-- fr.lua
-- Written by Habna -- Translated with Google, Talyrion1003
-- Rewritten by many

_G.L = {};
L[ "TBLoad" ] = "TitanBar " .. Version .. " charg\195\169e!";
L[ "TBSSCS" ] = "TitanBar: La taille de l'\195\169cran a chang\195\169, reposionnement des contr\195\180les...";
L[ "TBSSCD" ] = "TitanBar: fini!";
L[ "TBOpt" ] = "Les options sont disponibles via le clic droit sur TitanBar";

--Misc
L[ "NoData" ] = "Aucune autre donn\195\169e disponible dans l'API";
L[ "NA" ] = "N/D";
--L[ "dmg" ] = " dmg";
L[ "You" ] = "Toi: ";
L[ "ButDel" ] = "Effacer les infos de ce personnage";
--L[ "" ] = "";

-- TitanBar Menu
L[ "MBag" ] = "Porte-feuille";
L[ "MGSC" ] = "Votre argent";
L[ "MBI" ] = "Informations de vos sacs";
L[ "MPI" ] = "Information du joueur";
L[ "MEI" ] = "Points pour tous vos articles";
L[ "MDI" ] = "Durabilit\195\169s de vos articles";
L[ "MPL" ] = "Emplacement du joueur";
L[ "MGT" ] = "Heure";
L[ "MOP" ] = "Plus d'options";
L[ "MPP" ] = "Profile";
L[ "MSC" ] = "Commandes shell";
L[ "MRA" ] = "R\195\169initialiser les param\195\168tres";
L[ "MUTB" ] = "D\195\169charger";
L[ "MRTB" ] = "Recharger";
L[ "MATB" ] = "\195\128 propos de TitanBar ";
L[ "MBG" ] = "Changer l'arri\195\168re plan";
L[ "MCL" ] = "Changer la langue vers ...";
L[ "MCLen" ] = "l'anglais";
L[ "MCLfr" ] = "Fran\195\167ais";
L[ "MCLde" ] = "l'Allemand";
L[ "MTI" ] = "Suivre des articles";
--L[ "MView" ] = "Voir votre ";
L[ "MVault" ] = "Coffre";
L[ "MStorage" ] = "Stockage Partag\195\169";
--L[ "MBank" ] = "Banque";
L[ "MDayNight" ] = "Jour & Nuit";
L[ "MReputation" ] = "R\195\169putation";

