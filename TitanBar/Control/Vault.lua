-- Vault.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "VaultToolTip")
import(AppDirD .. "ControlFactory")

_G.VT = {}; -- Vault table in _G

--**v Vault Control v**
CreateTitanBarControl(VT, VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue)
--**^
--**v Vault icon on TitanBar v**
VT["Icon"] = CreateControlIcon(VT["Ctr"], Constants.ICON_SIZE_MEDIUM_LARGE, Constants.ICON_SIZE_MEDIUM_LARGE, resources.Storage.Vault, 4)

SetupControlInteraction({
	icon = VT["Icon"],
	controlName = "VT",
	controlTable = VT,
	settingsSection = settings.Vault,
	xVarName = "VTLocX",
	yVarName = "VTLocY",
	windowVar = "wVT",
	windowImportPath = AppCtrD .. "VaultWindow",
	windowFunction = "frmVault",
	tooltipKey = "VT",
	customTooltipHandler = ShowVaultToolTip
})
--**^