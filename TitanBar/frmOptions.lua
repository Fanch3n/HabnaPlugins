-- frmOptions.lua
-- written by Habna
-- rewritten by many

import(AppDirD .. "UIHelpers")

if _G.Debug then write("frmOptions.lua"); end

-- All controls on TitanBar that have been created, currencies included
function GetWalletControls()
	local walletControls = { };
	_G.ControlRegistry.ForEach(function(id, data)
		if data.controls and data.controls[ "Ctr" ] then
			walletControls[ id ] = { IsVisible = data.show, Control = data.controls[ "Ctr" ] };
		end
	end)
	return walletControls;
end

local tFonts = { "Arial12", "TrajanPro13", "TrajanPro14", "TrajanPro15", "TrajanPro16", "TrajanPro18", "TrajanPro19", "TrajanPro20", "TrajanPro21",
			"TrajanPro23", "TrajanPro24", "TrajanPro25", "TrajanPro26", "TrajanPro28", "TrajanProBold16", "TrajanProBold22", "TrajanProBold24",
			"TrajanProBold25", "TrajanProBold30", "TrajanProBold36", "Verdana10", "Verdana12", "Verdana14", "Verdana16",
			"Verdana18", "Verdana20", "Verdana22", "Verdana23" };

local tFontsF = { "1107296297", "1107296258", "1107296268", "1107296263", "1107296267", "1107296265", "1107296309", "1107296256", "1107296266", "1107296269",
			"1107296277", "1107296326", "1107296293", "1107296294", "1107296298", "1107296275",	"1107296292", "1107296274", "1107296273", "1107296276",
			"1107296279", "1107296264", "1107296257", "1107296280", "1107296281", "1107296278", "1107296282", "1107296283" };

local aAutoHide = { L[ "OPAHD" ], L[ "OPAHE" ], L[ "OPAHC" ] };

local aIconSize = { L[ "OPISS" ], L[ "OPISL" ] }; --Small & Large
--aIconSize = { L[ "OPISS" ], L[ "OPISM" ], L[ "OPISL" ] }; --Small, Medium & Large

