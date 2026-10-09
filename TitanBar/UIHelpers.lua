-- UIHelpers.lua
-- Centralized small UI helper constructors

import(AppDirD .. "TooltipManager")

-- ============================================================================
-- TOOLTIP CREATION
-- ============================================================================

-- Creates a tooltip window with standard setup and optional listbox
-- Parameters:
--   config: {
--     width: Optional width (defaults based on hasListBox)
--     height: Optional initial height
--     hasListBox: Boolean, whether to create a listbox (default false)
--     listBoxPosition: {x, y} position for listbox (default {15, 12} or {20, 20})
--     listBoxWidth: Optional width for listbox
--     emptyMessage: Optional message label for empty state
--     emptyMessageSize: {width, height} for empty message (default {350, 39})
--   }
-- Returns: {
--   window: The tooltip window
--   listBox: The listbox (if hasListBox is true)
--   emptyMessageLabel: The empty message label (if emptyMessage provided)
-- }
function CreateTooltipWindow(config)
	config = config or {}
	local hasListBox = config.hasListBox or false
	local listBoxPos = config.listBoxPosition or (hasListBox and {x = 15, y = 12} or {x = 20, y = 20})
	
	-- Create the tooltip window
	_G.ToolTipWin = Turbine.UI.Window()
	_G.ToolTipWin:SetZOrder(1)
	_G.ToolTipWin:SetVisible(true)
	
	if config.width then
		_G.ToolTipWin:SetWidth(config.width)
	end
	
	if config.height then
		_G.ToolTipWin:SetHeight(config.height)
	end
	
	local result = {
		window = _G.ToolTipWin
	}
	
	-- Create listbox if requested
	if hasListBox then
		local listBox = Turbine.UI.ListBox()
		listBox:SetParent(_G.ToolTipWin)
		listBox:SetZOrder(1)
		listBox:SetPosition(listBoxPos.x, listBoxPos.y)
		
		if config.listBoxWidth then
			listBox:SetWidth(config.listBoxWidth)
		elseif config.width then
			listBox:SetWidth(config.width - 30)
		end
		
		result.listBox = listBox
	end
	
	-- Create empty message label if requested
	if config.emptyMessage then
		local emptyLabel = GetLabel(config.emptyMessage)
		emptyLabel:SetParent(_G.ToolTipWin)
		
		local msgSize = config.emptyMessageSize or {width = 350, height = Constants.LABEL_HEIGHT_MESSAGE or 39}
		emptyLabel:SetSize(msgSize.width, msgSize.height)
		
		result.emptyMessageLabel = emptyLabel
	end
	
	return result
end

-- Positions and shows a tooltip window based on mouse position and TitanBar location
-- Parameters:
--   window: The tooltip window to position
--   xOffset: Optional x offset (default -5)
--   yOffset: Optional y offset (default -15)
--   useHeight: If true, uses window height for y positioning when TBTop is false
function PositionAndShowTooltip(window, xOffset, yOffset, useHeight)
	local x = xOffset or -5
	local y = yOffset or -15
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition()
	local width, height = GetScaledSize(window)

	-- Adjust x if tooltip would go off screen
	if width + mouseX + 5 > screenWidth then
		x = width - 10
	end

	-- Adjust y based on TitanBar position
	if not TBTop then
		y = height
	end
	
	window:SetPosition(mouseX - x, mouseY - y)
	window:SetVisible(true)
end

-- ============================================================================
-- UI SCALING (Update 49.6)
-- ============================================================================

-- Attaches the edges of a stretch-mode control that has a fixed size inside its parent:
-- it keeps its position and size when the parent is resized, e.g. by UI scaling.
-- Call before stretching the control.
function AttachScalingEdges(control)
	local Same, Opposite = Turbine.UI.EdgeAttachmentType.Same, Turbine.UI.EdgeAttachmentType.Opposite
	control:AttachEdges(Same, Same, Opposite, Opposite)
end

-- Stretches a control's whole background image to the given size, whatever the image's
-- native size: stretch mode 2 first sizes the control to the image, mode 1 then stretches
-- it from there. Resetting the mode first makes this safe to repeat.
function StretchBackground(control, width, height)
	control:SetStretchMode(nil)
	control:SetStretchMode(2)
	control:SetStretchMode(1)
	control:SetSize(width, height)
end

-- Returns the on-screen size of a window (its size times its total scale).
function GetScaledSize(window)
	local width, height = window:GetSize()
	local scale = window:GetScale()
	return width * scale, height * scale
end

-- Width of TitanBar in its own (unscaled) units, so that it spans the whole screen.
-- Rounded up so the bar never stops short of the right screen edge.
function GetBarWidth()
	return math.ceil(screenWidth / TB["win"]:GetScale())
