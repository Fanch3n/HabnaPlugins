-- functionsCtr.lua
-- written by Habna
-- rewritten by many


function ImportCtr( value )
    if value == "WI" then --Wallet infos
        import (AppCtrD.."Wallet");
        import (AppCtrD.."WalletToolTip");
        UpdateWallet();
        WI[ "Ctr" ]:SetPosition( _G.ControlData.WI.location.x, _G.ControlData.WI.location.y );
    elseif value == "MI" then --Money Infos
		local moneyWhere = (_G.ControlData.Money and _G.ControlData.Money.where) or Constants.Position.NONE
		if moneyWhere == Constants.Position.TITANBAR then
            import (AppCtrD.."MoneyInfos");
            import (AppCtrD.."MoneyInfosToolTip");
            MI[ "Ctr" ]:SetPosition( _G.ControlData.Money.location.x, _G.ControlData.Money.location.y );
        end
		if moneyWhere ~= Constants.Position.NONE then
            AddCallback(GetPlayerAttributes(), "MoneyChanged",
                function(sender, args) UpdateMoney(); end
                );
            AddCallback(sspack, "CountChanged", UpdateSharedStorageGold);
            -- ^^ Thx Heridian!
            UpdateMoney();
        else
            RemoveCallback(GetPlayerAttributes(), "MoneyChanged");
            RemoveCallback(sspack, "CountChanged", UpdateSharedStorageGold);
            -- ^^ Thx Heridian!
        end
    elseif value == "BI" then --Backpack Infos
        import (AppCtrD.."BagInfos");
        --import (AppCtrD.."BagInfosToolTip");
        AddCallback(backpack, "ItemAdded",
            function(sender, args) UpdateBackpackInfos(); end
            );
        AddCallback(backpack, "ItemRemoved",
            function(sender, args)
                ItemRemovedTimer:SetWantsUpdates( true );
            end
            ); --Workaround
        --AddCallback(backpack, "ItemRemoved",
        --    function(sender, args) UpdateBackpackInfos(); end
        --    ); --Add when workaround is not needed anymore
        UpdateBackpackInfos();
        BI[ "Ctr" ]:SetPosition( _G.ControlData.BI.location.x, _G.ControlData.BI.location.y );
    elseif value == "PI" then --Player Infos
        import (AppCtrD.."PlayerInfos");
        import (AppCtrD.."PlayerInfosToolTip");
        AddCallback(Player, "LevelChanged",
            function(sender, args)
                PI["Lvl"]:SetText( Player:GetLevel() );
                PI["Lvl"]:SetSize( PI["Lvl"]:GetTextLength() * NM+1, CTRHeight );
                PI["Name"]:SetPosition( PI["Lvl"]:GetLeft() + PI["Lvl"]:GetWidth() + 5, 0 );
            end);
        AddCallback(Player, "NameChanged",
            function(sender, args)
                PI["Name"]:SetText( Player:GetName() );
                PI["Name"]:SetSize( PI["Name"]:GetTextLength() * TM, CTRHeight );
                AjustIcon(" PI ");
            end);
        XPcb = AddCallback(Turbine.Chat, "Received",
            function(sender, args)
            if args.ChatType == Turbine.ChatType.Advancement then
                xpMess = args.Message;
                if xpMess ~= nil then
                    local xpPattern;
                    if GLocale == "en" then
                        xpPattern = "total of ([%d%p]*) XP";
                    elseif GLocale == "fr" then
                        xpPattern = "de ([%d%p]*) points d'exp\195\169rience";
                    elseif GLocale == "de" then
                        xpPattern = "\195\188ber ([%d%p]*) EP";
                    end
                    local tmpXP = string.match(xpMess,xpPattern);
                    if tmpXP ~= nil then
                        ExpPTS = tmpXP;
                        settings.PlayerInfos.XP = ExpPTS;
                        SaveSettings( false );
                    end
                end
            end
            end);
        UpdatePlayersInfos();
        PI[ "Ctr" ]:SetPosition( _G.ControlData.PI.location.x, _G.ControlData.PI.location.y );
    elseif value == "DI" then --Durability Infos
        import (AppCtrD.."DurabilityInfos");
        import (AppCtrD.."DurabilityInfosToolTip");
        UpdateDurabilityInfos();
        DI[ "Ctr" ]:SetPosition( _G.ControlData.DI.location.x, _G.ControlData.DI.location.y );
    elseif value == "EI" then --Equipment Infos
        import (AppCtrD.."EquipInfos");
        import (AppCtrD.."EquipInfosToolTip");
        UpdateEquipsInfos();
        EI[ "Ctr" ]:SetPosition( _G.ControlData.EI.location.x, _G.ControlData.EI.location.y );
    elseif value == "PL" then --Player Location
        import (AppCtrD.."PlayerLoc");
        --AddCallback(Player, "LocationChanged", UpdatePlayerLoc(); end);
        PLcb = AddCallback(Turbine.Chat, "Received",
            function(sender, args)
            if args.ChatType == Turbine.ChatType.Standard then
                plMess = args.Message;
                if plMess ~= nil then
                    if GLocale == "en" then
                        plPattern = "Entered the%s+(.-)%s*%-";
                    elseif GLocale == "fr" then
                        plPattern = "Canal%s+(.-)%s*%-";
                    elseif GLocale == "de" then
                        plPattern = "Chat%-Kanal%s+'(.-)%s*%-";
                    end

                    local tmpPL = string.match( plMess, plPattern );
                    if tmpPL ~= nil then
                        --write("'".. tmpPL .. "'"); -- debug purpose
                        pLLoc = tmpPL;
                        UpdatePlayerLoc( pLLoc );
                        settings.PlayerLoc.L = string.format( pLLoc );
                        SaveSettings( false );
                    end
                end
            end
        end);
        UpdatePlayerLoc( pLLoc );
        PL[ "Ctr" ]:SetPosition( _G.ControlData.PL.location.x, _G.ControlData.PL.location.y );
    elseif value == "TI" then --Track Items
        import (AppCtrD.."TrackItems");
        import (AppCtrD.."TrackItemsToolTip");
        UpdateTrackItems();
        TI[ "Ctr" ]:SetPosition( _G.ControlData.TI.location.x, _G.ControlData.TI.location.y );
    elseif value == "IF" then --Infamy
        -- Use Infamy/Renown ranks from Constants
        _G.InfamyRanks = Constants.INFAMY_RANKS;

        if PlayerAlign == 1 then
            --Free people rank icon 0 to 15
            InfIcon = resources.FreePeoples
        else
            --Monster play rank icon 0 to 15
            InfIcon = resources.Monster
        end
        import (AppCtrD.."Infamy");
        import (AppCtrD.."InfamyToolTip");
        ---InfamyCount = Turbine.
        --AddCallback(InfamyCount, "QuantityChanged",
        --    function(sender, args) UpdateInfamy(); end
        --    );
        IFcb = AddCallback(Turbine.Chat, "Received",
            function(sender, args)
            if args.ChatType == Turbine.ChatType.Advancement then
                ifMess = args.Message;
                if ifMess ~= nil then
                    if PlayerAlign == 1 then
                        if GLocale == "en" then
                            ifPattern = "earned ([%d%p]*) renown points";
                        elseif GLocale == "fr" then
                            ifPattern = "gagn\195\169 ([%d%p]*) points " ..
                                "renomm\195\169e";
                        elseif GLocale == "de" then
                            ifPattern = "habt ([%d%p]*) Ansehenspunkte";
                        end
                    else
                        if GLocale == "en" then
                            ifPattern = "earned ([%d%p]*) infamy points";
                        elseif GLocale == "fr" then
                            ifPattern = "gagn\195\169 ([%d%p]*) points " ..
                                "d'infamie";
                        elseif GLocale == "de" then
                            ifPattern = "habt ([%d%p]*) Verrufenheitspunkte";
                        end
                    end

                    local tmpIF = string.match(ifMess,ifPattern);
                    if tmpIF ~= nil then
                        InfamyPTS = InfamyPTS + tmpIF;

                        for i=0, 14 do
                            if tonumber(InfamyPTS) >= _G.InfamyRanks[i] and
                                tonumber(InfamyPTS) < _G.InfamyRanks[i+1] then
                                InfamyRank = i;
                                break
                                end
                        end
                        settings.Infamy.P = string.format("%.0f", InfamyPTS);
                        settings.Infamy.K = string.format("%.0f", InfamyRank);
                        SaveSettings( false );
                        UpdateInfamy();
                    end
                end
            end
            end);
        UpdateInfamy();
        IF[ "Ctr" ]:SetPosition( _G.ControlData.IF.location.x, _G.ControlData.IF.location.y );
    elseif value == "DN" then --Day & Night Time
        import (AppCtrD.."DayNight");
        UpdateDayNight();
        DN[ "Ctr" ]:SetPosition( _G.ControlData.DN.location.x, _G.ControlData.DN.location.y );
    elseif value == "LP" then --LOTRO points
		local lpWhere = (_G.ControlData.LP and _G.ControlData.LP.where) or Constants.Position.NONE
		if lpWhere == Constants.Position.TITANBAR then
            import (AppCtrD.."LOTROPoints");
            LP[ "Ctr" ]:SetPosition( _G.ControlData.LP.location.x, _G.ControlData.LP.location.y );
            UpdateLOTROPoints();
        end
		if lpWhere ~= Constants.Position.NONE then
            --PlayerLP = Player:GetLOTROPoints();
            --AddCallback(PlayerLP, "LOTROPointsChanged",
            --    function(sender, args) UpdateLOTROPoints(); end
            --);
            LPcb = AddCallback(Turbine.Chat, "Received",
                function(sender, args)
                if args.ChatType == Turbine.ChatType.Advancement then
                    local tpMess = args.Message;
                    if tpMess ~= nil then
                        local tpPattern;
                        if GLocale == "en" then
                            tpPattern = "earned ([%d%p]*) LOTRO Points";
                        elseif GLocale == "fr" then
                            tpPattern = "gagn\195\169 ([%d%p]*) points LOTRO";
                        elseif GLocale == "de" then
                            tpPattern = "habt ([%d%p]*) Punkte erhalten";
                        end
                        local tmpLP = string.match(tpMess,tpPattern);
                        if tmpLP ~= nil then
                            LPTS = tmpLP;
                            _G.LOTROPTS = _G.LOTROPTS + LPTS;
                            UpdateLOTROPoints()
                        end
                    end
                end
                end);
        else
            RemoveCallback(Turbine.Chat, "Received", LPcb);
        end
    elseif value == "GT" then --Game Time
        import (AppCtrD.."GameTime");
        --import (AppCtrD.."GameTimeToolTip");
        --PlayerTime = Turbine.Engine.GetDate();
        --AddCallback(PlayerTime, "MinuteChanged",
        --    function(sender, args) UpdateGameTime(); end
        --);
        if _G.ShowBT then UpdateGameTime("bt");
        elseif _G.ShowST then UpdateGameTime("st");
        else UpdateGameTime("gt") end
        if _G.ControlData.GT.location.x + GT[ "Ctr" ]:GetWidth() > screenWidth then
            _G.ControlData.GT.location.x = screenWidth - GT[ "Ctr" ]:GetWidth();
        end --Replace if out of screen
        GT[ "Ctr" ]:SetPosition( _G.ControlData.GT.location.x, _G.ControlData.GT.location.y );
    elseif value == "VT" then --Vault
        import (AppCtrD.."Vault");
        import (AppCtrD.."VaultToolTip");
        AddCallback(vaultpack, "CountChanged",
            function(sender, args) SavePlayerVault(); end
            );
        UpdateVault();
        VT[ "Ctr" ]:SetPosition( _G.ControlData.VT.location.x, _G.ControlData.VT.location.y );
    elseif value == "SS" then --Shared Storage
        import (AppCtrD.."SharedStorage");
        import (AppCtrD.."SharedStorageToolTip");
        AddCallback(sspack, "CountChanged",
            function(sender, args) SavePlayerSharedStorage(); end
            );
        UpdateSharedStorage();
        SS[ "Ctr" ]:SetPosition( _G.ControlData.SS.location.x, _G.ControlData.SS.location.y );
	elseif value == "RP" then --Reputation Points
        import (AppCtrD.."Reputation");
        import (AppCtrD.."ReputationToolTip");
        ReputationCallback = AddCallback(Turbine.Chat, "Received",
            function( sender, args )
                if (args.ChatType ~= Turbine.ChatType.Advancement) then return; end

                local rpMess = args.Message;
                if rpMess ~= nil then
                -- Check string, Reputation Name and Reputation Point pattern
                    local cstr, factionPattern, rppPattern, rpbPattern;
                    if GLocale == "en" then
                        factionPattern = "reputation with (.*) has (.*) by";
                        rppPattern = "has .* by ([%d%p]*)%.";
                    elseif GLocale == "fr" then
                        factionPattern = "de la faction (.*) a (.*) de";
                        rppPattern = "a .* de ([%d%p]*)%.";
                    elseif GLocale == "de" then
                        factionPattern = "Euer Ruf bei (.*) hat sich um .* (%a+)";
                        rppPattern = "hat sich um ([%d%p]*) .*";
                    end
                    -- check string if an accelerator was used
                    if GLocale == "de" then
                        cstr = string.match( rpMess, "Bonus" );
                    else cstr = string.match( rpMess, "bonus" ); end
                    -- Accelerator was used, end of string is different.
                    -- Ex. (700 from bonus). instead of just a dot after the
                    -- amount of points
                    if cstr ~= nil then
                        if GLocale == "en" then
                            rppPattern = "has increased by ([%d%p]*) %(";
                            rpbPattern = "%(([%d%p]*) from bonus";
                        elseif GLocale == "fr" then
                            rppPattern = "a augment\195\169 de ([%d%p]*) %(";
                            rpbPattern = "%(([%d%p]*) du bonus";
                        elseif GLocale == "de" then
                            factionPattern = "Euer Ruf bei der Gruppe \"(.*)\" wurde um"
                            rppPattern = "wurde um ([%d%p]*) erh\195\182ht";
                            rpbPattern = "%(([%d%p]*) durch Bonus";
                        end
                    end
                    local rpName,increaseOrDecrease = string.match( rpMess,factionPattern );

                    -- Reputation Name
                    if rpMess ~= nil and rpName ~= nil then
                        -- decrease remaining bonus acceleration
                        if rpbPattern ~= nil then
                            local rpBonus = string.match( rpMess, rpbPattern );
                            rpBonus = string.gsub( rpBonus, ",", "" );
                            local newValue = math.max(0, PlayerReputation[PN]["ReputationAcceleration"].Total - rpBonus)
                            PlayerReputation[PN]["ReputationAcceleration"].Total = string.format("%.0f", newValue);
                        end
                        local rpPTS = string.match( rpMess, rppPattern );
                        if (rpPTS) then
                            -- Replace "," in 1,400 to get 1400 or the "." in 1.400 to get 1400
                            rpPTS = string.gsub(rpPTS, "[%p]", "");
                            rpPTS = tonumber(rpPTS);
                        end
                        if (increaseOrDecrease == L[ "RPDECREASE"]) then
                            rpPTS = -rpPTS;
                        end
                        for _, faction in ipairs(_G.Factions.list) do
                            if L[faction.name] == rpName then
                                local current_points = PlayerReputation[PN][faction.name].Total
                                local newPointsTotal = current_points + rpPTS
                                local factionMaxReputation = tonumber(faction.ranks[#faction.ranks].requiredReputation) or 0
                                newPointsTotal = math.min(factionMaxReputation, newPointsTotal)
                                newPointsTotal = math.max(0, newPointsTotal)
                                PlayerReputation[PN][faction.name].Total = string.format("%.0f", newPointsTotal)
                            end
                        end
                        SavePlayerReputation();
                    end
                end
            end
        );
        UpdateReputation();
        RP[ "Ctr" ]:SetPosition( _G.ControlData.RP.location.x, _G.ControlData.RP.location.y );
    else
        if _G.CurrencyData[value].Where == 1 then
            createCurrencyTable(value)
            _G.CurrencyData[value].Ctr:SetPosition(_G.CurrencyData[value].LocX, _G.CurrencyData[value].LocY)
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
    end

    KeepIconControlInBar(value);

end


function GetEquipmentInfos()
    LoadEquipmentTable();
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

    for i, v in ipairs( EquipSlots ) do
        local PlayerEquipItem = PlayerEquipment:GetItem( v );
        itemEquip[i] = Turbine.UI.Lotro.ItemControl( PlayerEquipItem );

        -- Item Name, WearState, Quality & Durability
        if PlayerEquipItem ~= nil then
            itemEquip[i].Item = true;
            itemEquip[i].Name = PlayerEquipItem:GetName();
            itemEquip[i].Slot = Slots[i];--Debug

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
                write("<rgb=#FF0000>"..i.."</rgb>: <rgb=#6969FF>"..Slots[i]..
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

function LoadPlayerVault()
    PlayerVault = Turbine.PluginData.Load(
        Turbine.DataScope.Server, "TitanBarVault");
    if PlayerVault == nil then PlayerVault = {}; end
    if PlayerVault[PN] == nil then PlayerVault[PN] = {}; end
end

function SavePlayerVault()
    if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play

    local vaultpackSize = vaultpack:GetCapacity();
    local vaultpackCount = vaultpack:GetCount();

    PlayerVault[PN] = {};

    for ii = 1, vaultpackCount do
        local ind = tostring(ii);
        PlayerVault[PN][ind] = vaultpack:GetItem(ii);
        local iteminfo = PlayerVault[PN][ind]:GetItemInfo();

        PlayerVault[PN][ind].Q = tostring(iteminfo:GetQualityImageID());
        PlayerVault[PN][ind].B = tostring(iteminfo:GetBackgroundImageID());
        PlayerVault[PN][ind].U = tostring(iteminfo:GetUnderlayImageID());
        PlayerVault[PN][ind].S = tostring(iteminfo:GetShadowImageID());
        PlayerVault[PN][ind].I = tostring(iteminfo:GetIconImageID());
        PlayerVault[PN][ind].T = tostring(iteminfo:GetName());
        local tq = tostring(PlayerVault[PN][ind]:GetQuantity());
        if tq == "1" then tq = ""; end
        PlayerVault[PN][ind].N = tq;
        PlayerVault[PN][ind].Z = tostring(vaultpackSize);
    end

    Turbine.PluginData.Save(
        Turbine.DataScope.Server, "TitanBarVault", PlayerVault);
end

function LoadPlayerSharedStorage()
    PlayerSharedStorage = Turbine.PluginData.Load(Turbine.DataScope.Server,
        "TitanBarSharedStorage");
    if PlayerSharedStorage == nil then PlayerSharedStorage = {}; end
end

function SavePlayerSharedStorage()
    if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play

    sspackSize = sspack:GetCapacity();
    sspackCount = sspack:GetCount();

    PlayerSharedStorage = {};

    for ii = 1, sspackCount do
        local ind = tostring(ii);
        PlayerSharedStorage[ind] = sspack:GetItem( ii );
        local iteminfo = PlayerSharedStorage[ind]:GetItemInfo();

        PlayerSharedStorage[ind].Q = tostring(iteminfo:GetQualityImageID());
        PlayerSharedStorage[ind].B = tostring(iteminfo:GetBackgroundImageID());
        PlayerSharedStorage[ind].U = tostring(iteminfo:GetUnderlayImageID());
        PlayerSharedStorage[ind].S = tostring(iteminfo:GetShadowImageID());
        PlayerSharedStorage[ind].I = tostring(iteminfo:GetIconImageID());
        PlayerSharedStorage[ind].T = tostring(iteminfo:GetName());
        local tq = tostring(PlayerSharedStorage[ind]:GetQuantity());
        if tq == "1" then tq = ""; end
        PlayerSharedStorage[ind].N = tq;
        PlayerSharedStorage[ind].Z = tostring(sspackSize);
    end

    Turbine.PluginData.Save(
        Turbine.DataScope.Server, "TitanBarSharedStorage", PlayerSharedStorage
        );
end

-- vvv Added by Heridan vvv
function UpdateSharedStorageGold( sender, args )
    local storagesize = sspack:GetCount()
    local sharedmoney = 0
    local i
    for i = 1, storagesize do
        local item = sspack:GetItem(i)
        if item ~= nil then
            local name = item:GetName()
            local count = item:GetQuantity()
            if name == L[ "MGB" ] then -- Gold Bag
                sharedmoney = sharedmoney + ( count * 1000000 )
            elseif name == L[ "MSB" ] then -- Silver Bag
                sharedmoney = sharedmoney + ( count * 100000 )
            elseif name == L[ "MCB" ] then -- Copper Bag
                sharedmoney = sharedmoney + ( count * 10000 )
            end
        end
    end
    wallet[ L[ "MStorage" ] ] =  {
        [ "Show" ] = true,
        [ "ShowToAll" ] = true,
        [ "Money" ] = tostring( sharedmoney )
    }
    UpdateMoney()
end
-- ^^^ Added by Heridan ^^^

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

function UpdateReputationSaveFileFormat(reputation)
    if not reputation["file_version"] then
        local now = Turbine.Engine.GetDate()
        local nowString = string.format("%04d%02d%02d_%02d%02d%02d",
            now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second)
        local filename = string.format("TitanBarRep_v0bak_%s", nowString)
        Turbine.PluginData.Save(Turbine.DataScope.Server, filename, reputation)

        local repOrder = {
            -- Normal faction advancement + Forochel and Minas Tirith
            "RPMB", "RPTH", "RPTMS", "RPDOC", "RPTYW", "RPRE", "RPER", "RPDOTA", "RPTEl", "RPCN", "RPTWA",
            "RPLF", "RPWB", "RPLOTA", "RPTEg", "RPIGG", "RPIGM", "RPAME", "RPTGC", "RPG", "RPM",
            "RPTRS", "RPHLG", "RPMD", "RPTR", "RPMEV", "RPMN", "RPMS", "RPMW",
            "RPPW", "RPSW", "RPTEo", "RPTHe", "RPTEFF", "RPMRV", "RPMDE", "RPML",
            "RPP", "RPRI", "RPRR", "RPDMT", "RPDA",
            -- Dol Amroth Buildings (position 37< <46)
            "RPDAA", "RPDAB", "RPDAD", "RPDAGH", "RPDAL", "RPDAW", "RPDAM",
            "RPDAS",
            -- Crafting guilds (position 45< <53)
            "RPJG", "RPCG", "RPSG", "RPTG", "RPWoG", "RPWeG", "RPMG",
            -- Host of the West
            "RPHOTW", "RPHOTWA", "RPHOTWW", "RPHOTWP",
            -- Plateau of Gorgoroth
            "RPCOG", "RPEOFBs", "RPEOFBn", "RPRSC",
            -- Strongholds of the North
            "RPDOE", "RPEOF", "RPMOD", "RPGME",
            -- Vales of Anduin
            "RPWF",
            -- Minas Morgul
            "RPTGA", "RPTWC", "RPRMI",
            -- Wells of Langflood
            "RPPOW",
            -- Elderslade
            "RPMOG", "RPGA",
            --Azanulbizar
            "RPHOT", "RPKU",
            --Gundabad
            "RPROFMH",
            -- Special Event
            "RPCCLE", "RPTAA", "RPTIL",
            -- Reputation Accelerator
            "RPACC",
        }
        local baseReputation = {
            20000, 20000, 20000, 20000, 0,     20000, 20000, 1000,  20000, 20000, 20000,
            10000, 20000, 10000, 20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000,
            20000, 0,     0,     10000,
            20000, 20000, 20000, 20000,
            20000,
            30000, 0,     2000,
            20000,
            20000, 20000,
            20000, 10000,
            20000,
            20000, 0,     0,
            0
        }
        local reputationSteps = {
          ["default"] = {
            [0] = 10000, [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 60000, [7] = 90000, [8] = 200000, [9] = 1
          },
          ["RPTGA"] = {
            [1] = 10000, [2] = 20000, [3] = 20000, [4] = 1
          },
          ["RPTWC"] = {
            [1] = 10000, [2] = 15000, [3] = 20000, [4] = 20000, [5] = 20000, [6] = 20000,
            [7] = 30000, [8] = 1
          },
          ["RPRMI"] = {
            [1] = 4000, [2] = 6000, [3] = 8000, [4] = 10000, [5] = 12000,
            [6] = 14000, [7] = 16000, [8] = 18000, [9] = 20000, [10] = 1
          },
          ["RPGA"] = {
            [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000, [6] = 1
          }
        }
        for playerName, playerRep in pairs(reputation) do
            for i = 1, #repOrder do
                local factionAbbreviation = repOrder[i]
                if playerRep[factionAbbreviation] == nil then
                    playerRep[factionAbbreviation] = {};
                end
                if playerRep[factionAbbreviation].P == nil then
                    playerRep[factionAbbreviation].P = "0";
                end --Points
                if playerRep[factionAbbreviation].V == nil then
                    playerRep[factionAbbreviation].V = false;
                end --Show faction in tooltip
                if playerRep[factionAbbreviation].R == nil then
                    playerRep[factionAbbreviation].R = "1";
                end --rank

                -- add total (cumulative) points for reputation
                local reputationRank = playerRep[factionAbbreviation].R
                local stepsType = "default"
                if factionAbbreviation == "RPTGA" or factionAbbreviation == "RPTWC" or
                factionAbbreviation == "RPRMI" or factionAbbreviation == "RPGA" then
                    stepsType = factionAbbreviation;
                end
                local factionReputationSteps = reputationSteps[stepsType]
                local totalReputation = playerRep[factionAbbreviation].P
                totalReputation = totalReputation + baseReputation[i]
                for j = 1, math.min(#factionReputationSteps, reputationRank) - 1 do
                    totalReputation = totalReputation + factionReputationSteps[j]
                end
                playerRep[factionAbbreviation].Total = tostring(totalReputation)
            end
            for _, faction in ipairs(_G.Factions.list) do
                playerRep = reputation[playerName]
                playerRep[faction.name] = playerRep[faction.name] or {}
                local total = "0"
                local visible = false
                if faction.legacyTitanbarName and playerRep[faction.legacyTitanbarName] then
                    total = playerRep[faction.name].Total or playerRep[faction.legacyTitanbarName].Total
                    visible = playerRep[faction.name].V or playerRep[faction.legacyTitanbarName].V
                    playerRep[faction.legacyTitanbarName] = nil
                else
                    total = playerRep[faction.name].Total
                    visible = playerRep[faction.name].V
                end
                playerRep[faction.name].Total = total or "0"
                playerRep[faction.name].V = visible or false
            end
        end
    reputation["file_version"] = "2"
    end
end

function LoadPlayerReputation()
    PlayerReputation = Turbine.PluginData.Load(Turbine.DataScope.Server, "TitanBarReputation")
    if PlayerReputation == nil then PlayerReputation = {}; end
    UpdateReputationSaveFileFormat(PlayerReputation)
    if PlayerReputation[PN] == nil then PlayerReputation[PN] = {}; end

    for _, faction in ipairs(_G.Factions.list) do
        PlayerReputation[PN][faction.name] = PlayerReputation[PN][faction.name] or {}
        PlayerReputation[PN][faction.name].Total = PlayerReputation[PN][faction.name].Total or "0"
        PlayerReputation[PN][faction.name].V = PlayerReputation[PN][faction.name].V or false
    end
    SavePlayerReputation();
end

function SavePlayerReputation()
    if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play

    Turbine.PluginData.Save(
        Turbine.DataScope.Server, "TitanBarReputation", PlayerReputation);
end

function LoadPlayerLOTROPoints()
    PlayerLOTROPoints = Turbine.PluginData.Load(Turbine.DataScope.Account, "TitanBarLOTROPoints") or {}
    PlayerLOTROPoints["PTS"] = PlayerLOTROPoints.PTS or "0"
    _G.LOTROPTS = PlayerLOTROPoints.PTS;
    SavePlayerLOTROPoints()
end

function SavePlayerLOTROPoints()
    PlayerLOTROPoints["PTS"] = string.format("%.0f", _G.LOTROPTS);
    Turbine.PluginData.Save(Turbine.DataScope.Account, "TitanBarLOTROPoints", PlayerLOTROPoints);
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
                    AjustIcon(currency.name);
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
                    AjustIcon(currency.name);
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
