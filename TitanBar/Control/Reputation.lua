-- Reputation.lua
-- Written by Habna

if resources == nil then import "HabnaPlugins.TitanBar.TBresources"; end;
import(AppDirD .. "UIHelpers")
import(AppCtrD .. "ReputationToolTip")
import(AppDirD .. "ControlFactory")

function UpdateReputationSaveFileFormat(reputation)
    if not reputation["file_version"] then
        local now = Turbine.Engine.GetDate()
        local nowString = string.format("%04d%02d%02d_%02d%02d%02d",
            now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second)
        local filename = string.format("TitanBarRep_v0bak_%s", nowString)
        Turbine.PluginData.Save(Turbine.DataScope.Server, filename, reputation)

        local repOrder = {
            -- Normal faction advancement + Forochel and Minas Tirith
            "RPMB", "RPTH", "RPTMS", "RPDOC", "RPTYW", "RPRE", "RPER", "RPDOTA", "RPTEl", "RPCN", "RPTWA",
            "RPLF", "RPWB", "RPLOTA", "RPTEg", "RPIGG", "RPIGM", "RPAME", "RPTGC", "RPG", "RPM",
            "RPTRS", "RPHLG", "RPMD", "RPTR", "RPMEV", "RPMN", "RPMS", "RPMW",
            "RPPW", "RPSW", "RPTEo", "RPTHe", "RPTEFF", "RPMRV", "RPMDE", "RPML",
            "RPP", "RPRI", "RPRR", "RPDMT", "RPDA",
            -- Dol Amroth Buildings (position 37< <46)
            "RPDAA", "RPDAB", "RPDAD", "RPDAGH", "RPDAL", "RPDAW", "RPDAM",
            "RPDAS",
            -- Crafting guilds (position 45< <53)
            "RPJG", "RPCG", "RPSG", "RPTG", "RPWoG", "RPWeG", "RPMG",
            -- Host of the West
            "RPHOTW", "RPHOTWA", "RPHOTWW", "RPHOTWP",
            -- Plateau of Gorgoroth
            "RPCOG", "RPEOFBs", "RPEOFBn", "RPRSC",
            -- Strongholds of the North
            "RPDOE", "RPEOF", "RPMOD", "RPGME",
            -- Vales of Anduin
            "RPWF",
            -- Minas Morgul
            "RPTGA", "RPTWC", "RPRMI",
            -- Wells of Langflood
            "RPPOW",
            -- Elderslade
            "RPMOG", "RPGA",
            --Azanulbizar
            "RPHOT", "RPKU",
            --Gundabad
            "RPROFMH",
            -- Special Event
            "RPCCLE", "RPTAA", "RPTIL",
            -- Reputation Accelerator
            "RPACC",
        }
        local baseReputation = {
            20000, 20000, 20000, 20000, 0,     20000, 20000, 1000,  20000, 20000, 20000,
            10000, 20000, 10000, 20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000, 20000, 20000, 20000,
            20000, 20000, 20000, 20000,
            20000, 0,     0,     10000,
            20000, 20000, 20000, 20000,
            20000,
            30000, 0,     2000,
            20000,
            20000, 20000,
            20000, 10000,
            20000,
            20000, 0,     0,
            0
        }
        local reputationSteps = {
          ["default"] = {
            [0] = 10000, [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 60000, [7] = 90000, [8] = 200000, [9] = 1
          },
          ["RPTGA"] = {
            [1] = 10000, [2] = 20000, [3] = 20000, [4] = 1
          },
          ["RPTWC"] = {
            [1] = 10000, [2] = 20000, [3] = 20000, [4] = 1
          },
          ["RPRMI"] = {
            [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 50000, [7] = 60000, [8] = 70000, [9] = 1
          },
          ["RPPOW"] = {
            [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 50000, [7] = 60000, [8] = 70000, [9] = 1
          },
          ["RPMOG"] = {
            [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 50000, [7] = 60000, [8] = 70000, [9] = 1
          },
          ["RPGA"] = {
            [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 50000, [7] = 60000, [8] = 70000, [9] = 1
          },
          ["RPHOT"] = {
            [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 50000, [7] = 60000, [8] = 70000, [9] = 1
          },
          ["RPKU"] = {
            [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 50000, [7] = 60000, [8] = 70000, [9] = 1
          },
          ["RPROFMH"] = {
            [1] = 10000, [2] = 20000, [3] = 25000, [4] = 30000, [5] = 45000,
            [6] = 50000, [7] = 60000, [8] = 70000, [9] = 1
          },
          ["RPDMT"] = { [0] = 1 }
        }

        for playerName, playerRep in pairs(reputation) do
            for i, factionAbbreviation in ipairs(repOrder) do
                playerRep[factionAbbreviation] = playerRep[factionAbbreviation] or {}
                local reputationRank = tonumber(playerRep[factionAbbreviation].K) or 0
                local stepsType = "default"
                if reputationSteps[factionAbbreviation] then
                    stepsType = factionAbbreviation;
                end
                local factionReputationSteps = reputationSteps[stepsType]
                local totalReputation = playerRep[factionAbbreviation].P
                totalReputation = totalReputation + baseReputation[i]
                for j = 1, math.min(#factionReputationSteps, reputationRank) - 1 do
                    totalReputation = totalReputation + factionReputationSteps[j]
                end
                playerRep[factionAbbreviation].Total = tostring(totalReputation)
            end
            for _, faction in ipairs(_G.Factions.list) do
                playerRep = reputation[playerName]
                playerRep[faction.name] = playerRep[faction.name] or {}
                local total = "0"
                local visible = false
                if faction.legacyTitanbarName and playerRep[faction.legacyTitanbarName] then
                    total = playerRep[faction.name].Total or playerRep[faction.legacyTitanbarName].Total
                    visible = playerRep[faction.name].V or playerRep[faction.legacyTitanbarName].V
                    playerRep[faction.legacyTitanbarName] = nil
                else
                    total = playerRep[faction.name].Total
                    visible = playerRep[faction.name].V
                end
                playerRep[faction.name].Total = total or "0"
                playerRep[faction.name].V = visible or false
            end
        end
    reputation["file_version"] = "2"
    end
end

function LoadPlayerReputation()
    _G.PlayerReputation = Turbine.PluginData.Load(Turbine.DataScope.Server, "TitanBarReputation")
    if _G.PlayerReputation == nil then _G.PlayerReputation = {}; end
    UpdateReputationSaveFileFormat(_G.PlayerReputation)
    if _G.PlayerReputation[PN] == nil then _G.PlayerReputation[PN] = {}; end

    for _, faction in ipairs(_G.Factions.list) do
        _G.PlayerReputation[PN][faction.name] = _G.PlayerReputation[PN][faction.name] or {}
        _G.PlayerReputation[PN][faction.name].Total = _G.PlayerReputation[PN][faction.name].Total or "0"
        _G.PlayerReputation[PN][faction.name].V = _G.PlayerReputation[PN][faction.name].V or false
    end
    SavePlayerReputation();
end
_G.LoadPlayerReputation = LoadPlayerReputation

function SavePlayerReputation()
    if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play

    Turbine.PluginData.Save(
        Turbine.DataScope.Server, "TitanBarReputation", _G.PlayerReputation);
end

-- Moved from functions.lua
function UpdateReputation()
	AdjustIcon( "RP" );
end

function InitializeReputation()
    _G.ControlData.RP.controls = _G.ControlData.RP.controls or {}
    local RP = _G.ControlData.RP.controls
    
    local colors = _G.ControlData.RP.colors
    
    if not RP["Ctr"] then
        CreateTitanBarControl(RP, colors.alpha, colors.red, colors.green, colors.blue)
        _G.ControlData.RP.ui.control = RP["Ctr"]

        --**v Reputation icon on TitanBar v**
        RP["Icon"] = CreateControlIcon(RP["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, resources.Reputation.Icon, 4)

        SetupControlInteraction({
            icon = RP["Icon"],
            controlTable = RP,
            settingsSection = settings.Reputation,
            windowImportPath = AppCtrD .. "ReputationWindow",
            windowFunction = "frmReputationWindow",
            tooltipKey = "RP",
            customTooltipHandler = ShowRPWindow
        })
        
        -- Load data and setup callback
        LoadPlayerReputation()
        
        -- Copying the complex callback logic from functionsCtr.lua
        if not RP.callback then
            RP.callback = AddCallback(Turbine.Chat, "Received",
                function( sender, args )
                    if (args.ChatType ~= Turbine.ChatType.Advancement) then return; end

                    local rpMess = args.Message;
                    if rpMess ~= nil then
                    -- Check string, Reputation Name and Reputation Point pattern
                        local cstr, factionPattern, rppPattern, rpbPattern;
                        if GLocale == "en" then
                            factionPattern = "reputation with (.*) has (.*) by";
                            rppPattern = "has .* by ([%d%p]*)%.";
                        elseif GLocale == "fr" then
                            factionPattern = "de la faction (.*) a (.*) de";
                            rppPattern = "a .* de ([%d%p]*)%.";
                        elseif GLocale == "de" then
                            factionPattern = "Euer Ruf bei (.*) hat sich um .* (%a+)";
                            rppPattern = "hat sich um ([%d%p]*) .*";
                        end
                        -- check string if an accelerator was used
                        if GLocale == "de" then
                            cstr = string.match( rpMess, "Bonus" );
                        else cstr = string.match( rpMess, "bonus" ); end
                        -- Accelerator was used, end of string is different.
                        -- Ex. (700 from bonus). instead of just a dot after the
                        -- amount of points
                        if cstr ~= nil then
                            if GLocale == "en" then
                                rppPattern = "has increased by ([%d%p]*) %(";
                                rpbPattern = "%(([%d%p]*) from bonus";
                            elseif GLocale == "fr" then
                                rppPattern = "a augment\195\169 de ([%d%p]*) %(";
                                rpbPattern = "%(([%d%p]*) du bonus";
                            elseif GLocale == "de" then
                                factionPattern = "Euer Ruf bei der Gruppe \"(.*)\" wurde um"
                                rppPattern = "wurde um ([%d%p]*) erh\195\182ht";
                                rpbPattern = "%(([%d%p]*) durch Bonus";
                            end
                        end
                        local rpName,increaseOrDecrease = string.match( rpMess,factionPattern );

                        -- Reputation Name
                        if rpMess ~= nil and rpName ~= nil then
                            -- decrease remaining bonus acceleration
                            if rpbPattern ~= nil then
                                local rpBonus = string.match( rpMess, rpbPattern );
                                rpBonus = string.gsub( rpBonus, ",", "" );
                                local newValue = math.max(0, _G.PlayerReputation[PN]["ReputationAcceleration"].Total - rpBonus)
                                _G.PlayerReputation[PN]["ReputationAcceleration"].Total = string.format("%.0f", newValue);
                            end
                            local rpPTS = string.match( rpMess, rppPattern );
                            if (rpPTS) then
                                -- Replace "," in 1,400 to get 1400 or the "." in 1.400 to get 1400
                                rpPTS = string.gsub(rpPTS, "[%p]", "");
                                rpPTS = tonumber(rpPTS);
                            end
                            if (increaseOrDecrease == L[ "RPDECREASE"]) then
                                rpPTS = -rpPTS;
                            end
                            for _, faction in ipairs(_G.Factions.list) do
                                if L[faction.name] == rpName then
                                    local current_points = _G.PlayerReputation[PN][faction.name].Total
                                    local newPointsTotal = current_points + rpPTS
                                    local factionMaxReputation = tonumber(faction.ranks[#faction.ranks].requiredReputation) or 0
                                    newPointsTotal = math.min(factionMaxReputation, newPointsTotal)
                                    newPointsTotal = math.max(0, newPointsTotal)
                                    _G.PlayerReputation[PN][faction.name].Total = string.format("%.0f", newPointsTotal)
                                end
                            end
                            SavePlayerReputation();
                        end
                    end
                end
            );
        end
    end
    
    UpdateReputation()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "RP",
		settingsKey = "Reputation",
		hasWhere = false,
		defaults = { show = false, x = 0, y = 0 },
		initFunc = InitializeReputation
	})
end

-- Export global functions
_G.LoadPlayerReputation = LoadPlayerReputation
_G.SavePlayerReputation = SavePlayerReputation
_G.UpdateReputation = UpdateReputation
_G.UpdateReputationSaveFileFormat = UpdateReputationSaveFileFormat