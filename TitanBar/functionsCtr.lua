-- functionsCtr.lua
-- written by Habna
-- rewritten by many


function ImportCtr( value )
    -- Resolve legacy aliases
    -- MI was historically mapped to 'Money' internally after import
    if value == "MI" then value = "Money" end

    -- Lazy Loading Map: ID -> Filename (relative to AppCtrD)
    local controlFiles = {
        ["WI"]    = "Wallet",
        ["Money"] = "MoneyInfos",
        ["BI"]    = "BagInfos",
        ["PI"]    = "PlayerInfos",
        ["DI"]    = "DurabilityInfos",
        ["EI"]    = "EquipInfos",
        ["PL"]    = "PlayerLoc",
        ["TI"]    = "TrackItems",
        ["IF"]    = "Infamy",
        ["DN"]    = "DayNight",
        ["LP"]    = "LOTROPoints",
        ["GT"]    = "GameTime",
        ["VT"]    = "Vault",
        ["SS"]    = "SharedStorage",
        ["RP"]    = "Reputation"
    }

    -- If control is not initialized, try to import it first
    if not (_G.ControlData[value] and _G.ControlData[value].initFunc) then
        local fileName = controlFiles[value]
        if fileName then
            import(AppCtrD .. fileName)
        end
    end

    -- 1. Standard Controls (via ControlRegistry)
    local data = _G.ControlData[value]
    if data and data.initFunc then
        data.initFunc()
        -- Ensure position is set if the control was just created
        if data.controls and data.controls["Ctr"] and data.location then
            data.controls["Ctr"]:SetPosition(data.location.x, data.location.y)
        end
        KeepIconControlInBar(value);
        return
    end

    -- 2. Currencies (Legacy system)
    if _G.CurrencyData and _G.CurrencyData[value] then
        if _G.CurrencyData[value].Where == 1 then
            createCurrencyTable(value)
            local ctr = _G.CurrencyData[value].Ctr
            if ctr then
                ctr:SetPosition(_G.CurrencyData[value].LocX, _G.CurrencyData[value].LocY)
            end
        end
        if _G.CurrencyData[value].Where ~= 3 then
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


function GetEquipmentInfos()
    PlayerEquipment = Player:GetEquipment();
    if PlayerEquipment == nil then
        write("<rgb=#FF3333>No equipment, returning.</rgb>");
        return
    end
    --Remove when Player Equipment info are available before plugin is loaded

    itemEquip = {};
    itemScore, numItems = 0, 0;
    Wq = 4; -- weight Quality
    Wd = 1; -- weight Durability

    for i, v in ipairs( Constants.EquipmentSlots ) do
        local PlayerEquipItem = PlayerEquipment:GetItem( v );
        itemEquip[i] = Turbine.UI.Lotro.ItemControl( PlayerEquipItem );

        -- Item Name, WearState, Quality & Durability
        if PlayerEquipItem ~= nil then
            itemEquip[i].Item = true;
            itemEquip[i].Name = PlayerEquipItem:GetName();
            itemEquip[i].Slot = Constants.EquipmentSlotNames[i];--Debug

            local Quality = 10*((6-PlayerEquipItem:GetQuality())%6);

            local Durability = PlayerEquipItem:GetDurability();
            if Durability ~= 0 then
                Durability = 10*((Durability%7)+1);
            end

            itemEquip[i].Score =
                round((Wq*Quality*7 + Wd*Durability*5)/(3.5*(Wq + Wd)));

            itemEquip[i].WearState = PlayerEquipItem:GetWearState();
            if itemEquip[i].WearState == 0 then
                itemEquip[i].WearStatePts = 0; -- undefined
            elseif itemEquip[i].WearState == 3 then
                itemEquip[i].WearStatePts = 0; -- Broken / cass�
            elseif itemEquip[i].WearState == 1 then
                itemEquip[i].WearStatePts = 20; -- Damaged / endommag�
            elseif itemEquip[i].WearState == 4 then
                itemEquip[i].WearStatePts = 99; -- Worn / us�
            elseif itemEquip[i].WearState == 2 then
                itemEquip[i].WearStatePts = 100;
            end -- Pristine / parfait
            if itemEquip[i].WearState ~= 0 then
                -- undefined items shouldn't be counted
                numItems = numItems + 1;
            end

            itemEquip[i].BImgID = PlayerEquipItem:GetBackgroundImageID();
            itemEquip[i].QImgID = PlayerEquipItem:GetQualityImageID();
            itemEquip[i].UImgID = PlayerEquipItem:GetUnderlayImageID();
            itemEquip[i].SImgID = PlayerEquipItem:GetShadowImageID();
            itemEquip[i].IImgID = PlayerEquipItem:GetIconImageID();

            itemEquip[i].wsHandler = AddCallback(
                PlayerEquipItem, "WearStateChanged",
                function(sender, args) ChangeWearState(i); end
                );

            if _G.Debug then
                write("<rgb=#00FF00>"..numItems.."</rgb> / <rgb=#FF0000>"..i..
                    "</rgb>: <rgb=#6969FF>"..itemEquip[i].Slot..
                    ":</rgb> \"<rgb=#CECECE>"..itemEquip[i].Name..
                    "</rgb>\" is of "..Quality.." quality and "..Durability..
                    " durability with a wear state of "
                    ..itemEquip[i].WearState.." ("..itemEquip[i].WearStatePts..
                    "%) for an overall score of: "..itemEquip[i].Score );
                    --Summary debug line for all stuff in here
            end
        else
            itemEquip[i].Item = false;
            itemEquip[i].Name = "zEmpty";
            itemEquip[i].Score = 0;
            itemEquip[i].WearState = 0;
            itemEquip[i].WearStatePts = 0;

            if _G.Debug then
                write("<rgb=#FF0000>"..i.."</rgb>: <rgb=#6969FF>"..Constants.EquipmentSlotNames[i]..
                    ":</rgb> <rgb=#FF3333>NO ITEM</rgb>");
            end
        end
    end
