-- Written By Giseldah (Original By Habna. 4andreas)

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

-- player data

local aCalcTypeMit = {[12] = "MitLight", [25] = "MitLight", [13] = "MitMedium", [26] = "MitMedium", [14] = "MitHeavy", [27] = "MitHeavy"}

local PD = {}
	PD.CLASS,
	PD.LEVEL,
	PD.MAXMORALE,
	PD.MAXPOWER,
	PD.BASEMORALE,
	PD.BASEPOWER,
	PD.RACE,
	PD.XP_CURRENT,
	PD.ICMR,
	PD.NCMR,
	PD.ICPR,
	PD.NCPR,
	PD.BASEICMR,
	PD.BASENCMR,
	PD.BASEICPR,
	PD.BASENCPR,
	PD.MIGHT,
	PD.AGILITY,
	PD.VITALITY,
	PD.WILL,
	PD.FATE,
	PD.BASEMIGHT,
	PD.BASEAGILITY,
	PD.BASEVITALITY,
	PD.BASEWILL,
	PD.BASEFATE,
	PD.CRITHIT,
	PD.FINESSE,
	PD.MELPHYMAS,
	PD.RNGPHYMAS,
	PD.TACMAS,
	PD.OUTHEAL,
	PD.RESIST,
	PD.CRITDEF,
	PD.INHEAL,
	PD.CANBLOCK,
	PD.CANPARRY,
	PD.CANEVADE,
	PD.BLOCK,
	PD.PARRY,
	PD.EVADE,
	PD.COMPHYMIT,
	PD.NONPHYMIT,
	PD.TACMIT,
	PD.FIREMIT,
	PD.LIGHTNINGMIT,
	PD.FROSTMIT,
	PD.ACIDMIT,
	PD.SHADOWMIT,
	PD.CALCTYPE_COMPHYMIT,
	PD.CALCTYPE_NONPHYMIT,
	PD.CALCTYPE_TACMIT,
	PD.PENARMOUR,
	PD.PENBPE,
	PD.PENRESIST
	= 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55

