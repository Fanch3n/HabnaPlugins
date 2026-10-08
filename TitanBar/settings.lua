-- settings.lua
-- Written by Habna
-- Rewritten by many

-- Defaults for new settings, set in LoadSettings()
local tA, tR, tG, tB, tX, tY, tL, tT

-- ============================================================================
-- HELPER FUNCTIONS FOR LOADING SETTINGS
-- ============================================================================

-- Save ControlData to settings structure  
local function SaveControlSettings(controlId, settingsSection)
	local data = _G.ControlData[controlId]
	if not (data and data.colors) then return end
	
	settingsSection.V = data.show
	settingsSection.A = Constants.FormatFloat(data.colors.alpha)
	settingsSection.R = Constants.FormatFloat(data.colors.red)
	settingsSection.G = Constants.FormatFloat(data.colors.green)
	settingsSection.B = Constants.FormatFloat(data.colors.blue)
	settingsSection.X = Constants.FormatInt(data.location.x)
	settingsSection.Y = Constants.FormatInt(data.location.y)
	settingsSection.L = Constants.FormatInt(data.window.left)
	settingsSection.T = Constants.FormatInt(data.window.top)
	
	if data.where ~= nil then
		settingsSection.W = Constants.FormatInt(data.where)
	end
end

-- Initialize a settings section if it doesn't exist
local function EnsureSettingsSection(sectionName)
	if settings[sectionName] == nil then 
		settings[sectionName] = {}
	end
	return settings[sectionName]
end

-- Set default color values (Alpha, Red, Green, Blue) for a settings section
local function SetDefaultColors(section, a, r, g, b)
	section.A = section.A or Constants.FormatFloat(a)
	section.R = section.R or Constants.FormatFloat(r)
	section.G = section.G or Constants.FormatFloat(g)
	section.B = section.B or Constants.FormatFloat(b)
end

-- Set default position (X, Y) for a control on TitanBar
local function SetDefaultPosition(section, x, y)
	section.X = section.X or Constants.FormatInt(x)
	section.Y = section.Y or Constants.FormatInt(y)
end

-- Set default window position (Left, Top) for a window
local function SetDefaultWindowPosition(section, left, top)
	section.L = section.L or Constants.FormatInt(left)
	section.T = section.T or Constants.FormatInt(top)
end

-- Initialize a control with standard defaults (colors, position, window position)
-- If colorDefaults/posDefaults/windowPosDefaults are not provided or are empty tables,
-- the function will use the default tA, tR, tG, tB, tX, tY, tL, tT values
local function InitControlDefaults(sectionName, colorDefaults, posDefaults, windowPosDefaults)
	local section = EnsureSettingsSection(sectionName)
	
	-- Apply color defaults (use tA, tR, tG, tB if not overridden)
	colorDefaults = colorDefaults or {}
	SetDefaultColors(section, 
		colorDefaults.a or tA, 
		colorDefaults.r or tR, 
		colorDefaults.g or tG, 
		colorDefaults.b or tB)
	
	-- Apply position defaults (use tX, tY if not overridden)
	posDefaults = posDefaults or {}
	SetDefaultPosition(section, posDefaults.x or tX, posDefaults.y or tY)
	
	-- Apply window position defaults only if explicitly provided
	if windowPosDefaults then
		SetDefaultWindowPosition(section, 
			windowPosDefaults.left or tL, 
			windowPosDefaults.top or tT)
	end
	
	return section
end

-- ============================================================================
-- HELPER FUNCTIONS FOR SAVING SETTINGS
-- ============================================================================

-- Save color values (Alpha, Red, Green, Blue) to a settings section
local function SaveColors(section, alpha, red, green, blue)
	section.A = string.format("%.3f", alpha)
	section.R = string.format("%.3f", red)
	section.G = string.format("%.3f", green)
	section.B = string.format("%.3f", blue)
end

-- Save position values (X, Y) to a settings section
local function SavePosition(section, x, y)
	section.X = string.format("%.0f", x)
	section.Y = string.format("%.0f", y)
end

-- Save window position values (Left, Top) to a settings section
local function SaveWindowPosition(section, left, top)
	section.L = string.format("%.0f", left)
	section.T = string.format("%.0f", top)
end

