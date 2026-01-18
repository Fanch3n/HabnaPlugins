-- Vault.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "VaultToolTip")
import(AppDirD .. "ControlFactory")

-- Use _G.ControlData.VT.controls for all UI controls
local VT = {}
_G.ControlData.VT.controls = VT

--**v Vault Control v**
local colors = _G.ControlData.VT.colors
CreateTitanBarControl(VT, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.VT.ui.control = VT["Ctr"]
--**^
--**v Vault icon on TitanBar v**
VT["Icon"] = CreateControlIcon(VT["Ctr"], Constants.ICON_SIZE_MEDIUM_LARGE, Constants.ICON_SIZE_MEDIUM_LARGE, resources.Storage.Vault, 4)

SetupControlInteraction({
	icon = VT["Icon"],
	controlTable = VT,
	settingsSection = settings.Vault,
	windowImportPath = AppCtrD .. "VaultWindow",
	windowFunction = "frmVault",
	tooltipKey = "VT",
	customTooltipHandler = ShowVaultToolTip
})
--**^