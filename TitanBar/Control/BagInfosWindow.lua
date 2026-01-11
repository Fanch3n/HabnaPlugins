-- BagInfosWindow.lua
-- written by Habna

function frmBagInfos()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	tbackpack = backpack
	SelCN = PN
	import(AppClassD .. "ComboBox")
	local bagInfosDropdown = HabnaPlugins.TitanBar.Class.ComboBox()

	-- Create window using helper with custom configuration
	local wBI = CreateControlWindow(
		"BagInfos", "BI",
		L["BIh"], 390, 560,
		{
			dropdown = bagInfosDropdown,
			onClosing = function(sender, args)
				RemoveCallback(tbackpack, "ItemAdded")
				RemoveCallback(tbackpack, "ItemRemoved")
			end
		}
	)

	-- Set up dropdown after window is created
	bagInfosDropdown:SetParent(wBI)
	bagInfosDropdown:SetSize(Constants.DROPDOWN_WIDTH, Constants.DROPDOWN_HEIGHT)
	bagInfosDropdown:SetPosition(15, 35)
	bagInfosDropdown.dropDownWindow:SetParent(wBI)
	bagInfosDropdown.dropDownWindow:SetPosition(bagInfosDropdown:GetLeft(), bagInfosDropdown:GetTop() + bagInfosDropdown:GetHeight() + 2)

	bagInfosDropdown.ItemChanged = function () -- The event that's executed when a menu item is clicked.
		wBI.SearchTextBox:SetText( "" );
		wBI.SearchTextBox.TextChanged( sender, args );
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
	wBI.searchLabel = CreateTitleLabel(wBI, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	-- Use the factory helper to create a search TextBox + DelIcon
	local searchLeft = wBI.searchLabel:GetLeft() + wBI.searchLabel:GetWidth()
	local searchWidth = wBI:GetWidth() - 150
	local search = CreateSearchControl(wBI, searchLeft, wBI.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	wBI.SearchTextBox = search.TextBox
	wBI.DelIcon = search.DelIcon

	wBI.SearchTextBox.TextChanged = function( sender, args )
		wBI.searchText = string.lower( wBI.SearchTextBox:GetText() );
		if wBI.searchText == "" then wBI.searchText = nil; end
		CountBIItems();
	end

	wBI.SearchTextBox.FocusLost = function( sender, args )
	end

	-- Create list box area via helper
	local lbTop = wBI.searchLabel:GetTop() + wBI.searchLabel:GetHeight() + 5
	local lb = CreateListBoxWithBorder(wBI, 15, lbTop, wBI:GetWidth() - 30, Constants.LISTBOX_HEIGHT_LARGE, Color["grey"])
	wBI.ListBoxBorder = lb.Border
	wBI.ListBox = lb.ListBox
	wBI.ListBoxScrollBar = lb.ScrollBar
	ConfigureListBox(wBI.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])
	-- **v Show used slot info in tooltip? v**
	wBI.UsedSlots = CreateAutoSizedCheckBox(wBI, L["BIUsed"], 30, wBI.ListBox:GetTop() + wBI.ListBox:GetHeight() + 6, BIUsed);

	wBI.UsedSlots.CheckedChanged = function( sender, args )
		_G.BIUsed = wBI.UsedSlots:IsChecked();
		settings.BagInfos.U = _G.BIUsed;
		SaveSettings( false );
		UpdateBackpackInfos();
	end
	-- **^
	-- **v Show max slot in tooltip? v**
	wBI.MaxSlots = CreateAutoSizedCheckBox(wBI, L["BIMax"], 30, wBI.UsedSlots:GetTop() + wBI.UsedSlots:GetHeight(), BIMax);

	wBI.MaxSlots.CheckedChanged = function( sender, args )
		_G.BIMax = wBI.MaxSlots:IsChecked();
		settings.BagInfos.M = _G.BIMax;
		SaveSettings( false );
		UpdateBackpackInfos();
	end
	-- **^
	-- **v Delete character infos button v**
	wBI.ButtonDelete = Turbine.UI.Lotro.Button();
	wBI.ButtonDelete:SetParent( wBI );
	wBI.ButtonDelete:SetText( L["ButDel"] );
	wBI.ButtonDelete:SetSize( wBI.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght

	wBI.ButtonDelete.Click = function( sender, args )
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

	--**v Workaround for the ItemRemoved that fire before the backpack was updated (Turbine API issue) v**
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
	local wBI = _G.ControlData.BI.windowInstance
	backpackCount = 0;
	wBI.ListBox:ClearItems();
	itemCtl = {};
	titem = nil;

	if SelCN == L["VTAll"] then
		wBI.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerBags) do
			if i == PN then backpackCount = tbackpack:GetSize();
			else for k, v in pairs(PlayerBags[i]) do backpackCount = backpackCount + 1; end end
            AddBagsPack(i, true);
			backpackCount = 0;
        end
    else
		if SelCN == PN then wBI.ButtonDelete:SetEnabled( false ); backpackCount = tbackpack:GetSize();
		else wBI.ButtonDelete:SetEnabled( true ); for k, v in pairs(PlayerBags[SelCN]) do backpackCount = backpackCount + 1; end end
		AddBagsPack(SelCN, false);
    end
 
    wBI.ButtonDelete:SetPosition( wBI:GetWidth()/2 - wBI.ButtonDelete:GetWidth()/2, wBI.MaxSlots:GetTop()+ wBI.MaxSlots:GetHeight()+5 );
end

function AddBagsPack(n, addCharacterName)
	local wBI = _G.ControlData.BI.windowInstance
	for i = 1, backpackCount do
		if n == PN then	titem = tbackpack:GetItem(i); if titem ~= nil then itemName = titem:GetName(); else itemName = ""; end
		else titem = PlayerBags[n][tostring(i)]; itemName = PlayerBags[n][tostring(i)].T; end

		if not wBI.searchText or string.find(string.lower( itemName ), wBI.searchText, 1, true) then
			-- Use CreateItemRow helper to build the item row
			local row = CreateItemRow(wBI.ListBox, wBI.ListBox:GetWidth(), 35, (n == PN), (n == PN) and titem or PlayerBags[n][tostring(i)])
			itemCtl[i] = row.Container
			local itemLbl = row.ItemLabel
			if row.ItemQuantity and not (n == PN) then
				-- Ensure quantity is set from saved data
				local data = PlayerBags[n] and PlayerBags[n][tostring(i)]
				if data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
			end

			if (n == PN and titem ~= nil) or (n ~= PN and PlayerBags[n] and PlayerBags[n][tostring(i)]) then
				itemLbl:SetText( itemName )
				wBI.ListBox:AddItem( itemCtl[i] )
			end

			if addCharacterName then itemLbl:AppendText( " (" .. n .. ")" ) end
		end
	end
end
