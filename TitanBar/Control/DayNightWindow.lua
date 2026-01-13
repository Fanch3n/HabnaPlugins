-- DayNightWindow.lua
-- written by Habna

function frmDayNightWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	_G.ControlData.DN = _G.ControlData.DN or {}
	local prevTS = _G.ControlData.DN.ts
	local bHelp = false
	
	local windowWidth = (TBLocale == "fr") and 335 or 290
	
	-- Create window using helper
	local wDN = CreateControlWindow(
		"DayNight", "DN",
		L["MDayNight"], windowWidth, 105,
		{
			onClosing = function(sender, args)
				local ts = tonumber(_G.ControlData.DN.ts) or 0
				if ts == 0 then _G.ControlData.DN.ts = tonumber(prevTS) or 0 end
				settings.DayNight.S = string.format("%.0f", tonumber(_G.ControlData.DN.ts) or 0)
				SaveSettings(false)
				UpdateDayNight()
			end
		}
	)

	local NextTimeCB = Turbine.UI.Lotro.CheckBox();
	NextTimeCB:SetParent( wDN );
	NextTimeCB:SetPosition( 35, 40 );
	NextTimeCB:SetText( L["NextT"] );
	NextTimeCB:SetSize( NextTimeCB:GetTextLength() * 8.5, 20 );
	NextTimeCB:SetChecked( (_G.ControlData.DN.next ~= false) );
	NextTimeCB:SetForeColor( Color["rustedgold"] );

	NextTimeCB.CheckedChanged = function( sender, args )
		_G.ControlData.DN.next = NextTimeCB:IsChecked();
		settings.DayNight.N = _G.ControlData.DN.next;
		SaveSettings( false );
		UpdateDayNight();
	end

	local TAjustlbl = CreateTitleLabel(wDN, L["TAjustL"], NextTimeCB:GetLeft(), NextTimeCB:GetTop() + 30, nil, Color["rustedgold"], 8.5, nil, 20)
	local TAjustTB = CreateInputTextBox(wDN, tostring(tonumber(_G.ControlData.DN.ts) or 0), TAjustlbl:GetLeft() + TAjustlbl:GetWidth(), TAjustlbl:GetTop() - 5, 75);
	TAjustTB:SetForeColor( Color["white"] );

	TAjustTB.FocusGained = function( sender, args )
		TAjustTB:SetWantsUpdates( true );
	end

	TAjustTB.FocusLost = function( sender, args )
		TAjustTB:SetWantsUpdates( false );
	end

	TAjustTB.Update = function( sender, args )
		local parsed_text = TAjustTB:GetText();

		if tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil or parsed_text == "-0" or parsed_text == "+0" or parsed_text == "00" then
			TAjustTB:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			return
		elseif string.len(parsed_text) == 2 and string.sub(parsed_text,1,1) == "0" then
			TAjustTB:SetText( string.sub( parsed_text, 2 ) );
			return
		end

		_G.ControlData.DN.ts = tonumber(parsed_text) or 0
		settings.DayNight.S = string.format("%.0f", tonumber(_G.ControlData.DN.ts) or 0);
		SaveSettings( false );
		UpdateDayNight();
	end

	local Help = Turbine.UI.Lotro.Button();
	Help:SetParent( wDN );
	Help:SetPosition( TAjustTB:GetLeft()+TAjustTB:GetWidth() + 10, TAjustTB:GetTop() );
	Help:SetText( "?" );
	Help:SetSize( Constants.HELP_BUTTON_WIDTH, Constants.HELP_BUTTON_HEIGHT );
	Help:SetForeColor( Color["rustedgold"] );

	Help.Click = function( sender, args )
		bHelp = not bHelp;
		ShowHelpSection(bHelp);
	end

	HelpTB = Turbine.UI.Label();
	HelpTB:SetParent( wDN );
	
	HelpTB:SetPosition( TAjustlbl:GetLeft(), TAjustlbl:GetTop()+TAjustlbl:GetHeight()+10 );
	HelpTB:SetForeColor( Color["rustedgold"] );
	HelpTB:SetVisible( bHelp );
	HelpTB:SetSize( wDN:GetWidth()-60, 250 );
	HelpTB:SetText( "Try using does value if time is not sync:\n\n* Arkenstone: ... 1295018461\n* Brandywine: ... 1295011363\n* Crickhollow: .. 1295013525\n* Gladden: ...... 1295020785\n* Landroval: .... 1295028066" );

	ShowHelpSection(bHelp);
end

function ShowHelpSection(bHelp)
	local wDN = _G.ControlData.DN.windowInstance
	if bHelp then
			wDN:SetHeight( wDN:GetHeight() + 125 );
	else
		wDN:SetHeight( 105 );
	end
	HelpTB:SetVisible( bHelp );
end