-- ============================================================================
-- SETTINGS OF THE CONTROLS
-- ============================================================================
-- One entry per control. Loading, saving and "Reset all settings" all work from this table.
--   id: the ControlData / ControlRegistry id; section: the section in the settings file
--   show, where, x: defaults of the standard fields (x can be a function for positions that depend on the bar width)
--   noWindow: the control has no window, so no window position is stored (PlayerLoc uses L for its text)
--   fields: the control's own settings, saved as section[key] and kept in ControlData[id][field]
--     type: "bool" (the default), "int" (saved as a whole number), "float" (saved with 3 decimals) or "string"
--     default: value of the field for new characters and after a reset (can be a function)
--     invert: the saved value is the opposite of the field
--     keepOnReset: "Reset all settings" keeps the current value
local CONTROL_SETTINGS = {
	{ id = "WI", section = "Wallet" },
	{ id = "Money", section = "Money", show = true, where = Constants.Position.TITANBAR, x = Constants.DEFAULT_MONEY_X,
		fields = {
			{ key = "S", field = "stm", default = false }, -- Show total money of all characters on the control
			{ key = "SS", field = "sss", default = true }, -- Show statistics of the session
			{ key = "TS", field = "sts", default = true }, -- Show statistics of today
		} },
	{ id = "LP", section = "LOTROPoints", where = Constants.Position.NONE },
	{ id = "BI", section = "BagInfos", show = true,
		fields = {
			{ key = "U", field = "used", default = true },
			{ key = "M", field = "max", default = true },
		} },
	{ id = "PI", section = "PlayerInfos", x = Constants.DEFAULT_PLAYER_INFO_X, noWindow = true,
		fields = {
			{ key = "XP", field = "xp", type = "string", default = "0", keepOnReset = true },
			{ key = "Layout", field = "layout", default = false, keepOnReset = true },
		} },
	{ id = "EI", section = "EquipInfos", show = true, x = Constants.DEFAULT_EQUIP_INFO_X, noWindow = true },
	{ id = "DI", section = "DurabilityInfos", show = true, x = Constants.DEFAULT_DURABILITY_INFO_X,
		fields = {
			{ key = "I", field = "icon", default = true },
			{ key = "N", field = "text", default = true },
		} },
	{ id = "PL", section = "PlayerLoc", show = true, x = function() return TBWidth - Constants.DEFAULT_PLAYER_LOC_WIDTH end, noWindow = true,
		fields = {
			{ key = "L", field = "text", type = "string", default = function() return L["PLMsg"] end, keepOnReset = true },
		} },
	{ id = "TI", section = "TrackItems" },
	{ id = "IF", section = "Infamy",
		fields = {
			{ key = "F", field = "set", default = true, keepOnReset = true },
			{ key = "P", field = "points", type = "int", default = 0, keepOnReset = true },
			{ key = "K", field = "rank", type = "int", default = 0, keepOnReset = true },
		} },
	{ id = "VT", section = "Vault" },
	{ id = "SS", section = "SharedStorage" },
	{ id = "DN", section = "DayNight",
		fields = {
			{ key = "N", field = "next", default = true },
			{ key = "S", field = "ts", type = "int", default = 10350, keepOnReset = true },
		} },
	{ id = "RP", section = "Reputation",
		fields = {
			{ key = "H", field = "showMax", default = false, invert = true }, -- saved as "hide max"
		} },
	{ id = "GT", section = "GameTime", show = true, x = function() return TBWidth - Constants.GAME_TIME_DEFAULT_OFFSET end,
		fields = {
			{ key = "H", field = "clock24h", default = false },
			{ key = "S", field = "showST", default = false }, -- Show server time
			{ key = "O", field = "showBT", default = false }, -- Show both server and real time
			{ key = "M", field = "userGMT", type = "int", default = 0 },
		} },
}

local function DefaultX(control)
	if type(control.x) == "function" then return control.x() end
	return control.x or 0
end

local function DefaultValue(field)
	if type(field.default) == "function" then return field.default() end
	return field.default
end

-- Value of a field as it is saved in the settings file
local function SavedValue(field, value)
	if value == nil then value = DefaultValue(field) end
	if field.type == "int" then return Constants.FormatInt(tonumber(value) or DefaultValue(field)) end
	if field.type == "float" then return Constants.FormatFloat(tonumber(value) or DefaultValue(field)) end
	if field.type == "string" then return value end
	if field.invert then return value ~= true end
	return value == true
end

-- Value of a field as it is kept in ControlData
local function LoadedValue(field, saved)
	if field.type == "int" or field.type == "float" then return tonumber(saved) or DefaultValue(field) end
	if field.type == "string" then return saved end
	if field.invert then return saved ~= true end
	return saved == true
end

