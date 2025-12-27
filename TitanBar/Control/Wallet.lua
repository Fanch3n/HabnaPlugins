-- Wallet.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "WalletToolTip")
import(AppDirD .. "ControlFactory")

_G.WI = {}; -- Wallet table in _G

--**v Wallet Control v**
CreateTitanBarControl(WI, WIbcAlpha, WIbcRed, WIbcGreen, WIbcBlue)
--**^
--**v Wallet icon on TitanBar v**
WI["Icon"] = CreateControlIcon(WI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.Wallet, Turbine.UI.BlendMode.AlphaBlend)

SetupControlInteraction({
	icon = WI["Icon"],
	controlName = "WI",
	controlTable = WI,
	settingsSection = settings.Wallet,
	xVarName = "WILocX",
	yVarName = "WILocY",
	windowVar = "wWI",
	windowImportPath = AppCtrD .. "WalletWindow",
	windowFunction = "frmWalletWindow",
	hasTooltip = true,
	customTooltipHandler = ShowWIToolTip
})
--**^