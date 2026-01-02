import(AppDirD .. "UIHelpers")
import(AppCtrD .. "InfamyToolTip")
import(AppDirD .. "ControlFactory")

_G.IF = {}; -- Infamy table in _G

local colors = _G.ControlData.IF.colors
CreateTitanBarControl(IF, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.IF.ui.control = IF["Ctr"]

IF["Icon"] = CreateControlIcon(IF["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

SetupControlInteraction({
	icon = IF["Icon"],
	controlName = "IF",
	controlId = "IF",
	controlTable = IF,
	settingsSection = settings.Infamy,
	windowVar = "wIF",
	windowImportPath = AppCtrD .. "InfamyWindow",
	windowFunction = "frmInfamyWindow",
	customTooltipHandler = ShowIFWindow
})