local function GetPlayerData()
	aPlayerData = {}
	for nPDId = 1,55 do
		aPlayerData[nPDId] = nil
	end

	aPlayerData[PD.CLASS] = PlayerClassIs
	aPlayerData[PD.LEVEL] = Player:GetLevel()
	aPlayerData[PD.MAXMORALE] = Player:GetMaxMorale()
	aPlayerData[PD.MAXPOWER] = Player:GetMaxPower()
	aPlayerData[PD.RACE] = PlayerRaceIs

	if PlayerAlign == 1 then -- freeps only
		local PlayerAttrib = GetPlayerAttributes()

		local sCS_ClassName
		if useCalcStat then
			sCS_ClassName = CalcStat("ClassName",PlayerClassIdIs)
		end

		if ExpPTS then
			-- experience data from chat
			local sExpPTS = strgsub(ExpPTS,"%p+","")
			aPlayerData[PD.XP_CURRENT] = tonumber(sExpPTS)
		end

		-- Vital/Main
		aPlayerData[PD.ICMR] = PlayerAttrib:GetInCombatMoraleRegeneration()
		aPlayerData[PD.NCMR] = PlayerAttrib:GetOutOfCombatMoraleRegeneration()
		aPlayerData[PD.ICPR] = PlayerAttrib:GetInCombatPowerRegeneration()
		aPlayerData[PD.NCPR] = PlayerAttrib:GetOutOfCombatPowerRegeneration()
		if useCalcStat then
			aPlayerData[PD.BASEMORALE] = CalcStat(sCS_ClassName.."CDBaseMorale",aPlayerData[PD.LEVEL])
			aPlayerData[PD.BASEICMR] = CalcStat(sCS_ClassName.."CDBaseICMR",aPlayerData[PD.LEVEL])
			aPlayerData[PD.BASENCMR] = CalcStat(sCS_ClassName.."CDBaseNCMR",aPlayerData[PD.LEVEL])
			aPlayerData[PD.BASEPOWER] = CalcStat(sCS_ClassName.."CDBasePower",aPlayerData[PD.LEVEL])
			aPlayerData[PD.BASEICPR] = CalcStat(sCS_ClassName.."CDBaseICPR",aPlayerData[PD.LEVEL])
			aPlayerData[PD.BASENCPR] = CalcStat(sCS_ClassName.."CDBaseNCPR",aPlayerData[PD.LEVEL])
		end
		aPlayerData[PD.MIGHT] = PlayerAttrib:GetMight()
		aPlayerData[PD.AGILITY] = PlayerAttrib:GetAgility()
		aPlayerData[PD.VITALITY] = PlayerAttrib:GetVitality()
		aPlayerData[PD.WILL] = PlayerAttrib:GetWill()
		aPlayerData[PD.FATE] = PlayerAttrib:GetFate()
		aPlayerData[PD.BASEMIGHT] = PlayerAttrib:GetBaseMight()
		aPlayerData[PD.BASEAGILITY] = PlayerAttrib:GetBaseAgility()
		aPlayerData[PD.BASEVITALITY] = PlayerAttrib:GetBaseVitality()
		aPlayerData[PD.BASEWILL] = PlayerAttrib:GetBaseWill()
		aPlayerData[PD.BASEFATE] = PlayerAttrib:GetBaseFate()
		-- Offence
		aPlayerData[PD.CRITHIT] = PlayerAttrib:GetBaseCriticalHitChance()
		aPlayerData[PD.FINESSE] = PlayerAttrib:GetFinesse()
		aPlayerData[PD.MELPHYMAS] = PlayerAttrib:GetMeleeDamage()
		aPlayerData[PD.RNGPHYMAS] = PlayerAttrib:GetRangeDamage()
		aPlayerData[PD.TACMAS] = PlayerAttrib:GetTacticalDamage()
		aPlayerData[PD.OUTHEAL] = PlayerAttrib:GetOutgoingHealing()
		-- Defence
		aPlayerData[PD.RESIST] = PlayerAttrib:GetBaseResistance()
		aPlayerData[PD.CRITDEF] = PlayerAttrib:GetBaseCriticalHitAvoidance()
		aPlayerData[PD.INHEAL] = PlayerAttrib:GetIncomingHealing()
		-- Avoidance
		aPlayerData[PD.CANBLOCK] = PlayerAttrib:CanBlock()
		aPlayerData[PD.CANPARRY] = PlayerAttrib:CanParry()
		aPlayerData[PD.CANEVADE] = PlayerAttrib:CanEvade()
		aPlayerData[PD.BLOCK] = PlayerAttrib:GetBlock()
		aPlayerData[PD.PARRY] = PlayerAttrib:GetParry()
		aPlayerData[PD.EVADE] = PlayerAttrib:GetEvade()
		-- Mitigations
		aPlayerData[PD.COMPHYMIT] = PlayerAttrib:GetCommonMitigation()
		aPlayerData[PD.NONPHYMIT] = PlayerAttrib:GetPhysicalMitigation()
		aPlayerData[PD.TACMIT] = PlayerAttrib:GetTacticalMitigation()
		aPlayerData[PD.FIREMIT] = PlayerAttrib:GetFireMitigation()
		aPlayerData[PD.LIGHTNINGMIT] = PlayerAttrib:GetLightningMitigation()
		aPlayerData[PD.FROSTMIT] = PlayerAttrib:GetFrostMitigation()
		aPlayerData[PD.ACIDMIT] = PlayerAttrib:GetAcidMitigation()
		aPlayerData[PD.SHADOWMIT] = PlayerAttrib:GetShadowMitigation()
		if useCalcStat then
			aPlayerData[PD.CALCTYPE_COMPHYMIT] = aCalcTypeMit[CalcStat(sCS_ClassName.."CDCalcTypeComPhyMit",aPlayerData[PD.LEVEL])]
			aPlayerData[PD.CALCTYPE_NONPHYMIT] = aCalcTypeMit[CalcStat(sCS_ClassName.."CDCalcTypeNonPhyMit",aPlayerData[PD.LEVEL])]
			aPlayerData[PD.CALCTYPE_TACMIT] = aCalcTypeMit[CalcStat(sCS_ClassName.."CDCalcTypeTacMit",aPlayerData[PD.LEVEL])]
			aPlayerData[PD.PENARMOUR] = {CalcStat("TPenArmour",aPlayerData[PD.LEVEL],1),CalcStat("TPenArmour",aPlayerData[PD.LEVEL],2),CalcStat("TPenArmour",aPlayerData[PD.LEVEL],3),CalcStat("T2PenArmour",aPlayerData[PD.LEVEL])}
			aPlayerData[PD.PENBPE] = {CalcStat("TPenBPE",aPlayerData[PD.LEVEL],1),CalcStat("TPenBPE",aPlayerData[PD.LEVEL],2),CalcStat("TPenBPE",aPlayerData[PD.LEVEL],3),CalcStat("T2PenBPE",aPlayerData[PD.LEVEL])}
			aPlayerData[PD.PENRESIST] = {CalcStat("TPenResist",aPlayerData[PD.LEVEL],1),CalcStat("TPenResist",aPlayerData[PD.LEVEL],2),CalcStat("TPenResist",aPlayerData[PD.LEVEL],3),CalcStat("T2PenResist",aPlayerData[PD.LEVEL])}
		end
	end
	
	return aPlayerData
end

-- various content display functions

local CI = {}

CI.TI_TEXT
	= 1

-- displays a generic text
local function SetTextStatValue(oControl,aPlayerData,aContentInfo)
	local nPDId = aContentInfo[CI.TI_TEXT]
	local sText = type(nPDId) == "number" and aPlayerData[nPDId] or nil

	local sContentText = ""
	
	if not (type(sText) == "string") then
		sContentText = L[ "PINOTAVAIL" ]
	else
		sContentText = sText
	end

	oControl:SetText(sContentText)
end

CI.NI_NUMBER
	= 1

-- displays a generic number
local function SetNumberStatValue(oControl,aPlayerData,aContentInfo)
	local nPDId = aContentInfo[CI.NI_NUMBER]
	local nNumber = type(nPDId) == "number" and aPlayerData[nPDId] or nil

	local sContentText = ""
	
	if not (type(nNumber) == "number") then
		sContentText = L[ "PINOTAVAIL" ]
	else
		sContentText = stringformatvalue("%'.0f",correctvalue(nNumber))
	end

	oControl:SetText(sContentText)
end

