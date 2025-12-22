-- GameTime.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.GT = {}; -- Game Time table in _G

--**v Control for Game time v**
GT["Ctr"] = Turbine.UI.Control();
GT["Ctr"]:SetParent( TB["win"] );
GT["Ctr"]:SetMouseVisible( false );
GT["Ctr"]:SetZOrder( 2 );
GT["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
GT["Ctr"]:SetBackColor( Turbine.UI.Color( GTbcAlpha, GTbcRed, GTbcGreen, GTbcBlue ) );
--GT["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Game time on TitanBar v**
GT["Lbl"] = Turbine.UI.Label();
GT["Lbl"]:SetParent( GT["Ctr"] );
GT["Lbl"]:SetPosition( 0, 0 );
GT["Lbl"]:SetFont( _G.TBFont );
--GT["Lbl"]:SetForeColor( Color["white"] );
GT["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
GT["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--GT["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

GT["Lbl"].MouseMove = function( sender, args )
	GT["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveGTCtr(sender, args);
	else
		ShowToolTipWin( "GT" );
	end
end

GT["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

GT["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmGT then _G.frmGT = false; wGT:Close();
			else
				_G.frmGT = true;
				import (AppCtrD.."GameTimeWindow");
				frmGameTimeWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "GT";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(GT["Ctr"], settings.GameTime, "GTLocX", "GTLocY")
GT["Lbl"].MouseDown = dragHandlers.MouseDown
GT["Lbl"].MouseUp = dragHandlers.MouseUp
--**^

function MoveGTCtr(sender, args)
	MoveControlConstrained(GT["Ctr"], args);
end