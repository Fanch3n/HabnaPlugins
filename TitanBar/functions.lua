-- functions.lua
-- Written By Habna
-- rewritten by many

import(AppDirD .. "UIHelpers")

function AddCallback(object, event, callback)
	if object[event] == nil then
		object[event] = callback;
	else
		if type(object[event]) == "table" then
			table.insert(object[event], callback);
		else
			object[event] = { object[event], callback };
		end
	end
	return callback;
end

function RemoveCallback(object, event, callback)
	if object[event] == callback then
		object[event] = nil;
	elseif type(object[event]) == "table" then
		for i = 1, #object[event] do
			if object[event][i] == callback then
				table.remove(object[event], i);
				break;
			end
		end
	end
end

-- Workaround because 'math.round' not working for some user, weird!
function round(num)
    return math.floor(num + 0.5)
end

function ApplySkin() --Tooltip skin
	local ToolTipWin = _G.ToolTipWin
	local Box = resources.Box

	-- Create and position tooltip corners and edges
	local function createTooltipPart(name, x, y, width, height, background)
		local part = CreateControl(Turbine.UI.Control, ToolTipWin, x, y, width, height)
		part:SetBackground(background)
	end

	createTooltipPart("topLeftCorner", 0, 0, 36, 36, Box.TopLeft)
	createTooltipPart("TopBar", 36, 0, ToolTipWin:GetWidth() - 36, 37, Box.Top)
	createTooltipPart("topRightCorner", ToolTipWin:GetWidth() - 36, 0, 36, 36, Box.TopRight)
	createTooltipPart("midLeft", 0, 36, 36, ToolTipWin:GetHeight() - 36, Box.MidLeft)
	createTooltipPart("MidMid", 36, 36, ToolTipWin:GetWidth() - 36, ToolTipWin:GetHeight() - 36, Box.Middle)
	createTooltipPart("midRight", ToolTipWin:GetWidth() - 36, 36, 36, ToolTipWin:GetHeight() - 36, Box.MidRight)
	createTooltipPart("botLeftCorner", 0, ToolTipWin:GetHeight() - 36, 36, 36, Box.BottomLeft)
	createTooltipPart("BotBar", 36, ToolTipWin:GetHeight() - 36, ToolTipWin:GetWidth() - 36, 36, Box.Bottom)
	createTooltipPart("botRightCorner", ToolTipWin:GetWidth() - 36, ToolTipWin:GetHeight() - 36, 36, 36, Box.BottomRight)
end

--**v Create a ToolTip Window v**
function createToolTipWin( xOffset, yOffset, xSize, ySize, side, header, text1,
        text2, text3 )
	local txt = {text1, text2, text3};
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetSize( xSize, ySize );
	--_G.ToolTipWin:SetMouseVisible( false );
	_G.ToolTipWin:SetZOrder( Constants.ZORDER_TOOLTIP );
	_G.ToolTipWin.xOffset = xOffset;
	_G.ToolTipWin.yOffset = yOffset;
	--_G.ToolTipWin:SetBackColor( Color["black"] ); --Debug purpose

	ApplySkin();

	--**v Text in Header v**
	local lblheader = CreateControl(Turbine.UI.Label, _G.ToolTipWin, 40, 7, xSize, ySize);
	lblheader:SetForeColor( Color["green"] );
	lblheader:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	lblheader:SetText( header );
	--**^
	
	local YPos = 25;
	
	--**v Text v**
	for i = 1, #txt do
		local lbltext = CreateControl(Turbine.UI.Label, _G.ToolTipWin, 40, YPos, xSize, 15);
		lbltext:SetForeColor( Color["white"] );
		lbltext:SetFont(Turbine.UI.Lotro.Font.Verdana14);
		lbltext:SetText( txt[i] );
		YPos = YPos + 15;
	end
	--**^

	return _G.ToolTipWin;
end

