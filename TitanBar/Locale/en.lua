-- en.lua
-- Written by Habna
-- Rewritten by many

_G.L = {};
L[ "TBLoad" ] = "TitanBar " .. Version .. " loaded!";
L[ "TBSSCS" ] = "TitanBar: Screen size has changed, repositioning controls...";
L[ "TBSSCD" ] = "TitanBar: done!";
L[ "TBOpt" ] = "Options are available by right clicking on TitanBar";

--Misc
L[ "NoData" ] = "No other data available in API";
L[ "NA" ] = "N/A";
--L[ "dmg" ] = " dmg";
L[ "You" ] = "You: ";
L[ "ButDel" ] = "Delete information of this character";
--L[ "" ] = "";

-- TitanBar Menu
L[ "MBag" ] = "Wallet";
L[ "MGSC" ] = "Money";
L[ "MBI" ] = "Backpack infos";
L[ "MPI" ] = "Player infos";
L[ "MEI" ] = "Equipment infos";
L[ "MDI" ] = "Durability infos";
L[ "MPL" ] = "Player Location";
L[ "MGT" ] = "Time";
L[ "MOP" ] = "More options";
L[ "MPP" ] = "Profile";
L[ "MSC" ] = "Shell commands";
L[ "MRA" ] = "Reset all settings";
L[ "MUTB" ] = "Unload";
L[ "MRTB" ] = "Reload";
L[ "MATB" ] = "About ";
L[ "MBG" ] = "Set back color";
L[ "MCL" ] = "Change language to ...";
L[ "MCLen" ] = "English";
L[ "MCLfr" ] = "French";
L[ "MCLde" ] = "Deutsch";
L[ "MTI" ] = "Track Items";
--L[ "MView" ] = "View your ";
L[ "MVault" ] = "Vault";
L[ "MStorage" ] = "Shared Storage";
--L[ "MBank" ] = "Bank";
L[ "MDayNight" ] = "Day & Night Time";
L[ "MReputation" ] = "Reputation";

