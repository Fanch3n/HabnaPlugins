-- Vault.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "VaultToolTip")
import(AppDirD .. "ControlFactory")

_G.VT = {}; -- Vault table in _G

--**v Vault Control v**
local colors = _G.ControlData.VT.colors
CreateTitanBarControl(VT, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.VT.ui.control = VT["Ctr"]
--**^
--**v Vault icon on TitanBar v**
VT["Icon"] = CreateControlIcon(VT["Ctr"], Constants.ICON_SIZE_MEDIUM_LARGE, Constants.ICON_SIZE_MEDIUM_LARGE, resources.Storage.Vault, 4)

SetupControlInteraction({
	icon = VT["Icon"],
	controlName = "VT",
	controlId = "VT",
	controlTable = VT,
	settingsSection = settings.Vault,
	windowVar = "wVT",
	windowImportPath = AppCtrD .. "VaultWindow",
	windowFunction = "frmVault",
	tooltipKey = "VT",
	customTooltipHandler = ShowVaultToolTip
})
--**^