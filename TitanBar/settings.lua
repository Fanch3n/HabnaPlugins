-- settings.lua
-- Written by Habna
-- Rewritten by many

-- Defaults for new settings, set in LoadSettings() and ResetSettings()
local tX, tY, tW, tL, tT

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

	---@type table<string, table>
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
	bcAlpha = tonumber(titanBar.A) or Constants.DEFAULT_ALPHA
	bcRed = tonumber(titanBar.R) or Constants.DEFAULT_RED
	bcGreen = tonumber(titanBar.G) or Constants.DEFAULT_GREEN
	bcBlue = tonumber(titanBar.B) or Constants.DEFAULT_BLUE
	TBWidth = tonumber(titanBar.W) or screenWidth
	TBLocale = titanBar.L
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
	_G.ControlData.PI = _G.ControlData.PI or {}
	_G.ControlData.PI.xp = playerInfos.XP
	_G.ControlData.PI.layout = playerInfos.Layout
	local piLayout = _G.ControlData.PI.layout
	if not piLayout then
		_G.AlignLbl = Turbine.UI.ContentAlignment.MiddleLeft;
		_G.AlignVal = Turbine.UI.ContentAlignment.MiddleRight;
		_G.AlignOff = 0;
		_G.AlignOffP = 5;
	--  _G.AlignHead = Turbine.UI.ContentAlignment.MiddleLeft;
	elseif piLayout then
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
	_G.ControlData.PL = _G.ControlData.PL or {}
	_G.ControlData.PL.text = playerLoc.L


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
	_G.ControlData.IF = _G.ControlData.IF or {}
	_G.ControlData.IF.set = infamy.F
	_G.ControlData.IF.points = tonumber(infamy.P) or 0
	_G.ControlData.IF.rank = tonumber(infamy.K) or 0


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
	_G.ControlData.DN = _G.ControlData.DN or {}
	_G.ControlData.DN.next = dayNight.N
	_G.ControlData.DN.ts = tonumber(dayNight.S) or 0


	-- Reputation control
	local reputation = InitControlDefaults("Reputation", {}, {}, {})
	reputation.V = reputation.V or false
	reputation.H = reputation.H == nil and true or reputation.H
	LoadControlSettings("RP", reputation)
	_G.ControlData.RP = _G.ControlData.RP or {}
	-- Legacy setting key: settings.Reputation.H stored "hide max". Runtime flag is now showMax.
	_G.ControlData.RP.showMax = (reputation.H ~= true)


	-- GameTime control
	local gameTime = InitControlDefaults("GameTime", {}, {x=screenWidth - Constants.GAME_TIME_DEFAULT_OFFSET}, {})
	gameTime.V = gameTime.V == nil and true or gameTime.V
	gameTime.H = gameTime.H or false -- default to 12h format
	gameTime.S = gameTime.S or false -- True = Show server time
	gameTime.O = gameTime.O or false -- True = Show both server and real time
	gameTime.M = gameTime.M or Constants.FormatInt(0)
	LoadControlSettings("GT", gameTime)
	_G.ControlData.GT = _G.ControlData.GT or {}
	_G.ControlData.GT.clock24h = (gameTime.H == true)
	_G.ControlData.GT.showST = (gameTime.S == true)
	_G.ControlData.GT.showBT = (gameTime.O == true)
	_G.ControlData.GT.userGMT = tonumber(gameTime.M) or 0
	
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
	titanBar.L = TBLocale
	titanBar.H = Constants.FormatInt(TBHeight)
	titanBar.F = Constants.FormatInt(_G.TBFont)
	titanBar.T = TBFontT
	titanBar.D = TBTop
	titanBar.Z = TBReloaded
	titanBar.ZT = TBReloadedText
	
	-- Options
	local options = EnsureSettingsSection("Options")
	SaveWindowPosition(options, OPWLeft, OPWTop)
	options.H = TBAutoHide
	options.I = Constants.FormatInt(TBIconSize)

	-- Profile, Shell, Background
	SaveWindowPosition(EnsureSettingsSection("Profile"), PPWLeft, PPWTop)
	SaveWindowPosition(EnsureSettingsSection("Shell"), SCWLeft, SCWTop)
	local background = EnsureSettingsSection("Background")
	SaveWindowPosition(background, BGWLeft, BGWTop)
	background.A = BGWToAll

	-- Wallet
	local wallet = EnsureSettingsSection("Wallet")
	SaveControlSettings("WI", wallet)

	-- Money
	local money = EnsureSettingsSection("Money")
	SaveControlSettings("Money", money)
	money.S = _G.ControlData.Money.stm
	money.SS = _G.ControlData.Money.sss
	money.TS = _G.ControlData.Money.sts

	-- LOTROPoints
	local lotroPoints = EnsureSettingsSection("LOTROPoints")
	SaveControlSettings("LP", lotroPoints)
	
	-- BagInfos
	local bagInfos = EnsureSettingsSection("BagInfos")
	SaveControlSettings("BI", bagInfos)
	bagInfos.U = _G.ControlData.BI.used
	bagInfos.M = _G.ControlData.BI.max

	SaveWindowPosition(EnsureSettingsSection("BagInfosList"), BLWLeft, BLWTop)

	-- PlayerInfos
	local playerInfos = EnsureSettingsSection("PlayerInfos")
	SaveControlSettings("PI", playerInfos)
	playerInfos.XP = (_G.ControlData.PI and _G.ControlData.PI.xp) or Constants.FormatInt(0)
	playerInfos.Layout = (_G.ControlData.PI and _G.ControlData.PI.layout) or false

	-- EquipInfos
	local equipInfos = EnsureSettingsSection("EquipInfos")
	SaveControlSettings("EI", equipInfos)
	
	-- DurabilityInfos
	local durabilityInfos = EnsureSettingsSection("DurabilityInfos")
	SaveControlSettings("DI", durabilityInfos)
	durabilityInfos.I = _G.ControlData.DI.icon
	durabilityInfos.N = _G.ControlData.DI.text

	-- PlayerLoc
	local playerLoc = EnsureSettingsSection("PlayerLoc")
	SaveControlSettings("PL", playerLoc)
	playerLoc.L = string.format(((_G.ControlData.PL and _G.ControlData.PL.text) or L["PLMsg"]))

	-- TrackItems
	local trackItems = EnsureSettingsSection("TrackItems")
	SaveControlSettings("TI", trackItems)

	-- Infamy
	local infamy = EnsureSettingsSection("Infamy")
	SaveControlSettings("IF", infamy)
	infamy.F = (_G.ControlData.IF and _G.ControlData.IF.set) ~= false
	infamy.P = Constants.FormatInt((_G.ControlData.IF and _G.ControlData.IF.points) or 0)
	infamy.K = Constants.FormatInt((_G.ControlData.IF and _G.ControlData.IF.rank) or 0)

	-- Vault
	local vault = EnsureSettingsSection("Vault")
	SaveControlSettings("VT", vault)
	
	-- SharedStorage
	local sharedStorage = EnsureSettingsSection("SharedStorage")
	SaveControlSettings("SS", sharedStorage)
	
	-- DayNight
	local dayNight = EnsureSettingsSection("DayNight")
	SaveControlSettings("DN", dayNight)
	dayNight.N = ((_G.ControlData.DN and _G.ControlData.DN.next) ~= false)
	dayNight.S = Constants.FormatInt(((_G.ControlData.DN and _G.ControlData.DN.ts) or 0))
	
	-- Reputation
	local reputation = EnsureSettingsSection("Reputation")
	SaveControlSettings("RP", reputation)
	-- Persist legacy key as hideMax for backward compatibility.
	reputation.H = ((_G.ControlData.RP and _G.ControlData.RP.showMax) ~= true)

	-- GameTime
	local gameTime = EnsureSettingsSection("GameTime")
	SaveControlSettings("GT", gameTime)
	gameTime.H = (_G.ControlData.GT and _G.ControlData.GT.clock24h) == true
	gameTime.S = (_G.ControlData.GT and _G.ControlData.GT.showST) == true
	gameTime.O = (_G.ControlData.GT and _G.ControlData.GT.showBT) == true
	gameTime.M = Constants.FormatInt(((_G.ControlData.GT and tonumber(_G.ControlData.GT.userGMT)) or 0))

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
	Turbine.PluginData.Save( Constants.SETTINGS_SCOPE, Constants.GetSettingsName( GLocale ), settings );
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
	TBLocale = "en";
	
	tA, tR, tG, tB, tX, tY, tW = 0.3, 0.3, 0.3, 0.3, 0, 0, 3;
	tL, tT = 100, 100;
	
	TBHeight, _G.TBFont, TBFontT, TBTop, TBAutoHide, TBIconSize, bcAlpha, bcRed, bcGreen, bcBlue = Constants.DEFAULT_TITANBAR_HEIGHT, 1107296268, "TrajanPro14", true, L["OPAHC"], Constants.ICON_SIZE_LARGE, tA, tR, tG, tB;
	
	-- Reset all controls (currencies included) to defaults defined in ControlRegistry
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