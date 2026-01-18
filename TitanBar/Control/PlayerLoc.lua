-- PlayerLoc.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function UpdatePlayerLoc( value )
    if not (_G.ControlData.PL and _G.ControlData.PL.controls and _G.ControlData.PL.controls["Lbl"]) then return end

	local fontMetric=FontMetric();
    fontMetric:SetFont(_G.TBFont);
	_G.ControlData.PL.controls[ "Lbl" ]:SetText( value );
	_G.ControlData.PL.controls[ "Lbl" ]:SetSize( fontMetric:GetTextWidth(value,fontMetric.FontSize), CTRHeight );

	_G.ControlData.PL.controls[ "Ctr" ]:SetSize( _G.ControlData.PL.controls[ "Lbl" ]:GetWidth(), CTRHeight );
end

function InitializePlayerLoc()
    -- Cleanup existing controls to prevent duplication
    if _G.ControlData.PL.controls and _G.ControlData.PL.controls["Ctr"] then
        _G.ControlData.PL.controls["Ctr"]:SetParent(nil)
    end
    
    local plData = _G.ControlData.PL
    
    -- Cleanup existing callbacks
    if plData.callbacks then
        for _, cb in ipairs(plData.callbacks) do
            if RemoveCallback then
                RemoveCallback(cb.obj, cb.evt, cb.func)
            end
        end
    end
    plData.callbacks = {}

    -- Use _G.ControlData.PL.controls for all UI controls
    local PL = {}
    _G.ControlData.PL.controls = PL

    local colors = _G.ControlData.PL.colors
    CreateTitanBarControl(PL, colors.alpha, colors.red, colors.green, colors.blue)
    _G.ControlData.PL.ui = _G.ControlData.PL.ui or {}
    _G.ControlData.PL.ui.control = PL["Ctr"]

    PL["Lbl"] = CreateControlLabel(PL["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleLeft)

    SetupControlInteraction({
        icon = PL["Lbl"],
        controlTable = PL,
        settingsSection = settings.PlayerLoc,
        onLeftClick = function() end
    })

    -- Callback registration
    if AddCallback then
        -- Chat (Location Monitoring)
        local cbChat = function(sender, args)
            if args.ChatType == Turbine.ChatType.Standard then
                local plMess = args.Message;
                if plMess ~= nil then
                    local plPattern;
                    if GLocale == "en" then
                        plPattern = "Entered the%s+(.-)%s*%-";
                    elseif GLocale == "fr" then
                        plPattern = "Canal%s+(.-)%s*%-";
                    elseif GLocale == "de" then
                        plPattern = "Chat%-Kanal%s+'(.-)%s*%-";
                    end

                    local tmpPL = string.match( plMess, plPattern );
                    if tmpPL ~= nil then
                        _G.ControlData.PL = _G.ControlData.PL or {}
                        _G.ControlData.PL.text = tmpPL
                        UpdatePlayerLoc( tmpPL );
                        settings.PlayerLoc.L = string.format( tmpPL );
                        SaveSettings( false );
                    end
                end
            end
        end
        AddCallback(Turbine.Chat, "Received", cbChat)
        table.insert(plData.callbacks, {obj=Turbine.Chat, evt="Received", func=cbChat})
    end

    local plText = (plData and plData.text) or (settings.PlayerLoc and settings.PlayerLoc.L) or L["PLMsg"]
    UpdatePlayerLoc( plText );
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "PL",
		settingsKey = "PlayerLoc",
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 },
		initFunc = InitializePlayerLoc
	})
end