-- displays LvlXP information
-- needs CalcStat
local function SetLvlXPStatValue(oControl,aPlayerData,aContentInfo)
	if not aPlayerData[PD.XP_CURRENT] then oControl:SetText(L[ "PINOTAVAIL" ]) return end
	if not useCalcStat then oControl:SetText(NO_CALCSTAT_CONTENT) return end
	local nLevelCap = CalcStat("LevelCap")
	if aPlayerData[PD.LEVEL] == nLevelCap then oControl:SetText(L[ "PILVLXPCAP" ]) return end

	local nLvlExpCostTot = CalcStat("LvlExpCostTot",aPlayerData[PD.LEVEL])
	local nLvlExpCurr = aPlayerData[PD.XP_CURRENT]-nLvlExpCostTot
	local nLvlExpNext = CalcStat("LvlExpCost",aPlayerData[PD.LEVEL]+1)
	if nLvlExpCurr < 0 or nLvlExpCurr > nLvlExpNext then oControl:SetText(L[ "PINOTAVAIL" ]) return end
	local nLvlExpPerc = (nLvlExpCurr/nLvlExpNext)*100

	oControl:SetText(stringformatvalue("%'d",nLvlExpNext-nLvlExpCurr).."/"..stringformatvalue("%.1f%%",correctvalue(nLvlExpPerc)))
end

-- displays next reforge character level and item level
-- needs CalcStat
local function SetLiReforgeStatValue(oControl,aPlayerData,aContentInfo)
	if not useCalcStat then oControl:SetText(NO_CALCSTAT_CONTENT) return end
	local nLevelCap = CalcStat("LevelCap")
	local nLi2ILvlCap = CalcStat("Li2ILvlCap")
	local nPrevLi2ReforgeILvl = CalcStat("Li2ReforgeILvl",aPlayerData[PD.LEVEL]-1,nLi2ILvlCap)
	local nTestLi2ReforgeILvl
	
	for nLevel = aPlayerData[PD.LEVEL], nLevelCap do
		nTestLi2ReforgeILvl = CalcStat("Li2ReforgeILvl",nLevel,nLi2ILvlCap)
		if nTestLi2ReforgeILvl > nPrevLi2ReforgeILvl then
			oControl:SetText(strgsub(strgsub(L[ "PILIREFFMT" ],"#iLvl",nTestLi2ReforgeILvl),"#cLvl",nLevel))
			return
		end
	end
	
	oControl:SetText(L[ "PINOTAVAIL" ])
end

CI.BTI_VALUE
	= 1

-- displays base & total values
-- needs CalcStat for some values
local function SetBaseTotalStatValue(oControl,aPlayerData,aContentInfo)
	local nPDId = aContentInfo[CI.BTI_VALUE]
	local nValue = type(nPDId) == "number" and aPlayerData[nPDId] or nil

	local sContentText = ""
	
	if (PD.BASEMORALE <= nPDId and nPDId <= PD.BASEPOWER) or (PD.BASEICMR <= nPDId and nPDId <= PD.BASENCPR) then
		-- CalcStat content
		if not useCalcStat then
			sContentText = NO_CALCSTAT_CONTENT
		elseif PD.BASEICMR <= nPDId and nPDId <= PD.BASENCPR then
			sContentText = stringformatvalue("%'.1f",correctvalue(nValue))
		else
			sContentText = stringformatvalue("%'.0f",correctvalue(nValue))
		end
	else
		-- non CalcStat content
		if not (type(nValue) == "number") then
			sContentText = L[ "PINOTAVAIL" ]
		elseif PD.ICMR <= nPDId and nPDId <= PD.NCPR then
			sContentText = stringformatvalue("%'.1f",correctvalue(nValue))
		else
			sContentText = stringformatvalue("%'.0f",correctvalue(nValue))
		end
	end
	
	oControl:SetText(sContentText)
end

local CAPCOLOR = {}
	CAPCOLOR.STANDARD = Color["yellow"]
	CAPCOLOR.T1 = Color["yellow"] -- Turbine.UI.Color(1,0.9,0) -- T1 only exists in The Hoard for mitigations
	CAPCOLOR.T2 = Color["orange"]
	CAPCOLOR.T3 = Color["red"]
	CAPCOLOR.ENHIII = Color["purple"]

-- calculates reached caps and returns approp. color
-- needs CalcStat for caps
local function GetRatCapColor(sCSRatName,nRating,aCSPenRats)
	if useCalcStat and type(sCSRatName) == "string" and type(nRating) == "number" then
		nPRatPCapR = CalcStat(sCSRatName.."PRatPCapR",aPlayerData[PD.LEVEL])
		if aCSPenRats then
			if nRating >= nPRatPCapR-aCSPenRats[4] then
				return CAPCOLOR.ENHIII
			elseif nRating >= nPRatPCapR-aCSPenRats[3] then
				return CAPCOLOR.T3
			elseif nRating >= nPRatPCapR-aCSPenRats[2] then
				return CAPCOLOR.T2
			elseif nRating >= nPRatPCapR-aCSPenRats[1] then
				return CAPCOLOR.T1
			end
		end
		if nRating >= nPRatPCapR then
			return CAPCOLOR.STANDARD
		end
	end
	return Color["white"]
end

CI.RI_RATING,
CI.RI_CSRATNAME,
CI.RI_CSPENRATS,
CI.RI_AVAILABLE,
CI.RI_SELECT
	= 1,2,3,4,5

