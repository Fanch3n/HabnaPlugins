-- functionsMenu.lua
-- Written By Habna


--**v Functions for the menu v**

-- **v Show/Hide Wallet v**
function ShowHideWallet()
	local controlData = _G.ControlData.WI
	controlData.show = not controlData.show
	if not settings.Wallet then settings.Wallet = {} end
	settings.Wallet.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		--write( "TitanBar: Showing wallet control");
		ImportCtr( "WI" );
		local colors = _G.ControlData.WI.colors
		WI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		--write( "TitanBar: Hiding wallet control");
		local window = _G.ControlData.WI.windowInstance; if window then window:Close(); end
	end
	WI[ "Ctr" ]:SetVisible( controlData.show );
	opt_WI:SetChecked( controlData.show );
end
-- **^
-- **v Show/Hide Money v**
function ShowHideMoney()
	local controlData = _G.ControlData.Money
	controlData.show = not controlData.show
	if not settings.Money then settings.Money = {} end
	settings.Money.V = controlData.show
	settings.Money.W = string.format("%.0f", _G.MIWhere);
	SaveSettings( false );
	ImportCtr( "MI" );
	if controlData.show then
		--write( "TitanBar: Showing money");
		--ImportCtr( "MI" );
		local colors = _G.ControlData.Money.colors
		MI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		--write( "TitanBar: Hiding money");
		local window = _G.ControlData.Money.windowInstance; if window then window:Close(); end
	end
	MI[ "Ctr" ]:SetVisible( controlData.show );
end
-- **^
-- **v Show/Hide LOTRO Points v**
function ShowHideLOTROPoints()
	local controlData = _G.ControlData.LP
	controlData.show = not controlData.show
	if not settings.LOTROPoints then settings.LOTROPoints = {} end
	settings.LOTROPoints.V = controlData.show
	settings.LOTROPoints.W = string.format("%.0f", _G.LPWhere);
	SaveSettings( false );
	ImportCtr( "LP" );
	if controlData.show then
		local colors = _G.ControlData.LP.colors
		LP[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		local window = _G.ControlData.LP.windowInstance; if window then window:Close(); end
	end
	LP[ "Ctr" ]:SetVisible( controlData.show );
end
-- **^
-- **v Show/Hide backpack Infos v**
function ShowHideBackpackInfos()
	local controlData = _G.ControlData.BI
	controlData.show = not controlData.show
	if not settings.BagInfos then settings.BagInfos = {} end
	settings.BagInfos.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "BI" );
		local colors = _G.ControlData.BI.colors
		BI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(backpack, "ItemAdded");
		RemoveCallback(backpack, "ItemRemoved");
		local window = _G.ControlData.BI.windowInstance; if window then window:Close(); end
	end
	BI[ "Ctr" ]:SetVisible( controlData.show );
	opt_BI:SetChecked( controlData.show );
end
--**^
-- **v Show/Hide backpack Infos v**
function ShowHidePlayerInfos()
	local controlData = _G.ControlData.PI
	controlData.show = not controlData.show
	if not settings.PlayerInfos then settings.PlayerInfos = {} end
	settings.PlayerInfos.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "PI" );
		local colors = _G.ControlData.PI.colors
		PI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(Player, "LevelChanged");
		RemoveCallback(Player, "NameChanged");
		RemoveCallback(Turbine.Chat, "Received", XPcb);
	end
	PI[ "Ctr" ]:SetVisible( controlData.show );
	opt_PI:SetChecked( controlData.show );
end
--**^
-- **v Show/Hide equipment Infos v**
function ShowHideEquipInfos()
	local controlData = _G.ControlData.EI
	controlData.show = not controlData.show
	if not settings.EquipInfos then settings.EquipInfos = {} end
	settings.EquipInfos.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		GetEquipmentInfos();
		AddCallback(PlayerEquipment, "ItemEquipped", function(sender, args) if _G.ControlData.EI.show then GetEquipmentInfos(); UpdateEquipsInfos(); end end);
		AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) ItemUnEquippedTimer:SetWantsUpdates( true ); end); --Workaround
		ImportCtr( "EI" );
		local colors = _G.ControlData.EI.colors
		EI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(PlayerEquipment, "ItemEquipped");
		RemoveCallback(PlayerEquipment, "ItemUnequipped");
		local window = _G.ControlData.EI.windowInstance; if window then window:Close(); end
	end
	EI[ "Ctr" ]:SetVisible( controlData.show );
	opt_EI:SetChecked( controlData.show );
end
--**^
-- **v Show/Hide durability Infos v**
function ShowHideDurabilityInfos()
	local controlData = _G.ControlData.DI
	controlData.show = not controlData.show
	if not settings.DurabilityInfos then settings.DurabilityInfos = {} end
	settings.DurabilityInfos.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		GetEquipmentInfos();
		AddCallback(PlayerEquipment, "ItemEquipped", function(sender, args) if _G.ControlData.EI.show then GetEquipmentInfos(); UpdateEquipsInfos(); end if _G.ControlData.DI.show then GetEquipmentInfos(); UpdateDurabilityInfos(); end end);
		AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) ItemUnEquippedTimer:SetWantsUpdates( true ); end); --Workaround
		ImportCtr( "DI" );
		local colors = _G.ControlData.DI.colors
		DI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(PlayerEquipment, "ItemEquipped");
		RemoveCallback(PlayerEquipment, "ItemUnequipped");
		local window = _G.ControlData.DI.windowInstance; if window then window:Close(); end
	end
	DI[ "Ctr" ]:SetVisible( controlData.show );
	opt_DI:SetChecked( controlData.show );
