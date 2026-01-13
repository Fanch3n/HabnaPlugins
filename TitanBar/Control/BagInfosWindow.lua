-- BagInfosWindow.lua
-- written by Habna

function frmBagInfos()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	tbackpack = backpack
	SelCN = PN
	import(AppClassD .. "ComboBox")
	local bagInfosDropdown = HabnaPlugins.TitanBar.Class.ComboBox()

	-- Initialize UI state table
	_G.ControlData.BI = _G.ControlData.BI or {}
	_G.ControlData.BI.ui = _G.ControlData.BI.ui or {}
	local ui = _G.ControlData.BI.ui

	-- Create window using helper with custom configuration
	local wBI = CreateControlWindow(
		"BagInfos", "BI",
		L["BIh"], 390, 560,
		{
			dropdown = bagInfosDropdown,
			onClosing = function(sender, args)
				RemoveCallback(tbackpack, "ItemAdded")
				RemoveCallback(tbackpack, "ItemRemoved")
				_G.ControlData.BI.ui = nil
			end
		}
	)
	ui.window = wBI

	-- Set up dropdown after window is created
	bagInfosDropdown:SetParent(wBI)
	bagInfosDropdown:SetSize(Constants.DROPDOWN_WIDTH, Constants.DROPDOWN_HEIGHT)
	bagInfosDropdown:SetPosition(15, 35)
	bagInfosDropdown.dropDownWindow:SetParent(wBI)
	bagInfosDropdown.dropDownWindow:SetPosition(bagInfosDropdown:GetLeft(), bagInfosDropdown:GetTop() + bagInfosDropdown:GetHeight() + 2)

	bagInfosDropdown.ItemChanged = function (sender, args) -- The event that's executed when a menu item is clicked.
		ui.SearchTextBox:SetText( "" );
		ui.SearchTextBox.TextChanged( sender, args );
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

	ui.searchLabel = CreateTitleLabel(wBI, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	-- Use the factory helper to create a search TextBox + DelIcon
	local searchLeft = ui.searchLabel:GetLeft() + ui.searchLabel:GetWidth()
	local searchWidth = wBI:GetWidth() - 150
	local search = CreateSearchControl(wBI, searchLeft, ui.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	ui.SearchTextBox = search.TextBox
	ui.DelIcon = search.DelIcon

	ui.SearchTextBox.TextChanged = function(sender, args)
		ui.searchText = string.lower(ui.SearchTextBox:GetText());
		if ui.searchText == "" then ui.searchText = nil; end
		CountBIItems();
	end

	-- Create list box area via helper
	local lbTop = ui.searchLabel:GetTop() + ui.searchLabel:GetHeight() + 5
	local lb = CreateListBoxWithBorder(wBI, 15, lbTop, wBI:GetWidth() - 30, Constants.LISTBOX_HEIGHT_LARGE, Color["grey"])
	ui.ListBoxBorder = lb.Border
	ui.ListBox = lb.ListBox
	ui.ListBoxScrollBar = lb.ScrollBar
	ConfigureListBox(ui.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])
	local biData = _G.ControlData.BI
	if biData.used == nil then biData.used = true end
	if biData.max == nil then biData.max = true end

	ui.UsedSlots = CreateAutoSizedCheckBox(wBI, L["BIUsed"], 30, ui.ListBox:GetTop() + ui.ListBox:GetHeight() + 6, biData.used);

	ui.UsedSlots.CheckedChanged = function(sender, args)
		biData.used = ui.UsedSlots:IsChecked();
		settings.BagInfos.U = biData.used;
		SaveSettings( false );
		UpdateBackpackInfos();
	end

	ui.MaxSlots = CreateAutoSizedCheckBox(wBI, L["BIMax"], 30, ui.UsedSlots:GetTop() + ui.UsedSlots:GetHeight(), biData.max);

	ui.MaxSlots.CheckedChanged = function(sender, args)
		biData.max = ui.MaxSlots:IsChecked();
		settings.BagInfos.M = biData.max;
		SaveSettings( false );
		UpdateBackpackInfos();
	end

	ui.ButtonDelete = Turbine.UI.Lotro.Button();
	ui.ButtonDelete:SetParent( wBI );
	ui.ButtonDelete:SetText( L["ButDel"] );
	ui.ButtonDelete:SetSize( ui.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght

	ui.ButtonDelete.Click = function( sender, args )
		PlayerBags[SelCN] = nil;
		SavePlayerBags();
		write(SelCN .. L["BID"]);
		SelCN = PN;
		bagInfosDropdown.selection = -1;
		CreateBIComboBox();
		CountBIItems();
	end

	AddCallback(tbackpack, "ItemAdded", 
		function(sender, args)
		local ui = _G.ControlData.BI and _G.ControlData.BI.ui
		if ui then
			if SelCN == PN then SavePlayerBags(); CountBIItems();
			elseif SelCN == L["VTAll"] then CountBIItems(); end
		end
	end);

	-- Workaround for the ItemRemoved that fire before the backpack was updated (Turbine API issue)
	BIItemRemovedTimer = Turbine.UI.Control();
	BIItemRemovedTimer.Update = function( sender, args )
		BIItemRemovedTimer:SetWantsUpdates( false );
		local ui = _G.ControlData.BI and _G.ControlData.BI.ui
		if ui then
			if SelCN == PN then SavePlayerBags(); CountBIItems();
			elseif SelCN == L["VTAll"] then CountBIItems(); end
		end
	end

	AddCallback(tbackpack, "ItemRemoved", function(sender, args) BIItemRemovedTimer:SetWantsUpdates( true ); end); --Workaround

	CountBIItems();
    
end

function CountBIItems()
	local ui = _G.ControlData.BI and _G.ControlData.BI.ui
	if not ui then return end
	backpackCount = 0;
	ui.ListBox:ClearItems();
	itemCtl = {};
	titem = nil;

	if SelCN == L["VTAll"] then
		ui.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerBags) do
			if i == PN then backpackCount = tbackpack:GetSize();
			else for k, v in pairs(PlayerBags[i]) do backpackCount = backpackCount + 1; end end
            AddBagsPack(i, true);
			backpackCount = 0;
        end
    else
		if SelCN == PN then ui.ButtonDelete:SetEnabled( false ); backpackCount = tbackpack:GetSize();
		else ui.ButtonDelete:SetEnabled( true ); for k, v in pairs(PlayerBags[SelCN]) do backpackCount = backpackCount + 1; end end
		AddBagsPack(SelCN, false);
    end
 
    ui.ButtonDelete:SetPosition( ui.window:GetWidth()/2 - ui.ButtonDelete:GetWidth()/2, ui.MaxSlots:GetTop()+ ui.MaxSlots:GetHeight()+5 );
end

function AddBagsPack(n, addCharacterName)
	local ui = _G.ControlData.BI and _G.ControlData.BI.ui
	if not ui then return end
	for i = 1, backpackCount do
		if n == PN then	titem = tbackpack:GetItem(i); if titem ~= nil then itemName = titem:GetName(); else itemName = ""; end
		else titem = PlayerBags[n][tostring(i)]; itemName = PlayerBags[n][tostring(i)].T; end

		if not ui.searchText or string.find(string.lower( itemName ), ui.searchText, 1, true) then
			-- Use CreateItemRow helper to build the item row
			local row = CreateItemRow(ui.ListBox, ui.ListBox:GetWidth(), 35, (n == PN), (n == PN) and titem or PlayerBags[n][tostring(i)])
			itemCtl[i] = row.Container
			local itemLbl = row.ItemLabel
			if row.ItemQuantity and not (n == PN) then
				-- Ensure quantity is set from saved data
				local data = PlayerBags[n] and PlayerBags[n][tostring(i)]
				if data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
			end

			if (n == PN and titem ~= nil) or (n ~= PN and PlayerBags[n] and PlayerBags[n][tostring(i)]) then
				itemLbl:SetText( itemName )
				ui.ListBox:AddItem( itemCtl[i] )
			end

			if addCharacterName then itemLbl:AppendText( " (" .. n .. ")" ) end
		end
	end
end
