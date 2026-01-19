-- DayNight.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function GetInGameTime()
	local nowtime = Turbine.Engine.GetLocalTime();
	local gametime = Turbine.Engine.GetGameTime();
	local ts = (_G.ControlData and _G.ControlData.DN and tonumber(_G.ControlData.DN.ts)) or 0
	local InitDawn =  nowtime - gametime + ts;
	local adjust = (nowtime - (nowtime - gametime + ts)) % Constants.GAME_TIME_CYCLE;
  local darray = {572, 1722, 1067, 1678, 1101, 570, 1679, 539, 1141, 1091};
	local dtarray = {
        L["Dawn"], L["Morning"], L["Noon"], L["Afternoon"], L["Dusk"], 
        L["Gloaming"], L["Evening"], L["Midnight"], L["LateWatches"],
        L["Foredawn"], L["Dawn"]}; 
    if (adjust <= 6140) then sDay = "day" else sDay = "night" end;
    local dapos = 1;
    if (adjust <= 572) then dapos = 1;
	elseif (adjust <= 2294) then dapos = 2;
	elseif (adjust <= 3361) then dapos = 3;
	elseif (adjust <= 5039) then dapos = 4;
	elseif (adjust <= 6140) then dapos = 5;
	elseif (adjust <= 6710) then dapos = 6;
	elseif (adjust <= 8389) then dapos = 7;
	elseif (adjust <= 8928) then dapos = 8;
	elseif (adjust <= 10069) then dapos = 9;
	elseif (adjust <= 11160) then dapos = 10;
	end
    timer = dtarray[dapos];
    ntimer = dtarray[dapos+1];
    local timesincedawn = (nowtime - InitDawn) % 11160;
	
	local tempIGduration = 0;
	for m = 1, dapos do
		tempIGduration = tempIGduration + darray[m]; 
        -- duration from dawn through next IG time
	end
	
	totalseconds = math.floor( tempIGduration - timesincedawn );  
    -- duration left for current IG time is equal to (time from dawn to next 
    -- IG time) minus (time from now since last dawn)
	
	local cdhours = math.floor( totalseconds / 3600 );
	cdminutes = math.floor( 60*( (totalseconds / 3600) - cdhours) );
	local cdseconds = math.floor( 60*(60*( (totalseconds/3600) - cdhours ) 
        - cdminutes) + 0.5 );
end

-- Moved from functions.lua
function UpdateDayNight()
	local cdate = Turbine.Engine.GetDate();
	local chour = cdate.Hour;
	local cminute = cdate.Minute;
	local ampm = "";
	timer, sDay = nil, nil;

	GetInGameTime();
	local DNLen = 0;
	local DNTime = timer;
	DNLen1 = string.len(DNTime) * TM;
	DNLen = DNLen1;
	
	local dnData = (_G.ControlData and _G.ControlData.DN) or {}
	if dnData.next ~= false then --Show next day & night time
		if totalseconds >= 60 then NDNTime = cdminutes .. " min: " .. ntimer;
		else NDNTime = totalseconds .. " sec: " .. ntimer; end

		local DNLen2 = string.len(NDNTime) * TM;
		if DNLen2 > DNLen1 then DNLen = DNLen2; end

		_G.ControlData.DN.controls[ "Lbl" ]:SetText( DNTime .. "\n" .. NDNTime );
	else
		_G.ControlData.DN.controls[ "Lbl" ]:SetText( DNTime );
	end

	_G.ControlData.DN.controls[ "Lbl" ]:SetSize( DNLen, CTRHeight ); --Auto size with text length
	--DN[ "Lbl" ]:SetBackColor( Color["white"] ); -- Debug purpose

	if sDay == "day" then _G.ControlData.DN.controls[ "Icon" ]:SetBackground( resources.Sun );
        -- Sun in-game icon (0x4101f898 or 0x4101f89b)
	else _G.ControlData.DN.controls[ "Icon" ]:SetBackground( resources.Moon ); end -- Moon in-game icon

	AdjustIcon( "DN" );
end

function InitializeDayNight()
    _G.ControlData.DN.controls = _G.ControlData.DN.controls or {}
    local DN = _G.ControlData.DN.controls
    
    local colors = _G.ControlData.DN.colors
    
    if not DN["Ctr"] then
        CreateTitanBarControl(DN, colors.alpha, colors.red, colors.green, colors.blue)
        _G.ControlData.DN.ui.control = DN["Ctr"]

        --**v Day & Night & icon on TitanBar v**
        DN["Icon"] = CreateControlIcon(DN["Ctr"], Constants.ICON_SIZE_SMALL, Constants.ICON_SIZE_SMALL)

        DN["Lbl"] = CreateControlLabel(DN["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

        SetupControlInteraction({
            icon = DN["Lbl"],
            controlTable = DN,
            settingsSection = settings.DayNight,
            windowImportPath = AppCtrD .. "DayNightWindow",
            windowFunction = "frmDayNightWindow",
            tooltipKey = "DN",
            leaveControl = DN["Lbl"]
        })

        -- Delegate Icon events to Lbl
        DelegateMouseEvents(DN["Icon"], DN["Lbl"])
    end
    
    UpdateDayNight()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "DN",
		settingsKey = "DayNight",
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 },
		initFunc = InitializeDayNight
	})
end

_G.UpdateDayNight = UpdateDayNight