end
--**^
-- **v Show/Hide Tracked Items Infos v**
function ShowHideTrackItems()
	local controlData = _G.ControlData.TI
	controlData.show = not controlData.show
	if not settings.TrackItems then settings.TrackItems = {} end
	settings.TrackItems.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "TI" );
		local colors = _G.ControlData.TI.colors
		TI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		local window = _G.ControlData.TI.windowInstance; if window then window:Close(); end
	end
	TI[ "Ctr" ]:SetVisible( controlData.show );
	opt_TI:SetChecked( controlData.show );
end
--**^
-- **v Show/Hide Infamy v**
function ShowHideInfamy()
	local controlData = _G.ControlData.IF
	controlData.show = not controlData.show
	if not settings.Infamy then settings.Infamy = {} end
	settings.Infamy.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "IF" );
		local colors = _G.ControlData.IF.colors
		IF[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(Turbine.Chat, "Received", IFcb);
		local window = _G.ControlData.IF.windowInstance; if window then window:Close(); end
	end
	IF[ "Ctr" ]:SetVisible( controlData.show );
	opt_IF:SetChecked( controlData.show );
end
-- **^
-- **v Show/Hide Vault v**
function ShowHideVault()
	local controlData = _G.ControlData.VT
	controlData.show = not controlData.show
	if not settings.Vault then settings.Vault = {} end
	settings.Vault.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "VT" );
		local colors = _G.ControlData.VT.colors
		VT[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(vaultpack, "CountChanged");
		local window = _G.ControlData.VT.windowInstance; if window then window:Close(); end
	end
	VT[ "Ctr" ]:SetVisible( controlData.show );
	opt_VT:SetChecked( controlData.show );
end
-- **^
-- **v Show/Hide SharedStorage v**
function ShowHideSharedStorage()
	local controlData = _G.ControlData.SS
	controlData.show = not controlData.show
	if not settings.SharedStorage then settings.SharedStorage = {} end
	settings.SharedStorage.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "SS" );
		local colors = _G.ControlData.SS.colors
		SS[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(sspack, "CountChanged");
		local window = _G.ControlData.SS.windowInstance; if window then window:Close(); end
	end
	SS[ "Ctr" ]:SetVisible( controlData.show );
	opt_SS:SetChecked( controlData.show );
end
-- **^
-- **v Show/Hide Day & Night time v**
function ShowHideDayNight()
	local controlData = _G.ControlData.DN
	controlData.show = not controlData.show
	if not settings.DayNight then settings.DayNight = {} end
	settings.DayNight.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "DN" );
		local colors = _G.ControlData.DN.colors
		DN[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		local window = _G.ControlData.DN.windowInstance; if window then window:Close(); end
	end
	DN[ "Ctr" ]:SetVisible( controlData.show );
	opt_DN:SetChecked( controlData.show );
end
-- **^
-- **v Show/Hide Reputation v**
function ShowHideReputation()
	local controlData = _G.ControlData.RP
	controlData.show = not controlData.show
	if not settings.Reputation then settings.Reputation = {} end
	settings.Reputation.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "RP" );
		local colors = _G.ControlData.RP.colors
		RP[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(Turbine.Chat, "Received", ReputationCallback);
		local window = _G.ControlData.RP.windowInstance; if window then window:Close(); end
	end
	RP[ "Ctr" ]:SetVisible( controlData.show );
	opt_RP:SetChecked( controlData.show );
end
-- **^

-- **v Show/Hide Player Location v**
function ShowHidePlayerLoc()
	local controlData = _G.ControlData.PL
	controlData.show = not controlData.show
	if not settings.PlayerLoc then settings.PlayerLoc = {} end
	settings.PlayerLoc.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "PL" );
		local colors = _G.ControlData.PL.colors
		PL[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		RemoveCallback(Turbine.Chat, "Received", PLcb);
	end
	PL[ "Ctr" ]:SetVisible( controlData.show );
	opt_PL:SetChecked( controlData.show );
end
--**^
-- **v Show/Hide Time v**
function ShowHideGameTime()
	local controlData = _G.ControlData.GT
	controlData.show = not controlData.show
	if not settings.GameTime then settings.GameTime = {} end
	settings.GameTime.V = controlData.show
	SaveSettings( false );
	if controlData.show then
		ImportCtr( "GT" );
		local colors = _G.ControlData.GT.colors
		GT[ "Ctr" ]:SetBackColor( Turbine.UI.Color( colors.alpha, colors.red, colors.green, colors.blue ) );
	else
		local window = _G.ControlData.GT.windowInstance; if window then window:Close(); end
	end
	GT[ "Ctr" ]:SetVisible( controlData.show );
	opt_GT:SetChecked( controlData.show );
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
