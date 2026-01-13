-- WalletWindow.lua
-- Written by Habna
-- Rewritten by Many

local wcur

function frmWalletWindow()
	wcur = nil;
	import (AppClassD.."ComboBox");
	import(AppDirD .. "WindowFactory")
	local WIDD = HabnaPlugins.TitanBar.Class.ComboBox();
	local WIbutSave

	_G.ControlData.WI = _G.ControlData.WI or {}
	local wiData = _G.ControlData.WI
	wiData.ui = wiData.ui or {}
	local ui = wiData.ui

	local w = 320;
	if GLocale == "de" then w = 360;
	elseif GLocale == "fr" then w = 360;
	end

	local wWI = CreateControlWindow(
		"Wallet", "WI",
		L["MBag"], w, 640,
		{
			dropdown = WIDD,
			onClosing = function(sender, args)
				if WIDD and WIDD.dropDownWindow then WIDD.dropDownWindow:SetVisible(false) end
				wiData.ui = nil
			end,
			onKeyDown = function(sender, args)
				if args.Action == Constants.KEY_ENTER then
					if WIbutSave then WIbutSave.Click(sender, args) end
				end
			end
		}
	)
	ui.window = wWI
	local window = ui.window
	ui.WIDD = WIDD

	
	local WIlbltextHeight = 35;
	-- Use CreateTitleLabel for the centered wallet title
	local WIlbltext = CreateTitleLabel(window, L["WIt"], 20, 35, nil, Color["green"], nil, window:GetWidth()-40, WIlbltextHeight, Turbine.UI.ContentAlignment.MiddleCenter)

	local WIFilterlblHeight = 20;
	local WIFilterlbl = CreateFieldLabel(window, "Search:", 20, 75, 8, 60)

	-- Use factory helper to create the search TextBox + delete icon
	local wSearch = CreateSearchControl(window, WIFilterlbl:GetLeft() + WIFilterlbl:GetWidth(), WIFilterlbl:GetTop(), window:GetWidth() - 120, 20, Turbine.UI.Lotro.Font.Verdana16, resources)
	local WIFiltertxt = wSearch.TextBox
	ui.WIFilterDelIcon = wSearch.DelIcon
	ui.WIFiltertxt = WIFiltertxt
	local lastFilterText = ""
	WIFiltertxt.TextChanged = function()
		local current = WIFiltertxt:GetText() or ""
		if lastFilterText ~= current then
			lastFilterText = current
			if ui.WIFilter then ui.WIFilter() end
		end
	end

	local function WIFilter()
		local wiListBox = ui.WIListBox
		if not wiListBox then return end
		local filterText = string.lower(WIFiltertxt:GetText() or "");
		for i = 1, wiListBox:GetItemCount() do
			local row = wiListBox:GetItem(i);
			if string.find(string.lower(row.curLbl:GetText()), filterText) == nil then
				row:SetHeight(0);
			else
				row:SetHeight(20);
			end
		end
	end
	ui.WIFilter = WIFilter

	local WIListBoxHeight = window:GetHeight()-95 - WIlbltextHeight - WIFilterlblHeight;
	local wileft, witop = 20, 115
	local wilb = CreateListBoxWithBorder(window, wileft, witop, window:GetWidth()-40, WIListBoxHeight, nil)
	local WIListBox = wilb.ListBox
	ui.WIListBox = WIListBox
	WIListBox:SetParent( window );
	WIListBox:SetZOrder( 1 );
	WIListBox:SetPosition( 20, 115 );
	WIListBox:SetSize( window:GetWidth()-40, WIListBoxHeight );
	ConfigureListBox(WIListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])
	local WIListBoxScrollBar = wilb.ScrollBar
	ui.WIListBoxScrollBar = WIListBoxScrollBar
	WIListBoxScrollBar:SetParent( WIListBox );
	WIListBoxScrollBar:SetZOrder( 1 );
	WIListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	WIListBox:SetVerticalScrollBar( WIListBoxScrollBar );
	WIListBoxScrollBar:SetPosition( WIListBox:GetWidth() - 10, 0 );
	WIListBoxScrollBar:SetSize( 12, WIListBox:GetHeight() );

	local WIWCtr = CreateControl(Turbine.UI.Control, window, WIListBox:GetLeft(), WIListBox:GetTop(), WIListBox:GetWidth(), WIListBox:GetHeight());
	ui.WIWCtr = WIWCtr
	WIWCtr:SetZOrder( 0 );
	WIWCtr:SetVisible( false );
	WIWCtr:SetBlendMode( 5 );
	WIWCtr:SetBackground( resources.WalletWindow );

	WIWCtr.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Right ) then
			WIDD.Cleanup();
			WIWCtr:SetVisible( false );
			WIWCtr:SetZOrder( 0 );
		end
	end
	
	local WIlblFN = CreateControl(Turbine.UI.Label, WIWCtr, 0, WIWCtr:GetHeight()/2 - 40, WIWCtr:GetWidth(), 15);
	ui.WIlblFN = WIlblFN
	WIlblFN:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
	WIlblFN:SetFontStyle( Turbine.UI.FontStyle.Outline );
	WIlblFN:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	WIlblFN:SetForeColor( Color["rustedgold"] );

	local WICBO = { L["WIot"], L["WIiw"], L["WIds"] } --Combobox options
	ui.WICBO = WICBO

	WIDD:SetParent( WIWCtr );
	WIDD:SetSize( 170, Constants.DROPDOWN_HEIGHT );
	WIDD:SetPosition( WIWCtr:GetWidth()/2 - WIDD:GetWidth()/2, WIlblFN:GetTop()+WIlblFN:GetHeight()+10 );

	WIDD.dropDownWindow:SetParent( WIWCtr );
	WIDD.dropDownWindow:SetPosition(WIDD:GetLeft(), WIDD:GetTop() + WIDD:GetHeight()+2);

	-- Populate the wallet combobox using the helper
	PopulateDropDown(WIDD, WICBO, false, nil, nil)

	--** LOTRO Point box
	local LPWCtr = Turbine.UI.Control();
	ui.LPWCtr = LPWCtr
	LPWCtr:SetParent( WIWCtr );
	LPWCtr:SetPosition( WIListBox:GetLeft(), WIDD:GetTop()+WIDD:GetHeight()+10 );
	LPWCtr:SetZOrder( 2 );
	--LPWCtr:SetBackColor( Color["red"] ); -- debug purpose

	local WIlblLOTROPTS = Turbine.UI.Label();
	WIlblLOTROPTS:SetParent( LPWCtr );
	--WIlblLOTROPTS:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	WIlblLOTROPTS:SetText( L["MLotroPoints"] );
	WIlblLOTROPTS:SetPosition( 0, 2 );
	WIlblLOTROPTS:SetSize( WIlblLOTROPTS:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	WIlblLOTROPTS:SetForeColor( Color["rustedgold"] );
	WIlblLOTROPTS:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--WIlblLOTROPTS:SetBackColor( Color["red"] ); -- debug purpose

	local WItxtLOTROPTS = CreateInputTextBox(LPWCtr, nil, WIlblLOTROPTS:GetLeft()+WIlblLOTROPTS:GetWidth()+5, WIlblLOTROPTS:GetTop()-2);
	ui.WItxtLOTROPTS = WItxtLOTROPTS
	if PlayerAlign == 2 then WItxtLOTROPTS:SetBackColor( Color["red"] ); end

	WItxtLOTROPTS.FocusGained = function( sender, args )
		WItxtLOTROPTS:SelectAll();
		WItxtLOTROPTS:SetWantsUpdates( true );
	end

	WItxtLOTROPTS.FocusLost = function( sender, args )
		WItxtLOTROPTS:SetWantsUpdates( false );
	end

	WItxtLOTROPTS.Update = function( sender, args )
		local parsed_text = WItxtLOTROPTS:GetText();

		if tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil then
			WItxtLOTROPTS:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			return
		elseif string.len(parsed_text) > 1 and string.sub(parsed_text,1,1) == "0" then
			WItxtLOTROPTS:SetText( string.sub( parsed_text, 2 ) );
			return
		end
	end

	LPWCtr:SetSize( WIListBox:GetWidth(), 20 );
	--**

	WIbutSave = CreateAutoSizedButton(WIWCtr, L["PWSave"])
	ui.WIbutSave = WIbutSave

	WIbutSave.Click = function( sender, args )
		WIWCtr:SetVisible( false );
		WIWCtr:SetZOrder( 0 );

		local SelIndex = WIDD:GetSelection();
		--Where-> 1: On TitanBar / 2: In wallet control tooltip / 3: Don't show
		if wcur == L["MGSC"] then
			_G.ControlData.Money = _G.ControlData.Money or {}
			_G.ControlData.Money.where = SelIndex
			settings.Money.W = string.format("%.0f", SelIndex);
			if SelIndex == Constants.Position.TITANBAR then if not _G.ControlData.Money.show then ShowHideMoney(); end
			else if _G.ControlData.Money.show then ShowHideMoney(); end end
		elseif wcur == L["MLotroPoints"] then
			_G.ControlData.LP = _G.ControlData.LP or {}
			_G.ControlData.LP.where = SelIndex
			settings.LOTROPoints.W = string.format("%.0f", SelIndex);
			if SelIndex == Constants.Position.TITANBAR then
				if not _G.ControlData.LP.show then
					ShowHideLOTROPoints()
				end
			else
				if _G.ControlData.LP.show then
					ShowHideLOTROPoints()
				end
			end

			local parsed_text = WItxtLOTROPTS:GetText();

			if parsed_text == "" then
				WItxtLOTROPTS:SetText( "0" );
				WItxtLOTROPTS:Focus();
				return
			end
			
			local lpData = _G.ControlData and _G.ControlData.LP
			local currentPoints = (lpData and lpData.points) or "0"
			if parsed_text == currentPoints then
				WItxtLOTROPTS:Focus();
				return
			end
			
			_G.ControlData.LP = _G.ControlData.LP or {}
			_G.ControlData.LP.points = WItxtLOTROPTS:GetText();
			UpdateLOTROPoints()
		else
			local cur = _G.CurrencyLangMap[wcur]
			_G.CurrencyData[cur].Where = SelIndex
			settings[cur].W = string.format("%.0f", SelIndex)
			if SelIndex == Constants.Position.TITANBAR then
				if not _G.CurrencyData[cur].IsVisible then
					ShowHideCurrency(cur)
				end
			else
				if _G.CurrencyData[cur].IsVisible then
					ShowHideCurrency(cur)
				end
			end
		end

		SaveSettings( false );
	end

	RefreshWIListBox();
end

function RefreshWIListBox()
	local wiData = _G.ControlData and _G.ControlData.WI
	local ui = wiData and wiData.ui
	if not ui or not ui.window then return end
	local WIListBox = ui.WIListBox
	if not WIListBox then return end
	local WIWCtr = ui.WIWCtr
	local WIlblFN = ui.WIlblFN
	local WIDD = ui.WIDD
	local WICBO = ui.WICBO
	local LPWCtr = ui.LPWCtr
	local WIbutSave = ui.WIbutSave
	local WItxtLOTROPTS = ui.WItxtLOTROPTS

	WIListBox:ClearItems();
	
	for i = 1, #MenuItem do
		local WICtr = Turbine.UI.Control();
		WICtr:SetParent( WIListBox );
		WICtr:SetSize( WIListBox:GetWidth(), 20 );
		
		-- Wallet currency name
		local curLbl = Turbine.UI.Label();
		WICtr.curLbl = curLbl;
		curLbl:SetParent( WICtr );
		curLbl:SetText( MenuItem[i] );
		curLbl:SetSize( WIListBox:GetWidth(), 20 );
		curLbl:SetPosition( 0, 0 );
		curLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
		curLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		curLbl:SetForeColor( Color["nicegold"] );
        curLbl:SetMultiline(false);
		--curLbl:SetBackColor( Color["blue"] ); --debug purpose

		curLbl.MouseClick = function( sender, args )
			if ( args.Button == Turbine.UI.MouseButton.Right ) then
				wcur = MenuItem[i];
				WIlblFN:SetText( wcur );
				LPWCtr:SetVisible( false );
				WIbutSave:SetPosition( WIWCtr:GetWidth()/2 - WIbutSave:GetWidth()/2, WIDD:GetTop()+WIDD:GetHeight()+10 );

				local tw
				if wcur == L["MGSC"] then
					tw = (_G.ControlData.Money and _G.ControlData.Money.where) or Constants.Position.NONE -- Money
				elseif wcur == L["MLotroPoints"] then
					tw = (_G.ControlData.LP and _G.ControlData.LP.where) or Constants.Position.NONE -- LOTRO Points
					LPWCtr:SetVisible( true ); -- LOTRO Points
					local lpData = _G.ControlData and _G.ControlData.LP
					local points = (lpData and lpData.points) or "0"
					WItxtLOTROPTS:SetText( points ); -- LOTRO Points
					WItxtLOTROPTS:Focus(); -- LOTRO Points
					WIbutSave:SetPosition( WIWCtr:GetWidth()/2 - WIbutSave:GetWidth()/2, LPWCtr:GetTop()+LPWCtr:GetHeight()+10); -- LOTRO Points
				else
					tw = _G.CurrencyData[_G.CurrencyLangMap[wcur]].Where
				end

				for k, v in pairs(WICBO) do
					if k == tonumber(tw) then
						WIDD:SetSelection(k)
					end
				end

				WIWCtr:SetVisible( true );
				WIWCtr:SetZOrder( 2 );
				WIWCtr:SetBackground( resources.WalletWindowRefresh );
			end
		end

		WIListBox:AddItem( WICtr );
	end
	if ui.WIFilter then ui.WIFilter() end
end