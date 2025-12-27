-- DurabilityInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "DurabilityInfosToolTip")
import(AppDirD .. "ControlFactory")

_G.DI = {}; -- Items Durability Infos table in _G

CreateTitanBarControl(DI, DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue)

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