-- Legend
-- ( offsetX, offsetY, width, height, bubble side, header text, text1, text2, text3, text4 )
function ShowToolTipWin(ToShow)
	local w = 350
	local bblTo, x, y= "left", -5, -15
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	local h = 80
	local TTW = nil

	local headerKeys = {
		BI = "MBI",
		GT = "GTh",
		VT = "MVault",
		SS = "MStorage",
		DN = "MDayNight",
		LP = "LotroPointsh",
	}

	-- TODO if DI (DurIcon) is replaced this needs to change
	if TBLocale == "fr" then w = 315;
	elseif TBLocale == "de" then
		if ToShow == "DI" then w = 225; 
		else w = 305; end
	end

	if w + mouseX > screenWidth then
		bblTo = "right"
		x = w - 10
	end

	if not TBTop then
		y = h
	end

	local headerKey = headerKeys[ToShow]
	if headerKey then
		TTW = createToolTipWin(x, y, w, h, bblTo, L[headerKey], L["EIt1"], L["EIt2"], L["EIt3"])
	elseif ToShow == "DP" or ToShow == "PL" or _G.currencies.byName[ToShow] then
		h = 65;
		TTW = createToolTipWin(x, y, w, h, bblTo, L[ToShow .. "h"], L["EIt2"], L["EIt3"])
	else
		write(ToShow .. " not recognized for Tooltip creation, add in functions.lua")
		return
	end

	_G.ToolTipWin:SetPosition(
		mouseX - _G.ToolTipWin.xOffset,
		mouseY - _G.ToolTipWin.yOffset
	)
	_G.ToolTipWin:SetVisible(true);
end
--**^
--**v Update Wallet on TitanBar v**
function UpdateWallet()
	AjustIcon( "WI" );
end
--**^
--**v Update money on TitanBar v**
function UpdateMoney()
	local where = (_G.ControlData and _G.ControlData.Money and _G.ControlData.Money.where) or Constants.Position.NONE
	if where == Constants.Position.TITANBAR then
		local moneyData = (_G.ControlData and _G.ControlData.Money) or {}
		local showTotal = moneyData.stm == true
		local money = GetPlayerAttributes():GetMoney();
		local gold, silver, copper = DecryptMoney(money);
	
		MI[ "GLbl" ]:SetText( string.format( "%.0f", gold ) );
		MI[ "SLbl" ]:SetText( string.format( "%.0f", silver ) );
		MI[ "CLbl" ]:SetText( string.format( "%.0f", copper ) );

		SavePlayerMoney( false );

		MI[ "GLbl" ]:SetSize( MI[ "GLbl" ]:GetTextLength() * NM, CTRHeight ); 
            --Auto size with text length
		MI[ "SLbl" ]:SetSize( 4 * NM, CTRHeight ); --Auto size with text length
		MI[ "CLbl" ]:SetSize( 3 * NM, CTRHeight ); --Auto size with text length

		MI[ "GLblT" ]:SetVisible( showTotal );
		MI[ "GLbl" ]:SetVisible( not showTotal );

		MI[ "SLblT" ]:SetVisible( showTotal );
		MI[ "SLbl" ]:SetVisible( not showTotal );

		MI[ "CLblT" ]:SetVisible( showTotal );
		MI[ "CLbl" ]:SetVisible( not showTotal );
	
		if showTotal then --Add Total Money on TitanBar Money control.
			local strData = L[ "MIWTotal" ] .. ": ";
			local strData1 = string.format( "%.0f", GoldTot );
			local strData2 = L[ "You" ] .. MI[ "GLbl" ]:GetText();
			local TextLen = string.len( strData ) * TM + string.len( strData1 ) * NM;
			if TBFontT == "TrajanPro25" then TextLen = TextLen + 7; end
			MI[ "GLblT" ]:SetText(strData .. strData1 .. "\n" .. strData2 .. " ");
			MI[ "GLblT" ]:SetSize( TextLen, CTRHeight );

			strData1 = string.format( "%.0f", SilverTot );
			strData2 = MI[ "SLbl" ]:GetText();
			TextLen = 4 * NM + 6;
			MI[ "SLblT" ]:SetText( strData1 .. "\n" .. strData2 .. " " );
			MI[ "SLblT" ]:SetSize( TextLen, CTRHeight );

			strData1 = string.format( "%.0f", CopperTot );
			strData2 = MI[ "CLbl" ]:GetText();
			TextLen = 3 * NM + 6;
			MI[ "CLblT" ]:SetText( strData1 .. "\n" .. strData2 .. " " );
			MI[ "CLblT" ]:SetSize( TextLen, CTRHeight );
		end

		--Statistics section
		local PN = Player:GetName();
		local bIncome = true;
		bSumSSS, bSumSTS = true, true;
		local hadmoney = walletStats[DOY][PN].Had;

		local diff = money - hadmoney;
		if diff < 0 then diff = math.abs(diff); bIncome = false; end

		if bIncome then 
			walletStats[DOY][PN].Earned = 
                tostring(walletStats[DOY][PN].Earned + diff);
			walletStats[DOY][PN].TotEarned = 
                tostring(walletStats[DOY][PN].TotEarned + diff);
		else
			walletStats[DOY][PN].Spent = 
                tostring(walletStats[DOY][PN].Spent + diff);
			walletStats[DOY][PN].TotSpent = 
                tostring(walletStats[DOY][PN].TotSpent + diff);
		end

		walletStats[DOY][PN].Had = tostring(money);

		--Sum of session statistics
		local SSS = walletStats[DOY][PN].Earned - walletStats[DOY][PN].Spent;
		if SSS < 0 then SSS = math.abs(SSS); bSumSSS = false; end
		walletStats[DOY][PN].SumSS = tostring(SSS);

		-- Sum of today satistics
		--Calculate all character earned & spent
		totem, totsm = 0,0;
		for k,v in pairs(walletStats[DOY]) do
			totem = totem + v.TotEarned;
			totsm = totsm + v.TotSpent;
		end
		
		local STS = totem - totsm;
		if STS < 0 then STS = math.abs(STS); bSumSTS = false; end
		walletStats[DOY][PN].SumTS = tostring(STS);

		Turbine.PluginData.Save( 
            Turbine.DataScope.Server, "TitanBarPlayerWalletStats", walletStats);
	
		AjustIcon( "MI" );
	end
