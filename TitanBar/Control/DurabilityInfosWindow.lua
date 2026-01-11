-- DurabilityInfosWindow.lua
-- written by Habna


function frmDurabilityInfosWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")

	-- Create window via helper
	local wDI = CreateControlWindow(
		"DurabilityInfos", "DI",
		L["DWTitle"], (TBLocale == "fr") and 400 or 300, 90
	)

	-- **v Show Icon in tooltip? v**
	local TTIcon = CreateAutoSizedCheckBox(wDI, L["DIIcon"], 30, 40, DIIcon);

	TTIcon.CheckedChanged = function( sender, args )
		DIIcon = TTIcon:IsChecked();
		settings.DurabilityInfos.I = DIIcon;
		SaveSettings( false );
	end
	-- **^
	-- **v Show Item Name in tooltip? v**
	local TTItemName = CreateAutoSizedCheckBox(wDI, L["DIText"], 30, TTIcon:GetTop() + TTIcon:GetHeight(), DIText);

	TTItemName.CheckedChanged = function( sender, args )
		DIText = TTItemName:IsChecked();
		settings.DurabilityInfos.N = DIText;
		SaveSettings( false );
	end
	-- **^
end