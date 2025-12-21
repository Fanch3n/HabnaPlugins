-- BagInfosWindow.lua
-- written by Habna

function frmBagInfos()
	import(AppDirD .. "WindowFactory")
	tbackpack = backpack
	SelCN = PN
	import(AppClassD .. "ComboBox")
	local bagInfosDropdown = HabnaPlugins.TitanBar.Class.ComboBox()

	-- Create window using factory with custom configuration
	_G.wBI = CreateWindow({
		text = L["BIh"],
		width = 390,
		height = 560,
		left = BIWLeft,
		top = BIWTop,
		config = {
			dropdown = bagInfosDropdown,
			settingsKey = "BagInfos",
			windowGlobalVar = "wBI",
			formGlobalVar = "frmBI",
			onPositionChanged = function(left, top)
				BIWLeft, BIWTop = left, top
			end,
			onClosing = function(sender, args)
				RemoveCallback(tbackpack, "ItemAdded")
				RemoveCallback(tbackpack, "ItemRemoved")
			end
		}
	})

	-- Set up dropdown after window is created
	bagInfosDropdown:SetParent(_G.wBI)
	bagInfosDropdown:SetSize(159, 19)
	bagInfosDropdown:SetPosition(15, 35)
	bagInfosDropdown.dropDownWindow:SetParent(_G.wBI)
	bagInfosDropdown.dropDownWindow:SetPosition(bagInfosDropdown:GetLeft(), bagInfosDropdown:GetTop() + bagInfosDropdown:GetHeight() + 2)

	bagInfosDropdown.ItemChanged = function () -- The event that's executed when a menu item is clicked.
		_G.wBI.SearchTextBox:SetText( "" );
		_G.wBI.SearchTextBox.TextChanged( sender, args );
		SelCN = bagInfosDropdown.label:GetText();
		CountBIItems();
	end

	-- CreateBIComboBox: populate the dropdown with character names
	local function CreateBIComboBox()
		local newt = {}
		if type(PlayerBags) == "table" then
			for i in pairs(PlayerBags) do
				if string.sub(i,1,1) ~= "~" then
					table.insert(newt, i)
				end
			end
		end
		table.sort(newt)

		bagInfosDropdown.listBox:ClearItems()
		bagInfosDropdown:AddItem(L["VTAll"], 0)

		local selIndex = nil
		for k, v in ipairs(newt) do
			bagInfosDropdown:AddItem(v, k)
			if v == PN then selIndex = k end
		end

		if selIndex then
			bagInfosDropdown:SetSelection(selIndex)
		end
	end
	CreateBIComboBox()
	-- **^
	-- **v search label & text box v**
	_G.wBI.searchLabel = Turbine.UI.Label();
    _G.wBI.searchLabel:SetParent( _G.wBI );
    _G.wBI.searchLabel:SetText( L["VTSe"] );
    _G.wBI.searchLabel:SetPosition( 15, 60 );
    _G.wBI.searchLabel:SetSize( _G.wBI.searchLabel:GetTextLength() * 8, 18 ); --Auto size with text lenght
    _G.wBI.searchLabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro15 );
    _G.wBI.searchLabel:SetForeColor( Color["gold"] );
	 
    _G.wBI.SearchTextBox = Turbine.UI.Lotro.TextBox();
    _G.wBI.SearchTextBox:SetParent( _G.wBI );
    _G.wBI.SearchTextBox:SetPosition(  _G.wBI.searchLabel:GetLeft() +  _G.wBI.searchLabel:GetWidth(),  _G.wBI.searchLabel:GetTop() );
    _G.wBI.SearchTextBox:SetSize( _G.wBI:GetWidth() - 150, 18 );
    _G.wBI.SearchTextBox:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	_G.wBI.SearchTextBox:SetMultiline( false );
	
    _G.wBI.SearchTextBox.TextChanged = function( sender, args )
        _G.wBI.searchText = string.lower( _G.wBI.SearchTextBox:GetText() );
        if _G.wBI.searchText == "" then _G.wBI.searchText = nil; end
        CountBIItems();
    end

	_G.wBI.SearchTextBox.FocusLost = function( sender, args )
		
	end
	-- **^
	--**v clear search text box icon v**
	_G.wBI.DelIcon = Turbine.UI.Label();
	_G.wBI.DelIcon:SetParent( _G.wBI );
	_G.wBI.DelIcon:SetPosition( _G.wBI.SearchTextBox:GetLeft() + _G.wBI.SearchTextBox:GetWidth() + 5, _G.wBI.SearchTextBox:GetTop() );
	_G.wBI.DelIcon:SetSize( 16, 16 );
	_G.wBI.DelIcon:SetBackground( resources.DelIcon );
	_G.wBI.DelIcon:SetBlendMode( 4 );
	_G.wBI.DelIcon:SetVisible( true );
				
	_G.wBI.DelIcon.MouseClick = function( sender, args )
		_G.wBI.SearchTextBox:SetText( "" );
		_G.wBI.SearchTextBox.TextChanged( sender, args );
		_G.wBI.SearchTextBox:Focus();
	end
	-- **^
	-- **v Set the item listbox border v**
	_G.wBI.ListBoxBorder = Turbine.UI.Control();
	_G.wBI.ListBoxBorder:SetParent( _G.wBI );
	_G.wBI.ListBoxBorder:SetPosition( 15, _G.wBI.SearchTextBox:GetTop() + _G.wBI.SearchTextBox:GetHeight() + 5 );
	_G.wBI.ListBoxBorder:SetSize( _G.wBI:GetWidth() - 30, 392 );
	_G.wBI.ListBoxBorder:SetBackColor( Color["grey"] );
	_G.wBI.ListBoxBorder:SetVisible( true );
	-- **^
	-- **v Set the item listbox v**
	_G.wBI.ListBox = Turbine.UI.ListBox();
	_G.wBI.ListBox:SetParent( _G.wBI );
	_G.wBI.ListBox:SetPosition( _G.wBI.ListBoxBorder:GetLeft() + 2, _G.wBI.ListBoxBorder:GetTop() + 2 );
	_G.wBI.ListBox:SetSize( _G.wBI.ListBoxBorder:GetWidth() - 4, _G.wBI.ListBoxBorder:GetHeight() - 4 );
	_G.wBI.ListBox:SetMaxItemsPerLine( 1 );
	_G.wBI.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	_G.wBI.ListBox:SetBackColor( Color["black"] );
	-- **^
	-- **v Set the listbox scrollbar v**
	_G.wBI.ListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	_G.wBI.ListBoxScrollBar:SetParent( _G.wBI.ListBox );
	_G.wBI.ListBoxScrollBar:SetPosition( _G.wBI.ListBox:GetWidth() - 10, 0 );
	_G.wBI.ListBoxScrollBar:SetSize( 12, _G.wBI.ListBox:GetHeight() );
	_G.wBI.ListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	_G.wBI.ListBox:SetVerticalScrollBar( _G.wBI.ListBoxScrollBar );
	-- **^
	-- **v Show used slot info in tooltip? v**
	_G.wBI.UsedSlots = Turbine.UI.Lotro.CheckBox();
	_G.wBI.UsedSlots:SetParent( _G.wBI );
	_G.wBI.UsedSlots:SetPosition( 30, _G.wBI.ListBox:GetTop() + _G.wBI.ListBox:GetHeight() + 6 );
	_G.wBI.UsedSlots:SetText( L["BIUsed"] );
	_G.wBI.UsedSlots:SetSize( _G.wBI.UsedSlots:GetTextLength() * 8.5, 20 );
	_G.wBI.UsedSlots:SetChecked( BIUsed );
	_G.wBI.UsedSlots:SetForeColor( Color["rustedgold"] );

	_G.wBI.UsedSlots.CheckedChanged = function( sender, args )
		_G.BIUsed = _G.wBI.UsedSlots:IsChecked();
		settings.BagInfos.U = _G.BIUsed;
		SaveSettings( false );
		UpdateBackpackInfos();
	end
	-- **^
	-- **v Show max slot in tooltip? v**
	_G.wBI.MaxSlots = Turbine.UI.Lotro.CheckBox();
	_G.wBI.MaxSlots:SetParent( _G.wBI );
	_G.wBI.MaxSlots:SetPosition( 30, _G.wBI.UsedSlots:GetTop() + _G.wBI.UsedSlots:GetHeight() );
	_G.wBI.MaxSlots:SetText( L["BIMax"] );
	_G.wBI.MaxSlots:SetSize( _G.wBI.MaxSlots:GetTextLength() * 8.5, 20 );
	_G.wBI.MaxSlots:SetChecked( BIMax );
	_G.wBI.MaxSlots:SetForeColor( Color["rustedgold"] );

	_G.wBI.MaxSlots.CheckedChanged = function( sender, args )
		_G.BIMax = _G.wBI.MaxSlots:IsChecked();
		settings.BagInfos.M = _G.BIMax;
		SaveSettings( false );
		UpdateBackpackInfos();
	end
	-- **^
	-- **v Delete character infos button v**
	_G.wBI.ButtonDelete = Turbine.UI.Lotro.Button();
	_G.wBI.ButtonDelete:SetParent( _G.wBI );
	_G.wBI.ButtonDelete:SetText( L["ButDel"] );
	_G.wBI.ButtonDelete:SetSize( _G.wBI.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght

	_G.wBI.ButtonDelete.Click = function( sender, args )
		PlayerBags[SelCN] = nil;
		SavePlayerBags();
		write(SelCN .. L["BID"]);
		SelCN = PN;
		bagInfosDropdown.selection = -1;
		CreateBIComboBox();
		CountBIItems();
	end
	-- **^

	AddCallback(tbackpack, "ItemAdded", 
		function(sender, args)
		if frmBI then
			if SelCN == PN then SavePlayerBags(); CountBIItems();
			elseif SelCN == L["VTAll"] then CountBIItems(); end
		end
	end);

	--**v Workaround for the ItemRemoved that fire before the backpack was updated (Turnine API issue) v**
	BIItemRemovedTimer = Turbine.UI.Control();
	BIItemRemovedTimer.Update = function( sender, args )
		BIItemRemovedTimer:SetWantsUpdates( false );
		if frmBI then
			if SelCN == PN then SavePlayerBags(); CountBIItems();
			elseif SelCN == L["VTAll"] then CountBIItems(); end
		end
	end

	AddCallback(tbackpack, "ItemRemoved", function(sender, args) BIItemRemovedTimer:SetWantsUpdates( true ); end); --Workaround

	CountBIItems();
    
end

function CountBIItems()
	backpackCount = 0;
	_G.wBI.ListBox:ClearItems();
	itemCtl = {};
	titem = nil;

	if SelCN == L["VTAll"] then
		_G.wBI.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerBags) do
			if i == PN then backpackCount = tbackpack:GetSize();
			else for k, v in pairs(PlayerBags[i]) do backpackCount = backpackCount + 1; end end
            AddBagsPack(i, true);
			backpackCount = 0;
        end
    else
		if SelCN == PN then _G.wBI.ButtonDelete:SetEnabled( false ); backpackCount = tbackpack:GetSize();
		else _G.wBI.ButtonDelete:SetEnabled( true ); for k, v in pairs(PlayerBags[SelCN]) do backpackCount = backpackCount + 1; end end
		AddBagsPack(SelCN, false);
    end
 
    _G.wBI.ButtonDelete:SetPosition( _G.wBI:GetWidth()/2 - _G.wBI.ButtonDelete:GetWidth()/2, _G.wBI.MaxSlots:GetTop()+ _G.wBI.MaxSlots:GetHeight()+5 );
