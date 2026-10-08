-- functionsCtr.lua
-- written by Habna
-- rewritten by many


function ImportCtr( value )
    -- 1. Standard Controls (via ControlRegistry)
    local data = _G.ControlData[value]
    if data and data.initFunc then
        data.initFunc()

        -- Trigger onShow event/handler if present (for event registration etc)
        if data.onShow then
            data.onShow()
        end

        -- Ensure position is set if the control was just created
        if data.controls and data.controls["Ctr"] and data.location then
            data.controls["Ctr"]:SetPosition(data.location.x, data.location.y)
        end
        KeepIconControlInBar(value);
        return
    end

    -- 2. Currencies
    if data and data.kind == "currency" then
        if data.where == 1 then
            createCurrencyTable(value)
            local ctr = data.controls.Ctr
            if ctr then
                ctr:SetPosition(data.location.x, data.location.y)
            end
        end
        if data.where ~= 3 then
            if value == "DestinyPoints" then
                AddCallback(GetPlayerAttributes(), "DestinyPointsChanged", function(sender, args)
                    UpdateCurrencyDisplay("DestinyPoints")
                end)
            end
            UpdateCurrencyDisplay(value)
        elseif value == "DestinyPoints" then
            RemoveCallback(GetPlayerAttributes(), "DestinyPointsChanged")
        end
        
        KeepIconControlInBar(value);
    end


end

-- The item tracking list (ITL) is a list of { N = item name, L = game language, B, U, S, I = icons }.
-- Items are tracked by their name, which is only known in the game language the item was ticked in:
-- the game has no language-independent id for items. Items tracked in another language are kept
-- and count again when the game runs in that language. The icons draw items that are not in the bags.
-- One file for all game languages (since 1.53); older versions had one list per language.
local TRACKING_LIST_NAME = "TitanBarPlayerItemTrackingList"

-- The values of a saved list in their order (the keys are saved as text: "1", "2", ...)
local function SavedList(saved)
    local keys = {};
    for k in pairs(saved) do table.insert(keys, k) end
    table.sort(keys, function(a, b) return (tonumber(a) or 0) < (tonumber(b) or 0) end);
    local list = {};
    for _, k in ipairs(keys) do table.insert(list, saved[k]) end
    return list
end

local function IsTrackedItem(entry)
    return type(entry) == "table" and type(entry.N) == "string" and type(entry.L) == "string" and entry.I ~= nil
end

-- A list of an older version, { [name] = { Q, B, U, S, I } } for one game language
local function OldTrackingList(old, locale)
    local list = {};
    for _, entry in ipairs(SavedList(old)) do
        local name, icons;
        if type(entry) == "table" then name, icons = next(entry) end
        if type(name) == "string" and type(icons) == "table" and icons.I ~= nil then
            table.insert(list, { N = name, L = locale, B = icons.B, U = icons.U, S = icons.S, I = icons.I });
        end
    end
    return list
end

function LoadPlayerItemTrackingList()
    ITL = {};
    local loaded = Turbine.PluginData.Load(Turbine.DataScope.Character, TRACKING_LIST_NAME);
    if loaded then
        for _, entry in ipairs(SavedList(loaded)) do
            if IsTrackedItem(entry) then table.insert(ITL, entry) end
        end
        return
    end

    -- First start of a version with one list: take over the lists of all game languages
    for _, locale in ipairs(GameLocalesCurrentFirst()) do
        local ok, old = pcall(Turbine.PluginData.Load, Turbine.DataScope.Character, TRACKING_LIST_NAME .. locale:upper());
        if ok and type(old) == "table" then
            for _, entry in ipairs(OldTrackingList(old, locale)) do table.insert(ITL, entry) end
        end
    end
    SavePlayerItemTrackingList(ITL);
end

-- The tracked items of the current game language
function TrackedItemsOfLanguage()
    local list = {};
    for _, entry in ipairs(ITL) do
        if entry.L == GLocale then table.insert(list, entry) end
    end
    return list
end

function IsItemTracked(name)
    for _, entry in ipairs(ITL) do
        if entry.L == GLocale and entry.N == name then return true end
    end
    return false
end

