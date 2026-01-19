-- Main.lua
-- written by Habna
-- rewritten by many

import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay";

AppDir = "HabnaPlugins.TitanBar";
AppDirD = AppDir..".";

AppClassD = AppDirD.."Class.";
AppCtrD = AppDirD.."Control.";
AppLocaleD = AppDirD.."Locale.";

-- Ensure path globals are accessible to dynamically loaded modules
_G.AppDir = AppDir;
_G.AppDirD = AppDirD;
_G.AppClassD = AppClassD;
_G.AppCtrD = AppCtrD;
_G.AppLocaleD = AppLocaleD;

Version = Plugins["TitanBar"]:GetVersion();--> ** TitanBar current version **
_G.TB = {};
windowOpen = true;
_G.Debug = false;-- True will enable some functions when I'm debugging

-- Import and initialize control registry
import(AppDirD.."ControlRegistry");
_G.ControlRegistry.InitializeAll();

-- BlendMode 1: Color / 2: Normal / 3: Multiply / 4: AlphaBlend / 5: Overlay / 
-- 6: Grayscale / 7: Screen / 8: Undefined

-- [FontName]={[Fontsize]=pixel needed to show one number}
_G.FontN = {
	["Arial"] = {[12]=6},
	["TrajanPro"] = {[13]=7,[14]=7,[15]=7,[16]=8,[18]=9,[19]=10,[20]=10,[21]=11,
        [23]=11,[24]=11,[25]=7,[26]=12,[28]=13},
	["TrajanProBold"] = {[16]=9,[22]=11,[24]=12,[25]=13,[30]=15,[36]=18},
	["Verdana"] = {[10]=5,[12]=7,[14]=8,[16]=8,[18]=12,[20]=12,[22]=12,[23]=13}
	};

-- [FontName]={[Fontsize]=pixel needed to show one letter}
_G.FontT = {
	["Arial"] = {[12]=6},
	["TrajanPro"] = {[13]=8,[14]=9,[15]=9,[16]=10,[18]=11,[19]=12,[20]=12,
        [21]=13,[23]=14,[24]=15,[25]=7,[26]=16,[28]=17},
	["TrajanProBold"] = {[16]=10,[22]=14,[24]=15,[25]=16,[30]=19,[36]=22},
	["Verdana"] = {[10]=5.5,[12]=7,[14]=8,[16]=9,[18]=10,[20]=11,[22]=12,
        [23]=12}
	};

screenWidth, screenHeight = Turbine.UI.Display.GetSize();
write = Turbine.Shell.WriteLine;

--**v Get player instance v**
Player = Turbine.Gameplay.LocalPlayer.GetInstance();
vaultpack = Player:GetVault();
sspack = Player:GetSharedStorage();
backpack = Player:GetBackpack();
PN = Player:GetName();
PlayerAlign = Player:GetAlignment(); --1: Free People / 2: Monster Play
--PlayerAlign = 2;--debug purpose
--**

--**v Detect Game Language v**
GLocale = Turbine.Engine.GetLanguage();
if GLocale == Turbine.Language.French then GLocale = "fr";
elseif GLocale == Turbine.Language.German then GLocale = "de"; 
else GLocale = "en";
end
--**^

import (AppDirD.."Constants");

import (AppDirD.."TBresources");
import (AppDirD.."Currencies");
import (AppDirD.."Factions");
import (AppClassD.."Class");
import (AppDirD.."color");
import (AppDirD.."settings");

-- Initialize Turbine-dependent constants before using them
Constants.InitializeAlignments();

-- Assign durability slots now that Constants is initialized
_G.DurabilitySlotsBG = Constants.DURABILITY_SLOTS_BG;

LoadSettings();

-- Ensure settings is globally accessible for dynamically loaded controls
_G.settings = settings;

import (AppDirD.."UIHelpers");
import (AppDirD.."ControlFactory");

-- Ensure ControlFactory functions are globally accessible for dynamically loaded controls
_G.CreateTitanBarControl = CreateTitanBarControl;
_G.CreateControlIcon = CreateControlIcon;
_G.SetupControlInteraction = SetupControlInteraction;
_G.CreateControlLabel = CreateControlLabel;

