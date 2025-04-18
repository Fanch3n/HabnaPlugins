-- functionsMenu.lua
-- Written By Habna


--**v Functions for the menu v**

-- **v Show/Hide Wallet v**
function ShowHideWallet()
	ShowWallet = not ShowWallet;
	settings.Wallet.V = ShowWallet;
	SaveSettings( false );
	if ShowWallet then
		--write( "TitanBar: Showing wallet control");
		ImportCtr( "WI" );
		WI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( WIbcAlpha, WIbcRed, WIbcGreen, WIbcBlue ) );
	else
		--write( "TitanBar: Hiding wallet control");
		if _G.frmWI then wWI:Close(); end
	end
	WI[ "Ctr" ]:SetVisible( ShowWallet );
	opt_WI:SetChecked( ShowWallet );
end
-- **^
-- **v Show/Hide Money v**
function ShowHideMoney()
	ShowMoney = not ShowMoney;
	settings.Money.V = ShowMoney;
	settings.Money.W = string.format("%.0f", _G.MIWhere);
	SaveSettings( false );
	ImportCtr( "MI" );
	if ShowMoney then
		--write( "TitanBar: Showing money");
		--ImportCtr( "MI" );
		MI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue ) );
	else
		--write( "TitanBar: Hiding money");
		if _G.frmMI then wMI:Close(); end
	end
	MI[ "Ctr" ]:SetVisible( ShowMoney );
end
-- **^
-- **v Show/Hide LOTRO Points v**
function ShowHideLOTROPoints()
	ShowLOTROPoints = not ShowLOTROPoints;
	settings.LOTROPoints.V = ShowLOTROPoints;
	settings.LOTROPoints.W = string.format("%.0f", _G.LPWhere);
	SaveSettings( false );
	ImportCtr( "LP" );
	if ShowLOTROPoints then
		LP[ "Ctr" ]:SetBackColor( Turbine.UI.Color( LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue ) );
	else
		if _G.frmLP then wLP:Close(); end
	end
	LP[ "Ctr" ]:SetVisible( ShowLOTROPoints );
end
-- **^
-- **v Show/Hide backpack Infos v**
function ShowHideBackpackInfos()
	ShowBagInfos = not ShowBagInfos;
	settings.BagInfos.V = ShowBagInfos;
	SaveSettings( false );
	if ShowBagInfos then
		ImportCtr( "BI" );
		BI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue ) );
	else
		RemoveCallback(backpack, "ItemAdded");
		RemoveCallback(backpack, "ItemRemoved");
		if _G.frmBI then wBI:Close(); end
	end
	BI[ "Ctr" ]:SetVisible( ShowBagInfos );
	opt_BI:SetChecked( ShowBagInfos );
end
--**^
-- **v Show/Hide backpack Infos v**
function ShowHidePlayerInfos()
	ShowPlayerInfos = not ShowPlayerInfos;
	settings.PlayerInfos.V = ShowPlayerInfos;
	SaveSettings( false );
	if ShowPlayerInfos then
		ImportCtr( "PI" );
		PI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( PIbcAlpha, PIbcRed, PIbcGreen, PIbcBlue ) );
	else
		RemoveCallback(Player, "LevelChanged");
		RemoveCallback(Player, "NameChanged");
		RemoveCallback(Turbine.Chat, "Received", XPcb);
	end
	PI[ "Ctr" ]:SetVisible( ShowPlayerInfos );
	opt_PI:SetChecked( ShowPlayerInfos );
end
--**^
-- **v Show/Hide equipment Infos v**
function ShowHideEquipInfos()
	ShowEquipInfos = not ShowEquipInfos;
	settings.EquipInfos.V = ShowEquipInfos;
	SaveSettings( false );
	if ShowEquipInfos then
		GetEquipmentInfos();
		AddCallback(PlayerEquipment, "ItemEquipped", function(sender, args) if ShowEquipInfos then GetEquipmentInfos(); UpdateEquipsInfos(); end end);
		AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) ItemUnEquippedTimer:SetWantsUpdates( true ); end); --Workaround
		ImportCtr( "EI" );
		EI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue ) );
	else
		RemoveCallback(PlayerEquipment, "ItemEquipped");
		RemoveCallback(PlayerEquipment, "ItemUnequipped");
		if _G.frmEI then wEI:Close(); end
	end
	EI[ "Ctr" ]:SetVisible( ShowEquipInfos );
	opt_EI:SetChecked( ShowEquipInfos );
