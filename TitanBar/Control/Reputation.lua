if resources == nil then import "HabnaPlugins.TitanBar.TBresources"; end;
import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import(AppCtrD .. "ReputationToolTip")

function InitializeReputation()
-- Use _G.ControlData.RP.controls for all UI controls
local RP = {}
_G.ControlData.RP.controls = RP

local colors = _G.ControlData.RP.colors
RP["Ctr"] = CreateTitanBarControl(RP, colors.alpha, colors.red, colors.green, colors.blue)
_G.ControlData.RP.ui.control = RP["Ctr"]

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

-- Chat listener for reputation changes
ReputationCallback = AddCallback(Turbine.Chat, "Received",
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

if rpMess ~= nil and rpName ~= nil then
if rpbPattern ~= nil then
local rpBonus = string.match( rpMess, rpbPattern );
rpBonus = string.gsub( rpBonus, ",", "" );
local newValue = math.max(0, PlayerReputation[PN]["ReputationAcceleration"].Total - rpBonus)
PlayerReputation[PN]["ReputationAcceleration"].Total = string.format("%.0f", newValue);
end
local rpPTS = string.match( rpMess, rppPattern );
if (rpPTS) then
rpPTS = string.gsub(rpPTS, "[%p]", "");
rpPTS = tonumber(rpPTS);
end
if (increaseOrDecrease == L[ "RPDECREASE"]) then
rpPTS = -rpPTS;
end
for _, faction in ipairs(_G.Factions.list) do
if L[faction.name] == rpName then
local current_points = PlayerReputation[PN][faction.name].Total
local newPointsTotal = current_points + rpPTS
local factionMaxReputation = tonumber(faction.ranks[#faction.ranks].requiredReputation) or 0
newPointsTotal = math.min(factionMaxReputation, newPointsTotal)
newPointsTotal = math.max(0, newPointsTotal)
PlayerReputation[PN][faction.name].Total = string.format("%.0f", newPointsTotal)
end
end
SavePlayerReputation();
end
end
end
);

UpdateReputation()
end

-- Self-registration
_G.ControlRegistry.Register({
id = "RP",
settingsKey = "Reputation",
hasWhere = true,
defaults = { show = false, where = 1, x = 0, y = 0 },
initFunc = InitializeReputation
})
