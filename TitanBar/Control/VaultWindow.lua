-- VaultWindow.lua
-- written by Habna


function frmVault()
	tvaultpack = vaultpack;
	SelCN = PN;
	import (AppClassD.."ComboBox");
	VICB = HabnaPlugins.TitanBar.Class.ComboBox();

	-- **v Set some window stuff v**
	import(AppDirD .. "WindowFactory")

	-- Create window via factory
	_G.wVT = CreateWindow({
		text = L["MVault"],
		width = 390,
		height = 520,
		left = VTWLeft,
		top = VTWTop,
		config = {
			dropdown = VICB,
			settingsKey = "Vault",
			windowGlobalVar = "wVT",
			formGlobalVar = "frmVT",
			onPositionChanged = function(left, top)
				VTWLeft, VTWTop = left, top
			end,
			onClosing = function(sender, args)
				if VICB and VICB.dropDownWindow then VICB.dropDownWindow:SetVisible(false) end
				RemoveCallback( tvaultpack, "CountChanged" )
			end,
		}
	})

	-- **^
	-- **v Create drop down box v**
	VICB:SetParent( _G.wVT );
	VICB:SetSize( 159, 19 );
	VICB:SetPosition( 15, 35 );

	VICB.dropDownWindow:SetParent( _G.wVT );
	VICB.dropDownWindow:SetPosition(VICB:GetLeft(), VICB:GetTop() + VICB:GetHeight()+2);

	VICB.ItemChanged = function( sender, args ) -- The event that's executed when a menu item is clicked.
		_G.wVT.SearchTextBox:SetText( "" );
		_G.wVT.SearchTextBox.TextChanged( sender, args );
		SelCN = VICB.label:GetText();
		CountVIItems();
	end

	CreateVIComboBox();
	-- **^
	-- **v search label & text box v**
	-- **v search label & text box v**
	_G.wVT.searchLabel = CreateTitleLabel(_G.wVT, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = _G.wVT.searchLabel:GetLeft() + _G.wVT.searchLabel:GetWidth()
	local searchWidth = _G.wVT:GetWidth() - 150
	local search = CreateSearchControl(_G.wVT, searchLeft, _G.wVT.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	_G.wVT.SearchTextBox = search.TextBox
	_G.wVT.DelIcon = search.DelIcon

	_G.wVT.SearchTextBox.TextChanged = function( sender, args )
		_G.wVT.searchText = string.lower( _G.wVT.SearchTextBox:GetText() );
		if _G.wVT.searchText == "" then _G.wVT.searchText = nil; end
		CountVIItems();
	end

	_G.wVT.SearchTextBox.FocusLost = function( sender, args )
	end

	local lbTop = 60
	local lb = CreateListBoxWithBorder(_G.wVT, 15, lbTop, _G.wVT:GetWidth() - 30, 392, Color["grey"])
	_G.wVT.ListBoxBorder = lb.Border
	_G.wVT.ListBox = lb.ListBox
	_G.wVT.ListBoxScrollBar = lb.ScrollBar
	_G.wVT.ListBox:SetMaxItemsPerLine( 1 );
	_G.wVT.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	_G.wVT.ListBox:SetBackColor( Color["black"] );
	-- **v Delete character infos button v**
	_G.wVT.ButtonDelete = Turbine.UI.Lotro.Button();
	_G.wVT.ButtonDelete:SetParent( _G.wVT );
	_G.wVT.ButtonDelete:SetText( L["ButDel"] );
	_G.wVT.ButtonDelete:SetSize( _G.wVT.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght

	_G.wVT.ButtonDelete.Click = function( sender, args )
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
		if frmVT then
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
	local vaultpackCount = 0;
	_G.wVT.ListBox:ClearItems();
	itemCtl = {};

	if SelCN == L["VTAll"] then
		_G.wVT.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerVault) do
			for k, v in pairs(PlayerVault[i]) do vaultpackCount = vaultpackCount + 1; end
            AddVaultPack(i, true, vaultpackCount);
			vaultpackCount = 0;
        end
    else
		if SelCN == PN then _G.wVT.ButtonDelete:SetEnabled( false );
		else _G.wVT.ButtonDelete:SetEnabled( true ); end
		for k, v in pairs(PlayerVault[SelCN]) do vaultpackCount = vaultpackCount + 1; end
		if vaultpackCount == 0 then SetEmptyVault();
		else AddVaultPack(SelCN, false, vaultpackCount); end
    end
 
    _G.wVT.ButtonDelete:SetPosition( _G.wVT:GetWidth()/2 - _G.wVT.ButtonDelete:GetWidth()/2, _G.wVT.ListBox:GetTop()+_G.wVT.ListBox:GetHeight()+10 );
end

function SetEmptyVault()
	local itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( _G.wVT.ListBox:GetWidth(), 35 );

	local lblmgs = CreateTitleLabel(itemCtl, L["VTnd"], 0, 0, nil, Color["green"], nil, itemCtl:GetWidth(), itemCtl:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

	_G.wVT.ListBox:AddItem( itemCtl );
	_G.wVT.ButtonDelete:SetVisible( false );

	_G.wVT.ListBoxBorder:SetPosition( 15, 60 );
	_G.wVT.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	_G.wVT.ListBox:SetPosition( _G.wVT.ListBoxBorder:GetLeft() + 2, _G.wVT.ListBoxBorder:GetTop() + 2 );
	_G.wVT.ListBox:SetHeight( lblmgs:GetHeight() )
	_G.wVT.ListBoxScrollBar:SetVisible( false );
	_G.wVT:SetHeight( itemCtl:GetHeight() + 85 );
end

function AddVaultPack(n, addCharacterName, vaultpackCount)
	for i = 1, vaultpackCount do
		local itemName = PlayerVault[n][tostring(i)].T;
		if not _G.wVT.searchText or string.find(string.lower( itemName ), _G.wVT.searchText, 1, true) then
			-- Use CreateItemRow for vault item
			local data = PlayerVault[n][tostring(i)]
			local row = CreateItemRow(_G.wVT.ListBox, _G.wVT.ListBox:GetWidth(), 35, false, data)
			itemCtl[i] = row.Container
			if row.ItemQuantity and data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
			row.ItemLabel:SetText( data.T )
			if addCharacterName then row.ItemLabel:AppendText( " (" .. n .. ")" ) end
			_G.wVT.ListBox:AddItem( itemCtl[i] )
			_G.wVT.ButtonDelete:SetVisible( true );
		end
	end
	
	_G.wVT.ListBoxBorder:SetPosition( 15, _G.wVT.SearchTextBox:GetTop() + _G.wVT.SearchTextBox:GetHeight() + 5 );
	_G.wVT.ListBoxBorder:SetHeight( 392 );
	_G.wVT.ListBox:SetPosition( _G.wVT.ListBoxBorder:GetLeft() + 2, _G.wVT.ListBoxBorder:GetTop() + 2 );
	_G.wVT.ListBox:SetHeight( _G.wVT.ListBoxBorder:GetHeight() - 4 );
	_G.wVT.ListBoxScrollBar:SetHeight( _G.wVT.ListBox:GetHeight() );
	_G.wVT:SetHeight( 520 );
end