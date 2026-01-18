-- frmMain.lua
-- written by Habna


function frmMain()
	--**v Check if TitanBar Reloader/Unloader is loaded v**
	Turbine.PluginManager.RefreshAvailablePlugins();

	TBRChecker = Turbine.UI.Control();
	TBRChecker:SetWantsUpdates(true);

	TBRChecker.Update = function(sender, args)
		local loaded_plugins = Turbine.PluginManager.GetLoadedPlugins();
		for k, v in pairs(loaded_plugins) do
			if v.Name == "TitanBar Reloader" then
				Turbine.PluginManager.UnloadScriptState('TitanBarReloader');
			elseif v.Name == "TitanBar Unloader" then
				Turbine.PluginManager.UnloadScriptState('TitanBarUnloader');
			end
		end
		TBRChecker:SetWantsUpdates(false);
	end
	--**^
	
	TB["win"] = Turbine.UI.Window();
	if TBTop then TB["win"]:SetPosition( 0, 0 );
	else TB["win"]:SetPosition( 0, screenHeight - TBHeight ); end
	TB["win"]:SetSize( screenWidth, TBHeight );
	--TB["win"]:SetBackground( resources.TitanBar.Background );
	TB["win"]:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );
	--TB["win"]:SetMouseVisible( false ); -- If set to false, menu will not work.
	TB["win"]:SetWantsKeyEvents( true );
	TB["win"]:SetVisible( true );
	--TB["win"]:SetZOrder( 10 );
	TB["win"]:Activate();

	
	--**v TitanBar event handlers v**
	TB["win"].KeyDown = function( sender, args )
		if ( args.Action == Constants.KEY_TOGGLE_UI ) then -- Hide if F12 key is pressed
			if not CSPress then
				TB["win"]:SetVisible( not TB["win"]:IsVisible() );
				if not windowOpen then MouseHoverCtr:SetVisible( not MouseHoverCtr:IsVisible() ); end
			end
			F12Press = not F12Press;
		elseif ( args.Action == Constants.KEY_TOGGLE_LAYOUT_MODE ) then -- Hide if (Ctrl + \) is pressed
			if not F12Press then
				TB["win"]:SetVisible( not TB["win"]:IsVisible() );
				if not windowOpen then MouseHoverCtr:SetVisible( not MouseHoverCtr:IsVisible() ); end
			end
			CSPress = not CSPress;
		end
	end

	TB["win"].MouseMove = function( sender, args )
		windowOpen = false;
		AutoHideCtr:SetWantsUpdates( true );
	end

	TB["win"].MouseLeave = function( sender, args )
		if Player:IsInCombat() and windowOpen and TBAutoHide ~= L["OPAHD"] then AutoHideCtr:SetWantsUpdates( true );
		elseif TBAutoHide == L["OPAHE"] then AutoHideCtr:SetWantsUpdates( true ); end
	end

	TB["win"].MouseClick = function( sender, args )
		TB["win"].MouseMove();

		if ( args.Button == Turbine.UI.MouseButton.Right ) then
			mouseXPos, mouseYPos = Turbine.UI.Display.GetMousePosition();
			_G.sFromCtr = "TitanBar";
			TitanBarMenu:ShowMenu();
		--elseif ( args.Button == Turbine.UI.MouseButton.Left ) then
			
		end
	end

	TB["win"].MouseDoubleClick = function( sender, args )
		ReloadTitanBar();
	end
	--**

	MouseHoverCtr = Turbine.UI.Window();
	MouseHoverCtr:SetPosition( (TB["win"]:GetWidth() / 2) - 125 , TB["win"]:GetHeight() );
	MouseHoverCtr:SetSize( 250, 15 );
	--MouseHoverCtr:SetZOrder( 1 );
	--MouseHoverCtr:SetBackColor( Color["red"] ); --debug purpose
	MouseHoverCtr:SetBackground( resources.frmMain ); 

	MouseHoverCtr.MouseHover = function( sender, args )
		AutoHideCtr:SetWantsUpdates( true );
	end
	
	AutoHideCtr = Turbine.UI.Control();
	--AutoHideCtr:SetWantsUpdates( true ); --debug purpose
	AutoHideCtr.Update = function( sender, args )
		if windowOpen then
			MouseHoverCtr:SetVisible( false );
			if TBTop then --TitanBar is at top
				if ( TB["win"]:GetTop() + TB["win"]:GetHeight() == 0 ) then
					AutoHideCtr:SetWantsUpdates( false );
					windowOpen = false;
					MouseHoverCtr:SetVisible( true );
					MouseHoverCtr:SetTop( TB["win"]:GetTop() + TB["win"]:GetHeight() );
				else
					TB["win"]:SetTop( TB["win"]:GetTop() - 1 );
				end
			else  --TitanBar is at bottom
				if ( TB["win"]:GetTop() == screenHeight ) then
					AutoHideCtr:SetWantsUpdates( false );
					windowOpen = false;
					MouseHoverCtr:SetVisible( true );
					MouseHoverCtr:SetTop( TB["win"]:GetTop() - MouseHoverCtr:GetHeight() );
				else
					TB["win"]:SetTop( TB["win"]:GetTop() + 1 );
				end
			end
		else
			MouseHoverCtr:SetVisible( false );
			if TBTop then --TitanBar is at top
				if ( TB["win"]:GetTop() == 0 ) then
					AutoHideCtr:SetWantsUpdates( false );
					windowOpen = true;
				else
					TB["win"]:SetTop( TB["win"]:GetTop() + 1 );
				end
			else --TitanBar is at bottom
				if ( TB["win"]:GetTop() + TB["win"]:GetHeight() == screenHeight ) then
					AutoHideCtr:SetWantsUpdates( false );
					windowOpen = true;
				else
					TB["win"]:SetTop( TB["win"]:GetTop() - 1 );
				end
			end
		end
	end
	
	PlayerCurrency = {};
	PlayerCurrencyHandler = {};

	LoadPlayerWallet();
	LoadPlayerMoney();
	LoadPlayerVault();
	LoadPlayerSharedStorage();
	LoadPlayerBags();
	LoadPlayerReputation();
	LoadPlayerLOTROPoints();
	LoadPlayerItemTrackingList();
	LoadPlayerProfile();

	if TBReloaded and TBReloadedText == "Profile" then opt_profile.Click(); end--TitanBar was reloaded because a profile need to be loaded
	if TBReloaded and TBReloadedText == "Font" then opt_options.Click(); end--TitanBar was reloaded because a font need to be loaded

	if TBAutoHide == L["OPAHE"] then AutoHideCtr:SetWantsUpdates( true ); end --Auto hide if needed

	if PlayerAlign == 1 then
		if PlayerWalletSize ~= nil or PlayerWalletSize ~= 0 then
				for k,v in pairs(_G.currencies.list) do
					if _G.CurrencyData[v.name] == nil then _G.CurrencyData[v.name] = {} end
					if _G.CurrencyData[v.name].Where == nil then _G.CurrencyData[v.name].Where = 3 end
					if _G.CurrencyData[v.name].Where ~= 3 then ImportCtr(v.name); end
				end
		end
	else
		-- Disable infos not useful in Monster Play
		_G.ControlData.DI.show, _G.ControlData.EI.show = false, false
		_G.ControlData.VT.show, _G.ControlData.SS.show = false, false
		_G.ControlData.RP.show = false
		for _,cur in pairs(_G.currencies.list) do
			if not cur.visibleInMonsterPlay then
				_G.CurrencyData[cur.name].IsVisible = false
			end
		end

		if PlayerWalletSize ~= nil or PlayerWalletSize ~= 0 then
			-- if _G.ControlData.WI.show then ImportCtr( "WI" ); end
			if _G.CurrencyData["Commendation"].Where ~= 3 then ImportCtr("Commendation"); end
			if ((_G.ControlData.LP and _G.ControlData.LP.where) or Constants.Position.NONE) ~= Constants.Position.NONE then ImportCtr( "LP" ); end
		end
	end

	-- Handled by ControlRegistry.ForEach in main.lua
	-- if _G.ControlData.WI.show then ImportCtr( "WI" ); end
	-- if ((_G.ControlData.Money and _G.ControlData.Money.where) or Constants.Position.NONE) ~= Constants.Position.NONE then ImportCtr( "MI" ); end
	if _G.ControlData.TI.show then ImportCtr( "TI" ); end --Track Items
	if _G.ControlData.IF.show then ImportCtr( "IF" ); end --Infamy/Renown
	if _G.ControlData.VT.show then ImportCtr( "VT" ); end --Vault
	if _G.ControlData.SS.show then ImportCtr( "SS" ); end --SharedStorage
	if _G.ControlData.DN.show then ImportCtr( "DN" ); end --Day & Night time
	if _G.ControlData.RP.show then ImportCtr( "RP" ); end --Reputation Points
	if ((_G.ControlData.LP and _G.ControlData.LP.where) or Constants.Position.NONE) ~= Constants.Position.NONE then ImportCtr( "LP" ); end --LOTRO Points

	--**v Workaround for the ItemRemoved that fires before the backpack was updated (Turbine API issue) v**
	ItemRemovedTimer = Turbine.UI.Control();
	
	ItemRemovedTimer.Update = function( sender, args )
		ItemRemovedTimer:SetWantsUpdates( false );
		UpdateBackpackInfos();
	end
	--**
	
	-- BagInfos handled by ControlRegistry.ForEach
	-- if _G.ControlData.BI.show then ImportCtr( "BI" );	end
	if _G.ControlData.PI.show then ImportCtr( "PI" ); end
	if _G.ControlData.PL.show then ImportCtr( "PL" ); end
	if _G.ControlData.GT.show then ImportCtr( "GT" ); end

	if _G.ControlData.DI.show or _G.ControlData.EI.show then
		GetEquipmentInfos();
		AddCallback(PlayerEquipment, "ItemEquipped", function(sender, args) if _G.ControlData.EI.show then GetEquipmentInfos(); UpdateEquipsInfos(); end if _G.ControlData.DI.show then GetEquipmentInfos(); UpdateDurabilityInfos(); end end);
		AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) ItemUnEquippedTimer:SetWantsUpdates( true ); end); --Workaround
		--AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) if _G.ControlData.EI.show then GetEquipmentInfos(); UpdateEquipsInfos(); end if _G.ControlData.DI.show then GetEquipmentInfos(); UpdateDurabilityInfos(); end end);
	end

	AddCallback(
		PlayerWallet,
		"ItemAdded",
		function(sender, args)
			LoadPlayerWallet()
			SetCurrencyFromZero(args["Item"]:GetName(), args["Item"]:GetQuantity())
		end
	)

	AddCallback(
		PlayerWallet,
		"ItemRemoved",
		function(sender, args)
			SetCurrencyToZero(args["Item"]:GetName())
		end
	)
	
	--**v Workaround for the ItemUnequipped that fires before the equipment was updated (Turbine API issue) v**
	ItemUnEquippedTimer = Turbine.UI.Control();

	ItemUnEquippedTimer.Update = function( sender, args )
		if _G.ControlData.EI.show then GetEquipmentInfos(); UpdateEquipsInfos(); end
		if _G.ControlData.DI.show then GetEquipmentInfos(); UpdateDurabilityInfos(); end
		ItemUnEquippedTimer:SetWantsUpdates( false );
	end
	--**
	
	if _G.ControlData.EI.show then ImportCtr( "EI" ); end
	if _G.ControlData.DI.show then ImportCtr( "DI" ); end
	
	--**v Run these functions at-startup only once because if TitanBar is loaded with in-game plugin manager some controls do not update properly v**
	OneTimer = Turbine.UI.Control();
	AllTimer = Turbine.UI.Control();
	AllTimer:SetWantsUpdates( true );
	
	if _G.ControlData.EI.show or _G.ControlData.DI.show then
		OneTimer:SetWantsUpdates( true )
		AllTimer:SetWantsUpdates( false )
		NumSec = 0
		Interval = 2
	end
	if TBReloaded then
		OneTimer:SetWantsUpdates( false )
		AllTimer:SetWantsUpdates( true )
		settings.TitanBar.Z = false
		settings.TitanBar.ZT = "TB"
		SaveSettings( false )
	end --TitanBar was reloaded

	OneTimer.Update = function( sender, args )
		local currentdate = Turbine.Engine.GetDate();
		local currentsecond = currentdate.Second;
		local max = 24
		if _G.Debug then max = 6 end
		if NumSec < max then -- Run for 24 secs. -- TODO why?
			if (oldsecond ~= currentsecond) then
				if Interval == 0 then
					if _G.ControlData.EI.show or _G.ControlData.DI.show then GetEquipmentInfos();
						if PlayerEquipment ~= nil then
							if _G.ControlData.EI.show then ImportCtr( "EI" ); end
							if _G.ControlData.DI.show then ImportCtr( "DI" ); end
						end
					end

					if _G.Debug then write( "OneTimer: Interval" );	end

					Interval = 2;
				else
					Interval = Interval - 1;
				end
				
				oldsecond = currentsecond;
				NumSec = NumSec + 1;

				if _G.Debug then
					if NumSec <= 1 then seconds = "sec"; else seconds = "secs"; end
					write( "OneTimer: " .. NumSec .. " " .. seconds );
				end
			end
		else
			AllTimer:SetWantsUpdates( true );
			OneTimer:SetWantsUpdates( false );
		end
	end
	--**
	
	--**v Run these functions all the time v**	
	AllTimer.Update = function( sender, args )
		local currentdate = Turbine.Engine.GetDate();
		local currentminute = currentdate.Minute;
		local currentsecond = currentdate.Second;
		
		if (oldminute ~= currentminute) then
			if _G.ControlData.GT.show then-- Until I find the minute changed event or something similar
				if _G.ControlData.GT.showBT then UpdateGameTime("bt");
				elseif _G.ControlData.GT.showST then UpdateGameTime("st");
				else UpdateGameTime("gt") end
			end
		end
		
		if (oldsecond ~= currentsecond) then
			screenWidth, screenHeight = Turbine.UI.Display.GetSize();
			if TBWidth ~= screenWidth then ReplaceCtr(); end --Replace control if screen width has changed

			if _G.ControlData.DN.show then UpdateDayNight(); end
		end

		oldminute = currentminute;
		oldsecond = currentsecond;

		--When player log out & log in with same character, the durability control show -1%
		--Because equipment info are not avail when re-login, weird!
		--if PlayerAlign == 1 and _G.ControlData.DI.show then if DI[ "Lbl" ]:GetText() == "-1%" then GetEquipmentInfos(); UpdateDurabilityInfos(); end end
	end
	--**
end