import (AppDirD.."functions");
import (AppCtrD.."CurrencyLogic");
import (AppDirD.."functionsCtr");
import (AppCtrD.."Wallet");
import (AppCtrD.."MoneyInfos");
import (AppCtrD.."BagInfos");
import (AppCtrD.."PlayerInfos");
import (AppCtrD.."PlayerLoc");
import (AppCtrD.."EquipInfos");
import (AppCtrD.."DurabilityInfos");
import (AppCtrD.."TrackItems");
import (AppCtrD.."Infamy");
import (AppCtrD.."Vault");
import (AppCtrD.."SharedStorage");
import (AppCtrD.."DayNight");
import (AppCtrD.."Reputation");
import (AppCtrD.."LOTROPoints");
import (AppCtrD.."GameTime");
import (AppDirD.."functionsMenu");
import (AppDirD.."functionsMenuControl");
import (AppDirD.."OptionPanel"); 
    -- LUA option panel file (for in-game plugin manager options tab)
import (AppDirD.."menu");
import (AppDirD.."menuControl");
import (AppDirD.."background");
import (AppDirD.."frmMain");
import (AppDirD.."FontMetric");
frmMain();

-- Initialize all registered controls dynamically
if _G.ControlRegistry and _G.ControlRegistry.ForEach then
    _G.ControlRegistry.ForEach(function(id, data)
        -- ImportCtr handles initialization and positioning if initFunc is present
        if data.initFunc and data.show then
            local success, err = pcall(function() ImportCtr(id) end)
            if not success then
                Turbine.Shell.WriteLine("Error initializing control " .. id .. ": " .. tostring(err))
            end
        end
    end)
end

if PlayerAlign == 1 then
  MenuItem = {
		-- Coin
		L["MGSC"], L["MCommendation"], L["MDestinyPoints"], L["MLotroPoints"], L["MMithrilCoins"],
		-- Currency
		L["MMotesOfEnchantment"], L["MFigmentsOfSplendour"], L["MEmbersOfEnchantment"], L["MAncientScript"], L["MDelvingWrit"],
		-- Instances and Skirmishes
		L["MSkirmishMarks"], L["MMedallions"], L["MSeals"], L["MStarsOfMerit"],
		-- Festivals and Events
		L["MAnniversaryToken"], L["MFallFestivalToken"], L["MFarmersFaireToken"], L["MMidsummerToken"], L["MSpringLeaf"], L["MYuleToken"],
		L["MBuriedTreasureToken"],
		-- Inn League and Ale Association
		L["MBadgeOfTaste"], L["MBadgeOfDishonour"],
		-- Item Advancement
		L["MShards"],
		-- Other   
		L["MAmrothSilverPiece"], L["MBingoBadge"], L["MCentralGondorSilverPiece"], L["MEastGondorSilverPiece"], L["MGiftGiversBrand"], L["MTokensOfHytbold"], L["MColdIronToken"],
		L["MMedallionOfMoria"], L["MMedallionOfLothlorien"], L["MTokenOfHeroism"], L["MHerosMark"], L["MGabilakkaWarMark"], L["MSteelToken"],
		L["MCopperCoinOfGundabad"], L["MSilverCoinOfGundabad"], L["MIronCoinOfCardolan"], L["MBreeLandWoodMark"], L["MBronzeArnorianCoin"],
		L["MSilverArnorianCoin"], L["MGreyfloodMark"], L["MGundabadMountainMark"], L["MSilverTokenOfTheRiddermark"], L["MGoldenTokenOfTheRiddermark"],
		L["MMinasTirithSilverPiece"], L["MCrackedEasterlingSceptre"], L["MGrimOrkishBrand"], L["MSandWornCopperToken"], L["MFrigidSteelSignetRing"],
		L["MEngravedOnyxSigil"], L["MSandSmoothedBurl"], L["MLumpOfRedRockSalt"], L["MIronSignetOfTheSeaShadow"],	L["MIronSignetOfTheFist"],
		L["MIronSignetOfTheAxe"],	L["MIronSignetOfTheBlackMoon"],	L["MIronSignetOfTheNecromancer"],	L["MIronSignetOfTheTwinFlame"],
    L["MPhialCrimsonExtract"], L["MPhialUmberExtract"], L["MPhialVerdantExtract"], L["MPhialGoldenExtract"], L["MPhialVioletExtract"], L["MPhialAmberExtract"],
		L["MPhialSapphireExtract"], L["MShaganiGhin"], L["MHamatiUrgul"], L["MMurGhalaSarz"], L["MSilverSerpent"], L["MHuntersGuildMark"], L["MBlightedRelic"],
		L["MTatteredShadow"],
	}
