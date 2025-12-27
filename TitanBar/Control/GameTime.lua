-- GameTime.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.GT = {}; -- Game Time table in _G

CreateTitanBarControl(GT, GTbcAlpha, GTbcRed, GTbcGreen, GTbcBlue)

GT["Lbl"] = CreateControlLabel(GT["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleRight)

SetupControlInteraction({
	icon = GT["Lbl"],
	controlName = "GT",
	controlTable = GT,
	settingsSection = settings.GameTime,
	xVarName = "GTLocX",
	yVarName = "GTLocY",
	windowVar = "wGT",
	windowImportPath = AppCtrD .. "GameTimeWindow",
	windowFunction = "frmGameTimeWindow"
})
--**^