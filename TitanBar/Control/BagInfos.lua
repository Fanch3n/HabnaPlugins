-- BagInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function InitializeBagInfos()
	-- Use _G.ControlData.BI.controls for all UI controls
	local BI = {}
	_G.ControlData.BI.controls = BI

	--**v Control for backpack infos v**
	local colors = _G.ControlData.BI.colors
	CreateTitanBarControl(BI, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.BI.ui.control = BI["Ctr"]
	--**^
	--**v Backpack infos & icon on TitanBar v**
	BI["Icon"] = CreateControlIcon(BI["Ctr"], Constants.ICON_SIZE_MEDIUM, Constants.ICON_SIZE_MEDIUM_LARGE, nil, Turbine.UI.BlendMode.AlphaBlend)

	BI["Lbl"] = CreateControlLabel(BI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

	SetupControlInteraction({
		icon = BI["Lbl"],
		controlTable = BI,
		settingsSection = settings.BagInfos,
		windowImportPath = AppCtrD .. "BagInfosWindow",
		windowFunction = "frmBagInfos",
		leaveControl = BI["Lbl"]
	})

	-- Delegate icon events to the label so both regions behave the same
	DelegateMouseEvents(BI["Icon"], BI["Lbl"])
	--**^

	-- Set up callbacks
	AddCallback(backpack, "ItemAdded", function(sender, args) UpdateBackpackInfos(); end);
	AddCallback(backpack, "ItemRemoved", function(sender, args) ItemRemovedTimer:SetWantsUpdates(true); end); --Workaround
	
	UpdateBackpackInfos();
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "BI",
	settingsKey = "BagInfos",
	hasWhere = false,
	defaults = { show = true, x = 0, y = 0 },
	initFunc = InitializeBagInfos
})