end
--**^
-- **v Show/Hide durability Infos v**
function ShowHideDurabilityInfos()
	ShowDurabilityInfos = not ShowDurabilityInfos;
	settings.DurabilityInfos.V = ShowDurabilityInfos;
	SaveSettings( false );
	if ShowDurabilityInfos then
		GetEquipmentInfos();
		AddCallback(PlayerEquipment, "ItemEquipped", function(sender, args) if ShowEquipInfos then GetEquipmentInfos(); UpdateEquipsInfos(); end if ShowDurabilityInfos then GetEquipmentInfos(); UpdateDurabilityInfos(); end end);
		AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) ItemUnEquippedTimer:SetWantsUpdates( true ); end); --Workaround
		ImportCtr( "DI" );
		DI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue ) );
	else
		RemoveCallback(PlayerEquipment, "ItemEquipped");
		RemoveCallback(PlayerEquipment, "ItemUnequipped");
		if _G.frmDI then wDI:Close(); end
	end
	DI[ "Ctr" ]:SetVisible( ShowDurabilityInfos );
	opt_DI:SetChecked( ShowDurabilityInfos );
end
--**^
-- **v Show/Hide Tracked Items Infos v**
function ShowHideTrackItems()
	ShowTrackItems = not ShowTrackItems;
	settings.TrackItems.V = ShowTrackItems;
	SaveSettings( false );
	if ShowTrackItems then
		ImportCtr( "TI" );
		TI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue ) );
	else
		if _G.frmTI then wTI:Close(); end
	end
	TI[ "Ctr" ]:SetVisible( ShowTrackItems );
	opt_TI:SetChecked( ShowTrackItems );
end
--**^
-- **v Show/Hide Infamy v**
function ShowHideInfamy()
	ShowInfamy = not ShowInfamy;
	settings.Infamy.V = ShowInfamy;
	SaveSettings( false );
	if ShowInfamy then
		ImportCtr( "IF" );
		IF[ "Ctr" ]:SetBackColor( Turbine.UI.Color( IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue ) );
	else
		RemoveCallback(Turbine.Chat, "Received", IFcb);
		if _G.frmIF then wIF:Close(); end
	end
	IF[ "Ctr" ]:SetVisible( ShowInfamy );
	opt_IF:SetChecked( ShowInfamy );
end
-- **^
-- **v Show/Hide Vault v**
function ShowHideVault()
	ShowVault = not ShowVault;
	settings.Vault.V = ShowVault;
	SaveSettings( false );
	if ShowVault then
		ImportCtr( "VT" );
		VT[ "Ctr" ]:SetBackColor( Turbine.UI.Color( VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue ) );
	else
		RemoveCallback(vaultpack, "CountChanged");
		if _G.frmVT then wVT:Close(); end
	end
	VT[ "Ctr" ]:SetVisible( ShowVault );
	opt_VT:SetChecked( ShowVault );
end
-- **^
-- **v Show/Hide SharedStorage v**
function ShowHideSharedStorage()
	ShowSharedStorage = not ShowSharedStorage;
	settings.SharedStorage.V = ShowSharedStorage;
	SaveSettings( false );
	if ShowSharedStorage then
		ImportCtr( "SS" );
		SS[ "Ctr" ]:SetBackColor( Turbine.UI.Color( SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue ) );
	else
		RemoveCallback(sspack, "CountChanged");
		if _G.frmSS then wSS:Close(); end
	end
	SS[ "Ctr" ]:SetVisible( ShowSharedStorage );
	opt_SS:SetChecked( ShowSharedStorage );
end
-- **^
-- **v Show/Hide Bank v**
function ShowHideBank()
	ShowBank = not ShowBank;
	settings.Bank.V = ShowBank;
	SaveSettings( false );
	if ShowBank then
		ImportCtr( "BK" );
		BK[ "Ctr" ]:SetBackColor( Turbine.UI.Color( BKbcAlpha, BKbcRed, BKbcGreen, BKbcBlue ) );
	else
	end
	BK[ "Ctr" ]:SetVisible( ShowBank );
	opt_BK:SetChecked( ShowBank );
end
-- **^
-- **v Show/Hide Day & Night time v**
function ShowHideDayNight()
	ShowDayNight = not ShowDayNight;
	settings.DayNight.V = ShowDayNight;
	SaveSettings( false );
	if ShowDayNight then
		ImportCtr( "DN" );
		DN[ "Ctr" ]:SetBackColor( Turbine.UI.Color( DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue ) );
	else
		if _G.frmDN then wDN:Close(); end
	end
	DN[ "Ctr" ]:SetVisible( ShowDayNight );
	opt_DN:SetChecked( ShowDayNight );