-- Wallet Currency Controls
-- LOTRO Points control
L[ "MLotroPoints" ] = "Points LOTRO";
L[ "LotroPointsh" ] = "Ce sont vos points LOTRO";
-- Mithril Coins control
L[ "MMithrilCoins" ] = "Pi\195\168ce de mithril";
L[ "MithrilCoinsh" ] = "Ce sont vos Pi\195\168ces de mithril";
-- Yule Tokens control
L[ "MYuleToken" ] = "Jeton du festival de Yule";
L[ "YuleTokenh" ] = "Ce sont vos Jetons du festival de Yule";
-- Anniversary Tokens control
L[ "MAnniversaryToken" ] = "Jeton d'anniversaire";
L[ "AnniversaryTokenh" ] = "Ce sont vos Jetons d'anniversaire";
-- Bingo Badge control
L[ "MBingoBadge" ] = "Insigne de Bingo";
L[ "BingoBadgeh" ] = "These are your Insignes de Bingo";
-- Skirmish marks control
L[ "MSkirmishMarks" ] = "Marque";
L[ "SkirmishMarksh" ] = "Ce sont vos marques d'escarmouches";
-- Destiny Points control
L[ "MDestinyPoints" ] = "Points destin\195\169e";
L[ "DestinyPointsh" ] = "Ce sont vos points destin\195\169e";
-- Shards control
L[ "MShards" ] = "Eclat";
L[ "Shardsh" ] = "Ce sont vos Eclats";
-- Tokens of Hytbold control
L[ "MTokensOfHytbold" ] = "Jeton d'Hytbold";
L[ "TokensOfHytboldh" ] = "Ce sont vos Jetons d'Hytbold";
-- Medallions control
L[ "MMedallions" ] = "M\195\169daillon";
L[ "Medallionsh" ] = "Ce sont vos m\195\169daillons";
-- Seals control
L[ "MSeals" ] = "Sceau";
L[ "Sealsh" ] = "Ce sont vos sceaux";
-- Commendations control
L[ "MCommendation" ] = "Citation";
L[ "Commendationh" ] = "Ce sont vos Citations";
-- Amroth Silver Piece control
L[ "MAmrothSilverPiece" ] = "Pi\195\168ce d'argent d'Amroth";
L[ "AmrothSilverPieceh" ] = "Ce sont vos Pi\195\168ces d'argent d'Amroth";
-- Stars of Merit control
L[ "MStarsOfMerit" ] = "\195\137toile du m\195\169rite";
L[ "StarsOfMerith" ] = "Ce sont vos \195\137toiles du m\195\169rite";
-- Central Gondor Silver Piece control
L[ "MCentralGondorSilverPiece" ] = "Pi\195\168ce d'argent du Gondor central";
L[ "CentralGondorSilverPieceh" ] = "Ce sont vos Pi\195\168ces d'argent du gondor Central";
-- Gift giver's Brand control
L[ "MGiftgiversBrand" ] = "Marque du Donateur";
L[ "GiftgiversBrandh" ] = "Ce sont vos Marques du Donateur";
-- Motes of Enchantment control
L[ "MMotesOfEnchantment" ] = "Grain d\226\128\153enchantement";
L[ "MotesOfEnchantmenth" ] = "Ce sont vos Grains d'Enchantement";
-- Embers of Enchantment control
L[ "MEmbersOfEnchantment" ] = "Braise d\226\128\153enchantement";
L[ "EmbersOfEnchantmenth" ] = "Ce sont vos Braises d'Enchantement";
-- Figments of Splendour control
L[ "MFigmentsOfSplendour" ] = "Mirage de splendeur";
L[ "FigmentsOfSplendourh" ] = "Ce sont vos Mirages de Splendour";
-- Fall Festival Tokens control
L[ "MFallFestivalToken" ] = "Jeton du festival d'automne";
L[ "FallFestivalTokenh" ] = "Ce sont vos Jetons du Festival d'Automne";
-- Farmers Faire Tokens control
L[ "MFarmersFaireToken" ] = "Jeton de la Foire des fermiers";
L[ "FarmersFaireTokenh" ] = "Ce sont vos Jetons de la Foire des Fermiers";
-- Spring Leaves control
L[ "MSpringLeaf" ] = "Feuille de printemps";
L[ "SpringLeafh" ] = "Ce sont vos Feuille de Printemps";
-- Midsummer Tokens control
L[ "MMidsummerToken" ] = "Jeton du solstice d'\195\169t\195\169";
L[ "MidsummerTokenh" ] = "Ce sont vos Jetons du solstice d'été";
-- Ancient Script control
L[ "MAncientScript" ] = "\195\137criture ancienne";
L[ "AncientScripth" ] = "Ce sont vos \195\137criture ancienne";
-- Inn League / Ale Association control
L[ "MBadgeOfTaste" ] = "Médaille du goût";
L[ "BadgeOfTasteh" ] = "Ce sont vos Médailles du goût";
L[ "MBadgeOfDishonour" ] = "Médaille de la honte";
L[ "BadgeOfDishonourh" ] = "Ce sont vos Médailles de la honte";
-- Delving Writs
L[ "MDelvingWrit" ] = "Acte d'excavation";
L[ "DelvingWrith" ] = "Ce sont vos Actes d'excavation";
-- Cold-iron Tokens
L[ "MColdIronToken" ] = "Jeton en fer froid";
L[ "ColdIronTokenh" ] = "Ce sont vos Jeton en fer froid";
-- Token of Heroism
L[ "MTokenOfHeroism" ] = "Jeton d'héroïsme";
L[ "TokenOfHeroismh" ] = "Ce sont vos Jetons d'héroïsme";
-- Hero's Mark
L[ "MHerosMark" ] = "Marque de héros";
L[ "HerosMarkh" ] = "Ce sont vos Marques de héros";
-- Medallion of Moria
L[ "MMedallionOfMoria" ] = "Médaillon de la Moria";
L[ "MedallionOfMoriah" ] = "Ce sont vos Médaillons de la Moria";
-- Medallion of Lothlórien
L[ "MMedallionOfLothlorien" ] = "Médaillon de la Lothlórien";
L[ "MedallionOfLothlorienh" ] = "Ce sont vos Médaillons de la Lothlórien";
-- Buried Treasure Token
L[ "MBuriedTreasureToken" ] = "Jeton du Trésor enfoui";
L[ "BuriedTreasureTokenh" ] = "Ce sont vos Jetons du Trésor enfoui";
-- Gabil'akkâ War-mark
L[ "MGabilakkaWarMark" ] = "Marque de guerre des Gabil'akkâ";
L[ "GabilakkaWarMarkh" ] = "Ce sont vos Marques de guerre des Gabil'akkâ";
-- Copper Coin of Gundabad
L[ "MCopperCoinOfGundabad" ] = "Pièce de cuivre de Gundabad";
L[ "CopperCoinOfGundabadh" ] = "Ce sont vos Pièces de cuivre de Gundabad";
-- Silver Coin of Gundabad
L[ "MSilverCoinOfGundabad" ] = "Pièce d'argent de Gundabad";
L[ "SilverCoinOfGundabadh" ] = "Ce sont vos Pièces d'argent de Gundabad";
-- Steel Token
L[ "MSteelToken" ] = "Jeton d'acier";
L[ "SteelTokenh" ] = "Jetons d'acier";
-- Iron Coin of Cardolan
L[ "MIronCoinOfCardolan" ] = "Pièce en fer du Cardolan";
L[ "IronCoinOfCardolanh" ] = "Ce sont vos Pièces en fer du Cardolan";
-- Bree-land Wood-mark
L[ "MBreeLandWoodMark" ] = "Marque sylvestre du Pays de Bree";
L[ "BreeLandWoodMarkh" ] = "Ce sont vos Marques sylvestres du Pays de Bree";
-- Bronze Arnorian Coin
L[ "MBronzeArnorianCoin" ] = "Pièce en bronze d'Arnor";
L[ "BronzeArnorianCoinh" ] = "Ce sont vos Pièces en bronze d'Arnor";
-- Silver Arnorian Coin
L[ "MSilverArnorianCoin" ] = "Pièce en argent d'Arnor";
L[ "SilverArnorianCoinh" ] = "Ce sont vos Pièces en argent d'Arnor";
-- East Gondor Silver Piece
L[ "MEastGondorSilverPiece" ] = "Pièce d'argent du Gondor oriental";
L[ "EastGondorSilverPieceh" ] = "Ce sont vos Pièces d'argent du Gondor oriental";
-- Greyflood Marks
L[ "MGreyfloodMark" ] = "Marque du Flot Gris";
L[ "GreyfloodMarkh" ] = "Ce sont vos Marques du Flot Gris";
-- Gundabad Mountain-marks
L[ "MGundabadMountainMark" ] = "Marque de la montagne de Gundabad";
L[ "GundabadMountainMarkh" ] = "Ce sont vos Marques de la montagne de Gundabad";
-- Silver Token of the Riddermark
L[ "MSilverTokenOfTheRiddermark" ] = "Jeton argenté du Riddermark";
L[ "SilverTokenOfTheRiddermarkh" ] = "Ce sont vos Jetons argentés du Riddermark";
-- Golden Token of the Riddermark
L[ "MGoldenTokenOfTheRiddermark" ] = "Jeton doré du Riddermark";
L[ "GoldenTokenOfTheRiddermarkh" ] = "Ce sont vos Jetons dorés du Riddermark";
-- Minas Tirith Silver Piece
L[ "MMinasTirithSilverPiece" ] = "Pièce d'argent de Minas Tirith";
L[ "MinasTirithSilverPieceh" ] = "Ce sont vos Pièces d'argent de Minas Tirith";
-- Cracked Easterling Sceptre
L[ "MCrackedEasterlingSceptre" ] = "Sceptre d'Homme de l'Est fissuré";
L[ "CrackedEasterlingSceptreh" ] = "Ce sont vos Sceptres fissurés d'Homme de l'Est";
-- Grim Orkish Brand
L[ "MGrimOrkishBrand" ] = "Marque orque sombre";
L[ "GrimOrkishBrandh" ] = "Ce sont vos Marques orques sinistres";
-- Sand-work Copper Token
L[ "MSandWornCopperToken" ] = "Jeton de cuivre usé par le sable";
L[ "SandWornCopperTokenh" ] = "Jetons de cuivre usés par le sable";
-- Frigid Steel Signet Ring
L[ "MFrigidSteelSignetRing" ] = "Chevalière en acier glacé";
L[ "FrigidSteelSignetRingh" ] = "Ce sont vos Chevalières en acier glacial";
-- Engraved Onyx Sigil
L[ "MEngravedOnyxSigil" ] = "Sceau en onyx gravé";
L[ "EngravedOnyxSigilh" ] = "Ce sont vos Sceaux d'onyx gravés";
-- Sand-smoothed Burl
L[ "MSandSmoothedBurl" ] = "Nœud poncé";
L[ "SandSmoothedBurlh" ] = "Nœuds patinés par le sable";
-- Lump of Red Rock Salt
L[ "MLumpOfRedRockSalt" ] = "Morceau de sel gemme";
L[ "LumpOfRedRockSalth" ] = "Ce sont vos Morceaux de sel de roche rouge";
-- Iron Signet of the Sea-shadow
L[ "MIronSignetOfTheSeaShadow" ] = "Chevalière en fer de l'Ombre de la Mer";
L[ "IronSignetOfTheSeaShadowh" ] = "Ce sont vos Chevalières en fer de l'Ombre de la Mer";
-- Iron Signet of the Fist
L[ "MIronSignetOfTheFist" ] = "Chevalière en fer du poing";
L[ "IronSignetOfTheFisth" ] = "Ce sont vos Chevalières en fer du poing";
-- Iron Signet of the Axe
L[ "MIronSignetOfTheAxe" ] = "Chevalière en fer de la hache";
L[ "IronSignetOfTheAxeh" ] = "Ce sont vos Chevalières en fer de la hache";
-- Iron Signet of the Black Moon
L[ "MIronSignetOfTheBlackMoon" ] = "Chevalière en fer de la lune noire";
L[ "IronSignetOfTheBlackMoonh" ] = "Ce sont vos Chevalières en fer de la lune noire";
-- Iron Signet of the Necromancer
L[ "MIronSignetOfTheNecromancer" ] = "Chevalière en fer du nécromancien";
L[ "IronSignetOfTheNecromancerh" ] = "Ce sont vos Chevalières en fer du nécromancien";
-- Iron Signet of the Twin Flame
L[ "MIronSignetOfTheTwinFlame" ] = "Chevalière en fer des flammes jumelles";
L[ "IronSignetOfTheTwinFlameh" ] = "Ce sont vos Chevalières en fer des flammes jumelles";
-- Phial of Crimson Extract
L[ "MPhialCrimsonExtract" ] = "Fiole d'extrait de pourpre";
L[ "PhialCrimsonExtracth" ] = "Ce sont vos Fioles d'extrait de pourpre";
-- Phial of Umber Extract
L[ "MPhialUmberExtract" ] = "Fiole d'extrait de terre de Sienne";
L[ "PhialUmberExtracth" ] = "Ce sont vos Fioles d'extrait de terre de Sienne";
-- Phial of Verdant Extract
L[ "MPhialVerdantExtract" ] = "Fiole d'extrait verdoyant";
L[ "PhialVerdantExtracth" ] = "Ce sont vos Fioles d'extrait verdoyant";
-- Phial of Golden Extract
L[ "MPhialGoldenExtract" ] = "Fiole d'extrait doré";
L[ "PhialGoldenExtracth" ] = "Ce sont vos Fioles d'extrait doré";
-- Phial of Violet Extract
L[ "MPhialVioletExtract" ] = "Fiole d'extrait de violette";
L[ "PhialVioletExtracth" ] = "Ce sont vos Fioles d'extrait de violette";
-- Phial of Amber Extract
L[ "MPhialAmberExtract" ] = "Fiole d'extrait d'ambre";
L[ "PhialAmberExtracth" ] = "Ce sont vos Fioles d'extrait d'ambre";
-- Phial of Sapphire Extract
L[ "MPhialSapphireExtract" ] = "Fiole d'extrait de saphir";
L[ "PhialSapphireExtracth" ] = "Ce sont vos Fioles d'extrait de saphir";

