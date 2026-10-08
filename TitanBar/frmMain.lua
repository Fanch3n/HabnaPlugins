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
	TB["win"]:SetLeft( 0 );
	LayoutBar();
	TB["win"]:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );
	--TB["win"]:SetMouseVisible( false ); -- If set to false, menu will not work.
	TB["win"]:SetWantsKeyEvents( true );
	TB["win"]:SetVisible( true );
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
		end
	end

	TB["win"].MouseDoubleClick = function( sender, args )
		ReloadTitanBar();
	end
	--**

	MouseHoverCtr = Turbine.UI.Window();
	MouseHoverCtr:SetSize( 250, 15 );
	MouseHoverCtr:SetTop( GetBarScreenHeight() );
	CenterMouseHover();
	--MouseHoverCtr:SetBackColor( Color["red"] ); --debug purpose
	MouseHoverCtr:SetBackground( resources.frmMain ); 

	MouseHoverCtr.MouseHover = function( sender, args )
		AutoHideCtr:SetWantsUpdates( true );
	end
	
	AutoHideCtr = Turbine.UI.Control();
	--AutoHideCtr:SetWantsUpdates( true ); --debug purpose
	AutoHideCtr.Update = function( sender, args )
		-- Compare against the bar's on-screen height, which depends on the UI scale.
		-- Use <= / >= because a scaled height may not be reached in exact 1px steps.
		local barHeight = GetBarScreenHeight();
		if windowOpen then
			MouseHoverCtr:SetVisible( false );
			if TBTop then --TitanBar is at top
				if ( TB["win"]:GetTop() + barHeight <= 0 ) then
					TB["win"]:SetTop( -barHeight );
					AutoHideCtr:SetWantsUpdates( false );
					windowOpen = false;
					MouseHoverCtr:SetVisible( true );
					MouseHoverCtr:SetTop( 0 );
				else
					TB["win"]:SetTop( TB["win"]:GetTop() - 1 );
				end
			else  --TitanBar is at bottom
				if ( TB["win"]:GetTop() >= screenHeight ) then
					TB["win"]:SetTop( screenHeight );
					AutoHideCtr:SetWantsUpdates( false );
					windowOpen = false;
					MouseHoverCtr:SetVisible( true );
					local _, hoverHeight = GetScaledSize( MouseHoverCtr );
					MouseHoverCtr:SetTop( screenHeight - hoverHeight );
				else
					TB["win"]:SetTop( TB["win"]:GetTop() + 1 );
				end
			end
		else
			MouseHoverCtr:SetVisible( false );
			if TBTop then --TitanBar is at top
				if ( TB["win"]:GetTop() >= 0 ) then
					TB["win"]:SetTop( 0 );
					AutoHideCtr:SetWantsUpdates( false );
					windowOpen = true;
				else
					TB["win"]:SetTop( TB["win"]:GetTop() + 1 );
				end
			else --TitanBar is at bottom
				if ( TB["win"]:GetTop() + barHeight <= screenHeight ) then
					TB["win"]:SetTop( screenHeight - barHeight );
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
					if _G.ControlData[v.name].where ~= 3 then ImportCtr(v.name); end
				end
		end
	else
		-- Disable controls and currencies that are only useful for the Free People
		_G.ControlRegistry.ForEachRegistered(function(id, data, meta)
			if meta.freePeopleOnly then data.show = false end
		end)

		if PlayerWalletSize ~= nil or PlayerWalletSize ~= 0 then
			for _,cur in pairs(_G.currencies.list) do
				if cur.visibleInMonsterPlay and _G.ControlData[cur.name].where ~= 3 then ImportCtr(cur.name); end
			end
			if ((_G.ControlData.LP and _G.ControlData.LP.where) or Constants.Position.NONE) ~= Constants.Position.NONE then ImportCtr( "LP" ); end
		end
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
	
	-- Workaround for the ItemUnequipped that fires before the equipment was updated (Turbine API issue)
	ItemUnEquippedTimer = Turbine.UI.Control();

	ItemUnEquippedTimer.Update = function(sender, args)
		if EquipmentManager then EquipmentManager.Refresh(); end
		if _G.ControlData.EI.show then UpdateEquipsInfos(); end
		if _G.ControlData.DI.show then UpdateDurabilityInfos(); end
		ItemUnEquippedTimer:SetWantsUpdates(false);
	end
	
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
		TBReloaded, TBReloadedText = false, "TB"
		SaveSettings()
	end --TitanBar was reloaded

	local oldsecond, oldminute
	OneTimer.Update = function( sender, args )
		local currentdate = Turbine.Engine.GetDate();
		local currentsecond = currentdate.Second;
		local max = 24
		if _G.Debug then max = 6 end
		if NumSec < max then -- Run for 24 secs. -- TODO why?
			if (oldsecond ~= currentsecond) then
				if Interval == 0 then
					if _G.ControlData.EI.show or _G.ControlData.DI.show then 
						if EquipmentManager then EquipmentManager.Refresh(); end
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
					local seconds = (NumSec <= 1) and "sec" or "secs";
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
			if TBWidth ~= GetBarWidth() then ReplaceCtr(); end --Replace control if screen width or UI scale has changed

			if _G.ControlData.DN.show then UpdateDayNight(); end
		end

		oldminute = currentminute;
		oldsecond = currentsecond;

	end
	--**
end