-- Wallet Currency Controls
-- LOTRO Points control
L[ "MLotroPoints" ] = "LOTRO points";
L[ "LotroPointsh" ] = "These are your LOTRO points";
-- Mithril Coins control
L[ "MMithrilCoins" ] = "Mithril Coin";
L[ "MithrilCoinsh" ] = "These are your Mithril Coins";
-- Yule Tokens control
L[ "MYuleToken" ] = "Yule Festival Token";
L[ "YuleTokenh" ] = "These are your Yule Festival Tokens";
-- Anniversary Tokens control
L[ "MAnniversaryToken" ] = "Anniversary Token";
L[ "AnniversaryTokenh" ] = "These are your Anniversary Tokens";
-- Bingo Badge control
L[ "MBingoBadge" ] = "Bingo Badge";
L[ "BingoBadgeh" ] = "These are your Bingo Badges";
-- Skirmish marks control
L[ "MSkirmishMarks" ] = "Mark";
L[ "SkirmishMarksh" ] = "These are your skirmish marks";
-- Destiny Points control
L[ "MDestinyPoints" ] = "Destiny Point";
L[ "DestinyPointsh" ] = "These are your Destiny Points";
-- Shards control
L[ "MShards" ] = "Shard";
L[ "Shardsh" ] = "These are your shard";
-- Tokens of Hytbold control
L[ "MTokensOfHytbold" ] = "Token of Hytbold";
L[ "TokensOfHytboldh" ] = "These are your Tokens of Hytbold";
-- Medallions control
L[ "MMedallions" ] = "Medallion";
L[ "Medallionsh" ] = "These are your medallions";
-- Seals control
L[ "MSeals" ] = "Seal";
L[ "Sealsh" ] = "These are your seals";
-- Commendations control
L[ "MCommendation" ] = "Commendation";
L[ "Commendationh" ] = "These are your Commendations";
-- Amroth Silver Piece control
L[ "MAmrothSilverPiece" ] = "Amroth Silver Piece";
L[ "AmrothSilverPieceh" ] = "These are your Amroth Silver Pieces";
-- Stars of Merit control
L[ "MStarsOfMerit" ] = "Star of Merit";
L[ "StarsOfMerith" ] = "These are your Stars of Merit";
-- Central Gondor Silver Piece control
L[ "MCentralGondorSilverPiece" ] = "Central Gondor Silver Piece";
L[ "CentralGondorSilverPieceh" ] = "These are your Central Gondor Silver Pieces";
-- Gift giver's Brand control
L[ "MGiftgiversBrand" ] = "Gift-giver's Brand";
L[ "GiftgiversBrandh" ] = "These are your Gift-giver's Brands";
-- Motes of Enchantment control
L[ "MMotesOfEnchantment" ] = "Motes of Enchantment";
L[ "MotesOfEnchantmenth" ] = "These are your Motes of Enchantment";
-- Embers of Enchantment control
L[ "MEmbersOfEnchantment" ] = "Embers of Enchantment";
L[ "EmbersOfEnchantmenth" ] = "These are your Embers of Enchantment";
-- Figments of Splendour control
L[ "MFigmentsOfSplendour" ] = "Figments of Splendour";
L[ "FigmentsOfSplendourh" ] = "These are your Figments of Splendour";
-- Fall Festival Tokens control
L[ "MFallFestivalToken" ] = "Fall Festival Token";
L[ "FallFestivalTokenh" ] = "These are your Fall Festival Tokens";
-- Farmers Faire Tokens control
L[ "MFarmersFaireToken" ] = "Farmers Faire Token";
L[ "FarmersFaireTokenh" ] = "These are your Farmers Faire Tokens";
-- Spring Leaves control
L[ "MSpringLeaf" ] = "Spring Leaf";
L[ "SpringLeafh" ] = "These are your Spring Leaves";
-- Midsummer Tokens control
L[ "MMidsummerToken" ] = "Midsummer Token";
L[ "MidsummerTokenh" ] = "These are your Midsummer Tokens";
-- Ancient Script control
L[ "MAncientScript" ] = "Ancient Script";
L[ "AncientScripth" ] = "These are your Ancient Scripts";
-- Inn League / Ale Association control
L[ "MBadgeOfTaste" ] = "Badge of Taste";
L[ "BadgeOfTasteh" ] = "These are your Badges of Taste";
L[ "MBadgeOfDishonour" ] = "Badge of Dishonour";
L[ "BadgeOfDishonourh" ] = "These are your Badges of Dishonour";
-- Delving Writs
L[ "MDelvingWrit" ] = "Delving Writ";
L[ "DelvingWrith" ] = "These are your Delving Writs";
-- Cold-iron Tokens
L[ "MColdIronToken" ] = "Cold-iron Token";
L[ "ColdIronTokenh" ] = "Your Cold-iron Tokens";
-- Token of Heroism
L[ "MTokenOfHeroism" ] = "Token of Heroism";
L[ "TokenOfHeroismh" ] = "Your Tokens of Heroism";
-- Hero's Mark
L[ "MHerosMark" ] = "Hero's Mark";
L[ "HerosMarkh" ] = "Your Hero's Marks";
-- Medallion of Moria
L[ "MMedallionOfMoria" ] = "Medallion of Moria";
L[ "MedallionOfMoriah" ] = "Your Medallions of Moria";
-- Medallion of Lothlórien
L[ "MMedallionOfLothlorien" ] = "Medallion of Lothlórien";
L[ "MedallionOfLothlorienh" ] = "Your Medallions of Lothlórien";
-- Buried Treasure Token
L[ "MBuriedTreasureToken" ] = "Buried Treasure Token";
L[ "BuriedTreasureTokenh" ] = "Your Buried Treasure Tokens";
-- Gabil'akkâ War-mark
L[ "MGabilakkaWarMark" ] = "Gabil'akkâ War-mark";
L[ "GabilakkaWarMarkh" ] = "Your Gabil'akkâ War-marks";
-- Copper Coin of Gundabad
L[ "MCopperCoinOfGundabad" ] = "Copper Coin of Gundabad";
L[ "CopperCoinOfGundabadh" ] = "Your Copper Coins of Gundabad";
-- Silver Coin of Gundabad
L[ "MSilverCoinOfGundabad" ] = "Silver Coin of Gundabad";
L[ "SilverCoinOfGundabadh" ] = "Your Silver Coins of Gundabad";
-- Steel Token
L[ "MSteelToken" ] = "Steel Token";
L[ "SteelTokenh" ] = "Your Steel Tokens";
-- Iron Coin of Cardolan
L[ "MIronCoinOfCardolan" ] = "Iron Coin of Cardolan";
L[ "IronCoinOfCardolanh" ] = "Your Iron Coins of Cardolan";
-- Bree-land Wood-mark
L[ "MBreeLandWoodMark" ] = "Bree-land Wood-mark";
L[ "BreeLandWoodMarkh" ] = "Your Bree-land Wood-marks";
-- Bronze Arnorian Coin
L[ "MBronzeArnorianCoin" ] = "Bronze Arnorian Coin";
L[ "BronzeArnorianCoinh" ] = "Your Bronze Arnorian Coins";
-- Silver Arnorian Coin
L[ "MSilverArnorianCoin" ] = "Silver Arnorian Coin";
L[ "SilverArnorianCoinh" ] = "Your Silver Arnorian Coins";
-- East Gondor Silver Piece
L[ "MEastGondorSilverPiece" ] = "East Gondor Silver Piece";
L[ "EastGondorSilverPieceh" ] = "Your East Gondor Silver Pieces";
-- Greyflood Marks
L[ "MGreyfloodMark" ] = "Greyflood Mark";
L[ "GreyfloodMarkh" ] = "Your Greyflood Marks";
-- Gundabad Mountain-marks
L[ "MGundabadMountainMark" ] = "Gundabad Mountain-mark";
L[ "GundabadMountainMarkh" ] = "Your Gundabad Mountain-marks";
-- Silver Token of the Riddermark
L[ "MSilverTokenOfTheRiddermark" ] = "Silver Token of the Riddermark";
L[ "SilverTokenOfTheRiddermarkh" ] = "Your Silver Tokens of the Riddermark";
-- Golden Token of the Riddermark
L[ "MGoldenTokenOfTheRiddermark" ] = "Golden Token of the Riddermark";
L[ "GoldenTokenOfTheRiddermarkh" ] = "Your Golden Tokens of the Riddermark";
-- Minas Tirith Silver Piece
L[ "MMinasTirithSilverPiece" ] = "Minas Tirith Silver Piece";
L[ "MinasTirithSilverPieceh" ] = "Your Minas Tirith Silver Pieces";
-- Cracked Easterling Sceptre
L[ "MCrackedEasterlingSceptre" ] = "Cracked Easterling Sceptre";
L[ "CrackedEasterlingSceptreh" ] = "Your Cracked Easterling Sceptres";
-- Grim Orkish Brand
L[ "MGrimOrkishBrand" ] = "Grim Orkish Brand";
L[ "GrimOrkishBrandh" ] = "Your Grim Orkish Brands";
-- Sand-work Copper Token
L[ "MSandWornCopperToken" ] = "Sand-worn Copper Token";
L[ "SandWornCopperTokenh" ] = "Your Sand-worn Copper Tokens";
-- Frigid Steel Signet Ring
L[ "MFrigidSteelSignetRing" ] = "Frigid Steel Signet Ring";
L[ "FrigidSteelSignetRingh" ] = "Your Frigid Steel Signet Rings";
-- Engraved Onyx Sigil
L[ "MEngravedOnyxSigil" ] = "Engraved Onyx Sigil";
L[ "EngravedOnyxSigilh" ] = "Your Engraved Onyx Sigils";
-- Sand-smoothed Burl
L[ "MSandSmoothedBurl" ] = "Sand-smoothed Burl";
L[ "SandSmoothedBurlh" ] = "Your Sand-smoothed Burls";
-- Lump of Red Rock Salt
L[ "MLumpOfRedRockSalt" ] = "Lump of Red Rock Salt";
L[ "LumpOfRedRockSalth" ] = "Your Lumps of Red Rock Salt";
-- Iron Signet of the Sea-shadow
L[ "MIronSignetOfTheSeaShadow" ] = "Iron Signet of the Sea-shadow";
L[ "IronSignetOfTheSeaShadowh" ] = "Your Iron Signets of the Sea-shadow";
-- Iron Signet of the Fist
L[ "MIronSignetOfTheFist" ] = "Iron Signet of the Fist";
L[ "IronSignetOfTheFisth" ] = "Your Iron Signets of the Fist";
-- Iron Signet of the Axe
L[ "MIronSignetOfTheAxe" ] = "Iron Signet of the Axe";
L[ "IronSignetOfTheAxeh" ] = "Your Iron Signets of the Axe";
-- Iron Signet of the Black Moon
L[ "MIronSignetOfTheBlackMoon" ] = "Iron Signet of the Black Moon";
L[ "IronSignetOfTheBlackMoonh" ] = "Your Iron Signets of the Black Moon";
-- Iron Signet of the Necromancer
L[ "MIronSignetOfTheNecromancer" ] = "Iron Signet of the Necromancer";
L[ "IronSignetOfTheNecromancerh" ] = "Your Iron Signets of the Necromancer";
-- Iron Signet of the Twin Flame
L[ "MIronSignetOfTheTwinFlame" ] = "Iron Signet of the Twin Flame";
L[ "IronSignetOfTheTwinFlameh" ] = "Your Iron Signets of the Twin Flame";

