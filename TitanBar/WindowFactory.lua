-- Constants for key codes
local KEY_ESCAPE = Turbine.UI.Lotro.Action.Escape
local KEY_TOGGLE_UI = 268435635
local KEY_TOGGLE_LAYOUT_MODE = 268435579

-- Default window configuration
local DEFAULT_WINDOW_CONFIG = {
    onMouseMove = nil,
    onMouseDown = nil,
    onMouseUp = nil,
    onClosing = nil,
    dropdown = nil,
    settingsKey = nil,
    windowGlobalVar = nil,
    formGlobalVar = nil,
    onPositionChanged = nil,
    onKeyDown = nil,
}

function CreateWindow(windowSettings)
    local config = windowSettings.config or {}
    
    -- Merge with defaults
    for key, value in pairs(DEFAULT_WINDOW_CONFIG) do
        if config[key] == nil then
            config[key] = value
        end
    end

    local window = Turbine.UI.Lotro.Window()
    window:SetText(windowSettings.text)
    window:SetPosition(windowSettings.left, windowSettings.top)
    window:SetSize(windowSettings.width, windowSettings.height)
    window:SetWantsKeyEvents(true)
    window:SetVisible(true)
    window:Activate()

    local isDragging = false

    window.KeyDown = function(sender, args)
        if args.Action == KEY_ESCAPE then
            window:Close()
        elseif args.Action == KEY_TOGGLE_UI or args.Action == KEY_TOGGLE_LAYOUT_MODE then
            window:SetVisible(not window:IsVisible())
        end

        -- Allow consumer to handle additional key events. If provided, call after
        -- the factory default handling so callers can implement keys like Enter.
        if config.onKeyDown then
            pcall(function() config.onKeyDown(sender, args) end)
        end
    end

    window.MouseDown = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then
            isDragging = true
            if config.onMouseDown then config.onMouseDown(sender, args) end
        end
    end

    window.MouseMove = function(sender, args)
        if config.dropdown and isDragging then
            config.dropdown:CloseDropDown()
        end
        if config.onMouseMove then config.onMouseMove(sender, args) end
    end

    window.MouseUp = function(sender, args)
        isDragging = false
        
        -- Save position
        if config.settingsKey then
            settings[config.settingsKey].L = string.format("%.0f", window:GetLeft())
            settings[config.settingsKey].T = string.format("%.0f", window:GetTop())
            if config.onPositionChanged then
                config.onPositionChanged(window:GetPosition())
            end
            SaveSettings(false)
        end
        
        if config.onMouseUp then config.onMouseUp(sender, args) end
    end

    window.Closing = function(sender, args)
        window:SetWantsKeyEvents(false)
        
        if config.dropdown then
            config.dropdown.dropDownWindow:SetVisible(false)
        end
        
        if config.onClosing then config.onClosing(sender, args) end
        
        if config.windowGlobalVar then
            _G[config.windowGlobalVar] = nil
        end
        if config.formGlobalVar then
            _G[config.formGlobalVar] = nil
        end
    end

    return window
end