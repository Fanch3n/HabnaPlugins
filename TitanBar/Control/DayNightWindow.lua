-- DayNightWindow.lua
-- written by Habna

function frmDayNightWindow()
	import(AppDirD .. "WindowFactory")
	local prevTS = _G.TS
	local bHelp = false
	
	local windowWidth = (TBLocale == "fr") and 335 or 290
	
	-- Create window using factory
	_G.wDN = CreateWindow({
		text = L["MDayNight"],
		width = windowWidth,
		height = 105,
		left = DNWLeft,
		top = DNWTop,
		config = {
			settingsKey = "DayNight",
			windowGlobalVar = "wDN",
			formGlobalVar = "frmDN",
			onPositionChanged = function(left, top)
				DNWLeft, DNWTop = left, top
			end,
			onClosing = function(sender, args)
				if tonumber(_G.TS) == 0 then _G.TS = tonumber(prevTS) end
				settings.DayNight.S = string.format("%.0f", _G.TS)
				SaveSettings(false)
				UpdateDayNight()
			end
		}
	})
	
	-- **v Show/Hide Next time - Check box v**
	local NextTimeCB = Turbine.UI.Lotro.CheckBox();
	NextTimeCB:SetParent( _G.wDN );
	NextTimeCB:SetPosition( 35, 40 );
	NextTimeCB:SetText( L["NextT"] );
	NextTimeCB:SetSize( NextTimeCB:GetTextLength() * 8.5, 20 );
	NextTimeCB:SetChecked( _G.DNNextT );
	NextTimeCB:SetForeColor( Color["rustedgold"] );

	NextTimeCB.CheckedChanged = function( sender, args )
		_G.DNNextT = NextTimeCB:IsChecked();
		settings.DayNight.N = _G.DNNextT;
		SaveSettings( false );
		UpdateDayNight();
	end
	-- **^
	-- **v Timer seed - Label v**
	local TAjustlbl = CreateTitleLabel(_G.wDN, L["TAjustL"], NextTimeCB:GetLeft(), NextTimeCB:GetTop() + 30, nil, Color["rustedgold"], 8.5, nil, 20)
	-- **^
	-- **v Timer seed - Text box v**
	local TAjustTB = Turbine.UI.Lotro.TextBox();
	TAjustTB:SetParent( _G.wDN );
	TAjustTB:SetPosition( TAjustlbl:GetLeft() + TAjustlbl:GetWidth(), TAjustlbl:GetTop() - 5 );
	TAjustTB:SetText( _G.TS );
	TAjustTB:SetMultiline( false );
	TAjustTB:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	TAjustTB:SetSize( 75, 20 );
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

		_G.TS = parsed_text;
		settings.DayNight.S = string.format("%.0f",_G.TS);
		SaveSettings( false );
		UpdateDayNight();
	end
	-- **^
	-- **v ? - Button v**
	local Help = Turbine.UI.Lotro.Button();
	Help:SetParent( _G.wDN );
	Help:SetPosition( TAjustTB:GetLeft()+TAjustTB:GetWidth() + 10, TAjustTB:GetTop() );
	Help:SetText( "?" );
	Help:SetSize( 10, 20 );
	Help:SetForeColor( Color["rustedgold"] );

	Help.Click = function( sender, args )
		bHelp = not bHelp;
		ShowHelpSection(bHelp);
	end
	-- **^
	-- **v ? - TextBox v**
	HelpTB = Turbine.UI.Label();
	HelpTB:SetParent( _G.wDN );
	
	HelpTB:SetPosition( TAjustlbl:GetLeft(), TAjustlbl:GetTop()+TAjustlbl:GetHeight()+10 );
	HelpTB:SetForeColor( Color["rustedgold"] );
	HelpTB:SetVisible( bHelp );
	HelpTB:SetSize( _G.wDN:GetWidth()-60, 250 );
	HelpTB:SetText( "Try using does value if time is not sync:\n\n* Arkenstone: ... 1295018461\n* Brandywine: ... 1295011363\n* Crickhollow: .. 1295013525\n* Gladden: ...... 1295020785\n* Landroval: .... 1295028066" );
	-- **^
	
	ShowHelpSection(bHelp);
end

function ShowHelpSection(bHelp)
	if bHelp then
		_G.wDN:SetHeight( _G.wDN:GetHeight() + 125 );
	else
		_G.wDN:SetHeight( 105 );
	end
	HelpTB:SetVisible( bHelp );
end
