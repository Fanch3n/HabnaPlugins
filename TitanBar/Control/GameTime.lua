import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function InitializeGameTime()
-- Use _G.ControlData.GT.controls for all UI controls
local GT = {}
_G.ControlData.GT.controls = GT

local colors = _G.ControlData.GT.colors
GT["Ctr"] = CreateTitanBarControl(GT, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.GT.ui.control = GT["Ctr"]

GT["Lbl"] = CreateControlLabel(GT["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleRight)

SetupControlInteraction({
icon = GT["Lbl"],
controlTable = GT,
settingsSection = settings.GameTime,
windowImportPath = AppCtrD .. "GameTimeWindow",
windowFunction = "frmGameTimeWindow"
})

if _G.ControlData.GT.showBT then UpdateGameTime("bt");
elseif _G.ControlData.GT.showST then UpdateGameTime("st");
else UpdateGameTime("gt") end
end

-- Self-registration
_G.ControlRegistry.Register({
id = "GT",
settingsKey = "GameTime",
hasWhere = true,
defaults = { show = false, where = 1, x = 0, y = 0 },
initFunc = InitializeGameTime
})
