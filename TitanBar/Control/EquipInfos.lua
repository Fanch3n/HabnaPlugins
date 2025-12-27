import(AppDirD .. "UIHelpers")
import(AppCtrD .. "EquipInfosToolTip")
import(AppDirD .. "ControlFactory")

_G.EI = {}; -- Equipment Infos table in _G

CreateTitanBarControl(EI, EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue)
EI["Ctr"]:SetSize(Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

EI["Icon"] = CreateControlIcon(EI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
EI["Icon"]:SetBackground(0x410f2ea5)

EI["Lbl"] = CreateControlLabel(EI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

SetupControlInteraction({
	icon = EI["Lbl"],
	controlName = "EI",
	controlTable = EI,
	settingsSection = settings.EquipInfos,
	xVarName = "EILocX",
	yVarName = "EILocY",
	onLeftClick = function() end,
	customTooltipHandler = ShowEIWindow
})

DelegateMouseEvents(EI["Icon"], EI["Lbl"])
--**^
--]]