end

function AddBagsPack(n, addCharacterName)
	for i = 1, backpackCount do
		if n == PN then	titem = tbackpack:GetItem(i); if titem ~= nil then itemName = titem:GetName(); else itemName = ""; end
		else titem = PlayerBags[n][tostring(i)]; itemName = PlayerBags[n][tostring(i)].T; end

		if not _G.wBI.searchText or string.find(string.lower( itemName ), _G.wBI.searchText, 1, true) then
			-- Item control
			itemCtl[i] = Turbine.UI.Control();
			itemCtl[i]:SetSize( _G.wBI.ListBox:GetWidth() - 10, 35 );

			if n == PN then
				-- Item Background/Underlay/Shadow/Image
				local itemBG = Turbine.UI.Lotro.ItemControl( titem );
				itemBG:SetParent( itemCtl[i] );
				itemBG:SetSize( 34, 34 );
				itemBG:SetPosition( 0, 0 );
			else
				-- Item Background
				local itemBG = Turbine.UI.Control();
				itemBG:SetParent( itemCtl[i] );
				itemBG:SetSize( 32, 32 );
				itemBG:SetPosition( 3, 3 );
				if PlayerBags[n][tostring(i)].B ~= "0" then itemBG:SetBackground( tonumber(PlayerBags[n][tostring(i)].B) ); end
				itemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
				-- Item Underlay
				local itemU = Turbine.UI.Control();
				itemU:SetParent( itemCtl[i] );
				itemU:SetSize( 32, 32 );
				itemU:SetPosition( 3, 3 );
				if PlayerBags[n][tostring(i)].U ~= "0" then itemU:SetBackground( tonumber(PlayerBags[n][tostring(i)].U) ); end
				itemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
				-- Item Shadow
				local itemS = Turbine.UI.Control();
				itemS:SetParent( itemCtl[i] );
				itemS:SetSize( 32, 32 );
				itemS:SetPosition( 3, 3 );
				if PlayerBags[n][tostring(i)].S ~= "0" then itemS:SetBackground( tonumber(PlayerBags[n][tostring(i)].S) ); end
				itemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
				-- Item Image
				local item = Turbine.UI.Control();
				item:SetParent( itemCtl[i] );
				item:SetSize( 32, 32 );
				item:SetPosition( 3, 3 );
				if PlayerBags[n][tostring(i)].I ~= "0" then item:SetBackground( tonumber(PlayerBags[n][tostring(i)].I) ); end
				item:SetBlendMode( Turbine.UI.BlendMode.Overlay );

				-- Item Quantity
				local itemQTE = Turbine.UI.Label();
				itemQTE:SetParent( itemCtl[i] );
				itemQTE:SetSize( 32, 15 );
				itemQTE:SetPosition( -4, 16 );
				itemQTE:SetFont( Turbine.UI.Lotro.Font.Verdana12 );
				itemQTE:SetFontStyle( Turbine.UI.FontStyle.Outline );
				itemQTE:SetOutlineColor( Color["black"] );
				itemQTE:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
				itemQTE:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
				itemQTE:SetForeColor( Color["nicegold"] );
				itemQTE:SetText( tonumber(PlayerBags[n][tostring(i)].N) );
			end

			-- Item name
			local itemLbl = Turbine.UI.Label();
			itemLbl:SetParent( itemCtl[i] );
			itemLbl:SetSize( itemCtl[i]:GetWidth() - 35, 35 );
			itemLbl:SetPosition( 37, 2 );
			itemLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
			itemLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			itemLbl:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
			itemLbl:SetForeColor( Color["white"] );

			if titem ~= nil then
				itemLbl:SetText( itemName );
				_G.wBI.ListBox:AddItem( itemCtl[i] );
			end

			if addCharacterName then itemLbl:AppendText( " (" .. n .. ")" ); end
		end
	end
end