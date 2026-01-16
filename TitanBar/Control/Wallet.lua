-- Wallet.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import (AppCtrD .. "WalletToolTip")

function InitializeWallet()
	-- Use _G.ControlData.WI.controls for all UI controls
	local WI = {}
	_G.ControlData.WI.controls = WI

	--**v Wallet Control v**
	local colors = _G.ControlData.WI.colors
	WI["Ctr"] = CreateTitanBarControl(WI, colors.alpha, colors.red, colors.green, colors.blue)
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
	
	UpdateWallet()
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "WI",
	settingsKey = "Wallet",
	hasWhere = true,
	defaults = { show = false, where = 2, x = 0, y = 0 },
	initFunc = InitializeWallet
})
--**^