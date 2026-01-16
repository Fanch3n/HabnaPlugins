-- settings.lua
-- Written by Habna
-- Rewritten by many

-- ============================================================================
-- HELPER FUNCTIONS FOR LOADING SETTINGS
-- ============================================================================

-- Load settings from file into ControlData structure
local function LoadControlSettings(controlId, settingsSection)
	local data = _G.ControlData[controlId]
	if not data then return end
	
	-- Load visibility
	data.show = settingsSection.V or false
	
	-- Load colors
	data.colors.alpha = tonumber(settingsSection.A) or Constants.DEFAULT_ALPHA
	data.colors.red = tonumber(settingsSection.R) or Constants.DEFAULT_RED
	data.colors.green = tonumber(settingsSection.G) or Constants.DEFAULT_GREEN
	data.colors.blue = tonumber(settingsSection.B) or Constants.DEFAULT_BLUE
	
	-- Load location
	data.location.x = tonumber(settingsSection.X) or Constants.DEFAULT_X
	data.location.y = tonumber(settingsSection.Y) or Constants.DEFAULT_Y
	
	-- Load window position
	data.window.left = tonumber(settingsSection.L) or Constants.DEFAULT_WINDOW_LEFT
	data.window.top = tonumber(settingsSection.T) or Constants.DEFAULT_WINDOW_TOP
	
	-- Load where (if applicable)
	if data.where ~= nil and settingsSection.W then
		data.where = tonumber(settingsSection.W)
	end
end

-- Save ControlData to settings structure  
local function SaveControlSettings(controlId, settingsSection)
	local data = _G.ControlData[controlId]
	if not data then return end
	
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

-- Load color values from a settings section into global variables
local function LoadColors(section, alphaVar, redVar, greenVar, blueVar)
	_G[alphaVar] = tonumber(section.A)
	_G[redVar] = tonumber(section.R)
	_G[greenVar] = tonumber(section.G)
	_G[blueVar] = tonumber(section.B)
end

-- Load position values from a settings section into global variables
local function LoadPosition(section, xVar, yVar)
	_G[xVar] = tonumber(section.X)
	_G[yVar] = tonumber(section.Y)
end

-- Load window position values from a settings section into global variables
local function LoadWindowPosition(section, leftVar, topVar)
	_G[leftVar] = tonumber(section.L)
	_G[topVar] = tonumber(section.T)
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

-- Save standard control settings (visibility, colors, position, window position) - OLD VERSION
local function SaveControlSettingsOld(sectionName, visible, alpha, red, green, blue, x, y, left, top)
	settings[sectionName] = {}
	settings[sectionName].V = visible
	SaveColors(settings[sectionName], alpha, red, green, blue)
	SavePosition(settings[sectionName], x, y)
	if left and top then
		SaveWindowPosition(settings[sectionName], left, top)
	end
end

-- Create a new settings section and save window position
local function SaveSectionWithWindowPos(sectionName, left, top)
	settings[sectionName] = {}
	SaveWindowPosition(settings[sectionName], left, top)
	return settings[sectionName]
end

-- ============================================================================
-- SETTINGS LOADING
-- ============================================================================

