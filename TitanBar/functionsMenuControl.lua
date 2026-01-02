-- functionsMenuControl.lua
-- Written By Habna
-- Rewritten by many


--**v Functions for the menu of control v**
--**v Unload control v**
function UnloadControl( value )
	if _G.Debug then write("UnloadControl "..value); end
    -- Remove all controls from TitanBar:
	if value == "applyToAllControls" then
		-- Unload all standard controls
		_G.ControlRegistry.ForEach(function(controlId, data)
			if data.show then
				-- Set where to hidden if control has that property
				if data.where ~= nil then
					data.where = 3
				end
				-- Call toggle function to hide
				if data.toggleFunc then
					data.toggleFunc()
				end
				-- Uncheck option if available
				if data.ui.optCheckbox then
					data.ui.optCheckbox:SetChecked(false)
				end
			end
		end)
		
		-- Unload all currency controls
		for k,v in pairs(_G.currencies.list) do
			if _G.CurrencyData[v.name].IsVisible then
				_G.CurrencyData[v.name].Where = 3
				ShowHideCurrency(v.name);
			end
		end
		
    -- Remove just the selected control from TitanBar
	elseif value == "applyToThis" then
		local data = _G.ControlRegistry.Get(_G.sFromCtr)
		if data then
			-- Standard control
			if data.where ~= nil then
				data.where = 3
			end
			if data.toggleFunc then
				data.toggleFunc()
			end
			if data.ui.optCheckbox then
				data.ui.optCheckbox:SetChecked(false)
			end
		elseif _G.CurrencyData[_G.sFromCtr] then
			-- Currency control
			_G.CurrencyData[_G.sFromCtr].Where = 3
			ShowHideCurrency(_G.sFromCtr)
		end
	end

	TB["win"].MouseLeave();
end
--**^

--**v Match/Reset/Apply back color v**
function BGColor( cmd, value )
	if _G.Debug then write("BGColor cmd: "..cmd..", value: "..value); end
	if cmd == "reset" then
		if GLocale == "en" then tA, tR, tG, tB = 0.3, 0.3, 0.3, 0.3;
		else tA, tR, tG, tB = tonumber("0,3"), tonumber("0,3"), tonumber("0,3"), tonumber("0,3"); end
	elseif cmd == "match" then
		tA, tR, tG, tB = bcAlpha, bcRed, bcGreen, bcBlue;
	elseif cmd == "apply" then
		local data = _G.ControlRegistry.Get(_G.sFromCtr)
		if data then
			-- Standard control
			tA = data.colors.alpha
			tR = data.colors.red
			tG = data.colors.green
			tB = data.colors.blue
		elseif _G.CurrencyData[_G.sFromCtr] then
			-- Currency control
			tA = _G.CurrencyData[_G.sFromCtr].bcAlpha
			tR = _G.CurrencyData[_G.sFromCtr].bcRed
			tG = _G.CurrencyData[_G.sFromCtr].bcGreen
			tB = _G.CurrencyData[_G.sFromCtr].bcBlue
		end
	end
	
	if value == "applyToAllControls" then
		-- Apply to all standard controls
		_G.ControlRegistry.ForEach(function(controlId, data)
			data.colors.alpha = tA
			data.colors.red = tR
			data.colors.green = tG
			data.colors.blue = tB
			if data.show and data.ui.control then
				data.ui.control:SetBackColor(Turbine.UI.Color(tA, tR, tG, tB))
			end
		end)
		
		-- Apply to all currency controls
		for k,v in pairs(_G.currencies.list) do
			_G.CurrencyData[v.name].bcAlpha = tA
			_G.CurrencyData[v.name].bcRed = tR
			_G.CurrencyData[v.name].bcGreen = tG
			_G.CurrencyData[v.name].bcBlue = tB
			if _G.CurrencyData[v.name].IsVisible then
				_G.CurrencyData[v.name].Ctr:SetBackColor(Turbine.UI.Color(tA, tR, tG, tB))
			end
		end
	elseif value == "applyToAllAndTitanBar" then
		BGColor( cmd, "applyToAllControls" );
		BGColor( cmd, "TitanBar" );
	elseif value == "applyToThis" then
		local data = _G.ControlRegistry.Get(_G.sFromCtr)
		if data then
			-- Standard control
			data.colors.alpha = tA
			data.colors.red = tR
			data.colors.green = tG
			data.colors.blue = tB
			if data.ui.control then
				data.ui.control:SetBackColor(Turbine.UI.Color(tA, tR, tG, tB))
			end
		elseif _G.CurrencyData[_G.sFromCtr] then
			-- Currency control
			_G.CurrencyData[_G.sFromCtr].bcAlpha = tA
			_G.CurrencyData[_G.sFromCtr].bcRed = tR
			_G.CurrencyData[_G.sFromCtr].bcGreen = tG
			_G.CurrencyData[_G.sFromCtr].bcBlue = tB
			_G.CurrencyData[_G.sFromCtr].Ctr:SetBackColor(Turbine.UI.Color(tA, tR, tG, tB))
		end
	elseif value == "TitanBar" then
		bcAlpha, bcRed, bcGreen, bcBlue = tA, tR, tG, tB;
		TB["win"]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) );
	end

	SaveSettings( true );
	TB["win"].MouseLeave();
end