-- Control Menu
L[ "MCU" ] = "D\195\169charger ...";
L[ "MCBG" ] = "Changer l'arriere plan de ce contr\195\180le";
L[ "MTBBG" ] = "Appliquer la m\195\170me couleur de TitanBar a ...";
L[ "MTBBGC" ] = "ce contr\195\180le";
L[ "MTBBGAC" ] = "tous les contr\195\180les";
L[ "MCRBG" ] = "Restaurer l'arri\195\168re plan de ...";
L[ "MCABT" ] = "Appliquer l'arri\195\168re plan de ce contr\195\180le a ...";
L[ "MCABTA" ] = "tous les contr\195\180les et TitanBar";
L[ "MCABTTB" ] = "TitanBar";
L[ "MCRC" ] = "Rafra\195\174chir ...";

-- Background window
L[ "BWTitle" ] = "R\195\169gler couleur";
L[ "BWAlpha" ] = "Alpha";
L[ "BWCurSetColor" ] = "Couleur d\195\169j\195\160 r\195\169gl\195\169";
L[ "BWApply" ] = " Appliquer la couleur \195\160 tous les \195\169l\195\169ments";
L[ "BWSave" ] = "Sauvegarder";
L[ "BWDef" ] = "Par d\195\169faut";
L[ "BWBlack" ] = "Noir";
L[ "BWTrans" ] = "Transparent";