-- Control Menu
L[ "MCU" ] = "Unload ...";
L[ "MCBG" ] = "Change back color of this control";
L[ "MTBBG" ] = "Apply TitanBar back color to ...";
L[ "MTBBGC" ] = "this control";
L[ "MTBBGAC" ] = "all control";
L[ "MCRBG" ] = "Reset back color of ...";
L[ "MCABT" ] = "Apply this control back color to ...";
L[ "MCABTA" ] = "all control & TitanBar";
L[ "MCABTTB" ] = "TitanBar";
L[ "MCRC" ] = "Refresh ...";

-- Background window
L[ "BWTitle" ] = "Set back color";
L[ "BWAlpha" ] = "Alpha";
L[ "BWCurSetColor" ] = "Currently set color";
L[ "BWApply" ] = " Apply color to all elements";
L[ "BWSave" ] = "Save color";
L[ "BWDef" ] = "Default";
L[ "BWBlack" ] = "Black";
L[ "BWTrans" ] = "Transparent";

-- Wallet infos window
L[ "WIt" ] = "Right click a currency name to get its settings";
L[ "WIot" ] = "On TitanBar";
L[ "WIiw" ] = "In tooltip";
L[ "WIds" ] = "Don't show";
L[ "WInc" ] = "You track no currency!\nLeft click to see the currency list.";

