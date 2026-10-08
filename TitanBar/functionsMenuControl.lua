-- functionsMenuControl.lua
-- Written By Habna
-- Rewritten by many


--**v Functions for the menu of control v**
--**v Unload control v**
-- Hide a control and take it off the TitanBar
local function Unload(controlId, data)
	if data.where ~= nil then
		data.where = Constants.Position.NONE
	end
	if data.toggleFunc then
		data.toggleFunc()
	else
		ToggleControl(controlId)
	end
	if data.ui and data.ui.menuItem then
		data.ui.menuItem:SetChecked(false)
	end
end

function UnloadControl( value )
	if _G.Debug then write("UnloadControl "..value); end
	-- Remove all controls from TitanBar:
	if value == "applyToAllControls" then
		-- All controls, currencies included
		_G.ControlRegistry.ForEach(function(controlId, data)
			if data.show then Unload(controlId, data) end
		end)

	-- Remove just the selected control from TitanBar
	elseif value == "applyToThis" then
		local data = _G.ControlRegistry.Get(_G.sFromCtr)
		if data and data.show then Unload(_G.sFromCtr, data) end
	end

	TB["win"].MouseLeave();
end
--**^

--**v Match/Reset/Apply back color v**
function BGColor( cmd, value )
	if _G.Debug then write("BGColor cmd: "..cmd..", value: "..value); end
	if cmd == "reset" then
		tA, tR, tG, tB = 0.3, 0.3, 0.3, 0.3;
	elseif cmd == "match" then
		tA, tR, tG, tB = bcAlpha, bcRed, bcGreen, bcBlue;
	elseif cmd == "apply" then
		local data = _G.ControlRegistry.Get(_G.sFromCtr)
		if data then
			tA = data.colors.alpha
			tR = data.colors.red
			tG = data.colors.green
			tB = data.colors.blue
		end
	end
	
	if value == "applyToAllControls" then
		-- Apply to all controls, currencies included
		_G.ControlRegistry.ForEach(function(controlId, data)
			data.colors.alpha = tA
			data.colors.red = tR
			data.colors.green = tG
			data.colors.blue = tB
			if data.ui and data.ui.control then
				data.ui.control:SetBackColor(Turbine.UI.Color(tA, tR, tG, tB))
			end
		end)
	elseif value == "applyToAllAndTitanBar" then
		BGColor( cmd, "applyToAllControls" );
		BGColor( cmd, "TitanBar" );
	elseif value == "applyToThis" then
		local data = _G.ControlRegistry.Get(_G.sFromCtr)
		if data then
			data.colors.alpha = tA
			data.colors.red = tR
			data.colors.green = tG
			data.colors.blue = tB
			if data.ui and data.ui.control then
				data.ui.control:SetBackColor(Turbine.UI.Color(tA, tR, tG, tB))
			end
		end
	elseif value == "TitanBar" then
		bcAlpha, bcRed, bcGreen, bcBlue = tA, tR, tG, tB;
		TB["win"]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) );
	end

	SaveSettings();
	TB["win"].MouseLeave();
end