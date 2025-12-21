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

		-- Use PopulateDropDown helper: include an "All" option and select current player if present
		PopulateDropDown(bagInfosDropdown, newt, true, L["VTAll"], PN)
	end
	CreateBIComboBox()
	-- **^
	-- **v search label & text box v**
	_G.wBI.searchLabel = CreateTitleLabel(_G.wBI, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	-- Use the factory helper to create a search TextBox + DelIcon
	local searchLeft = _G.wBI.searchLabel:GetLeft() + _G.wBI.searchLabel:GetWidth()
	local searchWidth = _G.wBI:GetWidth() - 150
	local search = CreateSearchControl(_G.wBI, searchLeft, _G.wBI.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	_G.wBI.SearchTextBox = search.TextBox
	_G.wBI.DelIcon = search.DelIcon

	_G.wBI.SearchTextBox.TextChanged = function( sender, args )
		_G.wBI.searchText = string.lower( _G.wBI.SearchTextBox:GetText() );
		if _G.wBI.searchText == "" then _G.wBI.searchText = nil; end
		CountBIItems();
	end

	_G.wBI.SearchTextBox.FocusLost = function( sender, args )
	end

	-- Create list box area via helper
	local lbTop = _G.wBI.SearchTextBox:GetTop() + _G.wBI.SearchTextBox:GetHeight() + 5
	local lb = CreateListBoxWithBorder(_G.wBI, 15, lbTop, _G.wBI:GetWidth() - 30, 392, Color["grey"])
	_G.wBI.ListBoxBorder = lb.Border
	_G.wBI.ListBox = lb.ListBox
	_G.wBI.ListBoxScrollBar = lb.ScrollBar
	_G.wBI.ListBox:SetMaxItemsPerLine( 1 );
	_G.wBI.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	_G.wBI.ListBox:SetBackColor( Color["black"] );
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
			-- Use CreateItemRow helper to build the item row
			local row = CreateItemRow(_G.wBI.ListBox, _G.wBI.ListBox:GetWidth(), 35, (n == PN), (n == PN) and titem or PlayerBags[n][tostring(i)])
			itemCtl[i] = row.Container
			local itemLbl = row.ItemLabel
			if row.ItemQuantity and not (n == PN) then
				-- Ensure quantity is set from saved data
				local data = PlayerBags[n] and PlayerBags[n][tostring(i)]
				if data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
			end

			if (n == PN and titem ~= nil) or (n ~= PN and PlayerBags[n] and PlayerBags[n][tostring(i)]) then
				itemLbl:SetText( itemName )
				_G.wBI.ListBox:AddItem( itemCtl[i] )
			end

			if addCharacterName then itemLbl:AppendText( " (" .. n .. ")" ) end
		end
	end
end