-- ControlFactory.lua
-- Factory functions for creating TitanBar controls consistently
-- Eliminates repetitive control setup code

-- ============================================================================
-- TITANBAR CONTROL CREATION
-- ============================================================================

-- Creates a standard TitanBar control with common properties
-- Parameters:
--   controlTable: The global table to populate (e.g., WI, MI, BI)
--   alpha, red, green, blue: Color values for the control background
-- Returns: The created control
function CreateTitanBarControl(controlTable, alpha, red, green, blue)
	local control = Turbine.UI.Control()
	control:SetParent(TB["win"])
	control:SetMouseVisible(false)
	control:SetZOrder(2)
	control:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
	control:SetBackColor(Turbine.UI.Color(alpha, red, green, blue))
	
	controlTable["Ctr"] = control
	return control
end

-- ============================================================================
-- ICON CREATION
-- ============================================================================

-- Creates a standard icon control for TitanBar controls
-- Parameters:
--   parent: The parent control
--   width, height: Icon dimensions (final desired size)
--   background: Optional background resource
--   blendMode: Optional blend mode (defaults to AlphaBlend)
--   stretchMode: Optional stretch mode (0, 1, or nil)
--   originalWidth, originalHeight: Required if stretchMode is 1 (original image size)
-- Returns: The created icon control
-- Note: For StretchMode 1, the control is first set to originalWidth/Height, then stretch mode
--       is applied, then it's resized to width/height. This ensures proper scaling behavior.
function CreateControlIcon(parent, width, height, background, blendMode, stretchMode, originalWidth, originalHeight)
	local icon = Turbine.UI.Control()
	icon:SetParent(parent)
	icon:SetBlendMode(blendMode or Turbine.UI.BlendMode.AlphaBlend)
	
	-- Handle StretchMode 1 correctly: set original size first, then stretch mode, then final size
	if stretchMode == 1 then
		if not originalWidth or not originalHeight then
			error("CreateControlIcon: originalWidth and originalHeight are required when stretchMode is 1")
		end
		icon:SetSize(originalWidth, originalHeight)
		if background then
			icon:SetBackground(background)
		end
		icon:SetStretchMode(1)
		icon:SetSize(width, height)
	else
		icon:SetSize(width, height)
		if background then
			icon:SetBackground(background)
		end
		if stretchMode then
			icon:SetStretchMode(stretchMode)
		end
	end
	
	return icon
end

-- ============================================================================
-- DRAG AND CLICK HANDLERS
-- ============================================================================

