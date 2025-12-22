-- Infamy.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.IF = {}; -- Infamy table in _G

--**v Control of Infamy v**
IF["Ctr"] = Turbine.UI.Control();
IF["Ctr"]:SetParent( TB["win"] );
IF["Ctr"]:SetMouseVisible( false );
IF["Ctr"]:SetZOrder( 2 );
IF["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
IF["Ctr"]:SetBackColor( Turbine.UI.Color( IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue ) );
--IF["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Infamy & icon on TitanBar v**
IF["Icon"] = Turbine.UI.Control();
IF["Icon"]:SetParent( IF["Ctr"] );
IF["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
IF["Icon"]:SetSize( Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE );
--IF["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

local MoveIFCtr = CreateMoveHandler(IF["Ctr"], IF["Icon"])

IF["Icon"].MouseMove = function( sender, args )
	--IF["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveIFCtr(sender, args);
	else
		if not IFTT then
			IFTT = true;
			ShowIFWindow();
		else
			PositionToolTipWindow();
		end
	end
end

IF["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	IFTT = false;
end

IF["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmIF then _G.frmIF = false; wIF:Close();
			else
				_G.frmIF = true;
				import (AppCtrD.."InfamyWindow");
				frmInfamyWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "IF";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(IF["Ctr"], settings.Infamy, "IFLocX", "IFLocY")
IF["Icon"].MouseDown = dragHandlers.MouseDown
IF["Icon"].MouseUp = dragHandlers.MouseUp
--**^