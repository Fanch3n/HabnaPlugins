-- GameTime.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function UpdateGameTime(str)
	local gtData = _G.ControlData and _G.ControlData.GT
	local clock24h = gtData and gtData.clock24h == true
	local showST = gtData and gtData.showST == true
	local showBT = gtData and gtData.showBT == true
	local userGMT = (gtData and tonumber(gtData.userGMT)) or 0

	local cdate = Turbine.Engine.GetDate();
	local chour = cdate.Hour;
	local cminute = cdate.Minute;
	local ampm = "";
	TheTime = nil;
	TextLen = nil;

    local GT = _G.ControlData.GT.controls
    if not GT or not GT["Lbl"] then return end

	local function formatTime(hour, minute)
		local suffix = "";
		if not clock24h then
			if hour == 12 then suffix = "pm";
			elseif hour >= 13 then hour = hour - 12; suffix = "pm";
			else if hour == 0 then hour = 12; end suffix = "am"; end
		end

		return hour .. ":" .. string.format("%02d", minute) .. suffix;
	end

	if str == "st" then
		if showST then
			chour = chour + userGMT;
			if chour < 0 then
				chour = 24 + chour;
				if chour == 0 then chour = 24; end
			elseif chour == 24 then
				chour = 24 - chour;
			end
		end

		gtData.stime = formatTime(chour, cminute);
		TheTime = gtData.stime;
		TextLen = string.len(TheTime) * NM;
	elseif str == "gt" then
		gtData.gtime = formatTime(chour, cminute);
		TheTime = gtData.gtime;
		TextLen = string.len(TheTime) * TM;
	elseif str == "bt" then
		UpdateGameTime("st");
		UpdateGameTime("gt");
		TheTime = L["GTWST"] .. gtData.stime; -- default value to calculate length
		TextLen = string.len(TheTime) * NM;
		TheTime = 
            L["GTWST"] .. gtData.stime .. "\n" .. L["GTWRT"] .. gtData.gtime .. " ";
	end
	
	GT[ "Lbl" ]:SetText( TheTime );
	GT[ "Lbl" ]:SetSize( TextLen, CTRHeight ); --Auto size with text length
	GT[ "Ctr" ]:SetSize( GT[ "Lbl" ]:GetWidth(), CTRHeight );
end

function InitializeGameTime()
    _G.ControlData.GT.controls = _G.ControlData.GT.controls or {}
    local GT = _G.ControlData.GT.controls
    
    local colors = _G.ControlData.GT.colors
    
    if not GT["Ctr"] then
        CreateTitanBarControl(GT, colors.alpha, colors.red, colors.green, colors.blue)
        _G.ControlData.GT.ui.control = GT["Ctr"]

        GT["Lbl"] = CreateControlLabel(GT["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleRight)

        SetupControlInteraction({
            icon = GT["Lbl"],
            controlTable = GT,
            settingsSection = settings.GameTime,
            windowImportPath = AppCtrD .. "GameTimeWindow",
            windowFunction = "frmGameTimeWindow",
            tooltipKey = "GT",
            leaveControl = GT["Lbl"]
        })
    end

    if _G.ControlData.GT.showBT then UpdateGameTime("bt");
    elseif _G.ControlData.GT.showST then UpdateGameTime("st");
    else UpdateGameTime("gt") end

    if GT["Ctr"] and _G.ControlData.GT.location.x + GT["Ctr"]:GetWidth() > screenWidth then
        _G.ControlData.GT.location.x = screenWidth - GT["Ctr"]:GetWidth();
    end --Replace if out of screen
    
    if GT["Ctr"] then
        GT["Ctr"]:SetPosition(_G.ControlData.GT.location.x, _G.ControlData.GT.location.y)
    end
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "GT",
		settingsKey = "GameTime",
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 },
		initFunc = InitializeGameTime
	})
end

_G.UpdateGameTime = UpdateGameTime