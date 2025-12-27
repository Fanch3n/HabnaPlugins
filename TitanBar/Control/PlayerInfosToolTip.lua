-- Written By Giseldah (inspired by original work by Habna, 4andreas)

import(AppDirD .. "UIHelpers")

local mathmax = math.max
local strfind = string.find
local strformat = string.format
local strgsub = string.gsub
local strreverse = string.reverse
local strsub = string.sub
local tableinsert = table.insert

local useCalcStat = pcall(import,"Giseldah.CalcStat")
-- useCalcStat = false -- test

local NO_CALCSTAT_CONTENT = "-"

-- ******************** Start Formatting/Display Support **********************

-- Floating point numbers bring errors into the calculation, both inside the Lotro-client and in this function collection. This is why a 100% match with the stats in Lotro is impossible.
-- Anyway, to compensate for some errors, we use a calculation deviation correction value. This makes for instance 24.49999999 round to 25, as it's assumed that 24.5 was intended as outcome of a formula.
local DblCalcDev = 0.00000001

-- small number correction for display purposes only (like in-game)
local function correctvalue(nValue)
	if nValue == nil then
		return 0
	elseif (nValue % 1) == 0 then
		return nValue -- don't adjust whole numbers
	elseif nValue < -DblCalcDev then
		return nValue-0.0002
	elseif nValue > DblCalcDev then
		return nValue+0.0002
	else
		return 0
	end
end

local function AddCommas(pre,post) return pre..strreverse(strgsub(strreverse(post),"(%d%d%d)","%1,")) end
local function SplitDecimal(str) return strgsub(str,"^(%d)(%d+)",AddCommas) end
local function ReformatThousSep(str) return strgsub(str,"[%d%.]+",SplitDecimal) end

-- adds trailing zero removal option (set minimum precision): %.0.3f
-- adds thousand separator option to formatting: %'d
local function stringformatvalue(sFormat,xValue)
	if type(xValue) == "number" then
		local sPreFormat = sFormat

		local bPostThousSep = strfind(sPreFormat,"%%'")
		if bPostThousSep then
			sPreFormat = strgsub(sPreFormat,"%%'","%%")
		end

		local bPostFormatTrailZeroes = strfind(sPreFormat,".%d+.%d+%a")
		local nTrailZeroesMinPrec

		if bPostFormatTrailZeroes then
			local _, _, sTrailZeroesMinPrec = strfind(sPreFormat,".(%d+).%d+%a")
			nTrailZeroesMinPrec = tonumber(sTrailZeroesMinPrec)
			sPreFormat = strgsub(sPreFormat,".%d+(.%d+%a)","%1")
		end

		local sPostFormat = strformat(sPreFormat,xValue)

		if bPostFormatTrailZeroes then
			local sTrailZeroesGetDecimals = "%d+(.%d+)"
			local sTrailZeroesSetDecimals = "(%d+).%d+"
			local _, _, sDotDecimals = strfind(sPostFormat,sTrailZeroesGetDecimals)

			while sDotDecimals and #sDotDecimals > nTrailZeroesMinPrec+1 and strsub(sDotDecimals,-1,-1) == "0" do
				sDotDecimals = strsub(sDotDecimals,1,-2)
			end

			if sDotDecimals == "." then
				sPostFormat = strgsub(sPostFormat,sTrailZeroesSetDecimals,"%1")
			elseif sDotDecimals then
				sPostFormat = strgsub(sPostFormat,sTrailZeroesSetDecimals,"%1"..sDotDecimals)
			end
		end

		if bPostThousSep then
			sPostFormat = ReformatThousSep(sPostFormat)
		end

		return sPostFormat
	else
		return strformat(sFormat,xValue)
	end
end

-- ********************* End Formatting/Display Support ***********************

-- simple enum support
local function enum(fields)
	local enums = {}
	for i,name in ipairs(fields) do
		enums[name] = i
	end
	return enums
end

-- player data

local aCalcTypeMit = {[12] = "MitLight", [25] = "MitLight", [13] = "MitMedium", [26] = "MitMedium", [14] = "MitHeavy", [27] = "MitHeavy"}

local PD = enum {
	'CLASS', 'LEVEL', 'RACE', 'XP_CURRENT', 'MAXMORALE', 'MAXPOWER', 'CLASSMORALE', 'CLASSPOWER', 'RACEMORALE', 'RACEPOWER',
	'ICMR', 'NCMR', 'ICPR', 'NCPR', 'CLASSICMR', 'CLASSNCMR', 'CLASSICPR', 'CLASSNCPR', 'RACEICMR', 'RACENCMR', 'RACEICPR', 'RACENCPR',
	'MIGHT', 'AGILITY', 'VITALITY', 'WILL', 'FATE', 'CLASSMIGHT', 'CLASSAGILITY', 'CLASSVITALITY', 'CLASSWILL', 'CLASSFATE', 'RACEMIGHT', 'RACEAGILITY', 'RACEVITALITY', 'RACEWILL', 'RACEFATE',
	'CRITHIT', 'FINESSE', 'MELPHYMAS', 'RNGPHYMAS', 'TACMAS', 'OUTHEAL', 'RESIST', 'CRITDEF', 'INHEAL', 'CANBLOCK', 'CANPARRY', 'CANEVADE', 'BLOCK', 'PARRY', 'EVADE',
	'COMPHYMIT', 'NONPHYMIT', 'TACMIT', 'FIREMIT', 'LIGHTNINGMIT', 'FROSTMIT', 'ACIDMIT', 'SHADOWMIT', 'CALCTYPE_COMPHYMIT', 'CALCTYPE_NONPHYMIT', 'CALCTYPE_TACMIT',
	'PENARMOUR', 'PENBPE', 'PENRESIST'
}

-- CalcStat stats set
local IsCScontent = {
	[PD.CLASSMORALE] = true,		[PD.CLASSICMR] = true,			[PD.CLASSNCMR] = true,
	[PD.CLASSPOWER] = true,			[PD.CLASSICPR] = true,			[PD.CLASSNCPR] = true,
	[PD.RACEMORALE] = true,			[PD.RACEICMR] = true,			[PD.RACENCMR] = true,
	[PD.RACEPOWER] = true,			[PD.RACEICPR] = true,			[PD.RACENCPR] = true,
	[PD.RACEMIGHT] = true,			[PD.RACEAGILITY] = true,		[PD.RACEVITALITY] = true,		[PD.RACEWILL] = true,		[PD.RACEFATE] = true,
	[PD.CALCTYPE_COMPHYMIT] = true,	[PD.CALCTYPE_NONPHYMIT] = true,	[PD.CALCTYPE_TACMIT] = true,
	[PD.PENARMOUR] = true,			[PD.PENBPE] = true,				[PD.PENRESIST] = true
}