-- Money infos window
L[ "MIWTitle" ] = "Coin";
L[ "MIWTotal" ] = "Total";
L[ "MIWAll" ] = "Show total on TitanBar";
L[ "MIWCM" ] = "Show player money";
L[ "MIWCMAll" ] = "Show to all your character";
L[ "MIWSSS" ] = "Show session statistics in tooltip";
L[ "MIWSTS" ] = "Show today statistics in tooltip";
L[ "MIWID" ] = " wallet info deleted!"
L[ "MIMsg" ] = "No wallet info was found!"
L[ "MISession" ] = "Session";
L[ "MIDaily" ] = "Today";
L[ "MIStart" ] = "Starting";
L[ "MIEarned" ] = "Earned";
L[ "MISpent" ] = "Spent";
--L[ "MITotEarned" ] = "Total earned";
--L[ "MITotSpent" ] = "Total spent";

-- Vault window
L[ "VTh" ] = "vault";
L[ "VTnd" ] = "No data was found for this character";
L[ "VTID" ] = " vault info deleted!"
L[ "VTSe" ] = "Search:"
L[ "VTAll" ] = "-- All --"

-- Shared Storage window
L[ "SSh" ] = "shared storage";
L[ "SSnd" ] = "Need to open your shared storage at least once";

-- Backpack window
L[ "BIh" ] = "backpack";
L[ "BID" ] = " bags info deleted!"

-- Bank window
L[ "BKh" ] = "bank";

-- Day & Night window
L[ "Dawn" ] = "Dawn";
L[ "Morning" ] = "Morning";
L[ "Noon" ] = "Noon";
L[ "Afternoon" ] = "Afternoon";
L[ "Dusk" ] = "Dusk";
L[ "Gloaming" ] = "Gloaming";
L[ "Evening" ] = "Evening";
L[ "Midnight" ] = "Midnight";
L[ "LateWatches" ] = "Late Watches";
L[ "Foredawn" ] = "Foredawn";
L[ "NextT" ] = "Show next time";
L[ "TAjustL" ] = "Timer seed";

-- Reputation window
L[ "RPt" ] = "select / unselect a faction\nright click to get its settings";
L[ "RPnf" ] = "You track no faction!\nLeft click to see the faction list.";
L[ "RPPHMaxHide" ] = "Hide factions at maximum reputation";

