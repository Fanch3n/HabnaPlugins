-- ControlRegistry.lua
-- Centralized control data management for TitanBar
-- Instead of scattered global variables, each control has a structured data object in _G.ControlData
-- This eliminates dozens of global variables like ShowWallet, WIbcAlpha, WILocX, etc.

_G.ControlRegistry = {}
_G.ControlData = {}

-- Initialize control data structure
-- This replaces scattered globals like ShowWallet, WIbcAlpha, WILocX, etc.
local function InitControlData(controlId, settingsKey, toggleFunc, hasWhere, defaults)
	defaults = defaults or {}
	_G.ControlData[controlId] = {
		id = controlId,
		settingsKey = settingsKey,
		toggleFunc = toggleFunc,
		
		-- Display state
		show = defaults.show or false,
		where = hasWhere and (defaults.where or 1) or nil,  -- 1=TitanBar, 2=Tooltip, 3=Hidden (for controls with Where option)
		
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
		
		-- UI references (set when control is created)
		ui = {
			control = nil,      -- The main control table (WI, BI, etc.)
			optCheckbox = nil   -- The options checkbox (opt_WI, opt_BI, etc.)
		}
	}
	
	return _G.ControlData[controlId]
end

-- Registry structure for each control - maps ID to metadata
-- This is configuration, while ControlData holds runtime state
local registry = {
	WI = {
		settingsKey = "Wallet",
		toggleFunc = nil,  -- Set after function is defined
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 }
	},
	Money = {
		settingsKey = "Money",
		toggleFunc = nil,
		hasWhere = true,
		defaults = { show = true, where = 1, x = nil, y = 0 }  -- x set in InitializeAll based on Constants
	},
	BI = {
		settingsKey = "BagInfos",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = true, x = 0, y = 0 }
	},
	PI = {
		settingsKey = "PlayerInfos",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = false, x = nil, y = 0 }  -- x set in InitializeAll
	},
	EI = {
		settingsKey = "EquipInfos",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = true, x = nil, y = 0 }  -- x set in InitializeAll
	},
	DI = {
		settingsKey = "DurabilityInfos",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = true, x = nil, y = 0 }  -- x set in InitializeAll
	},
	PL = {
		settingsKey = "PlayerLoc",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = true, x = nil, y = 0 }  -- x set in InitializeAll
	},
	TI = {
		settingsKey = "TrackItems",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 }
	},
	IF = {
		settingsKey = "Infamy",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 }
	},
	VT = {
		settingsKey = "Vault",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 }
	},
	SS = {
		settingsKey = "SharedStorage",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 }
	},
	DN = {
		settingsKey = "DayNight",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 }
	},
	RP = {
		settingsKey = "Reputation",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 }
	},
	LP = {
		settingsKey = "LOTROPoints",
		toggleFunc = nil,
		hasWhere = true,
		defaults = { show = false, where = 3, x = 0, y = 0 }
	},
	GT = {
		settingsKey = "GameTime",
		toggleFunc = nil,
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 }
	}
}

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
		local defaults = config.defaults or {}
		
		-- Reset display state
		data.show = defaults.show or false
		if config.hasWhere then
			data.where = defaults.where or 1
		end
		
		-- Reset colors to default
		data.colors.alpha = defaults.alpha or 0.3
		data.colors.red = defaults.red or 0.3
		data.colors.green = defaults.green or 0.3
		data.colors.blue = defaults.blue or 0.3
		
		-- Reset location
		local defaultX = defaults.x
		if defaultX == nil then
			defaultX = GetDefaultX(id)
		end
		data.location.x = defaultX
		data.location.y = defaults.y or 0
		
		-- Keep window positions as they are (don't reset)
		-- Keep ui references as they are
	end
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

-- Backward compatibility helpers
-- These functions allow gradual migration from old variable names to ControlData
_G.ControlRegistry.LegacyMapping = {
	-- ShowXxx variables
	ShowWallet = function() return _G.ControlData.WI.show end,
	SetShowWallet = function(val) _G.ControlData.WI.show = val end,
	
	ShowMoney = function() return _G.ControlData.Money.show end,
	SetShowMoney = function(val) _G.ControlData.Money.show = val end,
	
	ShowBagInfos = function() return _G.ControlData.BI.show end,
	SetShowBagInfos = function(val) _G.ControlData.BI.show = val end,
	
	ShowPlayerInfos = function() return _G.ControlData.PI.show end,
	SetShowPlayerInfos = function(val) _G.ControlData.PI.show = val end,
	
	ShowEquipInfos = function() return _G.ControlData.EI.show end,
	SetShowEquipInfos = function(val) _G.ControlData.EI.show = val end,
	
	ShowDurabilityInfos = function() return _G.ControlData.DI.show end,
	SetShowDurabilityInfos = function(val) _G.ControlData.DI.show = val end,
	
	ShowPlayerLoc = function() return _G.ControlData.PL.show end,
	SetShowPlayerLoc = function(val) _G.ControlData.PL.show = val end,
	
	ShowTrackItems = function() return _G.ControlData.TI.show end,
	SetShowTrackItems = function(val) _G.ControlData.TI.show = val end,
	
	ShowInfamy = function() return _G.ControlData.IF.show end,
	SetShowInfamy = function(val) _G.ControlData.IF.show = val end,
	
	ShowVault = function() return _G.ControlData.VT.show end,
	SetShowVault = function(val) _G.ControlData.VT.show = val end,
	
	ShowSharedStorage = function() return _G.ControlData.SS.show end,
	SetShowSharedStorage = function(val) _G.ControlData.SS.show = val end,
	
	ShowDayNight = function() return _G.ControlData.DN.show end,
	SetShowDayNight = function(val) _G.ControlData.DN.show = val end,
	
	ShowReputation = function() return _G.ControlData.RP.show end,
	SetShowReputation = function(val) _G.ControlData.RP.show = val end,
	
	ShowLOTROPoints = function() return _G.ControlData.LP.show end,
	SetShowLOTROPoints = function(val) _G.ControlData.LP.show = val end,
	
	ShowGameTime = function() return _G.ControlData.GT.show end,
	SetShowGameTime = function(val) _G.ControlData.GT.show = val end
}