-- Defaults of the standard fields of a control, used by ControlRegistry.Register()
function GetControlDefaults(controlId)
	for _, control in ipairs(CONTROL_SETTINGS) do
		if control.id == controlId then
			return { show = control.show or false, where = control.where, x = DefaultX(control), y = 0 }
		end
	end
end

-- ============================================================================
-- LANGUAGE-INDEPENDENT VALUES
-- ============================================================================

-- PluginData writes numbers with the decimal separator of the game language (e.g. 1,5 in German),
-- and no client can read such a file back. So only strings and booleans are saved.
-- Returns a copy of t with all numbers (values and keys) turned into strings.
function SaveableTable(t)
	local copy = {}
	for k, v in pairs(t) do
		if type(k) == "number" then k = tostring(k) end
		if type(v) == "number" then
			v = tostring(v)
		elseif type(v) == "table" then
			v = SaveableTable(v)
		end
		copy[k] = v
	end
	return copy
end

-- Auto hide is saved as a code. Older versions saved the translated text of the option.
local AUTO_HIDE_KEYS = { never = "OPAHD", always = "OPAHE", combat = "OPAHC" }
local AUTO_HIDE_OLD_TEXTS = {
	["Disabled"] = "never", ["D\195\169sactiver"] = "never", ["niemals"] = "never",
	["Always"] = "always", ["Toujours"] = "always", ["immer"] = "always",
	["Only in combat"] = "combat", ["Seulement en combat"] = "combat", ["Nur in der Schlacht"] = "combat",
}

-- Saved value (code or old text) -> text of the option in TitanBar's language, as used at runtime
local function AutoHideText(saved)
	local code = AUTO_HIDE_KEYS[saved] and saved or AUTO_HIDE_OLD_TEXTS[saved] or "never"
	return L[AUTO_HIDE_KEYS[code]]
end

-- Text of the option -> code to save
local function AutoHideCode(text)
	for code, key in pairs(AUTO_HIDE_KEYS) do
		if L[key] == text then return code end
	end
	return "never"
end

-- Icon size, saved as text by very old versions
local ICON_SIZE_OLD_TEXTS = {
	["Small (16x16)"] = Constants.ICON_SIZE_SMALL, ["Petit (16x16)"] = Constants.ICON_SIZE_SMALL, ["klein (16x16)"] = Constants.ICON_SIZE_SMALL,
	["Large (32x32)"] = Constants.ICON_SIZE_LARGE, ["Grand (32x32)"] = Constants.ICON_SIZE_LARGE, ["Breit (32x32)"] = Constants.ICON_SIZE_LARGE,
}

-- The game languages, the current one first: the order in which files of older versions are taken over
function GameLocalesCurrentFirst()
	local order = { GLocale }
	for _, locale in ipairs({ "en", "de", "fr" }) do
		if locale ~= GLocale then table.insert(order, locale) end
	end
	return order
end

-- Loads the settings file. On the first start of a version with one file for all game languages,
-- the file of the current game language is taken over, or else the file of another language.
-- The old files are kept, so older TitanBar versions still find them.
local function LoadSettingsFile()
	local loaded = Turbine.PluginData.Load( Constants.SETTINGS_SCOPE, Constants.SETTINGS_NAME )
	if loaded then return loaded end

	for _, locale in ipairs(GameLocalesCurrentFirst()) do
		local ok, old = pcall(Turbine.PluginData.Load, Constants.SETTINGS_SCOPE, Constants.GetSettingsName(locale))
		if ok and type(old) == "table" then
			-- TitanBar's language was the game language unless it was changed in the menu
			if old.TitanBar and old.TitanBar.L == locale then old.TitanBar.L = "auto" end
			return old
		end
	end
end

-- ============================================================================
-- SETTINGS OF TITANBAR ITSELF
-- ============================================================================
-- Kept in global variables. Loading, saving and "Reset all settings" all work from these tables.