-- All reputation names
L[ "RPMB" ]    = "Men of Bree";
L[ "RPTH" ]    = "Thorin's Hall";
L[ "RPTMS" ]   = "The Mathom Society";
L[ "RPRE" ]    = "Rangers of Esteld\195\173n";
L[ "RPER" ]    = "Elves of Rivendell";
L[ "RPTEl" ]   = "The Eldgang";
L[ "RPCN" ]    = "Council of the North";
L[ "RPTWA" ]   = "The Wardens of Ann\195\186minas";
L[ "RPLF" ]    = "Lossoth of Forochel";
L[ "RPTEg" ]   = "The Eglain";
L[ "RPIGG" ]   = "Iron Garrison Guards";
L[ "RPIGM" ]   = "Iron Garrison Miners";
L[ "RPAME" ]   = "Algraig, Men of Enedwaith";
L[ "RPTGC" ]   = "The Grey Company";
L[ "RPG" ]     = "Galadhrim";
L[ "RPM" ]     = "Malledhrim";
L[ "RPTRS" ]   = "The Riders of Stangard";
L[ "RPHLG" ]   = "Heroes of Limlight Gorge";
L[ "RPMD" ]    = "Men of Dunland";
L[ "RPTR" ]    = "Th\195\169odred's Riders";
L[ "RPJG" ]    = "Jeweller's Guild";
L[ "RPCG" ]    = "Cook's Guild";
L[ "RPSG" ]    = "Scholar's Guild";
L[ "RPTG" ]    = "Tailor's Guild";
L[ "RPWoG" ]   = "Woodworker's Guild";
L[ "RPWeG" ]   = "Weaponsmith's Guild";
L[ "RPMG" ]    = "Metalsmith's Guild";
L[ "RPMEV" ]   = "Men of the Entwash Vale";
L[ "RPMN" ]    = "Men of the Norcrofts";
L[ "RPMS" ]    = "Men of the Sutcrofts";
L[ "RPMW" ]    = "Men of the Wold";
L[ "RPPW" ]    = "People of Wildermore";
L[ "RPSW" ]    = "Survivors of Wildermore";
L[ "RPTEo" ]   = "The Eorlingas";
L[ "RPTHe" ]   = "The Helmingas";
L[ "RPTEFF" ]  = "The Ents of Fangorn Forest";
L[ "RPDA" ]    = "Dol Amroth";
L[ "RPDAA" ]   = "Dol Amroth - Armoury";
L[ "RPDAB" ]   = "Dol Amroth - Bank";
L[ "RPDAD" ]   = "Dol Amroth - Docks";
L[ "RPDAGH" ]  = "Dol Amroth - Great Hall";
L[ "RPDAL" ]   = "Dol Amroth - Library";
L[ "RPDAW" ]   = "Dol Amroth - Warehouse";
L[ "RPDAM" ]   = "Dol Amroth - Mason";
L[ "RPDAS" ]   = "Dol Amroth - Swan-knights";
L[ "RPMRV" ]   = "Men of Ringl\195\179 Vale";
L[ "RPMDE" ]   = "Men of Dor-en-Ernil";
L[ "RPML" ]    = "Men of Lebennin";
L[ "RPP" ]     = "Pelargir";
L[ "RPRI" ]    = "Rangers of Ithilien";
L[ "RPDMT" ]   = "Defenders of Minas Tirith";
L[ "RPRR" ]    = "Riders of Rohan";
L[ "RPHOTW" ]  = "Host of the West";
L[ "RPHOTWA" ] = "Host of the West: Armour";
L[ "RPHOTWW" ] = "Host of the West: Weapons";
L[ "RPHOTWP" ] = "Host of the West: Provisions";
L[ "RPCOG" ]   = "Conquest of Gorgoroth";
L[ "RPEOFBs" ] = "Enmity of Fushaum Bal south";
L[ "RPEOFBn" ] = "Enmity of Fushaum Bal north";
L[ "RPRSC" ]   = "Red Sky Clan";
L[ "RPDOE" ]   = "Dwarves of Erebor";
L[ "RPEOF" ]   = "Elves of Felegoth";
L[ "RPMOD" ]   = "Men of Dale";
L[ "RPCCLE" ]  = "Chicken Chasing League of Eriador";
L[ "RPTAA" ]   = "The Ale Association";
L[ "RPTIL" ]   = "The Inn League";
L[ "RPGME" ]   = "Grey Mountains Expedition";
L[ "RPWF" ]    = "Wilderfolk";
L[ "RPTGA" ]   = "The Great Alliance";
L[ "RPTWC" ]   = "The White Company";
L[ "RPRMI" ]   = "Reclamation of Minas Ithil";
L[ "RPPOW" ]   = "Protectors of Wilderland";
L[ "RPMOG" ]   = "March on Gundabad";
L[ "RPGA" ]    = "The Gabil'akk\195\162";
L[ "RPWB"]	   = "Woodcutter's Brotherhood";
L[ "RPLOTA"]   = "The League of the Axe";
L[ "RPHOT" ]   = "The Haban'akk\195\162 of Thr\195\161in"; 
L[ "RPKU" ]    = "Kharum-ubn\195\162r";
L[ "RPROFMH" ] = "Reclaimers of the Mountain-hold";
L[ "RPDOTA" ]  = "Defenders of The Angle";
L[ "RPTYW" ]   = "The Yonder-watch";
L[ "RPDOC" ]   = "Dúnedain of Cardolan";
L[ "RPACC" ]   = "Reputation Acceleration";

