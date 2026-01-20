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
L[ "MGiftGiversBrand" ] = "Gift-giver's Brand";
L[ "GiftGiversBrandh" ] = "These are your Gift-giver's Brands";
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
-- Sand-worn Copper Token
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
-- Phial of Crimson Extract
L[ "MPhialCrimsonExtract" ] = "Phial of Crimson Extract";
L[ "PhialCrimsonExtracth" ] = "Your Phials of Crimson Extract";
-- Phial of Umber Extract
L[ "MPhialUmberExtract" ] = "Phial of Umber Extract";
L[ "PhialUmberExtracth" ] = "Your Phials of Umber Extract";
-- Phial of Verdant Extract
L[ "MPhialVerdantExtract" ] = "Phial of Verdant Extract";
L[ "PhialVerdantExtracth" ] = "Your Phials of Verdant Extract";
-- Phial of Golden Extract
L[ "MPhialGoldenExtract" ] = "Phial of Golden Extract";
L[ "PhialGoldenExtracth" ] = "Your Phials of Golden Extract";
-- Phial of Violet Extract
L[ "MPhialVioletExtract" ] = "Phial of Violet Extract";
L[ "PhialVioletExtracth" ] = "Your Phials of Violet Extract";
-- Phial of Amber Extract
L[ "MPhialAmberExtract" ] = "Phial of Amber Extract";
L[ "PhialAmberExtracth" ] = "Your Phials of Amber Extract";
-- Phial of Sapphire Extract
L[ "MPhialSapphireExtract" ] = "Phial of Sapphire Extract";
L[ "PhialSapphireExtracth" ] = "Your Phials of Sapphire Extract";
-- Shagâni Ghín
L["MShaganiGhin"] = "Shagâni Ghín";
L["ShaganiGhinh"] = "Your Shagâni Ghín"
-- Hamâti Urgûl
L["MHamatiUrgul"] = "Hamâti Urgûl";
L["HamatiUrgulh"] = "Your Hamâti Urgûl";
-- Mûr Ghala Sârz
L["MMurGhalaSarz"] = "Mûr Ghala Sârz";
L["MurGhalaSarzh"] = "Your Mûr Ghala Sârzai";
-- Silver Serpent
L["MSilverSerpent"] = "Silver Serpent";
L["SilverSerpenth"] = "Your Silver Serpents";
-- Hunter's Guild Mark
L["MHuntersGuildMark"] = "Hunter's Guild Mark";
L["HuntersGuildMarkh"] = "Your Hunter's Guild Marks";
-- Blighted Relic
L["MBlightedRelic"] = "Blighted Relic";
L["BlightedRelich"] = "Your Blighted Relics";
-- Tattered Shadows
L["MTatteredShadow"] = "Tattered Shadow";
L["TatteredShadowh"] = "Your Tattered Shadows";
-- Fangorn Leaf
L["MFangornLeaf"] = "Fangorn Leaf";
L["FangornLeafh"] = "Your Fangorn Leaves";

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
L[ "MISession" ] = "Session Statistics";
L[ "MIDaily" ] = "Today Statistics";
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
L[ "RPPHMaxShow" ] = "Show factions at maximum reputation";

