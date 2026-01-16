import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import(AppCtrD .. "VaultToolTip")

function InitializeVault()
-- Use _G.ControlData.VT.controls for all UI controls
local VT = {}
_G.ControlData.VT.controls = VT

local colors = _G.ControlData.VT.colors
VT["Ctr"] = CreateTitanBarControl(VT, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.VT.ui.control = VT["Ctr"]

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

-- Monitor vault changes
AddCallback(vaultpack, "CountChanged", function(sender, args) 
SavePlayerVault() 
end)

UpdateVault()
end

-- Self-registration
_G.ControlRegistry.Register({
id = "VT",
settingsKey = "Vault",
hasWhere = true,
defaults = { show = false, where = 1, x = 0, y = 0 },
initFunc = InitializeVault
})
