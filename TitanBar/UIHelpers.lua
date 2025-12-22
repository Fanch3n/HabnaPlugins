-- UIHelpers.lua
-- Centralized small UI helper constructors

-- Create a search control: a TextBox with a delete icon to clear it.
-- Returns { TextBox = tb, DelIcon = del, Container = container }
function CreateSearchControl(parent, left, top, width, height, font, resources)
    height = height or 18
    local container = Turbine.UI.Control()
    container:SetParent(parent)
    container:SetPosition(left, top)
    container:SetSize(width, height)

    local tb = Turbine.UI.Lotro.TextBox()
    tb:SetParent(container)
    tb:SetPosition(0, 0)
    tb:SetSize(width - 24, height)
    if font then tb:SetFont(font) end
    tb:SetMultiline(false)

    local del = Turbine.UI.Label()
    del:SetParent(container)
    del:SetPosition(width - 20, 0)
    del:SetSize(Constants.DELETE_ICON_SIZE, Constants.DELETE_ICON_SIZE)
    if resources and resources.DelIcon then
        del:SetBackground(resources.DelIcon)
    end
    del:SetBlendMode(4)
    del:SetVisible(true)
    del.MouseClick = function(sender, args)
        tb:SetText("")
        if tb.TextChanged then
            pcall(function() tb.TextChanged(tb, args) end)
        end
        tb:Focus()
    end

    return { TextBox = tb, DelIcon = del, Container = container }
end

-- Create a list area with a visual border, inner ListBox and attached ScrollBar.
-- Returns { Border = border, ListBox = listBox, ScrollBar = scroll }
function CreateListBoxWithBorder(parent, left, top, width, height, backColor)
    local border = Turbine.UI.Control()
    border:SetParent(parent)
    border:SetPosition(left, top)
    border:SetSize(width, height)
    border:SetBackColor(backColor or Color["grey"])
    border:SetVisible(true)

    local listBox = Turbine.UI.ListBox()
    listBox:SetParent(parent)
    listBox:SetPosition(left + 2, top + 2)
    listBox:SetSize(width - 4, height - 4)

    local scroll = Turbine.UI.Lotro.ScrollBar()
    scroll:SetParent(listBox)
    scroll:SetPosition(listBox:GetWidth() - 10, 0)
    scroll:SetSize(12, listBox:GetHeight())
    scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    listBox:SetVerticalScrollBar(scroll)

    return { Border = border, ListBox = listBox, ScrollBar = scroll }
end

-- Create an item row used in bag/shared storage/vault lists.
-- `itemSpec` is either a Turbine item (for player inventory) or a table with fields {B,U,S,I,N,T}
-- `isPlayerItem` selects the ItemControl path.
-- Returns { Container = ctl, ItemLabel = lbl, ItemQuantity = qte (or nil) }
function CreateItemRow(parent, width, height, isPlayerItem, itemSpec)
    local ctl = Turbine.UI.Control()
    ctl:SetParent(parent)
    ctl:SetSize(width - 10, height)

    local itemQTE = nil
    if isPlayerItem then
        if itemSpec then
            local itemBG = Turbine.UI.Lotro.ItemControl(itemSpec)
            itemBG:SetParent(ctl)
            itemBG:SetSize(Constants.ITEM_CONTROL_SIZE, Constants.ITEM_CONTROL_SIZE)
            itemBG:SetPosition(0, 0)
        end
    else
        local itemBG = CreateControl(Turbine.UI.Control, ctl, 3, 3, 32, 32)
        if itemSpec and itemSpec.B and itemSpec.B ~= "0" then itemBG:SetBackground(tonumber(itemSpec.B)) end
        itemBG:SetBlendMode(Turbine.UI.BlendMode.Overlay)

        local itemU = CreateControl(Turbine.UI.Control, ctl, 3, 3, 32, 32)
        if itemSpec and itemSpec.U and itemSpec.U ~= "0" then itemU:SetBackground(tonumber(itemSpec.U)) end
        itemU:SetBlendMode(Turbine.UI.BlendMode.Overlay)

        local itemS = CreateControl(Turbine.UI.Control, ctl, 3, 3, 32, 32)
        if itemSpec and itemSpec.S and itemSpec.S ~= "0" then itemS:SetBackground(tonumber(itemSpec.S)) end
        itemS:SetBlendMode(Turbine.UI.BlendMode.Overlay)

        local item = CreateControl(Turbine.UI.Control, ctl, 3, 3, 32, 32)
        if itemSpec and itemSpec.I and itemSpec.I ~= "0" then item:SetBackground(tonumber(itemSpec.I)) end
        item:SetBlendMode(Turbine.UI.BlendMode.Overlay)

        local qtyText = itemSpec and itemSpec.N and tonumber(itemSpec.N) or nil
        itemQTE = CreateQuantityLabel(ctl, qtyText)
    end

    local itemLbl = CreateControl(Turbine.UI.Label, ctl, 37, 2, ctl:GetWidth() - 35, height)
    itemLbl:SetFont(Turbine.UI.Lotro.Font.TrajanPro16)
    itemLbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    itemLbl:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay)
    itemLbl:SetForeColor(Color["white"])

    return { Container = ctl, ItemLabel = itemLbl, ItemQuantity = itemQTE }
