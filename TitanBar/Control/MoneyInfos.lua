-- MoneyInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.MI = {}; -- Money Infos table in _G

--**v Control of Gold/Silver/Copper currencies v**
MI["Ctr"] = Turbine.UI.Control();
MI["Ctr"]:SetParent( TB["win"] );
MI["Ctr"]:SetMouseVisible( false );
MI["Ctr"]:SetZOrder( 2 );
MI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MI["Ctr"]:SetBackColor( Turbine.UI.Color( MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue ) );
--MI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Control of Gold currencies v**
MI["GCtr"] = Turbine.UI.Control();
MI["GCtr"]:SetParent( MI["Ctr"] );
MI["GCtr"]:SetMouseVisible( false );
--MI["GCtr"]:SetZOrder( 2 );
--MI["GCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
--**^
--**v Gold & total amount on TitanBar v**
MI["GLblT"] = Turbine.UI.Label();
MI["GLblT"]:SetParent( MI["GCtr"] );
MI["GLblT"]:SetPosition( 0, 0 );
MI["GLblT"]:SetFont( _G.TBFont );
--MI["GLblT"]:SetForeColor( Color["white"] );
MI["GLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["GLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["GLblT"]:SetBackColor( Color["white"] ); -- Debug purpose
--**^
--**v Gold amount & icon on TitanBar v**
MI["GLbl"] = Turbine.UI.Label();
MI["GLbl"]:SetParent( MI["GCtr"] );
MI["GLbl"]:SetPosition( 0, 0 );
MI["GLbl"]:SetFont( _G.TBFont );
--MI["GLbl"]:SetForeColor( Color["white"] );
MI["GLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["GLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["GLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["GIcon"] = Turbine.UI.Control();
MI["GIcon"]:SetParent( MI["GCtr"] );
--MI["GIcon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MI["GIcon"]:SetSize( 27, 21 );
MI["GIcon"]:SetBackground( resources.MoneyIcon.Gold );-- in-game icon 27x21 (3 coins: 0x41004641 / 1 coin: 0x41007e7b) ( all 3 coins 16x16 - 1 of each: 0x41005e9e)
--MI["GIcon"]:SetBackColor( Color["blue"] ); -- Debug purpose

MI["GIcon"].MouseMove = function( sender, args )
	MI["CIcon"].MouseMove( sender, args );
end
--**^

--**v Control of Silver currencies v**
MI["SCtr"] = Turbine.UI.Control();
MI["SCtr"]:SetParent( MI["Ctr"] );
MI["SCtr"]:SetMouseVisible( false );
--MI["SCtr"]:SetZOrder( 2 );
--MI["SCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
--**^
--**v Silver & total amount on TitanBar v**
MI["SLblT"] = Turbine.UI.Label();
MI["SLblT"]:SetParent( MI["SCtr"] );
MI["SLblT"]:SetPosition( 0, 0 );
MI["SLblT"]:SetFont( _G.TBFont );
--MI["SLblT"]:SetForeColor( Color["white"] );
MI["SLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["SLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["SLblT"]:SetBackColor( Color["white"] ); -- Debug purpose

--**^
--**v Silver amount & icon on TitanBar v**
MI["SLbl"] = Turbine.UI.Label();
MI["SLbl"]:SetParent( MI["SCtr"] );
MI["SLbl"]:SetPosition( 0, 0 );
MI["SLbl"]:SetFont( _G.TBFont );
--MI["SLbl"]:SetForeColor( Color["white"] );
--MI["SLbl"]:SetSize( 20, 30 );
MI["SLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["SLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["SLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["SIcon"] = Turbine.UI.Control();
MI["SIcon"]:SetParent( MI["SCtr"] );
--MI["SIcon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MI["SIcon"]:SetSize( 27, 21 );
MI["SIcon"]:SetBackground( resources.MoneyIcon.Silver );-- in-game icon 27x21 (3 coins: 0x41007e7e / 1 coin: 0x41007e7c)
--MI["SIcon"]:SetBackColor( Color["blue"] ); -- Debug purpose

MI["SIcon"].MouseMove = function( sender, args )
	MI["CIcon"].MouseMove( sender, args );
end
--**^

--**v Control of Copper currencies v**
MI["CCtr"] = Turbine.UI.Control();
MI["CCtr"]:SetParent( MI["Ctr"] );
MI["CCtr"]:SetMouseVisible( false );
--MI["CCtr"]:SetZOrder( 2 );
--MI["CCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
--**^
--**v Copper & total amount on TitanBar v**
MI["CLblT"] = Turbine.UI.Label();
MI["CLblT"]:SetParent( MI["CCtr"] );
MI["CLblT"]:SetPosition( 0, 0 );
MI["CLblT"]:SetFont( _G.TBFont );
--MI["CLblT"]:SetForeColor( Color["white"] );
MI["CLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["CLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["CLblT"]:SetBackColor( Color["white"] ); -- Debug purpose

--**^
--**v Copper amount & icon on TitanBar v**
MI["CIcon"] = Turbine.UI.Control();
MI["CIcon"]:SetParent( MI["CCtr"] );
--MI["CIcon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MI["CIcon"]:SetSize( 27, 21 );
MI["CIcon"]:SetBackground( resources.MoneyIcon.Copper );-- in-game icon 27x21 (3 coins: 0x41007e80 / 1 coin: 0x41007e7d)
--MI["CIcon"]:SetBackColor( Color["blue"] ); -- Debug purpose

local MoveMICtr = CreateMoveHandler(MI["Ctr"], MI["CLbl"])

MI["CIcon"].MouseMove = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveMICtr(sender, args); end
end


MI["CLbl"] = Turbine.UI.Label();
MI["CLbl"]:SetParent( MI["CCtr"] );
MI["CLbl"]:SetPosition( 0, 0 );
MI["CLbl"]:SetFont( _G.TBFont );
--MI["CLbl"]:SetForeColor( Color["white"] );
--MI["CLbl"]:SetSize( 20, 30 );
MI["CLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["CLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["CLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["CLbl"].MouseMove = function( sender, args )
	--MI["CLbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveMICtr(sender, args);
	else
		if not MITT then
			MITT = true;
			ShowMIWindow();
		else
			PositionToolTipWindow();
		end
	end
end

MI["CLbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	MITT = false;
end

MI["CLbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmMI then _G.frmMI = false; wMI:Close();
			else
				_G.frmMI = true;
				import (AppCtrD.."MoneyInfosWindow");
				frmMoneyInfosWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "Money";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(MI["Ctr"], settings.Money, "MILocX", "MILocY")
MI["CLbl"].MouseDown = dragHandlers.MouseDown
MI["CLbl"].MouseUp = dragHandlers.MouseUp
--**^

-- Delegate mouse events from child controls to CLbl
DelegateMouseEvents(MI["GLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["GLbl"], MI["CLbl"]);
DelegateMouseEvents(MI["GIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});
DelegateMouseEvents(MI["SLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["SLbl"], MI["CLbl"]);
DelegateMouseEvents(MI["SIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});
DelegateMouseEvents(MI["CLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["CIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});