end
--**^
--**v Update LOTRO points on TitanBar v**
function UpdateLOTROPoints()
	local where = (_G.ControlData and _G.ControlData.LP and _G.ControlData.LP.where) or Constants.Position.NONE
	if where == Constants.Position.TITANBAR then
		LP["Lbl"]:SetText(_G.LOTROPTS)
		LP["Lbl"]:SetSize(LP["Lbl"]:GetTextLength() * NM, CTRHeight)
		AjustIcon("LP")
	end
	SavePlayerLOTROPoints()
end
--**^
-- AU3 MARKER 2 - DO NOT REMOVE
--**v Update currency on TitanBar v**
function UpdateCurrencyDisplay(currencyName)
	if _G.CurrencyData[currencyName].Where == 1 then
		if currencyName == "DestinyPoints" then
			_G.CurrencyData[currencyName].Lbl:SetText(GetPlayerAttributes():GetDestinyPoints())
		else
			_G.CurrencyData[currencyName].Lbl:SetText(GetCurrency(L["M"..currencyName]))
		end
		_G.CurrencyData[currencyName].Lbl:SetSize(_G.CurrencyData[currencyName].Lbl:GetTextLength() * NM, CTRHeight ); 
		AjustIcon(currencyName);
	end
end
--**^
--**v Update backpack infos on TitanBar v**
function UpdateBackpackInfos()
	local max = backpack:GetSize();
	local freeslots = 0;

	for i = 1, max do
		if ( backpack:GetItem( i ) == nil ) then freeslots = freeslots + 1; end
	end

	local biData = (_G.ControlData and _G.ControlData.BI) or {}
	local showUsed = (biData.used ~= false) -- default true
	local showMax = (biData.max ~= false) -- default true

	if showUsed and showMax then 
        BI[ "Lbl" ]:SetText( max - freeslots .. "/" .. max );
	elseif showUsed and not showMax then 
        BI[ "Lbl" ]:SetText( max - freeslots );
	elseif (not showUsed) and showMax then 
        BI[ "Lbl" ]:SetText( freeslots .. "/" .. max );
	elseif (not showUsed) and (not showMax) then 
        BI[ "Lbl" ]:SetText( freeslots ); 
    end
	BI[ "Lbl" ]:SetSize( BI[ "Lbl" ]:GetTextLength() * NM, CTRHeight ); 

	--Change bag icon with capacity
	local i = nil;
	local usedslots = max - freeslots;
	local bi = round((( usedslots / max ) * 100));

	if bi >= 0 and bi <= 15 then i = 1; end-- 0% to 15% Full bag
	if bi >= 16 and bi <= 30 then i = 2; end-- 16% to 30% Full bag
	if bi >= 31 and bi <= 75 then i = 3; end-- 31% to 75% Full bag
	if bi >= 76 and bi <= 99 then i = 4; end-- 75% to 99% Full bag
	if bi == 100 then i = 5; end-- 100% Full bag
	--if bi >= 101 then BagIcon = 0x41007ecf; end-- over loaded bag
	
	BI[ "Icon" ]:SetBackground( resources.BagIcon[i] );

	AjustIcon( "BI" );
