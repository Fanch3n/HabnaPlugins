-- DurabilityInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "DurabilityInfosToolTip")
import(AppDirD .. "ControlFactory")

-- Use _G.ControlData.DI.controls for all UI controls
local DI = {}
_G.ControlData.DI.controls = DI

local colors = _G.ControlData.DI.colors
CreateTitanBarControl(DI, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.DI.ui.control = DI["Ctr"]

DI["Icon"] = CreateControlIcon(DI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

DI["Lbl"] = CreateControlLabel(DI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = DI["Lbl"],
	controlTable = DI,
	settingsSection = settings.DurabilityInfos,
	windowImportPath = AppCtrD .. "DurabilityInfosWindow",
	windowFunction = "frmDurabilityInfosWindow",
	customTooltipHandler = ShowDIWindow
})

DelegateMouseEvents(DI["Icon"], DI["Lbl"])
--**^