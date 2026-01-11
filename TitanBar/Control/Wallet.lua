-- Wallet.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "WalletToolTip")
import(AppDirD .. "ControlFactory")

_G.WI = {}; -- Wallet table in _G

--**v Wallet Control v**
local colors = _G.ControlData.WI.colors
CreateTitanBarControl(WI, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.WI.ui.control = WI["Ctr"]
--**^
--**v Wallet icon on TitanBar v**
WI["Icon"] = CreateControlIcon(WI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.Wallet, Turbine.UI.BlendMode.AlphaBlend)

SetupControlInteraction({
	icon = WI["Icon"],
	controlTable = WI,
	settingsSection = settings.Wallet,
	windowImportPath = AppCtrD .. "WalletWindow",
	windowFunction = "frmWalletWindow",
	hasTooltip = true,
	customTooltipHandler = ShowWIToolTip
})
--**^