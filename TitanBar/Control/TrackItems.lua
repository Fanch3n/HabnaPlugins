import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import(AppCtrD .. "TrackItemsToolTip")

function InitializeTrackItems()
	-- Use _G.ControlData.TI.controls for all UI controls
	local TI = {}
	_G.ControlData.TI.controls = TI

	local colors = _G.ControlData.TI.colors
	TI["Ctr"] = CreateTitanBarControl(TI, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.TI.ui.control = TI["Ctr"]

	TI["Icon"] = CreateControlIcon(TI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.TrackItems)

	SetupControlInteraction({
		icon = TI["Icon"],
		controlTable = TI,
		settingsSection = settings.TrackItems,
		windowImportPath = AppCtrD .. "TrackItemsWindow",
		windowFunction = "frmTrackItemsWindow",
		customTooltipHandler = ShowTIWindow
	})
	
	UpdateTrackItems()
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "TI",
	settingsKey = "TrackItems",
	hasWhere = true,
	defaults = { show = false, where = 1, x = 0, y = 0 },
	initFunc = InitializeTrackItems
})
--**^