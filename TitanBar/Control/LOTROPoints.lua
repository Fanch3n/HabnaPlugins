import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.LP = {}; -- LOTRO Points table in _G

CreateTitanBarControl(LP, LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue)

LP["Icon"] = CreateControlIcon(LP["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
LP["Icon"]:SetBackground(_G.resources.LOTROPoints)
LP["Icon"]:SetSize(Constants.LOTRO_POINTS_ICON_WIDTH, Constants.LOTRO_POINTS_ICON_HEIGHT)
LP["Icon"]:SetStretchMode(1)
LP["Icon"]:SetSize(Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

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