end
--**^

--**v Update player infos on TitanBar v**
function UpdatePlayersInfos()
	--Race
	PlayerRaceIdIs = Player:GetRace();
	local PlayerRaceIsLkey = "PR"..PlayerRaceIdIs
	PlayerRaceIs = L[PlayerRaceIsLkey]
	if not PlayerRaceIs then
		PlayerRaceIs = PlayerRaceIsLkey -- show the expected localization key if not found
	end

	--Class
	PlayerClassIdIs = Player:GetClass()
	local PlayerClassIsLkey = "PC"..PlayerClassIdIs
	PlayerClassIs = L[PlayerClassIsLkey]
	if not PlayerClassIs then
		PlayerClassIs = PlayerClassIsLkey -- show the expected localization key if not found
	end

	--Update visuale
	PI[ "Icon" ]:SetBackground(resources.PlayerIconCode[PlayerClassIdIs]) -- if class icon is unknown in the resource then background image is set to nil: nothing visible
	
	PI["Lvl"]:SetText(tostring(Player:GetLevel()))
	PI["Lvl"]:SetSize(PI["Lvl"]:GetTextLength() * NM+1, CTRHeight)
	PI["Name"]:SetPosition(PI["Lvl"]:GetLeft() + PI["Lvl"]:GetWidth() + 5, 0)
	--PI["Name"]:SetText("OneVeryLongCharacterName") --Debug purpose
	PI["Name"]:SetText(Player:GetName())
	PI["Name"]:SetSize(PI["Name"]:GetTextLength() * TM, CTRHeight);

	AjustIcon("PI");
end
--**^

function ChangeWearState(value)
	-- Set new wear state in table
	local WearState = PlayerEquipment:GetItem(EquipSlots[value]):GetWearState();
	itemEquip[value].WearState = WearState;

	if WearState == 0 then itemEquip[value].WearStatePts = 0; -- undefined
	elseif WearState == 3 then itemEquip[value].WearStatePts = 0; -- Broken
	elseif WearState == 1 then itemEquip[value].WearStatePts = 20; -- Damaged
	elseif WearState == 4 then itemEquip[value].WearStatePts = 99; -- Worn
	elseif WearState == 2 then itemEquip[value].WearStatePts = 100; -- Pristine
    end

	UpdateDurabilityInfos();
end

--**v Update Player Durability infos on TitanBar v**
function UpdateDurabilityInfos()
	local TDPts = 0;
	for i = 1, 20 do
        TDPts = TDPts + itemEquip[i].WearStatePts;
    end
    if numItems == 0 then TDPts = 100;
    else TDPts = TDPts / numItems; end

	--Change durability icon with %
	local DurIcon = nil;
	if TDPts >= 0 and TDPts <= 33 then DurIcon = 1; end--0x41007e29
	if TDPts >= 34 and TDPts <= 66 then DurIcon = 2; end--0x41007e29
	if TDPts >= 67 and TDPts <= 100 then DurIcon = 3; end--0x41007e28
	DI[ "Icon" ]:SetBackground( resources.Durability[DurIcon] );

	TDPts = string.format( "%.0f", TDPts );
	DI[ "Lbl" ]:SetText( TDPts .. "%" );
	DI[ "Lbl" ]:SetSize( DI[ "Lbl" ]:GetTextLength() * NM + 5, CTRHeight ); 
	AjustIcon( "DI" );
end
--**^
--**v Update equipment infos on TitanBar v**
function UpdateEquipsInfos()
    TotalItemsScore = 0;
    for i = 1,20 do TotalItemsScore = TotalItemsScore + itemEquip[i].Score; end
		AjustIcon("EI")