-- All reputation standings
L[ "RPMSR" ]  = "Maximum standing reached"
L[ "RPGL1" ]  = "Neutral";
L[ "RPGL2" ]  = "Acquaintance";
L[ "RPGL3" ]  = "Friend";
L[ "RPGL4" ]  = "Ally";
L[ "RPGL5" ]  = "Kindred";
L[ "RPGL6" ]  = "Respected";
L[ "RPGL7" ]  = "Honoured";
L[ "RPGL8" ]  = "Celebrated";
L[ "RPBL1" ]  = "Outsider";
L[ "RPBL2" ]  = "Enemy";
L[ "RPGG1" ]  = "Initiate";
L[ "RPGG2" ]  = "Apprentice";
L[ "RPGG3" ]  = "Journeyman";
L[ "RPGG4" ]  = "Expert";
L[ "RPGG5" ]  = "Artisan";
L[ "RPGG6" ]  = "Master";
L[ "RPGG7" ]  = "Eastemnet Master";
L[ "RPGG8" ]  = "Westemnet Master";
L[ "RPGG9" ]  = "Honoured Master";
L[ "RCCLE1" ] = "Rookie";
L[ "RCCLE2" ] = "Minor Leaguer";
L[ "RCCLE3" ] = "Major Leaguer";
L[ "RCCLE4" ] = "All-star";
L[ "RCCLE5" ] = "Hall of Famer";
L[ "RPBR" ]   = "Bonus Remaining";
L[ "RPMI1" ]  = "The Reclamation";
L[ "RPMI2" ]  = "The Reclamation Continues";
L[ "RPMI3" ]  = "The Trial of Wrath";
L[ "RPMI4" ]  = "The Reclamation Continues II";
L[ "RPMI5" ]  = "The Trial of Sorrow";
L[ "RPMI6" ]  = "The Reclamation Continues III";
L[ "RPMI7" ]  = "The Trial of Madness";
L[ "RPMI8" ]  = "The Reclamation Continues IV";
L[ "RPMI9" ]  = "The Trial of Despair";
L[ "RPMI10" ] = "The Trial of Death";
L[ "RPGA1" ] = "Idmul";
L[ "RPGA2" ] = "Dumul";
L[ "RPGA3" ] = "Izkhas";
L[ "RPGA4" ] = "Uzkhas";
L[ "RPGA5" ] = "Fabar\195\162l";
L[ "RPGA6" ] = "Azghzabad";

-- Reputation changes
L[ "RPDECREASE"] = "decreased";

-- Infamy/Renown window
if PlayerAlign == 1 then L[ "IFWTitle" ] = "Renown"; L[ "IFIF" ] = "Total renown:";
else L[ "IFWTitle" ] = "Infamy"; L[ "IFIF" ] = "Total infamy:"; end
L[ "IFCR" ] = "Your rank:";
L[ "IFTN" ] = "points for the next rank";

-- GameTime window
L[ "GTWTitle" ] = "Real/Server Time";
L[ "GTW24h" ] = "Show time in 24 hour format";
L[ "GTWSST" ] = "Show server time       GMT";
L[ "GTWSBT" ] = "Show real & server time";
L[ "GTWST" ] = "Server: ";
L[ "GTWRT" ] = "Real: ";

-- More Options window
L[ "OPWTitle" ] = L[ "MOP" ];
L[ "OPHText" ] = "Height:";
L[ "OPFText" ] = "Font:";
L[ "OPAText" ] = "Auto hide:";
L[ "OPAHD" ] = "Disabled";
L[ "OPAHE" ] = "Always";
L[ "OPAHC" ] = "Only in combat";
L[ "OPIText" ] = "Icon size:";
L[ "OPTBTop" ] = "At top of screen";
L[ "OPISS" ] = "Small";
L[ "OPISM" ] = "Medium";
L[ "OPISL" ] = "Large";
L[ "Layout" ] = "Alternative PlayerInfo Layout\n(Reloads TB after changing)";

-- Profile window
L[ "PWProfile" ] = "Profile";
L[ "PWEPN" ] = "Enter a profile name";
L[ "PWCreate" ] = "Create";
L[ "PWNew" ] = "New profile";
L[ "PWCreated" ] = "has been created";
L[ "PWLoad" ] = "Load";
L[ "PWNFound" ] = "No profile was found";
L[ "PWFail" ] = " cannot be loaded because the language of the game is not the same language of this profile";
L[ "PWLoaded" ] = "loaded";
L[ "PWDelete" ] = "Delete";
L[ "PWDeleteFailed" ] = "Failed to delete profile ";
L[ "PWFailDelete" ] = " cannot be deleted because the language of the game is not the same language of this profile";
L[ "PWDeleted" ] = "deleted";
L[ "PWSave" ] = "Save";
L[ "PWSaved" ] = "saved";
L[ "PWCancel" ] = "Cancel";

-- Shell commands window
L[ "SCWTitle" ] = "TitanBar Shell Commands";
L[ "SCWC1" ] = "Show TitanBar Options";
L[ "SCWC2" ] = "Unload TitanBar";
L[ "SCWC3" ] = "Reload TitanBar";
L[ "SCWC4" ] = "Reset all settings to default";

