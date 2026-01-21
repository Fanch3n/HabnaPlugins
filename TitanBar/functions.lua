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

function ApplySkin()
    if _G.ToolTipWin then
        TooltipManager.ApplySkin(_G.ToolTipWin)
    end
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