-- All reputation names
L[ "MenOfBree" ]    = "Men of Bree";
L[ "ThorinsHall" ]    = "Thorin's Hall";
L[ "TheMathomSociety" ]   = "The Mathom Society";
L[ "RangersOfEsteldin" ]    = "Rangers of Esteld\195\173n";
L[ "ElvesOfRivendell" ]    = "Elves of Rivendell";
L[ "TheEldgang" ]   = "The Eldgang";
L[ "CouncilOfTheNorth" ]    = "Council of the North";
L[ "TheWardensOfAnnuminas" ]   = "The Wardens of Ann\195\186minas";
L[ "LossothOfForochel" ]    = "Lossoth of Forochel";
L[ "TheEglain" ]   = "The Eglain";
L[ "IronGarrisonGuards" ]   = "Iron Garrison Guards";
L[ "IronGarrisonMiners" ]   = "Iron Garrison Miners";
L[ "AlgraigMenOfEnedwaith" ]   = "Algraig, Men of Enedwaith";
L[ "TheGreyCompany" ]   = "The Grey Company";
L[ "Galadhrim" ]     = "Galadhrim";
L[ "Malledhrim" ]     = "Malledhrim";
L[ "TheRidersOfStangard" ]   = "The Riders of Stangard";
L[ "HeroesOfLimlightGorge" ]   = "Heroes of Limlight Gorge";
L[ "MenOfDunland" ]    = "Men of Dunland";
L[ "TheodredsRiders" ]    = "Th\195\169odred's Riders";
L[ "JewellersGuild" ]    = "Jeweller's Guild";
L[ "CooksGuild" ]    = "Cook's Guild";
L[ "ScholarsGuild" ]    = "Scholar's Guild";
L[ "TailorsGuild" ]    = "Tailor's Guild";
L[ "WoodworkersGuild" ]   = "Woodworker's Guild";
L[ "WeaponsmithsGuild" ]   = "Weaponsmith's Guild";
L[ "MetalsmithsGuild" ]    = "Metalsmith's Guild";
L[ "MenOfTheEntwashVale" ]   = "Men of the Entwash Vale";
L[ "MenOfTheNorcrofts" ]    = "Men of the Norcrofts";
L[ "MenOfTheSutcrofts" ]    = "Men of the Sutcrofts";
L[ "MenOfTheWold" ]    = "Men of the Wold";
L[ "PeopleOfWildermore" ]    = "People of Wildermore";
L[ "SurvivorsOfWildermore" ]    = "Survivors of Wildermore";
L[ "TheEorlingas" ]   = "The Eorlingas";
L[ "TheHelmingas" ]   = "The Helmingas";
L[ "TheEntsOfFangornForest" ]  = "The Ents of Fangorn Forest";
L[ "DolAmroth" ]    = "Dol Amroth";
L[ "DolAmrothArmoury" ]   = "Dol Amroth - Armoury";
L[ "DolAmrothBank" ]   = "Dol Amroth - Bank";
L[ "DolAmrothDocks" ]   = "Dol Amroth - Docks";
L[ "DolAmrothGreatHall" ]  = "Dol Amroth - Great Hall";
L[ "DolAmrothLibrary" ]   = "Dol Amroth - Library";
L[ "DolAmrothWarehouse" ]   = "Dol Amroth - Warehouse";
L[ "DolAmrothMason" ]   = "Dol Amroth - Mason";
L[ "DolAmrothSwanKnights" ]   = "Dol Amroth - Swan-knights";
L[ "MenOfRingloVale" ]   = "Men of Ringl\195\179 Vale";
L[ "MenOfDorEnErnil" ]   = "Men of Dor-en-Ernil";
L[ "MenOfLebennin" ]    = "Men of Lebennin";
L[ "Pelargir" ]     = "Pelargir";
L[ "RangersOfIthilien" ]    = "Rangers of Ithilien";
L[ "DefendersOfMinasTirith" ]   = "Defenders of Minas Tirith";
L[ "RidersOfRohan" ]    = "Riders of Rohan";
L[ "HostOfTheWest" ]  = "Host of the West";
L[ "HostOfTheWestArmour" ] = "Host of the West: Armour";
L[ "HostOfTheWestWeapons" ] = "Host of the West: Weapons";
L[ "HostOfTheWestProvisions" ] = "Host of the West: Provisions";
L[ "ConquestOfGorgoroth" ]   = "Conquest of Gorgoroth";
L[ "EnmityOfFushaumBalSouth" ] = "Enmity of Fushaum Bal south";
L[ "EnmityOfFushaumBalNorth" ] = "Enmity of Fushaum Bal north";
L[ "RedSkyClan" ]   = "Red Sky Clan";
L[ "DwarvesOfErebor" ]   = "Dwarves of Erebor";
L[ "ElvesOfFelegoth" ]   = "Elves of Felegoth";
L[ "MenOfDale" ]   = "Men of Dale";
L[ "ChickenChasingLeagueOfEriador" ]  = "Chicken Chasing League of Eriador";
L[ "TheAleAssociation" ]   = "The Ale Association";
L[ "TheInnLeague" ]   = "The Inn League";
L[ "GreyMountainsExpedition" ]   = "Grey Mountains Expedition";
L[ "Wilderfolk" ]    = "Wilderfolk";
L[ "TheGreatAlliance" ]   = "The Great Alliance";
L[ "TheWhiteCompany" ]   = "The White Company";
L[ "ReclamationOfMinasIthil" ]   = "Reclamation of Minas Ithil";
L[ "ProtectorsOfWilderland" ]   = "Protectors of Wilderland";
L[ "MarchOnGundabad" ]   = "March on Gundabad";
L[ "TheGabilakka" ]    = "The Gabil'akk\195\162";
L[ "WoodcuttersBrotherhood"]	   = "Woodcutter's Brotherhood";
L[ "TheLeagueOfTheAxe"]   = "The League of the Axe";
L[ "TheHabanakkaOfThrain" ]   = "The Haban'akk\195\162 of Thr\195\161in"; 
L[ "KharumUbnar" ]    = "Kharum-ubn\195\162r";
L[ "ReclaimersOfTheMountainHold" ] = "Reclaimers of the Mountain-hold";
L[ "DefendersOfTheAngle" ]  = "Defenders of The Angle";
L[ "TheYonderWatch" ]   = "The Yonder-watch";
L[ "DunedainOfCardolan" ]   = "Dúnedain of Cardolan";
L[ "ReputationAcceleration" ]   = "Reputation Acceleration";

