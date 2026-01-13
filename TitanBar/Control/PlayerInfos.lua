import(AppDirD .. "UIHelpers")
import(AppCtrD .. "PlayerInfosToolTip")
import(AppDirD .. "ControlFactory")

-- Use _G.ControlData.PI.controls for all UI controls
local PI = {}
_G.ControlData.PI.controls = PI

local colors = _G.ControlData.PI.colors
CreateTitanBarControl(PI, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.PI.ui.control = PI["Ctr"]

PI["Icon"] = CreateControlIcon(PI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

PI["Lvl"] = CreateControlLabel(PI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

PI["Name"] = CreateControlLabel(PI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleLeft)

SetupControlInteraction({
	icon = PI["Name"],
	controlTable = PI,
	settingsSection = settings.PlayerInfos,
	onLeftClick = function() end,
	customTooltipHandler = ShowPIWindow
})

DelegateMouseEvents(PI["Icon"], PI["Name"])
DelegateMouseEvents(PI["Lvl"], PI["Name"])
--**^