-- Shell commands
L[ "SC0" ] = "Command not supported";
L[ "SCa1" ] = "options";
L[ "SCb1" ] = "opt / ";
L[ "SCa2" ] = "unload";
L[ "SCb2" ] = "  u / ";
L[ "SCa3" ] = "reload";
L[ "SCb3" ] = "  r / ";
L[ "SCa4" ] = "resetall";
L[ "SCb4" ] = " ra / ";

-- Durability infos window
L[ "DWTitle" ] = "Durability infos";
L[ "DWLbl" ] = " damaged item";
L[ "DWLbls" ] = " damaged items";
L[ "DWLblND" ] = "All your items are at 100%";
L[ "DIIcon" ] = "Show icon in tooltip";
L[ "DIText" ] = "Show item name in tooltip";
L[ "DWnint" ] = "Not showing icon & item name";

-- Equipment infos window
--L[ "EWTitle" ] = "Equipment infos";
L[ "EWLbl" ] = "Items currently on your character";
L[ "EWLblD" ] = "Score";
L[ "EWItemNP" ] = " Item not present";
--L[ "EWItemF" ] = " item was found";
--L[ "EWItemsF" ] = " items was found";
L[ "EWST1" ] = "Head";
L[ "EWST13" ] = "Left Earring";
L[ "EWST14" ] = "Right Earring";
L[ "EWST10" ] = "Necklace";
L[ "EWST6" ] = "Shoulder";
L[ "EWST7" ] = "Back";
L[ "EWST2" ] = "Chest";
L[ "EWST8" ] = "Left Bracelet";
L[ "EWST9" ] = "Right Bracelet";
L[ "EWST11" ] = "Left Ring";
L[ "EWST12" ] = "Right Ring";
L[ "EWST4" ] = "Gloves";
L[ "EWST3" ] = "Legs";
L[ "EWST5" ] = "Feet";
L[ "EWST15" ] = "Pocket";
L[ "EWST16" ] = "Primary Weapon";
L[ "EWST17" ] = "Secondary Weapon/Shield";
L[ "EWST18" ] = "Ranged Weapon";
L[ "EWST19" ] = "Craft Tool";
L[ "EWST20" ] = "Class";

-- Player Infos control
--L[ "PINAME" ] = "Your name";
--L[ "PILVL" ] = "Your level";
--L[ "PIICON" ] = "Your are a ";
L[ "Morale" ] = "Morale";
L[ "Power" ] = "Power";
L[ "Armour" ] = "Armour";
L[ "Stats" ] = "Statistics";
L[ "Might" ] = "Might";
L[ "Agility" ] = "Agility";
L[ "Vitality" ] = "Vitality";
L[ "Will" ] = "Will";
L[ "Fate" ] = "Fate";
L[ "Finesse" ] = "Finesse";
L[ "Mitigations" ] = "Mitigations";
L[ "Common" ] = "Common";
L[ "Fire" ] = "Fire";
L[ "Frost" ] = "Frost";
L[ "Shadow" ] = "Shadow";
L[ "Lightning" ] = "Lightning";
L[ "Acid" ] = "Acid";
L[ "Physical" ] = "Physical";
L[ "Tactical" ] = "Tactical";
L[ "Healing" ] = "Healing";
L[ "Outgoing" ] = "Outgoing";
L[ "Incoming" ] = "Incoming";
L[ "Avoidances" ] = "Avoidances";
L[ "Block" ] = "Block";
L[ "Parry" ] = "Parry";
L[ "Evade" ] = "Evade";
L[ "Resistances" ] = "Resistance";
L[ "Base" ] = "Base";
L[ "CritAvoid" ] = "Crit. Defence";
L[ "CritChance" ] = "Crit. Chance";
L[ "Mastery" ] = "Mastery";
L[ "Level" ] = "Level";
L[ "Race" ] = "Race";
L[ "Class" ] = "Class";
L[ "XP" ] = "Exp.";
L[ "NXP" ] = "Next lvl at";
L[ "MLvl" ] = "Maximum level reached";
L[ "Offence" ] = "Offence";
L[ "Defence" ] = "Defence";
L[ "Wrath" ] = "Wrath";
L[ "Orc" ] = "Orc-craft";
L[ "Fell" ] = "Fell-wrought";
L[ "Melee" ] = "Melee dam.";
L[ "Ranged" ] = "Ranged dam.";
L[ "CritHit" ] = "Crit. hit";
L[ "CritMag" ] = "Crit. mag.";
L[ "DevHit" ] = "Dev. hit";
L[ "DevMag" ] = "Dev. mag.";
L[ "CritDef" ] = "Crit. defence";
L[ "Partial" ] = "partial";
L[ "PartMit" ] = "part.mit.";
L[ "Capped1" ] = "Yellow - capped";
L[ "Capped2" ] = "Orange - T2 capped";
L[ "Capped3" ] = "Red - T3+ capped";
L[ "Capped4" ] = "Purple - Enh III capped";
L[ "CalcStatDependency" ] = "This window requires CalcStat to be installed";

