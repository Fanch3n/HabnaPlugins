-- VaultWindow.lua
-- written by Habna


function frmVault()
	tvaultpack = vaultpack;
	SelCN = PN;
	import (AppClassD.."ComboBox");
	VICB = HabnaPlugins.TitanBar.Class.ComboBox();

	-- **v Set some window stuff v**
	import(AppDirD .. "WindowFactory")

	-- Create window via helper
	local wVT = CreateControlWindow(
		"Vault", "VT",
		L["MVault"], 390, 520,
		{
			dropdown = VICB,
			onClosing = function(sender, args)
				if VICB and VICB.dropDownWindow then VICB.dropDownWindow:SetVisible(false) end
				RemoveCallback( tvaultpack, "CountChanged" )
			end
		}
	)

	-- **^
	-- **v Create drop down box v**
	VICB:SetParent( wVT );
	VICB:SetSize( 159, 19 );
	VICB:SetPosition( 15, 35 );

	VICB.dropDownWindow:SetParent( wVT );
	VICB.dropDownWindow:SetPosition(VICB:GetLeft(), VICB:GetTop() + VICB:GetHeight()+2);

	VICB.ItemChanged = function( sender, args ) -- The event that's executed when a menu item is clicked.
		wVT.SearchTextBox:SetText( "" );
		wVT.SearchTextBox.TextChanged( sender, args );
		SelCN = VICB.label:GetText();
		CountVIItems();
	end

	CreateVIComboBox();
	-- **^
	-- **v search label & text box v**
	-- **v search label & text box v**
	wVT.searchLabel = CreateTitleLabel(wVT, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = wVT.searchLabel:GetLeft() + wVT.searchLabel:GetWidth()
	local searchWidth = wVT:GetWidth() - 150
	local search = CreateSearchControl(wVT, searchLeft, wVT.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	wVT.SearchTextBox = search.TextBox
	wVT.DelIcon = search.DelIcon

	wVT.SearchTextBox.TextChanged = function( sender, args )
		wVT.searchText = string.lower( wVT.SearchTextBox:GetText() );
		if wVT.searchText == "" then wVT.searchText = nil; end
		CountVIItems();
	end

	wVT.SearchTextBox.FocusLost = function( sender, args )
	end

	local lbTop = 85
	local lb = CreateListBoxWithBorder(wVT, 15, lbTop, wVT:GetWidth() - 30, Constants.LISTBOX_HEIGHT_STANDARD, Color["grey"])
	wVT.ListBoxBorder = lb.Border
	wVT.ListBox = lb.ListBox
	wVT.ListBoxScrollBar = lb.ScrollBar
	wVT.ListBox:SetMaxItemsPerLine( 1 );
	ConfigureListBox(wVT.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])
	-- **v Delete character infos button v**
	wVT.ButtonDelete = Turbine.UI.Lotro.Button();
	wVT.ButtonDelete:SetParent( wVT );
	wVT.ButtonDelete:SetText( L["ButDel"] );
	wVT.ButtonDelete:SetSize( wVT.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght

	wVT.ButtonDelete.Click = function( sender, args )
		PlayerVault[SelCN] = nil;
		SavePlayerVault();
		write( SelCN .. L["VTID"] );
		SelCN = PN;
		VICB.selection = -1;
		CreateVIComboBox();
		CountVIItems();
	end
	-- **^

	AddCallback(tvaultpack, "CountChanged", 
		function(sender, args)
		if _G.ControlData.VT.windowInstance then
			if SelCN == PN or SelCN == L["VTAll"] then CountVIItems(); end
		end
	end);

	CountVIItems();
end

function CreateVIComboBox()
	-- **v Create an array of character name, sort it, then use it as a reference - label & DropDown box v**
	local newt = {}
	for i in pairs(PlayerVault) do
		if string.sub( i, 1, 1 ) == "~" then PlayerVault[i] = nil; else table.insert(newt,i); end --Delete session play character
	end
	table.sort(newt);
	-- Use PopulateDropDown helper (adds All and selects PN if present)
	PopulateDropDown(VICB, newt, true, L["VTAll"], PN)
	-- **^
end

function CountVIItems()
	local wVT = _G.ControlData.VT.windowInstance
	local vaultpackCount = 0;
	wVT.ListBox:ClearItems();
	itemCtl = {};

	if SelCN == L["VTAll"] then
		wVT.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerVault) do
			for k, v in pairs(PlayerVault[i]) do vaultpackCount = vaultpackCount + 1; end
            AddVaultPack(i, true, vaultpackCount);
			vaultpackCount = 0;
        end
    else
		if SelCN == PN then wVT.ButtonDelete:SetEnabled( false );
		else wVT.ButtonDelete:SetEnabled( true ); end
		for k, v in pairs(PlayerVault[SelCN]) do vaultpackCount = vaultpackCount + 1; end
		if vaultpackCount == 0 then SetEmptyVault();
		else AddVaultPack(SelCN, false, vaultpackCount); end
    end
 
    wVT.ButtonDelete:SetPosition( wVT:GetWidth()/2 - wVT.ButtonDelete:GetWidth()/2, wVT.ListBox:GetTop()+wVT.ListBox:GetHeight()+10 );
end

function SetEmptyVault()
	local wVT = _G.ControlData.VT.windowInstance
	local itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( wVT.ListBox:GetWidth(), 35 );

	local lblmgs = CreateTitleLabel(itemCtl, L["VTnd"], 0, 0, nil, Color["green"], nil, itemCtl:GetWidth(), itemCtl:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

	wVT.ListBox:AddItem( itemCtl );
	wVT.ButtonDelete:SetVisible( false );

	wVT.ListBoxBorder:SetPosition( 15, 85 );
	wVT.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	wVT.ListBox:SetPosition( wVT.ListBoxBorder:GetLeft() + 2, wVT.ListBoxBorder:GetTop() + 2 );
	wVT.ListBox:SetHeight( lblmgs:GetHeight() )
	wVT.ListBoxScrollBar:SetVisible( false );
	wVT:SetHeight( itemCtl:GetHeight() + 85 );
end

function AddVaultPack(n, addCharacterName, vaultpackCount)
	local wVT = _G.ControlData.VT.windowInstance
	for i = 1, vaultpackCount do
		local itemName = PlayerVault[n][tostring(i)].T;
		if not wVT.searchText or string.find(string.lower( itemName ), wVT.searchText, 1, true) then
			-- Use CreateItemRow for vault item
			local data = PlayerVault[n][tostring(i)]
			local row = CreateItemRow(wVT.ListBox, wVT.ListBox:GetWidth(), 35, false, data)
			itemCtl[i] = row.Container
			if row.ItemQuantity and data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
			row.ItemLabel:SetText( data.T )
			if addCharacterName then row.ItemLabel:AppendText( " (" .. n .. ")" ) end
			wVT.ListBox:AddItem( itemCtl[i] )
			wVT.ButtonDelete:SetVisible( true );
		end
		end
	
	wVT.ListBoxBorder:SetPosition( 15, wVT.searchLabel:GetTop() + wVT.searchLabel:GetHeight() + 5 );
	wVT.ListBoxBorder:SetHeight( Constants.LISTBOX_HEIGHT_STANDARD );
	wVT.ListBox:SetPosition( wVT.ListBoxBorder:GetLeft() + 2, wVT.ListBoxBorder:GetTop() + 2 );
	wVT.ListBox:SetHeight( wVT.ListBoxBorder:GetHeight() - 4 );
	wVT.ListBoxScrollBar:SetHeight( wVT.ListBox:GetHeight() );
	wVT:SetHeight( 520 );
end
