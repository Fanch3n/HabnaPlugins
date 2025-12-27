-- MoneyInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

_G.MI = {}; -- Money Infos table in _G

--**v Control of Gold/Silver/Copper currencies v**
MI["Ctr"] = CreateTitanBarControl(MI, MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue)
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

MI["GIcon"] = CreateControlIcon(MI["GCtr"], Constants.MONEY_ICON_WIDTH, Constants.MONEY_ICON_HEIGHT, resources.MoneyIcon.Gold)

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

MI["SIcon"] = CreateControlIcon(MI["SCtr"], Constants.MONEY_ICON_WIDTH, Constants.MONEY_ICON_HEIGHT, resources.MoneyIcon.Silver)

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
MI["CIcon"] = CreateControlIcon(MI["CCtr"], Constants.MONEY_ICON_WIDTH, Constants.MONEY_ICON_HEIGHT, resources.MoneyIcon.Copper)

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

-- Delegate mouse events from child controls to CLbl
DelegateMouseEvents(MI["GLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["GLbl"], MI["CLbl"]);
DelegateMouseEvents(MI["GIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});
DelegateMouseEvents(MI["SLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["SLbl"], MI["CLbl"]);
DelegateMouseEvents(MI["SIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});
DelegateMouseEvents(MI["CLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["CIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});