-- **v Load / update / set default settings v**
-- I'm confused as to what most of this is... Most of these strings should be in localization files, and I believe they are - so why are they here too?  Deprecated code that hasn't been cleaned up yet?
-- It's probably to solve the radix point problem. This can be solved with a combination of vindar_patch and string replacement in the future.
function LoadSettings()
	if GLocale == "de" then
		settings = Turbine.PluginData.Load( Constants.SETTINGS_SCOPE, Constants.SETTINGS_NAME_DE );
	elseif GLocale == "en" then
		settings = Turbine.PluginData.Load( Constants.SETTINGS_SCOPE, Constants.SETTINGS_NAME_EN );
	elseif GLocale == "fr" then
		settings = Turbine.PluginData.Load( Constants.SETTINGS_SCOPE, Constants.SETTINGS_NAME_FR );
	end
	
	tA, tR, tG, tB, tX, tY, tW = Constants.DEFAULT_ALPHA, Constants.DEFAULT_RED, Constants.DEFAULT_GREEN, Constants.DEFAULT_BLUE, Constants.DEFAULT_X, Constants.DEFAULT_Y, Constants.Position.NONE;
	tL, tT = Constants.DEFAULT_WINDOW_LEFT, Constants.DEFAULT_WINDOW_TOP;

	settings = settings or {}

	local titanBar = EnsureSettingsSection("TitanBar")
	SetDefaultColors(titanBar, tA, tR, tG, tB)
	titanBar.W = titanBar.W or Constants.FormatInt(screenWidth)
	titanBar.L = titanBar.L or GLocale
	titanBar.H = titanBar.H or Constants.FormatInt(Constants.DEFAULT_TITANBAR_HEIGHT)
	titanBar.F = titanBar.F or Constants.FormatInt(Constants.DEFAULT_TITANBAR_FONT_ID)
	titanBar.T = titanBar.T or Constants.DEFAULT_TITANBAR_FONT_NAME
	titanBar.D = titanBar.D == nil and true or titanBar.D -- True ->TitanBar set to Top of the screen
	titanBar.Z = titanBar.Z or false -- Titanbar was reloaded
	--if settings.TitanBar.ZT == nil then settings.TitanBar.ZT = "TB"; end -- TitanBar was reloaded (text)
	_G.ControlData.uiState = _G.ControlData.uiState or {}
	local ui = _G.ControlData.uiState
	ui.bcAlpha = tonumber(titanBar.A)
	ui.bcRed = tonumber(titanBar.R)
	ui.bcGreen = tonumber(titanBar.G)
	ui.bcBlue = tonumber(titanBar.B)
	ui.TBWidth = tonumber(titanBar.W)
	ui.TBLocale = titanBar.L
	import (AppLocaleD..ui.TBLocale)
	ui.TBHeight = tonumber(titanBar.H)
	_G.TBFont = tonumber(titanBar.F) -- Keep _G.TBFont for compatibility or update it later
	ui.TBFontT = titanBar.T
	local tStrS = tonumber(string.sub( ui.TBFontT, string.len(ui.TBFontT) - 1, string.len(ui.TBFontT) )); --Get Font Size
	--write(tStrS);
	if ui.TBHeight > Constants.DEFAULT_TITANBAR_HEIGHT and tStrS <= Constants.FONT_SIZE_THRESHOLD then 
		ui.CTRHeight = Constants.DEFAULT_CONTROL_HEIGHT;
	elseif ui.TBHeight > Constants.DEFAULT_TITANBAR_HEIGHT and tStrS > Constants.FONT_SIZE_THRESHOLD then
		ui.CTRHeight = 2*tStrS;
	else 
		ui.CTRHeight = ui.TBHeight; 
	end
	--write(ui.CTRHeight);
	local tStr = string.sub( ui.TBFontT, 1, string.len(ui.TBFontT) - 2 ); --Get Font name
	--write(tStr);
	if tStrS == nil then tStrS = 0; end
	ui.NM = _G.FontN[tStr][tStrS]; --Number multiplier
	ui.TM = _G.FontT[tStr][tStrS]; --Text multiplier
	ui.TBTop = titanBar.D
	ui.TBReloaded = titanBar.Z
	ui.TBReloadedText = titanBar.ZT

	local options = EnsureSettingsSection("Options")
	options.V = nil
	SetDefaultWindowPosition(options, tL, tT)
	options.H = options.H or L["OPAHD"]
	options.I = options.I or Constants.FormatInt(Constants.DEFAULT_ICON_SIZE)
	ui.OPWLeft = tonumber(options.L)
	ui.OPWTop = tonumber(options.T)
	
	ui.TBAutoHide = options.H
	-- If user change language, Auto hide option not showing in proper language. Fix: Re-input correct word in variable.
	if ui.TBAutoHide == "Disabled" or ui.TBAutoHide == "D\195\169sactiver" or ui.TBAutoHide == "niemals" then ui.TBAutoHide = L["OPAHD"]; end
	if ui.TBAutoHide == "Always" or ui.TBAutoHide == "Toujours" or ui.TBAutoHide == "immer" then ui.TBAutoHide = L["OPAHE"]; end
	if ui.TBAutoHide == "Only in combat" or ui.TBAutoHide == "Seulement en combat" or ui.TBAutoHide == "Nur in der Schlacht" then ui.TBAutoHide = L["OPAHC"]; end

	ui.TBIconSize = options.I
	-- If user change language, icon disappear. Fix: Re-input correct word in variable.
	if ui.TBIconSize == "Small (16x16)" or ui.TBIconSize == "Petit (16x16)" or ui.TBIconSize == "klein (16x16)" then ui.TBIconSize = L["OPISS"];
	elseif ui.TBIconSize == "Large (32x32)" or ui.TBIconSize == "Grand (32x32)" or ui.TBIconSize == "Breit (32x32)" then ui.TBIconSize = L["OPISL"]; end
	

	local profile = EnsureSettingsSection("Profile")
	profile.V = nil
	SetDefaultWindowPosition(profile, tL, tT)
	ui.PPWLeft = tonumber(profile.L)
	ui.PPWTop = tonumber(profile.T)

	local shell = EnsureSettingsSection("Shell")
	SetDefaultWindowPosition(shell, tL, tT)
	ui.SCWLeft = tonumber(shell.L)
	ui.SCWTop = tonumber(shell.T)

	local background = EnsureSettingsSection("Background")
	SetDefaultWindowPosition(background, tL, tT)
	background.A = background.A or false
	ui.BGWLeft = tonumber(background.L)
	ui.BGWTop = tonumber(background.T)
	_G.BGWToAll = background.A


	-- Load settings for all registered controls
	_G.ControlRegistry.ForEach(function(id, data)
		local config = _G.ControlRegistry.GetMetadata(id)
		local section = InitControlDefaults(config.settingsKey, data.colors, data.location, data.window)
		LoadControlSettings(id, section)
	end)

	-- Custom legacy loading for controls with extra settings
	-- Note: These should eventually be moved into the individual control's self-registration
	
	-- Money extra settings
	local money = settings["Money"] or {}
	_G.ControlData.Money = _G.ControlData.Money or {}
	_G.ControlData.Money.stm = (money.S == true)
	_G.ControlData.Money.sss = money.SS ~= false
	_G.ControlData.Money.sts = money.TS ~= false

	-- BagInfos extra settings
	local bagInfos = settings["BagInfos"] or {}
	_G.ControlData.BI.used = bagInfos.U ~= false
	_G.ControlData.BI.max = bagInfos.M ~= false

	-- DurabilityInfos extra settings
	local durabilityInfos = settings["DurabilityInfos"] or {}
	_G.ControlData.DI.icon = durabilityInfos.I ~= false
	_G.ControlData.DI.text = durabilityInfos.N ~= false

	-- PlayerLoc extra settings
	local playerLoc = settings["PlayerLoc"] or {}
	_G.ControlData.PL.text = playerLoc.L or L["PLMsg"]

	-- Infamy extra settings
	local infamy = settings["Infamy"] or {}
	_G.ControlData.IF.set = infamy.F ~= false
	_G.ControlData.IF.points = tonumber(infamy.P) or 0
	_G.ControlData.IF.rank = tonumber(infamy.K) or 0

	-- DayNight extra settings
	local dayNight = settings["DayNight"] or {}
	_G.ControlData.DN.next = dayNight.N ~= false
	_G.ControlData.DN.ts = tonumber(dayNight.S) or 0

	-- Reputation extra settings
	local reputation = settings["Reputation"] or {}
	_G.ControlData.RP.showMax = (reputation.H ~= true)

	-- GameTime extra settings
	local gameTime = settings["GameTime"] or {}
	_G.ControlData.GT.clock24h = (gameTime.H == true)
	_G.ControlData.GT.showST = (gameTime.S == true)
	_G.ControlData.GT.showBT = (gameTime.O == true)
	_G.ControlData.GT.userGMT = tonumber(gameTime.M) or 0

	-- PlayerInfos extra settings
	local playerInfos = settings["PlayerInfos"] or {}
	_G.ControlData.PI.xp = playerInfos.XP or Constants.FormatInt(0)
	_G.ControlData.PI.layout = playerInfos.Layout or false
	-- Apply UI layout state based on PI settings
	if not _G.ControlData.PI.layout then
		ui.AlignLbl, ui.AlignVal, ui.AlignOff, ui.AlignOffP = Turbine.UI.ContentAlignment.MiddleLeft, Turbine.UI.ContentAlignment.MiddleRight, 0, 5
	else
		ui.AlignLbl, ui.AlignVal, ui.AlignOff, ui.AlignOffP = Turbine.UI.ContentAlignment.MiddleRight, Turbine.UI.ContentAlignment.MiddleLeft, 5, 0
	end

	for k,v in pairs(_G.currencies.list) do
		CreateSettingsForCurrency(v)
		LoadSettingsForCurrency(v.name)
	end

	SaveSettings( false );
	
	--if settings.TitanBar.W ~= screenWidth then ReplaceCtr(); end --Replace control if screen width as changed