end

function LoadPlayerItemTrackingList()
    local locale = "TitanBarPlayerItemTrackingList" .. GLocale:upper();
    ITL = Turbine.PluginData.Load(Turbine.DataScope.Character, locale);
    if ITL == nil then ITL = {}; end
end

function SavePlayerItemTrackingList(ITL)
    local newt = {};
    for k, v in pairs(ITL) do newt[tostring(k)] = v; end
    ITL = newt;
    local locale = "TitanBarPlayerItemTrackingList" .. GLocale:upper();
    Turbine.PluginData.Save(Turbine.DataScope.Character, locale, ITL);
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





function LoadPlayerBags()
    PlayerBags = Turbine.PluginData.Load(
        Turbine.DataScope.Server, "TitanBarBags");
    if PlayerBags == nil then PlayerBags = {}; end
    if PlayerBags[PN] == nil then PlayerBags[PN] = {}; end
end

function SavePlayerBags()
    if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play

    backpackSize = backpack:GetSize();

    PlayerBags[PN] = {};
    ii=1;
    for i = 1, backpackSize do

        local items = backpack:GetItem( i );

        if items ~= nil then
            local ind = tostring(ii);
            PlayerBags[PN][ind] = items;
            local iteminfo = PlayerBags[PN][ind]:GetItemInfo();

            --local sc = Turbine.UI.Lotro.Shortcut( items );
            --PlayerBags[PN][ind].C = sc:GetData();

            PlayerBags[PN][ind].Q = tostring(iteminfo:GetQualityImageID());
            PlayerBags[PN][ind].B = tostring(iteminfo:GetBackgroundImageID());
            PlayerBags[PN][ind].U = tostring(iteminfo:GetUnderlayImageID());
            PlayerBags[PN][ind].S = tostring(iteminfo:GetShadowImageID());
            PlayerBags[PN][ind].I = tostring(iteminfo:GetIconImageID());
            PlayerBags[PN][ind].T = tostring(iteminfo:GetName());
            local tq = tostring(PlayerBags[PN][ind]:GetQuantity());
            if tq == "1" then tq = ""; end
            PlayerBags[PN][ind].N = tq;
            PlayerBags[PN][ind].Z = tostring(backpackSize);

            ii = ii +1;
        end
    end

    Turbine.PluginData.Save(
        Turbine.DataScope.Server, "TitanBarBags", PlayerBags);
    --[[
    Turbine.PluginData.Save(Turbine.DataScope.Server, "TitanBarSharedStorage",
        PlayerBags[PN]); --Debug purpose since i dont have a shared storage
    --]]
end





function UpdateCurrency(currency_display)
    if _G.Debug then write("UpdateCurrency:" ..currency_display); end
    local currency_name = _G.CurrencyLangMap[currency_display]
    if _G.Debug and not currency_name then write("Currency not supported!"); end
    if currency_name and _G.CurrencyData[currency_name].IsVisible then
        UpdateCurrencyDisplay(currency_name)
    end
end

function SetCurrencyToZero(str)
    for _, currency in pairs(_G.currencies.list) do
        if str == L["M" .. currency.name] and _G.CurrencyData[currency.name].IsVisible then
            if _G.CurrencyData[currency.name].IsVisible then
                if _G.CurrencyData[currency.name].Where == 1 then
                    _G.CurrencyData[currency.name].Lbl:SetText("0");
                    _G.CurrencyData[currency.name].Lbl:SetSize(_G.CurrencyData[currency.name].Lbl:GetTextLength() * NM, CTRHeight );
                    AdjustIcon(currency.name);
                end
            end
        end
    end
end

function SetCurrencyFromZero(str, amount)
    for _, currency in pairs(_G.currencies.list) do
        if str == L["M" .. currency.name] and _G.CurrencyData[currency.name].IsVisible then
            if _G.CurrencyData[currency.name].IsVisible then
                if _G.CurrencyData[currency.name].Where == 1 then
                    _G.CurrencyData[currency.name].Lbl:SetText(amount);
                    _G.CurrencyData[currency.name].Lbl:SetSize(_G.CurrencyData[currency.name].Lbl:GetTextLength() * NM, CTRHeight );
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