end
--**^
--**v Update Track Items on TitanBar v**
function UpdateTrackItems()
	AjustIcon( "TI" );
end
--**^
--**v Update Infamy points on TitanBar v**
function UpdateInfamy()
	--Change Rank icon with infamy points
	IF[ "Icon" ]:SetBackground( InfIcon[tonumber(settings.Infamy.K)] );
	
	AjustIcon( "IF" );
end
--**^
--**v Update Vault on TitanBar v**
function UpdateVault()
	AjustIcon( "VT" );
end
--**^
--**v Update Shared Storage on TitanBar v**
function UpdateSharedStorage()
	AjustIcon( "SS" );
end
--**^
--**v Update Day & Night time on TitanBar v**
function UpdateDayNight()
	local cdate = Turbine.Engine.GetDate();
	local chour = cdate.Hour;
	local cminute = cdate.Minute;
	local ampm = "";
	timer, sDay = nil, nil;

	GetInGameTime();
	local DNLen = 0;
	local DNTime = timer;
	DNLen1 = string.len(DNTime) * TM;
	DNLen = DNLen1;
	
	local dnData = (_G.ControlData and _G.ControlData.DN) or {}
	if dnData.next ~= false then --Show next day & night time
		if totalseconds >= 60 then NDNTime = cdminutes .. " min: " .. ntimer;
		else NDNTime = totalseconds .. " sec: " .. ntimer; end

		local DNLen2 = string.len(NDNTime) * TM;
		if DNLen2 > DNLen1 then DNLen = DNLen2; end

		DN[ "Lbl" ]:SetText( DNTime .. "\n" .. NDNTime );
	else
		DN[ "Lbl" ]:SetText( DNTime );
	end

	DN[ "Lbl" ]:SetSize( DNLen, CTRHeight ); --Auto size with text length
	--DN[ "Lbl" ]:SetBackColor( Color["white"] ); -- Debug purpose

	if sDay == "day" then DN[ "Icon" ]:SetBackground( resources.Sun );
        -- Sun in-game icon (0x4101f898 or 0x4101f89b)
	else DN[ "Icon" ]:SetBackground( resources.Moon ); end -- Moon in-game icon

	AjustIcon( "DN" );
end
--**^
--**v Update Reputation on TitanBar v**
function UpdateReputation()
	AjustIcon( "RP" );
end
--**^
--**v Update Player Location on TitanBar v**
function UpdatePlayerLoc( value )
	fontMetric=FontMetric();
    fontMetric:SetFont(_G.TBFont);
    PL[ "Lbl" ]:SetText( value );
	PL[ "Lbl" ]:SetSize( fontMetric:GetTextWidth(value,fontMetric.FontSize), CTRHeight );

	PL[ "Ctr" ]:SetSize( PL[ "Lbl" ]:GetWidth(), CTRHeight );
end
--**^
--**v Update game time on TitanBar v**
function UpdateGameTime(str)
	local gtData = _G.ControlData and _G.ControlData.GT
	local clock24h = gtData and gtData.clock24h == true
	local showST = gtData and gtData.showST == true
	local showBT = gtData and gtData.showBT == true
	local userGMT = (gtData and tonumber(gtData.userGMT)) or 0

	local cdate = Turbine.Engine.GetDate();
	local chour = cdate.Hour;
	local cminute = cdate.Minute;
	local ampm = "";
	TheTime = nil;
	TextLen = nil;

	local function formatTime(hour, minute)
		local suffix = "";
		if not clock24h then
			if hour == 12 then suffix = "pm";
			elseif hour >= 13 then hour = hour - 12; suffix = "pm";
			else if hour == 0 then hour = 12; end suffix = "am"; end
		end

		return hour .. ":" .. string.format("%02d", minute) .. suffix;
	end

	if str == "st" then
		if showST then
			chour = chour + userGMT;
			if chour < 0 then
				chour = 24 + chour;
				if chour == 0 then chour = 24; end
			elseif chour == 24 then
				chour = 24 - chour;
			end
		end

		_G.STime = formatTime(chour, cminute);
		TheTime = _G.STime;
		TextLen = string.len(TheTime) * NM;
	elseif str == "gt" then
		--write("Game Time");
		_G.GTime = formatTime(chour, cminute);
		TheTime = _G.GTime;
		TextLen = string.len(TheTime) * TM;
	elseif str == "bt" then
		--write("Both Time");
		UpdateGameTime("st");
		UpdateGameTime("gt");
		TheTime = L["GTWST"] .. _G.STime;
		TextLen = string.len(TheTime) * NM;
		TheTime = 
            L["GTWST"] .. _G.STime .. "\n" .. L["GTWRT"] .. _G.GTime .. " ";
	end
	
	GT[ "Lbl" ]:SetText( TheTime );
	GT[ "Lbl" ]:SetSize( TextLen, CTRHeight ); --Auto size with text length
	GT[ "Ctr" ]:SetSize( GT[ "Lbl" ]:GetWidth(), CTRHeight );
