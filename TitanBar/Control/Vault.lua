-- Vault.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.VT = {}; -- Vault table in _G

--**v Vault Control v**
VT["Ctr"] = Turbine.UI.Control();
VT["Ctr"]:SetParent( TB["win"] );
VT["Ctr"]:SetMouseVisible( false );
VT["Ctr"]:SetZOrder( 2 );
VT["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
VT["Ctr"]:SetBackColor( Turbine.UI.Color( VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue ) );
--VT["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Vault icon on TitanBar v**
VT["Icon"] = Turbine.UI.Control();
VT["Icon"]:SetParent( VT["Ctr"] );
VT["Icon"]:SetBlendMode( 4 );--Turbine.UI.BlendMode.AlphaBlend
VT["Icon"]:SetSize( 30, 30 );
VT["Icon"]:SetBackground( resources.Storage.Vault );
--VT["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

local MoveVTCtr = CreateMoveHandler(VT["Ctr"], VT["Icon"])

VT["Icon"].MouseMove = function( sender, args )
	--VT["Icon"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveVTCtr(sender, args);
	else
		if not VTTT then
			VTTT = true;
			ShowVaultToolTip();
		else
			local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
			
			--[[if _G.ToolTipWin:GetWidth() + mouseX + 5 > screenWidth then x = _G.ToolTipWin:GetWidth() - 10;
			else x = -5; end
			
			if TBTop then y = -15;
			else y = _G.ToolTipWin:GetHeight() end

			_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);]]
		end
	end
end

VT["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	VTTT = false;
end

VT["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmVT then _G.frmVT = false; wVT:Close();
			else
				_G.frmVT = true;
				import (AppCtrD.."VaultWindow");
				frmVault();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "VT";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(VT["Ctr"], settings.Vault, "VTLocX", "VTLocY")
VT["Icon"].MouseDown = dragHandlers.MouseDown
VT["Icon"].MouseUp = dragHandlers.MouseUp
--**^