end
-- **^

function LoadSettingsForCurrency(name)
	if _G.CurrencyData == nil then
		_G.CurrencyData = {}
	end
	if _G.CurrencyData[name] == nil then
		_G.CurrencyData[name] = {}
	end
	
	local data = _G.CurrencyData[name]
	local section = settings[name]
	
	data.IsVisible = section.V
	data.bcAlpha = tonumber(section.A)
	data.bcRed = tonumber(section.R)
	data.bcGreen = tonumber(section.G)
	data.bcBlue = tonumber(section.B)
	data.LocX = tonumber(section.X)
	data.LocY = tonumber(section.Y)
	data.Where = tonumber(section.W)
	
	if data.Where == Constants.Position.NONE and data.IsVisible then
		data.Where = Constants.Position.TITANBAR
		section.W = Constants.FormatInt(data.Where)
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
function SaveSettings(str)
	if str then --True: get all variable and save settings
		settings = {}
		local ui = _G.ControlData.uiState
		
		-- TitanBar
		settings.TitanBar = {}
		SaveColors(settings.TitanBar, ui.bcAlpha, ui.bcRed, ui.bcGreen, ui.bcBlue)
		settings.TitanBar.W = Constants.FormatInt(screenWidth)
		settings.TitanBar.L = ui.TBLocale
		settings.TitanBar.H = Constants.FormatInt(ui.TBHeight)
		settings.TitanBar.F = Constants.FormatInt(_G.TBFont)
		settings.TitanBar.T = ui.TBFontT
		settings.TitanBar.D = ui.TBTop
		settings.TitanBar.Z = ui.TBReloaded
		settings.TitanBar.ZT = ui.TBReloadedText
		
		-- Options
		settings.Options = {}
		SaveWindowPosition(settings.Options, ui.OPWLeft, ui.OPWTop)
		settings.Options.H = ui.TBAutoHide
		settings.Options.I = Constants.FormatInt(ui.TBIconSize)

		-- Profile, Shell, Background
		SaveWindowPosition(EnsureSettingsSection("Profile"), ui.PPWLeft, ui.PPWTop)
		SaveWindowPosition(EnsureSettingsSection("Shell"), ui.SCWLeft, ui.SCWTop)
		settings.Background = {}
		SaveWindowPosition(settings.Background, ui.BGWLeft, ui.BGWTop)
		settings.Background.A = BGWToAll

		-- Wallet
		if not settings.Wallet then settings.Wallet = {} end
		SaveControlSettings("WI", settings.Wallet)

		-- Money
		if not settings.Money then settings.Money = {} end
		SaveControlSettings("Money", settings.Money)
		settings.Money.S = _G.ControlData.Money.stm
		settings.Money.SS = _G.ControlData.Money.sss
		settings.Money.TS = _G.ControlData.Money.sts

		-- LOTROPoints
		if not settings.LOTROPoints then settings.LOTROPoints = {} end
		SaveControlSettings("LP", settings.LOTROPoints)
		
		-- BagInfos
		if not settings.BagInfos then settings.BagInfos = {} end
		SaveControlSettings("BI", settings.BagInfos)
		settings.BagInfos.U = _G.ControlData.BI.used
		settings.BagInfos.M = _G.ControlData.BI.max

		SaveSectionWithWindowPos("BagInfosList", BLWLeft, BLWTop)

		-- PlayerInfos
		if not settings.PlayerInfos then settings.PlayerInfos = {} end
		SaveControlSettings("PI", settings.PlayerInfos)
		settings.PlayerInfos.XP = (_G.ControlData.PI and _G.ControlData.PI.xp) or Constants.FormatInt(0)
		settings.PlayerInfos.Layout = (_G.ControlData.PI and _G.ControlData.PI.layout) or false

		-- EquipInfos
		if not settings.EquipInfos then settings.EquipInfos = {} end
		SaveControlSettings("EI", settings.EquipInfos)
		
		-- DurabilityInfos
		if not settings.DurabilityInfos then settings.DurabilityInfos = {} end
		SaveControlSettings("DI", settings.DurabilityInfos)
		settings.DurabilityInfos.I = _G.ControlData.DI.icon
		settings.DurabilityInfos.N = _G.ControlData.DI.text
	
		-- PlayerLoc
		if not settings.PlayerLoc then settings.PlayerLoc = {} end
		SaveControlSettings("PL", settings.PlayerLoc)
		settings.PlayerLoc.L = string.format(((_G.ControlData.PL and _G.ControlData.PL.text) or L["PLMsg"]))

		-- TrackItems
		if not settings.TrackItems then settings.TrackItems = {} end
		SaveControlSettings("TI", settings.TrackItems)

		-- Infamy
		if not settings.Infamy then settings.Infamy = {} end
		SaveControlSettings("IF", settings.Infamy)
		settings.Infamy.F = (_G.ControlData.IF and _G.ControlData.IF.set) ~= false
		settings.Infamy.P = Constants.FormatInt((_G.ControlData.IF and _G.ControlData.IF.points) or 0)
		settings.Infamy.K = Constants.FormatInt((_G.ControlData.IF and _G.ControlData.IF.rank) or 0)

		-- Vault
		if not settings.Vault then settings.Vault = {} end
		SaveControlSettings("VT", settings.Vault)
		
		-- SharedStorage
		if not settings.SharedStorage then settings.SharedStorage = {} end
		SaveControlSettings("SS", settings.SharedStorage)
		
		-- DayNight
		if not settings.DayNight then settings.DayNight = {} end
		SaveControlSettings("DN", settings.DayNight)
		settings.DayNight.N = ((_G.ControlData.DN and _G.ControlData.DN.next) ~= false)
		settings.DayNight.S = Constants.FormatInt(((_G.ControlData.DN and _G.ControlData.DN.ts) or 0))
		
		-- Reputation
		if not settings.Reputation then settings.Reputation = {} end
		SaveControlSettings("RP", settings.Reputation)
		-- Persist legacy key as hideMax for backward compatibility.
		settings.Reputation.H = ((_G.ControlData.RP and _G.ControlData.RP.showMax) ~= true)

		-- GameTime
		if not settings.GameTime then settings.GameTime = {} end
		SaveControlSettings("GT", settings.GameTime)
		settings.GameTime.H = (_G.ControlData.GT and _G.ControlData.GT.clock24h) == true
		settings.GameTime.S = (_G.ControlData.GT and _G.ControlData.GT.showST) == true
		settings.GameTime.O = (_G.ControlData.GT and _G.ControlData.GT.showBT) == true
		settings.GameTime.M = Constants.FormatInt(((_G.ControlData.GT and tonumber(_G.ControlData.GT.userGMT)) or 0))
				
		for k,v in pairs(_G.currencies.list) do
			SetSettings(v.name)
		end
		
		local ui = _G.ControlData.uiState
		SaveSectionWithWindowPos("BagInfosList", ui.BLWLeft, ui.BLWTop)
	end
	
	if GLocale == "de" then Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarSettingsDE", settings ); end
	if GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarSettingsEN", settings ); end
	if GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarSettingsFR", settings ); end