else
	MenuItem = { L["MCommendation"], L["MLotroPoints"] }
end

TitanBarCommand = Turbine.ShellCommand()

_G.CurrencyLangMap = { -- reverse lookup table necessary to get the internal item name
	[L["MGSC"]] = "GSC",
	[L["MCommendation"]] = "Commendation",
	[L["MDestinyPoints"]] = "DestinyPoints",
	[L["MLotroPoints"]] = "LotroPoints",
	[L["MMithrilCoins"]] = "MithrilCoins",
	[L["MMotesOfEnchantment"]] = "MotesOfEnchantment",
	[L["MFigmentsOfSplendour"]] = "FigmentsOfSplendour",
	[L["MEmbersOfEnchantment"]] = "EmbersOfEnchantment",
	[L["MAncientScript"]] = "AncientScript",
	[L["MDelvingWrit"]] = "DelvingWrit",
	[L["MSkirmishMarks"]] = "SkirmishMarks",
	[L["MMedallions"]] = "Medallions",
	[L["MSeals"]] = "Seals",
	[L["MStarsOfMerit"]] = "StarsOfMerit",
	[L["MAnniversaryToken"]] = "AnniversaryToken",
	[L["MFallFestivalToken"]] = "FallFestivalToken",
	[L["MFarmersFaireToken"]] = "FarmersFaireToken",
	[L["MMidsummerToken"]] = "MidsummerToken",
	[L["MSpringLeaf"]] = "SpringLeaf",
	[L["MYuleToken"]] = "YuleToken",
	[L["MBadgeOfTaste"]] = "BadgeOfTaste",
	[L["MBadgeOfDishonour"]] = "BadgeOfDishonour",
	[L["MShards"]] = "Shards",
  [L["MAmrothSilverPiece"]] = "AmrothSilverPiece",
	[L["MBingoBadge"]] = "BingoBadge",
	[L["MCentralGondorSilverPiece"]] = "CentralGondorSilverPiece",
	[L["MGiftGiversBrand"]] = "GiftGiversBrand",
	[L["MTokensOfHytbold"]] = "TokensOfHytbold",
	[L["MColdIronToken"]] = "ColdIronToken",
	[L["MTokenOfHeroism"]] = "TokenOfHeroism",
	[L["MHerosMark"]] = "HerosMark",
	[L["MMedallionOfMoria"]] = "MedallionOfMoria",
	[L["MMedallionOfLothlorien"]] = "MedallionOfLothlorien",
	[L["MBuriedTreasureToken"]] = "BuriedTreasureToken",
	[L["MGabilakkaWarMark"]] = "GabilakkaWarMark",
	[L["MCopperCoinOfGundabad"]] = "CopperCoinOfGundabad",
	[L["MSilverCoinOfGundabad"]] = "SilverCoinOfGundabad",
	[L["MSteelToken"]] = "SteelToken",
	[L["MIronCoinOfCardolan"]] = "IronCoinOfCardolan",
	[L["MBreeLandWoodMark"]] = "BreeLandWoodMark",
	[L["MBronzeArnorianCoin"]] = "BronzeArnorianCoin",
	[L["MSilverArnorianCoin"]] = "SilverArnorianCoin",
	[L["MEastGondorSilverPiece"]] = "EastGondorSilverPiece",
	[L["MGreyfloodMark"]] = "GreyfloodMark",
	[L["MGundabadMountainMark"]] = "GundabadMountainMark",
	[L["MSilverTokenOfTheRiddermark"]] = "SilverTokenOfTheRiddermark",
	[L["MGoldenTokenOfTheRiddermark"]] = "GoldenTokenOfTheRiddermark",
	[L["MMinasTirithSilverPiece"]] = "MinasTirithSilverPiece",
	[L["MCrackedEasterlingSceptre"]] = "CrackedEasterlingSceptre",
	[L["MGrimOrkishBrand"]] = "GrimOrkishBrand",
	[L["MSandWornCopperToken"]] = "SandWornCopperToken",
	[L["MFrigidSteelSignetRing"]] = "FrigidSteelSignetRing",
	[L["MEngravedOnyxSigil"]] = "EngravedOnyxSigil",
	[L["MSandSmoothedBurl"]] = "SandSmoothedBurl",
	[L["MLumpOfRedRockSalt"]] = "LumpOfRedRockSalt",
	[L["MIronSignetOfTheSeaShadow"]] = "IronSignetOfTheSeaShadow",
	[L["MIronSignetOfTheFist"]] = "IronSignetOfTheFist",
	[L["MIronSignetOfTheAxe"]] = "IronSignetOfTheAxe",
	[L["MIronSignetOfTheBlackMoon"]] = "IronSignetOfTheBlackMoon",
	[L["MIronSignetOfTheNecromancer"]] = "IronSignetOfTheNecromancer",
	[L["MIronSignetOfTheTwinFlame"]] = "IronSignetOfTheTwinFlame",
	[L["MPhialCrimsonExtract"]] = "PhialCrimsonExtract",
	[L["MPhialUmberExtract"]] = "PhialUmberExtract",
	[L["MPhialVerdantExtract"]] = "PhialVerdantExtract",
	[L["MPhialGoldenExtract"]] = "PhialGoldenExtract",
	[L["MPhialVioletExtract"]] = "PhialVioletExtract",
	[L["MPhialAmberExtract"]] = "PhialAmberExtract",
	[L["MPhialSapphireExtract"]] = "PhialSapphireExtract",
	[L["MShaganiGhin"]] = "ShaganiGhin",
	[L["MHamatiUrgul"]] = "HamatiUrgul",
	[L["MMurGhalaSarz"]] = "MurGhalaSarz",
	[L["MSilverSerpent"]] = "SilverSerpent",
	[L["MHuntersGuildMark"]] = "HuntersGuildMark",
	[L["MBlightedRelic"]] = "BlightedRelic",
	[L["MTatteredShadow"]] = "TatteredShadow",
}

