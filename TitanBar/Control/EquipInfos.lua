import(AppDirD .. "UIHelpers")
import(AppCtrD .. "EquipInfosToolTip")
import(AppDirD .. "ControlFactory")

function UpdateEquipsInfos()
    if not (itemEquip and AdjustIcon) then
        if GetEquipmentInfos then GetEquipmentInfos() end
    end
    if not itemEquip then return end -- Still failed?

    _G.TotalItemsScore = 0;
    for i = 1, 20 do
        if itemEquip[i] then
            _G.TotalItemsScore = _G.TotalItemsScore + (itemEquip[i].Score or 0);
        end
    end
    if AdjustIcon then AdjustIcon("EI") end
end

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

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
    _G.ControlRegistry.Register({
        id = "EI",
        settingsKey = "EquipInfos",
        hasWhere = false,
        defaults = { show = true, x = nil, y = 0 },
        initFunc = InitializeEquipInfos
    })
end
