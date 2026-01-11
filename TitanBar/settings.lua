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
	bcAlpha = tonumber(titanBar.A)
	bcRed = tonumber(titanBar.R)
	bcGreen = tonumber(titanBar.G)
	bcBlue = tonumber(titanBar.B)
	TBWidth = tonumber(titanBar.W)
	TBLocale = titanBar.L
	import (AppLocaleD..TBLocale)
	TBHeight = tonumber(titanBar.H)
	_G.TBFont = tonumber(titanBar.F)
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
	tStr = string.sub( TBFontT, 1, string.len(TBFontT) - 2 ); --Get Font name
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
	options.H = options.H or L["OPAHD"]
	options.I = options.I or Constants.FormatInt(Constants.DEFAULT_ICON_SIZE)
	OPWLeft = tonumber(options.L)
	OPWTop = tonumber(options.T)
	
	TBAutoHide = options.H
	-- If user change language, Auto hide option not showing in proper language. Fix: Re-input correct word in variable.
	if TBAutoHide == "Disabled" or TBAutoHide == "D\195\169sactiver" or TBAutoHide == "niemals" then TBAutoHide = L["OPAHD"]; end
	if TBAutoHide == "Always" or TBAutoHide == "Toujours" or TBAutoHide == "immer" then TBAutoHide = L["OPAHE"]; end
	if TBAutoHide == "Only in combat" or TBAutoHide == "Seulement en combat" or TBAutoHide == "Nur in der Schlacht" then TBAutoHide = L["OPAHC"]; end

	TBIconSize = options.I
	-- If user change language, icon disappear. Fix: Re-input correct word in variable.
	if TBIconSize == "Small (16x16)" or TBIconSize == "Petit (16x16)" or TBIconSize == "klein (16x16)" then TBIconSize = L["OPISS"];
	elseif TBIconSize == "Large (32x32)" or TBIconSize == "Grand (32x32)" or TBIconSize == "Breit (32x32)" then TBIconSize = L["OPISL"]; end
	

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


	-- Wallet control
	local wallet = InitControlDefaults("Wallet", {}, {}, {})
	wallet.V = wallet.V or false
	LoadControlSettings("WI", wallet)


	-- Money control
	local money = InitControlDefaults("Money", {}, {x=Constants.DEFAULT_MONEY_X}, {})
	money.V = money.V == nil and true or money.V
	money.S = money.S or false --Show Total Money of all characters on TitanBar Money control
	money.SS = money.SS == nil and true or money.SS --Show stats for session
	money.TS = money.TS == nil and true or money.TS --Show stats for today
	money.W = money.W or Constants.FormatInt(Constants.Position.TITANBAR)
	LoadControlSettings("Money", money)
	_G.ControlData.Money = _G.ControlData.Money or {}
	_G.ControlData.Money.stm = money.S
	_G.ControlData.Money.sss = money.SS
	_G.ControlData.Money.sts = money.TS

	-- LOTROPoints control
	local lotroPoints = InitControlDefaults("LOTROPoints", {}, {}, {})
	lotroPoints.V = lotroPoints.V or false
	lotroPoints.W = lotroPoints.W or Constants.FormatInt(tW)
	LoadControlSettings("LP", lotroPoints)
	_G.ControlData.LP = _G.ControlData.LP or {}


	-- BagInfos control
	local bagInfos = InitControlDefaults("BagInfos", {}, {}, {})
	bagInfos.V = bagInfos.V == nil and true or bagInfos.V
	bagInfos.U = bagInfos.U == nil and true or bagInfos.U
	bagInfos.M = bagInfos.M == nil and true or bagInfos.M
	LoadControlSettings("BI", bagInfos)
	_G.ControlData.BI = _G.ControlData.BI or {}
	_G.ControlData.BI.used = bagInfos.U
	_G.ControlData.BI.max = bagInfos.M


	local bagInfosList = EnsureSettingsSection("BagInfosList")
	SetDefaultWindowPosition(bagInfosList, tL, tT)
	BLWLeft = tonumber(bagInfosList.L)
	BLWTop = tonumber(bagInfosList.T)


	-- PlayerInfos control
	local playerInfos = InitControlDefaults("PlayerInfos", {}, {x=Constants.DEFAULT_PLAYER_INFO_X})
	playerInfos.V = playerInfos.V or false
	playerInfos.XP = playerInfos.XP or Constants.FormatInt(0)
	playerInfos.Layout = playerInfos.Layout or false
	LoadControlSettings("PI", playerInfos)
	ExpPTS = playerInfos.XP
	PILayout = playerInfos.Layout
	if not PILayout then
		_G.AlignLbl = Turbine.UI.ContentAlignment.MiddleLeft;
		_G.AlignVal = Turbine.UI.ContentAlignment.MiddleRight;
		_G.AlignOff = 0;
		_G.AlignOffP = 5;
	--  _G.AlignHead = Turbine.UI.ContentAlignment.MiddleLeft;
	elseif PILayout then
		_G.AlignLbl = Turbine.UI.ContentAlignment.MiddleRight;
		_G.AlignVal = Turbine.UI.ContentAlignment.MiddleLeft;
		_G.AlignOff = 5;
		_G.AlignOffP = 0;
	--	_G.AlignHead = Turbine.UI.ContentAlignment.MiddleCenter;
	end

	-- EquipInfos control
	local equipInfos = InitControlDefaults("EquipInfos", {}, {x=Constants.DEFAULT_EQUIP_INFO_X})
	equipInfos.V = equipInfos.V == nil and true or equipInfos.V
	LoadControlSettings("EI", equipInfos)


	-- DurabilityInfos control
	local durabilityInfos = InitControlDefaults("DurabilityInfos", {}, {x=Constants.DEFAULT_DURABILITY_INFO_X}, {})
	durabilityInfos.V = durabilityInfos.V == nil and true or durabilityInfos.V
	durabilityInfos.I = durabilityInfos.I == nil and true or durabilityInfos.I
	durabilityInfos.N = durabilityInfos.N == nil and true or durabilityInfos.N
	LoadControlSettings("DI", durabilityInfos)
	_G.ControlData.DI = _G.ControlData.DI or {}
	_G.ControlData.DI.icon = durabilityInfos.I
	_G.ControlData.DI.text = durabilityInfos.N


	-- PlayerLoc control
	local playerLoc = InitControlDefaults("PlayerLoc", {}, {x=screenWidth - Constants.DEFAULT_PLAYER_LOC_WIDTH})
	playerLoc.V = playerLoc.V == nil and true or playerLoc.V
	playerLoc.L = playerLoc.L or L["PLMsg"]
	LoadControlSettings("PL", playerLoc)
	pLLoc = playerLoc.L


	-- TrackItems control
	local trackItems = InitControlDefaults("TrackItems", {}, {}, {})
	trackItems.V = trackItems.V or false
	LoadControlSettings("TI", trackItems)


	-- Infamy control
	local infamy = InitControlDefaults("Infamy", {}, {}, {})
	infamy.V = infamy.V or false
	infamy.F = infamy.F == nil and true or infamy.F
	infamy.P = infamy.P or Constants.FormatInt(0)
	infamy.K = infamy.K or Constants.FormatInt(0)
	LoadControlSettings("IF", infamy)
	SetInfamy = infamy.F
	InfamyPTS = infamy.P
	InfamyRank = infamy.K


	-- Vault control
	local vault = InitControlDefaults("Vault", {}, {}, {})
	vault.V = vault.V or false
	LoadControlSettings("VT", vault)


	-- SharedStorage control
	local sharedStorage = InitControlDefaults("SharedStorage", {}, {}, {})
	sharedStorage.V = sharedStorage.V or false
	LoadControlSettings("SS", sharedStorage)

	-- DayNight control
	local dayNight = InitControlDefaults("DayNight", {}, {}, {})
	dayNight.V = dayNight.V or false
	dayNight.N = dayNight.N == nil and true or dayNight.N
	dayNight.S = dayNight.S or Constants.FormatInt(10350)
	LoadControlSettings("DN", dayNight)
	_G.DNNextT = dayNight.N
	_G.TS = tonumber(dayNight.S)


	-- Reputation control
	local reputation = InitControlDefaults("Reputation", {}, {}, {})
	reputation.V = reputation.V or false
	reputation.H = reputation.H or false
	LoadControlSettings("RP", reputation)
	HideMaxReps = reputation.H


	-- GameTime control
	local gameTime = InitControlDefaults("GameTime", {}, {x=screenWidth - Constants.GAME_TIME_DEFAULT_OFFSET}, {})
	gameTime.V = gameTime.V == nil and true or gameTime.V
	gameTime.H = gameTime.H or false -- default to 12h format
	gameTime.S = gameTime.S or false -- True = Show server time
	gameTime.O = gameTime.O or false -- True = Show both server and real time
	gameTime.M = gameTime.M or Constants.FormatInt(0)
	LoadControlSettings("GT", gameTime)
	_G.Clock24h = gameTime.H
	_G.ShowST = gameTime.S
	_G.ShowBT = gameTime.O
	_G.UserGMT = gameTime.M
	
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
		
		-- TitanBar
		settings.TitanBar = {}
		SaveColors(settings.TitanBar, bcAlpha, bcRed, bcGreen, bcBlue)
		settings.TitanBar.W = Constants.FormatInt(screenWidth)
		settings.TitanBar.L = TBLocale
		settings.TitanBar.H = Constants.FormatInt(TBHeight)
		settings.TitanBar.F = Constants.FormatInt(_G.TBFont)
		settings.TitanBar.T = TBFontT
		settings.TitanBar.D = TBTop
		settings.TitanBar.Z = TBReloaded
		settings.TitanBar.ZT = TBReloadedText
		
		-- Options
		settings.Options = {}
		SaveWindowPosition(settings.Options, OPWLeft, OPWTop)
		settings.Options.H = TBAutoHide
		settings.Options.I = Constants.FormatInt(TBIconSize)

		-- Profile, Shell, Background
		SaveSectionWithWindowPos("Profile", PPWLeft, PPWTop)
		SaveSectionWithWindowPos("Shell", SCWLeft, SCWTop)
		settings.Background = {}
		SaveWindowPosition(settings.Background, BGWLeft, BGWTop)
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
		settings.PlayerInfos.XP = ExpPTS
		settings.PlayerInfos.Layout = PILayout

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
		settings.PlayerLoc.L = string.format(pLLoc)

		-- TrackItems
		if not settings.TrackItems then settings.TrackItems = {} end
		SaveControlSettings("TI", settings.TrackItems)

		-- Infamy
		if not settings.Infamy then settings.Infamy = {} end
		SaveControlSettings("IF", settings.Infamy)
		settings.Infamy.P = Constants.FormatInt(InfamyPTS)
		settings.Infamy.K = Constants.FormatInt(InfamyRank)

		-- Vault
		if not settings.Vault then settings.Vault = {} end
		SaveControlSettings("VT", settings.Vault)
		
		-- SharedStorage
		if not settings.SharedStorage then settings.SharedStorage = {} end
		SaveControlSettings("SS", settings.SharedStorage)
		
		-- DayNight
		if not settings.DayNight then settings.DayNight = {} end
		SaveControlSettings("DN", settings.DayNight)
		settings.DayNight.N = _G.DNNextT
		settings.DayNight.S = Constants.FormatInt(_G.TS)
		
		-- Reputation
		if not settings.Reputation then settings.Reputation = {} end
		SaveControlSettings("RP", settings.Reputation)
		settings.Reputation.H = HideMaxReps

		-- GameTime
		if not settings.GameTime then settings.GameTime = {} end
		SaveControlSettings("GT", settings.GameTime)
		settings.GameTime.H = _G.Clock24h
		settings.GameTime.S = _G.ShowST
		settings.GameTime.O = _G.ShowBT
		settings.GameTime.M = Constants.FormatInt(_G.UserGMT)
				
		for k,v in pairs(_G.currencies.list) do
			SetSettings(v.name)
		end

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
	TBLocale = "en";
	
	if GLocale == "en" then tA, tR, tG, tB, tX, tY, tW = 0.3, 0.3, 0.3, 0.3, 0, 0, 3;
	else tA, tR, tG, tB, tX, tY, tW = "0,3", "0,3", "0,3", "0,3", "0", "0", "3"; end
	tL, tT = 100, 100;
	
	TBHeight, _G.TBFont, TBFontT, TBTop, TBAutoHide, TBIconSize, bcAlpha, bcRed, bcGreen, bcBlue = Constants.DEFAULT_TITANBAR_HEIGHT, 1107296268, "TrajanPro14", true, L["OPAHC"], Constants.ICON_SIZE_LARGE, tA, tR, tG, tB;
	
	-- Reset all controls to defaults defined in ControlRegistry
	_G.ControlRegistry.ResetToDefaults()
	
	-- Reset control-specific settings that aren't in ControlData structure
	_G.ControlData.Money.stm, _G.ControlData.Money.sss, _G.ControlData.Money.sts = false, true, true
	_G.ControlData.BI.used, _G.ControlData.BI.max = true, true
	_G.ControlData.DI.icon, _G.ControlData.DI.text = true, true
	_G.DNNextT = true
	
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
	write( L["TBSSCS"] );
	TB["win"]:SetSize( screenWidth, TBHeight );
	local oldScreenWidth = settings.TitanBar.W;
	TBWidth = screenWidth;
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