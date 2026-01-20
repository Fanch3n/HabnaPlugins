-- de.lua
-- Written by Habna -- Translated by Nadia (https://hdro-guide.de)
-- Rewritten by many

_G.L = {};
L[ "TBLoad" ] = "TitanBar " .. Version .. " geladen!";
L[ "TBSSCS" ] = "TitanBar: Bildschirmgröße geändert, positioniere Icons neu...";
L[ "TBSSCD" ] = "TitanBar: erledigt!";
L[ "TBOpt" ] = "Optionen sind durch einen Rechtsklick auf TitanBar verf\195\188gbar";

--Misc
L[ "NoData" ] = "Keine anderen Daten in der API";
L[ "NA" ] = "N/A";
--L[ "dmg" ] = " def";
L[ "You" ] = "Du: ";
L[ "ButDel" ] = "Infos dieser Art l\195\182schen";
--L[ "" ] = "";

-- TitanBar Menu
L[ "MBag" ] = "Zeige Geldbeutel";
L[ "MGSC" ] = "Verm\195\182gen"; -- (Gold, Silber, Kupfer)
L[ "MBI" ] = "Rucksack Infos";
L[ "MPI" ] = "Spieler Infos";
L[ "MEI" ] = "Ausr\195\188stung Infos";
L[ "MDI" ] = "Haltbarkeit Infos";
L[ "MPL" ] = "Spieler Ort";
L[ "MGT" ] = "Uhrzeit";
L[ "MOP" ] = "Weitere Optionen";
L[ "MPP" ] = "Profil";
L[ "MSC" ] = "Shell-Befehle";
L[ "MRA" ] = "Auf Standardwerte zur\195\188cksetzen";
L[ "MUTB" ] = "entfernen";
L[ "MRTB" ] = "neu laden";
L[ "MATB" ] = "\195\188ber";
L[ "MBG" ] = "Hintergrundfarbe";
L[ "MCL" ] = "Sprache \195\164ndern ...";
L[ "MCLen" ] = "Englisch";
L[ "MCLfr" ] = "Franz\195\182sisch";
L[ "MCLde" ] = "Deutsch";
L[ "MTI" ] = "Artikel verfolgen";
--L[ "MView" ] = "Anzeigen ";
L[ "MVault" ] = "Bankfach";
L[ "MStorage" ] = "gemeinsamer Lagerraum";
L[ "MDayNight" ] = "Tages- & Nacht-Zeit";
L[ "MReputation" ] = "Ruf";

-- Wallet Currency Controls
-- LOTRO Points control
L[ "MLotroPoints" ] = "HdRO-Punkte";
L[ "LotroPointsh" ] = "Eure HdRO-Punkte";
-- Mithril Coins control
L[ "MMithrilCoins" ] = "Mithril-M\195\188nze";
L[ "MithrilCoinsh" ] = "Eure Mithril-M\195\188nzen";
-- Yule Tokens control
L[ "MYuleToken" ] = "Julfestmarke";
L[ "YuleTokenh" ] = "Eure Julfestmarken";
-- Anniversary Tokens control
L[ "MAnniversaryToken" ] = "Jubil\195\164umsm\195\188nze";
L[ "AnniversaryTokenh" ] = "Eure Jubil\195\164umsm\195\188nzen";
-- Bingo Badge control
L[ "MBingoBadge" ] = "Bingo-Abzeichen";
L[ "BingoBadgeh" ] = "Eure Bingo-Abzeichen";
-- Skirmish marks control
L[ "MSkirmishMarks" ] = "Zeichen";
L[ "SkirmishMarksh" ] = "Eure Scharm\195\188tzel-Zeichen";
-- Destiny Points control
L[ "MDestinyPoints" ] = "Schicksalspunkte";
L[ "DestinyPointsh" ] = "Eure Schicksalspunkte";
-- Shards control
L[ "MShards" ] = "Scherbe";
L[ "Shardsh" ] = "Eure Scherben";
-- Tokens of Hytbold control
L[ "MTokensOfHytbold" ] = "M\195\188nze von Hytbold";
L[ "TokensOfHytboldh" ] = "Eure M\195\188nzen von Hytbold";
-- Medallions control
L[ "MMedallions" ] = "Medaillon";
L[ "Medallionsh" ] = "Eure Medaillons";
-- Seals control
L[ "MSeals" ] = "Siegel";
L[ "Sealsh" ] = "Eure Siegel";
-- Commendations control
L[ "MCommendation" ] = "Anerkennung";
L[ "Commendationh" ] = "Eure Anerkennung";
-- Amroth Silver Piece control
L[ "MAmrothSilverPiece" ] = "Amroth-Silberst\195\188ck";
L[ "AmrothSilverPieceh" ] = "Eure Amroth-Silberst\195\188cke";
-- Stars of Merit control
L[ "MStarsOfMerit" ] = "Stern des Verdienst";
L[ "StarsOfMerith" ] = "Eure Sterne des Verdienst";
-- Central Gondor Silver Piece control
L[ "MCentralGondorSilverPiece" ] = "Zentralgondorisches Silberst\195\188ck";
L[ "CentralGondorSilverPieceh" ] = "Eure Zentralgondorischen Silberst\195\188cke";
-- Gift giver's Brand control
L[ "MGiftGiversBrand" ] = "Zeichen des Schenkenden";
L[ "GiftGiversBrandh" ] = "Eure Zeichen des Schenkenden";
-- Motes of Enchantment control
L[ "MMotesOfEnchantment" ] = "Staub der Verzauberung";
L[ "MotesOfEnchantmenth" ] = "Euer Staub der Verzauberung";
-- Embers of Enchantment control
L[ "MEmbersOfEnchantment" ] = "Funken der Verzauberung";
L[ "EmbersOfEnchantmenth" ] = "Eure Funken der Verzauberung";
-- Figments of Splendour control
L[ "MFigmentsOfSplendour" ] = "Prachtst\195\188ck des Glanzes";
L[ "FigmentsOfSplendourh" ] = "Eure Prachtst\195\188cke des Glanzes";
-- Fall Festival Tokens control
L[ "MFallFestivalToken" ] = "Herbstfest-Medaille";
L[ "FallFestivalTokenh" ] = "Eure Herbstfest-Medaillen";
-- Farmers Faire Tokens control
L[ "MFarmersFaireToken" ] = "Bauernfest-M\195\188nze";
L[ "FarmersFaireTokenh" ] = "Eure Bauernfest-M\195\188nzen";
-- Spring Leaves control
L[ "MSpringLeaf" ] = "Fr\195\188hlingsblatt";
L[ "FSpringLeafh" ] = "Eure Fr\195\188hlingsbl\195\164tter";
-- Midsummer Tokens control
L[ "MMidsummerToken" ] = "Mittsommer-Marke";
L[ "MidsummerTokenh" ] = "Eure Mittsommer-Marken";
-- Ancient Script control
L[ "MAncientScript" ] = "Uralte Schrift";
L[ "AncientScripth" ] = "Eure Uralte Schriften";
-- Inn League / Ale Association control
L[ "MBadgeOfTaste" ] = "Abzeichen des Geschmacks";
L[ "BadgeOfTasteh" ] = "Eure Abzeichen des Geschmacks";
L[ "MBadgeOfDishonour" ] = "Abzeichen der Schande";
L[ "BadgeOfDishonourh" ] = "Eure Abzeichen der Schande";
-- Delving Writs
L[ "MDelvingWrit" ] = "Erkunder-Schriftstück";
L[ "DelvingWrith" ] = "Eure Erkunder-Schriftstücke";
-- Cold-iron Tokens
L[ "MColdIronToken" ] = "Kalte Eisenmarke";
L[ "ColdIronTokenh" ] = "Eure Kalte Eisenmarken";
-- Token of Heroism
L[ "MTokenOfHeroism" ] = "Marke des Heldentums";
L[ "TokenOfHeroismh" ] = "Eure Marken des Heldentums";
-- Hero's Mark
L[ "MHerosMark" ] = "Heldenmarke";
L[ "HerosMarkh" ] = "Eure Heldenmarken";
-- Medallion of Moria
L[ "MMedallionOfMoria" ] = "Medaillon von Moria";
L[ "MedallionOfMoriah" ] = "Eure Medaillons von Moria";
-- Medallion of Lothlórien
L[ "MMedallionOfLothlorien" ] = "Medaillon von Lothlórien";
L[ "MedallionOfLothlorienh" ] = "Eure Medaillons von Lothlórien";
-- Buried Treasure Token
L[ "MBuriedTreasureToken" ] = "Münze der vergrabenen Schätze";
L[ "BuriedTreasureTokenh" ] = "Eure Münzen der vergrabenen Schätze";
-- Gabil'akkâ War-mark
L[ "MGabilakkaWarMark" ] = "Gabil'akkâ-Kriegsmarke";
L[ "GabilakkaWarMarkh" ] = "Eure Gabil'akkâ-Kriegsmarken";
-- Copper Coin of Gundabad
L[ "MCopperCoinOfGundabad" ] = "Kupfermünze von Gundabad";
L[ "CopperCoinOfGundabadh" ] = "Eure Kupfermünzen von Gundabad";
-- Silver Coin of Gundabad
L[ "MSilverCoinOfGundabad" ] = "Silvermünze von Gundabad";
L[ "SilverCoinOfGundabadh" ] = "Eure Silbermünzen von Gundabad";
-- Steel Token
L[ "MSteelToken" ] = "Schildmünze";
L[ "SteelTokenh" ] = "Eure Schildmünzen";
-- Iron Coin of Cardolan
L[ "MIronCoinOfCardolan" ] = "Eisenmünze von Cardolan";
L[ "IronCoinOfCardolanh" ] = "Eure Eisenmünzen von Cardolan";
-- Bree-land Wood-mark
L[ "MBreeLandWoodMark" ] = "Breeland-Waldmarke";
L[ "BreeLandWoodMarkh" ] = "Eure Breeland-Waldmarken";
-- Bronze Arnorian Coin
L[ "MBronzeArnorianCoin" ] = "Arnorische Bronzemünze";
L[ "BronzeArnorianCoinh" ] = "Eure Arnorischen Bronzemünzen";
-- Silver Arnorian Coin
L[ "MSilverArnorianCoin" ] = "Arnorische Silbermünze";
L[ "SilverArnorianCoinh" ] = "Eure Arnorischen Silbermünzen";
-- East Gondor Silver Piece
L[ "MEastGondorSilverPiece" ] = "Ostgondorisches Silberstück";
L[ "EastGondorSilverPieceh" ] = "Eure Ostgondorischen Silberstücke";
-- Greyflood Marks
L[ "MGreyfloodMark" ] = "Grauflut-Zeichen";
L[ "GreyfloodMarkh" ] = "Eure Grauflut-Zeichen";
-- Gundabad Mountain-marks
L[ "MGundabadMountainMark" ] = "Gundabad-Bergmarke";
L[ "GundabadMountainMarkh" ] = "Eure Gundabad-Bergmarken";
-- Silver Token of the Riddermark
L[ "MSilverTokenOfTheRiddermark" ] = "Silbermünze aus der Riddermark";
L[ "SilverTokenOfTheRiddermarkh" ] = "Eure Silbermünzen aus der Riddermark";
-- Golden Token of the Riddermark
L[ "MGoldenTokenOfTheRiddermark" ] = "Goldmünze aus der Riddermark";
L[ "GoldenTokenOfTheRiddermarkh" ] = "Eure Goldmünzen aus der Riddermark";
-- Minas Tirith Silver Piece
L[ "MMinasTirithSilverPiece" ] = "Silberstück aus Minas Tirith";
L[ "MinasTirithSilverPieceh" ] = "Silberstücke aus Minas Tirith";
-- Cracked Easterling Sceptre
L[ "MCrackedEasterlingSceptre" ] = "Gebrochenes Ostling-Zepter";
L[ "CrackedEasterlingSceptreh" ] = "Eure Gebrochenen Ostling-Zepter";
-- Grim Orkish Brand
L[ "MGrimOrkishBrand" ] = "Fürchterliches Ork-Brandeisen";
L[ "GrimOrkishBrandh" ] = "Eure Fürchterlichen Ork-Brandeisen";
-- Sand-worn Copper Token
L[ "MSandWornCopperToken" ] = "Vom Sand geschliffene Kupfermarke";
L[ "SandWornCopperTokenh" ] = "Eure vom Sand geschliffenen Kupfermarken";
-- Frigid Steel Signet Ring
L[ "MFrigidSteelSignetRing" ] = "Kalter stählerner Siegelring";
L[ "FrigidSteelSignetRingh" ] = "Eure Kalten stählernen Siegelringe";
-- Engraved Onyx Sigil
L[ "MEngravedOnyxSigil" ] = "Graviertes Onyx-Siegel";
L[ "EngravedOnyxSigilh" ] = "Eure Gravierten Onyx-Siegel";
-- Sand-smoothed Burl
L[ "MSandSmoothedBurl" ] = "Vom Sand geglättetes Wurzelholz";
L[ "SandSmoothedBurlh" ] = "Eure vom Sand geglätteten Wurzelhölze";
-- Lump of Red Rock Salt
L[ "MLumpOfRedRockSalt" ] = "Brocken rotes Steinsalz";
L[ "LumpOfRedRockSalth" ] = "Eure Brocken roten Steinsalzes";
-- Iron Signet of the Sea-shadow
L[ "MIronSignetOfTheSeaShadow" ] = "Eisernes Siegel des Meeresschattens";
L[ "IronSignetOfTheSeaShadowh" ] = "Eure Eisernen Siegel des Meeresschattens";
-- Iron Signet of the Fist
L[ "MIronSignetOfTheFist" ] = "Eisernes Siegel der Faust";
L[ "IronSignetOfTheFisth" ] = "Eure Eisernen Siegel der Faust";
-- Iron Signet of the Axe
L[ "MIronSignetOfTheAxe" ] = "Eisernes Siegel der Axt";
L[ "IronSignetOfTheAxeh" ] = "Eure Eisernen Siegel der Axt";
-- Iron Signet of the Black Moon
L[ "MIronSignetOfTheBlackMoon" ] = "Eisernes Siegel des schwarzen Monds";
L[ "IronSignetOfTheBlackMoonh" ] = "Eure Eisernen Siegel des schwarzen Monds";
-- Iron Signet of the Necromancer
L[ "MIronSignetOfTheNecromancer" ] = "Eisernes Siegel des Geisterbeschwörers";
L[ "IronSignetOfTheNecromancerh" ] = "Eure Eisernen Siegel des Geisterbeschwörers";
-- Iron Signet of the Twin Flame
L[ "MIronSignetOfTheTwinFlame" ] = "Eisernes Siegel der Zwillingsflamme";
L[ "IronSignetOfTheTwinFlameh" ] = "Eure Eisernen Siegel der Zwillingsflamme";
-- Phial of Crimson Extract
L[ "MPhialCrimsonExtract" ] = "Phiole mit karmesinrotem Extrakt";
L[ "PhialCrimsonExtracth" ] = "Eure Phiolen mit karmesinrotem Extrakt";
-- Phial of Umber Extract
L[ "MPhialUmberExtract" ] = "Phiole mit umbrafarbenem Extrakt";
L[ "PhialUmberExtracth" ] = "Eure Phiolen mit umbrafarbenem Extrakt";
-- Phial of Verdant Extract
L[ "MPhialVerdantExtract" ] = "Phiole mit grünem Extrakt";
L[ "PhialVerdantExtracth" ] = "Eure Phiolen mit grünem Extrakt";
-- Phial of Golden Extract
L[ "MPhialGoldenExtract" ] = "Phiole mit goldenem Extrakt";
L[ "PhialGoldenExtracth" ] = "Eure Phiolen mit goldenem Extrakt";
-- Phial of Violet Extract
L[ "MPhialVioletExtract" ] = "Phiole mit violettem Extrakt";
L[ "PhialVioletExtracth" ] = "Eure Phiolen mit violettem Extrakt";
-- Phial of Amber Extract
L[ "MPhialAmberExtract" ] = "Phiole mit bernsteinfarbenem Extrakt";
L[ "PhialAmberExtracth" ] = "Eure Phiolen mit bernsteinfarbenem Extrakt";
-- Phial of Sapphire Extract
L[ "MPhialSapphireExtract" ] = "Phiole mit saphirfarbenem Extrakt";
L[ "PhialSapphireExtracth" ] = "Eure Phiolen mit saphirfarbenem Extrakt";
-- Shagâni Ghín
L["MShaganiGhin"] = "Shagâni Ghín";
L["ShaganiGhinh"] = "Eure Shagâni Ghín"
-- Hamâti Urgûl
L["MHamatiUrgul"] = "Hamâti-Urgûl";
L["HamatiUrgulh"] = "Eure Hamâti-Urgûl";
-- Mûr Ghala Sârz
L["MMurGhalaSarz"] = "Sârz von Mûr Ghala";
L["MurGhalaSarzh"] = "Eure Sârzai von Mûr Ghala";
-- Silver Serpent
L["MSilverSerpent"] = "Silberschlange";
L["SilverSerpenth"] = "Eure Silberschlangen";
-- Hunter's Guild Mark
L["MHuntersGuildMark"] = "Jägergildenzeichen";
L["HuntersGuildMarkh"] = "Eure Jägergildenzeichen";
-- Blighted Relic
L["MBlightedRelic"] = "Verderbtes Relikt";
L["BlightedRelich"] = "Eure Verderbten Relikte";
-- Tattered Shadows
L["MTatteredShadow"] = "Zerfledderter Schatten";
L["TatteredShadowh"] = "Eure Zerfledderten Schatten";
-- Fangorn Leaf
L["MFangornLeaf"] = "Fangornblatt";
L["FangornLeafh"] = "Eure Fangornblätter";

-- Control Menu
L[ "MCU" ] = "entfernen ...";
L[ "MCBG" ] = "Hintergrundfarbe dieses Elements \195\132ndern";
L[ "MTBBG" ] = "\195\156bernehmen der Hintergrundfarbe f\195\188r ...";
L[ "MTBBGC" ] = "dieses Steuerelement";
L[ "MTBBGAC" ] = "alle Steuerelement";
L[ "MCRBG" ] = "Hintergrundfarbe zur\195\188cksetzen ...";
L[ "MCABT" ] = "Diese Farbe f\195\188r ...";
L[ "MCABTA" ] = "alle Steuerelement & TitanBar";
L[ "MCABTTB" ] = "TitanBar";
L[ "MCRC" ] = "Aktualisieren ...";

-- Background window
L[ "BWTitle" ] = "Farbeinstellung";
L[ "BWAlpha" ] = "Alpha";
L[ "BWCurSetColor" ] = "Aktuelle Farbe";
L[ "BWApply" ] = " Ausgew\195\164hlte Farbe f\195\188r alle Elemente";
L[ "BWSave" ] = "Speichern";
L[ "BWDef" ] = "Standard";
L[ "BWBlack" ] = "Schwarz";
L[ "BWTrans" ] = "Transparent";

-- Wallet infos window
L[ "WIt" ] = "Rechtsklick auf eine W\195\164hrung f\195\188r die Einstellung";--Waehrung, fuer
L[ "WIot" ] = "auf TitanBar";
L[ "WIiw" ] = "im Tooltip";
L[ "WIds" ] = "Nicht mehr anzeigen";
L[ "WInc" ] = "Sie verfolgen keine W\195\164hrung!\nLinks klicken, um die W\195\164hrung Liste zu sehen.";

-- Money infos window
L[ "MIWTitle" ] = "Geldbeutel";
L[ "MIWTotal" ] = "Gesamt";
L[ "MIWAll" ] = "Gesamtsumme anzeigen";
L[ "MIWCM" ] = "Eingeloggten Charakter zeigen";
L[ "MIWCMAll" ] = "Alle Charaktere zeigen";
L[ "MIWSSS" ] = "Sitzungsstatistik im Tooltip zeigen";
L[ "MIWSTS" ] = "Heutige Statistik im Tooltip zeigen";
L[ "MIWID" ] = " Geldbeutel-Info gel\195\182scht";
L[ "MIMsg" ] = "Keine Geldbeutelinfo gefunden";
L[ "MISession" ] = "Statistik Sitzung";
L[ "MIDaily" ] = "Statistik Heute";
L[ "MIStart" ] = "Start";
L[ "MIEarned" ] = "Eingenommen";
L[ "MISpent" ] = "Ausgegeben";
--L[ "MITotEarned" ] = "Gesamt eingenommen";
--L[ "MITotSpent" ] = "Gesamt ausgegeben";

-- Vault window
L[ "VTh" ] = "Bankfach";
L[ "VTnd" ] = "Es wurden keine Daten f\195\188r diesen Charakter gefunden";
L[ "VTID" ] = " Bankfachinfo gel\195\182scht!"; 
L[ "VTSe" ] = "Suchen:";
L[ "VTAll" ] = "-- Alle --";

-- Shared Storage window
L[ "SSh" ] = "gemeinsamer Lagerraum";
L[ "SSnd" ] = "Ihr m\195\188sst Euren Lagerraum mindestens einmal \195\182ffnen";

-- Backpack window
L[ "BIh" ] = "Rucksack";
L[ "BID" ] = " Rucksackinfo gel\195\182scht!"; 

-- Day & Night window
L[ "Dawn" ] = "Morgend\195\164mmerung";
L[ "Morning" ] = "Vormittag";
L[ "Noon" ] = "Mittag";
L[ "Afternoon" ] = "Nachmittag";
L[ "Dusk" ] = "Abendr\195\182te";
L[ "Gloaming" ] = "Abendd\195\164mmerung";
L[ "Evening" ] = "Abend";
L[ "Midnight" ] = "Mitternacht";
L[ "LateWatches" ] = "Nachtwache";
L[ "Foredawn" ] = "Morgenr\195\182te";
L[ "NextT" ] = "N\195\164chste Tageszeit zeigen";
L[ "TAjustL" ] = "Timer seed";

-- Reputation window
L[ "RPt" ] = "Aktivieren / deaktivieren der Fraktionen\nRechtsklick, um aktuellen Stand einzugeben";
L[ "RPnf" ] = "Ihr verfolgt keine Fraktion!\nLinksklick, um die Fraktionsliste zu sehen.";
L[ "RPPHMaxShow" ] = "Zeige Fraktionen mit maximalem Ruf";

-- All reputation names
L[ "MenOfBree" ]    = "Menschen von Bree";
L[ "ThorinsHall" ]    = "Thorins Halle";
L[ "TheMathomSociety" ]   = "Die Mathom-Gesellschaft";
L[ "RangersOfEsteldin" ]    = "Waldl\195\164ufer von Esteld\195\173n";
L[ "ElvesOfRivendell" ]    = "Elben von Bruchtal";
L[ "TheEldgang" ]   = "Die Eldgang";
L[ "CouncilOfTheNorth" ]    = "Rat des Nordens";
L[ "TheWardensOfAnnuminas" ]   = "Die H\195\188ter von Ann\195\186minas";
L[ "LossothOfForochel" ]    = "Lossoth von Forochel";
L[ "TheEglain" ]   = "Die Eglain";
L[ "IronGarrisonGuards" ]   = "Wächter der eisernen Garnison";
L[ "IronGarrisonMiners" ]   = "Bergarbeiter der Eisernen Garnison";
L[ "AlgraigMenOfEnedwaith" ]   = "Algraig, Menschen von Enedwaith";
L[ "TheGreyCompany" ]   = "Die Graue Schar";
L[ "Galadhrim" ]     = "Galadhrim";
L[ "Malledhrim" ]     = "Malledhrim";
L[ "TheRidersOfStangard" ]   = "Die Reiter von Stangard";
L[ "HeroesOfLimlightGorge" ]   = "Helden der Limklar-Schlucht";
L[ "MenOfDunland" ]    = "Menschen aus Dunland";
L[ "TheodredsRiders" ]    = "Th\195\169odreds Reiter";
L[ "JewellersGuild" ]    = "Goldschmiedegilde";
L[ "CooksGuild" ]    = "Kochgilde";
L[ "ScholarsGuild" ]    = "Gelehrtengilde";
L[ "TailorsGuild" ]    = "Schneidergilde";
L[ "WoodworkersGuild" ]   = "Drechslergilde";
L[ "WeaponsmithsGuild" ]   = "Waffenschmiedegilde";
L[ "MetalsmithsGuild" ]    = "Schmiedegilde";
L[ "MenOfTheEntwashVale" ]   = "Menschen des Entwasser-Tals";
L[ "MenOfTheNorcrofts" ]    = "Menschen der Norhofen";
L[ "MenOfTheSutcrofts" ]    = "Menschen der Suthofen";
L[ "MenOfTheWold" ]    = "Menschen der Steppe";
L[ "PeopleOfWildermore" ]    = "Bewohner der Wildermark";
L[ "SurvivorsOfWildermore" ]    = "\195\156berlebende der Wildermark";
L[ "TheEorlingas" ]   = "Die Eorlingas";
L[ "TheHelmingas" ]   = "Die Helmingas";
L[ "TheEntsOfFangornForest" ]  = "Die Ents des Fangorn-Walds";
L[ "DolAmroth" ]    = "Dol Amroth";
L[ "DolAmrothArmoury" ]   = "Dol Amroth - Waffenkammer";
L[ "DolAmrothBank" ]   = "Dol Amroth - Bank";
L[ "DolAmrothDocks" ]   = "Dol Amroth - Landungsbr\195\188cken";
L[ "DolAmrothGreatHall" ]  = "Dol Amroth - Gro\195\159e Halle";
L[ "DolAmrothLibrary" ]   = "Dol Amroth - Bibliothek";
L[ "DolAmrothWarehouse" ]   = "Dol Amroth - Lagerhaus";
L[ "DolAmrothMason" ]   = "Dol Amroth - Maurerei";
L[ "DolAmrothSwanKnights" ]   = "Dol Amroth - Schwanenritter";
L[ "MenOfRingloVale" ]   = "Bewohner des Ringl\195\179tals";
L[ "MenOfDorEnErnil" ]   = "Bewohner von Dor-en-Ernil";
L[ "MenOfLebennin" ]    = "Bewohner von Lebennin";
L[ "Pelargir" ]     = "Pelargir";
L[ "RangersOfIthilien" ]    = "Waldl\195\164ufer von Ithilien";
L[ "DefendersOfMinasTirith" ]   = "Verteidiger von Minas Tirith";
L[ "RidersOfRohan" ]    = "Reiter von Rohan";
L[ "HostOfTheWest" ]  = "Heer des Westens";
L[ "HostOfTheWestArmour" ] = "Heer des Westens: R\195\188stung";
L[ "HostOfTheWestWeapons" ] = "Heer des Westens: Waffen";
L[ "HostOfTheWestProvisions" ] = "Heer des Westens: Vorr\195\164te";
L[ "ConquestOfGorgoroth" ]   = "Eroberung von Gorgoroth";
L[ "EnmityOfFushaumBalSouth" ] = "Feind des s\195\188dlichen Fushaum Bal";
L[ "EnmityOfFushaumBalNorth" ] = "Feind des n\195\182rdlichen Fushaum Bal";
L[ "RedSkyClan" ]   = "Rothimmel-Sippe";
L[ "DwarvesOfErebor" ]   = "Zwerge vom Erebor";
L[ "ElvesOfFelegoth" ]   = "Elben von Felegoth";
L[ "MenOfDale" ]   = "Menschen von Thal";
L[ "ChickenChasingLeagueOfEriador" ]  = "H\195\188hnerjagd-Liga von Eriador";
L[ "TheAleAssociation" ]   = "Die Bier-Genossenschaft";
L[ "TheInnLeague" ]   = "Die Gasthausliga";
L[ "GreyMountainsExpedition" ]   = "Expedition ins Graue Gebirge";
L[ "Wilderfolk" ]    = "Wildes Volk";
L[ "TheGreatAlliance" ]   = "Die Grosse Allianz";
L[ "TheWhiteCompany" ]   = "Die Weisse Schar";
L[ "ReclamationOfMinasIthil" ]   = "Die R\195\188ckeroberung von Minas Ithil";
L[ "ProtectorsOfWilderland" ]   = "Besch\195\188tzer des Wilderlands";
L[ "MarchOnGundabad" ]   = "Marsch auf Gundabad";
L[ "TheGabilakka" ]    = "Die Gabil'akk\195\162";
L[ "WoodcuttersBrotherhood"]	   = "Bruderschaft der Holzf\195\164ller";
L[ "TheLeagueOfTheAxe"]   = "Der Bund der Axt";
L[ "TheHabanakkaOfThrain" ]   = "Die Haban’akk\195\162 von Thr\195\161in";
L[ "KharumUbnar" ]    = "Kharum-ubn\195\162r";
L[ "ReclaimersOfTheMountainHold" ] = "R\195\188ckeroberer der Bergfestung";
L[ "DefendersOfTheAngle" ]  = "Verteidiger des Bogens";
L[ "TheYonderWatch" ]   = "Die Ferne Wacht";
L[ "DunedainOfCardolan" ]   = "Dúnedain von Cardolan";
L[ "ReputationAcceleration" ]   = "Rufbeschleunigung";

L["StewardsOfTheIronHome"] = "Truchsesse des eisernen Hauses"
L["TownsfolkOfTheKingstead"] = "Bewohner von Königsstatt"
L["TownsfolkOfTheEastfold"] = "Bewohner der Ostfold"
L["TheRenewalOfGondor"] = "Die Erneuerung Gondors"
L["UmbarCooksGuild"] = "Kochgilde von Umbar"
L["UmbarJewellersGuild"] = "Goldschmiedegilde von Umbar"
L["UmbarMetalsmithsGuild"] = "Umbar-Schmiedegilde"
L["UmbarScholarsGuild"] = "Gelehrtengilde von Umbar"
L["UmbarTailorsGuild"] = "Umbar-Schneidergilde"
L["UmbarWeaponsmithsGuild"] = "Umbar-Waffenschmiedegilde"
L["UmbarWoodworkersGuild"] = "Umbar-Drechslergilde"
L["CitizensOfUmbarBaharbel"] = "Bürger von Umbar Baharbêl"
L["PhetekariOfUmbar"] = "Phetekâri von Umbar"
L["TheIkorbani"] = "Die Ikorbâni"
L["TheAdurhid"] = "Die Adúrhid"
L["ThePathOfValour"] = "Der Pfad der Tapferkeit"
L["AmeliasStudies"] = "Amelias Studien"
L["MoriaBountyHunters"] = "Moria-Kopfgeldjäger"
L["KintaiOfSulMadash"] = "Kintai von Sul Madásh"
L["CityOfZajana"] = "Stadt Zajâna"
L["TemamirOfJiretMenesh"] = "Temámir von Jiret-menêsh"
L["HamatRenewed"] = "Das Erneuerte Hamât"
L["HuntersGuildOfMurGhala"] = "Jägergilde von Mûr Ghala"

-- All reputation standings
L[ "RPMSR" ]  = "Maximalen Ruf erreicht";
L[ "Neutral" ]  = "Neutral";
L[ "Acquaintance" ]  = "Bekannter";
L[ "Friend" ]  = "Freund";
L[ "Ally" ]  = "Verb\195\188ndeter";
L[ "Kindred" ]  = "Verwandter";
L[ "Respected" ]  = "Respektiert";
L[ "Honoured" ]  = "Verehrt";
L[ "Celebrated" ]  = "Gefeiert";
L[ "Outsider" ]  = "Au\195\159enseiter";
L[ "Enemy" ]  = "Feind";
L[ "Member" ] = "Mitglied";
L[ "GuildInitiate" ]  = "Eingeweihter";
L[ "ApprenticeOfTheGuild" ]  = "Lehrling";
L[ "JourneymanOfTheGuild" ]  = "Geselle";
L[ "ExpertOfTheGuild" ]  = "Experte";
L[ "ArtisanOfTheGuild" ]  = "Virtuose";
L[ "MasterOfTheGuild" ]  = "Meister";
L[ "EastemnetMasterOfTheGuild" ]  = "Ost-Emnet-Meister der Gilde";
L[ "WestemnetMasterOfTheGuild" ]  = "West-Emnet-Meister der Gilde";
L[ "HonouredMasterOfTheGuild" ]  = "Ehrenmeister der Gilde";
L[ "UmbarGuildMember" ]  = "Umbar-Gildenmitglied";
L[ "Rookie" ] = "Grünschnabel";
L[ "MinorLeaguer" ] = "Minor Leaguer"; --male: Mittelklassespieler female: Mittelklassespielerin
L[ "MajorLeaguer" ] = "Major Leaguer"; --male: Meisterspieler female: Meisterspielerin
L[ "AllStar" ] = "All-star"; --male: Spitzenspieler female: Spitzenspielerin
L[ "HallOfFamer" ] = "Hall of Famer"; --male: Rekordspieler female: Rekordspielerin
L[ "BonusRemaining" ]   = "Verbleibender Bonus";
L[ "TheReclamation" ]  = "Die R\195\188ckeroberung von Minas Ithil";
L[ "TheReclamationContinues" ]  = "Die R\195\188ckeroberung geht weiter I";
L[ "TheTrialOfWrath" ]  = "Pr\195\188fung des Zorn";
L[ "TheReclamationContinuesIi" ]  = "Die R\195\188ckeroberung geht weiter II";
L[ "TheTrialOfSorrow" ]  = "Pr\195\188fung der Trauer";
L[ "TheReclamationContinuesIii" ]  = "Die R\195\188ckeroberung geht weiter III";
L[ "TheTrialOfMadness" ]  = "Pr\195\188fung des Wahnsinn";
L[ "TheReclamationContinuesIv" ]  = "Die R\195\188ckeroberung geht weiter IV";
L[ "TheTrialOfDespair" ]  = "Pr\195\188fung der Verzweiflung";
L[ "TheTrialOfDeath" ] = "Pr\195\188fung des Todes";
L[ "Idmul" ] = "Idmul";
L[ "Dumul" ] = "Dumul";
L[ "Izkhas" ] = "Izkhas";
L[ "Uzkhas" ] = "Uzkhas";
L[ "Fabaral" ] = "Fabar\195\162l";
L[ "Azghzabad" ] = "Azghzabad";

-- Reputation changes
L[ "RPDECREASE"] = "verschlechtert";

-- Infamy/Renown window
if PlayerAlign == 1 then L[ "IFWTitle" ] = "Ansehen"; L[ "IFIF" ] = "Gesamtes Ansehen:";
else L[ "IFWTitle" ] = "Verrufenheit"; L[ "IFIF" ] = "Gesamte Verrufenheit:"; end
L[ "IFCR" ] = "Euer Rang:";
L[ "IFTN" ] = "Punkte f\195\188r den n\195\164chsten Rang";

-- GameTime window
L[ "GTWTitle" ] = "Lokale/Server Zeit";
L[ "GTW24h" ] = "Anzeige der Uhrzeit im 24 Stunden-Format";
L[ "GTWSST" ] = "Zeige Serverzeit       GMT";
L[ "GTWSBT" ] = "Lokale und Server-Zeit zeigen";
L[ "GTWST" ] = "Server: ";
L[ "GTWRT" ] = "Lokal: ";

-- More Options window
L[ "OPWTitle" ] = L[ "MOP" ];
L[ "OPHText" ] = "H\195\182he:";
L[ "OPFText" ] = "Schriftart:";
L[ "OPAText" ] = "Automatisch im Hintergrund:";
L[ "OPAHD" ] = "niemals";
L[ "OPAHE" ] = "immer";
L[ "OPAHC" ] = "Nur in der Schlacht";
L[ "OPIText" ] = "Icon-Gr\195\182\195\159e:";
L[ "OPTBTop" ] = "Oben am Bildschirm";
L[ "OPISS" ] = "klein";
L[ "OPISM" ] = "medium";
L[ "OPISL" ] = "breit";
L[ "Layout" ] = "Alternatives PlayerInfo Layout\nL\195\164dt TB nach \195\132nderung neu";

-- Profile window
L[ "PWProfile" ] = "Profil";
L[ "PWEPN" ] = "Gebt einen Profilnamen ein";
L[ "PWCreate" ] = "erstellen";
L[ "PWNew" ] = "Neues Profil";
L[ "PWCreated" ] = "wurde erstellt";
L[ "PWLoad" ] = "laden";
L[ "PWNFound" ] = "Kein Profil gefunden";
L[ "PWFail" ] = " kann nicht geladen werden, da Sprache des Spiels nicht mit jener des Profils \195\188bereinstimmt";
L[ "PWLoaded" ] = "geladen";
L[ "PWDelete" ] = "L\195\182schen";
L[ "PWDeleteFailed" ] = "Profil konnte nicht gel\195\182scht werden ";
L[ "PWFailDelete" ] = " kann nicht gel\195\182scht werden, da Sprache im Profil und im Spiel nicht \195\188bereinstimmt";
L[ "PWDeleted" ] = "gel\195\182scht";
L[ "PWSave" ] = "speichern";
L[ "PWSaved" ] = "gespeichert";
L[ "PWCancel" ] = "abbrechen";

-- Shell commands window
L[ "SCWTitle" ] = "TitanBar Shell-Befehle";
L[ "SCWC1" ] = "Zeigt TitanBar Optionen";
L[ "SCWC2" ] = "Entfernt TitanBar";
L[ "SCWC3" ] = "L\195\164dt TitanBar neu";
L[ "SCWC4" ] = "Zur\195\188cksetzen aller Einstellungen auf die Standardwerte";

-- Shell commands
L[ "SC0" ] = "Befehl wird nicht unterst\195\188tzt";
L[ "SCa1" ] = "Optionen";
L[ "SCb1" ] = "opt / ";
L[ "SCa2" ] = "entfernen";
L[ "SCb2" ] = "  u / ";
L[ "SCa3" ] = "neu laden";
L[ "SCb3" ] = "  r / ";
L[ "SCa4" ] = "alle zur\195\188cksetzen";
L[ "SCb4" ] = " ra / ";

-- Durability infos window
L[ "DWTitle" ] = "Haltbarkeit-Infos";
L[ "DWLbl" ] = " besch\195\164digter Gegenstand";
L[ "DWLbls" ] = " besch\195\164digte Gegenst\195\164nde";
L[ "DWLblND" ] = "Alle Eure Gegenst\195\164nde sind 100%";
L[ "DIIcon" ] = " Symbole im Tooltip";
L[ "DIText" ] = " Namen im Tooltip";
L[ "DWnint" ] = " Symbole & Namen sind ausgeblendet";

-- Equipment infos window
--L[ "EWTitle" ] = "Ausstattung Infos";
L[ "EWLbl" ] = "Vom Charakter getragene Ausr\195\188stung";
L[ "EWLblD" ] = "Punkte";
L[ "EWItemNP" ] = " Artikel nicht vorhanden";
--L[ "EWItemF" ] = " Element gefunden";
--L[ "EWItemsF" ] = " Artikel gefunden";
L[ "EWST1" ] = "Kopf";
L[ "EWST13" ] = "Linker Ohrring";
L[ "EWST14" ] = "Rechter Ohrring";
L[ "EWST10" ] = "Halskette";
L[ "EWST6" ] = "Schultern";
L[ "EWST7" ] = "R\195\188cken";
L[ "EWST2" ] = "Brust";
L[ "EWST8" ] = "Linkes Handgelenk";
L[ "EWST9" ] = "Rechtes Handgelenk";
L[ "EWST11" ] = "Linker Ring";
L[ "EWST12" ] = "Rechter Ring";
L[ "EWST4" ] = "Handschuhe";
L[ "EWST3" ] = "Beine";
L[ "EWST5" ] = "F\195\188\195\159e";
L[ "EWST15" ] = "Beutel";
L[ "EWST16" ] = "Hauptwaffe";
L[ "EWST17" ] = "Zweitwaffe";
L[ "EWST18" ] = "Fernwaffe";
L[ "EWST19" ] = "Handwerkzeug";
L[ "EWST20" ] = "Klassenfeld";

-- Player Infos control
L[ "PICHAR" ]  = "Charakter";
L[ "PIRACE" ]  = "Volk";
L[ "PICLASS" ]  = "Klasse";
L[ "PILEVEL" ]  = "Stufe";
L[ "PILVLXP" ]  = "EP benöt./erreicht";
L[ "PILVLXPCAP" ] = "am Max"
L[ "PILIREF" ]  = "LI Neu schmieden";
L[ "PILIREFFMT" ]  = "iLvl #iLvl @ #cLvl";
L[ "PIVITALS" ]  = "Vitale Werte";
L[ "PICURR" ] = "Akt.";
L[ "PIMORALE" ]  = "Maximum Moral";
L[ "PIICMR" ]  = "Moralreg. im K.";
L[ "PINCMR" ]  = "Moralreg. au\195\159 K.";
L[ "PIPOWER" ]  = "Maximum Kraft";
L[ "PIICPR" ]  = "Kraftreg. im K.";
L[ "PINCPR" ]  = "Kraftreg. au\195\159 K.";
L[ "PIMAIN" ]  = "Hauptattribute";
L[ "PIMIGHT" ]  = "Macht";
L[ "PIAGILITY" ] = "Beweglichkeit";
L[ "PIVITALITY" ] = "Vitalität";
L[ "PIWILL" ] = "Wille";
L[ "PIFATE" ] = "Schicksal";
L[ "PIOFFENCE" ] = "Angriff";
L[ "PICURRAT" ] = "Akt. #";
L[ "PICURPERC" ] = "-> %";
L[ "PICAPRAT" ] = "Cap #";
L[ "PICAPPERC" ] = "-> %";
L[ "PIMELDMG" ] = "Nahkampf Sch.";
L[ "PIRNGDMG" ] = "Fernkampf Sch.";
L[ "PITACDMG" ] = "Taktischer Sch.";
L[ "PICRITHIT" ] = "Krit. Treffer";
L[ "PIDEVHIT" ] = "Verwüstet";
L[ "PICRITMAGN" ] = "Krit. Ausma\195\159";
L[ "PIFINESSE" ] = "Finesse";
L[ "PIHEALING" ] = "Heilung";
L[ "PIOUTHEAL" ] = "Ausgehende";
L[ "PIINHEAL" ] = "Empfangene";
L[ "PIDEFENCE" ] = "Verteidigung";
L[ "PICRITDEF" ] = "Krit. Verteid.";
L[ "PIRESIST" ] = "Resistenz";
L[ "PICAPPED1" ] = "Gelb - am Maximum für Landschaft/T1";
L[ "PICAPPED2" ] = "Orange - am Maximum für T2";
L[ "PICAPPED3" ] = "Rot - am Maximum für T3+";
L[ "PICAPPED4" ] = "Lila - am Maximum mit Enh. III effekt";
L[ "PICSDEP" ] = "Für dieses Fenster muss CalcStat installiert sein."
L[ "PIAVOID" ] = "Entgehen";
L[ "PIBLOCK" ] = "Blocken";
L[ "PIBLOCKPART" ] = "Teilerfolg";
L[ "PIBLOCKPMIT" ] = "Teil. Verring.";
L[ "PIPARRY" ] = "Parieren";
L[ "PIPARRYPART" ] = "Teilerfolg";
L[ "PIPARRYPMIT" ] = "Teil. Verring.";
L[ "PIEVADE" ] = "Ausweichen";
L[ "PIEVADEPART" ] = "Teilerfolg";
L[ "PIEVADEPMIT" ] = "Teil. Verring.";
L[ "PIMITS" ] = "Schadensreduz.";
L[ "PIPHYMIT" ] = "Physisch";
L[ "PIORCMIT" ] = "Ork-Waffen";
L[ "PIFWMIT" ] = "Hass";
L[ "PITACMIT" ] = "Taktisch";
L[ "PIFIREMIT" ] = "Feuer";
L[ "PILIGHTNMIT" ] = "Blitz";
L[ "PIFROSTMIT" ] = "Frost";
L[ "PIACIDMIT" ] = "Säure";
L[ "PISHADMIT" ] = "Schatten";
L[ "PINOTAVAIL" ] = "n. v.";

-- Money Infos control
L[ "MGh" ] = "Menge der Goldm\195\188nzen";
L[ "MSh" ] = "Menge der Silberm\195\188nzen";
L[ "MCh" ] = "Menge der Kupferm\195\188nzen";
L[ "MGB" ] = "Beutel mit Goldm\195\188nzen";
L[ "MSB" ] = "Beutel mit Silberm\195\188nzen";
L[ "MCB" ] = "Beutel mit Kupferm\195\188nzen";

-- Bag Infos control
--L[ "BIh" ] = "Rucksack Informationen";
--L[ "BIt1" ] = "belegte Pl\195\164tze / max";
L[ "BINI" ] = "Es wird kein Artikel verfolgt!\nLinksklick, um Eure Artikel zu sehen.";
L[ "BIIL" ] = "Artikel-Liste";
L[ "BIT" ] = "Aktiviert / deaktiviert ein Element";
L[ "BIUsed" ] = " Freie Taschenpl\195\164tze anzeigen";
L[ "BIMax" ] = " Taschenpl\195\164tze gesamt anzeigen";
L[ "BIMsg" ] = "Es wurde kein stapelbares Element gefunden.";

-- Equipment Infos control
L[ "EIh" ] = "Punkte Eures Equipments";
L[ "EIt1" ] = "Linksklick, um Optionsfenster zu \195\182ffnen";
L[ "EIt2" ] = "Zum Verschieben Linksklick halten";
L[ "EIt3" ] = "Rechtsklick f\195\188r Kontextmen\195\188";

-- Durability Infos control
L[ "DIh" ] = "Haltbarkeit Eurer Ausr\195\188stung";

-- Player Location control
L[ "PLh" ] = "Hier seid Ihr";
L[ "PLMsg" ] = "Bitte Stadt betreten";

-- Game Time control
L[ "GTh" ] = "Lokale/Server Zeit";

-- Chat message
L[ "TBR" ] = "TitanBar: Alle Einstellungen wurden zur\195\188ck auf die Standardwerte gesetzt";

-- Player Race names: 'PR' + Race Id
-- Add appropriate Race Id entry for new/unknown races.
-- Unlisted Race Id's show up in the Player infos tooltip.
L[ "PR65" ] = "Elb";
L[ "PR23" ] = "Mensch";
L[ "PR73" ] = "Zwerg";
L[ "PR81" ] = "Hobbit";
L[ "PR114" ] = "Beorninger";
L[ "PR117" ] = "Hochelb";
L[ "PR120" ] = "Stark-Axt";
L[ "PR125" ] = "Fluss-Hobbit";
L[ "PR7" ] = "Orc";
L[ "PR6" ] = "Uruk";
L[ "PR12" ] = "Spider";
L[ "PR66" ] = "Warg";
L[ "PR27" ] = "Critter";

-- Player Class names: 'PC' + Class Id
-- Add appropriate Class Id entry for new/unknown classes.
-- Unlisted Class Id's show up in the Player infos tooltip.
L[ "PC40" ] = "Schurke";
L[ "PC24" ] = "Hauptmann";
L[ "PC172" ] = "Waffenmeister";
L[ "PC23" ] = "W\195\164chter";
L[ "PC162" ] = "J\195\164ger";
L[ "PC185" ] = "Kundiger";
L[ "PC31" ] = "Barde";
L[ "PC193" ] = "Runenbewahrer";
L[ "PC194" ] = "H\195\188ter";
L[ "PC214" ] = "Beorning";
L[ "PC215" ] = "Schl\195\164ger";
L[ "PC216" ] = "Seefahrer";
L[ "PC71" ] = "Schnitter";
L[ "PC127" ] = "Weberspinne";
L[ "PC179" ] = "Schwarzpfeil";
L[ "PC52" ] = "Kriegsanf\195\188hrer";
L[ "PC126" ] = "Pirscher";
L[ "PC128" ] = "Saboteur";
L[ "PC192" ] = "H\195\188hn";

-- Durability
L[ "D" ] = "Haltbarkeit";
L[ "D1" ] = "Gesamte Haltbarkeit";
L[ "D2" ] = "Schwach";
L[ "D3" ] = "Best\195\164ndig";
L[ "D4" ] = "Br\195\188chig";
L[ "D5" ] = "Normal";
L[ "D6" ] = "Robust";
L[ "D7" ] = "Br\195\188chig";
L[ "D8" ] = "Unempfindlich";

-- Quality
L[ "Q" ] = "Qualit\195\164ten";
L[ "Q1" ] = "Alle Qualit\195\164ten";
L[ "Q2" ] = "Gew\195\182hnlich";
L[ "Q3" ] = "Ungew\195\182hnlich";
L[ "Q4" ] = "Unvergleichlich";
L[ "Q5" ] = "Selten";
L[ "Q6" ] = "Legend\195\164r";