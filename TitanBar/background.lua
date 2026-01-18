-- background.lua
-- Written by Habna
-- Rewritten by many

import(AppDirD .. "UIHelpers")

function frmBackground()
	sFrom = _G.sFromCtr;
	curColor = {};
	bClick = false;

	import(AppDirD .. "WindowFactory")
	
	-- **v Create window via factory v**
	wBackground = CreateWindow({
		text = L["BWTitle"],
		width = 400,
		height = 210,
		left = BGWLeft,
		top = BGWTop,
		config = {
			settingsKey = "Background",
			windowGlobalVar = "wBackground",
			formGlobalVar = "frmBackground",
			onPositionChanged = function(left, top)
				BGWLeft, BGWTop = left, top
			end
		}
	})
	wBackground.Opacity = 1
	-- **^
	-- **v Check box - label v**
	local SetToAllCtr = CreateAutoSizedCheckBox(wBackground, L["BWApply"], 40, wBackground:GetHeight() - 70, BGWToAll, 8, 30)

	SetToAllCtr.CheckedChanged = function( sender, args )
		BGWToAll = SetToAllCtr:IsChecked();
		--if BGWToAll then ChangeColor(mColor); end
		settings.Background.A = BGWToAll;
		SaveSettings( false );
	end
	-- **^

	-- **v Currently set color - label v**
	local CurSetColorLbl = CreateTitleLabel(wBackground, L["BWCurSetColor"], 305, 35, nil, Color["rustedgold"], nil, 80, 30)
	-- **^
	-- **v Currently Selected color - box v**
	curSelColorBorder = CreateControl(Turbine.UI.Label, wBackground, 305, 60, 73, 73);
	curSelColorBorder:SetBackColor( Color["white"] );

	curSelColor = CreateControl(Turbine.UI.Label, curSelColorBorder, 1, 1, 71, 71);
	
	-- Set backcolor window setting to currently control color
	if sFrom == "TitanBar" then
		curSelAlpha = bcAlpha or 0.3
		curSelRed = bcRed or 0.3
		curSelGreen = bcGreen or 0.3
		curSelBlue = bcBlue or 0.3
	else
		-- Try to get from ControlRegistry first
		local data = _G.ControlRegistry.Get(sFrom)
		if data then
			curSelAlpha = data.colors.alpha or 0.3
			curSelRed = data.colors.red or 0.3
			curSelGreen = data.colors.green or 0.3
			curSelBlue = data.colors.blue or 0.3
		elseif _G.CurrencyData[sFrom] then
			-- Fall back to currency data
			curSelAlpha = _G.CurrencyData[sFrom].bcAlpha or 0.3
			curSelRed = _G.CurrencyData[sFrom].bcRed or 0.3
			curSelGreen = _G.CurrencyData[sFrom].bcGreen or 0.3
			curSelBlue = _G.CurrencyData[sFrom].bcBlue or 0.3
		end
	end
	
	curAlpha, curColor.R, curColor.G, curColor.B = curSelAlpha, curSelRed, curSelGreen, curSelBlue;
	curSelColor:SetBackColor( Turbine.UI.Color( curSelAlpha, curSelRed, curSelGreen, curSelBlue ) );
	-- **^
	-- **v Save button v**
	local buttonSave = CreateAutoSizedButton(wBackground, L["BWSave"], wBackground:GetWidth() - 110, wBackground:GetHeight() - 34)
	buttonSave:SetVisible( true );

	buttonSave.Click = function( sender, args )
		BGWToAll = SetToAllCtr:IsChecked();
		
		UpdateBCvariable();
		
		ChangeColor(curSelColor:GetBackColor());
		SaveSettings( true );
	end
	-- **^
	-- Create alpha label and slider.
	local alphalabel = Turbine.UI.Label();
	alphalabel:SetParent( wBackground );
	alphalabel:SetText( L["BWAlpha"] .. " @ " .. ( curSelAlpha * 100 ) .. "%" );
	alphalabel:SetPosition( 40, 40 );
	alphalabel:SetSize( 242, 10 );
	alphalabel:SetBackColor( Color["black"] );
	alphalabel:SetTextAlignment( Turbine.UI.ContentAlignment.TopCenter );
	
	local alphaScrollBar = CreateControl(Turbine.UI.Lotro.ScrollBar, alphalabel, 0, 0, 242, 10);
	alphaScrollBar:SetMinimum( 0 );
	alphaScrollBar:SetMaximum( 100 );
	alphaScrollBar:SetValue( curSelAlpha * 100);
	
	alphaScrollBar.ValueChanged = function(sender, args)
		curAlpha = alphaScrollBar:GetValue() / 100;
		alphalabel:SetText( L["BWAlpha"] .. " @ " .. ( curAlpha * 100 ) .. "%" );
		BGWToAll = SetToAllCtr:IsChecked();
		if bClick then ChangeColor(Turbine.UI.Color( curAlpha, curSelRed, curSelGreen, curSelBlue ));
		else ChangeColor(Turbine.UI.Color( curAlpha, curColor.R, curColor.G, curColor.B )); end
		curSelColor:SetBackColor( Turbine.UI.Color( curAlpha, curSelRed, curSelGreen, curSelBlue ) )
	end
	-- **^
	-- **v Default button v**
	local buttonDefault = CreateAutoSizedButton(wBackground, L["BWDef"], 23, wBackground:GetHeight() - 34)
	buttonDefault:SetVisible( true );

	buttonDefault.Click = function(sender, args)
		BGWToAll = SetToAllCtr:IsChecked();
		alphaScrollBar:SetValue( 30 );
		curSelAlpha = ( 0.3 );
		curSelRed = ( 0.3 );
		curSelGreen = ( 0.3 );
		curSelBlue = ( 0.3 );
		curSelColor:SetBackColor( Turbine.UI.Color( curSelAlpha, curSelRed, curSelGreen, curSelBlue ) );
		ChangeColor(curSelColor:GetBackColor());
		bClick = true;
	end
	-- **^
	-- **v Black button v**
	local buttonBlack = CreateAutoSizedButton(wBackground, L["BWBlack"], buttonDefault:GetLeft() + buttonDefault:GetWidth() + 5, wBackground:GetHeight() - 34)
	buttonBlack:SetVisible( true );

	buttonBlack.Click = function(sender, args)
		BGWToAll = SetToAllCtr:IsChecked();
		alphaScrollBar:SetValue ( 100 );
		curSelAlpha = ( 1 );
		curSelRed = ( 0 );
		curSelGreen = ( 0 );
		curSelBlue = ( 0 );
		curSelColor:SetBackColor( Turbine.UI.Color( curSelAlpha, curSelRed, curSelGreen, curSelBlue ) );
		ChangeColor(curSelColor:GetBackColor());
		bClick = true;
	end
	-- **^
	-- **v Transparent button v**
	local buttonTrans = CreateAutoSizedButton(wBackground, L["BWTrans"], buttonBlack:GetLeft() + buttonBlack:GetWidth() + 5, wBackground:GetHeight() - 34)
	buttonTrans:SetVisible( true );

	buttonTrans.Click = function(sender, args)
		BGWToAll = SetToAllCtr:IsChecked();
		alphaScrollBar:SetValue ( 0 );
		curSelAlpha = ( 0 );
		curSelRed = ( 0 );
		curSelGreen = ( 0 );
		curSelBlue = ( 0 );
		curSelColor:SetBackColor( Turbine.UI.Color( curSelAlpha, curSelRed, curSelGreen, curSelBlue ) );
		ChangeColor(curSelColor:GetBackColor());
		bClick = true;
	end
	-- **^
	-- Create Colour Picker window/border.
	ColourPickerBorder = CreateControl(Turbine.UI.Label, wBackground, 40, 60, 242, 73);
	ColourPickerBorder:SetBackColor( Turbine.UI.Color( 1, .2, .2, .2  ) );
	ColourPickerBorder:SetVisible( true );
	
	-- Create Colour Picker.
	ColourPicker = CreateControl(Turbine.UI.Label, ColourPickerBorder, 1, 1, 240, 71);
	ColourPicker:SetBackground( resources.Picker ); -- 0x41007e13 / resources.Picker.Background

	ColourPicker.GetColorFromCoord = function( sender, X, Y )
		-- Controls the visibility of the cursor window
		local blockXvalue = (round(ColourPicker:GetWidth()/3));
		local blockYvalue = (round(ColourPicker:GetHeight()/2));

		curColor = Turbine.UI.Color();
		--curColor.A = 1.0;
		local myX = X;
		local myY = Y;
		local curRed = 0;
		local curGreen = 0;
		local curBlue = 0;

		if (myX >= 0) and (myX < blockXvalue) then

			-- First color block = red to green
			curRed = 100-((100/blockXvalue)*myX);
			curGreen = (100/blockXvalue)*myX;
			curBlue = 0;

		elseif (myX >= blockXvalue) and (myX < (2*blockXvalue)) then

			-- Second color block = green to blue
			curRed = 0;
			curGreen = 100-((100/blockXvalue)*(myX - blockXvalue));
			curBlue = (100/blockXvalue)*(myX - blockXvalue);

		elseif (myX >= (2*blockXvalue)) then

			-- Third color block = blue to red
			curRed = (100/blockXvalue)*(myX - 2*blockXvalue);
			curGreen = 0;
			curBlue = 100-((100/blockXvalue)*(myX - 2*blockXvalue));

		end

		if myY <= blockYvalue then

			-- In the top block, so fade from black to full color
			curRed = curRed * (myY/blockYvalue);
			curGreen = curGreen * (myY/blockYvalue);
			curBlue = curBlue * (myY/blockYvalue);

		else

			-- In the bottom block, so fade from full color to white
			curRed = curRed + ((myY - blockYvalue) * ((100 - curRed)/(blockYvalue)));
			curGreen = curGreen + ((myY - blockYvalue) * ((100 - curGreen)/(blockYvalue)));
			curBlue = curBlue + ((myY - blockYvalue) * ((100 - curBlue)/(blockYvalue)));

		end

		curColor.A = curAlpha;
		curColor.R = (1/100) * curRed;
		curColor.G = (1/100) * curGreen;
		curColor.B = (1/100) * curBlue;

		return curColor;
	end

	ColourPicker.MouseMove = function( sender, args )
		mColor = ColourPicker:GetColorFromCoord( args.X, args.Y );
		BGWToAll = SetToAllCtr:IsChecked();
		ChangeColor(mColor);
	end
	
	ColourPicker.MouseClick = function( sender, args )
		curSelRed = curColor.R;
		curSelGreen = curColor.G;
		curSelBlue = curColor.B;
		curSelColor:SetBackColor( mColor );
		bClick = true;
	end
	
	wBackground.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			wBackground:Close();
		elseif ( args.Action == Constants.KEY_TOGGLE_UI ) or ( args.Action == Constants.KEY_TOGGLE_LAYOUT_MODE ) then -- Hide if F12 key is press or reposition UI
			wBackground:SetVisible( not wBackground:IsVisible() );
		end
	end

	wBackground.MouseUp = function( sender, args )
		settings.Background.L = string.format("%.0f", wBackground:GetLeft());
		settings.Background.T = string.format("%.0f", wBackground:GetTop());
		BGWLeft, BGWTop = wBackground:GetPosition();
		SaveSettings( false );
	end

	wBackground.Closing = function( sender, args )
		wBackground:SetWantsKeyEvents( false );
		TB["win"].MouseLeave();
		BGWToAll = SetToAllCtr:IsChecked();

		UpdateBCvariable();
		
		ChangeColor(curSelColor:GetBackColor());
		wBackground = nil;
		option_backcolor:SetEnabled( true );
	end
