import(AppDirD .. "UIHelpers")
import(AppCtrD .. "TrackItemsToolTip")
import(AppDirD .. "ControlFactory")

_G.TI = {}; -- TrackItems table in _G

CreateTitanBarControl(TI, TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue)

TI["Icon"] = CreateControlIcon(TI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.TrackItems)

SetupControlInteraction({
	icon = TI["Icon"],
	controlName = "TI",
	controlTable = TI,
	settingsSection = settings.TrackItems,
	xVarName = "TILocX",
	yVarName = "TILocY",
	windowVar = "wTI",
	windowImportPath = AppCtrD .. "TrackItemsWindow",
	windowFunction = "frmTrackItemsWindow",
	customTooltipHandler = ShowTIWindow
})
--**^