-- Fields per section, like the fields of CONTROL_SETTINGS (key, type, default, keepOnReset), and:
--   get, set: access to the variable that holds the value at runtime
--   load, save: conversion between the saved value and the variable, instead of type
--   reset: value after "Reset all settings", if it is not the default (a function)
local BAR_SETTINGS = {
	TitanBar = {
		{ key = "A", type = "float", default = Constants.DEFAULT_ALPHA, get = function() return bcAlpha end, set = function(v) bcAlpha = v end },
		{ key = "R", type = "float", default = Constants.DEFAULT_RED, get = function() return bcRed end, set = function(v) bcRed = v end },
		{ key = "G", type = "float", default = Constants.DEFAULT_GREEN, get = function() return bcGreen end, set = function(v) bcGreen = v end },
		{ key = "B", type = "float", default = Constants.DEFAULT_BLUE, get = function() return bcBlue end, set = function(v) bcBlue = v end },
		{ key = "W", type = "int", default = function() return screenWidth end, keepOnReset = true,
			get = function() return TBWidth end, set = function(v) TBWidth = v end },
		-- TitanBar's language, "auto": the game language
		{ key = "L", type = "string", default = "auto", get = function() return TBLocaleChoice end, set = function(v) TBLocaleChoice = v end },
		{ key = "H", type = "int", default = Constants.DEFAULT_TITANBAR_HEIGHT, get = function() return TBHeight end, set = function(v) TBHeight = v end },
		{ key = "F", type = "int", default = Constants.DEFAULT_TITANBAR_FONT_ID, get = function() return _G.TBFont end, set = function(v) _G.TBFont = v end },
		{ key = "T", type = "string", default = Constants.DEFAULT_TITANBAR_FONT_NAME, get = function() return TBFontT end, set = function(v) TBFontT = v end },
		-- TitanBar at the top of the screen
		{ key = "D", default = true, get = function() return TBTop end, set = function(v) TBTop = v end },
		-- TitanBar was reloaded, and the window to open again after the reload ("Profile", "Font" or "TB" for none)
		{ key = "Z", default = false, keepOnReset = true, get = function() return TBReloaded end, set = function(v) TBReloaded = v end },
		{ key = "ZT", type = "string", keepOnReset = true, get = function() return TBReloadedText end, set = function(v) TBReloadedText = v end },
	},
	Options = {
		-- Auto hide: the text of the option at runtime, saved as a code
		{ key = "H", default = function() return L["OPAHD"] end, reset = function() return L["OPAHC"] end, load = AutoHideText, save = AutoHideCode,
			get = function() return TBAutoHide end, set = function(v) TBAutoHide = v end },
		{ key = "I", type = "int", default = Constants.DEFAULT_ICON_SIZE, load = function(saved) return ICON_SIZE_OLD_TEXTS[saved] or tonumber(saved) end,
			get = function() return TBIconSize end, set = function(v) TBIconSize = v end },
	},
	Background = {
		-- The background window applies the color to all controls
		{ key = "A", default = false, keepOnReset = true, get = function() return BGWToAll end, set = function(v) BGWToAll = v end },
	},
}