end
--**^


-- **v Change back color v**
function ChangeColor(tColor)
	if BGWToAll then
		TB["win"]:SetBackColor( tColor );
		
		-- Apply to all standard controls via ControlRegistry
		_G.ControlRegistry.ForEach(function(controlId, data)
			if data.show and data.ui.control then
				data.ui.control:SetBackColor(tColor)
			end
		end)
		
		-- Apply to all currency controls
		for k,v in pairs(_G.currencies.list) do
			if _G.CurrencyData[v.name].IsVisible then
				_G.CurrencyData[v.name].Ctr:SetBackColor(tColor)
			end
		end
	else
		if sFrom == "TitanBar" then 
			TB["win"]:SetBackColor( tColor )
		else
			-- Try to get from ControlRegistry first
			local data = _G.ControlRegistry.Get(sFrom)
			if data and data.ui.control then
				data.ui.control:SetBackColor(tColor)
			elseif _G.CurrencyData[sFrom] then
				-- Fall back to currency data
				_G.CurrencyData[sFrom].Ctr:SetBackColor(tColor)
			end
		end
	end
end
--**^

function LoadEquipmentTable()
	Slots = {
        "Head", "Chest", "Legs", "Gloves", "Boots", "Shoulder", "Back", 
        "Left Bracelet", "Right Bracelet", "Necklace", "Left Ring", 
        "Right Ring", "Left Earring", "Right Earring", "Pocket", 
        "Primary Weapon", "Secondary Weapon", "Ranged Weapon", "Craft Tool", 
        "Class"};
	EquipSlots = {
		Turbine.Gameplay.Equipment.Head,--						# 1
		Turbine.Gameplay.Equipment.Chest,--						# 2
		Turbine.Gameplay.Equipment.Legs,--						# 3
		Turbine.Gameplay.Equipment.Gloves,--					# 4
		Turbine.Gameplay.Equipment.Boots,--						# 5
		Turbine.Gameplay.Equipment.Shoulder,--				# 6
		Turbine.Gameplay.Equipment.Back,--						# 7
		Turbine.Gameplay.Equipment.Bracelet1,--				# 8
		Turbine.Gameplay.Equipment.Bracelet2,--				# 9
		Turbine.Gameplay.Equipment.Necklace,--				#10
		Turbine.Gameplay.Equipment.Ring1,--						#11
		Turbine.Gameplay.Equipment.Ring2,--						#12
		Turbine.Gameplay.Equipment.Earring1,--				#13
		Turbine.Gameplay.Equipment.Earring2,--				#14
		Turbine.Gameplay.Equipment.Pocket,--					#15
		Turbine.Gameplay.Equipment.PrimaryWeapon,--		#16
		Turbine.Gameplay.Equipment.SecondaryWeapon,--	#17
		Turbine.Gameplay.Equipment.RangedWeapon,--		#18
		Turbine.Gameplay.Equipment.CraftTool,--				#19
		Turbine.Gameplay.Equipment.Class,--						#20
	};
end

function ResetToolTipWin()
	if _G.ToolTipWin ~= nil then
		_G.ToolTipWin:SetVisible( false );
		_G.ToolTipWin = nil;
	end
end

function Player:InCombatChanged(sender, args)
	if TBAutoHide == L["OPAHC"] then AutoHideCtr:SetWantsUpdates( true ); end
end

