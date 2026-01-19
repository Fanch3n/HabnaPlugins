import(AppDirD .. "UIHelpers")
import(AppCtrD .. "InfamyToolTip")
import(AppDirD .. "ControlFactory")

-- Function to handle infamy/renown chat messages
function HandleInfamyChat(sender, args)
    if not (args and args.ChatType == Turbine.ChatType.Advancement) then return end
    
    local ifMess = args.Message;
    if ifMess == nil then return end

    local ifPattern;
    if PlayerAlign == 1 then
        if GLocale == "en" then
            ifPattern = "earned ([%d%p]*) renown points";
        elseif GLocale == "fr" then
            ifPattern = "gagn\195\169 ([%d%p]*) points " ..
                "renomm\195\169e";
        elseif GLocale == "de" then
            ifPattern = "habt ([%d%p]*) Ansehenspunkte";
        end
    else
        if GLocale == "en" then
            ifPattern = "earned ([%d%p]*) infamy points";
        elseif GLocale == "fr" then
            ifPattern = "gagn\195\169 ([%d%p]*) points " ..
                "d'infamie";
        elseif GLocale == "de" then
            ifPattern = "habt ([%d%p]*) Verrufenheitspunkte";
        end
    end

    if not ifPattern then return end

    local tmpIF = string.match(ifMess,ifPattern);
    if tmpIF ~= nil then
        _G.ControlData.IF = _G.ControlData.IF or {}
        local currentPoints = tonumber(_G.ControlData.IF.points) or 0
        local delta = tonumber((string.gsub(tmpIF, "%p+", ""))) or 0
        _G.ControlData.IF.points = currentPoints + delta

        _G.InfamyRanks = Constants.INFAMY_RANKS;
        for i=0, 14 do
            if (_G.ControlData.IF.points >= _G.InfamyRanks[i]) and
                (_G.ControlData.IF.points < _G.InfamyRanks[i+1]) then
                _G.ControlData.IF.rank = i
                break
            end
        end
        settings.Infamy.P = string.format("%.0f", _G.ControlData.IF.points);
        settings.Infamy.K = string.format("%.0f", _G.ControlData.IF.rank or 0);
        SaveSettings( false );
        UpdateInfamy();
    end
end

-- Moved from functions.lua
function UpdateInfamy()
    -- Ensure dependencies
    if not (AdjustIcon and _G.ControlData.IF and _G.ControlData.IF.controls) then return end
    
    local IF = _G.ControlData.IF.controls
    
    -- Determine icon set based on alignment
    local InfIcon;
    if PlayerAlign == 1 then
        --Free people rank icon 0 to 15
        InfIcon = resources.FreePeoples
    else
        --Monster play rank icon 0 to 15
        InfIcon = resources.Monster
    end

    --Change Rank icon with infamy points
    if IF["Icon"] and settings.Infamy and settings.Infamy.K then
        local rankIndex = tonumber(settings.Infamy.K)
        if rankIndex and InfIcon[rankIndex] then
            IF["Icon"]:SetBackground( InfIcon[rankIndex] );
        end
    end
    
    AdjustIcon( "IF" );
end

function InitializeInfamy()
    _G.ControlData.IF.controls = _G.ControlData.IF.controls or {}
    local IF = _G.ControlData.IF.controls
    
    local colors = _G.ControlData.IF.colors
    if not IF["Ctr"] then
        CreateTitanBarControl(IF, colors.alpha, colors.red, colors.green, colors.blue)
        _G.ControlData.IF.ui.control = IF["Ctr"]

        IF["Icon"] = CreateControlIcon(IF["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

        SetupControlInteraction({
            icon = IF["Icon"],
            controlTable = IF,
            settingsSection = settings.Infamy,
            windowImportPath = AppCtrD .. "InfamyWindow",
            windowFunction = "frmInfamyWindow",
            customTooltipHandler = ShowIFWindow
        })
    end
    
    -- Register chat callback
    if not IF.callback then
        IF.callback = AddCallback(Turbine.Chat, "Received", HandleInfamyChat);
    end
    
    UpdateInfamy()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "IF",
		settingsKey = "Infamy",
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 },
		initFunc = InitializeInfamy
	})
end