end
-- **^

function SetSettings(currencyName)
	local data = _G.CurrencyData[currencyName]
	settings[currencyName] = {}
	settings[currencyName].V = data.IsVisible
	SaveColors(settings[currencyName], data.bcAlpha, data.bcRed, data.bcGreen, data.bcBlue)
	SavePosition(settings[currencyName], data.LocX, data.LocY)
	settings[currencyName].W = Constants.FormatInt(data.Where)
end

-- **v Reset All Settings v**
function ResetSettings()
	write( L["TBR"] );
	_G.ControlData.uiState = _G.ControlData.uiState or {}
	local ui = _G.ControlData.uiState
	ui.TBLocale = "en";
	
	if GLocale == "en" then tA, tR, tG, tB, tX, tY, tW = 0.3, 0.3, 0.3, 0.3, 0, 0, 3;
	else tA, tR, tG, tB, tX, tY, tW = "0,3", "0,3", "0,3", "0,3", "0", "0", "3"; end
	tL, tT = 100, 100;
	
	ui.TBHeight = Constants.DEFAULT_TITANBAR_HEIGHT
	_G.TBFont = 1107296268
	ui.TBFontT = "TrajanPro14"
	TBTop = true
	ui.TBAutoHide = L["OPAHC"]
	ui.TBIconSize = Constants.ICON_SIZE_LARGE
	ui.bcAlpha = tA
	ui.bcRed = tR
	ui.bcGreen = tG
	ui.bcBlue = tB
	
	-- Reset all controls to defaults defined in ControlRegistry
	_G.ControlRegistry.ResetToDefaults()
	
	-- Reset control-specific settings that aren't in ControlData structure
	_G.ControlData.Money.stm, _G.ControlData.Money.sss, _G.ControlData.Money.sts = false, true, true
	_G.ControlData.BI.used, _G.ControlData.BI.max = true, true
	_G.ControlData.DI.icon, _G.ControlData.DI.text = true, true
	_G.ControlData.RP = _G.ControlData.RP or {}
	_G.ControlData.RP.showMax = false
	_G.ControlData.GT = _G.ControlData.GT or {}
	_G.ControlData.GT.clock24h = false
	_G.ControlData.GT.showST = false
	_G.ControlData.GT.showBT = false
	_G.ControlData.GT.userGMT = 0
	_G.ControlData.DN = _G.ControlData.DN or {}
	_G.ControlData.DN.next = true
	
	-- Reset currency controls
	for k,v in pairs(_G.currencies.list) do
		_G.CurrencyData[v.name].IsVisible = false
		_G.CurrencyData[v.name].bcAlpha = tA
		_G.CurrencyData[v.name].bcRed = tR
		_G.CurrencyData[v.name].bcGreen = tG
		_G.CurrencyData[v.name].bcBlue = tB
		_G.CurrencyData[v.name].LocX = tX
		_G.CurrencyData[v.name].LocY = tY
		_G.CurrencyData[v.name].Where = tW
	end
		
	SaveSettings( true ); --True: Get & save all settings table to file. / False: only save settings table to file.
	ReloadTitanBar();