L["StewardsOfTheIronHome"] = "Stewards of the Iron-home"
L["TownsfolkOfTheKingstead"] = "Townsfolk of the Kingstead"
L["TownsfolkOfTheEastfold"] = "Townsfolk of the Eastfold"
L["TheRenewalOfGondor"] = "The Renewal of Gondor"
L["UmbarCooksGuild"] = "Umbar Cook's Guild"
L["UmbarJewellersGuild"] = "Umbar Jeweller's Guild"
L["UmbarMetalsmithsGuild"] = "Umbar Metalsmith's Guild"
L["UmbarScholarsGuild"] = "Umbar Scholar's Guild"
L["UmbarTailorsGuild"] = "Umbar Tailor's Guild"
L["UmbarWeaponsmithsGuild"] = "Umbar Weaponsmith's Guild"
L["UmbarWoodworkersGuild"] = "Umbar Woodworker's Guild"
L["CitizensOfUmbarBaharbel"] = "Citizens of Umbar Baharbêl"
L["PhetekariOfUmbar"] = "Phetekâri of Umbar"
L["TheIkorbani"] = "The Ikorbâni"
L["TheAdurhid"] = "The Adúrhid"
L["ThePathOfValour"] = "The Path of Valour"
L["AmeliasStudies"] = "Amelia's Studies"
L["MoriaBountyHunters"] = "Moria Bounty Hunters"
L["KintaiOfSulMadash"] = "Kintai of Sul Madásh"
L["CityOfZajana"] = "City of Zajâna"
L["TemamirOfJiretMenesh"] = "Temámir of Jiret-menêsh"
L["HamatRenewed"] = "Hamât Renewed"
L["HuntersGuildOfMurGhala"] = "Hunter's Guild of Mûr Ghala"