-- Wallet infos window
L[ "WIt" ] = "Clic droit sur une devise pour voir ces configurations";
L[ "WIot" ] = "Sur TitanBar";
L[ "WIiw" ] = "Dans l'infobulle";
L[ "WIds" ] = "Ne pas afficher";
L[ "WInc" ] = "Vous suivez aucune devise!\nFaites un clic gauche pour voir la liste des devises.";

-- Money infos window
L[ "MIWTitle" ] = "Argent";
L[ "MIWTotal" ] = "Totaux";
L[ "MIWAll" ] = "Afficher le total sur TitanBar";
L[ "MIWCM" ] = "Afficher l'argent du joueur";
L[ "MIWCMAll" ] = "Afficher \195\160 tous vos personnages";
L[ "MIWSSS" ] = "Afficher les statistiques de session";
L[ "MIWSTS" ] = "Afficher les statistiques du jour";
L[ "MIWID" ] = " infos porte-feuille supprim\195\169";
L[ "MIMsg" ] = "Aucune infos de porte-feuille trouv\195\169";
L[ "MISession" ] = "Session";
L[ "MIDaily" ] = "du jour";
L[ "MIStart" ] = "D\195\169part";
L[ "MIEarned" ] = "Gagn\195\169";
L[ "MISpent" ] = "D\195\169pens\195\169";
--L[ "MITotEarned" ] = "Totaux gagn\195\169";
--L[ "MITotSpent" ] = "Totaux d\195\169pens\195\169";

-- Vault window
L[ "VTh" ] = "vo\195\187te";
L[ "VTnd" ] = "Aucune donn\195\169e n'as \195\169t\195\169 trouv\195\169 pour ce personnage";
L[ "VTID" ] = " infos coffre supprim\195\169!"
L[ "VTSe" ] = "Rechercher:"
L[ "VTAll" ] = "-- Tous --"

-- Shared Storage window
L[ "SSh" ] = "stockage partag\195\169";
L[ "SSnd" ] = "Besoin d'ouvrir votre stockage partag\195\169 au moins une fois";

-- Backpack window
L[ "BIh" ] = "Sac \195\160 dos";
L[ "BID" ] = " infos sacs supprim\195\169!"

-- Bank window
L[ "BKh" ] = "banque";

-- Day & Night window
L[ "Dawn" ] = "Aube";
L[ "Morning" ] = "Matin";
L[ "Noon" ] = "Midi";
L[ "Afternoon" ] = "Apr\195\168s-midi";
L[ "Dusk" ] = "Entre chien et loup";
L[ "Gloaming" ] = "Cr\195\169puscule";
L[ "Evening" ] = "Soir";
L[ "Midnight" ] = "Minuit";
L[ "LateWatches" ] = "Nuit noire";
L[ "Foredawn" ] = "Au bout..nuit";--Au bout de la nuit
L[ "NextT" ] = "Afficher le prochain temps";
L[ "TAjustL" ] = "Code de minuterie";

-- Reputation window
L[ "RPt" ] = "S\195\169lectionner / d\195\169s\195\169lectionner une faction\nclick droit pour voir ces configurations";
L[ "RPnf" ] = "Vous suivez aucune faction!\nFaites un clic gauche pour voir la liste des factions.";
L[ "RPPHMaxHide" ] = "Masquer les factions \195\160 une r\195\169putation maximale";-- Google: https://translate.google.com/#auto/fr/Hide%20factions%20at%20maximum%20reputation