end
-- **^

-- Called when screen size has changed to reposition controls
function ReplaceCtr()
	local ui = _G.ControlData.uiState
	write( L["TBSSCS"] );
	TB["win"]:SetSize( screenWidth, ui.TBHeight );
	local oldScreenWidth = settings.TitanBar.W;
	ui.TBWidth = screenWidth;
	settings.TitanBar.W = string.format("%.0f", screenWidth);
	
	-- Update all standard controls
	_G.ControlRegistry.ForEach(function(controlId, data)
		local settingsKey = data.settingsKey
		if settings[settingsKey] and settings[settingsKey].X then
			local oldLocX = settings[settingsKey].X / oldScreenWidth
			local newLocX = oldLocX * screenWidth
			
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
				
				if shouldReposition and data.ui.control then
					data.ui.control:SetPosition(data.location.x, data.location.y)
				end
			end
		end
	end)
	
	-- Update currency controls
	for k,v in pairs(_G.currencies.list) do
		if settings[v.name] and settings[v.name].X then
			local oldLocX = settings[v.name].X / oldScreenWidth
			_G.CurrencyData[v.name].LocX = oldLocX * screenWidth
			settings[v.name].X = string.format("%.0f", _G.CurrencyData[v.name].LocX)
			if _G.CurrencyData[v.name].IsVisible and _G.CurrencyData[v.name].Where == Constants.Position.TITANBAR then
				_G.CurrencyData[v.name].Ctr:SetPosition(_G.CurrencyData[v.name].LocX, _G.CurrencyData[v.name].LocY)
			end
		end
	end

	SaveSettings( false );
	write( L["TBSSCD"] );
end