--- Make sure if a control was at the bottom of the bar 
--- and now the bar is shorter that the control stays on the bar.
---@param controlName string
function KeepIconControlInBar(controlName)
	local container = nil;
	if (_G[controlName] and _G[controlName]["Ctr"]) then container = _G[controlName];
	elseif (_G.CurrencyData[controlName] and _G.CurrencyData[controlName].Ctr) then container = _G.CurrencyData[controlName];
	end

	if (container and container["Ctr"]) then
		local control = container["Ctr"];
		local saveFunction = container.SavePosition;

		-- if the control exists, make sure it's in the right location:
		local height = control:GetHeight();
		local currentBottom = control:GetTop() + height;
		if (currentBottom > TBHeight) then
			local newTop = TBHeight - height;
			-- Don't try and move the control above the bar:
			if (newTop < 0) then newTop = 0; end

			control:SetTop(newTop);

			if (saveFunction) then saveFunction(); end
		end
	end
end

function AjustIcon(str)
	--if TBHeight > 30 then CTRHeight = 30; end 
    --Stop ajusting icon size if TitanBar height is > 30px
	--CTRHeight=TBHeight;
	local Y = -1 - ((TBIconSize - CTRHeight) / 2);

	local function layoutIcon(icon, ctr, iconLeft, iconTop, ctrWidth)
		icon:SetStretchMode( 1 );
		icon:SetPosition( iconLeft, iconTop );
		ctr:SetSize( ctrWidth, CTRHeight );
		icon:SetSize( TBIconSize, TBIconSize );
		icon:SetStretchMode( 3 );
	end

	if str == "MI" then
		local moneyData = (_G.ControlData and _G.ControlData.Money) or {}
		local t = "" 
		if moneyData.stm == true then t = "T"; end 
        local p = { "G", "S", "C" }; --prefix for Gold, Silver, Copper controls
        local setleft = 0;
        for i = 1,3 do 
            local index = p[i] .. "Lbl" .. t;
            MI[p[i] .. "Ctr"]:SetLeft(setleft);
            local getright = MI[index]:GetLeft() + MI[index]:GetWidth();
            MI[p[i] .. "Icon"]:SetStretchMode(1);
		    MI[p[i] .. "Icon"]:SetPosition(getright - 4, Y + 1 );
		    MI[p[i] .. "Ctr"]:SetSize(getright + TBIconSize, CTRHeight);
            MI[p[i] .. "Icon"]:SetSize( TBIconSize, TBIconSize );
		    MI[p[i] .. "Icon"]:SetStretchMode( 3 );
            setleft = MI[p[i].."Ctr"]:GetLeft() + MI[p[i].."Ctr"]:GetWidth();
        end
		MI[ "Ctr" ]:SetSize( MI["GCtr"]:GetWidth() + MI["SCtr"]:GetWidth() + 
            MI["CCtr"]:GetWidth(), CTRHeight );
	elseif (_G.CurrencyData[str] and _G.CurrencyData[str].Icon) then
		local iconLeft = _G.CurrencyData[str].Lbl:GetLeft() + _G.CurrencyData[str].Lbl:GetWidth();
		if str ~= "DestinyPoints" then
			iconLeft = iconLeft + 3;
		end
		layoutIcon( _G.CurrencyData[str].Icon, _G.CurrencyData[str].Ctr, iconLeft, Y, iconLeft + TBIconSize );
	else
		-- Generic standard control layout.
		-- Any control with a global table containing ["Ctr"] and ["Icon"] will be handled here.
		-- This makes it much harder to forget adding a new control (e.g., EI).
		local container = _G[str];
		if container and container["Ctr"] and container["Icon"] then
			local label = container["Lbl"] or container["Name"];

			-- Icon-only controls keep the icon at x=0.
			local iconOnly = (label == nil)
				or (str == "WI")
				or (str == "TI")
				or (str == "VT")
				or (str == "SS")
				or (str == "IF")
				or (str == "RP");

			local dx = 0;
			local dy = 0;
			if str == "SP" then
				dx = -2;
			elseif str == "BI" then
				dx = 3;
				dy = 1;
			elseif str == "PI" then
				dx = 3;
			elseif str == "DN" then
				dy = 1;
			elseif str == "LP" then
				dx = 2;
				dy = 1;
			elseif str == "RP" then
				dy = 2;
			end

			local iconLeft = 0;
			if (not iconOnly) and label then
				iconLeft = label:GetLeft() + label:GetWidth();
			end
			iconLeft = iconLeft + dx;

			local ctrWidth = TBIconSize;
			if (not iconOnly) and label then
				ctrWidth = iconLeft + TBIconSize;
			end

			layoutIcon( container["Icon"], container["Ctr"], iconLeft, Y + dy, ctrWidth );
		elseif _G.ControlData and _G.ControlData[str] then
			write("AjustIcon: no layout handler for " .. tostring(str));
		end
	end

	KeepIconControlInBar(str);