local RISEL = {}
	RISEL.CURRAT,
	RISEL.CURPERC,
	RISEL.CAPRAT,
	RISEL.CAPPERC
	= 1,2,3,4

-- displays ratings & percentages in colors which depend on reached cap
-- needs CalcStat for percentages and cap ratings
local function SetRatingStatValue(oControl,aPlayerData,aContentInfo)
	local nRating = type(aContentInfo[CI.RI_RATING]) == "number" and aPlayerData[aContentInfo[CI.RI_RATING]] or nil
	local sCSRatName = type(aContentInfo[CI.RI_CSRATNAME]) == "string" and aContentInfo[CI.RI_CSRATNAME] or aPlayerData[aContentInfo[CI.RI_CSRATNAME]]
	local aCSPenRats = type(aContentInfo[CI.RI_CSPENRATS]) == "number" and aPlayerData[aContentInfo[CI.RI_CSPENRATS]] or nil
	local bAvailable = type(aContentInfo[CI.RI_AVAILABLE]) == "number" and aPlayerData[aContentInfo[CI.RI_AVAILABLE]] or not aContentInfo[CI.RI_AVAILABLE]

	local sContentText = ""
	local oContentColor = Color["white"]
	
	if aContentInfo[CI.RI_SELECT] == RISEL.CURRAT then
		-- non CalcStat content (except for cap color)
		if not (bAvailable and type(nRating) == "number") then
			sContentText = L[ "PINOTAVAIL" ]
		else
			sContentText = stringformatvalue("%'.0f",correctvalue(nRating))
			oContentColor = GetRatCapColor(sCSRatName,nRating,aCSPenRats)
		end
	else
		-- CalcStat content
		if not (bAvailable and type(nRating) == "number") then
			sContentText = L[ "PINOTAVAIL" ]
		elseif not useCalcStat then
			sContentText = NO_CALCSTAT_CONTENT
		elseif not (type(sCSRatName) == "string") then
			-- likely unknown mitigation calculation type
			sContentText = L[ "PINOTAVAIL" ]
		elseif aContentInfo[CI.RI_SELECT] == RISEL.CURPERC then
			sContentText = stringformatvalue("%.1f%%",correctvalue(CalcStat(sCSRatName.."PRatP",aPlayerData[PD.LEVEL],nRating)+CalcStat(sCSRatName.."PBonus",aPlayerData[PD.LEVEL])))
			oContentColor = GetRatCapColor(sCSRatName,nRating,aCSPenRats)
		elseif aContentInfo[CI.RI_SELECT] == RISEL.CAPRAT then
			sContentText = stringformatvalue("%'.0f",correctvalue(CalcStat(sCSRatName.."PRatPCapR",aPlayerData[PD.LEVEL])))
			oContentColor = GetRatCapColor(sCSRatName,nRating,aCSPenRats)
		elseif aContentInfo[CI.RI_SELECT] == RISEL.CAPPERC then
			sContentText = stringformatvalue("%.1f%%",correctvalue(CalcStat(sCSRatName.."PRatPCap",aPlayerData[PD.LEVEL])+CalcStat(sCSRatName.."PBonus",aPlayerData[PD.LEVEL])))
			oContentColor = GetRatCapColor(sCSRatName,nRating,aCSPenRats)
		end
	end
	
	oControl:SetText(sContentText)
	oControl:SetForeColor(oContentColor)
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

-- possible types of row formats, each expecting different row defs (parameters/settings)
local ROWFORMAT = {}
	ROWFORMAT.CHAR_HEADER, 
	ROWFORMAT.CHAR_STAT,
	ROWFORMAT.CHAR_LVLXP_STAT,
	ROWFORMAT.CHAR_LIREFORGE_STAT,
	ROWFORMAT.EMPTY,
	ROWFORMAT.BASETOTAL_HEADER,
	ROWFORMAT.BASETOTAL_STAT,
	ROWFORMAT.RATPERC_HEADER,
	ROWFORMAT.RATPERC_STAT,
	ROWFORMAT.COLORCENTER_TEXT
	= 1,2,3,4,5,6,7,8,9,10

local ROWDEF = {}
	-- all except EMPTY
	ROWDEF.ROWFORMAT,
	ROWDEF.LABELTEXT,
	ROWDEF.SUBINDENT
	= 1,2,3
	-- CHAR types
	ROWDEF.STAT_CONTENTFN,
	ROWDEF.STAT_CONTENT
	= 4,5
	-- BASETOTAL_STAT
	ROWDEF.STAT_BASE,
	ROWDEF.STAT_TOTAL
	= 4,5
	-- RATPERC_STAT
	ROWDEF.STAT_RATING,
	ROWDEF.STAT_CSRATNAME,
	ROWDEF.STAT_CSPENRATS,
	ROWDEF.STAT_AVAILABLE
	= 4,5,6,7
	-- COLORCENTER_TEXT
	ROWDEF.TEXT_COLOR
	= 4

-- layout text style data
local ST = {}
	ST.ALIGN, -- text alignment
	ST.FONT, -- text font
	ST.YOFF, -- offset from the top of row, for lining out texts with different font heights
	ST.HEIGHT, -- height of the text label, depending on font height
	ST.FGCOL, -- foreground/text color
	ST.BKCOL -- background color, used to create separator lines
	= 1,2,3,4,5,6

