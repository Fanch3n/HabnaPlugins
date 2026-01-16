import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function InitializeDayNight()
local DN = {}
_G.ControlData.DN.controls = DN

local colors = _G.ControlData.DN.colors
DN["Ctr"] = CreateTitanBarControl(DN, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.DN.ui.control = DN["Ctr"]

DN["Icon"] = CreateControlIcon(DN["Ctr"], Constants.ICON_SIZE_SMALL, Constants.ICON_SIZE_SMALL)
DN["Lbl"] = CreateControlLabel(DN["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
icon = DN["Lbl"],
controlTable = DN,
settingsSection = settings.DayNight,
windowImportPath = AppCtrD .. "DayNightWindow",
windowFunction = "frmDayNightWindow",
tooltipKey = "DN",
leaveControl = DN["Lbl"]
})

-- Delegate Icon events to Lbl
DelegateMouseEvents(DN["Icon"], DN["Lbl"])

UpdateDayNight()
end

-- Self-registration
_G.ControlRegistry.Register({
id = "DN",
settingsKey = "DayNight",
hasWhere = true,
defaults = { show = false, where = 1, x = 0, y = 0 },
initFunc = InitializeDayNight
})
