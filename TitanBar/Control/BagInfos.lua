-- BagInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function InitializeBagInfos()
	-- Cleanup existing controls to prevent duplication
    if _G.ControlData.BI.controls and _G.ControlData.BI.controls["Ctr"] then
		_G.ControlData.BI.controls["Ctr"]:SetParent(nil)
	end
    
    local biData = _G.ControlData.BI
    
    -- Cleanup existing callbacks
    if biData.callbacks then
        for _, cb in ipairs(biData.callbacks) do
            if RemoveCallback then
                RemoveCallback(cb.obj, cb.evt, cb.func)
            end
        end
    end
    biData.callbacks = {}

	-- Use _G.ControlData.BI.controls for all UI controls
	local BI = {}
	_G.ControlData.BI.controls = BI

	--**v Control for backpack infos v**
	local colors = _G.ControlData.BI.colors
	CreateTitanBarControl(BI, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.BI.ui = _G.ControlData.BI.ui or {}
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
    
    -- Register Callbacks
    if AddCallback and backpack then
        local cbAdded = function(sender, args) UpdateBackpackInfos(); end
        AddCallback(backpack, "ItemAdded", cbAdded);
        table.insert(biData.callbacks, {obj=backpack, evt="ItemAdded", func=cbAdded})
        
        local cbRemoved = function(sender, args)
            if ItemRemovedTimer then ItemRemovedTimer:SetWantsUpdates( true ); end
        end
        AddCallback(backpack, "ItemRemoved", cbRemoved);
        table.insert(biData.callbacks, {obj=backpack, evt="ItemRemoved", func=cbRemoved})
    end
    
    UpdateBackpackInfos();
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "BI",
		settingsKey = "BagInfos",
		hasWhere = false,
		defaults = { show = true, x = 0, y = 0 },
		initFunc = InitializeBagInfos
	})
end