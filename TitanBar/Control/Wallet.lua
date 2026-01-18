-- Wallet.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "WalletToolTip")
import(AppDirD .. "ControlFactory")

function InitializeWallet()
	-- Cleanup existing controls to prevent duplication
	if _G.ControlData.WI.controls and _G.ControlData.WI.controls["Ctr"] then
		_G.ControlData.WI.controls["Ctr"]:SetParent(nil)
	end

	-- Use _G.ControlData.WI.controls for all UI controls
	local WI = {}
	_G.ControlData.WI.controls = WI

	--**v Wallet Control v**
	local colors = _G.ControlData.WI.colors
	CreateTitanBarControl(WI, colors.alpha, colors.red, colors.green, colors.blue)
	
	-- Ensure ui table exists
	_G.ControlData.WI.ui = _G.ControlData.WI.ui or {}
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
	
	UpdateWallet()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "WI",
		settingsKey = "Wallet",
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 },
		initFunc = InitializeWallet
	})
end