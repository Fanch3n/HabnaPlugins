-- VaultWindow.lua
-- written by Habna


function frmVault()
	tvaultpack = vaultpack;
	SelCN = PN;
	import (AppClassD.."ComboBox");
	VICB = HabnaPlugins.TitanBar.Class.ComboBox();
	import(AppDirD .. "WindowFactory")

	-- Initialize UI state table
	_G.ControlData.VT = _G.ControlData.VT or {}
	_G.ControlData.VT.ui = _G.ControlData.VT.ui or {}
	local ui = _G.ControlData.VT.ui

	-- Create window via helper
	local wVT = CreateControlWindow(
		"Vault", "VT",
		L["MVault"], 390, 520,
		{
			dropdown = VICB,
			onClosing = function(sender, args)
				if VICB and VICB.dropDownWindow then VICB.dropDownWindow:SetVisible(false) end
				RemoveCallback( tvaultpack, "CountChanged" )
				_G.ControlData.VT.ui = { control = nil, optCheckbox = nil }
			end
		}
	)
	ui.window = wVT

	-- Set up dropdown after window is created
	VICB:SetParent(wVT)
	VICB:SetSize(Constants.DROPDOWN_WIDTH, Constants.DROPDOWN_HEIGHT)
	VICB:SetPosition(15, 35)
	VICB.dropDownWindow:SetParent(wVT)
	VICB.dropDownWindow:SetPosition(VICB:GetLeft(), VICB:GetTop() + VICB:GetHeight() + 2)

	VICB.ItemChanged = function(sender, args)
		ui.SearchTextBox:SetText("");
		ui.SearchTextBox.TextChanged(sender, args);
		SelCN = VICB.label:GetText();
		CountVIItems();
	end

	CreateVIComboBox();

	ui.searchLabel = CreateTitleLabel(wVT, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = ui.searchLabel:GetLeft() + ui.searchLabel:GetWidth()
	local searchWidth = wVT:GetWidth() - 150
	local search = CreateSearchControl(wVT, searchLeft, ui.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	ui.SearchTextBox = search.TextBox
	ui.DelIcon = search.DelIcon

	ui.SearchTextBox.TextChanged = function(sender, args)
		ui.searchText = string.lower(ui.SearchTextBox:GetText());
		if ui.searchText == "" then ui.searchText = nil; end
		CountVIItems();
	end

	local lbTop = 85
	local lb = CreateListBoxWithBorder(wVT, 15, lbTop, wVT:GetWidth() - 30, Constants.LISTBOX_HEIGHT_STANDARD, Color["grey"])
	ui.ListBoxBorder = lb.Border
	ui.ListBox = lb.ListBox
	ui.ListBoxScrollBar = lb.ScrollBar
	ui.ListBox:SetMaxItemsPerLine(1);
	ConfigureListBox(ui.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])

	ui.ButtonDelete = Turbine.UI.Lotro.Button();
	ui.ButtonDelete:SetParent( wVT );
	ui.ButtonDelete:SetText( L["ButDel"] );
	ui.ButtonDelete:SetSize( ui.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght

	ui.ButtonDelete.Click = function( sender, args )
		PlayerVault[SelCN] = nil;
		SavePlayerVault();
		write( SelCN .. L["VTID"] );
		SelCN = PN;
		VICB.selection = -1;
		CreateVIComboBox();
		CountVIItems();
	end

	AddCallback(tvaultpack, "CountChanged", 
		function(sender, args)
		local ui = _G.ControlData.VT and _G.ControlData.VT.ui
		if ui then
			if SelCN == PN or SelCN == L["VTAll"] then CountVIItems(); end
		end
	end);

	CountVIItems();
end

function CreateVIComboBox()
	local newt = {}
	for i in pairs(PlayerVault) do
		if string.sub( i, 1, 1 ) == "~" then PlayerVault[i] = nil; else table.insert(newt,i); end --Delete session play character
	end
	table.sort(newt);
	-- Use PopulateDropDown helper (adds All and selects PN if present)
	PopulateDropDown(VICB, newt, true, L["VTAll"], PN)
end

function CountVIItems()
	local ui = _G.ControlData.VT and _G.ControlData.VT.ui
	if not ui then return end
	local vaultpackCount = 0;
	ui.ListBox:ClearItems();
	itemCtl = {};

	if SelCN == L["VTAll"] then
		ui.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerVault) do
			for k, v in pairs(PlayerVault[i]) do vaultpackCount = vaultpackCount + 1; end
            AddVaultPack(i, true, vaultpackCount);
			vaultpackCount = 0;
        end
    else
		if SelCN == PN then ui.ButtonDelete:SetEnabled( false );
		else ui.ButtonDelete:SetEnabled( true ); end
		for k, v in pairs(PlayerVault[SelCN]) do vaultpackCount = vaultpackCount + 1; end
		if vaultpackCount == 0 then SetEmptyVault();
		else AddVaultPack(SelCN, false, vaultpackCount); end
    end
 
    ui.ButtonDelete:SetPosition( ui.window:GetWidth()/2 - ui.ButtonDelete:GetWidth()/2, ui.ListBox:GetTop()+ui.ListBox:GetHeight()+10 );
end

function SetEmptyVault()
	local ui = _G.ControlData.VT and _G.ControlData.VT.ui
	if not ui then return end
	local itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( ui.ListBox:GetWidth(), 35 );

	local lblmgs = CreateTitleLabel(itemCtl, L["VTnd"], 0, 0, nil, Color["green"], nil, itemCtl:GetWidth(), itemCtl:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

	ui.ListBox:AddItem( itemCtl );
	ui.ButtonDelete:SetVisible( false );

	ui.ListBoxBorder:SetPosition( 15, 85 );
	ui.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	ui.ListBox:SetPosition( ui.ListBoxBorder:GetLeft() + 2, ui.ListBoxBorder:GetTop() + 2 );
	ui.ListBox:SetHeight( lblmgs:GetHeight() )
	ui.ListBoxScrollBar:SetVisible( false );
	ui.window:SetHeight( itemCtl:GetHeight() + 85 );
end

function AddVaultPack(n, addCharacterName, vaultpackCount)
	local ui = _G.ControlData.VT and _G.ControlData.VT.ui
	if not ui then return end
	for i = 1, vaultpackCount do
		local itemName = PlayerVault[n][tostring(i)].T;
		if not ui.searchText or string.find(string.lower( itemName ), ui.searchText, 1, true) then
			-- Use CreateItemRow for vault item
			local data = PlayerVault[n][tostring(i)]
			local row = CreateItemRow(nil, ui.ListBox:GetWidth(), 35, false, data)
			itemCtl[i] = row.Container
			if row.ItemQuantity and data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
			row.ItemLabel:SetText( data.T )
			if addCharacterName then row.ItemLabel:AppendText( " (" .. n .. ")" ) end
			ui.ListBox:AddItem( itemCtl[i] )
			ui.ButtonDelete:SetVisible( true );
		end
		end
	
	ui.ListBoxBorder:SetPosition( 15, ui.searchLabel:GetTop() + ui.searchLabel:GetHeight() + 5 );
	ui.ListBoxBorder:SetHeight( Constants.LISTBOX_HEIGHT_STANDARD );
	ui.ListBox:SetPosition( ui.ListBoxBorder:GetLeft() + 2, ui.ListBoxBorder:GetTop() + 2 );
	ui.ListBox:SetHeight( ui.ListBoxBorder:GetHeight() - 4 );
	ui.ListBoxScrollBar:SetHeight( ui.ListBox:GetHeight() );
	ui.window:SetHeight( 520 );
    ui.ListBox:SetMaxItemsPerLine(2)
    ui.ListBox:SetMaxItemsPerLine(1)
end