end

-- Height TitanBar takes up on screen.
function GetBarScreenHeight()
	return math.ceil(TBHeight * TB["win"]:GetScale())
end

-- Sizes TitanBar to the screen width and moves it to the top or bottom edge.
function LayoutBar()
	TB["win"]:SetSize( GetBarWidth(), TBHeight );
	if TBTop then TB["win"]:SetTop( 0 );
	else TB["win"]:SetTop( screenHeight - GetBarScreenHeight() ); end
	if MouseHoverCtr then CenterMouseHover(); end
end

-- Centers the auto-hide hover strip horizontally on the screen.
function CenterMouseHover()
	local hoverWidth = GetScaledSize( MouseHoverCtr );
	MouseHoverCtr:SetLeft( (screenWidth - hoverWidth) / 2 );
end

-- Create a search control: a TextBox with a delete icon to clear it.
-- Returns { TextBox = tb, DelIcon = del, Container = container }
-- Lower case of a UTF-8 text, for searches that ignore case (string.lower only changes A-Z).
-- Covers the Latin letters with accents, Greek, Cyrillic and Armenian. Lua 5.1 has no UTF-8 support,
-- so the characters are decoded here: Unicode keeps most capitals at a fixed distance from their
-- small letters, or right before them.
local function LowerCodePoint(c)
	if c >= 0xC0 and c <= 0xDE and c ~= 0xD7 then return c + 0x20 end -- Latin-1: À-Þ (not ×)
	if c >= 0x100 and c <= 0x17F then -- Latin Extended-A: capital and small letter in pairs
		if c == 0x130 then return 0x69 end -- İ
		if c == 0x178 then return 0xFF end -- Ÿ
		if (c >= 0x139 and c <= 0x148) or (c >= 0x179 and c <= 0x17E) then
			if c % 2 == 1 then return c + 1 end
		elseif c ~= 0x138 and c ~= 0x149 and c ~= 0x17F and c % 2 == 0 then
			return c + 1
		end
		return c
	end
	if c >= 0x386 and c <= 0x3AB then -- Greek
		if c == 0x386 then return 0x3AC end
		if c >= 0x388 and c <= 0x38A then return c + 0x25 end
		if c == 0x38C then return 0x3CC end
		if c == 0x38E or c == 0x38F then return c + 0x3F end
		if c >= 0x391 and c ~= 0x3A2 then return c + 0x20 end
		return c
	end
	if c >= 0x400 and c <= 0x40F then return c + 0x50 end -- Cyrillic: Ѐ-Џ
	if c >= 0x410 and c <= 0x42F then return c + 0x20 end -- Cyrillic: А-Я
	if (c >= 0x460 and c <= 0x481) or (c >= 0x48A and c <= 0x4BF) or (c >= 0x4D0 and c <= 0x52F) then
		if c % 2 == 0 then return c + 1 end
		return c
	end
	if c == 0x4C0 then return 0x4CF end
	if c >= 0x4C1 and c <= 0x4CE then
		if c % 2 == 1 then return c + 1 end
		return c
	end
	if c >= 0x531 and c <= 0x556 then return c + 0x30 end -- Armenian
	if c == 0x1E9E then return 0xDF end -- ẞ
	if (c >= 0x1E00 and c <= 0x1E95) or (c >= 0x1EA0 and c <= 0x1EFF) then -- Latin Extended Additional (Vietnamese, ...)
		if c % 2 == 0 then return c + 1 end
	end
	return c
end

local function Encode(c)
	if c < 0x80 then return string.char(c) end
	if c < 0x800 then return string.char(0xC0 + math.floor(c / 0x40), 0x80 + c % 0x40) end
	return string.char(0xE0 + math.floor(c / 0x1000), 0x80 + math.floor(c / 0x40) % 0x40, 0x80 + c % 0x40)
end

function UTF8Lower(text)
	if not text then return "" end
	text = string.lower(text)
	text = string.gsub(text, "[\194-\223][\128-\191]", function(ch)
		local a, b = string.byte(ch, 1, 2)
		return Encode(LowerCodePoint((a - 0xC0) * 0x40 + (b - 0x80)))
	end)
	text = string.gsub(text, "\225[\184-\187][\128-\191]", function(ch) -- U+1E00-U+1EFF
		local a, b, c = string.byte(ch, 1, 3)
		return Encode(LowerCodePoint((a - 0xE0) * 0x1000 + (b - 0x80) * 0x40 + (c - 0x80)))
	end)
	return text
