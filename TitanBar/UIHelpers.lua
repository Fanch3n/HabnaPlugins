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
    tb:SetParent(parent)
    tb:SetPosition(left, top)
    tb:SetSize(width - 24, height)
    if font then tb:SetFont(font) end
    tb:SetMultiline(false)

    local del = Turbine.UI.Label()
    del:SetParent(parent)
    del:SetPosition(left + (width - 20), top)
    del:SetSize(16, 16)
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
            itemBG:SetSize(34, 34)
            itemBG:SetPosition(0, 0)
        end
    else
        local itemBG = Turbine.UI.Control()
        itemBG:SetParent(ctl)
        itemBG:SetSize(32, 32)
        itemBG:SetPosition(3, 3)
        if itemSpec and itemSpec.B and itemSpec.B ~= "0" then itemBG:SetBackground(tonumber(itemSpec.B)) end
        itemBG:SetBlendMode(Turbine.UI.BlendMode.Overlay)

        local itemU = Turbine.UI.Control()
        itemU:SetParent(ctl)
        itemU:SetSize(32, 32)
        itemU:SetPosition(3, 3)
        if itemSpec and itemSpec.U and itemSpec.U ~= "0" then itemU:SetBackground(tonumber(itemSpec.U)) end
        itemU:SetBlendMode(Turbine.UI.BlendMode.Overlay)

        local itemS = Turbine.UI.Control()
        itemS:SetParent(ctl)
        itemS:SetSize(32, 32)
        itemS:SetPosition(3, 3)
        if itemSpec and itemSpec.S and itemSpec.S ~= "0" then itemS:SetBackground(tonumber(itemSpec.S)) end
        itemS:SetBlendMode(Turbine.UI.BlendMode.Overlay)

        local item = Turbine.UI.Control()
        item:SetParent(ctl)
        item:SetSize(32, 32)
        item:SetPosition(3, 3)
        if itemSpec and itemSpec.I and itemSpec.I ~= "0" then item:SetBackground(tonumber(itemSpec.I)) end
        item:SetBlendMode(Turbine.UI.BlendMode.Overlay)

        itemQTE = Turbine.UI.Label()
        itemQTE:SetParent(ctl)
        itemQTE:SetSize(32, 15)
        itemQTE:SetPosition(-4, 16)
        itemQTE:SetFont(Turbine.UI.Lotro.Font.Verdana12)
        itemQTE:SetFontStyle(Turbine.UI.FontStyle.Outline)
        itemQTE:SetOutlineColor(Color["black"])
        itemQTE:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
        itemQTE:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay)
        itemQTE:SetForeColor(Color["nicegold"])
        if itemSpec and itemSpec.N then itemQTE:SetText(tonumber(itemSpec.N)) end
    end

    local itemLbl = Turbine.UI.Label()
    itemLbl:SetParent(ctl)
    itemLbl:SetSize(ctl:GetWidth() - 35, height)
    itemLbl:SetPosition(37, 2)
    itemLbl:SetFont(Turbine.UI.Lotro.Font.TrajanPro16)
    itemLbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    itemLbl:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay)
    itemLbl:SetForeColor(Color["white"])

    return { Container = ctl, ItemLabel = itemLbl, ItemQuantity = itemQTE }
end
