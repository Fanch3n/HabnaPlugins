-- LOTROPoints.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.LP = {}; -- LOTRO Points table in _G

--**v Control of LOTRO Points v**
LP["Ctr"] = Turbine.UI.Control();
LP["Ctr"]:SetParent( TB["win"] );
LP["Ctr"]:SetMouseVisible( false );
LP["Ctr"]:SetZOrder( 2 );
LP["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
LP["Ctr"]:SetBackColor( Turbine.UI.Color( LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue ) );
--LP["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Destiny points & icon on TitanBar v**
LP["Icon"] = Turbine.UI.Control();
LP["Icon"]:SetParent( LP["Ctr"] );
LP["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
LP["Icon"]:SetSize( 36, 43 );
LP["Icon"]:SetBackground( _G.resources.LOTROPoints );
LP["Icon"]:SetStretchMode( 1 );
LP["Icon"]:SetSize( 32, 32 );

--LP["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

LP["Icon"].MouseMove = function( sender, args )
	LP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
        MoveLPCtr(sender, args);
    else
        ShowToolTipWin( "LP" );
    end
end


LP["Lbl"] = Turbine.UI.Label();
LP["Lbl"]:SetParent( LP["Ctr"] );
LP["Lbl"]:SetFont( _G.TBFont );
LP["Lbl"]:SetPosition( 0, 0 );
--LP["Lbl"]:SetForeColor( Color["white"] );
LP["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
LP["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--LP["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

local MoveLPCtr = CreateMoveHandler(LP["Ctr"])

LP["Lbl"].MouseMove = function( sender, args )
	LP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveLPCtr(sender, args);
	else
		ShowToolTipWin( "LP" );
	end
end

LP["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

LP["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmLP then _G.frmLP = false; wLP:Close();
			else
				_G.frmLP = true;
				import (AppCtrD.."LOTROPointsWindow");
				frmLOTROPointsWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "LP";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(LP["Ctr"], settings.LOTROPoints, "LPLocX", "LPLocY")
LP["Lbl"].MouseDown = dragHandlers.MouseDown
LP["Lbl"].MouseUp = dragHandlers.MouseUp

-- Delegate Icon events to Lbl
DelegateMouseEvents(LP["Icon"], LP["Lbl"])
--**^