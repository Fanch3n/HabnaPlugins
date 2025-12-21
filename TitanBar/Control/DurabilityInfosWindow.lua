-- DurabilityInfosWindow.lua
-- written by Habna


function frmDurabilityInfosWindow()
	import(AppDirD .. "WindowFactory")

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
	local TTIcon = Turbine.UI.Lotro.CheckBox();
	TTIcon:SetParent( _G.wDI );
	TTIcon:SetPosition( 30, 40 );
	TTIcon:SetText( L["DIIcon"] );
	TTIcon:SetSize( TTIcon:GetTextLength() * 8.5, 20 );
	--TTIcon:SetVisible( true );
	--TTIcon:SetEnabled( false );
	TTIcon:SetChecked( DIIcon );
	TTIcon:SetForeColor( Color["rustedgold"] );

	TTIcon.CheckedChanged = function( sender, args )
		DIIcon = TTIcon:IsChecked();
		settings.DurabilityInfos.I = DIIcon;
		SaveSettings( false );
	end
	-- **^
	-- **v Show Item Name in tooltip? v**
	local TTItemName = Turbine.UI.Lotro.CheckBox();
	TTItemName:SetParent( _G.wDI );
	TTItemName:SetPosition( 30, TTIcon:GetTop() + TTIcon:GetHeight() );
	TTItemName:SetText( L["DIText"] );
	TTItemName:SetSize( TTItemName :GetTextLength() * 8.5, 20 );
	--TTItemName:SetVisible( true );
	--TTItemName:SetEnabled( false );
	TTItemName:SetChecked( DIText );
	TTItemName:SetForeColor( Color["rustedgold"] );

	TTItemName.CheckedChanged = function( sender, args )
		DIText = TTItemName:IsChecked();
		settings.DurabilityInfos.N = DIText;
		SaveSettings( false );
	end
	-- **^
end