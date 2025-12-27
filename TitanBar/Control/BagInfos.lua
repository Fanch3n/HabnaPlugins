-- BagInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.BI = {}; -- Backpack Infos table in _G

--**v Control for backpack infos v**
CreateTitanBarControl(BI, BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue)
--**^
--**v Backpack infos & icon on TitanBar v**
BI["Icon"] = CreateControlIcon(BI["Ctr"], Constants.ICON_SIZE_MEDIUM, Constants.ICON_SIZE_MEDIUM_LARGE, nil, Turbine.UI.BlendMode.AlphaBlend)

BI["Lbl"] = CreateControlLabel(BI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = BI["Lbl"],
	controlName = "BI",
	controlTable = BI,
	settingsSection = settings.BagInfos,
	xVarName = "BILocX",
	yVarName = "BILocY",
	windowVar = "wBI",
	windowImportPath = AppCtrD .. "BagInfosWindow",
	windowFunction = "frmBagInfos",
	hasTooltip = true
})

-- Delegate icon events to the label so both regions behave the same
DelegateMouseEvents(BI["Icon"], BI["Lbl"])
--**^