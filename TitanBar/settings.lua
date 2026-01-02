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
	-- Create legacy global variables for backward compatibility
	ShowWallet = _G.ControlData.WI.show
	WIbcAlpha, WIbcRed, WIbcGreen, WIbcBlue = _G.ControlData.WI.colors.alpha, _G.ControlData.WI.colors.red, _G.ControlData.WI.colors.green, _G.ControlData.WI.colors.blue
	_G.WILocX, _G.WILocY = _G.ControlData.WI.location.x, _G.ControlData.WI.location.y
	WIWLeft, WIWTop = _G.ControlData.WI.window.left, _G.ControlData.WI.window.top


	-- Money control
	local money = InitControlDefaults("Money", {}, {x=Constants.DEFAULT_MONEY_X}, {})
	money.V = money.V == nil and true or money.V
	money.S = money.S or false --Show Total Money of all characters on TitanBar Money control
	money.SS = money.SS == nil and true or money.SS --Show stats for session
	money.TS = money.TS == nil and true or money.TS --Show stats for today
	money.W = money.W or Constants.FormatInt(Constants.Position.TITANBAR)
	LoadControlSettings("Money", money)
	-- Create legacy global variables for backward compatibility
	ShowMoney = _G.ControlData.Money.show
	MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue = _G.ControlData.Money.colors.alpha, _G.ControlData.Money.colors.red, _G.ControlData.Money.colors.green, _G.ControlData.Money.colors.blue
	_G.MILocX, _G.MILocY = _G.ControlData.Money.location.x, _G.ControlData.Money.location.y
	MIWLeft, MIWTop = _G.ControlData.Money.window.left, _G.ControlData.Money.window.top
	_G.MIWhere = _G.ControlData.Money.where
	_G.STM = money.S
	_G.SSS = money.SS
	_G.STS = money.TS

	-- LOTROPoints control
	local lotroPoints = InitControlDefaults("LOTROPoints", {}, {}, {})
	lotroPoints.V = lotroPoints.V or false
	lotroPoints.W = lotroPoints.W or Constants.FormatInt(tW)
	LoadControlSettings("LP", lotroPoints)
	-- Create legacy global variables for backward compatibility
	ShowLOTROPoints = _G.ControlData.LP.show
	LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue = _G.ControlData.LP.colors.alpha, _G.ControlData.LP.colors.red, _G.ControlData.LP.colors.green, _G.ControlData.LP.colors.blue
	_G.LPLocX, _G.LPLocY = _G.ControlData.LP.location.x, _G.ControlData.LP.location.y
	LPWLeft, LPWTop = _G.ControlData.LP.window.left, _G.ControlData.LP.window.top
	_G.LPWhere = _G.ControlData.LP.where


	-- BagInfos control
	local bagInfos = InitControlDefaults("BagInfos", {}, {}, {})
	bagInfos.V = bagInfos.V == nil and true or bagInfos.V
	bagInfos.U = bagInfos.U == nil and true or bagInfos.U
	bagInfos.M = bagInfos.M == nil and true or bagInfos.M
	LoadControlSettings("BI", bagInfos)
	-- Create legacy global variables for backward compatibility
	ShowBagInfos = _G.ControlData.BI.show
	BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue = _G.ControlData.BI.colors.alpha, _G.ControlData.BI.colors.red, _G.ControlData.BI.colors.green, _G.ControlData.BI.colors.blue
	_G.BILocX, _G.BILocY = _G.ControlData.BI.location.x, _G.ControlData.BI.location.y
	BIWLeft, BIWTop = _G.ControlData.BI.window.left, _G.ControlData.BI.window.top
	_G.BIUsed = bagInfos.U
	_G.BIMax = bagInfos.M


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
	-- Create legacy global variables for backward compatibility
	ShowPlayerInfos = _G.ControlData.PI.show
	PIbcAlpha, PIbcRed, PIbcGreen, PIbcBlue = _G.ControlData.PI.colors.alpha, _G.ControlData.PI.colors.red, _G.ControlData.PI.colors.green, _G.ControlData.PI.colors.blue
	_G.PILocX, _G.PILocY = _G.ControlData.PI.location.x, _G.ControlData.PI.location.y
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
	-- Create legacy global variables for backward compatibility
	ShowEquipInfos = _G.ControlData.EI.show
	EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue = _G.ControlData.EI.colors.alpha, _G.ControlData.EI.colors.red, _G.ControlData.EI.colors.green, _G.ControlData.EI.colors.blue
	_G.EILocX, _G.EILocY = _G.ControlData.EI.location.x, _G.ControlData.EI.location.y


	-- DurabilityInfos control
	local durabilityInfos = InitControlDefaults("DurabilityInfos", {}, {x=Constants.DEFAULT_DURABILITY_INFO_X}, {})
	durabilityInfos.V = durabilityInfos.V == nil and true or durabilityInfos.V
	durabilityInfos.I = durabilityInfos.I == nil and true or durabilityInfos.I
	durabilityInfos.N = durabilityInfos.N == nil and true or durabilityInfos.N
	LoadControlSettings("DI", durabilityInfos)
	-- Create legacy global variables for backward compatibility
	ShowDurabilityInfos = _G.ControlData.DI.show
	DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue = _G.ControlData.DI.colors.alpha, _G.ControlData.DI.colors.red, _G.ControlData.DI.colors.green, _G.ControlData.DI.colors.blue
	_G.DILocX, _G.DILocY = _G.ControlData.DI.location.x, _G.ControlData.DI.location.y
	DIWLeft, DIWTop = _G.ControlData.DI.window.left, _G.ControlData.DI.window.top
	DIIcon = durabilityInfos.I
	DIText = durabilityInfos.N


	-- PlayerLoc control
	local playerLoc = InitControlDefaults("PlayerLoc", {}, {x=screenWidth - Constants.DEFAULT_PLAYER_LOC_WIDTH})
	playerLoc.V = playerLoc.V == nil and true or playerLoc.V
	playerLoc.L = playerLoc.L or L["PLMsg"]
	LoadControlSettings("PL", playerLoc)
	-- Create legacy global variables for backward compatibility
	ShowPlayerLoc = _G.ControlData.PL.show
	PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue = _G.ControlData.PL.colors.alpha, _G.ControlData.PL.colors.red, _G.ControlData.PL.colors.green, _G.ControlData.PL.colors.blue
	pLLoc = playerLoc.L
	_G.PLLocX, _G.PLLocY = _G.ControlData.PL.location.x, _G.ControlData.PL.location.y


	-- TrackItems control
	local trackItems = InitControlDefaults("TrackItems", {}, {}, {})
	trackItems.V = trackItems.V or false
	LoadControlSettings("TI", trackItems)
	-- Create legacy global variables for backward compatibility
	ShowTrackItems = _G.ControlData.TI.show
	TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue = _G.ControlData.TI.colors.alpha, _G.ControlData.TI.colors.red, _G.ControlData.TI.colors.green, _G.ControlData.TI.colors.blue
	_G.TILocX, _G.TILocY = _G.ControlData.TI.location.x, _G.ControlData.TI.location.y
	TIWLeft, TIWTop = _G.ControlData.TI.window.left, _G.ControlData.TI.window.top


	-- Infamy control
	local infamy = InitControlDefaults("Infamy", {}, {}, {})
	infamy.V = infamy.V or false
	infamy.F = infamy.F == nil and true or infamy.F
	infamy.P = infamy.P or Constants.FormatInt(0)
	infamy.K = infamy.K or Constants.FormatInt(0)
	LoadControlSettings("IF", infamy)
	-- Create legacy global variables for backward compatibility
	ShowInfamy = _G.ControlData.IF.show
	IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue = _G.ControlData.IF.colors.alpha, _G.ControlData.IF.colors.red, _G.ControlData.IF.colors.green, _G.ControlData.IF.colors.blue
	_G.IFLocX, _G.IFLocY = _G.ControlData.IF.location.x, _G.ControlData.IF.location.y
	IFWLeft, IFWTop = _G.ControlData.IF.window.left, _G.ControlData.IF.window.top
	SetInfamy = infamy.F
	InfamyPTS = infamy.P
	InfamyRank = infamy.K


	-- Vault control
	local vault = InitControlDefaults("Vault", {}, {}, {})
	vault.V = vault.V or false
	LoadControlSettings("VT", vault)
	-- Create legacy global variables for backward compatibility
	ShowVault = _G.ControlData.VT.show
	VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue = _G.ControlData.VT.colors.alpha, _G.ControlData.VT.colors.red, _G.ControlData.VT.colors.green, _G.ControlData.VT.colors.blue
	_G.VTLocX, _G.VTLocY = _G.ControlData.VT.location.x, _G.ControlData.VT.location.y
	VTWLeft, VTWTop = _G.ControlData.VT.window.left, _G.ControlData.VT.window.top


	-- SharedStorage control
	local sharedStorage = InitControlDefaults("SharedStorage", {}, {}, {})
	sharedStorage.V = sharedStorage.V or false
	LoadControlSettings("SS", sharedStorage)
	-- Create legacy global variables for backward compatibility
	ShowSharedStorage = _G.ControlData.SS.show
	SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue = _G.ControlData.SS.colors.alpha, _G.ControlData.SS.colors.red, _G.ControlData.SS.colors.green, _G.ControlData.SS.colors.blue
	_G.SSLocX, _G.SSLocY = _G.ControlData.SS.location.x, _G.ControlData.SS.location.y
	SSWLeft, SSWTop = _G.ControlData.SS.window.left, _G.ControlData.SS.window.top

	-- DayNight control
	local dayNight = InitControlDefaults("DayNight", {}, {}, {})
	dayNight.V = dayNight.V or false
	dayNight.N = dayNight.N == nil and true or dayNight.N
	dayNight.S = dayNight.S or Constants.FormatInt(10350)
	LoadControlSettings("DN", dayNight)
	-- Create legacy global variables for backward compatibility
	ShowDayNight = _G.ControlData.DN.show
	DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue = _G.ControlData.DN.colors.alpha, _G.ControlData.DN.colors.red, _G.ControlData.DN.colors.green, _G.ControlData.DN.colors.blue
	_G.DNLocX, _G.DNLocY = _G.ControlData.DN.location.x, _G.ControlData.DN.location.y
	DNWLeft, DNWTop = _G.ControlData.DN.window.left, _G.ControlData.DN.window.top
	_G.DNNextT = dayNight.N
	_G.TS = tonumber(dayNight.S)


	-- Reputation control
	local reputation = InitControlDefaults("Reputation", {}, {}, {})
	reputation.V = reputation.V or false
	reputation.H = reputation.H or false
	LoadControlSettings("RP", reputation)
	-- Create legacy global variables for backward compatibility
	ShowReputation = _G.ControlData.RP.show
	HideMaxReps = reputation.H
	RPbcAlpha, RPbcRed, RPbcGreen, RPbcBlue = _G.ControlData.RP.colors.alpha, _G.ControlData.RP.colors.red, _G.ControlData.RP.colors.green, _G.ControlData.RP.colors.blue
	_G.RPLocX, _G.RPLocY = _G.ControlData.RP.location.x, _G.ControlData.RP.location.y
	RPWLeft, RPWTop = _G.ControlData.RP.window.left, _G.ControlData.RP.window.top


	-- GameTime control
	local gameTime = InitControlDefaults("GameTime", {}, {x=screenWidth - Constants.GAME_TIME_DEFAULT_OFFSET}, {})
	gameTime.V = gameTime.V == nil and true or gameTime.V
	gameTime.H = gameTime.H or false -- default to 12h format
	gameTime.S = gameTime.S or false -- True = Show server time
	gameTime.O = gameTime.O or false -- True = Show both server and real time
	gameTime.M = gameTime.M or Constants.FormatInt(0)
	LoadControlSettings("GT", gameTime)
	-- Create legacy global variables for backward compatibility
	ShowGameTime = _G.ControlData.GT.show
	GTbcAlpha, GTbcRed, GTbcGreen, GTbcBlue = _G.ControlData.GT.colors.alpha, _G.ControlData.GT.colors.red, _G.ControlData.GT.colors.green, _G.ControlData.GT.colors.blue
	_G.GTLocX, _G.GTLocY = _G.ControlData.GT.location.x, _G.ControlData.GT.location.y
	GTWLeft, GTWTop = _G.ControlData.GT.window.left, _G.ControlData.GT.window.top
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
		_G.ControlData.WI.window.left = WIWLeft
		_G.ControlData.WI.window.top = WIWTop
		if not settings.Wallet then settings.Wallet = {} end
		SaveControlSettings("WI", settings.Wallet)

		-- Money
		_G.ControlData.Money.where = _G.MIWhere  -- Sync back any changes
		if not settings.Money then settings.Money = {} end
		SaveControlSettings("Money", settings.Money)
		settings.Money.S = _G.STM
		settings.Money.SS = _G.SSS
		settings.Money.TS = _G.STS
		if PlayerAlign == 1 then SaveWindowPosition(settings.Money, MIWLeft, MIWTop) end

		-- LOTROPoints
		_G.ControlData.LP.window.left = LPWLeft
		_G.ControlData.LP.window.top = LPWTop
		if not settings.LOTROPoints then settings.LOTROPoints = {} end
		SaveControlSettings("LP", settings.LOTROPoints)
		
		_G.ControlData.BI.window.left = BIWLeft
		_G.ControlData.BI.window.top = BIWTop
		
		-- BagInfos
		if not settings.BagInfos then settings.BagInfos = {} end
		SaveControlSettings("BI", settings.BagInfos)
		settings.BagInfos.U = _G.BIUsed
		settings.BagInfos.M = _G.BIMax

		SaveSectionWithWindowPos("BagInfosList", BLWLeft, BLWTop)

		-- PlayerInfos
		if not settings.PlayerInfos then settings.PlayerInfos = {} end
		SaveControlSettings("PI", settings.PlayerInfos)
		settings.PlayerInfos.XP = ExpPTS
		settings.PlayerInfos.Layout = PILayout

		-- EquipInfos
		if not settings.EquipInfos then settings.EquipInfos = {} end
		SaveControlSettings("EI", settings.EquipInfos)
		_G.ControlData.DI.window.left = DIWLeft
		_G.ControlData.DI.window.top = DIWTop
		
		-- DurabilityInfos
		if not settings.DurabilityInfos then settings.DurabilityInfos = {} end
		SaveControlSettings("DI", settings.DurabilityInfos)
		settings.DurabilityInfos.I = DIIcon
		settings.DurabilityInfos.N = DIText
	
		-- PlayerLoc
		if not settings.PlayerLoc then settings.PlayerLoc = {} end
		SaveControlSettings("PL", settings.PlayerLoc)
		settings.PlayerLoc.L = string.format(pLLoc)

		-- TrackItems
		if not settings.TrackItems then settings.TrackItems = {} end
		SaveControlSettings("TI", settings.TrackItems)

		_G.ControlData.IF.window.left = IFWLeft
		_G.ControlData.IF.window.top = IFWTop
		
		-- Infamy
		if not settings.Infamy then settings.Infamy = {} end
		SaveControlSettings("IF", settings.Infamy)
		settings.Infamy.P = Constants.FormatInt(InfamyPTS)
		settings.Infamy.K = Constants.FormatInt(InfamyRank)

		-- Vault
		_G.ControlData.VT.window.left = VTWLeft
		_G.ControlData.VT.window.top = VTWTop
		if not settings.Vault then settings.Vault = {} end
		SaveControlSettings("VT", settings.Vault)
		
		-- SharedStorage
		_G.ControlData.SS.window.left = SSWLeft
		_G.ControlData.SS.window.top = SSWTop
		if not settings.SharedStorage then settings.SharedStorage = {} end
		SaveControlSettings("SS", settings.SharedStorage)
		
		_G.ControlData.DN.window.left = DNWLeft
		_G.ControlData.DN.window.top = DNWTop
		
		-- DayNight
		if not settings.DayNight then settings.DayNight = {} end
		SaveControlSettings("DN", settings.DayNight)
		settings.DayNight.N = _G.DNNextT
		settings.DayNight.S = Constants.FormatInt(_G.TS)
		
		_G.ControlData.RP.window.left = RPWLeft
		_G.ControlData.RP.window.top = RPWTop
		
		-- Reputation
		if not settings.Reputation then settings.Reputation = {} end
		SaveControlSettings("RP", settings.Reputation)
		settings.Reputation.H = HideMaxReps

		-- GameTime
		if PlayerAlign == 1 then
			_G.ControlData.GT.window.left = GTWLeft
			_G.ControlData.GT.window.top = GTWTop
		end
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
	
	TBHeight, _G.TBFont, TBFontT, TBTop, TBAutoHide, TBIconSize, bcAlpha, bcRed, bcGreen, bcBlue = Constants.DEFAULT_TITANBAR_HEIGHT, 1107296268, "TrajanPro14", true, L["OPAHC"], Constants.ICON_SIZE_LARGE, tA, tR, tG, tB; --Backcolor & default X Location for TitanBar
	ShowWallet, WIbcAlpha, WIbcRed, WIbcGreen, WIbcBlue, _G.WILocX, _G.WILocY = false, tA, tR, tG, tB, tX, tY; --for Wallet Control
	ShowMoney, _G.STM, _G.SSS, _G.STS, MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue, _G.MILocX, _G.MILocY, _G.MIWhere = true, false, true, true, tA, tR, tG, tB, Constants.DEFAULT_MONEY_X, tY, Constants.Position.TITANBAR; --for Money Control
	ShowBagInfos, _G.BIUsed, _G.BIMax, BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue, _G.BILocX, _G.BILocY = true, true, true, tA, tR, tG, tB, tX, tY; --for Bag info Control
	ShowEquipInfos, EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue, _G.EILocX, _G.EILocY = true, tA, tR, tG, tB, Constants.DEFAULT_EQUIP_INFO_X, tY; --for Equipment infos Control
	ShowDurabilityInfos, DIIcon, DIText, DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue, _G.DILocX, _G.DILocY = true, true, true, tA, tR, tG, tB, Constants.DEFAULT_DURABILITY_INFO_X, tY; --for Durability infos Control
	ShowPlayerInfos, PIbcAlpha, PIbcRed, PIbcGreen, PIbcBlue, _G.PILocX, _G.PILocY = false, tA, tR, tG, tB, Constants.DEFAULT_PLAYER_INFO_X, tY; --for Player infos Control
	ShowTrackItems, TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue, _G.TILocX, _G.TILocY = false, tA, tR, tG, tB, tX, tY; --for Track Items Control
	ShowInfamy, IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue, _G.IFLocX, _G.IFLocY = false, tA, tR, tG, tB, tX, tY --for Infamy Control
	ShowVault, VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue, _G.VTLocX, _G.VTLocY = false, tA, tR, tG, tB, tX, tY --for Vault Control
	ShowSharedStorage, SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue, _G.SSLocX, _G.SSLocY = false, tA, tR, tG, tB, tX, tY --for SharedStorage Control
	--ShowBank, BKbcAlpha, BKbcRed, BKbcGreen, BKbcBlue, _G.BKLocX, _G.BKLocY = false, tA, tR, tG, tB, tX, tY --for Bank Control
	ShowDayNight, _G.DNNextT, DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue, _G.DNLocX, _G.DNLocY = false, true, tA, tR, tG, tB, tX, tY --for DayNight Control
	ShowReputation, RPbcAlpha, RPbcRed, RPbcGreen, RPbcBlue, _G.RPLocX, _G.RPLocY = false, tA, tR, tG, tB, tX, tY --for Reputation Control
	ShowLOTROPoints, LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue, _G.LPLocX, _G.LPLocY, _G.LPWhere = false, tA, tR, tG, tB, tX, tY, tW; --for LOTRO points Control
	ShowPlayerLoc, PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue, _G.PLLocX, _G.PLLocX = true, tA, tR, tG, tB, screenWidth - Constants.DEFAULT_PLAYER_LOC_WIDTH, tY; --for Player Location Control
	
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
	
	local oldLocX = settings.Wallet.X / oldScreenWidth;
	_G.WILocX = oldLocX * screenWidth;
	settings.Wallet.X = string.format("%.0f", _G.WILocX);
	if ShowWallet then WI[ "Ctr" ]:SetPosition( _G.WILocX, _G.WILocY ); end

	oldLocX = settings.Money.X / oldScreenWidth;
	_G.MILocX = oldLocX * screenWidth;
	settings.Money.X = string.format("%.0f", _G.MILocX);
	if ShowMoney and _G.MIWhere == 1 then MI[ "Ctr" ]:SetPosition( _G.MILocX, _G.MILocY ); end

	oldLocX = settings.BagInfos.X / oldScreenWidth;
	_G.BILocX = oldLocX * screenWidth;
	settings.BagInfos.X = string.format("%.0f", _G.BILocX);
	if ShowBagInfos then BI[ "Ctr" ]:SetPosition( _G.BILocX, _G.BILocY ); end

	oldLocX = settings.PlayerInfos.X / oldScreenWidth;
	_G.PILocX = oldLocX * screenWidth;
	settings.PlayerInfos.X = string.format("%.0f", _G.PILocX);
	if ShowPlayerInfos then PI[ "Ctr" ]:SetPosition( _G.PILocX, _G.PILocY ); end

	oldLocX = settings.EquipInfos.X / oldScreenWidth;
	_G.EILocX = oldLocX * screenWidth;
	settings.EquipInfos.X = string.format("%.0f", _G.EILocX);
	if ShowEquipInfos then EI[ "Ctr" ]:SetPosition( _G.EILocX, _G.EILocY ); end

	oldLocX = settings.DurabilityInfos.X / oldScreenWidth;
	_G.DILocX = oldLocX * screenWidth;
	settings.DurabilityInfos.X = string.format("%.0f", _G.DILocX);
	if ShowDurabilityInfos then DI[ "Ctr" ]:SetPosition( _G.DILocX, _G.DILocY ); end

	oldLocX = settings.PlayerLoc.X / oldScreenWidth;
	_G.PLLocX = oldLocX * screenWidth;
	settings.PlayerLoc.X = string.format("%.0f", _G.PLLocX);
	if ShowPlayerLoc then PL[ "Ctr" ]:SetPosition( _G.PLLocX, _G.PLLocY ); end

	oldLocX = settings.TrackItems.X / oldScreenWidth;
	_G.TILocX = oldLocX * screenWidth;
	settings.TrackItems.X = string.format("%.0f", _G.TILocX);
	if ShowTrackItems then TI[ "Ctr" ]:SetPosition( _G.TILocX, _G.TILocY ); end

	oldLocX = settings.Infamy.X / oldScreenWidth;
	_G.IFLocX = oldLocX * screenWidth;
	settings.Infamy.X = string.format("%.0f", _G.IFLocX);
	if ShowInfamy then IF[ "Ctr" ]:SetPosition( _G.IFLocX, _G.IFLocY ); end

	oldLocX = settings.Vault.X / oldScreenWidth;
	_G.VTLocX = oldLocX * screenWidth;
	settings.Vault.X = string.format("%.0f", _G.VTLocX);
	if ShowVault then VT[ "Ctr" ]:SetPosition( _G.VTLocX, _G.VTLocY ); end

	oldLocX = settings.SharedStorage.X / oldScreenWidth;
	_G.SSLocX = oldLocX * screenWidth;
	settings.SharedStorage.X = string.format("%.0f", _G.SSLocX);
	if ShowSharedStorage then SS[ "Ctr" ]:SetPosition( _G.SSLocX, _G.SSLocY ); end

	--oldLocX = settings.Bank.X / oldScreenWidth;
	--_G.BKLocX = oldLocX * screenWidth;
	--settings.Bank.X = string.format("%.0f", _G.BKLocX);
	--if ShowBank then BK[ "Ctr" ]:SetPosition( _G.BKLocX, _G.BKLocY ); end

	oldLocX = settings.DayNight.X / oldScreenWidth;
	_G.DNLocX = oldLocX * screenWidth;
	settings.DayNight.X = string.format("%.0f", _G.DNLocX);
	if ShowDayNight then DN[ "Ctr" ]:SetPosition( _G.DNLocX, _G.DNLocY ); end

	oldLocX = settings.Reputation.X / oldScreenWidth;
	_G.RPLocX = oldLocX * screenWidth;
	settings.Reputation.X = string.format("%.0f", _G.RPLocX);
	if ShowReputation then RP[ "Ctr" ]:SetPosition( _G.RPLocX, _G.RPLocY ); end

	oldLocX = settings.LOTROPoints.X / oldScreenWidth;
	_G.LPLocX = oldLocX * screenWidth;
	settings.LOTROPoints.X = string.format("%.0f", _G.LPLocX);
	if ShowLOTROPoints and _G.LPWhere == 1 then LP[ "Ctr" ]:SetPosition( _G.LPLocX, _G.LPLocY ); end

	oldLocX = settings.GameTime.X / oldScreenWidth;
	_G.GTLocX = oldLocX * screenWidth;
	settings.GameTime.X = string.format("%.0f", _G.GTLocX);
	if ShowGameTime then GT[ "Ctr" ]:SetPosition( _G.GTLocX, _G.GTLocY ); end
	
	for k,v in pairs(_G.currencies.list) do
		oldLocX = settings[v.name].X / oldScreenWidth
		_G.CurrencyData[v.name].LocX = oldLocX * screenWidth
		settings[v.name].X = string.format("%.0f", _G.CurrencyData[v.name].LocX)
		if _G.CurrencyData[v.name].IsVisible and _G.CurrencyData[v.name].Where == Constants.Position.TITANBAR then
			_G.CurrencyData[v.name].Ctr:SetPosition(_G.CurrencyData[v.name].LocX, _G.CurrencyData[v.name].LocY)
		end
	end


	SaveSettings( false );
	write( L["TBSSCD"] );
end