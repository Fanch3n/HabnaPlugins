-- SharedStorage.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "SharedStorageToolTip")
import(AppDirD .. "ControlFactory")

_G.SS = {}; -- Shared Storage table in _G

local colors = _G.ControlData.SS.colors
CreateTitanBarControl(SS, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.SS.ui.control = SS["Ctr"]

SS["Icon"] = CreateControlIcon(SS["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.Storage.Shared, Turbine.UI.BlendMode.AlphaBlend)

SetupControlInteraction({
	icon = SS["Icon"],
	controlTable = SS,
	settingsSection = settings.SharedStorage,
	windowImportPath = AppCtrD .. "SharedStorageWindow",
	windowFunction = "frmSharedStorage",
	tooltipKey = "SS",
	customTooltipHandler = ShowSharedToolTip
})
