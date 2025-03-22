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

Version = Plugins["TitanBar"]:GetVersion();--> ** TitanBar current version **
_G.TB = {};
windowOpen = true;
_G.Debug = true;-- True will enable some functions when I'm debugging

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
-- Legend: 0 = invalid / 2 = English / 268435457 = EnglishGB / 
--    268435459 = Francais / 268435460 = Deutsch / 268435463 = Russian
GLocale = Turbine.Engine.GetLanguage();
if GLocale == 268435459 then GLocale = "fr";
elseif GLocale == 268435460 then GLocale = "de"; 
else GLocale = "en";
end
--**^

Position = {
	TITANBAR = 1,
	TOOLTIP = 2,
	NONE = 3
}

import (AppDirD.."TBresources");
import (AppDirD.."Currencies");
import (AppClassD.."Class");
import (AppDir);
import (AppDirD.."color");
import (AppDirD.."settings");
LoadSettings();
import (AppDirD.."functions");
import (AppCtrD.."CurrencyLogic");
import (AppDirD.."functionsCtr");
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

if PlayerAlign == 1 then
  MenuItem = {
		-- Coin
		L["MGSC"], L["MCommendation"], L["MDestinyPoints"], L["MLP"], L["MMithrilCoins"],
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
		L["MAmrothSilverPiece"], L["MBingoBadge"], L["MCentralGondorSilverPiece"], L["MEastGondorSilverPiece"], L["MGiftgiversBrand"], L["MTokensOfHytbold"], L["MColdIronToken"],
		L["MMedallionOfMoria"], L["MMedallionOfLothlorien"], L["MTokenOfHeroism"], L["MHerosMark"], L["MGabilakkaWarMark"], L["MSteelToken"],
		L["MCopperCoinOfGundabad"], L["MSilverCoinOfGundabad"], L["MIronCoinOfCardolan"], L["MBreeLandWoodMark"], L["MBronzeArnorianCoin"],
		L["MSilverArnorianCoin"], L["MGreyfloodMark"], L["MGundabadMountainMark"], L["MSilverTokenOfTheRiddermark"], L["MGoldenTokenOfTheRiddermark"]
	}
else
	MenuItem = { L["MCommendation"], L["MLP"] }
end

TitanBarCommand = Turbine.ShellCommand()

_G.CurrencyLangMap = { -- reverse lookup table necessary to get the internal item name
	[L["MGSC"]] = "GSC",
	[L["MCommendation"]] = "Commendation",
	[L["MDestinyPoints"]] = "DestinyPoints",
	[L["MLP"]] = "LP",
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
	[L["MGiftgiversBrand"]] = "GiftgiversBrand",
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
	[L["MGoldenTokenOfTheRiddermark"]] = "GoldenTokenOfTheRiddermark"
}

function TitanBarCommand:Execute( command, arguments )
	if ( arguments == L["SCa1"] or arguments == "opt") then
		TitanBarMenu:ShowMenu();
	elseif ( arguments == L["SCa2"] or arguments == "u" ) then
		UnloadTitanBar();
	elseif ( arguments == L["SCa3"] or arguments == "r" ) then
		ReloadTitanBar();
	elseif ( arguments == L["SCa4"] or arguments == "ra" ) then
		ResetSettings();
	elseif ( arguments == L["SCa13"] or arguments == "?" or arguments == "sc" ) 
        then
		HelpInfo();
	--elseif ( arguments == L["SCa??"] or arguments == "ab") then
		--AboutTitanBar();
	elseif ( arguments == "pw" ) then
		write("");
		write("This is your currency:");
		write("-----v----------------------");
		ShowTableContent( PlayerCurrency );
		write("-----^----------------------");
		write("You may request to add a currency if it's not listed in the " .. 
            "wallet menu! Give the 'key' string to Habna so it can be added" .. 
            " into future version of TitanBar thx!");
		write("");
	else
		ShowNS = true;
	end

	if ShowNS then write( "TitanBar: " .. L["SC0"] ); ShowNS = nil; end 
        -- Command not supported
end

Turbine.Shell.AddCommand('TitanBar', TitanBarCommand)

Turbine.Plugin.Load = function( self, sender, args )
	write( L["TBLoad"] ); --TitanBar version loaded!
end

Turbine.Plugin.Unload = function( self, sender, args )
	SavePlayerMoney( true );
	SavePlayerBags();
end
