import(AppDirD .. "UIHelpers")
import(AppCtrD .. "TrackItemsToolTip")
import(AppDirD .. "ControlFactory")

-- Moved from functions.lua
function UpdateTrackItems()
    if AdjustIcon then AdjustIcon( "TI" ); end
end

function InitializeTrackItems()
    _G.ControlData.TI.controls = _G.ControlData.TI.controls or {}
    local TI = _G.ControlData.TI.controls
    
    local colors = _G.ControlData.TI.colors
    if not TI["Ctr"] then
        CreateTitanBarControl(TI, colors.alpha, colors.red, colors.green, colors.blue)
        _G.ControlData.TI.ui.control = TI["Ctr"]

        TI["Icon"] = CreateControlIcon(TI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.TrackItems)

        SetupControlInteraction({
            icon = TI["Icon"],
            controlTable = TI,
            settingsSection = settings.TrackItems,
            windowImportPath = AppCtrD .. "TrackItemsWindow",
            windowFunction = "frmTrackItemsWindow",
            tooltipKey = "TI", -- Uses generic ShowTIToolTip? No, checked grep, usually tailored.
            customTooltipHandler = ShowTIWindow -- Assuming this name based on pattern
        })
    end
    
    UpdateTrackItems()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "TI",
		settingsKey = "TrackItems",
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 },
		initFunc = InitializeTrackItems
	})
end