-- Regeneration stats set: need to display these with different number of decimals
local IsRegenStat = {
	[PD.ICMR] = true,		[PD.NCMR] = true,		[PD.ICPR] = true,		[PD.NCPR] = true,
	[PD.CLASSICMR] = true,	[PD.CLASSNCMR] = true,	[PD.CLASSICPR] = true,	[PD.CLASSNCPR] = true,
	[PD.RACEICMR] = true,	[PD.RACENCMR] = true,	[PD.RACEICPR] = true,	[PD.RACENCPR] = true
}

local function GetPlayerData()
	aPlayerData = {}
	for _,nPDId in ipairs(PD) do
		aPlayerData[nPDId] = nil
	end

	aPlayerData[PD.CLASS] =		PlayerClassIs
	aPlayerData[PD.LEVEL] =		Player:GetLevel()
	aPlayerData[PD.MAXMORALE] =	Player:GetMaxMorale()
	aPlayerData[PD.MAXPOWER] =	Player:GetMaxPower()
	aPlayerData[PD.RACE] =		PlayerRaceIs

	if PlayerAlign == 1 then -- freeps only
		if ExpPTS then
			-- experience data from chat
			local sExpPTS = strgsub(ExpPTS,"%p+","")
			aPlayerData[PD.XP_CURRENT] = tonumber(sExpPTS)
		end

		local PlayerAttrib = GetPlayerAttributes()
		-- Vital/Main
		aPlayerData[PD.ICMR] =			PlayerAttrib:GetInCombatMoraleRegeneration()
		aPlayerData[PD.NCMR] =			PlayerAttrib:GetOutOfCombatMoraleRegeneration()
		aPlayerData[PD.ICPR] =			PlayerAttrib:GetInCombatPowerRegeneration()
		aPlayerData[PD.NCPR] =			PlayerAttrib:GetOutOfCombatPowerRegeneration()
		aPlayerData[PD.MIGHT] =			PlayerAttrib:GetMight()
		aPlayerData[PD.AGILITY] =		PlayerAttrib:GetAgility()
		aPlayerData[PD.VITALITY] =		PlayerAttrib:GetVitality()
		aPlayerData[PD.WILL] =			PlayerAttrib:GetWill()
		aPlayerData[PD.FATE] =			PlayerAttrib:GetFate()
		aPlayerData[PD.CLASSMIGHT] =	PlayerAttrib:GetBaseMight()
		aPlayerData[PD.CLASSAGILITY] =	PlayerAttrib:GetBaseAgility()
		aPlayerData[PD.CLASSVITALITY] =	PlayerAttrib:GetBaseVitality()
		aPlayerData[PD.CLASSWILL] =		PlayerAttrib:GetBaseWill()
		aPlayerData[PD.CLASSFATE] =		PlayerAttrib:GetBaseFate()
		-- Offence
		aPlayerData[PD.CRITHIT] =		PlayerAttrib:GetBaseCriticalHitChance()
		aPlayerData[PD.FINESSE] =		PlayerAttrib:GetFinesse()
		aPlayerData[PD.MELPHYMAS] =		PlayerAttrib:GetMeleeDamage()
		aPlayerData[PD.RNGPHYMAS] =		PlayerAttrib:GetRangeDamage()
		aPlayerData[PD.TACMAS] =		PlayerAttrib:GetTacticalDamage()
		aPlayerData[PD.OUTHEAL] =		PlayerAttrib:GetOutgoingHealing()
		-- Defence
		aPlayerData[PD.RESIST] =		PlayerAttrib:GetBaseResistance()
		aPlayerData[PD.CRITDEF] =		PlayerAttrib:GetBaseCriticalHitAvoidance()
		aPlayerData[PD.INHEAL] =		PlayerAttrib:GetIncomingHealing()
		-- Avoidance
		aPlayerData[PD.CANBLOCK] =		PlayerAttrib:CanBlock()
		aPlayerData[PD.CANPARRY] =		PlayerAttrib:CanParry()
		aPlayerData[PD.CANEVADE] =		PlayerAttrib:CanEvade()
		aPlayerData[PD.BLOCK] =			PlayerAttrib:GetBlock()
		aPlayerData[PD.PARRY] =			PlayerAttrib:GetParry()
		aPlayerData[PD.EVADE] =			PlayerAttrib:GetEvade()
		-- Mitigations
		aPlayerData[PD.COMPHYMIT] =		PlayerAttrib:GetCommonMitigation()
		aPlayerData[PD.NONPHYMIT] =		PlayerAttrib:GetPhysicalMitigation()
		aPlayerData[PD.TACMIT] =		PlayerAttrib:GetTacticalMitigation()
		aPlayerData[PD.FIREMIT] =		PlayerAttrib:GetFireMitigation()
		aPlayerData[PD.LIGHTNINGMIT] =	PlayerAttrib:GetLightningMitigation()
		aPlayerData[PD.FROSTMIT] =		PlayerAttrib:GetFrostMitigation()
		aPlayerData[PD.ACIDMIT] =		PlayerAttrib:GetAcidMitigation()
		aPlayerData[PD.SHADOWMIT] =		PlayerAttrib:GetShadowMitigation()

		if useCalcStat then
			local sCS_ClassName = CalcStat("ClassName",PlayerClassIdIs)
			local sCS_RaceName = CalcStat("RaceName",PlayerRaceIdIs)
			local nCS_CharLevel = aPlayerData[PD.LEVEL]
			-- Vital/Main
			aPlayerData[PD.CLASSMORALE] =	CalcStat(sCS_ClassName.."CDBaseMorale",nCS_CharLevel)
			aPlayerData[PD.CLASSICMR] =		CalcStat(sCS_ClassName.."CDBaseICMR",nCS_CharLevel)
			aPlayerData[PD.CLASSNCMR] =		CalcStat(sCS_ClassName.."CDBaseNCMR",nCS_CharLevel)
			aPlayerData[PD.CLASSPOWER] =	CalcStat(sCS_ClassName.."CDBasePower",nCS_CharLevel)
			aPlayerData[PD.CLASSICPR] =		CalcStat(sCS_ClassName.."CDBaseICPR",nCS_CharLevel)
			aPlayerData[PD.CLASSNCPR] =		CalcStat(sCS_ClassName.."CDBaseNCPR",nCS_CharLevel)
			if PlayerClassIdIs == 185 and nCS_CharLevel >= 28 then
				-- add Will from Lore-master's Combat Characteristic Ancient Wisdom (active from cLvl28) to CLass Will, because it's also a passive scaling stat, depending on class
				-- with this, main stats will always be like class+race = current, if nothing is traited and no items or effects are on the character
				-- similar passive stats exist for other classes, for example involving Critical Defence rating for Guardian, Warden, etc.
				aPlayerData[PD.CLASSWILL] = (aPlayerData[PD.CLASSWILL] or 0) + CalcStat("LMAncientWisdomWill",nCS_CharLevel)
			end
			aPlayerData[PD.RACEMORALE] =	CalcStat(sCS_RaceName.."RDTraitMorale",nCS_CharLevel)
			aPlayerData[PD.RACEICMR] =		CalcStat(sCS_RaceName.."RDTraitICMR",nCS_CharLevel)
			aPlayerData[PD.RACENCMR] =		CalcStat(sCS_RaceName.."RDTraitNCMR",nCS_CharLevel)
			aPlayerData[PD.RACEPOWER] =		CalcStat(sCS_RaceName.."RDTraitPower",nCS_CharLevel)
			aPlayerData[PD.RACEICPR] =		CalcStat(sCS_RaceName.."RDTraitICPR",nCS_CharLevel)
			aPlayerData[PD.RACENCPR] =		CalcStat(sCS_RaceName.."RDTraitNCPR",nCS_CharLevel)
			aPlayerData[PD.RACEMIGHT] =		CalcStat(sCS_RaceName.."RDTraitMight",nCS_CharLevel)
			aPlayerData[PD.RACEAGILITY] =	CalcStat(sCS_RaceName.."RDTraitAgility",nCS_CharLevel)
			aPlayerData[PD.RACEVITALITY] =	CalcStat(sCS_RaceName.."RDTraitVitality",nCS_CharLevel)
			aPlayerData[PD.RACEWILL] =		CalcStat(sCS_RaceName.."RDTraitWill",nCS_CharLevel)
			aPlayerData[PD.RACEFATE] =		CalcStat(sCS_RaceName.."RDTraitFate",nCS_CharLevel)
			-- Mitigations
			aPlayerData[PD.CALCTYPE_COMPHYMIT] =	aCalcTypeMit[CalcStat(sCS_ClassName.."CDCalcTypeComPhyMit",	nCS_CharLevel)]
			aPlayerData[PD.CALCTYPE_NONPHYMIT] =	aCalcTypeMit[CalcStat(sCS_ClassName.."CDCalcTypeNonPhyMit",	nCS_CharLevel)]
			aPlayerData[PD.CALCTYPE_TACMIT] =		aCalcTypeMit[CalcStat(sCS_ClassName.."CDCalcTypeTacMit",	nCS_CharLevel)]
			-- Penetrations
			aPlayerData[PD.PENARMOUR] =	{T1 = CalcStat("TPenArmour",nCS_CharLevel,1),	T2 = CalcStat("TPenArmour",	nCS_CharLevel,2),	T3 = CalcStat("TPenArmour",	nCS_CharLevel,3)}
			aPlayerData[PD.PENBPE] =	{T1 = CalcStat("TPenBPE",	nCS_CharLevel,1),	T2 = CalcStat("TPenBPE",	nCS_CharLevel,2),	T3 = CalcStat("TPenBPE",	nCS_CharLevel,3)}
			aPlayerData[PD.PENRESIST] =	{T1 = CalcStat("TPenResist",nCS_CharLevel,1),	T2 = CalcStat("TPenResist",	nCS_CharLevel,2),	T3 = CalcStat("TPenResist",	nCS_CharLevel,3)}
		end
	end

	return aPlayerData