-- All reputation names
L[ "MenOfBree" ]    = "Hommes de Bree";
L[ "ThorinsHall" ]    = "Palais de Thorin";
L[ "TheMathomSociety" ]   = "La Soci\195\169t\195\169 des Mathoms";
L[ "RangersOfEsteldin" ]    = "R\195\180deurs d'Esteldin";
L[ "ElvesOfRivendell" ]    = "Elfes de Fondcombe";
L[ "TheEldgang" ]   = "Les Eldgangs";
L[ "CouncilOfTheNorth" ]    = "Conseil du Nord";
L[ "TheWardensOfAnnuminas" ]   = "Les Gardiens d'Annuminas";
L[ "LossothOfForochel" ]    = "Lossoth du Forochel";
L[ "TheEglain" ]   = "Les Eglain";
L[ "IronGarrisonGuards" ]   = "Gardes de la Garnison de Fer";
L[ "IronGarrisonMiners" ]   = "Minuers de la Garnison de Fer";
L[ "AlgraigMenOfEnedwaith" ]   = "Les Algraig, Hommes d'Enedwaith";
L[ "TheGreyCompany" ]   = "La Compagnie grise";
L[ "Galadhrim" ]     = "Galadhrim";
L[ "Malledhrim" ]     = "Malledhrim";
L[ "TheRidersOfStangard" ]   = "Les Cavaliers de Stangarde";
L[ "HeroesOfLimlightGorge" ]   = "Les H\195\169ros de la Gorge de Limeclair";
L[ "MenOfDunland" ]    = "Hommes du Pays de Dun";
L[ "TheodredsRiders" ]    = "Cavaliers de Th\195\169odred";
L[ "JewellersGuild" ]    = "Guilde des bijoutiers";
L[ "CooksGuild" ]    = "Guilde des cuisiniers";
L[ "ScholarsGuild" ]    = "Guilde des \195\169rudits";
L[ "TailorsGuild" ]    = "Guilde des tailleurs";
L[ "WoodworkersGuild" ]   = "Guilde des menuisiers";
L[ "WeaponsmithsGuild" ]   = "Guilde des fabricants d'armes";
L[ "MetalsmithsGuild" ]    = "Guilde des ferroniers";
L[ "MenOfTheEntwashVale" ]   = "Hommes de la vall\195\169e de l'Entalluve";
L[ "MenOfTheNorcrofts" ]    = "Hommes des Norcrofts";
L[ "MenOfTheSutcrofts" ]    = "Hommes des Sutcrofts";
L[ "MenOfTheWold" ]    = "Hommes du Plateau";
L[ "PeopleOfWildermore" ]    = "Peuple des Landes farouches";
L[ "SurvivorsOfWildermore" ]    = "Survivants des Landes farouches";
L[ "TheEorlingas" ]   = "Les Eorlingas";
L[ "TheHelmingas" ]   = "Les Helmingas";
L[ "TheEntsOfFangornForest" ]  = "Les Ents de la for\195\170t de Fangorn";
L[ "DolAmroth" ]    = "Dol Amroth";
L[ "DolAmrothArmoury" ]   = "Dol Amroth - Armurerie";
L[ "DolAmrothBank" ]   = "Dol Amroth - Banque";
L[ "DolAmrothDocks" ]   = "Dol Amroth - Quais";
L[ "DolAmrothGreatHall" ]  = "Dol Amroth - Palais";
L[ "DolAmrothLibrary" ]   = "Dol Amroth - Biblioth\195\168que";
L[ "DolAmrothWarehouse" ]   = "Dol Amroth - Entrep\195\180t";
L[ "DolAmrothMason" ]   = "Dol Amroth - Atelier de Maconnerie";
L[ "DolAmrothSwanKnights" ]   = "Dol Amroth - Chevaliers au Cygne";
L[ "MenOfRingloVale" ]   = "Hommes du Val de Ringl\195\179 Vale";
L[ "MenOfDorEnErnil" ]   = "Hommes de Dor-en-Ernil";
L[ "MenOfLebennin" ]    = "Hommes du Lebennin";
L[ "Pelargir" ]     = "Pelargir";
L[ "RangersOfIthilien" ]    = "R\195\180deurs de l'Ithilien";
L[ "DefendersOfMinasTirith" ]   = "Les D\195\169fenseurs de Minas Tirith";
L[ "RidersOfRohan" ]    = "Cavaliers de Rohan";
L[ "HostOfTheWest" ]  = "Arm\195\169e de l'ouest"; -- Thx Valiarym
L[ "HostOfTheWestArmour" ] = "Arm\195\169e de l'ouest: Armures"; -- Thx Valiarym
L[ "HostOfTheWestWeapons" ] = "Arm\195\169e de l'ouest: Armes"; -- Thx Valiarym
L[ "HostOfTheWestProvisions" ] = "Arm\195\169e de l'ouest: Provisions"; -- Thx Valiarym
L[ "ConquestOfGorgoroth" ]   = "Conqu\195\170te de Gorgoroth";-- Conqu�te de Gorgoroth
L[ "EnmityOfFushaumBalSouth" ] = "Ennemie du sud de Fushaum Bal";
L[ "EnmityOfFushaumBalNorth" ] = "Ennemie du nord de Fushaum Bal";
L[ "RedSkyClan" ]   = "Clan du Ciel rouge";
L[ "DwarvesOfErebor" ]   = "Nains d'Erebor";-- Thanks bornfight#0574 on Discord
L[ "ElvesOfFelegoth" ]   = "Elfes de Felegoth";-- Elves of Felegoth -- Thanks bornfight#0574 on Discord
L[ "MenOfDale" ]   = "Hommes de Dale";-- Men of Dale -- Thanks bornfight#0574 on Discord
L[ "ChickenChasingLeagueOfEriador" ]  = "Ligue des Chasseurs de Poulets d'Eriador";
L[ "TheAleAssociation" ]   = "La confr\195\168rie de la cervoise";
L[ "TheInnLeague" ]   = "La Ligue des Tavernes";
L[ "GreyMountainsExpedition" ]   = "Exp\195\168dition des Montagnes Grises"; -- Grey Mountains Expedition -- Thx bornfight
L[ "Wilderfolk" ]    = "Peuple Sauvage"; -- Wilderfolk
L[ "TheGreatAlliance" ]   = "La Grande Alliance"; -- The Great Alliance
L[ "TheWhiteCompany" ]   = "La Compagnie Blanche"; -- The White Company
L[ "ReclamationOfMinasIthil" ]   = "R\195\169clamation de Minas Ithil";
L[ "ProtectorsOfWilderland" ]   = "Protecteurs des Terres sauvages";
L[ "MarchOnGundabad" ]   = "Les Reconqu\195\169rants de Gundabad";
L[ "TheGabilakka" ]    = "Les Gabil'akk\195\162";
L[ "WoodcuttersBrotherhood"]	   = "Confr\195\169rie des B\195\185cherons";
L[ "TheLeagueOfTheAxe"]   = "La Ligue de la hache";
L[ "TheHabanakkaOfThrain" ]   = "Les Haban'akk\195\162 de Thr\195\162in";
L[ "KharumUbnar" ]    = "Kharum-ubn\195\162r";
L[ "ReclaimersOfTheMountainHold" ] = "La reconqu\195\170te de la Montagne";
L[ "DefendersOfTheAngle" ]  = "Défenseurs de l'Angle";
L[ "TheYonderWatch" ]   = "La Garde de la Comtè Lointaine";
L[ "DunedainOfCardolan" ]   = "Dunedain du Cardolan";
L[ "ReputationAcceleration" ]   = "Acc\195\168l\195\168ration de r\195\168putation";
L["StewardsOfTheIronHome"] = "Intendants de la Maison de Fer"
L["TownsfolkOfTheKingstead"] = "Habitants de la Terre-du-Roi"
L["TownsfolkOfTheEastfold"] = "Habitants de l'Estfolde"
L["TheRenewalOfGondor"] = "Le Gondor renaissant"
L["UmbarCooksGuild"] = "Guilde des cuisiniers d'Umbar"
L["UmbarJewellersGuild"] = "Guilde des bijoutiers d'Umbar"
L["UmbarMetalsmithsGuild"] = "Guilde des ferronniers d'Umbar"
L["UmbarScholarsGuild"] = "Guilde des érudits d'Umbar"
L["UmbarTailorsGuild"] = "Guilde des tailleurs d'Umbar"
L["UmbarWeaponsmithsGuild"] = "Guilde des fabricants d'armes d'Umbar"
L["UmbarWoodworkersGuild"] = "Guilde des menuisiers d'Umbar"
L["CitizensOfUmbarBaharbel"] = "Habitants d'Umbar Baharbêl"
L["PhetekariOfUmbar"] = "Phetekâri d'Umbar"
L["TheIkorbani"] = "Les Ikorbâni"
L["TheAdurhid"] = "Les Adurhid"
L["ThePathOfValour"] = "La voie de la bravoure"
L["AmeliasStudies"] = "Études d'Amelia"
L["MoriaBountyHunters"] = "Les chasseurs de primes de la Moria"

