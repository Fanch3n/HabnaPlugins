import(AppDirD .. "UIHelpers")
import(AppCtrD .. "TrackItemsToolTip")
import(AppDirD .. "ControlFactory")

_G.TI = {}; -- Track Items table in _G

local colors = _G.ControlData.TI.colors
CreateTitanBarControl(TI, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.TI.ui.control = TI["Ctr"]

TI["Icon"] = CreateControlIcon(TI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.TrackItems)

SetupControlInteraction({
	icon = TI["Icon"],
	controlName = "TI",
	controlId = "TI",
	controlTable = TI,
	settingsSection = settings.TrackItems,
	windowVar = "wTI",
	windowImportPath = AppCtrD .. "TrackItemsWindow",
	windowFunction = "frmTrackItemsWindow",
	customTooltipHandler = ShowTIWindow
})
--**^