-- DayNight.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.DN = {}; -- Day & Night table in _G

--**v Control of Day & Night v**
CreateTitanBarControl(DN, DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue)
--**^
--**v Day & Night & icon on TitanBar v**
DN["Icon"] = CreateControlIcon(DN["Ctr"], Constants.ICON_SIZE_SMALL, Constants.ICON_SIZE_SMALL)

DN["Lbl"] = CreateControlLabel(DN["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = DN["Lbl"],
	controlName = "DN",
	controlTable = DN,
	settingsSection = settings.DayNight,
	xVarName = "DNLocX",
	yVarName = "DNLocY",
	windowVar = "wDN",
	windowImportPath = AppCtrD .. "DayNightWindow",
	windowFunction = "frmDayNightWindow",
	tooltipKey = "DN",
	leaveControl = DN["Lbl"]
})

-- Delegate Icon events to Lbl
DelegateMouseEvents(DN["Icon"], DN["Lbl"])
--**^