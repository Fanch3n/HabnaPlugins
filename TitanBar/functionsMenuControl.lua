-- functionsMenuControl.lua
-- Written By Habna
-- Rewritten by many


--**v Functions for the menu of control v**
--**v Unload control v**
function UnloadControl( value )
	if _G.Debug then write("UnloadControl "..value); end
	if value == "ctr" then
		if ShowWallet then ShowHideWallet(); end
		if ShowMoney then _G.MIWhere = 3; ShowHideMoney(); end
		if ShowBagInfos then ShowHideBackpackInfos(); opt_BI:SetChecked( false ); end
		if ShowPlayerInfos then ShowHidePlayerInfos(); opt_PI:SetChecked( false ); end
		if ShowEquipInfos then ShowHideEquipInfos(); opt_EI:SetChecked( false ); end
		if ShowDurabilityInfos then ShowHideDurabilityInfos(); opt_DI:SetChecked( false ); end
		if ShowTrackItems then ShowHideTrackItems(); opt_TI:SetChecked( false ); end
		if ShowInfamy then ShowHideInfamy(); opt_IF:SetChecked( false ); end
		if ShowVault then ShowHideVault(); opt_VT:SetChecked( false ); end
		if ShowSharedStorage then ShowHideSharedStorage(); opt_SS:SetChecked( false ); end
		--if ShowBank then ShowHideBank(); opt_BK:SetChecked( false ); end
		if ShowDayNight then ShowHideDayNight(); opt_DN:SetChecked( false ); end
		if ShowReputation then ShowHideReputation(); opt_RP:SetChecked( false ); end
		if ShowLOTROPoints then _G.LPWhere = 3; ShowHideLOTROPoints(); end
		if ShowPlayerLoc then ShowHidePlayerLoc(); opt_PL:SetChecked( false ); end
		if ShowGameTime then ShowHideGameTime(); opt_GT:SetChecked( false ); end
		for k,v in pairs(_G.currencies) do
			if _G.CurrencyData[v.name].IsVisible then 
				_G.CurrencyData[v.name].Where = 3
				ShowHideCurrency(v.name);
			end
		end
		elseif value == "this" then
			if _G.sFromCtr == "WI" then ShowHideWallet();
			elseif _G.sFromCtr == "Money" then _G.MIWhere = 3; ShowHideMoney();
			elseif _G.sFromCtr == "BI" then ShowHideBackpackInfos(); opt_BI:SetChecked( false );
			elseif _G.sFromCtr == "PI" then ShowHidePlayerInfos(); opt_PI:SetChecked( false );
			elseif _G.sFromCtr == "EI" then ShowHideEquipInfos(); opt_EI:SetChecked( false );
			elseif _G.sFromCtr == "DI" then ShowHideDurabilityInfos(); opt_DI:SetChecked( false );
			elseif _G.sFromCtr == "TI" then ShowHideTrackItems(); opt_TI:SetChecked( false );
			elseif _G.sFromCtr == "IF" then ShowHideInfamy(); opt_IF:SetChecked( false );
			elseif _G.sFromCtr == "VT" then ShowHideVault(); opt_VT:SetChecked( false );
			elseif _G.sFromCtr == "SS" then ShowHideSharedStorage(); opt_SS:SetChecked( false );
			--elseif _G.sFromCtr == "BK" then ShowHideBank(); opt_BK:SetChecked( false );
			elseif _G.sFromCtr == "DN" then ShowHideDayNight(); opt_DN:SetChecked( false );
			elseif _G.sFromCtr == "RP" then ShowHideReputation(); opt_RP:SetChecked( false );
			elseif _G.sFromCtr == "LP" then _G.LPWhere = 3; ShowHideLOTROPoints();
			elseif _G.sFromCtr == "PL" then ShowHidePlayerLoc(); opt_PL:SetChecked( false );
			elseif _G.sFromCtr == "GT" then ShowHideGameTime(); opt_GT:SetChecked( false );
			end
			for k,v in pairs(_G.currencies) do
				if _G.sFromCtr == v.name then 
					_G.CurrencyData[v.name].Where = 3
					ShowHideCurrency(v.name);
				end
			end
		end

	TB["win"].MouseLeave();
end
--**^

--**v Match/Reset/Apply back color v**
function BGColor( cmd, value )
	if _G.Debug then write("BGColor cmd: "..cmd..", value: "..value); end
	if cmd == "reset" then
		if GLocale == "en" then tA, tR, tG, tB = 0.3, 0.3, 0.3, 0.3;
		else tA, tR, tG, tB = tonumber("0,3"), tonumber("0,3"), tonumber("0,3"), tonumber("0,3"); end
	elseif cmd == "match" then
		tA, tR, tG, tB = bcAlpha, bcRed, bcGreen, bcBlue;
	elseif cmd == "apply" then
		if _G.sFromCtr == "WI" then tA, tR, tG, tB = WIbcAlpha, WIbcRed, WIbcGreen, WIbcBlue;
		elseif _G.sFromCtr == "Money" then tA, tR, tG, tB = MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue;
		elseif _G.sFromCtr == "BI" then tA, tR, tG, tB = BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue;
		elseif _G.sFromCtr == "PI" then tA, tR, tG, tB = PIbcAlpha, PIbcRed, PIbcGreen, PIbcBlue;
		elseif _G.sFromCtr == "EI" then tA, tR, tG, tB = EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue;
		elseif _G.sFromCtr == "DI" then tA, tR, tG, tB = DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue;
		elseif _G.sFromCtr == "TI" then tA, tR, tG, tB = TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue;
		elseif _G.sFromCtr == "IF" then tA, tR, tG, tB = IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue;
		elseif _G.sFromCtr == "VT" then tA, tR, tG, tB = VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue;
		elseif _G.sFromCtr == "SS" then tA, tR, tG, tB = SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue;
