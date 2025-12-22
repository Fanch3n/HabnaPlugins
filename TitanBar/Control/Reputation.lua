-- Reputation.lua
-- Written by Habna

if resources == nil then import "HabnaPlugins.TitanBar.TBresources"; end;
import(AppDirD .. "UIHelpers")

_G.RP = {}; -- Reputation table in _G

--**v Reputation Control v**
RP["Ctr"] = Turbine.UI.Control();
RP["Ctr"]:SetParent( TB["win"] );
RP["Ctr"]:SetMouseVisible( false );
RP["Ctr"]:SetZOrder( 2 );
RP["Ctr"]:SetBlendMode( 4 );
RP["Ctr"]:SetBackColor( Turbine.UI.Color( RPbcAlpha, RPbcRed, RPbcGreen, RPbcBlue ) );
--RP["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Reputation icon on TitanBar v**
RP["Icon"] = Turbine.UI.Control();
RP["Icon"]:SetParent( RP["Ctr"] );
RP["Icon"]:SetBlendMode( 4 );
RP["Icon"]:SetSize( 32, 32 );
RP["Icon"]:SetBackground( resources.Reputation.Icon );-- in-game icon 32x32
--RP["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

RP["Icon"].MouseMove = function( sender, args )
	--RP["Icon"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveRPCtr(sender, args);
	else
		if not RPTT then
			RPTT = true;
			ShowRPWindow();
		else
			PositionToolTipWindow();
		end
	end
end

RP["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	RPTT = false;
end

RP["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if args.Button == Turbine.UI.MouseButton.Left then
		if not _G.WasDrag then
			if _G.frmRP then _G.frmRP = false; wRP:Close();
			else
				_G.frmRP = true;
				import (AppCtrD.."ReputationWindow");
				frmReputationWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "RP";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(RP["Ctr"], settings.Reputation, "RPLocX", "RPLocY")
RP["Icon"].MouseDown = dragHandlers.MouseDown
RP["Icon"].MouseUp = dragHandlers.MouseUp
--**^

function MoveRPCtr(sender, args)
	RP["Icon"].MouseLeave( sender, args );
	MoveControlConstrained(RP["Ctr"], args);
end