end

function UpdateBCvariable()
	-- Safety check for nil values
	curSelAlpha = curAlpha or 0.3
	curSelRed = curSelRed or 0.3
	curSelGreen = curSelGreen or 0.3
	curSelBlue = curSelBlue or 0.3

	if BGWToAll then
		bcAlpha, bcRed, bcGreen, bcBlue = curSelAlpha, curSelRed, curSelGreen, curSelBlue;
		
		-- Update all standard controls via ControlRegistry
		_G.ControlRegistry.ForEach(function(controlId, data)
			data.colors.alpha = curSelAlpha
			data.colors.red = curSelRed
			data.colors.green = curSelGreen
			data.colors.blue = curSelBlue
		end)
		
		-- Update all currency controls
		for k,v in pairs(_G.currencies.list) do
			_G.CurrencyData[v.name].bcAlpha = curSelAlpha
			_G.CurrencyData[v.name].bcRed = curSelRed
			_G.CurrencyData[v.name].bcGreen = curSelGreen
			_G.CurrencyData[v.name].bcBlue = curSelBlue
		end
	else
		if sFrom == "TitanBar" then 
			bcAlpha = curSelAlpha
			bcRed = curSelRed
			bcGreen = curSelGreen
			bcBlue = curSelBlue
		else
			-- Try to get from ControlRegistry first
			local data = _G.ControlRegistry.Get(sFrom)
			if data then
				data.colors.alpha = curSelAlpha
				data.colors.red = curSelRed
				data.colors.green = curSelGreen
				data.colors.blue = curSelBlue
			elseif _G.CurrencyData[sFrom] then
				-- Fall back to currency data
				_G.CurrencyData[sFrom].bcAlpha = curSelAlpha
				_G.CurrencyData[sFrom].bcRed = curSelRed
				_G.CurrencyData[sFrom].bcGreen = curSelGreen
				_G.CurrencyData[sFrom].bcBlue = curSelBlue
			end
		end
	end
end