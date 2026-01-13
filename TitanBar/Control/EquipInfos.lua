import(AppDirD .. "UIHelpers")
import(AppCtrD .. "EquipInfosToolTip")
import(AppDirD .. "ControlFactory")

-- Use _G.ControlData.EI.controls for all UI controls
local EI = {}
_G.ControlData.EI.controls = EI

local colors = _G.ControlData.EI.colors
CreateTitanBarControl(EI, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.EI.ui.control = EI["Ctr"]
EI["Ctr"]:SetSize(Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

EI["Icon"] = CreateControlIcon(EI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
EI["Icon"]:SetBackground(0x410f2ea5)

EI["Lbl"] = CreateControlLabel(EI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = EI["Lbl"],
	controlTable = EI,
	settingsSection = settings.EquipInfos,
	onLeftClick = function() end,
	customTooltipHandler = ShowEIWindow
})

DelegateMouseEvents(EI["Icon"], EI["Lbl"])
--**^
--]]