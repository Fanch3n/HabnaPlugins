-- PlayerLoc.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.PL = {}; -- Player Location table in _G

--**v Control for Player location v**
PL["Ctr"] = Turbine.UI.Control();
PL["Ctr"]:SetParent( TB["win"] );
PL["Ctr"]:SetMouseVisible( false );
PL["Ctr"]:SetZOrder( 2 );
PL["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
PL["Ctr"]:SetBackColor( Turbine.UI.Color( PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue ) );
--PL["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Player Icon & location on TitanBar v**
PL["Lbl"] = Turbine.UI.Label();
PL["Lbl"]:SetParent( PL["Ctr"] );
PL["Lbl"]:SetPosition( 0, 0 );
PL["Lbl"]:SetFont( _G.TBFont );
--PL["Lbl"]:SetForeColor( Color["white"] );
PL["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
PL["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
--PL["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

local MovePLCtr = CreateMoveHandler(PL["Ctr"])

PL["Lbl"].MouseMove = function( sender, args )
	PL["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MovePLCtr(sender, args);
	else
		ShowToolTipWin( "PL" );
	end
end

PL["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

PL["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "PL";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(PL["Ctr"], settings.PlayerLoc, "PLLocX", "PLLocY")
PL["Lbl"].MouseDown = dragHandlers.MouseDown
PL["Lbl"].MouseUp = dragHandlers.MouseUp
--**^