end

-- various content display functions

-- displays a generic text or number value from player data
local function SetStatValue(Ctr,aPlayerData,aContData)
	local nPDId = aContData.Stat
	if IsCScontent[nPDId] and not useCalcStat then Ctr:SetText(NO_CALCSTAT_CONTENT) return end
	local xValue = type(nPDId) == "number" and aPlayerData[nPDId] or nil

	local sContentText = ""
	
	if xValue == nil then
		sContentText = L[ "PINOTAVAIL" ]
	elseif type(xValue) == "string" then
		sContentText = xValue
	elseif xValue == 0 then
		-- don't display zero values
	elseif IsRegenStat[nPDId] then
		-- use regeneration stats number formatting
		sContentText = stringformatvalue("%'.1f",correctvalue(xValue))
	else
		sContentText = stringformatvalue("%'.0f",correctvalue(xValue))
	end
	
	Ctr:SetText(sContentText)
end

-- displays LvlXP information
-- needs CalcStat
local function SetLvlXPStatValue(Ctr,aPlayerData,aContData)
	if not aPlayerData[PD.XP_CURRENT] then Ctr:SetText(L[ "PINOTAVAIL" ]) return end
	if not useCalcStat then Ctr:SetText(NO_CALCSTAT_CONTENT) return end
	local nLevelCap = CalcStat("LevelCap")
	if aPlayerData[PD.LEVEL] >= nLevelCap then Ctr:SetText(L[ "PILVLXPCAP" ]) return end

	local nLvlExpCostTot = CalcStat("LvlExpCostTot",aPlayerData[PD.LEVEL])
	local nLvlExpCurr = aPlayerData[PD.XP_CURRENT]-nLvlExpCostTot
	local nLvlExpNext = CalcStat("LvlExpCost",aPlayerData[PD.LEVEL]+1)
	if nLvlExpCurr < 0 or nLvlExpCurr > nLvlExpNext then Ctr:SetText(L[ "PINOTAVAIL" ]) return end
	local nLvlExpPerc = (nLvlExpCurr/nLvlExpNext)*100

	Ctr:SetText(stringformatvalue("%'d",nLvlExpNext-nLvlExpCurr).." / "..stringformatvalue("%.1f%%",correctvalue(nLvlExpPerc)))
end

