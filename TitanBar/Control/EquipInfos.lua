import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import(AppCtrD .. "EquipInfosToolTip")

function InitializeEquipInfos()
	-- Use _G.ControlData.EI.controls for all UI controls
	local EI = {}
	_G.ControlData.EI.controls = EI

	local colors = _G.ControlData.EI.colors
	EI["Ctr"] = CreateTitanBarControl(EI, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.EI.ui.control = EI["Ctr"]

	EI["Icon"] = CreateControlIcon(EI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
	EI["Icon"]:SetBackground(0x410f2ea5)

	EI["Lbl"] = CreateControlLabel(EI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

	SetupControlInteraction({
		icon = EI["Lbl"],
		controlTable = EI,
		settingsSection = settings.EquipInfos,
		onLeftClick = function() end,
		customTooltipHandler = ShowEIWindow
	})

	DelegateMouseEvents(EI["Icon"], EI["Lbl"])
	
	UpdateEquipsInfos()
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "EI",
	settingsKey = "EquipInfos",
	hasWhere = true,
	defaults = { show = false, where = 1, x = 0, y = 0 },
	initFunc = InitializeEquipInfos
})
