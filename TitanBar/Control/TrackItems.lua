import(AppDirD .. "UIHelpers")
import(AppCtrD .. "TrackItemsToolTip")
import(AppDirD .. "ControlFactory")

-- Use _G.ControlData.TI.controls for all UI controls
local TI = {}
_G.ControlData.TI.controls = TI

local colors = _G.ControlData.TI.colors
CreateTitanBarControl(TI, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.TI.ui.control = TI["Ctr"]

TI["Icon"] = CreateControlIcon(TI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.TrackItems)

SetupControlInteraction({
	icon = TI["Icon"],
	controlTable = TI,
	settingsSection = settings.TrackItems,
	windowImportPath = AppCtrD .. "TrackItemsWindow",
	windowFunction = "frmTrackItemsWindow",
	customTooltipHandler = ShowTIWindow
})
--**^