-- displays next reforge character level and item level
-- needs CalcStat
local function SetLiReforgeStatValue(Ctr,aPlayerData,aContData)
	if not useCalcStat then Ctr:SetText(NO_CALCSTAT_CONTENT) return end
	local nLevelCap = CalcStat("LevelCap")
	local nLi2ILvlCap = CalcStat("Li2ILvlCap")
	local nPrevLi2ReforgeILvl = CalcStat("Li2ReforgeILvl",aPlayerData[PD.LEVEL]-1,nLi2ILvlCap)
	local nTestLi2ReforgeILvl
	
	for nLevel = aPlayerData[PD.LEVEL], nLevelCap do
		nTestLi2ReforgeILvl = CalcStat("Li2ReforgeILvl",nLevel,nLi2ILvlCap)
		if nTestLi2ReforgeILvl > nPrevLi2ReforgeILvl then
			Ctr:SetText(strgsub(strgsub(L[ "PILIREFFMT" ],"#iLvl",nTestLi2ReforgeILvl),"#cLvl",nLevel))
			return
		end
	end
	
	Ctr:SetText(strgsub(strgsub(L[ "PILIREFFMT" ],"#iLvl",nLi2ILvlCap),"#cLvl",aPlayerData[PD.LEVEL]))
end

local CAPCOLOR = {}
CAPCOLOR.NONCAP = Color["white"]
CAPCOLOR.CAPPED = Color["yellow"]
CAPCOLOR.T1 = Color["yellow"] -- T1 only exists in The Hoard (mitigations only), no different color for now
CAPCOLOR.T2 = Color["orange"]
CAPCOLOR.T3 = Color["red"]

-- calculates reached caps and returns approp. color
-- needs CalcStat for caps
local function GetRatCapColor(sCSRatName,nRating,aCSPenRats)
	if useCalcStat and type(sCSRatName) == "string" and type(nRating) == "number" then
		nPRatPCapR = CalcStat(sCSRatName.."PRatPCapR",aPlayerData[PD.LEVEL]) -- (normal) cap rating
		if aCSPenRats then
			-- penetration ratings are negative values, so need to be substracted here to calculate the compensated cap rating
			if nRating >= nPRatPCapR-aCSPenRats.T3 then
				return CAPCOLOR.T3
			elseif nRating >= nPRatPCapR-aCSPenRats.T2 then
				return CAPCOLOR.T2
			elseif nRating >= nPRatPCapR-aCSPenRats.T1 then
				return CAPCOLOR.T1
			end
		end
		if nRating >= nPRatPCapR then
			return CAPCOLOR.CAPPED
		end
	end
	return CAPCOLOR.NONCAP
end

-- Rating stat Select enum for stat selection
local RS = enum {'CURRAT','CURPERC','CAPRAT','CAPPERC'}

-- displays ratings & percentages in colors which depend on reached cap
-- needs CalcStat for percentages and cap ratings
local function SetRatingStatValue(Ctr,aPlayerData,aContData)
	local nRating = type(aContData.CurrRating) == "number" and aPlayerData[aContData.CurrRating] or nil
	local sCSRatName = type(aContData.CSRatName) == "string" and aContData.CSRatName or aPlayerData[aContData.CSRatName]
	local aCSPenRats = type(aContData.CSPenRats) == "number" and aPlayerData[aContData.CSPenRats] or nil
	local bAvailable = type(aContData.Available) == "number" and aPlayerData[aContData.Available] or not aContData.Available

	local sContentText = ""
	local oContentColor = Color["white"]
	
	if not (bAvailable and type(nRating) == "number") then
		sContentText = L[ "PINOTAVAIL" ]
	elseif not useCalcStat and aContData.Select ~= RS.CURRAT then
		sContentText = NO_CALCSTAT_CONTENT
	elseif type(sCSRatName) ~= "string" and aContData.Select ~= RS.CURRAT then
		-- likely unknown mitigation calculation type
		sContentText = L[ "PINOTAVAIL" ]
	elseif aContData.Select == RS.CURRAT then
		sContentText = stringformatvalue("%'.0f",correctvalue(nRating))
		oContentColor = GetRatCapColor(sCSRatName,nRating,aCSPenRats)
	elseif aContData.Select == RS.CURPERC then
		sContentText = stringformatvalue("%.1f%%",correctvalue(CalcStat(sCSRatName.."PRatP",aPlayerData[PD.LEVEL],nRating)+CalcStat(sCSRatName.."PBonus",aPlayerData[PD.LEVEL])))
		oContentColor = GetRatCapColor(sCSRatName,nRating,aCSPenRats)
	elseif aContData.Select == RS.CAPRAT then
		sContentText = stringformatvalue("%'.0f",correctvalue(CalcStat(sCSRatName.."PRatPCapR",aPlayerData[PD.LEVEL])))
		oContentColor = GetRatCapColor(sCSRatName,nRating,aCSPenRats)
	elseif aContData.Select == RS.CAPPERC then
		sContentText = stringformatvalue("%.1f%%",correctvalue(CalcStat(sCSRatName.."PRatPCap",aPlayerData[PD.LEVEL])+CalcStat(sCSRatName.."PBonus",aPlayerData[PD.LEVEL])))
		oContentColor = GetRatCapColor(sCSRatName,nRating,aCSPenRats)
	end
	
	Ctr:SetText(sContentText)
	Ctr:SetForeColor(oContentColor)
end

-- Layout Definition functions

-- initializes a new layout definition with default settings
local function NewLayoutDefinition()
	local aLayoutDef = {}

	-- will contain layout information
	aLayoutDef.ControlDefs = {}
	aLayoutDef.Width = 0 -- layout dimensions
	aLayoutDef.Height = 0

	-- (default) settings, used for layout construction
	-- you can override these settings in table definitions, so you can customize each table if needed
	aLayoutDef.TableOffsetX = 20 -- horizontal offset between tables
	aLayoutDef.BaseIndent = 0 -- usual indent for all except headers
	aLayoutDef.SubIndent = 5 -- indent amount for 'sub' stats
	aLayoutDef.RowHeight = 17 -- can be used to create more or less space between rows, but min height is 16 currently based on separator line
	aLayoutDef.MarginLeft = 1 -- +1 at both sides to compensate for underlining of headers, which are 2 units wider then the table's width
	aLayoutDef.MarginRight = 1
	aLayoutDef.MarginTop = 0 -- margins around each table
	aLayoutDef.MarginBottom = 0
	
	return aLayoutDef
end

-- possible types of row formats, each expecting different row def parameters/settings
local ROWFORMAT = enum {'CHAR_HEADER', 'CHAR_STAT', 'CHAR_LVLXP_STAT', 'CHAR_LIREFORGE_STAT', 'EMPTY', 'VITALMAIN_HEADER', 'VITALMAIN_STAT', 'RATPERC_HEADER', 'RATPERC_STAT', 'COLORCENTER_TEXT'}

