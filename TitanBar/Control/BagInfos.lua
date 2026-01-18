-- BagInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function UpdateBackpackInfos()
    -- Safety check: Ensure controls are initialized
    if not (_G.ControlData.BI and _G.ControlData.BI.controls and _G.ControlData.BI.controls["Lbl"]) then return end

	local max = backpack:GetSize();
	local freeslots = 0;

	for i = 1, max do
		if ( backpack:GetItem( i ) == nil ) then freeslots = freeslots + 1; end
	end

	local biData = (_G.ControlData and _G.ControlData.BI) or {}
	local showUsed = (biData.used ~= false) -- default true
	local showMax = (biData.max ~= false) -- default true

	if showUsed and showMax then 
        _G.ControlData.BI.controls[ "Lbl" ]:SetText( max - freeslots .. "/" .. max );
	elseif showUsed and not showMax then 
        _G.ControlData.BI.controls[ "Lbl" ]:SetText( max - freeslots );
	elseif (not showUsed) and showMax then 
        _G.ControlData.BI.controls[ "Lbl" ]:SetText( freeslots .. "/" .. max );
	elseif (not showUsed) and (not showMax) then 
        _G.ControlData.BI.controls[ "Lbl" ]:SetText( freeslots ); 
    end
	_G.ControlData.BI.controls[ "Lbl" ]:SetSize( _G.ControlData.BI.controls[ "Lbl" ]:GetTextLength() * NM, CTRHeight ); 

	--Change bag icon with capacity
	local i = nil;
	local usedslots = max - freeslots;
	local bi = round((( usedslots / max ) * 100));

	if bi >= 0 and bi <= 15 then i = 1; end-- 0% to 15% Full bag
	if bi >= 16 and bi <= 30 then i = 2; end-- 16% to 30% Full bag
	if bi >= 31 and bi <= 75 then i = 3; end-- 31% to 75% Full bag
	if bi >= 76 and bi <= 99 then i = 4; end-- 75% to 99% Full bag
	if bi == 100 then i = 5; end-- 100% Full bag
	--if bi >= 101 then BagIcon = 0x41007ecf; end-- over loaded bag
	
	_G.ControlData.BI.controls[ "Icon" ]:SetBackground( resources.BagIcon[i] );

	AdjustIcon( "BI" );
end

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