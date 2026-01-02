-- ControlRegistry.lua
-- Centralized control data management for TitanBar
-- Instead of scattered global variables, each control has a structured data object in _G.ControlData
-- This eliminates dozens of global variables like ShowWallet, WIbcAlpha, WILocX, etc.

_G.ControlRegistry = {}
_G.ControlData = {}

-- Initialize control data structure
-- This replaces scattered globals like ShowWallet, WIbcAlpha, WILocX, etc.
local function InitControlData(controlId, settingsKey, toggleFunc, hasWhere)
	_G.ControlData[controlId] = {
		id = controlId,
		settingsKey = settingsKey,
		toggleFunc = toggleFunc,
		
		-- Display state
		show = false,
		where = hasWhere and 1 or nil,  -- 1=TitanBar, 2=Tooltip, 3=Hidden (for controls with Where option)
		
		-- Colors (background)
		colors = {
			alpha = 0.3,
			red = 0.3,
			green = 0.3,
			blue = 0.3
		},
		
		-- Location on TitanBar
		location = {
			x = 0,
			y = 0
		},
		
		-- Window position (for control's settings window)
		window = {
			left = 100,
			top = 100
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
		hasWhere = false
	},
	Money = {
		settingsKey = "Money",
		toggleFunc = nil,
		hasWhere = true
	},
	BI = {
		settingsKey = "BagInfos",
		toggleFunc = nil,
		hasWhere = false
	},
	PI = {
		settingsKey = "PlayerInfos",
		toggleFunc = nil,
		hasWhere = false
	},
	EI = {
		settingsKey = "EquipInfos",
		toggleFunc = nil,
		hasWhere = false
	},
	DI = {
		settingsKey = "DurabilityInfos",
		toggleFunc = nil,
		hasWhere = false
	},
	PL = {
		settingsKey = "PlayerLoc",
		toggleFunc = nil,
		hasWhere = false
	},
	TI = {
		settingsKey = "TrackItems",
		toggleFunc = nil,
		hasWhere = false
	},
	IF = {
		settingsKey = "Infamy",
		toggleFunc = nil,
		hasWhere = false
	},
	VT = {
		settingsKey = "Vault",
		toggleFunc = nil,
		hasWhere = false
	},
	SS = {
		settingsKey = "SharedStorage",
		toggleFunc = nil,
		hasWhere = false
	},
	DN = {
		settingsKey = "DayNight",
		toggleFunc = nil,
		hasWhere = false
	},
	RP = {
		settingsKey = "Reputation",
		toggleFunc = nil,
		hasWhere = false
	},
	LP = {
		settingsKey = "LOTROPoints",
		toggleFunc = nil,
		hasWhere = true
	},
	GT = {
		settingsKey = "GameTime",
		toggleFunc = nil,
		hasWhere = false
	}
}

-- Initialize all control data structures
function _G.ControlRegistry.InitializeAll()
	for id, config in pairs(registry) do
		InitControlData(id, config.settingsKey, config.toggleFunc, config.hasWhere)
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

