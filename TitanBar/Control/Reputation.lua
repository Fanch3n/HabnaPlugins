-- Reputation.lua
-- Written by Habna

if resources == nil then import "HabnaPlugins.TitanBar.TBresources"; end;
import(AppDirD .. "UIHelpers")
import(AppCtrD .. "ReputationToolTip")
import(AppDirD .. "ControlFactory")

_G.RP = {}; -- Reputation table in _G

--**v Reputation Control v**
CreateTitanBarControl(RP, RPbcAlpha, RPbcRed, RPbcGreen, RPbcBlue)
--**^
--**v Reputation icon on TitanBar v**
RP["Icon"] = CreateControlIcon(RP["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.Reputation.Icon, 4)

SetupControlInteraction({
	icon = RP["Icon"],
	controlName = "RP",
	controlTable = RP,
	settingsSection = settings.Reputation,
	xVarName = "RPLocX",
	yVarName = "RPLocY",
	windowVar = "wRP",
	windowImportPath = AppCtrD .. "ReputationWindow",
	windowFunction = "frmReputationWindow",
	tooltipKey = "RP",
	customTooltipHandler = ShowRPWindow
})
--**^