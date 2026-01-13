-- GameTimesWindow.lua
-- written by Habna


function frmGameTimeWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	local gtData = _G.ControlData.GT

	-- Create window via helper
	local wGT = CreateControlWindow(
		"GameTime", "GT",
		L["GTWTitle"], 200, 120
	)

	local GMT = Turbine.UI.Lotro.TextBox();
	local ShowSTcb = Turbine.UI.Lotro.CheckBox();
	local ShowBTcb;  -- Forward declaration
	local Clock24Ctr = CreateAutoSizedCheckBox(wGT, L["GTW24h"], 35, 40, gtData.clock24h == true, 8);

	Clock24Ctr.CheckedChanged = function( sender, args )
		gtData.clock24h = Clock24Ctr:IsChecked() == true
		settings.GameTime.H = gtData.clock24h
		SaveSettings( false );
		if gtData.showBT then ShowSTcb:SetChecked(gtData.showBT); UpdateGameTime("bt");
		elseif gtData.showST then UpdateGameTime("st");
		else UpdateGameTime("gt") end
	end

	ShowSTcb:SetParent( wGT );
	ShowSTcb:SetPosition( 35, Clock24Ctr:GetTop() + 20 );
	ShowSTcb:SetText( L["GTWSST"] );
	ShowSTcb:SetSize( ShowSTcb:GetTextLength() * 8, 20 );
	--ShowSTcb:SetVisible( true );
	--ShowSTcb:SetEnabled( false );
	ShowSTcb:SetChecked( gtData.showST == true );
	ShowSTcb:SetForeColor( Color["rustedgold"] );

	ShowSTcb.CheckedChanged = function( sender, args )
		gtData.showST = ShowSTcb:IsChecked() == true
		if not gtData.showST then ShowBTcb:SetChecked(false); end
		settings.GameTime.S = gtData.showST
		gtData.userGMT = tonumber(GMT:GetText()) or 0
		SaveSettings( false );
		if not gtData.showBT then UpdateGameTime("st"); end
	end

	GMT:SetParent( ShowSTcb );
	GMT:SetText( tostring(tonumber(gtData.userGMT) or 0) );
	GMT:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	GMT:SetSize( Constants.GMT_FIELD_WIDTH, Constants.GMT_FIELD_HEIGHT );
	--GMT:SetVisible( true );
	--GMT:SetEnabled( false );
	GMT:SetForeColor( Color["white"] );

	GMT.FocusGained = function( sender, args )
		GMT:SetWantsUpdates( true );
	end

	GMT.FocusLost = function( sender, args )
		GMT:SetWantsUpdates( false );
	end

	GMT.Update = function( sender, args )
		local parsed_text = GMT:GetText();

		if parsed_text == "" or parsed_text == "-" or parsed_text == "+" then
			return
		elseif parsed_text == "0-" or parsed_text == "0+" or parsed_text == "00" then
			GMT:SetText( string.sub( parsed_text, 2, 2 ) );
			return
		elseif tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil or string.find(parsed_text,",") then
            GMT:SetText( "0" );
            return
		elseif string.len(parsed_text) == 2 and string.sub(parsed_text,1,1) == "0" then
			GMT:SetText( string.sub( parsed_text, 2 ) );
			return
		end
		gtData.userGMT = tonumber(GMT:GetText()) or 0
		settings.GameTime.M = Constants.FormatInt(gtData.userGMT)
		SaveSettings( false );
		if gtData.showST then
			if gtData.showBT then UpdateGameTime("bt");
			elseif gtData.showST then UpdateGameTime("st");
			else UpdateGameTime("gt") end
		end
	end

	ShowBTcb = CreateAutoSizedCheckBox(wGT, L["GTWSBT"], 35, ShowSTcb:GetTop() + 20, gtData.showBT == true);

	ShowBTcb.CheckedChanged = function( sender, args )
		gtData.showBT = ShowBTcb:IsChecked() == true
		settings.GameTime.O = gtData.showBT
		SaveSettings( false );
		ShowSTcb:SetChecked(gtData.showBT);
				
		if gtData.showBT then UpdateGameTime("bt");
		elseif gtData.showST then UpdateGameTime("st");
		else UpdateGameTime("gt") end
	end

	GMT:SetPosition( ShowSTcb:GetWidth() - 65, 0 );
	wGT:SetWidth( Clock24Ctr:GetWidth() + 60 );
	if TBLocale == "fr" then
		GMT:SetPosition( ShowSTcb:GetWidth() - 70, 0 );
		wGT:SetWidth( ShowSTcb:GetWidth() + 85 );
	end
end
