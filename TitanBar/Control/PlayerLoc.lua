-- PlayerLoc.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.PL = {}; -- Player Location table in _G

CreateTitanBarControl(PL, PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue)

PL["Lbl"] = CreateControlLabel(PL["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleLeft)

SetupControlInteraction({
	icon = PL["Lbl"],
	controlName = "PL",
	controlTable = PL,
	settingsSection = settings.PlayerLoc,
	xVarName = "PLLocX",
	yVarName = "PLLocY",
	onLeftClick = function() end
})
--**^