-- Sets up complete mouse interaction for a TitanBar control icon
-- Includes dragging, tooltip, window toggle, and right-click menu
-- Parameters:
--   icon: The icon control to attach handlers to
--   controlTable: The control's global table (controlId will be derived from ControlData)
--   settingsSection: The settings table section for this control
--   controlId: Optional control identifier (will be auto-derived from controlTable if not provided)
--   tooltipName: Optional tooltip identifier (defaults to controlId)
--   windowImportPath: Optional import path (defaults to AppCtrD + controlId + "Window")
--   windowFunction: Optional window function name (defaults to "frm" + controlId + "Window")
function SetupControlInteraction(config)
	local icon = config.icon
	local controlTable = config.controlTable
	local settingsSection = config.settingsSection
	
	-- Derive controlId from controlTable by finding which ControlData entry references it
	local controlId = config.controlId
	if not controlId and controlTable then
		for id, data in pairs(_G.ControlData) do
			if data.ui.control == controlTable["Ctr"] then
				controlId = id
				break
			end
		end
	end
	
	-- Use controlId for all derived values
	local tooltipName = config.tooltipName or controlId
	local windowImportPath = config.windowImportPath or (AppCtrD .. controlId .. "Window")
	local windowFunction = config.windowFunction or ("frm" .. controlId .. "Window")
	local hasTooltip = config.hasTooltip ~= false -- default true
	local customTooltipHandler = config.customTooltipHandler -- optional custom tooltip show function
	local tooltipKey = config.tooltipKey or controlId
	local tooltipReposition = config.tooltipReposition
	local tooltipHide = config.tooltipHide
	local tooltipGetWindow = config.tooltipGetWindow
	local tooltipCaptureWindow = config.tooltipCaptureWindow
	local leaveControl = config.leaveControl
	local onLeftClick = config.onLeftClick
	local onRightClick = config.onRightClick

	if tooltipReposition == nil and hasTooltip then
		tooltipReposition = type(PositionToolTipWindow) == "function" and PositionToolTipWindow or nil
	elseif tooltipReposition == false then
		tooltipReposition = nil
	end

	local tooltipOptions = nil
	if hasTooltip then
		local tooltipShowFn
		if customTooltipHandler then
			tooltipShowFn = customTooltipHandler
		else
			tooltipShowFn = function()
				ShowToolTipWin(tooltipName)
			end
		end

		tooltipOptions = {
			key = tooltipKey,
			show = tooltipShowFn,
			reposition = tooltipReposition,
			hide = tooltipHide,
			getWindow = tooltipGetWindow,
			captureWindow = tooltipCaptureWindow
		}
	end
	
	-- Create move handler
	local moveCtr = CreateMoveHandler(controlTable["Ctr"], icon)
	
	-- Mouse move handler
	icon.MouseMove = function(sender, args)
		if leaveControl and leaveControl.MouseLeave then
			leaveControl.MouseLeave(sender, args)
		end
		TB["win"].MouseMove()
		if _G.dragging then
			moveCtr(sender, args)
		elseif tooltipOptions then
			TooltipManager.Show(tooltipOptions)
		end
	end
	
	-- Mouse leave handler
	if tooltipOptions then
		icon.MouseLeave = function(sender, args)
			TooltipManager.Hide(tooltipOptions)
		end
	end
	
	local function logError(prefix, err)
		Turbine.Shell.WriteLine(string.format("TitanBar: %s (%s)", prefix, err))
	end

	local function findWindowFunction()
		if _G[windowFunction] then
			return _G[windowFunction]
		end
		local function tryNamespace(ns)
			if ns and type(ns[windowFunction]) == "function" then
				return ns[windowFunction]
			end
			return nil
		end
		return tryNamespace(HabnaPlugins and HabnaPlugins.TitanBar and HabnaPlugins.TitanBar.Control)
			or tryNamespace(HabnaPlugins and HabnaPlugins.TitanBar)
			or tryNamespace(HabnaPlugins)
	end

	local function toggleWindowDefault()
		-- Check if window exists in ControlData
		local window = _G.ControlData[controlId].windowInstance
		if window then
			-- Window is open, close it
			local ok, err = pcall(function()
				window:Close()
			end)
			if not ok then
				logError("failed to close " .. controlId .. " window", err)
			end
		else
			-- Window is closed, open it
			local ok, err = pcall(function()
				import(windowImportPath)
				local windowFn = findWindowFunction()
				if windowFn then
					windowFn()
				else
					error("window function '" .. windowFunction .. "' not found")
				end
			end)
			if not ok then
				logError("failed to open " .. controlId .. " window", err)
			end
		end
	end

	local function handleRightClick()
		if onRightClick then
			onRightClick()
		else
			_G.sFromCtr = controlId
			ControlMenu:ShowMenu()
		end
	end

	-- Mouse click handler
	icon.MouseClick = function(sender, args)
		TB["win"].MouseMove()
		if args.Button == Turbine.UI.MouseButton.Left then
			if not _G.WasDrag then
				if onLeftClick then
					onLeftClick()
				else
					toggleWindowDefault()
				end
			end
		elseif args.Button == Turbine.UI.MouseButton.Right then
			handleRightClick()
	end
	_G.WasDrag = false
end

-- Drag handlers
local dragHandlers = CreateDragHandlers(controlTable["Ctr"], settingsSection, controlId)
icon.MouseDown = dragHandlers.MouseDown
icon.MouseUp = dragHandlers.MouseUp
end-- ============================================================================
-- LABEL CREATION
-- ============================================================================

-- Creates a standard label for TitanBar controls
-- Parameters:
--   parent: The parent control
--   font: Optional font (defaults to _G.TBFont)
--   textAlignment: Optional alignment (defaults to MiddleRight)
-- Returns: The created label
function CreateControlLabel(parent, font, textAlignment)
	local label = Turbine.UI.Label()
	label:SetParent(parent)
	label:SetFont(font or _G.TBFont)
	label:SetPosition(0, 0)
	label:SetFontStyle(Turbine.UI.FontStyle.Outline)
	label:SetTextAlignment(textAlignment or Turbine.UI.ContentAlignment.MiddleRight)
	return label
end