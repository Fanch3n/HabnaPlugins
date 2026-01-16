import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import(AppCtrD .. "SharedStorageToolTip")

function InitializeSharedStorage()
-- Use _G.ControlData.SS.controls for all UI controls
local SS = {}
_G.ControlData.SS.controls = SS

local colors = _G.ControlData.SS.colors
SS["Ctr"] = CreateTitanBarControl(SS, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.SS.ui.control = SS["Ctr"]

SS["Icon"] = CreateControlIcon(SS["Ctr"], Constants.ICON_SIZE_MEDIUM_LARGE, Constants.ICON_SIZE_MEDIUM_LARGE, resources.Storage.SharedStorage, 4)

SetupControlInteraction({
icon = SS["Icon"],
controlTable = SS,
settingsSection = settings.SharedStorage,
windowImportPath = AppCtrD .. "SharedStorageWindow",
windowFunction = "frmSharedStorage",
tooltipKey = "SS",
customTooltipHandler = ShowSharedStorageToolTip
})

-- Monitor shared storage changes
AddCallback(sspack, "CountChanged", function(sender, args) 
SavePlayerSharedStorage() 
end)

UpdateSharedStorage()
end

-- Self-registration
_G.ControlRegistry.Register({
id = "SS",
settingsKey = "SharedStorage",
hasWhere = true,
defaults = { show = false, where = 1, x = 0, y = 0 },
initFunc = InitializeSharedStorage
})