local StMainHdr =	{Turbine.UI.ContentAlignment.BottomLeft,	Turbine.UI.Lotro.Font.TrajanPro16,	0,	16,	Color["white"],		nil}
local StStatLbl =	{Turbine.UI.ContentAlignment.BottomLeft,	Turbine.UI.Lotro.Font.TrajanPro14,	2,	14,	Color["nicegold"],	nil}
local StColHdr =	{Turbine.UI.ContentAlignment.BottomRight,	Turbine.UI.Lotro.Font.Verdana13,	3,	13,	Color["white"],		nil}
local StStatVal =	{Turbine.UI.ContentAlignment.BottomRight,	Turbine.UI.Lotro.Font.Verdana12,	3,	12,	Color["white"],		nil}
local StClrText =	{Turbine.UI.ContentAlignment.BottomCenter,	Turbine.UI.Lotro.Font.Verdana14,	1,	14,	nil,				nil}
local StSep =		{nil,										nil,								15,	1,	nil,				Color["trueblue"]}

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
	
	-- create control defs out of row defs

	local aControlDefs = aLayoutDef.ControlDefs

	for _,aRowDef in ipairs(aTableDef.RowDefs) do
		nIndent = aRowDef[ROWDEF.SUBINDENT] and nSubIndent or nBaseIndent
		nIndentedX = nTableStartX+nIndent
		if aRowDef[ROWDEF.ROWFORMAT] == ROWFORMAT.CHAR_HEADER then
			-- main header label
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.Width,						StMainHdr,	aRowDef[ROWDEF.LABELTEXT]})
			-- separator
			tableinsert(aControlDefs,{nTableStartX-1,	nRowY,aTableDef.Width+2,					StSep})
		elseif aRowDef[ROWDEF.ROWFORMAT] == ROWFORMAT.CHAR_STAT then
			-- stat label
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.Width-nIndent,				StStatLbl,	aRowDef[ROWDEF.LABELTEXT]})
			-- stat value
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.Width-nIndent,				StStatVal,	aRowDef[ROWDEF.STAT_CONTENT],	aRowDef[ROWDEF.STAT_CONTENTFN]})
		elseif aRowDef[ROWDEF.ROWFORMAT] == ROWFORMAT.EMPTY then
			-- nothing
		elseif aRowDef[ROWDEF.ROWFORMAT] == ROWFORMAT.BASETOTAL_HEADER then
			-- main header label
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.Width,						StMainHdr,	aRowDef[ROWDEF.LABELTEXT]})
			-- column header label base
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.CellWidthBase,				StColHdr,	L[ "PIBASE" ]})
			-- column header label total
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.CellWidthTotal,				StColHdr,	L[ "PITOTAL" ]})
			-- separator
			tableinsert(aControlDefs,{nTableStartX-1,	nRowY,aTableDef.Width+2,					StSep})
		elseif aRowDef[ROWDEF.ROWFORMAT] == ROWFORMAT.BASETOTAL_STAT then
			-- stat label
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.Width-nIndent,				StStatLbl,	aRowDef[ROWDEF.LABELTEXT]})
			-- stat value base
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.CellWidthBase-nIndent,		StStatVal,	{aRowDef[ROWDEF.STAT_BASE]},	SetBaseTotalStatValue})
			-- stat value total
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.CellWidthTotal-nIndent,		StStatVal,	{aRowDef[ROWDEF.STAT_TOTAL]},	SetBaseTotalStatValue})
		elseif aRowDef[ROWDEF.ROWFORMAT] == ROWFORMAT.RATPERC_HEADER then
			-- main header label
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.Width,						StMainHdr,	aRowDef[ROWDEF.LABELTEXT]})
			-- column header label current rating
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.CellWidthCurrRat,			StColHdr,	L[ "PICURRAT" ]})
			-- column header label current percentage
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.CellWidthCurrPerc,			StColHdr,	L[ "PICURPERC" ]})
			-- column header label cap rating
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.CellWidthCapRat,			StColHdr,	L[ "PICAPRAT" ]})
			-- column header label cap percentage
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.CellWidthCapPerc,			StColHdr,	L[ "PICAPPERC" ]})
			-- separator
			tableinsert(aControlDefs,{nTableStartX-1,	nRowY,aTableDef.Width+2,					StSep})
		elseif aRowDef[ROWDEF.ROWFORMAT] == ROWFORMAT.RATPERC_STAT then
			-- stat label
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.Width-nIndent,				StStatLbl,	aRowDef[ROWDEF.LABELTEXT]})
			-- stat value current rating
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.CellWidthCurrRat-nIndent,	StStatVal,	{aRowDef[ROWDEF.STAT_RATING],aRowDef[ROWDEF.STAT_CSRATNAME],aRowDef[ROWDEF.STAT_CSPENRATS],aRowDef[ROWDEF.STAT_AVAILABLE],RISEL.CURRAT},	SetRatingStatValue})
			-- stat value current percentage
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.CellWidthCurrPerc-nIndent,	StStatVal,	{aRowDef[ROWDEF.STAT_RATING],aRowDef[ROWDEF.STAT_CSRATNAME],aRowDef[ROWDEF.STAT_CSPENRATS],aRowDef[ROWDEF.STAT_AVAILABLE],RISEL.CURPERC},	SetRatingStatValue})
			-- stat value cap rating
			tableinsert(aControlDefs,{nIndentedX,		nRowY,aTableDef.CellWidthCapRat-nIndent,	StStatVal,	{aRowDef[ROWDEF.STAT_RATING],aRowDef[ROWDEF.STAT_CSRATNAME],aRowDef[ROWDEF.STAT_CSPENRATS],aRowDef[ROWDEF.STAT_AVAILABLE],RISEL.CAPRAT},	SetRatingStatValue})
			-- stat value cap percentage
			tableinsert(aControlDefs,{nIndentedX,nRowY,aTableDef.CellWidthCapPerc-nIndent,			StStatVal,	{aRowDef[ROWDEF.STAT_RATING],aRowDef[ROWDEF.STAT_CSRATNAME],aRowDef[ROWDEF.STAT_CSPENRATS],aRowDef[ROWDEF.STAT_AVAILABLE],RISEL.CAPPERC},	SetRatingStatValue})
		elseif aRowDef[ROWDEF.ROWFORMAT] == ROWFORMAT.COLORCENTER_TEXT then
			-- centered text with color
			tableinsert(aControlDefs,{nTableStartX,		nRowY,aTableDef.Width,						StClrText,	aRowDef[ROWDEF.LABELTEXT],		aRowDef[ROWDEF.TEXT_COLOR]})
		end
		nRowY = nRowY+nRowHeight
	end
	
	aLayoutDef.Height = mathmax(aLayoutDef.Height,nRowY+nMarginBottom)
	aLayoutDef.Width = nTableStartX+aTableDef.Width+nMarginRight