function TrackItem(item)
    local itemInfo = item:GetItemInfo();
    TrackEntry({
        N = itemInfo:GetName(),
        L = GLocale,
        B = tostring(itemInfo:GetBackgroundImageID()),
        U = tostring(itemInfo:GetUnderlayImageID()),
        S = tostring(itemInfo:GetShadowImageID()),
        I = tostring(itemInfo:GetIconImageID()),
    });
end

-- Tracks an entry of the list again (an item that is not in the bags)
function TrackEntry(entry)
    table.insert(ITL, entry);
    SavePlayerItemTrackingList(ITL);
end

function UntrackItem(name)
    for i = #ITL, 1, -1 do
        if ITL[i].L == GLocale and ITL[i].N == name then table.remove(ITL, i) end
    end
    SavePlayerItemTrackingList(ITL);
end

function SavePlayerItemTrackingList(ITL)
    Turbine.PluginData.Save(Turbine.DataScope.Character, TRACKING_LIST_NAME, SaveableTable(ITL));
end

function LoadPlayerMoney()
    wallet = Turbine.PluginData.Load(
        Turbine.DataScope.Server, "TitanBarPlayerWallet");

    if wallet == nil then wallet = {}; end

    local PN = Player:GetName();

    if wallet[PN] == nil then wallet[PN] = {}; end
    if wallet[PN].Show == nil then wallet[PN].Show = true; end
    if wallet[PN].ShowToAll == nil then wallet[PN].ShowToAll = true; end
	_G.ControlData = _G.ControlData or {}
	_G.ControlData.Money = _G.ControlData.Money or {}
	_G.ControlData.Money.scm = wallet[PN].Show
	_G.ControlData.Money.scma = wallet[PN].ShowToAll


    --Convert wallet
    --Removed 2017-02-07 (after 2012-08-18)
    --Restored 2017-10-02 (was causing "Invalid Data Scope" bug)
    local tGold, tSilver, tCopper, bOk;
    for k,v in pairs(wallet) do
        if wallet[k].Gold ~= nil then
            bOk = true;
            tGold = tonumber(wallet[k].Gold);
            wallet[k].Gold = nil;
        end
        if wallet[k].Silver ~= nil then
            bOk = true;
            tSilver = tonumber(wallet[k].Silver);
            wallet[k].Silver = nil;
        end
        if wallet[k].Copper ~= nil then
            bOk = true;
            tCopper = tonumber(wallet[k].Copper);
            wallet[k].Copper = nil;
            if tCopper < 10 then
                tCopper = "0".. tCopper;
            end
        end

        if bOk then
            local strdata;
            if tGold == 0 then
                if tSilver == 0 then
                    strdata = tCopper;
                else
                    strdata = tSilver..tCopper;
                end
            else
                if tSilver == 0 then
                    strdata = tGold.."000"..tCopper;
                else
                    strdata = tGold..tSilver..tCopper;
                end
            end
            wallet[k].Money = tostring(strdata);
        end
    end

    --Statistics section
    local DDate = Turbine.Engine.GetDate();
    DOY = tostring(DDate.DayOfYear);
    walletStats = Turbine.PluginData.Load(
        Turbine.DataScope.Server, "TitanBarPlayerWalletStats");
    if walletStats == nil then walletStats = {};
    else
        for k,v in pairs(walletStats) do
            if k ~= DOY then
                walletStats[k] = nil;
            end
        end
    end --Delete old date entry
    if walletStats[DOY] == nil then walletStats[DOY] = {}; end
    if walletStats[DOY][PN] == nil then
        walletStats[DOY][PN] = {};
        walletStats[DOY][PN].TotEarned = "0";
        walletStats[DOY][PN].TotSpent = "0";
        walletStats[DOY][PN].SumTS = "0";
    end
    local playerAtt = GetPlayerAttributes();
    walletStats[DOY][PN].Start = tostring(playerAtt:GetMoney());
    walletStats[DOY][PN].Had = tostring(playerAtt:GetMoney());
    walletStats[DOY][PN].Earned = "0";
    walletStats[DOY][PN].Spent = "0";
    walletStats[DOY][PN].SumSS = "0";
    --

    Turbine.PluginData.Save(
        Turbine.DataScope.Server, "TitanBarPlayerWalletStats", walletStats);
end

