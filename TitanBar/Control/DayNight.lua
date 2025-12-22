-- DayNight.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.DN = {}; -- Day & Night table in _G

--**v Control of Day & Night v**
DN["Ctr"] = Turbine.UI.Control();
DN["Ctr"]:SetParent( TB["win"] );
DN["Ctr"]:SetMouseVisible( false );
DN["Ctr"]:SetZOrder( 2 );
DN["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DN["Ctr"]:SetBackColor( Turbine.UI.Color( DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue ) );
--DN["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Day & Night & icon on TitanBar v**
DN["Icon"] = Turbine.UI.Control();
DN["Icon"]:SetParent( DN["Ctr"] );
--DN["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DN["Icon"]:SetSize( Constants.ICON_SIZE_SMALL, Constants.ICON_SIZE_SMALL ); --need 32x32 icon
--DN["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

DN["Icon"].MouseMove = function( sender, args )
	DN["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveDNCtr(sender, args); end
end


DN["Lbl"] = Turbine.UI.Label();
DN["Lbl"]:SetParent( DN["Ctr"] );
DN["Lbl"]:SetFont( _G.TBFont );
DN["Lbl"]:SetPosition( 0, 0 );
--DN["Lbl"]:SetForeColor( Color["white"] );
DN["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
DN["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--DN["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

local MoveDNCtr = CreateMoveHandler(DN["Ctr"])

DN["Lbl"].MouseMove = function( sender, args )
	DN["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveDNCtr(sender, args);
	else
		ShowToolTipWin( "DN" );
	end
end

DN["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

DN["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmDN then _G.frmDN = false; wDN:Close();
			else
				_G.frmDN = true;
				import (AppCtrD.."DayNightWindow");
				frmDayNightWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "DN";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(DN["Ctr"], settings.DayNight, "DNLocX", "DNLocY")
DN["Lbl"].MouseDown = dragHandlers.MouseDown
DN["Lbl"].MouseUp = dragHandlers.MouseUp

-- Delegate Icon events to Lbl
DelegateMouseEvents(DN["Icon"], DN["Lbl"])
--**^