-- DurabilityInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "DurabilityInfosToolTip")
import(AppDirD .. "ControlFactory")

_G.DI = {}; -- Durability Infos table in _G

local colors = _G.ControlData.DI.colors
CreateTitanBarControl(DI, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.DI.ui.control = DI["Ctr"]

DI["Icon"] = CreateControlIcon(DI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

DI["Lbl"] = CreateControlLabel(DI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = DI["Lbl"],
	controlName = "DI",
	controlTable = DI,
	settingsSection = settings.DurabilityInfos,
	xVarName = "DILocX",
	yVarName = "DILocY",
	windowVar = "wDI",
	windowImportPath = AppCtrD .. "DurabilityInfosWindow",
	windowFunction = "frmDurabilityInfosWindow",
	customTooltipHandler = ShowDIWindow
})

DelegateMouseEvents(DI["Icon"], DI["Lbl"])
--**^