-- Positions of TitanBar's own windows by settings section, { left = , top = }.
-- The windows keep them up to date when they are moved (see CreateWindow's position).
WindowPositions = {}
local WINDOW_SECTIONS = { "Options", "Profile", "Shell", "Background" }

local function LoadBarSettings(sectionName)
	local section = EnsureSettingsSection(sectionName)
	for _, field in ipairs(BAR_SETTINGS[sectionName]) do
		if section[field.key] == nil then
			if field.save then section[field.key] = field.save(DefaultValue(field)) else section[field.key] = SavedValue(field, nil) end
		end
		local value
		if field.load then value = field.load(section[field.key]) else value = LoadedValue(field, section[field.key]) end
		if value == nil then value = DefaultValue(field) end
		field.set(value)
		-- Older versions saved some settings differently, e.g. as translated text
		if field.save then section[field.key] = field.save(value) end
	end
end

local function SaveBarSettings()
	for sectionName, fields in pairs(BAR_SETTINGS) do
		local section = EnsureSettingsSection(sectionName)
		for _, field in ipairs(fields) do
			local value = field.get()
			if field.save then section[field.key] = field.save(value) else section[field.key] = SavedValue(field, value) end
		end
	end
end

local function ResetBarSettings()
	for _, fields in pairs(BAR_SETTINGS) do
		for _, field in ipairs(fields) do
			if not field.keepOnReset then
				if field.reset then field.set(field.reset()) else field.set(DefaultValue(field)) end
			end
		end
	end
end

-- Size of the controls and the text multipliers, from TitanBar's height and font
local function SetFontMetrics()
	local tStrS = tonumber(string.sub( TBFontT, string.len(TBFontT) - 1, string.len(TBFontT) )); --Get Font Size
	if TBHeight > Constants.DEFAULT_TITANBAR_HEIGHT and tStrS <= Constants.FONT_SIZE_THRESHOLD then
		CTRHeight = Constants.DEFAULT_CONTROL_HEIGHT;
	elseif TBHeight > Constants.DEFAULT_TITANBAR_HEIGHT and tStrS > Constants.FONT_SIZE_THRESHOLD then
		CTRHeight = 2*tStrS;
	else
		CTRHeight = TBHeight;
	end
	local tStr = string.sub( TBFontT, 1, string.len(TBFontT) - 2 ); --Get Font name
	if tStrS == nil then tStrS = 0; end
	NM = _G.FontN[tStr][tStrS]; --Number multiplier
	TM = _G.FontT[tStr][tStrS]; --Text multiplier
end

-- ============================================================================
-- SETTINGS LOADING
-- ============================================================================

-- **v Load / update / set default settings v**
function LoadSettings()
	settings = LoadSettingsFile()
	
	tA, tR, tG, tB, tX, tY = Constants.DEFAULT_ALPHA, Constants.DEFAULT_RED, Constants.DEFAULT_GREEN, Constants.DEFAULT_BLUE, Constants.DEFAULT_X, Constants.DEFAULT_Y;
	tL, tT = Constants.DEFAULT_WINDOW_LEFT, Constants.DEFAULT_WINDOW_TOP;

	---@type table<string, table>
	settings = settings or {}

	LoadBarSettings("TitanBar")
	TBLocale = (TBLocaleChoice == "auto") and GLocale or TBLocaleChoice
	import (AppLocaleD..TBLocale)
	SetFontMetrics()
	LoadBarSettings("Options") -- needs the language: auto hide is kept as the text of the option
	LoadBarSettings("Background")

	for _, sectionName in ipairs(WINDOW_SECTIONS) do
		local section = EnsureSettingsSection(sectionName)
		SetDefaultWindowPosition(section, tL, tT)
		WindowPositions[sectionName] = { left = tonumber(section.L), top = tonumber(section.T) }
	end

	-- Settings of older versions: shown state of the options and profile windows, the old bags window
	settings.Options.V = nil
	settings.Profile.V = nil
	settings.BagInfosList = nil

	-- Controls: fill in defaults for missing settings, and load the controls' own fields.
	-- The standard fields are loaded by ControlRegistry when a control registers.
	for _, control in ipairs(CONTROL_SETTINGS) do
		local section = InitControlDefaults(control.section, nil, { x = DefaultX(control) }, not control.noWindow and {} or nil)
		if section.V == nil then section.V = control.show or false end
		if control.where then section.W = section.W or Constants.FormatInt(control.where) end

		if control.fields then
			_G.ControlData[control.id] = _G.ControlData[control.id] or {}
			local data = _G.ControlData[control.id]
			for _, field in ipairs(control.fields) do
				if section[field.key] == nil then section[field.key] = SavedValue(field, nil) end
				data[field.field] = LoadedValue(field, section[field.key])
			end
		end
	end

	if not _G.ControlData.PI.layout then
		_G.AlignLbl = Turbine.UI.ContentAlignment.MiddleLeft;
		_G.AlignVal = Turbine.UI.ContentAlignment.MiddleRight;
		_G.AlignOff = 0;
		_G.AlignOffP = 5;
	else
		_G.AlignLbl = Turbine.UI.ContentAlignment.MiddleRight;
		_G.AlignVal = Turbine.UI.ContentAlignment.MiddleLeft;
		_G.AlignOff = 5;
		_G.AlignOffP = 0;
	end

	for k,v in pairs(_G.currencies.list) do
		CreateSettingsForCurrency(v)
		LoadSettingsForCurrency(v.name)
	end

	WriteSettings();
	
	--if settings.TitanBar.W ~= screenWidth then ReplaceCtr(); end --Replace control if screen width as changed
end
-- **^

function LoadSettingsForCurrency(name)
	_G.ControlRegistry.Register({
		id = name,
		kind = "currency",
		hasWhere = true,
		tooltipHeader = name .. "h",
		freePeopleOnly = not _G.currencies.byName[name].visibleInMonsterPlay,
		defaults = { show = false, where = Constants.Position.NONE, x = 0, y = 0 },
		toggleFunc = function() ShowHideCurrency(name) end
	})

	local data = _G.ControlData[name]
	local section = settings[name]
	
	data.show = section.V
	data.colors.alpha = tonumber(section.A) or Constants.DEFAULT_ALPHA
	data.colors.red = tonumber(section.R) or Constants.DEFAULT_RED
	data.colors.green = tonumber(section.G) or Constants.DEFAULT_GREEN
	data.colors.blue = tonumber(section.B) or Constants.DEFAULT_BLUE
	data.location.x = tonumber(section.X) or Constants.DEFAULT_X
	data.location.y = tonumber(section.Y) or Constants.DEFAULT_Y
	data.where = tonumber(section.W) or Constants.Position.NONE
	
	if data.where == Constants.Position.NONE and data.show then
		data.where = Constants.Position.TITANBAR
		section.W = Constants.FormatInt(data.where)
	end
end

function CreateSettingsForCurrency(currency)
	local name = currency.name
	settings[name] = settings[name] or settings[currency.legacyTitanbarName] or {}
	local section = settings[name]
	
	section.V = section.V or false
	SetDefaultColors(section, 0.3, 0.3, 0.3, 0.3)
	SetDefaultPosition(section, 0, 0)
	section.W = section.W or Constants.FormatInt(Constants.Position.NONE)
end


-- **v Save settings v**
-- Copies the runtime state into the settings table and writes it to disk.
-- The sections are updated in place, so references to them (e.g. in drag handlers) stay valid.
function SaveSettings()
	SaveBarSettings()
	for _, sectionName in ipairs(WINDOW_SECTIONS) do
		local position = WindowPositions[sectionName]
		SaveWindowPosition(EnsureSettingsSection(sectionName), position.left, position.top)
	end

	-- Controls
	for _, control in ipairs(CONTROL_SETTINGS) do
		local section = EnsureSettingsSection(control.section)
		SaveControlSettings(control.id, section)
		local data = _G.ControlData[control.id] or {}
		for _, field in ipairs(control.fields or {}) do
			section[field.key] = SavedValue(field, data[field.field])
		end
	end

	for k,v in pairs(_G.currencies.list) do
		SetSettings(v.name)
		-- The section under the name of old TitanBar versions was taken over when loading
		if v.legacyTitanbarName then settings[v.legacyTitanbarName] = nil end
	end

	WriteSettings()
end

-- Writes the settings table to disk as it is, without taking over the runtime state
-- (used while loading, and when a profile replaced the settings table)
function WriteSettings()
	Turbine.PluginData.Save( Constants.SETTINGS_SCOPE, Constants.SETTINGS_NAME, SaveableTable(settings) );
end
-- **^

-- Currencies keep their own settings layout (no window position)
function SetSettings(currencyName)
	local data = _G.ControlData[currencyName]
	local section = EnsureSettingsSection(currencyName)
	section.V = data.show
	SaveColors(section, data.colors.alpha, data.colors.red, data.colors.green, data.colors.blue)
	SavePosition(section, data.location.x, data.location.y)
	section.W = Constants.FormatInt(data.where)
end

-- **v Reset All Settings v**
function ResetSettings()
	write( L["TBR"] );
	ResetBarSettings()

	-- Reset all controls (currencies included) to defaults defined in ControlRegistry
	_G.ControlRegistry.ResetToDefaults()

	-- Reset the controls' own fields
	for _, control in ipairs(CONTROL_SETTINGS) do
		local data = _G.ControlData[control.id]
		for _, field in ipairs(control.fields or {}) do
			if not field.keepOnReset then data[field.field] = DefaultValue(field) end
		end
	end

	SaveSettings();
	ReloadTitanBar();
end
-- **^

-- Called when screen size or UI scale has changed to reposition controls
function ReplaceCtr()
	write( L["TBSSCS"] );
	LayoutBar();
	RelayoutIcons();
	local oldBarWidth = settings.TitanBar.W;
	TBWidth = GetBarWidth();
	settings.TitanBar.W = string.format("%.0f", TBWidth);
	
	-- Update all controls, currencies included
	_G.ControlRegistry.ForEach(function(controlId, data)
		local settingsKey = data.settingsKey
		if settings[settingsKey] and settings[settingsKey].X then
			local oldLocX = settings[settingsKey].X / oldBarWidth
			local newLocX = oldLocX * TBWidth
			
			-- Update ControlData
			data.location.x = newLocX
			
			-- Update settings
			settings[settingsKey].X = string.format("%.0f", newLocX)
			
			-- Reposition control if visible and on TitanBar
			if data.show then
				local shouldReposition = true
				-- Special cases for controls with "where" option
				if data.where ~= nil and data.where ~= Constants.Position.TITANBAR then
					shouldReposition = false
				end
				
				if shouldReposition and data.ui and data.ui.control then
					data.ui.control:SetPosition(data.location.x, data.location.y)
				end
			end
		end
	end)

	SaveSettings();
	write( L["TBSSCD"] );
end