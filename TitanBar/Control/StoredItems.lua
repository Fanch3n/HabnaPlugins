-- StoredItems.lua
-- Vault, Shared Storage and Bags share these parts: the items of a container are saved (per
-- character, or once for the shared storage), shown as icons in a tooltip, and listed in a
-- window with a search and, for items of several characters, a character selection.

import(AppDirD .. "UIHelpers")

-- ============================================================================
-- SAVING
-- ============================================================================

-- Saved form of the items of a container (backpack, vault, shared storage): the item objects
-- with their icons, name and quantity as text, numbered "1", "2", ... without gaps.
--   slots: number of places to look at (empty places are skipped)
--   capacity: saved with every item
function SaveableItems(container, slots, capacity)
	local saved, count = {}, 0
	for i = 1, slots do
		local item = container:GetItem(i)
		if item ~= nil then
			count = count + 1
			local itemInfo = item:GetItemInfo()
			item.Q = tostring(itemInfo:GetQualityImageID())
			item.B = tostring(itemInfo:GetBackgroundImageID())
			item.U = tostring(itemInfo:GetUnderlayImageID())
			item.S = tostring(itemInfo:GetShadowImageID())
			item.I = tostring(itemInfo:GetIconImageID())
			item.T = tostring(itemInfo:GetName())
			local quantity = tostring(item:GetQuantity())
			if quantity == "1" then quantity = "" end
			item.N = quantity
			item.Z = tostring(capacity)
			saved[tostring(count)] = item
		end
	end
	return saved
end

-- Number of saved items; they are numbered "1" up to this number
local function CountItems(items)
	local count = 0
	for _ in pairs(items or {}) do count = count + 1 end
	return count
end

-- Names of the characters with saved items, sorted, without session play characters ("~...")
local function CharacterNames(itemsByCharacter)
	local names = {}
	for name in pairs(itemsByCharacter or {}) do
		if string.sub(name, 1, 1) ~= "~" then table.insert(names, name) end
	end
	table.sort(names)
	return names
end

-- ============================================================================
-- TOOLTIP
-- ============================================================================

local TOOLTIP_ITEMS_PER_LINE = 15

-- Tooltip with the icons of saved items (Vault, Shared Storage)
function ShowStoredItemsToolTip(items, emptyMessage)
	local tt = CreateTooltipWindow({
		hasListBox = true,
		listBoxPosition = { x = 20, y = 20 },
		emptyMessage = emptyMessage
	})
	local listBox = tt.listBox
	listBox:SetOrientation(Turbine.UI.Orientation.Horizontal)

	local count = CountItems(items)
	tt.emptyMessageLabel:SetVisible(count == 0)
	listBox:SetVisible(count > 0)

	if count == 0 then
		_G.ToolTipWin:SetWidth(Constants.TOOLTIP_WIDTH_VAULT)
		_G.ToolTipWin:SetHeight(115)
		PositionAndShowTooltip(_G.ToolTipWin)
		ApplySkin()
		return
	end

	for i = 1, count do
		local data = items[tostring(i)]
		if data then
			local itemCtl = Turbine.UI.Control()
			itemCtl:SetParent(listBox)
			itemCtl:SetSize(Constants.ICON_SIZE_XLARGE, Constants.ICON_SIZE_XLARGE)

			-- Background, underlay, shadow and icon of the item
			for _, image in ipairs({ data.B, data.U, data.S, data.I }) do
				local layer = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
				if image ~= "0" then layer:SetBackground(tonumber(image)) end
				layer:SetBlendMode(Turbine.UI.BlendMode.Overlay)
			end

			local quantity = CreateControl(Turbine.UI.Label, itemCtl, 0, 20, Constants.ICON_SIZE_LARGE, 15)
			quantity:SetFont(Turbine.UI.Lotro.Font.Verdana12)
			quantity:SetFontStyle(Turbine.UI.FontStyle.Outline)
			quantity:SetOutlineColor(Color["black"])
			quantity:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
			quantity:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay)
			quantity:SetForeColor(Color["nicegold"])
			quantity:SetText(tonumber(data.N))

			listBox:AddItem(itemCtl)
		end
	end

	local height = 40 * (math.ceil(count / TOOLTIP_ITEMS_PER_LINE) - 1) + 60
	local maxHeight = screenHeight / _G.ToolTipWin:GetScale()
	if height > maxHeight then height = maxHeight - 70 end

	listBox:SetHeight(height)
	listBox:SetMaxColumns(TOOLTIP_ITEMS_PER_LINE)

	_G.ToolTipWin:SetHeight(height + 20)
	_G.ToolTipWin:SetWidth(40 * TOOLTIP_ITEMS_PER_LINE + 40)
	PositionAndShowTooltip(_G.ToolTipWin)
	listBox:SetWidth(_G.ToolTipWin:GetWidth() - 40)
	ApplySkin()