function CheckForReputationImport()
	local reputationImport = Turbine.PluginData.Load(Turbine.DataScope.Character, "TitanBar_CompanionImport");
	local emptyReputation = {};
	emptyReputation["SKIP"] = true;
	if type(reputationImport) == "table" and reputationImport["SKIP"] == nil then
		for _, faction in ipairs(_G.Factions.list) do
			if faction.id and faction.name then
				PlayerReputation[PN][faction.name].Total = reputationImport[faction.id];
			end
		end
		Turbine.PluginData.Save(Turbine.DataScope.Character, "TitanBar_CompanionImport", emptyReputation);
		write("TitanBar: Reputation import complete");
	end
end

CheckForReputationImport()

function TitanBarCommand:Execute(command, arguments)
	local function tokenize(str)
		local parts = {}
		for token in string.gmatch(str, "%S+") do
			table.insert(parts, token)
		end
		return parts
	end

	local commands = {
		-- options menu
		[L["SCa1"]] = function() TitanBarMenu:ShowMenu() end,
		["opt"]     = function() TitanBarMenu:ShowMenu() end,

		[L["SCa2"]] = UnloadTitanBar, ["u"]  = UnloadTitanBar,
		[L["SCa3"]] = ReloadTitanBar, ["r"]  = ReloadTitanBar,
		[L["SCa4"]] = ResetSettings,  ["ra"] = ResetSettings,

		["sc"] = function() HelpInfo() end,
		["?"]  = function() HelpInfo() end,

		["pw"] = function()
			write("")
			write("This is your currency:")
			write("-----v----------------------")
			ShowTableContent(PlayerCurrency)
			write("-----^----------------------")
			write("You may request to add a currency if it's not listed in the wallet menu!")
			write("Provide both the 'key' and 'value' to the maintainer.")
			write("")
		end,
	}

	local args = tokenize(arguments:lower());
	local cmd = args[1];
	local handled = false;

	if commands[cmd] then
		commands[cmd]();
		handled = true
	end

	if not handled then
		write("TitanBar: " .. L["SC0"]);
	end
end

Turbine.Shell.AddCommand('TitanBar', TitanBarCommand)

Turbine.Plugin.Load = function( self, sender, args )
	write( L["TBLoad"] ); --TitanBar version loaded!
end

Turbine.Plugin.Unload = function( self, sender, args )
	SavePlayerMoney( true );
	SavePlayerBags();
end