-- All reputation standings
L[ "RPMSR" ]  = "Maximum standing reached"
L[ "Neutral" ]  = "Neutral";
L[ "Acquaintance" ]  = "Acquaintance";
L[ "Friend" ]  = "Friend";
L[ "Ally" ]  = "Ally";
L[ "Kindred" ]  = "Kindred";
L[ "Respected" ]  = "Respected";
L[ "Honoured" ]  = "Honoured";
L[ "Celebrated" ]  = "Celebrated";
L[ "Outsider" ]  = "Outsider";
L[ "Enemy" ]  = "Enemy";
L[ "Member" ] = "Member";
L[ "GuildInitiate" ]  = "Initiate";
L[ "ApprenticeOfTheGuild" ]  = "Apprentice";
L[ "JourneymanOfTheGuild" ]  = "Journeyman";
L[ "ExpertOfTheGuild" ]  = "Expert";
L[ "ArtisanOfTheGuild" ]  = "Artisan";
L[ "MasterOfTheGuild" ]  = "Master";
L[ "EastemnetMasterOfTheGuild" ]  = "Eastemnet Master";
L[ "WestemnetMasterOfTheGuild" ]  = "Westemnet Master";
L[ "HonouredMasterOfTheGuild" ]  = "Honoured Master";
L[ "UmbarGuildMember" ]  = "Umbar Guild Member";
L[ "Rookie" ] = "Rookie";
L[ "MinorLeaguer" ] = "Minor Leaguer";
L[ "MajorLeaguer" ] = "Major Leaguer";
L[ "AllStar" ] = "All-star";
L[ "HallOfFamer" ] = "Hall of Famer";
L[ "BonusRemaining" ]   = "Bonus Remaining";
L[ "TheReclamation" ]  = "The Reclamation";
L[ "TheReclamationContinues" ]  = "The Reclamation Continues";
L[ "TheTrialOfWrath" ]  = "The Trial of Wrath";
L[ "TheReclamationContinuesIi" ]  = "The Reclamation Continues II";
L[ "TheTrialOfSorrow" ]  = "The Trial of Sorrow";
L[ "TheReclamationContinuesIii" ]  = "The Reclamation Continues III";
L[ "TheTrialOfMadness" ]  = "The Trial of Madness";
L[ "TheReclamationContinuesIv" ]  = "The Reclamation Continues IV";
L[ "TheTrialOfDespair" ]  = "The Trial of Despair";
L[ "TheTrialOfDeath" ] = "The Trial of Death";
L[ "Idmul" ] = "Idmul";
L[ "Dumul" ] = "Dumul";
L[ "Izkhas" ] = "Izkhas";
L[ "Uzkhas" ] = "Uzkhas";
L[ "Fabaral" ] = "Fabar\195\162l";
L[ "Azghzabad" ] = "Azghzabad";

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
L[ "PICHAR" ]  = "Character";
L[ "PIRACE" ]  = "Race";
L[ "PICLASS" ]  = "Class";
L[ "PILEVEL" ]  = "Level";
L[ "PILVLXP" ]  = "LvlXP req/acquired";
L[ "PILVLXPCAP" ] = "at cap"
L[ "PILIREF" ]  = "Li Reforge";
L[ "PILIREFFMT" ]  = "iLvl #iLvl @ #cLvl";
L[ "PIVITALS" ]  = "Vital Stats";
L[ "PICURR" ] = "Curr.";
L[ "PIMORALE" ]  = "Max Morale";
L[ "PIICMR" ]  = "ICMR";
L[ "PINCMR" ]  = "NCMR";
L[ "PIPOWER" ]  = "Max Power";
L[ "PIICPR" ]  = "ICPR";
L[ "PINCPR" ]  = "NCPR";
L[ "PIMAIN" ]  = "Main Stats";
L[ "PIMIGHT" ]  = "Might";
L[ "PIAGILITY" ] = "Agility";
L[ "PIVITALITY" ] = "Vitality";
L[ "PIWILL" ] = "Will";
L[ "PIFATE" ] = "Fate";
L[ "PIOFFENCE" ] = "Offence";
L[ "PICURRAT" ] = "Curr.#";
L[ "PICURPERC" ] = "-> %";
L[ "PICAPRAT" ] = "Cap #";
L[ "PICAPPERC" ] = "-> %";
L[ "PIMELDMG" ] = "Melee Dam.";
L[ "PIRNGDMG" ] = "Ranged Dam.";
L[ "PITACDMG" ] = "Tactical Dam.";
L[ "PICRITHIT" ] = "Crit. Hit";
L[ "PIDEVHIT" ] = "Dev. Hit";
L[ "PICRITMAGN" ] = "Crit. Magn.";
L[ "PIFINESSE" ] = "Finesse";
L[ "PIHEALING" ] = "Healing";
L[ "PIOUTHEAL" ] = "Outgoing";
L[ "PIINHEAL" ] = "Incoming";
L[ "PIDEFENCE" ] = "Defence";
L[ "PICRITDEF" ] = "Crit. Defence";
L[ "PIRESIST" ] = "Resistance";
L[ "PICAPPED1" ] = "Yellow - capped";
L[ "PICAPPED2" ] = "Orange - T2 capped";
L[ "PICAPPED3" ] = "Red - T3+ capped";
L[ "PICAPPED4" ] = "Purple - Enh III capped";
L[ "PICSDEP" ] = "This window requires CalcStat to be installed."
L[ "PIAVOID" ] = "Avoidances";
L[ "PIBLOCK" ] = "Block";
L[ "PIBLOCKPART" ] = "Partial";
L[ "PIBLOCKPMIT" ] = "Part.mit.";
L[ "PIPARRY" ] = "Parry";
L[ "PIPARRYPART" ] = "Partial";
L[ "PIPARRYPMIT" ] = "Part.mit.";
L[ "PIEVADE" ] = "Evade";
L[ "PIEVADEPART" ] = "Partial";
L[ "PIEVADEPMIT" ] = "Part.mit.";
L[ "PIMITS" ] = "Mitigations";
L[ "PIPHYMIT" ] = "Physical";
L[ "PIORCMIT" ] = "Orc-craft";
L[ "PIFWMIT" ] = "Fell-wrought";
L[ "PITACMIT" ] = "Tactical";
L[ "PIFIREMIT" ] = "Fire";
L[ "PILIGHTNMIT" ] = "Lightning";
L[ "PIFROSTMIT" ] = "Frost";
L[ "PIACIDMIT" ] = "Acid";
L[ "PISHADMIT" ] = "Shadow";
L[ "PINOTAVAIL" ] = "N/A";

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