-- layout Text Styles
-- Align: text alignment
-- Font: text font
-- Yoff: offset from the top of row, for lining out texts with different font heights
-- Height: height of the text label, depending on font height
-- FGColor: foreground/text color
-- BGColor: background color, used to create separator lines
local LTS = {}
LTS.MAINHDR =	{Align = Turbine.UI.ContentAlignment.BottomLeft,	Font = Turbine.UI.Lotro.Font.TrajanPro16,	Yoff = 0,	Height = 16,	FGColor = Color["white"]}
LTS.STATLBL =	{Align = Turbine.UI.ContentAlignment.BottomLeft,	Font = Turbine.UI.Lotro.Font.TrajanPro14,	Yoff = 2,	Height = 14,	FGColor = Color["nicegold"]}
LTS.COLHDR =	{Align = Turbine.UI.ContentAlignment.BottomRight,	Font = Turbine.UI.Lotro.Font.Verdana13,		Yoff = 3,	Height = 13,	FGColor = Color["white"]}
LTS.STATVAL =	{Align = Turbine.UI.ContentAlignment.BottomRight,	Font = Turbine.UI.Lotro.Font.Verdana12,		Yoff = 3,	Height = 12,	FGColor = Color["white"]}
LTS.COLORTXT =	{Align = Turbine.UI.ContentAlignment.BottomCenter,	Font = Turbine.UI.Lotro.Font.Verdana14,		Yoff = 1,	Height = 14}
LTS.SEP =		{																								Yoff = 15,	Height = 1,									BGColor = Color["trueblue"]}

-- adds a table to a layout definition.
-- tables are automatically positioned next to eachother: a new table will be added to the right of any existing ones (with a gap/offset).
-- layout dimensions will be adjusted accordingly: table widths will be added up and height will be determined by largest table height.
local function AddTableDefinition(aLayoutDef,aTableDef)
	-- get settings from Table or defaults from Layout Def.
	local nTableOffsetX = aTableDef.TableOffsetX or aLayoutDef.TableOffsetX
	local nBaseIndent = aTableDef.BaseIndent or aLayoutDef.BaseIndent
	local nSubIndent = aTableDef.SubIndent or aLayoutDef.SubIndent
	local nRowHeight = aTableDef.RowHeight or aLayoutDef.RowHeight
	local nMarginLeft = aTableDef.MarginLeft or aLayoutDef.MarginLeft
	local nMarginRight = aTableDef.MarginRight or aLayoutDef.MarginRight
	local nMarginTop = aTableDef.MarginTop or aLayoutDef.MarginTop
	local nMarginBottom = aTableDef.MarginBottom or aLayoutDef.MarginBottom

	local nTableStartX = aLayoutDef.Width == 0 and nMarginLeft or aLayoutDef.Width+nTableOffsetX+nMarginLeft
	local nTableStartY = nMarginTop
	local nRowY = nTableStartY
	local nIndent, nIndentedX
	
	-- generate layout control definitions from table row definitions

	local aControlDefs = aLayoutDef.ControlDefs

	local nRowFormat
	for _,aRowDef in ipairs(aTableDef.RowDefs) do
		nRowFormat = aRowDef.RowFormat
		nIndent = aRowDef.SubIndent and nSubIndent or nBaseIndent
		nIndentedX = nTableStartX+nIndent
		if nRowFormat == ROWFORMAT.CHAR_HEADER then
			-- main header label
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.Width,						Style = LTS.MAINHDR,									ContData = {LabelText = aRowDef.LabelText}})
			-- separator
			tableinsert(aControlDefs,{PosX = nTableStartX-1,PosY = nRowY,	Width = aTableDef.Width+2,						Style = LTS.SEP})
		elseif nRowFormat == ROWFORMAT.CHAR_STAT then
			-- stat label
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.Width-nIndent,				Style = LTS.STATLBL,									ContData = {LabelText = aRowDef.LabelText}})
			-- stat value
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.Width-nIndent,				Style = LTS.STATVAL,	ContFunc = aRowDef.ContFunc or
																																								SetStatValue,		ContData = {Stat = aRowDef.Stat}})
		elseif nRowFormat == ROWFORMAT.EMPTY then
			-- nothing.. might do something with vertical spacing here, for situations with only a single table
		elseif nRowFormat == ROWFORMAT.VITALMAIN_HEADER then
			-- main header label
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.Width,						Style = LTS.MAINHDR,									ContData = {LabelText = aRowDef.LabelText}})
			-- column header label class base
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.CellWidthClassBase,			Style = LTS.COLHDR,										ContData = {LabelText = L[ "PICLASS" ]}})
			-- column header label race base
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.CellWidthRaceBase,			Style = LTS.COLHDR,										ContData = {LabelText = L[ "PIRACE" ]}})
			-- column header label current
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.CellWidthCurrent,				Style = LTS.COLHDR,										ContData = {LabelText = L[ "PICURR" ]}})
			-- separator
			tableinsert(aControlDefs,{PosX = nTableStartX-1,PosY = nRowY,	Width = aTableDef.Width+2,						Style = LTS.SEP})
		elseif nRowFormat == ROWFORMAT.VITALMAIN_STAT then
			-- stat label
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.Width-nIndent,				Style = LTS.STATLBL,									ContData = {LabelText = aRowDef.LabelText}})
			-- stat value class base
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.CellWidthClassBase-nIndent,	Style = LTS.STATVAL,	ContFunc = SetStatValue,		ContData = {Stat = aRowDef.ClassBase}})
			-- stat value race base
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.CellWidthRaceBase-nIndent,	Style = LTS.STATVAL,	ContFunc = SetStatValue,		ContData = {Stat = aRowDef.RaceBase}})
			-- stat value current
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.CellWidthCurrent-nIndent,		Style = LTS.STATVAL,	ContFunc = SetStatValue,		ContData = {Stat = aRowDef.StatCurr}})
		elseif nRowFormat == ROWFORMAT.RATPERC_HEADER then
			-- main header label
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.Width,						Style = LTS.MAINHDR,									ContData = {LabelText = aRowDef.LabelText}})
			-- column header label current rating
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.CellWidthCurrRat,				Style = LTS.COLHDR,										ContData = {LabelText = L[ "PICURRAT" ]}})
			-- column header label current percentage
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.CellWidthCurrPerc,			Style = LTS.COLHDR,										ContData = {LabelText = L[ "PICURPERC" ]}})
			-- column header label cap rating
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.CellWidthCapRat,				Style = LTS.COLHDR,										ContData = {LabelText = L[ "PICAPRAT" ]}})
			-- column header label cap percentage
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.CellWidthCapPerc,				Style = LTS.COLHDR,										ContData = {LabelText = L[ "PICAPPERC" ]}})
			-- separator
			tableinsert(aControlDefs,{PosX = nTableStartX-1,PosY = nRowY,	Width = aTableDef.Width+2,						Style = LTS.SEP})
		elseif nRowFormat == ROWFORMAT.RATPERC_STAT then
			-- stat label
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.Width-nIndent,				Style = LTS.STATLBL,									ContData = {LabelText = aRowDef.LabelText}})
			-- stat value current rating
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.CellWidthCurrRat-nIndent,		Style = LTS.STATVAL,	ContFunc = SetRatingStatValue,	ContData = {CurrRating = aRowDef.CurrRating, CSRatName = aRowDef.CSRatName, CSPenRats = aRowDef.CSPenRats, Available = aRowDef.Available, Select = RS.CURRAT}})
			-- stat value current percentage
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.CellWidthCurrPerc-nIndent,	Style = LTS.STATVAL,	ContFunc = SetRatingStatValue,	ContData = {CurrRating = aRowDef.CurrRating, CSRatName = aRowDef.CSRatName, CSPenRats = aRowDef.CSPenRats, Available = aRowDef.Available, Select = RS.CURPERC}})
			-- stat value cap rating
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.CellWidthCapRat-nIndent,		Style = LTS.STATVAL,	ContFunc = SetRatingStatValue,	ContData = {CurrRating = aRowDef.CurrRating, CSRatName = aRowDef.CSRatName, CSPenRats = aRowDef.CSPenRats, Available = aRowDef.Available, Select = RS.CAPRAT}})
			-- stat value cap percentage
			tableinsert(aControlDefs,{PosX = nIndentedX,	PosY = nRowY,	Width = aTableDef.CellWidthCapPerc-nIndent,		Style = LTS.STATVAL,	ContFunc = SetRatingStatValue,	ContData = {CurrRating = aRowDef.CurrRating, CSRatName = aRowDef.CSRatName, CSPenRats = aRowDef.CSPenRats, Available = aRowDef.Available, Select = RS.CAPPERC}})
		elseif nRowFormat == ROWFORMAT.COLORCENTER_TEXT then
			-- centered text with color
			tableinsert(aControlDefs,{PosX = nTableStartX,	PosY = nRowY,	Width = aTableDef.Width,						Style = LTS.COLORTXT,									ContData = {LabelText = aRowDef.LabelText, TextColor = aRowDef.TextColor}})
		end
		nRowY = nRowY+nRowHeight
	end
	
	aLayoutDef.Height = mathmax(aLayoutDef.Height,nRowY+nMarginBottom) -- height of the layout is equal to the height of the largest table
	aLayoutDef.Width = nTableStartX+aTableDef.Width+nMarginRight -- add the total width of this table to the layout's width
