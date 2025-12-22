-- Wallet.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.WI = {}; -- Wallet table in _G

--**v Wallet Control v**
WI["Ctr"] = Turbine.UI.Control();
WI["Ctr"]:SetParent( TB["win"] );
WI["Ctr"]:SetMouseVisible( false );
WI["Ctr"]:SetZOrder( 2 );
WI["Ctr"]:SetBlendMode( 4 );
WI["Ctr"]:SetBackColor( Turbine.UI.Color( WIbcAlpha, WIbcRed, WIbcGreen, WIbcBlue ) );
--WI["Ctr"]:SetBackColor( Color["red"] ); -- Debug puWIose
--**^
--**v Wallet icon on TitanBar v**
WI["Icon"] = Turbine.UI.Control();
WI["Icon"]:SetParent( WI["Ctr"] );
WI["Icon"]:SetBlendMode( 4 );
WI["Icon"]:SetSize( 32, 32 );
WI["Icon"]:SetBackground( resources.Wallet ); 
--WI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

local MoveWICtr = CreateMoveHandler(WI["Ctr"], WI["Icon"])

WI["Icon"].MouseMove = function( sender, args )
	--WI["Icon"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveWICtr(sender, args);
	else
		if not WITT then
			WITT = true;
			ShowWIToolTip();
		else
			PositionToolTipWindow();
		end
	end
end

WI["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	WITT = false;
end

WI["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmWI then _G.frmWI = false; wWI:Close();
			else
				_G.frmWI = true;
				import (AppCtrD.."WalletWindow");
				frmWalletWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "WI";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(WI["Ctr"], settings.Wallet, "WILocX", "WILocY")
WI["Icon"].MouseDown = dragHandlers.MouseDown
WI["Icon"].MouseUp = dragHandlers.MouseUp
--**^