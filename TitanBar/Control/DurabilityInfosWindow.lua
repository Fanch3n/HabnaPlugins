-- DurabilityInfosWindow.lua
-- written by Habna


function frmDurabilityInfosWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	_G.ControlData.DI = _G.ControlData.DI or {}
	local diData = _G.ControlData.DI
	if diData.icon == nil then diData.icon = true end
	if diData.text == nil then diData.text = true end

	-- Create window via helper
	local wDI = CreateControlWindow(
		"DurabilityInfos", "DI",
		L["DWTitle"], (TBLocale == "fr") and 400 or 300, 90
	)

	-- Initialize UI table
	_G.ControlData.DI.ui = {
		window = wDI
	}
	local ui = _G.ControlData.DI.ui

	local TTIcon = CreateAutoSizedCheckBox(wDI, L["DIIcon"], 30, 40, diData.icon);

	TTIcon.CheckedChanged = function( sender, args )
		diData.icon = TTIcon:IsChecked();
		settings.DurabilityInfos.I = diData.icon;
		SaveSettings( false );
	end

	local TTItemName = CreateAutoSizedCheckBox(wDI, L["DIText"], 30, TTIcon:GetTop() + TTIcon:GetHeight(), diData.text);

	TTItemName.CheckedChanged = function( sender, args )
		diData.text = TTItemName:IsChecked();
		settings.DurabilityInfos.N = diData.text;
		SaveSettings( false );
	end

	-- Handle window close
	wDI.Closed = function(sender, args)
		_G.ControlData.DI.ui = nil;
	end
end