-- All reputation standings
L[ "RPMSR" ]  = "Statut maximum atteint";
L[ "Neutral" ]  = "Neutre";
L[ "Acquaintance" ]  = "Connaissance";
L[ "Friend" ]  = "Ami";
L[ "Ally" ]  = "Alli\195\169";-- Alli�
L[ "Kindred" ]  = "Fr\195\168re";-- Fr�re
L[ "Respected" ]  = "Respect\195\169";-- thx axennexa
L[ "Honoured" ]  = "Honor\195\169";-- thx axennexa
L[ "Celebrated" ]  = "Acclam\195\169";-- thx axennexa
L[ "Outsider" ]  = "\195\137tranger";-- �tranger
L[ "Enemy" ]  = "Ennemi";
L[ "Member" ] = "Membre";
L[ "GuildInitiate" ]  = "Initier";
L[ "ApprenticeOfTheGuild" ]  = "Aprenti";
L[ "JourneymanOfTheGuild" ]  = "Compagnon";
L[ "ExpertOfTheGuild" ]  = "Expert";
L[ "ArtisanOfTheGuild" ]  = "Artisan";
L[ "MasterOfTheGuild" ]  = "Ma\195\174tre";--Ma�tre
L[ "EastemnetMasterOfTheGuild" ]  = "Eastemnet Master";
L[ "WestemnetMasterOfTheGuild" ]  = "Westemnet Master";
L[ "HonouredMasterOfTheGuild" ]  = "Grand Ma\195\174tre Honor\195\169";
L[ "UmbarGuildMember" ]  = "Membre de guilde d'Umbar";
L[ "Rookie" ] = "Débutant";
L[ "MinorLeaguer" ] = "Joueur de ligue mineure";
L[ "MajorLeaguer" ] = "Joueur de ligue majeure";
L[ "AllStar" ] = "Vedette";
L[ "HallOfFamer" ] = "Champion";
L[ "BonusRemaining" ]   = "Bonus Restant";
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
L[ "RPDECREASE"] = "diminu\195\169";

-- Infamy/Renown window
if PlayerAlign == 1 then L[ "IFWTitle" ] = "Renomm\195\169e"; L[ "IFIF" ] = "Total de renomm\195\169e:";
else L[ "IFWTitle" ] = "Infamie"; L[ "IFIF" ] = "Total d'infamie:"; end
L[ "IFCR" ] = "Votre grade:";
L[ "IFTN" ] = "points pour le rang suivant";

-- GameTime window
L[ "GTWTitle" ] = "Temps actuel/serveur";
L[ "GTW24h" ] = "Afficher l'heure en format 24h";
L[ "GTWSST" ] = "Afficher l'heure du serveur       GMT";
L[ "GTWSBT" ] = "Afficher l'heure actuel et celui du serveur";
L[ "GTWST" ] = "Serveur: ";
L[ "GTWRT" ] = "Actuel: ";

-- More Options window
L[ "OPWTitle" ] = L[ "MOP" ];
L[ "OPHText" ] = "Hauteur:";
L[ "OPFText" ] = "Police:";
L[ "OPAText" ] = "Masquer automatiquement:";
L[ "OPAHD" ] = "D\195\169sactiver";
L[ "OPAHE" ] = "Toujours";
L[ "OPAHC" ] = "Seulement en combat";
L[ "OPIText" ] = "Taille des ic\195\180nes:";
L[ "OPTBTop" ] = "Au haut de l'\195\169cran";
L[ "OPISS" ] = "Petit";
L[ "OPISM" ] = "Moyen";
L[ "OPISL" ] = "Grand";
L[ "Layout" ] = "Alternative PlayerInfo Layout\n(Reloads TB after changing)";

