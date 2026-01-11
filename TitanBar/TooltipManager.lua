-- TooltipManager.lua
-- Centralizes tooltip state tracking so controls do not rely on per-control globals

TooltipManager = TooltipManager or {}

local tooltipStates = TooltipManager.__states or {}
TooltipManager.__states = tooltipStates

local function ensureState(key)
	local state = tooltipStates[key]
	if not state then
		state = { visible = false }
		tooltipStates[key] = state
	end
	return state
end

local function isWindowVisible(window)
	if window then
		local ok, visible = pcall(function()
			return window:IsVisible()
		end)
		if ok then
			return visible
		end
	end

	if _G.ToolTipWin then
		local ok, visible = pcall(function()
			return _G.ToolTipWin:IsVisible()
		end)
		if ok then
			return visible
		end
	end

	return false
end

local function defaultReposition()
	if type(PositionToolTipWindow) == "function" then
		PositionToolTipWindow()
	end
end

local function defaultHide()
	if type(ResetToolTipWin) == "function" then
		ResetToolTipWin()
	end
end

local function captureWindow(options)
	if options.getWindow then
		local ok, result = pcall(options.getWindow)
		if ok then
			return result
		else
			Turbine.Shell.WriteLine(string.format("TitanBar: tooltip getWindow failed for %s (%s)", options.key, result))
		end
	end
	return _G.ToolTipWin
end

function TooltipManager.Show(options)
	if not options or not options.key or not options.show then
		return
	end

	local state = ensureState(options.key)

	if state.visible and not isWindowVisible(state.window) then
		state.visible = false
		state.window = nil
	end

	if not state.visible then
		local ok, err = pcall(options.show)
		if not ok then
			Turbine.Shell.WriteLine(string.format("TitanBar: tooltip show failed for %s (%s)", options.key, err))
			return
		end

		state.visible = true
		if options.captureWindow ~= false then
			state.window = captureWindow(options)
		end
	else
		local reposition = options.reposition
		if reposition == nil then
			reposition = defaultReposition
		elseif reposition == false then
			reposition = nil
		end

		if reposition then
			local ok, err = pcall(reposition)
			if not ok then
				Turbine.Shell.WriteLine(string.format("TitanBar: tooltip reposition failed for %s (%s)", options.key, err))
			end
		end
	end
end

function TooltipManager.Hide(options)
	if not options or not options.key then
		return
	end

	local state = tooltipStates[options.key]
	if state then
		state.visible = false
		state.window = nil
	end

	local hideFn = options.hide
	if hideFn == nil then
		hideFn = defaultHide
	elseif hideFn == false then
		hideFn = nil
	end

	if hideFn then
		local ok, err = pcall(hideFn)
		if not ok then
			Turbine.Shell.WriteLine(string.format("TitanBar: tooltip hide failed for %s (%s)", options.key, err))
		end
	end
end

function TooltipManager.Reset(key)
	if key then
		local state = tooltipStates[key]
		if state then
			state.visible = false
			state.window = nil
		end
	else
		for _, state in pairs(tooltipStates) do
			state.visible = false
			state.window = nil
		end
	end
end