end

-- layout for freeps have all available stats
local function GetFreepLayoutDefinition()
	local aLayoutDef = NewLayoutDefinition()

	local nLabelWidth = 100 -- width reservation for label

	-- table on the left, with general character stats, vitals stats and main stats
	AddTableDefinition(aLayoutDef,{
		Width = nLabelWidth+180,
		CellWidthClassBase = nLabelWidth+70, -- reserve Label Width +70 for class base
		CellWidthRaceBase = nLabelWidth+120, -- +50 for race base
		CellWidthCurrent = nLabelWidth+180, -- +60 for current value --> total width
		RowDefs = {
			{RowFormat = ROWFORMAT.CHAR_HEADER,		LabelText = L[ "PICHAR" ]},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PICLASS" ],		SubIndent = false,	Stat = PD.CLASS},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PIRACE" ],		SubIndent = false,	Stat = PD.RACE},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PILEVEL" ],		SubIndent = false,	Stat = PD.LEVEL},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PILVLXP" ],		SubIndent = true,	ContFunc = SetLvlXPStatValue},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PILIREF" ],		SubIndent = true,	ContFunc = SetLiReforgeStatValue},
			{RowFormat = ROWFORMAT.EMPTY},
			{RowFormat = ROWFORMAT.VITALMAIN_HEADER,LabelText = L[ "PIVITALS" ]},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIMORALE" ],	SubIndent = false,	ClassBase = PD.CLASSMORALE,		RaceBase = PD.RACEMORALE,	StatCurr = PD.MAXMORALE},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIICMR" ],		SubIndent = true,	ClassBase = PD.CLASSICMR,		RaceBase = PD.RACEICMR,		StatCurr = PD.ICMR},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PINCMR" ],		SubIndent = true,	ClassBase = PD.CLASSNCMR,		RaceBase = PD.RACENCMR,		StatCurr = PD.NCMR},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIPOWER" ],		SubIndent = false,	ClassBase = PD.CLASSPOWER,		RaceBase = PD.RACEPOWER,	StatCurr = PD.MAXPOWER},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIICPR" ],		SubIndent = true,	ClassBase = PD.CLASSICPR,		RaceBase = PD.RACEICPR,		StatCurr = PD.ICPR},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PINCPR" ],		SubIndent = true,	ClassBase = PD.CLASSNCPR,		RaceBase = PD.RACENCPR,		StatCurr = PD.NCPR},
			{RowFormat = ROWFORMAT.EMPTY},
			{RowFormat = ROWFORMAT.VITALMAIN_HEADER,LabelText = L[ "PIMAIN" ]},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIMIGHT" ],		SubIndent = false,	ClassBase = PD.CLASSMIGHT,		RaceBase = PD.RACEMIGHT,	StatCurr = PD.MIGHT},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIAGILITY" ],	SubIndent = false,	ClassBase = PD.CLASSAGILITY,	RaceBase = PD.RACEAGILITY,	StatCurr = PD.AGILITY},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIVITALITY" ],	SubIndent = false,	ClassBase = PD.CLASSVITALITY,	RaceBase = PD.RACEVITALITY,	StatCurr = PD.VITALITY},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIWILL" ],		SubIndent = false,	ClassBase = PD.CLASSWILL,		RaceBase = PD.RACEWILL,		StatCurr = PD.WILL},
			{RowFormat = ROWFORMAT.VITALMAIN_STAT,	LabelText = L[ "PIFATE" ],		SubIndent = false,	ClassBase = PD.CLASSFATE,		RaceBase = PD.RACEFATE,		StatCurr = PD.FATE}
		}
	})

	-- table in the center, with percentage ratings and some colored notes at the bottom
	AddTableDefinition(aLayoutDef,{
		Width = nLabelWidth+240,
		CellWidthCurrRat = nLabelWidth+70, -- reserve Label Width +70 for current rating
		CellWidthCurrPerc = nLabelWidth+120, -- +50 for current percentage
		CellWidthCapRat = nLabelWidth+190, -- +70 for cap rating
		CellWidthCapPerc = nLabelWidth+240, -- +50 for cap percentage --> total width
		RowDefs = {
			{RowFormat = ROWFORMAT.RATPERC_HEADER,	LabelText = L[ "PIOFFENCE" ]},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIMELDMG" ],	SubIndent = false,	CurrRating = PD.MELPHYMAS,		CSRatName = "PhyDmg"},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIRNGDMG" ],	SubIndent = false,	CurrRating = PD.RNGPHYMAS,		CSRatName = "PhyDmg"},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PITACDMG" ],	SubIndent = false,	CurrRating = PD.TACMAS,			CSRatName = "TacDmg"},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PICRITHIT" ],	SubIndent = false,	CurrRating = PD.CRITHIT,		CSRatName = "CritHit"},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIDEVHIT" ],	SubIndent = false,	CurrRating = PD.CRITHIT,		CSRatName = "DevHit"},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PICRITMAGN" ],	SubIndent = false,	CurrRating = PD.CRITHIT,		CSRatName = "CritMagn"},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIFINESSE" ],	SubIndent = false,	CurrRating = PD.FINESSE,		CSRatName = "Finesse"},
			{RowFormat = ROWFORMAT.EMPTY},
			{RowFormat = ROWFORMAT.RATPERC_HEADER,	LabelText = L[ "PIHEALING" ]},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIOUTHEAL" ],	SubIndent = false,	CurrRating = PD.OUTHEAL,		CSRatName = "OutHeal"},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIINHEAL" ],	SubIndent = false,	CurrRating = PD.INHEAL,			CSRatName = "InHeal"},
			{RowFormat = ROWFORMAT.EMPTY},
			{RowFormat = ROWFORMAT.RATPERC_HEADER,	LabelText = L[ "PIDEFENCE" ]},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PICRITDEF" ],	SubIndent = false,	CurrRating = PD.CRITDEF,		CSRatName = "CritDef"},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIRESIST" ],	SubIndent = false,	CurrRating = PD.RESIST,			CSRatName = "Resist",				CSPenRats = PD.PENRESIST}, -- with resistance penetration
			{RowFormat = ROWFORMAT.EMPTY},
			{RowFormat = ROWFORMAT.EMPTY},
			useCalcStat and
			{RowFormat = ROWFORMAT.COLORCENTER_TEXT,LabelText = L[ "PICAPPED1" ],	TextColor = CAPCOLOR.CAPPED} or		{RowFormat = ROWFORMAT.EMPTY},
			useCalcStat and
			{RowFormat = ROWFORMAT.COLORCENTER_TEXT,LabelText = L[ "PICAPPED2" ],	TextColor = CAPCOLOR.T2} or			{RowFormat = ROWFORMAT.COLORCENTER_TEXT,LabelText = L[ "PICSDEP" ],		TextColor = Color["yellow"]},
			useCalcStat and
			{RowFormat = ROWFORMAT.COLORCENTER_TEXT,LabelText = L[ "PICAPPED3" ],	TextColor = CAPCOLOR.T3} or			{RowFormat = ROWFORMAT.EMPTY}
		}
	})

	-- table on the right, with avoidances and mitigations
	AddTableDefinition(aLayoutDef,{
		Width = nLabelWidth+240,
		CellWidthCurrRat = nLabelWidth+70, -- reserve Label Width +70 for current rating
		CellWidthCurrPerc = nLabelWidth+120, -- +50 for current percentage
		CellWidthCapRat = nLabelWidth+190, -- +70 for cap rating
		CellWidthCapPerc = nLabelWidth+240, -- +50 for cap percentage --> total width
		RowDefs = {
			{RowFormat = ROWFORMAT.RATPERC_HEADER,	LabelText = L[ "PIAVOID" ]},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIBLOCK" ],		SubIndent = false,	CurrRating = PD.BLOCK,			CSRatName = "Block",				CSPenRats = PD.PENBPE,	Available = PD.CANBLOCK}, -- with avoidance penetration
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIBLOCKPART" ],	SubIndent = true,	CurrRating = PD.BLOCK,			CSRatName = "PartBlock",			CSPenRats = PD.PENBPE,	Available = PD.CANBLOCK},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIBLOCKPMIT" ],	SubIndent = true,	CurrRating = PD.BLOCK,			CSRatName = "PartBlockMit",			CSPenRats = PD.PENBPE,	Available = PD.CANBLOCK},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIPARRY" ],		SubIndent = false,	CurrRating = PD.PARRY,			CSRatName = "Parry",				CSPenRats = PD.PENBPE,	Available = PD.CANPARRY},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIPARRYPART" ],	SubIndent = true,	CurrRating = PD.PARRY,			CSRatName = "PartParry",			CSPenRats = PD.PENBPE,	Available = PD.CANPARRY},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIPARRYPMIT" ],	SubIndent = true,	CurrRating = PD.PARRY,			CSRatName = "PartParryMit",			CSPenRats = PD.PENBPE,	Available = PD.CANPARRY},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIEVADE" ],		SubIndent = false,	CurrRating = PD.EVADE,			CSRatName = "Evade",				CSPenRats = PD.PENBPE,	Available = PD.CANEVADE},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIEVADEPART" ],	SubIndent = true,	CurrRating = PD.EVADE,			CSRatName = "PartEvade",			CSPenRats = PD.PENBPE,	Available = PD.CANEVADE},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIEVADEPMIT" ],	SubIndent = true,	CurrRating = PD.EVADE,			CSRatName = "PartEvadeMit",			CSPenRats = PD.PENBPE,	Available = PD.CANEVADE},
			{RowFormat = ROWFORMAT.EMPTY},
			{RowFormat = ROWFORMAT.RATPERC_HEADER,	LabelText = L[ "PIMITS" ]},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIPHYMIT" ],	SubIndent = false,	CurrRating = PD.COMPHYMIT,		CSRatName = PD.CALCTYPE_COMPHYMIT,	CSPenRats = PD.PENARMOUR}, -- with armour(mitigations) penetration
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIORCMIT" ],	SubIndent = true,	CurrRating = PD.NONPHYMIT,		CSRatName = PD.CALCTYPE_NONPHYMIT,	CSPenRats = PD.PENARMOUR},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIFWMIT" ],		SubIndent = true,	CurrRating = PD.NONPHYMIT,		CSRatName = PD.CALCTYPE_NONPHYMIT,	CSPenRats = PD.PENARMOUR},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PITACMIT" ],	SubIndent = false,	CurrRating = PD.TACMIT,			CSRatName = PD.CALCTYPE_TACMIT,		CSPenRats = PD.PENARMOUR},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIFIREMIT" ],	SubIndent = true,	CurrRating = PD.FIREMIT,		CSRatName = PD.CALCTYPE_TACMIT,		CSPenRats = PD.PENARMOUR},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PILIGHTNMIT" ],	SubIndent = true,	CurrRating = PD.LIGHTNINGMIT,	CSRatName = PD.CALCTYPE_TACMIT,		CSPenRats = PD.PENARMOUR},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIFROSTMIT" ],	SubIndent = true,	CurrRating = PD.FROSTMIT,		CSRatName = PD.CALCTYPE_TACMIT,		CSPenRats = PD.PENARMOUR},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PIACIDMIT" ],	SubIndent = true,	CurrRating = PD.ACIDMIT,		CSRatName = PD.CALCTYPE_TACMIT,		CSPenRats = PD.PENARMOUR},
			{RowFormat = ROWFORMAT.RATPERC_STAT,	LabelText = L[ "PISHADMIT" ],	SubIndent = true,	CurrRating = PD.SHADOWMIT,		CSRatName = PD.CALCTYPE_TACMIT,		CSPenRats = PD.PENARMOUR}
		}
	})
	
	return aLayoutDef