end

-- layout for freeps have all available stats
local function GetFreepLayoutDefinition()
	local aLayoutDef = NewLayoutDefinition()

	-- table on the left, with general character stats, vitals stats and main stats
	AddTableDefinition(aLayoutDef,{
		Width = 230,
		CellWidthBase = 165,
		CellWidthTotal = 230,
		RowDefs = {
			{ROWFORMAT.CHAR_HEADER,L[ "PICHAR" ]},
			{ROWFORMAT.CHAR_STAT,L[ "PIRACE" ],			false,	SetTextStatValue,		{PD.RACE}},
			{ROWFORMAT.CHAR_STAT,L[ "PICLASS" ],		false,	SetTextStatValue,		{PD.CLASS}},
			{ROWFORMAT.CHAR_STAT,L[ "PILEVEL" ],		false,	SetNumberStatValue,		{PD.LEVEL}},
			{ROWFORMAT.CHAR_STAT,L[ "PILVLXP" ],		true,	SetLvlXPStatValue,		{nil}},
			{ROWFORMAT.CHAR_STAT,L[ "PILIREF" ],		true,	SetLiReforgeStatValue,	{nil}},
			{ROWFORMAT.EMPTY},
			{ROWFORMAT.BASETOTAL_HEADER,L[ "PIVITALS" ]},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIMORALE" ],	false,	PD.BASEMORALE,	PD.MAXMORALE},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIICMR" ],	true,	PD.BASEICMR,	PD.ICMR},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PINCMR" ],	true,	PD.BASENCMR,	PD.NCMR},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIPOWER" ],	false,	PD.BASEPOWER,	PD.MAXPOWER},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIICPR" ],	true,	PD.BASEICPR,	PD.ICPR},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PINCPR" ],	true,	PD.BASENCPR,	PD.NCPR},
			{ROWFORMAT.EMPTY},
			{ROWFORMAT.BASETOTAL_HEADER,L[ "PIMAIN" ]},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIMIGHT" ],	false,	PD.BASEMIGHT,	PD.MIGHT},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIAGILITY" ],	false,	PD.BASEAGILITY,	PD.AGILITY},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIVITALITY" ],false,	PD.BASEVITALITY,PD.VITALITY},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIWILL" ],	false,	PD.BASEWILL,	PD.WILL},
			{ROWFORMAT.BASETOTAL_STAT,L[ "PIFATE" ],	false,	PD.BASEFATE,	PD.FATE}
		}
	})

	-- table in the center, with percentage ratings and some colored notes at the bottom
	AddTableDefinition(aLayoutDef,{
		Width = 340,
		CellWidthCurrRat = 170,
		CellWidthCurrPerc = 220,
		CellWidthCapRat = 290,
		CellWidthCapPerc = 340,
		RowDefs = {
			{ROWFORMAT.RATPERC_HEADER,L[ "PIOFFENCE" ]},
			{ROWFORMAT.RATPERC_STAT,L[ "PIMELDMG" ],	false,	PD.MELPHYMAS,	"PhyDmg"},
			{ROWFORMAT.RATPERC_STAT,L[ "PIRNGDMG" ],	false,	PD.RNGPHYMAS,	"PhyDmg"},
			{ROWFORMAT.RATPERC_STAT,L[ "PITACDMG" ],	false,	PD.TACMAS,		"TacDmg"},
			{ROWFORMAT.RATPERC_STAT,L[ "PICRITHIT" ],	false,	PD.CRITHIT,		"CritHit"},
			{ROWFORMAT.RATPERC_STAT,L[ "PIDEVHIT" ],	false,	PD.CRITHIT,		"DevHit"},
			{ROWFORMAT.RATPERC_STAT,L[ "PICRITMAGN" ],	false,	PD.CRITHIT,		"CritMagn"},
			{ROWFORMAT.RATPERC_STAT,L[ "PIFINESSE" ],	false,	PD.FINESSE,		"Finesse"},
			{ROWFORMAT.EMPTY},
			{ROWFORMAT.RATPERC_HEADER,L[ "PIHEALING" ]},
			{ROWFORMAT.RATPERC_STAT,L[ "PIOUTHEAL" ],	false,	PD.OUTHEAL,		"OutHeal"},
			{ROWFORMAT.RATPERC_STAT,L[ "PIINHEAL" ],	false,	PD.INHEAL,		"InHeal"},
			{ROWFORMAT.EMPTY},
			{ROWFORMAT.RATPERC_HEADER,L[ "PIDEFENCE" ]},
			{ROWFORMAT.RATPERC_STAT,L[ "PICRITDEF" ],	false,	PD.CRITDEF,		"CritDef"},
			{ROWFORMAT.RATPERC_STAT,L[ "PIRESIST" ],	false,	PD.RESIST,		"Resist",				PD.PENRESIST}, -- with resistance penetration
			{ROWFORMAT.EMPTY},
			useCalcStat and {ROWFORMAT.COLORCENTER_TEXT,L[ "PICAPPED1" ],false,CAPCOLOR.STANDARD} or {ROWFORMAT.EMPTY},
			useCalcStat and {ROWFORMAT.COLORCENTER_TEXT,L[ "PICAPPED2" ],false,CAPCOLOR.T2}       or {ROWFORMAT.COLORCENTER_TEXT,L[ "PICSDEP" ],false,CAPCOLOR.STANDARD},
			useCalcStat and {ROWFORMAT.COLORCENTER_TEXT,L[ "PICAPPED3" ],false,CAPCOLOR.T3}       or {ROWFORMAT.EMPTY},
			useCalcStat and {ROWFORMAT.COLORCENTER_TEXT,L[ "PICAPPED4" ],false,CAPCOLOR.ENHIII}   or {ROWFORMAT.EMPTY}
		}
	})

	-- table on the right, with avoidances and mitigations
	AddTableDefinition(aLayoutDef,{
		Width = 340,
		CellWidthCurrRat = 170,
		CellWidthCurrPerc = 220,
		CellWidthCapRat = 290,
		CellWidthCapPerc = 340,
		RowDefs = {
			{ROWFORMAT.RATPERC_HEADER,L[ "PIAVOID" ]},
			{ROWFORMAT.RATPERC_STAT,L[ "PIBLOCK" ],		false,	PD.BLOCK,		"Block",				PD.PENBPE,	PD.CANBLOCK}, -- with avoidance penetration
			{ROWFORMAT.RATPERC_STAT,L[ "PIBLOCKPART" ],	true,	PD.BLOCK,		"PartBlock",			PD.PENBPE,	PD.CANBLOCK},
			{ROWFORMAT.RATPERC_STAT,L[ "PIBLOCKPMIT" ],	true,	PD.BLOCK,		"PartBlockMit",			PD.PENBPE,	PD.CANBLOCK},
			{ROWFORMAT.RATPERC_STAT,L[ "PIPARRY" ],		false,	PD.PARRY,		"Parry",				PD.PENBPE,	PD.CANPARRY},
			{ROWFORMAT.RATPERC_STAT,L[ "PIPARRYPART" ],	true,	PD.PARRY,		"PartParry",			PD.PENBPE,	PD.CANPARRY},
			{ROWFORMAT.RATPERC_STAT,L[ "PIPARRYPMIT" ],	true,	PD.PARRY,		"PartParryMit",			PD.PENBPE,	PD.CANPARRY},
			{ROWFORMAT.RATPERC_STAT,L[ "PIEVADE" ],		false,	PD.EVADE,		"Evade",				PD.PENBPE,	PD.CANEVADE},
			{ROWFORMAT.RATPERC_STAT,L[ "PIEVADEPART" ],	true,	PD.EVADE,		"PartEvade",			PD.PENBPE,	PD.CANEVADE},
			{ROWFORMAT.RATPERC_STAT,L[ "PIEVADEPMIT" ],	true,	PD.EVADE,		"PartEvadeMit",			PD.PENBPE,	PD.CANEVADE},
			{ROWFORMAT.EMPTY},
			{ROWFORMAT.RATPERC_HEADER,L[ "PIMITS" ]},
			{ROWFORMAT.RATPERC_STAT,L[ "PIPHYMIT" ],	false,	PD.COMPHYMIT,	PD.CALCTYPE_COMPHYMIT,	PD.PENARMOUR}, -- with armour(mitigations) penetration
			{ROWFORMAT.RATPERC_STAT,L[ "PIORCMIT" ],	true,	PD.NONPHYMIT,	PD.CALCTYPE_NONPHYMIT,	PD.PENARMOUR},
			{ROWFORMAT.RATPERC_STAT,L[ "PIFWMIT" ],		true,	PD.NONPHYMIT,	PD.CALCTYPE_NONPHYMIT,	PD.PENARMOUR},
			{ROWFORMAT.RATPERC_STAT,L[ "PITACMIT" ],	false,	PD.TACMIT,		PD.CALCTYPE_TACMIT,		PD.PENARMOUR},
			{ROWFORMAT.RATPERC_STAT,L[ "PIFIREMIT" ],	true,	PD.FIREMIT,		PD.CALCTYPE_TACMIT,		PD.PENARMOUR},
			{ROWFORMAT.RATPERC_STAT,L[ "PILIGHTNMIT" ],	true,	PD.LIGHTNINGMIT,PD.CALCTYPE_TACMIT,		PD.PENARMOUR},
			{ROWFORMAT.RATPERC_STAT,L[ "PIFROSTMIT" ],	true,	PD.FROSTMIT,	PD.CALCTYPE_TACMIT,		PD.PENARMOUR},
			{ROWFORMAT.RATPERC_STAT,L[ "PIACIDMIT" ],	true,	PD.ACIDMIT,		PD.CALCTYPE_TACMIT,		PD.PENARMOUR},
			{ROWFORMAT.RATPERC_STAT,L[ "PISHADMIT" ],	true,	PD.SHADOWMIT,	PD.CALCTYPE_TACMIT,		PD.PENARMOUR}
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
			{ROWFORMAT.CHAR_HEADER,L[ "PICHAR" ]},
			{ROWFORMAT.CHAR_STAT,L[ "PIRACE" ],		false,SetTextStatValue,		{PD.RACE}},
			{ROWFORMAT.CHAR_STAT,L[ "PICLASS" ],	false,SetTextStatValue,		{PD.CLASS}},
			{ROWFORMAT.CHAR_STAT,L[ "PILEVEL" ],	false,SetNumberStatValue,	{PD.LEVEL}},
			{ROWFORMAT.EMPTY},
			{ROWFORMAT.CHAR_HEADER,L[ "PIVITALS" ]},
			{ROWFORMAT.CHAR_STAT,L[ "PIMORALE" ],	false,SetNumberStatValue,	{PD.MAXMORALE}},
			{ROWFORMAT.CHAR_STAT,L[ "PIPOWER" ],	false,SetNumberStatValue,	{PD.MAXPOWER}}
		}
	})

	return aLayoutDef