--		elseif _G.sFromCtr == "BK" then tA, tR, tG, tB = BKbcAlpha, BKbcRed, BKbcGreen, BKbcBlue;
		elseif _G.sFromCtr == "DN" then tA, tR, tG, tB = DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue;
		elseif _G.sFromCtr == "RP" then tA, tR, tG, tB = RPbcAlpha, RPbcRed, RPbcGreen, RPbcBlue;
		elseif _G.sFromCtr == "LP" then tA, tR, tG, tB = LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue;
		elseif _G.sFromCtr == "PL" then tA, tR, tG, tB = PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue;
		elseif _G.sFromCtr == "GT" then tA, tR, tG, tB = GTbcAlpha, GTbcRed, GTbcGreen, GTbcBlue;
		else
			for k,v in pairs(_G.currencies) do
				if v.name == _G.sFromCtr then
					tA = _G.CurrencyData[v.name].bcAlpha
					tR = _G.CurrencyData[v.name].bcRed
					tG = _G.CurrencyData[v.name].bcGreen
					tB = _G.CurrencyData[v.name].bcBlue
				end
			end
		end
	end
	
	if value == "ctr" then
		WIbcAlpha, WIbcRed, WIbcGreen, WIbcBlue = tA, tR, tG, tB;
		if ShowWallet then WI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue = tA, tR, tG, tB;
		if ShowMoney then MI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue = tA, tR, tG, tB;
		if ShowBagInfos then BI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		PIbcAlpha, PIbcRed, PIbcGreen, PIbcBlue = tA, tR, tG, tB;
		if ShowPlayerInfos then PI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue = tA, tR, tG, tB;
		if ShowEquipInfos then EI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue = tA, tR, tG, tB;
		if ShowDurabilityInfos then DI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue = tA, tR, tG, tB;
		if ShowTrackItems then TI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue = tA, tR, tG, tB;
		if ShowInfamy then IF[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue = tA, tR, tG, tB;
		if ShowVault then VT[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue = tA, tR, tG, tB;
		if ShowSharedStorage then SS[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
--		BKbcAlpha, BKbcRed, BKbcGreen, BKbcBlue = tA, tR, tG, tB;
--		if ShowBank then BK[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue = tA, tR, tG, tB;
		if ShowDayNight then DN[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		RPbcAlpha, RPbcRed, RPbcGreen, RPbcBlue = tA, tR, tG, tB;
		if ShowReputation then RP[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue = tA, tR, tG, tB;
		if ShowLOTROPoints then LP[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue = tA, tR, tG, tB;
		if ShowPlayerLoc then PL[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) ); end
		GTbcAlpha, GTbcRed, GTbcGreen, GTbcBlue = tA, tR, tG, tB;
		if ShowGameTime then GT[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) );	end
		
		for k,v in pairs(_G.currencies) do
			_G.CurrencyData[v.name].bcAlpha = tA
			_G.CurrencyData[v.name].bcRed = tR
			_G.CurrencyData[v.name].bcGreen = tG
			_G.CurrencyData[v.name].bcBlue = tB
			if _G.CurrencyData[v.name].IsVisible then
				_G.CurrencyData[v.name].Ctr:SetBackColor(Turbine.UI.Color(tA, tR, tG, tB))
			end
		end
	elseif value == "all" then
		BGColor( cmd, "ctr" );
		BGColor( cmd, "TitanBar" );
	elseif value == "this" then
		if _G.sFromCtr == "WI" then
			WI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) );
		elseif _G.sFromCtr == "Money" then
			MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue = tA, tR, tG, tB;
			MI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) );
		else
			_G.CurrencyData[_G.sFromCtr].bcAlpha = tA
			_G.CurrencyData[_G.sFromCtr].bcRed = tR
			_G.CurrencyData[_G.sFromCtr].bcGreen = tG
			_G.CurrencyData[_G.sFromCtr].bcBlue = tB
			_G.CurrencyData[_G.sFromCtr].Ctr:SetBackColor(Turbine.UI.Color(tA, tR, tG, tB))
		end
	elseif value == "TitanBar" then
		bcAlpha, bcRed, bcGreen, bcBlue = tA, tR, tG, tB;
		TB["win"]:SetBackColor( Turbine.UI.Color( tA, tR, tG, tB ) );
	end

	SaveSettings( true );
	TB["win"].MouseLeave();
end