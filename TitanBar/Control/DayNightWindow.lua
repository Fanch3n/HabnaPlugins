-- DayNightWindow.lua
-- written by Habna

function frmDayNightWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	_G.ControlData.DN = _G.ControlData.DN or {}
	_G.ControlData.DN.ui = _G.ControlData.DN.ui or {}
	local ui = _G.ControlData.DN.ui
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
				_G.ControlData.DN.ui = nil
			end
		}
	)
	ui.window = wDN

	local NextTimeCB = CreateAutoSizedCheckBox(wDN, L["NextT"], 35, 40, (_G.ControlData.DN.next ~= false), 8.5, 20)

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

	ui.HelpTB = Turbine.UI.Label();
	ui.HelpTB:SetParent( wDN );
	
	ui.HelpTB:SetPosition( TAjustlbl:GetLeft(), TAjustlbl:GetTop()+TAjustlbl:GetHeight()+10 );
	ui.HelpTB:SetForeColor( Color["rustedgold"] );
	ui.HelpTB:SetVisible( bHelp );
	ui.HelpTB:SetSize( wDN:GetWidth()-60, 250 );
	ui.HelpTB:SetText( "Try using does value if time is not sync:\n\n* Arkenstone: ... 1295018461\n* Brandywine: ... 1295011363\n* Crickhollow: .. 1295013525\n* Gladden: ...... 1295020785\n* Landroval: .... 1295028066" );

	ShowHelpSection(bHelp);
end

function ShowHelpSection(bHelp)
	local ui = _G.ControlData.DN and _G.ControlData.DN.ui
	if not ui then return end
	if bHelp then
			ui.window:SetHeight( ui.window:GetHeight() + 125 );
	else
		ui.window:SetHeight( 105 );
	end
	ui.HelpTB:SetVisible( bHelp );
end