-- **v Save player wallet infos v**
function SavePlayerMoney(save)
    if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play

    _G.ControlData.Money = _G.ControlData.Money or {}
    if _G.ControlData.Money.scm == nil then _G.ControlData.Money.scm = true end
    if _G.ControlData.Money.scma == nil then _G.ControlData.Money.scma = true end
    wallet[PN].Show = _G.ControlData.Money.scm
    wallet[PN].ShowToAll = _G.ControlData.Money.scma
    wallet[PN].Money = tostring(GetPlayerAttributes():GetMoney());

    -- Calculate Gold/Silver/Copper Total
    local goldTotal, silverTotal, copperTotal = 0, 0, 0;

    for k,v in pairs(wallet) do
        local gold, silver, copper = DecryptMoney(v.Money);
        if (k == PN and v.Show) or (k ~= PN and (v.ShowToAll or v.ShowToAll == nil)) then
            goldTotal = goldTotal + gold;
            silverTotal = silverTotal + silver;
            copperTotal = copperTotal + copper;
        end
    end

    silverTotal = silverTotal + math.floor(copperTotal / 100)
    copperTotal = copperTotal % 100

    goldTotal = goldTotal + math.floor(silverTotal / 1000)
    silverTotal = silverTotal % 1000

    GoldTot = goldTotal
    SilverTot = silverTotal
    CopperTot = copperTotal

    if save then
        Turbine.PluginData.Save(Turbine.DataScope.Server, "TitanBarPlayerWallet", wallet)
    end
end
-- **^

function LoadPlayerWallet()
    PlayerWallet = Player:GetWallet();
    PlayerWalletSize = PlayerWallet:GetSize();
    if PlayerWalletSize == 0 then return end
    -- ^^ Remove when Wallet info are available before plugin is loaded

    for i = 1, PlayerWalletSize do
        local CurItem = PlayerWallet:GetItem(i);
        local CurName = PlayerWallet:GetItem(i):GetName();

        PlayerCurrency[CurName] = CurItem;
        if PlayerCurrencyHandler[CurName] == nil then
            PlayerCurrencyHandler[CurName] = AddCallback(
                PlayerCurrency[CurName], "QuantityChanged",
                function(sender, args) UpdateCurrency(CurName); end
            );
        end
    end
end



function UpdateCurrency(currency_display)
    if _G.Debug then write("UpdateCurrency:" ..currency_display); end
    local currency_name = _G.CurrencyLangMap[currency_display]
    if _G.Debug and not currency_name then write("Currency not supported!"); end
    if currency_name and _G.ControlData[currency_name].show then
        UpdateCurrencyDisplay(currency_name)
    end
end

function SetCurrencyToZero(str)
    for _, currency in pairs(_G.currencies.list) do
        local data = _G.ControlData[currency.name]
        if str == L["M" .. currency.name] and data.show then
            if data.show then
                if data.where == 1 then
                    data.controls.Lbl:SetText("0");
                    data.controls.Lbl:SetSize(data.controls.Lbl:GetTextLength() * NM, CTRHeight );
                    AdjustIcon(currency.name);
                end
            end
        end
    end
end

function SetCurrencyFromZero(str, amount)
    for _, currency in pairs(_G.currencies.list) do
        local data = _G.ControlData[currency.name]
        if str == L["M" .. currency.name] and data.show then
            if data.show then
                if data.where == 1 then
                    data.controls.Lbl:SetText(amount);
                    data.controls.Lbl:SetSize(data.controls.Lbl:GetTextLength() * NM, CTRHeight );
                    AdjustIcon(currency.name);
                end
            end
        end
    end
end

function GetCurrency(localizedCurrencyName)
    CurQuantity = 0;

    for k,v in pairs(PlayerCurrency) do
        if k == localizedCurrencyName then
            CurQuantity = PlayerCurrency[localizedCurrencyName]:GetQuantity();
            break
        end
    end

    return CurQuantity
end

function GetLabel(message)
	local lblmgs = Turbine.UI.Label();
	lblmgs:SetText( message );
	lblmgs:SetPosition( 17, 40 );
	lblmgs:SetForeColor( Color["green"] );
	lblmgs:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	lblmgs:SetZOrder(2);
	return lblmgs;
end