-- Profile window
L[ "PWProfile" ] = "Profil";
L[ "PWEPN" ] = "Taper un nom";
L[ "PWCreate" ] = "Cr\195\169er";
L[ "PWNew" ] = "Nouveau profil";
L[ "PWCreated" ] = "a \195\169t\195\169 cr\195\169\195\169";-- a �t� cr��
L[ "PWLoad" ] = "Charger";
L[ "PWNFound" ] = "Aucun profile trouv\195\169";
L[ "PWFail" ] = " ne peut pas \195\170tre charg\195\169, car la langue du jeu n'est pas la m\195\170me langue que ce profil";
L[ "PWLoaded" ] = "charger";
L[ "PWDelete" ] = "Delete";-- Needs translation";
L[ "PWDeleteFailed" ] = "Failed to delete profile ";-- Needs translation
L[ "PWFailDelete" ] = " cannot be deleted because the language of the game is not the same language of this profile";-- Needs translation
L[ "PWDeleted" ] = "supprimer";
L[ "PWSave" ] = "Sauvegarder";
L[ "PWSaved" ] = "enregistr\195\169";-- enregistr�
L[ "PWCancel" ] = "Annuler";

-- Shell commands window
L[ "SCWTitle" ] = "Commandes shell TitanBar";
L[ "SCWC1" ] = "Afficher les options";
L[ "SCWC2" ] = "D\195\169charger TitanBar";
L[ "SCWC3" ] = "Recharger TitanBar";
L[ "SCWC4" ] = "R\195\169initialiser tous les r\195\169glages par d\195\169faut";

-- Shell commands
L[ "SC0" ] = "Cette commande n'est pas support\195\169";
L[ "SCa1" ] = "options";
L[ "SCb1" ] = "opt / ";
L[ "SCa2" ] = "d\195\169charger";
L[ "SCb2" ] = "  u / ";
L[ "SCa3" ] = "recharger";
L[ "SCb3" ] = "  r / ";
L[ "SCa4" ] = "r\195\169initialiser";
L[ "SCb4" ] = " ra / ";

-- Durability infos window
L[ "DWTitle" ] = "Durabilit\195\169 de vos articles";
L[ "DWLbl" ] = " article endommag\195\169";
L[ "DWLbls" ] = " articles endommag\195\169s";
L[ "DWLblND" ] = "Tous vos articles sont \195\160 100%";
L[ "DIIcon" ] = "Afficher l'ic\195\180ne dans l'infobulle";
L[ "DIText" ] = "Afficher le nom de l'article dans l'infobulle";
L[ "DWnint" ] = "Ic\195\180ne et nom pas afficher";

-- Equipment infos window
--L[ "EWTitle" ] = "Infos sur vos articles";
L[ "EWLbl" ] = "Articles actuellement sur vous";
L[ "EWLblD" ] = "Pointage";
L[ "EWItemNP" ] = " Article absent";
--L[ "EWItemF" ] = " article trouv\195\169";
--L[ "EWItemsF" ] = " articles trouv\195\169s";
L[ "EWST1" ] = "T\195\170te";
L[ "EWST13" ] = "Boucle d'oreille gauche";
L[ "EWST14" ] = "Boucle d'oreille droite";
L[ "EWST10" ] = "Collier";
L[ "EWST6" ] = "\195\137paules";
L[ "EWST7" ] = "Dos";
L[ "EWST2" ] = "Buste";
L[ "EWST8" ] = "Bracelet gauche";
L[ "EWST9" ] = "Bracelet droit";
L[ "EWST11" ] = "Anneau gauche";
L[ "EWST12" ] = "Anneau droite";
L[ "EWST4" ] = "Gants";
L[ "EWST3" ] = "Jambes";
L[ "EWST5" ] = "Pieds";
L[ "EWST15" ] = "Poche";
L[ "EWST16" ] = "Arme principale";
L[ "EWST17" ] = "Arme secondaire/Bouclier";
L[ "EWST18" ] = "Arme \195\160 distance";
L[ "EWST19" ] = "Outil d'artisanat";
L[ "EWST20" ] = "Objet de classe";

-- Player Infos control
--L[ "PINAME" ] = "Votre nom";
--L[ "PILVL" ] = "Votre niveau";
--L[ "PIICON" ] = "Vous \195\170tes un ";
L[ "Morale" ] = "Moral";
L[ "Power" ] = "Puissance";
L[ "Armour" ] = "Armure";
L[ "Stats" ] = "Statistiques";
L[ "Might" ] = "Force";
L[ "Agility" ] = "Agilit\195\169";
L[ "Vitality" ] = "Vitalit\195\169";
L[ "Will" ] = "Volont\195\169";
L[ "Fate" ] = "Destin";
L[ "Finesse" ] = "Finesse";
L[ "Mitigations" ] = "Mitigations";
L[ "Common" ] = "Commum";
L[ "Fire" ] = "Feu";
L[ "Frost" ] = "Froid";
L[ "Shadow" ] = "Ombre";
L[ "Lightning" ] = "Foudre";
L[ "Acid" ] = "Acide";
L[ "Physical" ] = "Physique";
L[ "Tactical" ] = "Tactique";
L[ "Healing" ] = "Soins";
L[ "Outgoing" ] = "Donn\195\169e";
L[ "Incoming" ] = "Re\195\167us";
L[ "Avoidances" ] = "Avoidances";
L[ "Block" ] = "Bloqu\195\169";
L[ "Parry" ] = "Par\195\169";
L[ "Evade" ] = "Esquiv\195\169";
L[ "Resistances" ] = "R\195\169sistance";
L[ "Base" ] = "Base";
L[ "CritAvoid" ] = "D\195\169f. critique";
L[ "CritChance" ] = "Coup critique";
L[ "Mastery" ] = "Ma\195\174trise";
L[ "Level" ] = "Niveau";
L[ "Race" ] = "Race";
L[ "Class" ] = "Classe";
L[ "XP" ] = "Exp.";
L[ "MLvl" ] = "Niveau maximum atteint";
L[ "NXP" ] = "Next lvl at";
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
L[ "PartMit" ] = "red.part.";
L[ "Capped1" ] = "Jaune - coiff\195\169";
L[ "Capped2" ] = "Orange - T2 coiff\195\169";
L[ "Capped3" ] = "Rouge - T3+ coiff\195\169";
L[ "Capped4" ] = "Violet - Enh III coiff\195\169";
L[ "CalcStatDependency" ] = "Cette fenêtre nécessite l'installation de CalcStat";

