-- GameTime.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

-- Use _G.ControlData.GT.controls for all UI controls
local GT = {}
_G.ControlData.GT.controls = GT

local colors = _G.ControlData.GT.colors
CreateTitanBarControl(GT, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.GT.ui.control = GT["Ctr"]

GT["Lbl"] = CreateControlLabel(GT["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleRight)

SetupControlInteraction({
	icon = GT["Lbl"],
	controlTable = GT,
	settingsSection = settings.GameTime,
	windowImportPath = AppCtrD .. "GameTimeWindow",
	windowFunction = "frmGameTimeWindow"
})
--**^