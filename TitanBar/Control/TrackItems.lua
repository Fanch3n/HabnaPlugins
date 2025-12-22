-- TrackItems.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.TI = {}; -- TrackItems table in _G

--**v TrackItems Control v**
TI["Ctr"] = Turbine.UI.Control();
TI["Ctr"]:SetParent( TB["win"] );
TI["Ctr"]:SetMouseVisible( false );
TI["Ctr"]:SetZOrder( 2 );
TI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
TI["Ctr"]:SetBackColor( Turbine.UI.Color( TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue ) );
--TI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v TrackItems icon on TitanBar v**
TI["Icon"] = Turbine.UI.Control();
TI["Icon"]:SetParent( TI["Ctr"] );
TI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
TI["Icon"]:SetSize( 32, 32 );
TI["Icon"]:SetBackground( resources.TrackItems );
--TI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

local MoveTICtr = CreateMoveHandler(TI["Ctr"], TI["Icon"])

TI["Icon"].MouseMove = function( sender, args )
	--TI["Icon"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveTICtr(sender, args);
	else
		if not TITT then
			TITT = true;
			ShowTIWindow();
		else
			PositionToolTipWindow();
		end
	end
end

TI["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	TITT = false;
end

TI["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmTI then _G.frmTI = false; wTI:Close();
			else
				_G.frmTI = true;
				import (AppCtrD.."TrackItemsWindow");
				frmTrackItemsWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "TI";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(TI["Ctr"], settings.TrackItems, "TILocX", "TILocY")
TI["Icon"].MouseDown = dragHandlers.MouseDown
TI["Icon"].MouseUp = dragHandlers.MouseUp
--**^