end
-- **^
-- **v Show/Hide Reputation v**
function ShowHideReputation()
	ShowReputation = not ShowReputation;
	settings.Reputation.V = ShowReputation;
	SaveSettings( false );
	if ShowReputation then
		ImportCtr( "RP" );
		RP[ "Ctr" ]:SetBackColor( Turbine.UI.Color( RPbcAlpha, RPbcRed, RPbcGreen, RPbcBlue ) );
	else
		RemoveCallback(Turbine.Chat, "Received", ReputationCallback);
		if _G.frmRP then wRP:Close(); end
	end
	RP[ "Ctr" ]:SetVisible( ShowReputation );
	opt_RP:SetChecked( ShowReputation );
end
-- **^

-- **v Show/Hide Player Location v**
function ShowHidePlayerLoc()
	ShowPlayerLoc = not ShowPlayerLoc;
	settings.PlayerLoc.V = ShowPlayerLoc;
	SaveSettings( false );
	if ShowPlayerLoc then
		ImportCtr( "PL" );
		PL[ "Ctr" ]:SetBackColor( Turbine.UI.Color( PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue ) );
	else
		RemoveCallback(Turbine.Chat, "Received", PLcb);
	end
	PL[ "Ctr" ]:SetVisible( ShowPlayerLoc );
	opt_PL:SetChecked( ShowPlayerLoc );
end
--**^
-- **v Show/Hide Time v**
function ShowHideGameTime()
	ShowGameTime = not ShowGameTime;
	settings.GameTime.V = ShowGameTime;
	SaveSettings( false );
	if ShowGameTime then
		ImportCtr( "GT" );
		GT[ "Ctr" ]:SetBackColor( Turbine.UI.Color( GTbcAlpha, GTbcRed, GTbcGreen, GTbcBlue ) );
	else
		if _G.frmGT then wGT:Close(); end
	end
	GT[ "Ctr" ]:SetVisible( ShowGameTime );
	opt_GT:SetChecked( ShowGameTime );
end
--**^
-- **v Profile load/Save v**
function LoadPlayerProfile()
	PProfile = Turbine.PluginData.Load( Turbine.DataScope.Account, "TitanBarPlayerProfile" );
	if PProfile == nil then PProfile = {}; end
end

function SavePlayerProfile()
	-- The table key is saved with "," in DE & FR clients. Ex. [1,000000]. This causes a parse error.
	-- If you change [1,000000] to [1.000000] error is not there any more. [1] would be easier! Why all those zeroes!
	-- So LOTRO saves the table key in the client language, but lua is unable to read it since "," is a special character.
	-- LOTRO just has to save the key in English and the value in the client language.

	-- So I'm converting the key [1,000000] into a string like this ["1"]
	-- That's VindarPatch's doing, it converts the whole table into string (key and value)
	-- Now I only need to convert the key since the values are already in the correct language format.
	local newt = {};
	for i, v in pairs(PProfile) do newt[tostring(i)] = v; end
	PProfile = newt;

	Turbine.PluginData.Save( Turbine.DataScope.Account, "TitanBarPlayerProfile", PProfile );
end
--**^
-- **v Show Shell Command window v**
function HelpInfo()
	if frmSC then
		wShellCmd:Close();
	else
		import(AppDirD.."shellcmd"); -- LUA shell command file
		frmShellCmd();
	end
end
-- **^
--**v Unload TitanBar v**
function UnloadTitanBar()
	Turbine.PluginManager.LoadPlugin( 'TitanBar Unloader' ); --workaround
end
--**^
--**v Reload TitanBar v**
function ReloadTitanBar()
	settings.TitanBar.Z = true;
	SaveSettings( false );
	Turbine.PluginManager.LoadPlugin( 'TitanBar Reloader' ); --workaround
end
--**^
--**v About TitanBar v**
function AboutTitanBar()
	--write( "TitanBar: About!" );
	--Turbine.PluginManager.ShowAbouts(Plugins.TitanBar); -- Add this when About is available
	--Turbine.PluginManager.ShowOptions(Plugins.TitanBar); --This will open plugin manager and show TitanBar options (THIS IS AN EXAMLPE)
end
--**^

function ShowHideCurrency(currency)
	_G.CurrencyData[currency].IsVisible = not _G.CurrencyData[currency].IsVisible
	settings[currency].V = _G.CurrencyData[currency].IsVisible
	settings[currency].W = string.format( "%.0f", _G.CurrencyData[currency].Where);
	SaveSettings( false );
	ImportCtr(currency);
	
	if _G.Debug then write("ShowHideCurrency:"..currency); end
	if _G.CurrencyData[currency].IsVisible then
		_G.CurrencyData[currency].Ctr:SetBackColor(Turbine.UI.Color(
			_G.CurrencyData[currency].bcAlpha,
			_G.CurrencyData[currency].bcRed,
			_G.CurrencyData[currency].bcGreen,
			_G.CurrencyData[currency].bcBlue
		))
	end
	_G.CurrencyData[currency].Ctr:SetVisible(_G.CurrencyData[currency].IsVisible);
end