-- TrackItemsWindow.lua
-- Written by Habna


local player = Turbine.Gameplay.LocalPlayer.GetInstance();
local backpack = player:GetBackpack();
local size = backpack:GetSize();

local item, itemCtl, itemLbl -- filled by CheckForStackableItems()

function frmTrackItemsWindow()
	import(AppDirD .. "WindowFactory")

	-- Initialize UI state table
	_G.ControlData.TI = _G.ControlData.TI or {}
	_G.ControlData.TI.ui = _G.ControlData.TI.ui or {}
	local ui = _G.ControlData.TI.ui
	ui.itemState = {} -- Track per-item selection state

	-- The rows show the items themselves, which are gone when they leave the bags: the list is built again
	-- when the bags change. ItemRemoved fires before the backpack was updated (Turbine API issue),
	-- so that rebuild waits one frame.
	local delayedRefresh = Turbine.UI.Control()
	delayedRefresh.Update = function(sender, args)
		delayedRefresh:SetWantsUpdates(false)
		CheckForStackableItems()
	end
	local onItemAdded = function(sender, args) CheckForStackableItems() end
	local onItemRemoved = function(sender, args) delayedRefresh:SetWantsUpdates(true) end
	AddCallback(backpack, "ItemAdded", onItemAdded)
	AddCallback(backpack, "ItemRemoved", onItemRemoved)

	-- Create window via helper
	local wTI = CreateControlWindow(
		"BagInfos", "TI",
		L["BIIL"], 390, 498,
		{
			onClosing = function(sender, args)
				RemoveCallback(backpack, "ItemAdded", onItemAdded)
				RemoveCallback(backpack, "ItemRemoved", onItemRemoved)
				delayedRefresh:SetWantsUpdates(false)
				_G.ControlData.TI.ui = { control = nil, optCheckbox = nil }
			end
		}
	)
	ui.window = wTI

	ui.lblBackPack = Turbine.UI.Label();
	ui.lblBackPack:SetParent( wTI );
	ui.lblBackPack:SetText( L["BIT"] );
	ui.lblBackPack:SetPosition( 0, 35);
	ui.lblBackPack:SetSize( wTI:GetWidth() , 15 );
	ui.lblBackPack:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	ui.lblBackPack:SetForeColor( Color["green"] );

	ui.searchLabel = CreateTitleLabel(wTI, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = ui.searchLabel:GetLeft() + ui.searchLabel:GetWidth()
	local searchWidth = wTI:GetWidth() - 150
	local search = CreateSearchControl(wTI, searchLeft, ui.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	ui.SearchTextBox = search.TextBox
	ui.DelIcon = search.DelIcon

	ui.SearchTextBox.TextChanged = function(sender, args)
		ApplySearch();
	end
	-- Needed to handle deleting text with the delete key:
	ui.SearchTextBox.KeyUp = function(sender, args)
		ApplySearch();
	end

	local lbTop = 85
	local lb = CreateListBoxWithBorder(wTI, 15, lbTop, wTI:GetWidth() - 30, Constants.LISTBOX_HEIGHT_STANDARD, Color["grey"])
	ui.ListBoxBorder = lb.Border
	ui.ListBox = lb.ListBox
	ui.ListBoxScrollBar = lb.ScrollBar
	ui.ListBox:SetMaxColumns(1);
	ConfigureListBox(ui.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])

	local tiData = _G.ControlData.TI
	ui.showMissing = CreateAutoSizedCheckBox(wTI, L["TIMissing"], 30, 0, tiData.showMissing ~= false)
	ui.showMissing.CheckedChanged = function(sender, args)
		tiData.showMissing = ui.showMissing:IsChecked()
		SaveSettings()
		ShowStackableItems()
	end

	CheckForStackableItems();
end

function ApplySearch()
    local ui = _G.ControlData.TI and _G.ControlData.TI.ui
    if not ui then return end
    local searchTerm = string.lower(ui.SearchTextBox:GetText());

    if (ui.searchText ~= searchTerm) then
        ui.searchText = searchTerm;
        ShowStackableItems();
    end
end

function CheckForStackableItems()
	item = {};
	itemCtl = {};
	itemLbl = {};
	local bFound = false;

	for i = 1, size do
		item[i] = backpack:GetItem( i );
		if item[i] ~= nil then
			local iteminfo = item[i]:GetItemInfo();
			item[i].Name = iteminfo:GetName();
			if iteminfo:GetMaxStackSize() > 1 then
				bFound = true
				item[i].Stackable = true;
			else
				item[i].Stackable = false;
			end
		else
			item[i] = "zEmpty";
		end
	end
	
	-- Tracked items that are not in the bags are listed too, so they can be untracked
	if bFound or #TrackedItemsOfLanguage() > 0 then ShowStackableItems();
	else SetEmptyTrackList(); end
end

function SetEmptyTrackList()
	local ui = _G.ControlData.TI and _G.ControlData.TI.ui
	if not ui then return end
	ui.ListBox:ClearItems();
	local itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( ui.ListBox:GetWidth(), 35 );

	local lblmgs = CreateTitleLabel(itemCtl, L["BIMsg"], 0, 0, nil, Color["red"], nil, itemCtl:GetWidth(), itemCtl:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

	ui.ListBoxBorder:SetPosition( 15, 85 );
	ui.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	ui.ListBox:SetPosition( ui.ListBoxBorder:GetLeft() + 2, ui.ListBoxBorder:GetTop() + 2 );
	ui.ListBox:SetHeight( lblmgs:GetHeight() );
	ui.ListBoxScrollBar:SetVisible( false );
	ui.showMissing:SetVisible( false );

	ui.ListBox:AddItem( itemCtl );
	ui.window:SetHeight( itemCtl:GetHeight() + 85 );
end

function ShowStackableItems()
	local ui = _G.ControlData.TI and _G.ControlData.TI.ui
	if not ui then return end
	ui.ListBox:ClearItems();
	ui.itemState = {}

	for i = 1, size do
		if item[i] ~= "zEmpty" and item[i].Stackable then -- Only show stackable item
			if not ui.searchText or string.find(string.lower( item[i].Name ), ui.searchText, 1, true) then
				-- Use CreateItemRow for player item
				local row = CreateItemRow(nil, ui.ListBox:GetWidth(), 35, true, item[i])
				itemCtl[i] = row.Container
				itemLbl[i] = row.ItemLabel
				itemLbl[i]:SetSize( ui.ListBox:GetWidth() - 48, 33 )
				itemLbl[i]:SetPosition( 36, 3 )
				itemLbl[i]:SetText( item[i].Name )
				ui.itemState[i] = false

				itemLbl[i].MouseClick = function( sender, args )
					if ( args.Button == Turbine.UI.MouseButton.Left ) then
						local name = itemLbl[i]:GetText();
						local tracked = not ui.itemState[i];
						if tracked then TrackItem(item[i]); else UntrackItem(name); end

						--Mark all stacks of the same item in the listbox
						for ii = 1, size do
							if item[ii] ~= "zEmpty" and item[ii].Stackable and itemLbl[ii] and item[ii].Name == name then
								ui.itemState[ii] = tracked;
								itemLbl[ii]:SetForeColor( tracked and Color["green"] or Color["white"] );
								if ii ~= i then itemLbl[ii]:SetBackColor( tracked and Color["darkgrey"] or Color["black"] ); end
							end
						end
					end
				end

				itemLbl[i].MouseHover = function(sender, args)
					itemLbl[i]:SetBackColor( Color["lightgrey"] );
				end

				itemLbl[i].MouseLeave = function(sender, args)
					if ui.itemState[i] then itemLbl[i]:SetBackColor( Color["darkgrey"] ); else itemLbl[i]:SetBackColor( Color["black"] ); end
				end

				ui.ListBox:AddItem( itemCtl[i] );
			end
		end
	end
	
	-- Mark the tracked items (only items shown by the search have a label)
	for ii = 1, size do
		if item[ii] ~= "zEmpty" and item[ii].Stackable and itemLbl[ii] and IsItemTracked(itemLbl[ii]:GetText()) then
			itemLbl[ii]:SetForeColor( Color["green"] );
			itemLbl[ii]:SetBackColor( Color["darkgrey"] );
			ui.itemState[ii] = true;
		end
	end

	-- Tracked items that are not in the bags (any more), so they can be untracked
	local inBags = {}
	for ii = 1, size do
		if item[ii] ~= "zEmpty" then inBags[item[ii].Name] = true end
	end
	for _, entry in ipairs(TrackedItemsOfLanguage()) do
		if ui.showMissing:IsChecked() and not inBags[entry.N] and (not ui.searchText or string.find(string.lower( entry.N ), ui.searchText, 1, true)) then
			local row = CreateItemRow(nil, ui.ListBox:GetWidth(), 35, false, { B = entry.B, U = entry.U, S = entry.S, I = entry.I, N = "0" })
			row.ItemQuantity:SetForeColor( Color["red"] )
			local label = row.ItemLabel
			label:SetSize( ui.ListBox:GetWidth() - 48, 33 )
			label:SetPosition( 36, 3 )
			label:SetText( entry.N )

			local tracked = true
			local function ShowState()
				label:SetForeColor( tracked and Color["green"] or Color["white"] );
				label:SetBackColor( tracked and Color["darkgrey"] or Color["black"] );
			end
			ShowState()

			label.MouseClick = function( sender, args )
				if ( args.Button == Turbine.UI.MouseButton.Left ) then
					tracked = not tracked;
					if tracked then TrackEntry(entry); else UntrackItem(entry.N); end
					ShowState()
				end
			end
			label.MouseHover = function(sender, args) label:SetBackColor( Color["lightgrey"] ); end
			label.MouseLeave = function(sender, args) ShowState() end

			ui.ListBox:AddItem( row.Container );
		end
	end

	ui.ListBoxBorder:SetPosition( 15, ui.searchLabel:GetTop() + ui.searchLabel:GetHeight() + 5 );
	ui.ListBoxBorder:SetHeight( Constants.LISTBOX_HEIGHT_STANDARD );
	ui.ListBox:SetPosition( ui.ListBoxBorder:GetLeft() + 2, ui.ListBoxBorder:GetTop() + 2 );
	ui.ListBox:SetHeight( ui.ListBoxBorder:GetHeight() - 4 );
	ui.ListBoxScrollBar:SetHeight( ui.ListBox:GetHeight() );
	ui.showMissing:SetTop( ui.ListBoxBorder:GetTop() + ui.ListBoxBorder:GetHeight() + 6 );
	ui.showMissing:SetVisible( true );
	ui.window:SetHeight( ui.showMissing:GetTop() + ui.showMissing:GetHeight() + 15 );
end