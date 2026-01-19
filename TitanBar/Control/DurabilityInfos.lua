-- DurabilityInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "DurabilityInfosToolTip")
import(AppDirD .. "ControlFactory")

-- Moved from functions.lua
function UpdateDurabilityInfos()
    -- Ensure dependencies
    if not (itemEquip and AdjustIcon) then
         if GetEquipmentInfos then GetEquipmentInfos() end
    end
    if not itemEquip then return end

	local TDPts = 0;
	for i = 1, 20 do
        if itemEquip[i] then
            TDPts = TDPts + (itemEquip[i].WearStatePts or 0);
        end
    end
    if numItems == 0 then TDPts = 100;
    else TDPts = TDPts / numItems; end

	--Change durability icon with %
	local DurIcon = nil;
	if TDPts >= 0 and TDPts <= 33 then DurIcon = 1; end--0x41007e29
	if TDPts >= 34 and TDPts <= 66 then DurIcon = 2; end--0x41007e29
	if TDPts >= 67 and TDPts <= 100 then DurIcon = 3; end--0x41007e28
    
    if _G.ControlData.DI and _G.ControlData.DI.controls and _G.ControlData.DI.controls[ "Icon" ] then
	    _G.ControlData.DI.controls[ "Icon" ]:SetBackground( resources.Durability[DurIcon] );
    end

	TDPts = string.format( "%.0f", TDPts );
    if _G.ControlData.DI and _G.ControlData.DI.controls and _G.ControlData.DI.controls[ "Lbl" ] then
        _G.ControlData.DI.controls[ "Lbl" ]:SetText( TDPts .. "%" );
        _G.ControlData.DI.controls[ "Lbl" ]:SetSize( _G.ControlData.DI.controls[ "Lbl" ]:GetTextLength() * NM + 5, CTRHeight ); 
    end
	AdjustIcon( "DI" );
end

function InitializeDurabilityInfos()
    _G.ControlData.DI.controls = _G.ControlData.DI.controls or {}
    local DI = _G.ControlData.DI.controls
    local colors = _G.ControlData.DI.colors
    
    if not DI["Ctr"] then
        CreateTitanBarControl(DI, colors.alpha, colors.red, colors.green, colors.blue)
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
    end
    
    UpdateDurabilityInfos()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "DI",
		settingsKey = "DurabilityInfos",
		hasWhere = false,
		defaults = { show = true, x = nil, y = 0 },
		initFunc = InitializeDurabilityInfos
	})
end
