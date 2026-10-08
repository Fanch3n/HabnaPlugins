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
	local data = _G.ControlData[currencyName]
	if data.where == 1 then
		local lbl = data.controls.Lbl
		if currencyName == "DestinyPoints" then
			lbl:SetText(GetPlayerAttributes():GetDestinyPoints())
		else
			lbl:SetText(GetCurrency(L["M"..currencyName]))
		end
		lbl:SetSize(lbl:GetTextLength() * NM, CTRHeight ); 
		AdjustIcon(currencyName);
	end
end








function ChangeColor(tColor)
	if BGWToAll then
		TB["win"]:SetBackColor( tColor );
		
		-- Apply to all controls, currencies included
		_G.ControlRegistry.ForEach(function(controlId, data)
			if data.show and data.ui and data.ui.control then
				data.ui.control:SetBackColor(tColor)
			end
		end)
	else
		if sFrom == "TitanBar" then 
			TB["win"]:SetBackColor( tColor )
		else
			local data = _G.ControlRegistry.Get(sFrom)
			if data and data.ui and data.ui.control then
				data.ui.control:SetBackColor(tColor)
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

-- Positions an icon in its control and sizes the control (for AdjustIcon and own icon layouts)
function LayoutIcon(icon, ctr, iconLeft, iconTop, ctrWidth)
	-- Stretched icons need edge attachments to scale with the bar.
	AttachScalingEdges( icon );
	ctr:SetSize( ctrWidth, CTRHeight );
	icon:SetPosition( iconLeft, iconTop );
	StretchBackground( icon, TBIconSize, TBIconSize );
	icon:SetStretchMode( 3 );
end

-- Lays out the icon of a control, as described by the icon field of its registration:
--   icon = { only = true }   the icon stays at x=0 even if the control has a label
--   icon = { dx = 3, dy = 1 } offset of the icon
--   icon = { layout = function(iconTop) end }   the control lays out its icons itself
--   icon = false             the control has no icon
function AdjustIcon(str)
	--if TBHeight > 30 then CTRHeight = 30; end
    --Stop ajusting icon size if TitanBar height is > 30px
	--CTRHeight=TBHeight;
	local Y = -1 - ((TBIconSize - CTRHeight) / 2);
	local data = _G.ControlData[str]
	local meta = _G.ControlRegistry.GetMetadata(str) or {}
	local icon = meta.icon or {}

	if icon.layout then
		icon.layout(Y)
	elseif _G.ControlRegistry.IsCurrency(str) then
		local controls = data.controls
		if controls and controls.Icon then
			local iconLeft = controls.Lbl:GetLeft() + controls.Lbl:GetWidth();
			if str ~= "DestinyPoints" then
				iconLeft = iconLeft + 3;
			end
			LayoutIcon( controls.Icon, controls.Ctr, iconLeft, Y, iconLeft + TBIconSize );
		end
	else
		local container = data and data.controls
		if container and container["Ctr"] and container["Icon"] then
			local label = container["Lbl"] or container["Name"];

			-- Icon-only controls keep the icon at x=0.
			local iconOnly = (label == nil) or icon.only;
			local dx = icon.dx or 0;
			local dy = icon.dy or 0;

			local iconLeft = 0;
			if (not iconOnly) and label then
				iconLeft = label:GetLeft() + label:GetWidth();
			end
			iconLeft = iconLeft + dx;

			local ctrWidth = TBIconSize;
			if (not iconOnly) and label then
				ctrWidth = iconLeft + TBIconSize;
			end

			LayoutIcon( container["Icon"], container["Ctr"], iconLeft, Y + dy, ctrWidth );
		elseif data and meta.icon ~= false then
			write("AdjustIcon: no layout handler for " .. tostring(str));
		end
	end

	KeepIconControlInBar(str);

end

-- Lays out every icon on TitanBar again, e.g. after the screen size or UI scale changed.
function RelayoutIcons()
	_G.ControlRegistry.ForEach(function(controlId, data)
		local onBar = data.show and (data.where == nil or data.where == Constants.Position.TITANBAR)
		if onBar and data.controls then
			local meta = _G.ControlRegistry.GetMetadata(controlId)
			if data.controls["Icon"] or (meta and meta.icon and meta.icon.layout) then
				AdjustIcon(controlId);
			end
		end
	end)
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