end

-- Control functions

local CTRDEF = {}
	CTRDEF.X,
	CTRDEF.Y,
	CTRDEF.WIDTH,
	CTRDEF.STYLE
	= 1,2,3,4
	CTRDEF.CONTENT,
	CTRDEF.CONTENTFN
	= 5,6
	CTRDEF.TEXT,
	CTRDEF.TXTCOLOR
	= 5,6

-- create controls out of the layout's control defs
local function CreateControls(oParent,aLayoutDef)
	local aContentControls = {}
	local aStyle
	local oControl
	for _,aControlDef in ipairs(aLayoutDef.ControlDefs) do
		aStyle = aControlDef[CTRDEF.STYLE]
		oControl = Turbine.UI.Label()
		oControl:SetParent(oParent)
		oControl:SetSize(aControlDef[CTRDEF.WIDTH],aStyle[ST.HEIGHT])
		oControl:SetPosition(aControlDef[CTRDEF.X],aControlDef[CTRDEF.Y]+aStyle[ST.YOFF])
		if aStyle[ST.ALIGN]	then oControl:SetTextAlignment(aStyle[ST.ALIGN]) end
		if aStyle[ST.FONT]	then oControl:SetFont(aStyle[ST.FONT]) end
		if aStyle[ST.FGCOL]	then oControl:SetForeColor(aStyle[ST.FGCOL]) end
		if aStyle[ST.BKCOL]	then oControl:SetBackColor(aStyle[ST.BKCOL]) end
		if type(aControlDef[CTRDEF.CONTENT]) == "table" then
			-- dynamic content creation by function
			tableinsert(aContentControls,{oControl,aControlDef[CTRDEF.CONTENT],aControlDef[CTRDEF.CONTENTFN]})
		elseif type(aControlDef[CTRDEF.TEXT]) == "string" then
			-- static text label with optional color
			oControl:SetText(aControlDef[CTRDEF.TEXT])
			if aControlDef[CTRDEF.TXTCOLOR] then oControl:SetForeColor(aControlDef[CTRDEF.TXTCOLOR]) end
		end
	end
	return aContentControls
