-- DayNight.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.DN = {}; -- Day & Night table in _G

--**v Control of Day & Night v**
local colors = _G.ControlData.DN.colors
CreateTitanBarControl(DN, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.DN.ui.control = DN["Ctr"]
--**^
--**v Day & Night & icon on TitanBar v**
DN["Icon"] = CreateControlIcon(DN["Ctr"], Constants.ICON_SIZE_SMALL, Constants.ICON_SIZE_SMALL)

DN["Lbl"] = CreateControlLabel(DN["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = DN["Lbl"],
	controlName = "DN",
	controlId = "DN",
	controlTable = DN,
	settingsSection = settings.DayNight,
	windowVar = "wDN",
	windowImportPath = AppCtrD .. "DayNightWindow",
	windowFunction = "frmDayNightWindow",
	tooltipKey = "DN",
	leaveControl = DN["Lbl"]
})

-- Delegate Icon events to Lbl
DelegateMouseEvents(DN["Icon"], DN["Lbl"])
--**^