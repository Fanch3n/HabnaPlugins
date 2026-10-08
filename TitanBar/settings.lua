-- settings.lua
-- Written by Habna
-- Rewritten by many

-- Defaults for new settings, set in LoadSettings()
local tX, tY, tL, tT

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
--     type: "bool" (the default), "int" (saved as a whole number) or "string"
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
	if field.type == "string" then return value end
	if field.invert then return value ~= true end
	return value == true
end

-- Value of a field as it is kept in ControlData
local function LoadedValue(field, saved)
	if field.type == "int" then return tonumber(saved) or DefaultValue(field) end
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
-- SETTINGS LOADING
-- ============================================================================

-- **v Load / update / set default settings v**
function LoadSettings()
	settings = LoadSettingsFile()
	
	tA, tR, tG, tB, tX, tY = Constants.DEFAULT_ALPHA, Constants.DEFAULT_RED, Constants.DEFAULT_GREEN, Constants.DEFAULT_BLUE, Constants.DEFAULT_X, Constants.DEFAULT_Y;
	tL, tT = Constants.DEFAULT_WINDOW_LEFT, Constants.DEFAULT_WINDOW_TOP;

	---@type table<string, table>
	settings = settings or {}

	local titanBar = EnsureSettingsSection("TitanBar")
	SetDefaultColors(titanBar, tA, tR, tG, tB)
	titanBar.W = titanBar.W or Constants.FormatInt(screenWidth)
	titanBar.L = titanBar.L or "auto" -- TitanBar's language, "auto": the game language
	titanBar.H = titanBar.H or Constants.FormatInt(Constants.DEFAULT_TITANBAR_HEIGHT)
	titanBar.F = titanBar.F or Constants.FormatInt(Constants.DEFAULT_TITANBAR_FONT_ID)
	titanBar.T = titanBar.T or Constants.DEFAULT_TITANBAR_FONT_NAME
	titanBar.D = titanBar.D == nil and true or titanBar.D -- True ->TitanBar set to Top of the screen
	titanBar.Z = titanBar.Z or false -- Titanbar was reloaded
	--if settings.TitanBar.ZT == nil then settings.TitanBar.ZT = "TB"; end -- TitanBar was reloaded (text)
	bcAlpha = tonumber(titanBar.A) or Constants.DEFAULT_ALPHA
	bcRed = tonumber(titanBar.R) or Constants.DEFAULT_RED
	bcGreen = tonumber(titanBar.G) or Constants.DEFAULT_GREEN
	bcBlue = tonumber(titanBar.B) or Constants.DEFAULT_BLUE
	TBWidth = tonumber(titanBar.W) or screenWidth
	TBLocaleChoice = titanBar.L
	TBLocale = (TBLocaleChoice == "auto") and GLocale or TBLocaleChoice
	import (AppLocaleD..TBLocale)
	TBHeight = tonumber(titanBar.H) or Constants.DEFAULT_TITANBAR_HEIGHT
	_G.TBFont = tonumber(titanBar.F) or Constants.DEFAULT_TITANBAR_FONT_ID
	TBFontT = titanBar.T
	local tStrS = tonumber(string.sub( TBFontT, string.len(TBFontT) - 1, string.len(TBFontT) )); --Get Font Size
	--write(tStrS);
	if TBHeight > Constants.DEFAULT_TITANBAR_HEIGHT and tStrS <= Constants.FONT_SIZE_THRESHOLD then 
		CTRHeight = Constants.DEFAULT_CONTROL_HEIGHT;
	elseif TBHeight > Constants.DEFAULT_TITANBAR_HEIGHT and tStrS > Constants.FONT_SIZE_THRESHOLD then
		CTRHeight = 2*tStrS;
	else 
		CTRHeight = TBHeight; 
	end
	--write(CTRHeight);
	local tStr = string.sub( TBFontT, 1, string.len(TBFontT) - 2 ); --Get Font name
	--write(tStr);
	if tStrS == nil then tStrS = 0; end
	NM = _G.FontN[tStr][tStrS]; --Number multiplier
	TM = _G.FontT[tStr][tStrS]; --Text multiplier
	TBTop = titanBar.D
	TBReloaded = titanBar.Z
	TBReloadedText = titanBar.ZT

	local options = EnsureSettingsSection("Options")
	options.V = nil
	SetDefaultWindowPosition(options, tL, tT)
	options.H = options.H or "never"
	options.I = options.I or Constants.FormatInt(Constants.DEFAULT_ICON_SIZE)
	OPWLeft = tonumber(options.L)
	OPWTop = tonumber(options.T)
	
	TBAutoHide = AutoHideText(options.H)
	options.H = AutoHideCode(TBAutoHide) -- old files: the code instead of the translated text
	TBIconSize = ICON_SIZE_OLD_TEXTS[options.I] or tonumber(options.I) or Constants.DEFAULT_ICON_SIZE
	

	local profile = EnsureSettingsSection("Profile")
	profile.V = nil
	SetDefaultWindowPosition(profile, tL, tT)
	PPWLeft = tonumber(profile.L)
	PPWTop = tonumber(profile.T)

	local shell = EnsureSettingsSection("Shell")
	SetDefaultWindowPosition(shell, tL, tT)
	SCWLeft = tonumber(shell.L)
	SCWTop = tonumber(shell.T)

	local background = EnsureSettingsSection("Background")
	SetDefaultWindowPosition(background, tL, tT)
	background.A = background.A or false
	BGWLeft = tonumber(background.L)
	BGWTop = tonumber(background.T)
	BGWToAll = background.A


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

	local bagInfosList = EnsureSettingsSection("BagInfosList")
	SetDefaultWindowPosition(bagInfosList, tL, tT)
	BLWLeft = tonumber(bagInfosList.L)
	BLWTop = tonumber(bagInfosList.T)

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
	-- TitanBar
	local titanBar = EnsureSettingsSection("TitanBar")
	SaveColors(titanBar, bcAlpha, bcRed, bcGreen, bcBlue)
	titanBar.W = Constants.FormatInt(TBWidth)
	titanBar.L = TBLocaleChoice
	titanBar.H = Constants.FormatInt(TBHeight)
	titanBar.F = Constants.FormatInt(_G.TBFont)
	titanBar.T = TBFontT
	titanBar.D = TBTop
	titanBar.Z = TBReloaded
	titanBar.ZT = TBReloadedText
	
	-- Options
	local options = EnsureSettingsSection("Options")
	SaveWindowPosition(options, OPWLeft, OPWTop)
	options.H = AutoHideCode(TBAutoHide)
	options.I = Constants.FormatInt(TBIconSize)

	-- Profile, Shell, Background
	SaveWindowPosition(EnsureSettingsSection("Profile"), PPWLeft, PPWTop)
	SaveWindowPosition(EnsureSettingsSection("Shell"), SCWLeft, SCWTop)
	local background = EnsureSettingsSection("Background")
	SaveWindowPosition(background, BGWLeft, BGWTop)
	background.A = BGWToAll

	-- Controls
	for _, control in ipairs(CONTROL_SETTINGS) do
		local section = EnsureSettingsSection(control.section)
		SaveControlSettings(control.id, section)
		local data = _G.ControlData[control.id] or {}
		for _, field in ipairs(control.fields or {}) do
			section[field.key] = SavedValue(field, data[field.field])
		end
	end

	SaveWindowPosition(EnsureSettingsSection("BagInfosList"), BLWLeft, BLWTop)

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
	TBLocaleChoice = "auto";
	
	tA, tR, tG, tB = 0.3, 0.3, 0.3, 0.3;
	
	TBHeight, _G.TBFont, TBFontT, TBTop, TBAutoHide, TBIconSize, bcAlpha, bcRed, bcGreen, bcBlue = Constants.DEFAULT_TITANBAR_HEIGHT, 1107296268, "TrajanPro14", true, L["OPAHC"], Constants.ICON_SIZE_LARGE, tA, tR, tG, tB;
	
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