end

local CONTCTR = {}
	CONTCTR.OBJ,
	CONTCTR.CONTENT,
	CONTCTR.CONTENTFN
	= 1,2,3

-- update dynamic controls with player data by using the control's content functions
local function UpdateDynamicContent(aContentControls,aPlayerData)
	for _,aContentControl in ipairs(aContentControls) do
		aContentControl[CONTCTR.CONTENTFN](aContentControl[CONTCTR.OBJ],aPlayerData,aContentControl[CONTCTR.CONTENT])
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
	local APICtr = Turbine.UI.Control()
	APICtr:SetParent(_G.ToolTipWin)
	APICtr:SetZOrder(1)
	APICtr:SetPosition(20,19)
	APICtr:SetSize(w,h)
	APICtr:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
	--APICtr:SetBackColor(Color["trueblue"]) -- test size
	--APICtr:SetBackground("HabnaPlugins/TitanBar/Resources/".."PIbk.tga")
	--**^

	-- creates all needed controls defined in the layout and returns a list with controls with 'dynamic' content: these need to be updated with data
	local aContentControls = CreateControls(APICtr,aLayoutDef)

	-- in theory you only need to create layout+controls once and update player.data+dyn.controls every time the window is shown,
	-- but it might be bad for resource usage.

	-- get all player data from client which are needed for display generation
	local aPlayerData = GetPlayerData()

	-- update all dynamic content with player information
	UpdateDynamicContent(aContentControls,aPlayerData)

	ApplySkin()
end
