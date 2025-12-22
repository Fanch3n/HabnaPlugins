-- DurabilityInfosWindow.lua
-- written by Habna


function frmDurabilityInfosWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")

	-- Create window via factory
	_G.wDI = CreateWindow({
		text = L["DWTitle"],
		width = (TBLocale == "fr") and 400 or 300,
		height = 90,
		left = DIWLeft,
		top = DIWTop,
		config = {
			settingsKey = "DurabilityInfos",
			windowGlobalVar = "wDI",
			formGlobalVar = "frmDI",
			onPositionChanged = function(left, top)
				DIWLeft, DIWTop = left, top
			end,
			onClosing = function(sender, args)
				-- nothing extra required
			end,
		}
	})

	-- **v Show Icon in tooltip? v**
	local TTIcon = CreateAutoSizedCheckBox(_G.wDI, L["DIIcon"], 30, 40, DIIcon);

	TTIcon.CheckedChanged = function( sender, args )
		DIIcon = TTIcon:IsChecked();
		settings.DurabilityInfos.I = DIIcon;
		SaveSettings( false );
	end
	-- **^
	-- **v Show Item Name in tooltip? v**
	local TTItemName = CreateAutoSizedCheckBox(_G.wDI, L["DIText"], 30, TTIcon:GetTop() + TTIcon:GetHeight(), DIText);

	TTItemName.CheckedChanged = function( sender, args )
		DIText = TTItemName:IsChecked();
		settings.DurabilityInfos.N = DIText;
		SaveSettings( false );
	end
	-- **^
end