end

-- Populate a dropdown from a simple array-like table.
-- Parameters:
--  dropdown: the ComboBox instance
--  items: an array-like table of strings
--  includeAll: boolean, whether to add an "All" entry at the start
--  allLabel: label for the All entry (defaults to L["VTAll"] when includeAll)
--  selectedValue: optional string to auto-select; returns the selected index or nil
function PopulateDropDown(dropdown, items, includeAll, allLabel, selectedValue)
    if not dropdown then return nil end
    dropdown.listBox:ClearItems()
    local startIndex = 1
    if includeAll then
        dropdown:AddItem(allLabel or L["VTAll"], 0)
        startIndex = 2
    end

    local selIndex = nil
    local idx = startIndex
    for _, entry in ipairs(items) do
        if type(entry) == "string" then
            dropdown:AddItem(entry, idx)
            if selectedValue and entry == selectedValue then selIndex = idx end
        elseif type(entry) == "table" then
            -- support { label = "...", value = "..." } or { "label", "value" }
            local label = entry.label or entry[1]
            local value = entry.value or entry[2] or idx
            dropdown:AddItem(label, value)
            if selectedValue and value == selectedValue then selIndex = idx end
        end
        idx = idx + 1
    end

    if selIndex then dropdown:SetSelection(selIndex) end
    return selIndex
end

-- Create a standardized title/label used for headings and small descriptors.
-- Parameters:
--  parent, text, left, top
--  font: a Turbine font (optional)
--  foreColor: Color table entry (optional)
--  autosizeFactor: if number, width = textLength * autosizeFactor; otherwise `width` must be supplied
--  width, height: explicit sizes if autosizeFactor is nil
--  alignment: Turbine.UI.ContentAlignment value (optional)
function CreateTitleLabel(parent, text, left, top, font, foreColor, autosizeFactor, width, height, alignment)
    local lbl = Turbine.UI.Label()
    lbl:SetParent(parent)
    lbl:SetText(text)
    lbl:SetPosition(left, top)
    local h = height or 18
    if autosizeFactor and type(autosizeFactor) == "number" then
        lbl:SetSize(string.len(text) * autosizeFactor, h)
    else
        lbl:SetSize(width or 100, h)
    end
    if font then lbl:SetFont(font) end
    if foreColor then lbl:SetForeColor(foreColor) end
    if alignment then lbl:SetTextAlignment(alignment) end
    return lbl
end

-- Create a compact field label for form inputs (smaller, standard styling).
-- Parameters:
--  parent, text, left, top
--  autosizeFactor: if number, width = textLength * autosizeFactor (default 8.5)
--  width: explicit width if autosizeFactor is nil
--  foreColor: defaults to Color["rustedgold"]
function CreateFieldLabel(parent, text, left, top, autosizeFactor, width, foreColor)
    local factor = autosizeFactor or 8.5
    local color = foreColor or Color["rustedgold"]
    return CreateTitleLabel(parent, text, left, top, nil, color, factor, width, 20, Turbine.UI.ContentAlignment.MiddleLeft)
end

-- Create and position a control in one call (consolidates SetParent, SetPosition, SetSize).
-- Parameters:
--  controlType: a Turbine control class (e.g., Turbine.UI.Label, Turbine.UI.Control)
--  parent: parent control
--  left, top: position
--  width, height: size
--  Returns: the configured control instance
function CreateControl(controlType, parent, left, top, width, height)
    local ctrl = controlType()
    ctrl:SetParent(parent)
    ctrl:SetPosition(left, top)
    ctrl:SetSize(width, height)
    return ctrl
end