-- Money Infos control
L[ "MGh" ] = "Quantity of gold";
L[ "MSh" ] = "Quantity of silver";
L[ "MCh" ] = "Quantity of copper";
L[ "MGB" ] = "Bag of Gold Coins"; -- Thx Heridan!
L[ "MSB" ] = "Bag of Silver Coins"; -- Thx Heridan!
L[ "MCB" ] = "Bag of Copper Coins"; -- Thx Heridan!

-- Bag Infos control
--L[ "BIh" ] = "Backpack informations";
--L[ "BIt1" ] = "Number of occupied slots/max";
L[ "BINI" ] = "You're tracking no items!\nLeft click to see your items."
L[ "BIIL" ] = "Items list"
L[ "BIT" ] = "Select / unselect an item"
L[ "BIUsed" ] = " Show used over free slots";
L[ "BIMax" ] = " Show total bag slots";
L[ "BIMsg" ] = "No stackable item was found in your bag!"

-- Equipment Infos control
L[ "EIh" ] = "Points for all your equipment";
L[ "EIt1" ] = "Left click to open the options window";
L[ "EIt2" ] = "Hold left click to move the control";
L[ "EIt3" ] = "Right click to open the control menu";

-- Durability Infos control
L[ "DIh" ] = "Durability of all your equipment";

-- Player Location control
L[ "PLh" ] = "This is where you are";
L[ "PLMsg" ] = "Enter a City!";

-- Game Time control
L[ "GTh" ] = "Real/Server Time";

-- Chat message
L[ "TBR" ] = "TitanBar: All my settings are set back to default";

-- Player Race names: 'PR' + Race Id
-- Add appropriate Race Id entry for new/unknown races.
-- Unlisted Race Id's show up in the Player infos tooltip.
L[ "PR65" ] = "Elf";
L[ "PR23" ] = "Man";
L[ "PR73" ] = "Dwarf";
L[ "PR81" ] = "Hobbit";
L[ "PR114" ] = "Beorning";
L[ "PR117" ] = "High Elf";
L[ "PR120" ] = "Stout-axe";
L[ "PR125" ] = "River Hobbit";
L[ "PR7" ] = "Orc";
L[ "PR6" ] = "Uruk";
L[ "PR12" ] = "Spider";
L[ "PR66" ] = "Warg";
L[ "PR27" ] = "Critter";

-- Player Class names: 'PC' + Class Id
-- Add appropriate Class Id entry for new/unknown classes.
-- Unlisted Class Id's show up in the Player infos tooltip.
L[ "PC40" ] = "Burglar";
L[ "PC24" ] = "Captain";
L[ "PC172" ] = "Champion";
L[ "PC23" ] = "Guardian";
L[ "PC162" ] = "Hunter";
L[ "PC185" ] = "Lore-Master";
L[ "PC31" ] = "Minstrel";
L[ "PC193" ] = "Rune-Keeper";
L[ "PC194" ] = "Warden";
L[ "PC214" ] = "Beorning";
L[ "PC215" ] = "Brawler";
L[ "PC216" ] = "Mariner";
L[ "PC71" ] = "Reaver";
L[ "PC127" ] = "Weaver";
L[ "PC179" ] = "Blackarrow";
L[ "PC52" ] = "Warleader";
L[ "PC126" ] = "Stalker";
L[ "PC128" ] = "Defiler";
L[ "PC192" ] = "Chicken";

-- Durability
L[ "D" ] = "Durability";
L[ "D1" ] = "All Durability";
L[ "D2" ] = "Weak";
L[ "D3" ] = "Substantial";
L[ "D4" ] = "Brittle";
L[ "D5" ] = "Normal";
L[ "D6" ] = "Tough";
L[ "D7" ] = "Filmsy";
L[ "D8" ] = "Indestructible";

-- Quality
L[ "Q" ] = "Quality";
L[ "Q1" ] = "All Quality";
L[ "Q2" ] = "Common";
L[ "Q3" ] = "UnCommon";
L[ "Q4" ] = "Incomparable";
L[ "Q5" ] = "Rare";
L[ "Q6" ] = "Legendary";