end

function DecryptMoney( v )
	if ( v == nil ) then
		write( '<rgb=#FF0000>ERROR:</rgb> <rgb=#FF7777>function.lua DecryptMoney() passed a <rgb=#0000FF>nil</rgb>value.  Assuming <rgb=#FF8000>0</rgb>.</rgb>' );
		v = 0;
	end
	local gold = math.floor( v / 100000);
	local silver = math.floor( v / 100) - gold * 1000;
	local copper = v - gold * 100000 - silver * 100;
	return gold, silver, copper
end


function GetInGameTime()
	local nowtime = Turbine.Engine.GetLocalTime();
	local gametime = Turbine.Engine.GetGameTime();
	local ts = (_G.ControlData and _G.ControlData.DN and tonumber(_G.ControlData.DN.ts)) or 0
	local InitDawn =  nowtime - gametime + ts;
	local adjust = (nowtime - (nowtime - gametime + ts)) % Constants.GAME_TIME_CYCLE;
  local darray = {572, 1722, 1067, 1678, 1101, 570, 1679, 539, 1141, 1091};
	local dtarray = {
        L["Dawn"], L["Morning"], L["Noon"], L["Afternoon"], L["Dusk"], 
        L["Gloaming"], L["Evening"], L["Midnight"], L["LateWatches"],
        L["Foredawn"], L["Dawn"]}; 
    if (adjust <= 6140) then sDay = "day" else sDay = "night" end;
    local dapos = 1;
    if (adjust <= 572) then dapos = 1;
	elseif (adjust <= 2294) then dapos = 2;
	elseif (adjust <= 3361) then dapos = 3;
	elseif (adjust <= 5039) then dapos = 4;
	elseif (adjust <= 6140) then dapos = 5;
	elseif (adjust <= 6710) then dapos = 6;
	elseif (adjust <= 8389) then dapos = 7;
	elseif (adjust <= 8928) then dapos = 8;
	elseif (adjust <= 10069) then dapos = 9;
	elseif (adjust <= 11160) then dapos = 10;
	end
    timer = dtarray[dapos];
    ntimer = dtarray[dapos+1];
    local timesincedawn = (nowtime - InitDawn) % 11160;
	
	local tempIGduration = 0;
	for m = 1, dapos do
		tempIGduration = tempIGduration + darray[m]; 
        -- duration from dawn through next IG time
	end
	
	totalseconds = math.floor( tempIGduration - timesincedawn );  
    -- duration left for current IG time is equal to (time from dawn to next 
    -- IG time) minus (time from now since last dawn)
	
	local cdhours = math.floor( totalseconds / 3600 );
	cdminutes = math.floor( 60*( (totalseconds / 3600) - cdhours) );
	local cdseconds = math.floor( 60*(60*( (totalseconds/3600) - cdhours ) 
        - cdminutes) + 0.5 );
end
-- For debug purpose
function ShowTableContent( table )
	if table == nil then write( "Table " .. table .. " is empty!" ); return end

	for k,v in pairs(table) do
        local text = "";
        if (v.GetName) then
            text = v:GetName();
        else 
            text = tostring(v);
        end

		write( "key: "..tostring( k )..", value: "..text );
	end
end

function GetTotalItems( MyTable )
	local counter = 0;
	for k, v in pairs( MyTable ) do counter = counter + 1; end
	return counter;
end

PlayerAtt = nil;
---Central function to handle calling Player:GetAttributes().
---(The first time GetAttributes is called, the LOTRO client hangs for a short period,
---so we want to initialize it as-needed instead of on plugin load.)
---@return Attributes | FreePeopleAttributes
function GetPlayerAttributes()
    if (PlayerAtt == nil) then
        PlayerAtt = Player:GetAttributes();
    end
    return PlayerAtt;
end
