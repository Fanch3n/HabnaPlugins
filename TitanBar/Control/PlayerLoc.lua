-- PlayerLoc.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.PL = {}; -- Player Location table in _G

local colors = _G.ControlData.PL.colors
CreateTitanBarControl(PL, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.PL.ui.control = PL["Ctr"]

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