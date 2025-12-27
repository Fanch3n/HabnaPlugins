import(AppDirD .. "UIHelpers")
import(AppCtrD .. "InfamyToolTip")
import(AppDirD .. "ControlFactory")

_G.IF = {}; -- Infamy table in _G

CreateTitanBarControl(IF, IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue)

IF["Icon"] = CreateControlIcon(IF["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

SetupControlInteraction({
	icon = IF["Icon"],
	controlName = "IF",
	controlTable = IF,
	settingsSection = settings.Infamy,
	xVarName = "IFLocX",
	yVarName = "IFLocY",
	windowVar = "wIF",
	windowImportPath = AppCtrD .. "InfamyWindow",
	windowFunction = "frmInfamyWindow",
	customTooltipHandler = ShowIFWindow
})