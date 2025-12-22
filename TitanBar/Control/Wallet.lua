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
		if not WasDrag then
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
	WasDrag = false;
end

WI["Icon"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		StartDrag(WI["Ctr"], args)
	end
end

WI["Icon"].MouseUp = function( sender, args )
	WI["Ctr"]:SetZOrder( 2 );
	_G.dragging = false;
	WI.SavePosition();
end

WI.SavePosition = function()
	SaveControlPosition(WI["Ctr"], settings.Wallet, "WILocX", "WILocY")
end
--**^

function MoveWICtr(sender, args)
	WI["Icon"].MouseLeave( sender, args );
	local CtrLocX = WI["Ctr"]:GetLeft();
	local CtrWidth = WI["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end

	local CtrLocY = WI["Ctr"]:GetTop();
	local CtrHeight = WI["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	WI["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end