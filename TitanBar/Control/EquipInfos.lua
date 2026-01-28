import(AppDirD .. "UIHelpers")
import(AppCtrD .. "EquipInfosToolTip")
import(AppDirD .. "ControlFactory")

function UpdateEquipsInfos()
    local itemEquip = nil
    if EquipmentManager then
        itemEquip = EquipmentManager.GetItems() 
    end
    if not itemEquip then return end

    _G.TotalItemsScore = 0;
    for i = 1, 20 do
        if itemEquip[i] then
            _G.TotalItemsScore = _G.TotalItemsScore + (itemEquip[i].Score or 0);
        end
    end
    if AdjustIcon then AdjustIcon("EI") end
end
_G.UpdateEquipsInfos = UpdateEquipsInfos

function InitializeEquipInfos()
    _G.ControlData.EI.controls = _G.ControlData.EI.controls or {}
    local EI = _G.ControlData.EI.controls

    local colors = _G.ControlData.EI.colors
    if not EI["Ctr"] then -- Only create if not exists
        CreateTitanBarControl(EI, colors.alpha, colors.red, colors.green, colors.blue)
        _G.ControlData.EI.ui.control = EI["Ctr"]

        EI["Icon"] = CreateControlIcon(EI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
        EI["Icon"]:SetBackground(0x410f2ea5)

        EI["Lbl"] = CreateControlLabel(EI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

        SetupControlInteraction({
            icon = EI["Lbl"],
            controlTable = EI,
            settingsSection = settings.EquipInfos,
            onLeftClick = function() end,
            customTooltipHandler = ShowEIWindow
        })

        DelegateMouseEvents(EI["Icon"], EI["Lbl"])
    end

    UpdateEquipsInfos()
end

local function OnShowEquipInfos()
    local controlData = _G.ControlData.EI
    controlData.callbacks = controlData.callbacks or {}

    -- Clear existing callbacks to prevent duplicates
    for _, cb in ipairs(controlData.callbacks) do
        if cb.obj and cb.evt and cb.func then
            RemoveCallback(cb.obj, cb.evt, cb.func)
        end
    end
    controlData.callbacks = {}

    -- Refresh data via EquipmentManager
    if EquipmentManager then EquipmentManager.Refresh() end

    -- Helper to add and track callback
    local function AddAndTrack(obj, evt, func)
        local cb = AddCallback(obj, evt, func)
        table.insert(controlData.callbacks, { obj = obj, evt = evt, func = cb })
    end

    -- Callback 1: ItemEquipped
    AddAndTrack(PlayerEquipment, "ItemEquipped", function(sender, args)
        if EquipmentManager then EquipmentManager.Refresh() end
        if _G.ControlData.EI.show then UpdateEquipsInfos() end
    end)

    -- Callback 2: ItemUnequipped
    AddAndTrack(PlayerEquipment, "ItemUnequipped", function(sender, args)
        if ItemUnEquippedTimer then ItemUnEquippedTimer:SetWantsUpdates(true) end
    end)
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
    _G.ControlRegistry.Register({
        id = "EI",
        settingsKey = "EquipInfos",
        hasWhere = false,
        defaults = { show = true, x = nil, y = 0 },
        initFunc = InitializeEquipInfos,
        onShow = OnShowEquipInfos
    })
end
