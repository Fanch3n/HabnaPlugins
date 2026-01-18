import(AppDirD .. "UIHelpers")
import(AppCtrD .. "InfamyToolTip")
import(AppDirD .. "ControlFactory")

-- Use _G.ControlData.IF.controls for all UI controls
local IF = {}
_G.ControlData.IF.controls = IF

local colors = _G.ControlData.IF.colors
CreateTitanBarControl(IF, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.IF.ui.control = IF["Ctr"]

IF["Icon"] = CreateControlIcon(IF["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

SetupControlInteraction({
	icon = IF["Icon"],
	controlTable = IF,
	settingsSection = settings.Infamy,
	windowImportPath = AppCtrD .. "InfamyWindow",
	windowFunction = "frmInfamyWindow",
	customTooltipHandler = ShowIFWindow
})