end

-- ============================================================================
-- WINDOW
-- ============================================================================

-- Window listing saved items with a search. config:
--   id, settingsKey, title, width, height: the window (see CreateControlWindow)
--   items():        the saved items: by character name if perCharacter, else one list
--   perCharacter:   character selection (with "All") and a button to delete the items of a character
--   write():        saves the items after the items of a character were deleted
--   deletedMessage: localization key of the chat message after deleting
--   emptyMessage:   localization key of the message shown when a character has no items
--   live:           container with the items of the current character (Bags): they are shown
--                   as the game shows them instead of from the saved items
--   searchTop, listTop, listHeight: layout of the search and the list
--   extras(window, top): adds controls below the list, returns their bottom
--   watch:          { { object, event, delayed } }: refresh the list on these events
--                   (delayed: one frame later, for events that fire before the container changed)
--   onChange():     called on these events before the refresh, e.g. to save the items
function CreateStoredItemsWindow(config)
	import(AppDirD .. "WindowFactory")
	local ALL = L["VTAll"]
	local ui = _G.ControlData[config.id].ui
	local selected = PN
	local searchText = nil
	local callbacks = {}

	local dropdown
	if config.perCharacter then
		import(AppClassD .. "ComboBox")
		dropdown = HabnaPlugins.TitanBar.Class.ComboBox()
	end

	local window = CreateControlWindow(
		config.settingsKey, config.id,
		config.title, config.width, config.height,
		{
			dropdown = dropdown,
			onClosing = function(sender, args)
				if dropdown then dropdown.dropDownWindow:SetVisible(false) end
				for _, callback in ipairs(callbacks) do
					RemoveCallback(callback.object, callback.event, callback.func)
				end
				ui.window = nil
			end
		}
	)
	ui.window = window

	if dropdown then
		dropdown:SetParent(window)
		dropdown:SetSize(Constants.DROPDOWN_WIDTH, Constants.DROPDOWN_HEIGHT)
		dropdown:SetPosition(15, 35)
		dropdown.dropDownWindow:SetParent(window)
		dropdown.dropDownWindow:SetPosition(dropdown:GetLeft(), dropdown:GetTop() + dropdown:GetHeight() + 2)
	end

	local searchLabel = CreateTitleLabel(window, L["VTSe"], 15, config.searchTop or 60, Turbine.UI.Lotro.Font.TrajanPro15,
		Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)
	local search = CreateSearchControl(window, searchLabel:GetLeft() + searchLabel:GetWidth(), searchLabel:GetTop(),
		window:GetWidth() - 150 + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)

	local listTop = config.listTop or (searchLabel:GetTop() + searchLabel:GetHeight() + 5)
	local list = CreateListBoxWithBorder(window, 15, listTop, window:GetWidth() - 30, config.listHeight, Color["grey"])
	local listBox = list.ListBox
	ConfigureListBox(listBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])

	local listBottom = listBox:GetTop() + listBox:GetHeight()
	local extrasBottom = config.extras and config.extras(window, listBottom)

	local deleteButton
	if config.perCharacter then
		deleteButton = Turbine.UI.Lotro.Button()
		deleteButton:SetParent(window)
		deleteButton:SetText(L["ButDel"])
		deleteButton:SetSize(deleteButton:GetTextLength() * 11, 15) --Auto size with text length
		local top = extrasBottom and (extrasBottom + 5) or (listBottom + 10)
		deleteButton:SetPosition(window:GetWidth() / 2 - deleteButton:GetWidth() / 2, top)
	end

	local function AddRow(item, name, owner, isLive)
		if searchText and not string.find(string.lower(name), searchText, 1, true) then return end
		local row = CreateItemRow(nil, listBox:GetWidth(), 35, isLive, item)
		row.ItemLabel:SetText(name)
		if owner then row.ItemLabel:AppendText(" (" .. owner .. ")") end
		listBox:AddItem(row.Container)
	end

	-- The items of one character, or of the shared storage
	local function AddItems(items, owner, isCurrentCharacter)
		if config.live and isCurrentCharacter then
			for i = 1, config.live:GetSize() do
				local item = config.live:GetItem(i)
				if item ~= nil then AddRow(item, item:GetName(), owner, true) end
			end
		else
			for i = 1, CountItems(items) do
				local entry = items[tostring(i)]
				if entry then AddRow(entry, entry.T, owner, false) end
			end
		end
	end

	-- A list with items, or the message that there are none
	local function ShowList(empty)
		if empty then
			local row = Turbine.UI.Control()
			row:SetSize(listBox:GetWidth(), 35)
			CreateTitleLabel(row, L[config.emptyMessage], 0, 0, nil, Color["green"], nil, row:GetWidth(), row:GetHeight(),
				Turbine.UI.ContentAlignment.MiddleCenter)
			listBox:AddItem(row)
			list.Border:SetHeight(row:GetHeight() + 4)
			listBox:SetHeight(row:GetHeight())
			list.ScrollBar:SetVisible(false)
			window:SetHeight(listTop + row:GetHeight() + 2)
		else
			list.Border:SetHeight(config.listHeight)
			listBox:SetHeight(config.listHeight - 4)
			list.ScrollBar:SetHeight(listBox:GetHeight())
			list.ScrollBar:SetVisible(true)
			window:SetHeight(config.height)
		end
		if deleteButton then deleteButton:SetVisible(not empty) end
	end

	local function Refresh()
		listBox:ClearItems()
		local all = config.items() or {}

		if not config.perCharacter then
			local empty = config.emptyMessage ~= nil and CountItems(all) == 0
			if not empty then AddItems(all, nil, false) end
			ShowList(empty)
			return
		end

		if selected == ALL then
			for _, name in ipairs(CharacterNames(all)) do
				AddItems(all[name], name, name == PN)
			end
			ShowList(false)
		else
			local items = all[selected] or {}
			local isLive = config.live ~= nil and selected == PN
			local empty = config.emptyMessage ~= nil and not isLive and CountItems(items) == 0
			if not empty then AddItems(items, nil, selected == PN) end
			ShowList(empty)
		end
		deleteButton:SetEnabled(selected ~= PN and selected ~= ALL)
	end

	search.TextBox.TextChanged = function(sender, args)
		searchText = string.lower(search.TextBox:GetText())
		if searchText == "" then searchText = nil end
		Refresh()
	end

	if dropdown then
		local function FillDropdown()
			PopulateDropDown(dropdown, CharacterNames(config.items()), true, ALL, PN)
		end
		FillDropdown()

		dropdown.ItemChanged = function(sender, args)
			search.TextBox:SetText("")
			searchText = nil
			selected = dropdown.label:GetText()
			Refresh()
		end

		deleteButton.Click = function(sender, args)
			config.items()[selected] = nil
			config.write()
			write(selected .. L[config.deletedMessage])
			selected = PN
			dropdown.selection = -1
			FillDropdown()
			Refresh()
		end
	end

	-- Refresh the list when the container changes
	local function Changed()
		if not ui.window then return end
		if config.onChange then config.onChange() end
		if not config.perCharacter or selected == PN or selected == ALL then Refresh() end
	end
	local delayedChange = Turbine.UI.Control()
	delayedChange.Update = function(sender, args)
		delayedChange:SetWantsUpdates(false)
		Changed()
	end
	for _, watched in ipairs(config.watch or {}) do
		local func
		if watched.delayed then
			func = function(sender, args) delayedChange:SetWantsUpdates(true) end
		else
			func = function(sender, args) Changed() end
		end
		AddCallback(watched.object, watched.event, func)
		table.insert(callbacks, { object = watched.object, event = watched.event, func = func })
	end

	Refresh()
	return window
end
