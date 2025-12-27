-- SharedStorage.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "SharedStorageToolTip")
import(AppDirD .. "ControlFactory")

_G.SS = {}; -- SharedStorage table in _G

--**v SharedStorage Control v**
CreateTitanBarControl(SS, SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue)
--**^
--**v SharedStorage icon on TitanBar v**
SS["Icon"] = CreateControlIcon(SS["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.Storage.Shared, Turbine.UI.BlendMode.AlphaBlend)

SetupControlInteraction({
	icon = SS["Icon"],
	controlName = "SS",
	controlTable = SS,
	settingsSection = settings.SharedStorage,
	xVarName = "SSLocX",
	yVarName = "SSLocY",
	windowVar = "wSS",
	windowImportPath = AppCtrD .. "SharedStorageWindow",
	windowFunction = "frmSharedStorage",
	tooltipKey = "SS",
	customTooltipHandler = ShowSharedToolTip
})
--**^