-- Create a quantity label for item displays (bottom-right corner with gold text)
-- Parameters:
--  parent: parent control
--  quantity: (optional) the quantity text/number to display
-- Returns: configured quantity label
function CreateQuantityLabel(parent, quantity)
    local lbl = CreateControl(Turbine.UI.Label, parent, -4, 16, 32, 15)
    lbl:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    lbl:SetFontStyle(Turbine.UI.FontStyle.Outline)
    lbl:SetOutlineColor(Color["black"])
    lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    lbl:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay)
    lbl:SetForeColor(Color["nicegold"])
    if quantity then lbl:SetText(tostring(quantity)) end
    return lbl
end

-- Configure a listbox with common settings (orientation, items per line, background)
-- Parameters:
--  listBox: the listbox to configure
--  itemsPerLine: (optional) default 1
--  orientation: (optional) default Horizontal
--  backColor: (optional) background color
function ConfigureListBox(listBox, itemsPerLine, orientation, backColor)
    listBox:SetMaxItemsPerLine(itemsPerLine or 1)
    listBox:SetOrientation(orientation or Turbine.UI.Orientation.Horizontal)
    if backColor then listBox:SetBackColor(backColor) end
end

-- Positions a tooltip window near the mouse cursor, accounting for screen edges and TitanBar position
function PositionToolTipWindow()
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	local x, y;
	
	if _G.ToolTipWin:GetWidth() + mouseX + Constants.TOOLTIP_MARGIN > screenWidth then 
		x = _G.ToolTipWin:GetWidth() - Constants.TOOLTIP_OFFSET_X;
	else 
		x = -Constants.TOOLTIP_MARGIN; 
	end
	
	if TBTop then 
		y = -15;
	else 
		y = _G.ToolTipWin:GetHeight();
	end

	_G.ToolTipWin:SetPosition(mouseX - x, mouseY - y);
end

-- Save control position to settings
-- Parameters:
--  control: the control to get position from
--  settingsTable: the settings table to update (e.g., settings.Wallet)
--  globalXVar: the global variable name for X position (e.g., "_G.WILocX")
--  globalYVar: the global variable name for Y position (e.g., "_G.WILocY")
function SaveControlPosition(control, settingsTable, globalXVarName, globalYVarName)
	local x = control:GetLeft()
	local y = control:GetTop()
	_G[globalXVarName] = x
	_G[globalYVarName] = y
	settingsTable.X = string.format("%.0f", x)
	settingsTable.Y = string.format("%.0f", y)
	SaveSettings(false)
end

-- Initialize drag operation on MouseDown
-- Parameters:
--  control: the control to set z-order on
--  args: the MouseButton event args
-- Sets global variables: dragStartX, dragStartY, dragging
function StartDrag(control, args)
	control:SetZOrder(3)
	_G.dragStartX = args.X
	_G.dragStartY = args.Y
	_G.dragging = true
end

-- Create an auto-sized button with standard settings
-- Parameters:
--  parent: parent control
--  text: button text
--  left, top: position (optional)
--  widthMultiplier: text length multiplier for width calculation (default: 10)
--  height: button height (default: 15)
-- Returns: the configured button instance
function CreateAutoSizedButton(parent, text, left, top, widthMultiplier, height)
	local btn = Turbine.UI.Lotro.Button()
	btn:SetParent(parent)
	btn:SetText(text)
	local w = btn:GetTextLength() * (widthMultiplier or 10)
	local h = height or 15
	btn:SetSize(w, h)
	if left and top then
		btn:SetPosition(left, top)
	end
	return btn
end

-- Create a standard input TextBox with common settings
-- Parameters:
--  parent: parent control
--  text: initial text value (optional)
--  left, top: position
--  width: textbox width (default: 80)
--  height: textbox height (default: 20)
--  font: Turbine font (default: TrajanPro14)
--  alignment: text alignment (default: MiddleLeft)
-- Returns: the configured textbox instance
function CreateInputTextBox(parent, text, left, top, width, height, font, alignment)
	local tb = Turbine.UI.Lotro.TextBox()
	tb:SetParent(parent)
	tb:SetPosition(left, top)
	tb:SetSize(width or 80, height or 20)
	tb:SetFont(font or Turbine.UI.Lotro.Font.TrajanPro14)
	tb:SetTextAlignment(alignment or Turbine.UI.ContentAlignment.MiddleLeft)
	tb:SetMultiline(false)
	if text then tb:SetText(text) end
	return tb
end

