-- BagInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.BI = {}; -- Backpack Infos table in _G

--**v Control for backpack infos v**
BI["Ctr"] = Turbine.UI.Control();
BI["Ctr"]:SetParent( TB["win"] );
BI["Ctr"]:SetMouseVisible( false );
BI["Ctr"]:SetZOrder( 2 );
BI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
BI["Ctr"]:SetBackColor( Turbine.UI.Color( BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue ) );
--BI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Backpack infos & icon on TitanBar v**
BI["Icon"] = Turbine.UI.Control();
BI["Icon"]:SetParent( BI["Ctr"] );
BI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
BI["Icon"]:SetSize( 24, 30 ); --24,30
--BI["Icon"]:SetBackground( 0x41001163 );-- in-game icon 24x30 0x41008113
--BI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

BI["Icon"].MouseMove = function( sender, args )
	BI["Lbl"].MouseLeave( sender, args )
	TB["win"].MouseMove();
	if dragging then MoveBICtr(sender, args); end
end


BI["Lbl"] = Turbine.UI.Label();
BI["Lbl"]:SetParent( BI["Ctr"] );
BI["Lbl"]:SetFont( _G.TBFont );
BI["Lbl"]:SetPosition( 0, 0 );
--BI["Lbl"]:SetForeColor( Color["white"] );
BI["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
BI["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--BI["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

BI["Lbl"].MouseMove = function( sender, args )
	BI["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveBICtr(sender, args);
	else
		ShowToolTipWin( "BI" );
	end
end

BI["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

BI["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmBI then _G.frmBI = false; wBI:Close();
			else
				_G.frmBI = true;
				import (AppCtrD.."BagInfosWindow");
				frmBagInfos();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "BI";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(BI["Ctr"], settings.BagInfos, "BILocX", "BILocY")
BI["Lbl"].MouseDown = dragHandlers.MouseDown
BI["Lbl"].MouseUp = dragHandlers.MouseUp

-- Delegate Icon events to Lbl
DelegateMouseEvents(BI["Icon"], BI["Lbl"])
--**^

function MoveBICtr(sender, args)
	BI["Lbl"].MouseLeave( sender, args );
	MoveControlConstrained(BI["Ctr"], args);
end