end

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

    -- The LOTRO TextBox does not raise TextChanged for every edit (e.g. the Del key),
    -- so while it has focus, compare the text every frame and raise the missed changes.
    -- The window's handler is wrapped to remember the text it was last called with,
    -- so edits that do raise TextChanged are not reported twice.
    local lastText = tb:GetText()
    local windowHandler
    local function dispatch(sender, args)
        lastText = tb:GetText()
        if windowHandler then windowHandler(sender, args) end
    end
    tb.FocusGained = function(sender, args)
        if tb.TextChanged ~= dispatch then
            windowHandler = tb.TextChanged
            tb.TextChanged = dispatch
        end
        lastText = tb:GetText()
        tb:SetWantsUpdates(true)
    end
    tb.Update = function(sender, args)
        if tb:GetText() ~= lastText then dispatch(tb, args) end
    end
    tb.FocusLost = function(sender, args)
        tb.Update(sender, args)
        tb:SetWantsUpdates(false)
    end

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
            -- Keep the size of the ItemControl: making it smaller cuts off the right and bottom
            -- of the red frame of unusable items
            itemBG:SetPosition(0, 0)
            if itemBG:GetHeight() > height then ctl:SetHeight(itemBG:GetHeight()) end
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

    local foundValue = nil
    local idx = startIndex
    for _, entry in ipairs(items) do
        if type(entry) == "string" then
            dropdown:AddItem(entry, idx)
            if selectedValue and entry == selectedValue then foundValue = idx end
        elseif type(entry) == "table" then
            -- support { label = "...", value = "..." } or { "label", "value" }
            local label = entry.label or entry[1]
            local value = entry.value or entry[2] or idx
            dropdown:AddItem(label, value)
            if selectedValue and value == selectedValue then foundValue = value end
        end
        idx = idx + 1
    end

    if foundValue then dropdown:SetSelection(foundValue) end
    return foundValue
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
    listBox:SetMaxColumns(itemsPerLine or 1)
    listBox:SetOrientation(orientation or Turbine.UI.Orientation.Horizontal)
    if backColor then listBox:SetBackColor(backColor) end
end

-- Positions a tooltip window near the mouse cursor, accounting for screen edges and TitanBar position
function PositionToolTipWindow()
	if not _G.ToolTipWin then return end
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	local width, height = GetScaledSize(_G.ToolTipWin);
	local x, y;

	if width + mouseX + Constants.TOOLTIP_MARGIN > screenWidth then
		x = width - Constants.TOOLTIP_OFFSET_X;
	else
		x = -Constants.TOOLTIP_MARGIN;
	end

	if TBTop then
		y = -15;
	else
		y = height;
	end

	_G.ToolTipWin:SetPosition(mouseX - x, mouseY - y);
end

-- Save control position to settings
-- Parameters:
--  control: the control to get position from
--  controlId: the control ID from ControlRegistry (e.g., "WI")
function SaveControlPosition(control, controlId)
	local x = control:GetLeft()
	local y = control:GetTop()
	
	-- Update ControlData structure
	local data = _G.ControlData[controlId]
	if data then
		data.location.x = x
		data.location.y = y
	end
	
	SaveSettings()
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
--  maxWidth: maximum X boundary (default: TB["win"]:GetWidth())
--  maxHeight: maximum Y boundary (default: TB["win"]:GetHeight())
-- Usage: MoveControlConstrained(myControl, args)
function MoveControlConstrained(control, args, maxWidth, maxHeight)
	local maxW = maxWidth or TB["win"]:GetWidth()
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
--  controlId: the control ID from ControlRegistry (e.g., "WI")
-- Returns: { MouseDown = function, MouseUp = function }
-- Usage: 
--   local handlers = CreateDragHandlers(WI["Ctr"], "WI")
--   WI["Icon"].MouseDown = handlers.MouseDown
--   WI["Icon"].MouseUp = handlers.MouseUp
function CreateDragHandlers(control, controlId)
	return {
		MouseDown = function(sender, args)
			if args.Button == Turbine.UI.MouseButton.Left then
				StartDrag(control, args)
			end
		end,
		MouseUp = function(sender, args)
			control:SetZOrder(2)
			_G.dragging = false
			SaveControlPosition(control, controlId)
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

-- Export helper functions to _G for dynamically loaded controls
_G.SaveControlPosition = SaveControlPosition
_G.StartDrag = StartDrag
_G.MoveControlConstrained = MoveControlConstrained
_G.CreateDragHandlers = CreateDragHandlers
_G.CreateMoveHandler = CreateMoveHandler
_G.DelegateMouseEvents = DelegateMouseEvents
_G.PositionToolTipWindow = PositionToolTipWindow
_G.CreateTooltipWindow = CreateTooltipWindow
_G.PositionAndShowTooltip = PositionAndShowTooltip