end

-- alternative layout for non-freeps is small, because almost no stats available
local function GetAltLayoutDefinition()
	local aLayoutDef = NewLayoutDefinition()

	-- some very general character & vitals stats in a single table
	AddTableDefinition(aLayoutDef,{
		Width = 165,
		RowDefs = {
			{RowFormat = ROWFORMAT.CHAR_HEADER,		LabelText = L[ "PICHAR" ]},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PICLASS" ],		SubIndent = false,	Stat = PD.CLASS},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PIRACE" ],		SubIndent = false,	Stat = PD.RACE},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PILEVEL" ],		SubIndent = false,	Stat = PD.LEVEL},
			{RowFormat = ROWFORMAT.EMPTY},
			{RowFormat = ROWFORMAT.CHAR_HEADER,		LabelText = L[ "PIVITALS" ]},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PIMORALE" ],	SubIndent = false,	Stat = PD.MAXMORALE},
			{RowFormat = ROWFORMAT.CHAR_STAT,		LabelText = L[ "PIPOWER" ],		SubIndent = false,	Stat = PD.MAXPOWER},
		}
	})

	return aLayoutDef
end

-- Control functions

-- create controls out of the layout's control defs
-- returns a list of 'dynamic' controls: controls with content which need to be updated by method/function, using player data
local function CreateControls(ParentCtr,aLayoutDef)
	local aDynamicControls = {}
	local aStyle
	local NewCtr
	for _,aControlDef in ipairs(aLayoutDef.ControlDefs) do
		aStyle = aControlDef.Style

		NewCtr = Turbine.UI.Label()
		NewCtr:SetParent(ParentCtr)

		NewCtr:SetSize(aControlDef.Width,aStyle.Height)
		NewCtr:SetPosition(aControlDef.PosX,aControlDef.PosY+aStyle.Yoff)

		if aStyle.Align		then NewCtr:SetTextAlignment(aStyle.Align) end
		if aStyle.Font		then NewCtr:SetFont(aStyle.Font) end
		if aStyle.FGColor	then NewCtr:SetForeColor(aStyle.FGColor) end
		if aStyle.BGColor	then NewCtr:SetBackColor(aStyle.BGColor) end

		if aControlDef.ContFunc then
			-- dynamic content creation by function
			tableinsert(aDynamicControls,{Ctr = NewCtr, ContFunc = aControlDef.ContFunc, ContData = aControlDef.ContData})
		elseif aControlDef.ContData and aControlDef.ContData.LabelText then
			-- static text label with optional color
			if aControlDef.ContData.TextColor then NewCtr:SetForeColor(aControlDef.ContData.TextColor) end
			NewCtr:SetText(aControlDef.ContData.LabelText)
		end
	end
	return aDynamicControls
