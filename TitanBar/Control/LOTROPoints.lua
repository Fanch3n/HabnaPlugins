import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.LP = {}; -- LOTRO Points table in _G

LP["Ctr"] = CreateTitanBarControl(LP, LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue)

LP["Icon"] = CreateControlIcon(LP["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, _G.resources.LOTROPoints, Turbine.UI.BlendMode.AlphaBlend, 1, Constants.LOTRO_POINTS_ICON_WIDTH, Constants.LOTRO_POINTS_ICON_HEIGHT)

LP["Lbl"] = CreateControlLabel(LP["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = LP["Lbl"],
	controlName = "LP",
	controlTable = LP,
	settingsSection = settings.LOTROPoints,
	xVarName = "LPLocX",
	yVarName = "LPLocY",
	windowVar = "wLP",
	windowImportPath = AppCtrD .. "LOTROPointsWindow",
	windowFunction = "frmLOTROPointsWindow"
})

DelegateMouseEvents(LP["Icon"], LP["Lbl"])