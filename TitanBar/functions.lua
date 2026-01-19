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

	local lblheader = CreateControl(Turbine.UI.Label, _G.ToolTipWin, 40, 7, xSize, ySize);
	lblheader:SetForeColor( Color["green"] );
	lblheader:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	lblheader:SetText( header );
	
	local YPos = 25;

	for i = 1, #txt do
		local lbltext = CreateControl(Turbine.UI.Label, _G.ToolTipWin, 40, YPos, xSize, 15);
		lbltext:SetForeColor( Color["white"] );
		lbltext:SetFont(Turbine.UI.Lotro.Font.Verdana14);
		lbltext:SetText( txt[i] );
		YPos = YPos + 15;
	end
	
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
	elseif ToShow == "IF" then
		h = 65;
		TTW = createToolTipWin(x, y, w, h, bblTo, L["Infamyh"], L["EIt2"], L["EIt3"])
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




function UpdateCurrencyDisplay(currencyName)
	if _G.CurrencyData[currencyName].Where == 1 then
		if currencyName == "DestinyPoints" then
			_G.CurrencyData[currencyName].Lbl:SetText(GetPlayerAttributes():GetDestinyPoints())
		else
			_G.CurrencyData[currencyName].Lbl:SetText(GetCurrency(L["M"..currencyName]))
		end
		_G.CurrencyData[currencyName].Lbl:SetSize(_G.CurrencyData[currencyName].Lbl:GetTextLength() * NM, CTRHeight ); 
		AdjustIcon(currencyName);
	end
end





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


function ChangeColor(tColor)
	if BGWToAll then
		TB["win"]:SetBackColor( tColor );
		
		-- Apply to all standard controls via ControlRegistry
		_G.ControlRegistry.ForEach(function(controlId, data)
			if data.show and data.ui and data.ui.control then
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
			if data and data.ui and data.ui.control then
				data.ui.control:SetBackColor(tColor)
			elseif _G.CurrencyData[sFrom] then
				-- Fall back to currency data
				_G.CurrencyData[sFrom].Ctr:SetBackColor(tColor)
			end
		end
	end
end

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
	
	-- Try to find the control in ControlData first
	if _G.ControlData and _G.ControlData[controlName] and _G.ControlData[controlName].controls then
		container = _G.ControlData[controlName].controls
	-- Special case for MI which is stored as "Money"
	elseif controlName == "MI" and _G.ControlData and _G.ControlData.Money and _G.ControlData.Money.controls then
		container = _G.ControlData.Money.controls
	elseif (_G.CurrencyData[controlName] and _G.CurrencyData[controlName].Ctr) then 
		container = _G.CurrencyData[controlName];
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

function AdjustIcon(str)
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
				_G.ControlData.Money.controls[p[i] .. "Ctr"]:SetLeft(setleft);
				local getright = _G.ControlData.Money.controls[index]:GetLeft() + _G.ControlData.Money.controls[index]:GetWidth();
				_G.ControlData.Money.controls[p[i] .. "Icon"]:SetStretchMode(1);
				_G.ControlData.Money.controls[p[i] .. "Icon"]:SetPosition(getright - 4, Y + 1 );
				_G.ControlData.Money.controls[p[i] .. "Ctr"]:SetSize(getright + TBIconSize, CTRHeight);
				_G.ControlData.Money.controls[p[i] .. "Icon"]:SetSize( TBIconSize, TBIconSize );
				_G.ControlData.Money.controls[p[i] .. "Icon"]:SetStretchMode( 3 );
				setleft = _G.ControlData.Money.controls[p[i].."Ctr"]:GetLeft() + _G.ControlData.Money.controls[p[i].."Ctr"]:GetWidth();
			end
			_G.ControlData.Money.controls[ "Ctr" ]:SetSize(_G.ControlData.Money.controls["GCtr"]:GetWidth() + _G.ControlData.Money.controls["SCtr"]:GetWidth() + 
            _G.ControlData.Money.controls["CCtr"]:GetWidth(), CTRHeight );
	elseif (_G.CurrencyData[str] and _G.CurrencyData[str].Icon) then
		local iconLeft = _G.CurrencyData[str].Lbl:GetLeft() + _G.CurrencyData[str].Lbl:GetWidth();
		if str ~= "DestinyPoints" then
			iconLeft = iconLeft + 3;
		end
		layoutIcon( _G.CurrencyData[str].Icon, _G.CurrencyData[str].Ctr, iconLeft, Y, iconLeft + TBIconSize );
	else
		-- Generic standard control layout.
		
		local container = nil
		-- Try to find the control in ControlData first
		if _G.ControlData and _G.ControlData[str] and _G.ControlData[str].controls then
			container = _G.ControlData[str].controls
		-- Special case for MI which is stored as "Money"
		elseif str == "MI" and _G.ControlData and _G.ControlData.Money and _G.ControlData.Money.controls then
			container = _G.ControlData.Money.controls
		end
		
		if container and container["Ctr"] and container["Icon"] then
			local label = container["Lbl"] or container["Name"];

			-- Icon-only controls keep the icon at x=0.
			local iconOnly = (label == nil)
				or (str == "EI")
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
		elseif _G.ControlData and _G.ControlData[str] and str ~= "PL" and str ~= "GT" then
			write("AdjustIcon: no layout handler for " .. tostring(str));
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
