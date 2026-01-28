-- ControlRegistry.lua
-- Centralized control data management for TitanBar

_G.ControlRegistry = {}
_G.ControlData = {}

-- Initialize control data structure
local function InitControlData(controlId, settingsKey, toggleFunc, hasWhere, defaults, onShow, onHide)
	defaults = defaults or {}

	-- Preserve existing data if available (loaded from settings or elsewhere)
	local existing = _G.ControlData[controlId] or {}

	local data = {
		id = controlId,
		settingsKey = settingsKey,
		toggleFunc = toggleFunc,
		initFunc = defaults.initFunc,
		onShow = onShow,
		onHide = onHide,

		-- Display state
		show = defaults.show or false,
		where = hasWhere and (defaults.where or 1) or nil, -- 1=TitanBar, 2=Tooltip, 3=Hidden

		-- Colors (background)
		colors = {
			alpha = defaults.alpha or 0.3,
			red = defaults.red or 0.3,
			green = defaults.green or 0.3,
			blue = defaults.blue or 0.3
		},

		-- Location on TitanBar
		location = {
			x = defaults.x or 0,
			y = defaults.y or 0
		},

		-- Window position (for control's settings window)
		window = {
			left = defaults.winLeft or 100,
			top = defaults.winTop or 100
		},

		ui = {
			control = nil, -- The main control table
			optCheckbox = nil -- The options checkbox
		}
	}

	-- Preserve extra fields that might have been added by settings loading
	for k, v in pairs(existing) do
		if data[k] == nil then
			data[k] = v
		end
	end

	-- Sync with global settings if available.
	if _G.settings and _G.settings[settingsKey] then
		local section = _G.settings[settingsKey]

		if section.V ~= nil then data.show = section.V end

		if section.A then data.colors.alpha = tonumber(section.A) or data.colors.alpha end
		if section.R then data.colors.red = tonumber(section.R) or data.colors.red end
		if section.G then data.colors.green = tonumber(section.G) or data.colors.green end
		if section.B then data.colors.blue = tonumber(section.B) or data.colors.blue end

		if section.X then data.location.x = tonumber(section.X) or data.location.x end
		if section.Y then data.location.y = tonumber(section.Y) or data.location.y end

		if section.L then data.window.left = tonumber(section.L) or data.window.left end
		if section.T then data.window.top = tonumber(section.T) or data.window.top end

		if data.where ~= nil and section.W then data.where = tonumber(section.W) or data.where end
	end

	_G.ControlData[controlId] = data
	return data
end

-- Registry structure for each control - maps ID to metadata
local registry = {}

-- Helper function to get default X position for a control
local function GetDefaultX(controlId)
	if not Constants then return 0 end

	if controlId == "Money" then
		return Constants.DEFAULT_MONEY_X
	elseif controlId == "PI" then
		return Constants.DEFAULT_PLAYER_INFO_X
	elseif controlId == "EI" then
		return Constants.DEFAULT_EQUIP_INFO_X
	elseif controlId == "DI" then
		return Constants.DEFAULT_DURABILITY_INFO_X
	elseif controlId == "PL" then
		return screenWidth - Constants.DEFAULT_PLAYER_LOC_WIDTH
	else
		return 0
	end
end

-- Initialize all control data structures
function _G.ControlRegistry.InitializeAll()
	for id, config in pairs(registry) do
		-- Apply default x positions based on Constants if not set
		local defaults = config.defaults or {}
		if defaults.x == nil then
			defaults.x = GetDefaultX(id)
		end
		InitControlData(id, config.settingsKey, config.toggleFunc, config.hasWhere, defaults)
	end
end

-- Reset all controls to default values
function _G.ControlRegistry.ResetToDefaults()
	for id, config in pairs(registry) do
		local data = _G.ControlData[id]
		if data then
			local defaults = config.defaults or {}

			data.show = defaults.show or false
			if config.hasWhere then
				data.where = defaults.where or 1
			end

			data.colors.alpha = defaults.alpha or 0.3
			data.colors.red = defaults.red or 0.3
			data.colors.green = defaults.green or 0.3
			data.colors.blue = defaults.blue or 0.3

			data.location.x = defaults.x or GetDefaultX(id)
			data.location.y = defaults.y or 0
		end
	end
end

-- Register a control dynamically
function _G.ControlRegistry.Register(config)
	local id = config.id
	registry[id] = {
		settingsKey = config.settingsKey or id,
		toggleFunc = config.toggleFunc,
		hasWhere = config.hasWhere or false,
		defaults = config.defaults or {},
		onShow = config.onShow,
		onHide = config.onHide
	}
	-- Also store initFunc in defaults so InitControlData picks it up
	registry[id].defaults.initFunc = config.initFunc

	-- Initialize data immediately
	local defaults = registry[id].defaults
	if defaults.x == nil then defaults.x = GetDefaultX(id) end
	InitControlData(id, registry[id].settingsKey, registry[id].toggleFunc, registry[id].hasWhere, defaults, config.onShow, config.onHide)
end

-- Get registration metadata
function _G.ControlRegistry.GetMetadata(controlId)
	return registry[controlId]
end

-- Public API to get control data
function _G.ControlRegistry.Get(controlId)
	return _G.ControlData[controlId]
end

-- Get all control IDs
function _G.ControlRegistry.GetAllIds()
	local ids = {}
	for id, _ in pairs(registry) do
		table.insert(ids, id)
	end
	return ids
end

-- Helper function to iterate over all standard controls
function _G.ControlRegistry.ForEach(callback)
	for id, data in pairs(_G.ControlData) do
		callback(id, data)
	end
end

-- Set toggle function for a control (must be called after function is defined)
function _G.ControlRegistry.SetToggleFunc(controlId, func)
	if registry[controlId] then
		registry[controlId].toggleFunc = func
		if _G.ControlData[controlId] then
			_G.ControlData[controlId].toggleFunc = func
		end
	end
end

-- Helper to check if a control is a currency (uses different data structure)
function _G.ControlRegistry.IsCurrency(controlId)
	return _G.currencies and _G.currencies[controlId] ~= nil
end
