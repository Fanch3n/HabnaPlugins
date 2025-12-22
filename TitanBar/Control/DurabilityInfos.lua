-- DurabilityInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.DI = {}; -- Items Durability Infos table in _G

--**v Control for durability infos v**
DI["Ctr"] = Turbine.UI.Control();
DI["Ctr"]:SetParent( TB["win"] );
DI["Ctr"]:SetMouseVisible( false );
DI["Ctr"]:SetZOrder( 2 );
DI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DI["Ctr"]:SetBackColor( Turbine.UI.Color( DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue ) );
--DI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Durability icon & infos on TitanBar v**
DI["Icon"] = Turbine.UI.Control();
DI["Icon"]:SetParent( DI["Ctr"] );
DI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DI["Icon"]:SetSize( 32, 32 );
--DI["Icon"]:SetBackground(  );-- in-game icon 32x32
--DI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose
	
DI["Icon"].MouseMove = function( sender, args )
	DI["Lbl"].MouseLeave( sender, args )
	TB["win"].MouseMove();
	if dragging then MoveDICtr(sender, args); end
end


DI["Lbl"] = Turbine.UI.Label();
DI["Lbl"]:SetParent( DI["Ctr"] );
DI["Lbl"]:SetFont( _G.TBFont );
DI["Lbl"]:SetPosition( 0, 0 );
--DI["Lbl"]:SetForeColor( Color["white"] );
DI["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
DI["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--DI["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose
	
DI["Lbl"].MouseMove = function( sender, args )
	--DI["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveDICtr(sender, args);
	else
		if not DITT then
			DITT = true;
			ShowDIWindow();
		else
			PositionToolTipWindow();
		end
	end
end

DI["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	DITT = false;
end

DI["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmDI then _G.frmDI = false; wDI:Close();
			else
				_G.frmDI = true;
				import (AppCtrD.."DurabilityInfosWindow");
				frmDurabilityInfosWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "DI";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(DI["Ctr"], settings.DurabilityInfos, "DILocX", "DILocY")
DI["Lbl"].MouseDown = dragHandlers.MouseDown
DI["Lbl"].MouseUp = dragHandlers.MouseUp

-- Delegate Icon events to Lbl
DelegateMouseEvents(DI["Icon"], DI["Lbl"])
--**^

function MoveDICtr(sender, args)
	DI["Lbl"].MouseLeave( sender, args );
	MoveControlConstrained(DI["Ctr"], args);
end