function frmOptions()
	TB["win"].MouseLeave();

	import ( AppClassD .. "ComboBox" );
	FontDD = HabnaPlugins.TitanBar.Class.ComboBox();

	-- **v Set some window stuff v**
	import(AppDirD .. "WindowFactory")

	-- Create options window via factory
	wOptions = CreateWindow({
		text = L[ "OPWTitle" ],
		width = 275,
		height = 275,
		position = WindowPositions.Options,
		config = {
			settingsKey = "Options",
			windowGlobalVar = "wOptions",
			onMouseDown = function(sender, args)
				-- Close dropdowns when the window is clicked or starts being dragged
				if FontDD and FontDD.dropped then FontDD:CloseDropDown(); end
				if AutoDD and AutoDD.dropped then AutoDD:CloseDropDown(); end
			end,
			onClosing = function( sender, args )
				if FontDD and FontDD.dropDownWindow then FontDD.dropDownWindow:SetVisible( false ); end
				if AutoDD and AutoDD.dropDownWindow then AutoDD.dropDownWindow:SetVisible( false ); end
				if TBAutoHide == L[ "OPAHE" ] then windowOpen = true; TB[ "win" ].MouseLeave(); end
				opt_options:SetEnabled( true );
			end,
		}
	})

	
	-- **v TitanBar Height - label v**
	local lblHeight = CreateTitleLabel(wOptions, L["OPHText"], 25, 40, nil, Color["rustedgold"], nil, wOptions:GetWidth() - 25, 15)
	-- **^
	-- **v Set the scrollbar v**
	local lblHeightV, lblIconSizeV -- created further down, updated by the scroll bars
	local wScrollBar = CreateControl(Turbine.UI.Lotro.ScrollBar, wOptions, lblHeight:GetLeft(), lblHeight:GetTop() + 15, wOptions:GetWidth() - 75, 10);
	wScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal );
	wScrollBar:SetMinimum( 10 );
	wScrollBar:SetMaximum( 100 );
	wScrollBar:SetValue( TBHeight );

	wScrollBar.ValueChanged = function( sender, args )
		local tValue = wScrollBar:GetValue();
		lblHeightV:SetText( tValue );
		TBHeight = tValue;
		LayoutBar();

		--Size Control if height is less 30px & stop at 30px if more 30px
		ResizeControls();
		SaveSettings();
	end
	-- **^
	-- **v TitanBar Height Value - label v**
	lblHeightV = CreateTitleLabel(wOptions, wScrollBar:GetValue(), wScrollBar:GetLeft() + wScrollBar:GetWidth() + 5, wScrollBar:GetTop(), nil, Color["rustedgold"], nil, 20, 15)
	-- **^

	-- **v TitanBar Font - label & DropDown box v**
	local lblFont = CreateTitleLabel(wOptions, L["OPFText"], 25, wScrollBar:GetTop() + 20, nil, Color["rustedgold"], nil, wOptions:GetWidth() - 25, 15)
	
	FontDD:SetParent( wOptions );
	FontDD:SetSize( Constants.DROPDOWN_WIDTH, Constants.DROPDOWN_HEIGHT );
	FontDD:SetPosition( 25, lblFont:GetTop() + 15 );
	FontDD.label:SetText( TBFontT );

	FontDD.dropDownWindow:SetParent( wOptions );
	FontDD.dropDownWindow:SetPosition( FontDD:GetLeft(), FontDD:GetTop() + FontDD:GetHeight() + 2 );

	for k,v in pairs( tFonts ) do
		FontDD:AddItem( v, k );
		if v == TBFontT then FontDD:SetSelection( k ); end
	end

	FontDD.ItemChanged = function( sender, args ) -- The event that's executed when a menu item is clicked.
		_G.TBFont = tonumber(tFontsF[ args.selection ]);
		TBFontT = FontDD.label:GetText();
		ReloadTitanBar("Font");
	end
	-- **^

	-- **v TitanBar Auto hide - label & DropDown box v**
	local lblAuto = CreateTitleLabel(wOptions, L["OPAText"], 25, FontDD:GetTop() + 30, nil, Color["rustedgold"], nil, wOptions:GetWidth() - 25, 15)
	
	AutoDD = HabnaPlugins.TitanBar.Class.ComboBox();
	AutoDD:SetParent( wOptions );
	AutoDD:SetSize( Constants.DROPDOWN_WIDTH, Constants.DROPDOWN_HEIGHT );
	AutoDD:SetPosition( 25, lblAuto:GetTop() + 15 );
	AutoDD.label:SetText( TBFontT );

	AutoDD.dropDownWindow:SetParent( wOptions );
	AutoDD.dropDownWindow:SetPosition( AutoDD:GetLeft(), AutoDD:GetTop() + AutoDD:GetHeight() + 2 );

	for k,v in pairs( aAutoHide ) do
		AutoDD:AddItem( v, k );
		if v == TBAutoHide then AutoDD:SetSelection( k ); end
	end

	AutoDD.ItemChanged = function( sender, args ) -- The event that's executed when a menu item is clicked.
		TBAutoHide = AutoDD.label:GetText();
		if TBAutoHide == L[ "OPAHE" ] then windowOpen = true; AutoHideCtr:SetWantsUpdates( true );
		elseif TBAutoHide == L[ "OPAHD" ] or TBAutoHide == L[ "OPAHC" ] then windowOpen = false; AutoHideCtr:SetWantsUpdates( true ); end
		SaveSettings();
	end
	-- **^
	-- **v TitanBar Icon Size - label & DropDown box v**
	local lblIconSize = CreateTitleLabel(wOptions, L["OPIText"], 25, AutoDD:GetTop() + 30, nil, Color["rustedgold"], nil, wOptions:GetWidth() - 25, 15)
	
	local wIconScrollBar = CreateControl(Turbine.UI.Lotro.ScrollBar, wOptions, lblIconSize:GetLeft(), lblIconSize:GetTop() + 15, wOptions:GetWidth() - 75, 10);
	wIconScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal );
	wIconScrollBar:SetMinimum( Constants.ICON_SIZE_SMALL );
	wIconScrollBar:SetMaximum( Constants.ICON_SIZE_LARGE );
	wIconScrollBar:SetValue( TBIconSize );

	wIconScrollBar.ValueChanged = function( sender, args )
		local itValue = wIconScrollBar:GetValue();
		lblIconSizeV:SetText( itValue );
		TBIconSize = itValue;
		SaveSettings();
		ResizeIcon();
	end
	-- **^
	-- **v TitanBar Icon Size Value - label v**
	lblIconSizeV = CreateTitleLabel(wOptions, wIconScrollBar:GetValue(), wIconScrollBar:GetLeft() + wIconScrollBar:GetWidth() + 5, wIconScrollBar:GetTop(), nil, Color["rustedgold"], nil, 20, 15)
	-- **^
	-- **v Set TitanBar at Top of screen - Check box v**
	local TBTopCB = CreateAutoSizedCheckBox(wOptions, L["OPTBTop"], wIconScrollBar:GetLeft(), wIconScrollBar:GetTop() + 20, TBTop);

	TBTopCB.CheckedChanged = function( sender, args )
		TBTop = TBTopCB:IsChecked();
		SaveSettings();
		LayoutBar();
		if TBAutoHide == L[ "OPAHE" ] then windowOpen = true; AutoHideCtr:SetWantsUpdates( true );
		elseif TBAutoHide == L[ "OPAHD" ] or TBAutoHide == L[ "OPAHC" ] then windowOpen = false; AutoHideCtr:SetWantsUpdates( true ); end
	end
	-- **^
	
	local currentLayout = (_G.ControlData and _G.ControlData.PI and _G.ControlData.PI.layout) or false
	local PILayoutCB = CreateAutoSizedCheckBox(wOptions, L["Layout"], TBTopCB:GetLeft(), TBTopCB:GetTop()+20, currentLayout, 8.5, 30);
	
	PILayoutCB.CheckedChanged = function( sender, args )
		_G.ControlData.PI = _G.ControlData.PI or {}
		_G.ControlData.PI.layout = PILayoutCB:IsChecked();
		SaveSettings();
		ReloadTitanBar();
	end
end

function ResizeControls()
	--Resize control height if control is visible
	CTRHeight = TBHeight;

	if TBHeight > 30 then CTRHeight = 30; end--Set control maximum height
	
	for ItemID, ShowItem in pairs( GetWalletControls() ) do
		if ShowItem.IsVisible then ShowItem.Control:SetHeight( CTRHeight ); end
		AdjustIcon( ItemID );
	end 

	if _G.ControlData.PL.show and _G.ControlData.PL.controls then _G.ControlData.PL.controls[ "Ctr" ]:SetHeight( CTRHeight ); _G.ControlData.PL.controls[ "Lbl" ]:SetHeight( CTRHeight ); end
	if _G.ControlData.GT.show  then _G.ControlData.GT.controls[ "Ctr" ]:SetHeight( CTRHeight );	_G.ControlData.GT.controls[ "Lbl" ]:SetHeight( CTRHeight ); end
end

function ResizeIcon()
	for ItemID, ShowItem in pairs( GetWalletControls() ) do
		if ShowItem.IsVisible then
			AdjustIcon(ItemID)
		end
	end
end