-- Create an auto-sized CheckBox with standard settings
-- Parameters:
--  parent: parent control
--  text: checkbox label text
--  left, top: position
--  checked: initial checked state (optional)
--  widthMultiplier: text length multiplier for width calculation (default: 8.5)
--  height: checkbox height (default: 20)
-- Returns: the configured checkbox instance
function CreateAutoSizedCheckBox(parent, text, left, top, checked, widthMultiplier, height)
	local cb = Turbine.UI.Lotro.CheckBox()
	cb:SetParent(parent)
	cb:SetText(text)
	cb:SetPosition(left, top)
	local w = cb:GetTextLength() * (widthMultiplier or 8.5)
	local h = height or 20
	cb:SetSize(w, h)
	cb:SetForeColor(Color["rustedgold"])
	if checked ~= nil then cb:SetChecked(checked) end
	return cb
end

-- Delegate all mouse events from sourceControl to targetControl
-- Parameters:
--  sourceControl: the control that will delegate its events
--  targetControl: the control that will handle the events
--  events: optional table of event names (default: all mouse events)
-- Usage: DelegateMouseEvents(childControl, parentControl)
function DelegateMouseEvents(sourceControl, targetControl, events)
	local allEvents = events or {"MouseMove", "MouseLeave", "MouseClick", "MouseDown", "MouseUp"}
	for _, eventName in ipairs(allEvents) do
		sourceControl[eventName] = function(sender, args)
			if targetControl[eventName] then
				targetControl[eventName](sender, args)
			end
		end
	end
end

-- Move a control with constrained boundaries during drag operation
-- Parameters:
--  control: the control to move
--  args: the mouse event args containing X and Y
--  maxWidth: maximum X boundary (default: screenWidth)
--  maxHeight: maximum Y boundary (default: TB["win"]:GetHeight())
-- Usage: MoveControlConstrained(myControl, args)
function MoveControlConstrained(control, args, maxWidth, maxHeight)
	local maxW = maxWidth or screenWidth
	local maxH = maxHeight or TB["win"]:GetHeight()
	
	local CtrLocX = control:GetLeft()
	local CtrWidth = control:GetWidth()
	CtrLocX = CtrLocX + (args.X - _G.dragStartX)
	if CtrLocX < 0 then CtrLocX = 0 elseif CtrLocX + CtrWidth > maxW then CtrLocX = maxW - CtrWidth end
	
	local CtrLocY = control:GetTop()
	local CtrHeight = control:GetHeight()
	CtrLocY = CtrLocY + (args.Y - _G.dragStartY)
	if CtrLocY < 0 then CtrLocY = 0 elseif CtrLocY + CtrHeight > maxH then CtrLocY = maxH - CtrHeight end
	
	control:SetPosition(CtrLocX, CtrLocY)
	_G.WasDrag = true
end

-- Create standard MouseDown and MouseUp handlers for draggable controls
-- Parameters:
--  control: the control to drag (e.g., WI["Ctr"])
--  settingsTable: the settings table to save position to (e.g., settings.Wallet)
--  xVarName: the X position variable name (e.g., "WILocX")
--  yVarName: the Y position variable name (e.g., "WILocY")
-- Returns: { MouseDown = function, MouseUp = function }
-- Usage: 
--   local handlers = CreateDragHandlers(WI["Ctr"], settings.Wallet, "WILocX", "WILocY")
--   WI["Icon"].MouseDown = handlers.MouseDown
--   WI["Icon"].MouseUp = handlers.MouseUp
function CreateDragHandlers(control, settingsTable, xVarName, yVarName)
	return {
		MouseDown = function(sender, args)
			if args.Button == Turbine.UI.MouseButton.Left then
				StartDrag(control, args)
			end
		end,
		MouseUp = function(sender, args)
			control:SetZOrder(2)
			_G.dragging = false
			SaveControlPosition(control, settingsTable, xVarName, yVarName)
		end
	}
end

-- Create a move handler function for control dragging
-- Parameters:
--  control: the control to move (e.g., WI["Ctr"])
--  leaveControl: optional control whose MouseLeave should be called (e.g., WI["Icon"])
-- Returns: function(sender, args) that moves the control
-- Usage:
--   local moveHandler = CreateMoveHandler(WI["Ctr"], WI["Icon"])
--   -- or without MouseLeave:
--   local moveHandler = CreateMoveHandler(GT["Ctr"])
function CreateMoveHandler(control, leaveControl)
	return function(sender, args)
		if leaveControl and leaveControl.MouseLeave then
			leaveControl.MouseLeave(sender, args)
		end
		MoveControlConstrained(control, args)
	end
end
