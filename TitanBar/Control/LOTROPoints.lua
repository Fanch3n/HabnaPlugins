import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.LP = {}; -- LOTRO Points table in _G

local colors = _G.ControlData.LP.colors
LP["Ctr"] = CreateTitanBarControl(LP, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.LP.ui.control = LP["Ctr"]

LP["Icon"] = CreateControlIcon(LP["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, _G.resources.LOTROPoints, Turbine.UI.BlendMode.AlphaBlend, 1, Constants.LOTRO_POINTS_ICON_WIDTH, Constants.LOTRO_POINTS_ICON_HEIGHT)

LP["Lbl"] = CreateControlLabel(LP["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = LP["Lbl"],
	controlTable = LP,
	settingsSection = settings.LOTROPoints,
	windowImportPath = AppCtrD .. "LOTROPointsWindow",
	windowFunction = "frmLOTROPointsWindow"
})

DelegateMouseEvents(LP["Icon"], LP["Lbl"])