-- Money Infos control
L[ "MGh" ] = "Quantit\195\169 de pi\195\168ces d'or";
L[ "MSh" ] = "Quantit\195\169 de pi\195\168ces d'argent";
L[ "MCh" ] = "Quantit\195\169 de pi\195\168ces de cuivre";
L[ "MGB" ] = "Sac de pi\195\168ces d'or"; -- Thx Lukrim!
L[ "MSB" ] = "Sac de pi\195\168ces d'argent"; -- Thx Lukrim!
L[ "MCB" ] = "Sac de pi\195\168ces de cuivre"; -- Thx Lukrim!

-- Bag Infos control
--L[ "BIh" ] = "Informations de vos sacs";
--L[ "BIt1" ] = "Nombre de place occup\195\169s/max";
L[ "BINI" ] = "Vous suivez pas d'article!\nFaites un clic gauche pour voir vos articles."
L[ "BIIL" ] = "Liste des articles"
L[ "BIT" ] = "S\195\169lectionner / d\195\169s\195\169lectionner un article"
L[ "BIUsed" ] = " Afficher espaces occup\195\169es, sinon libres";
L[ "BIMax" ] = " Afficher le total d'espaces";
L[ "BIMsg" ] = "Aucun article empilable n'a \195\169t\195\169 trouv\195\169!"

-- Equipment Infos control
L[ "EIh" ] = "Points pour tous les \195\169quipements";
L[ "EIt1" ] = "Clique gauche pour ouvrir la fen\195\170tre d'options";
L[ "EIt2" ] = "Tenir clique gauche pour d\195\169placer le contr\195\180le";
L[ "EIt3" ] = "Clique droit pour ouvrir le menu du contr\195\180le";

-- Durability Infos control
L[ "DIh" ] = "Durabilit\195\169 pour tous les \195\169quipements";

-- Player Location control
L[ "PLh" ] = "Votre emplacement";
L[ "PLMsg" ] = "Entrez une ville!";

-- Game Time control
L[ "GTh" ] = "Temps actuel/serveur";

-- Chat message
L[ "TBR" ] = "TitanBar: Tous les param\195\168tres on \195\169t\195\169 restaur\195\169 par default";

-- Player Race names: 'PR' + Race Id
-- Add appropriate Race Id entry for new/unknown races.
-- Unlisted Race Id's show up in the Player infos tooltip.
L[ "PR65" ] = "Elfe";
L[ "PR23" ] = "Homme";
L[ "PR73" ] = "Nain";
L[ "PR81" ] = "Hobbit";
L[ "PR114" ] = "Beornide";
L[ "PR117" ] = "Haut Elfe";-- Thanks F0urEyes#3544 on Discord
L[ "PR120" ] = "Nain Hache robuste";
L[ "PR125" ] = "Hobbit des Rivi\195\168res";
L[ "PR7" ] = "Orc";
L[ "PR6" ] = "Uruk";
L[ "PR12" ] = "Spider";
L[ "PR66" ] = "Warg";
L[ "PR27" ] = "Critter";

-- Player Class names: 'PC' + Class Id
-- Add appropriate Class Id entry for new/unknown classes.
-- Unlisted Class Id's show up in the Player infos tooltip.
L[ "PC40" ] = "Cambrioleur";
L[ "PC24" ] = "Capitaine";
L[ "PC172" ] = "Champion";
L[ "PC23" ] = "Gardien";
L[ "PC162" ] = "Chasseur";
L[ "PC185" ] = "Ma\195\174tre du savoir";
L[ "PC31" ] = "M\195\169nestrel";
L[ "PC193" ] = "Gardien des runes";
L[ "PC194" ] = "Sentinelle";
L[ "PC214" ] = "Beorning";
L[ "PC215" ] = "Bagarreur";
L[ "PC216" ] = "Marin";
L[ "PC71" ] = "Reaver";
L[ "PC127" ] = "Weaver";
L[ "PC179" ] = "Blackarrow";
L[ "PC52" ] = "Warleader";
L[ "PC126" ] = "Stalker";
L[ "PC128" ] = "Defiler";
L[ "PC192" ] = "Poulet";

-- Durability
L[ "D" ] = "Durabilit\195\169";
L[ "D1" ] = "Toutes les Durabilit\195\169s";
L[ "D2" ] = "Faible";
L[ "D3" ] = "Substantiel";
L[ "D4" ] = "Fragile";
L[ "D5" ] = "Normal";
L[ "D6" ] = "R\195\169sitant";
L[ "D7" ] = "Flimsy"; -- ??
L[ "D8" ] = "Indestructible";

-- Quality
L[ "Q" ] = "Qualit\195\169";
L[ "Q1" ] = "Toutes les Qualit\195\169s";
L[ "Q2" ] = "Commum";
L[ "Q3" ] = "Peu Commum";
L[ "Q4" ] = "Incomparable";
L[ "Q5" ] = "Rare";
L[ "Q6" ] = "L\195\169gendaire";