end

-- update dynamic controls with player data by using the control's content functions
local function UpdateDynamicContent(aDynamicControls,aPlayerData)
	for _,aDynamicControl in ipairs(aDynamicControls) do
		aDynamicControl.ContFunc(aDynamicControl.Ctr,aPlayerData,aDynamicControl.ContData)
	end
end

-- let's keep the layouts at hand, instead of constructing every time the window is shown
local aFreepLayoutDef
local aAltLayoutDef

function ShowPIWindow()
	-- construct layouts on request
	local aLayoutDef
	if PlayerAlign == 1 then -- Freep?
		if not aFreepLayoutDef then
			aFreepLayoutDef = GetFreepLayoutDefinition()
		end
		aLayoutDef = aFreepLayoutDef -- all stats
	else
		if not aAltLayoutDef then
			aAltLayoutDef = GetAltLayoutDefinition()
		end
		aLayoutDef = aAltLayoutDef -- very limited
	end

	-- offsetX, offsetY, width, height
	local x, y, w, h = -5, -15, aLayoutDef.Width, aLayoutDef.Height
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition()
	if w+mouseX > screenWidth then x = w+41 - 10 end
	if not TBTop then y = h+38 end

	_G.ToolTipWin = Turbine.UI.Window()
	_G.ToolTipWin:SetZOrder(1)
	_G.ToolTipWin:SetPosition(mouseX-x,mouseY-y)
	_G.ToolTipWin:SetSize(w+41,h+38)
	_G.ToolTipWin:SetVisible(true)

	--**v Control of all player infos v**
	local APICtr = CreateControl(Turbine.UI.Control, _G.ToolTipWin, 20, 19, w, h)
	APICtr:SetZOrder(1)
	APICtr:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
	--APICtr:SetBackColor(Color["trueblue"]) -- test size
	--APICtr:SetBackground("HabnaPlugins/TitanBar/Resources/".."PIbk.tga")
	--**^

	-- creates all needed controls defined in the layout and returns a list with controls with 'dynamic' content: these need to be updated with data
	local aDynamicControls = CreateControls(APICtr,aLayoutDef)

	-- in theory you only need to create layout+controls once and update player.data+dyn.controls every time the window is shown,
	-- but it might be bad for resource usage.

	-- get all player data from client which are needed for display generation
	local aPlayerData = GetPlayerData()

	-- update all dynamic content with player information
	UpdateDynamicContent(aDynamicControls,aPlayerData)

	ApplySkin()
end
