-- DurabilityInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import(AppCtrD .. "DurabilityInfosToolTip")

function InitializeDurabilityInfos()
	-- Use _G.ControlData.DI.controls for all UI controls
	local DI = {}
	_G.ControlData.DI.controls = DI

	local colors = _G.ControlData.DI.colors
	DI["Ctr"] = CreateTitanBarControl(DI, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.DI.ui.control = DI["Ctr"]

	DI["Icon"] = CreateControlIcon(DI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

	DI["Lbl"] = CreateControlLabel(DI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

	SetupControlInteraction({
		icon = DI["Lbl"],
		controlTable = DI,
		settingsSection = settings.DurabilityInfos,
		windowImportPath = AppCtrD .. "DurabilityInfosWindow",
		windowFunction = "frmDurabilityInfosWindow",
		customTooltipHandler = ShowDIWindow
	})

	DelegateMouseEvents(DI["Icon"], DI["Lbl"])
	
	UpdateDurabilityInfos()
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "DI",
	settingsKey = "DurabilityInfos",
	hasWhere = true,
	defaults = { show = false, where = 1, x = 0, y = 0 },
	initFunc = InitializeDurabilityInfos
})
--**^