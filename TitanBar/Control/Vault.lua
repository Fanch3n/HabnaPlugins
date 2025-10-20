-- Vault.lua
-- Written by Habna


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
		if not WasDrag then
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
	WasDrag = false;
end

VT["Icon"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		VT["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

VT["Icon"].MouseUp = function( sender, args )
	VT["Ctr"]:SetZOrder( 2 );
	dragging = false;
	VT.SavePosition();
end

VT.SavePosition = function()
	_G.VTLocX = VT["Ctr"]:GetLeft();
	settings.Vault.X = string.format("%.0f", _G.VTLocX);
	_G.VTLocY = VT["Ctr"]:GetTop();
	settings.Vault.Y = string.format("%.0f", _G.VTLocY);
	SaveSettings( false );
end
--**^

function MoveVTCtr(sender, args)
	VT["Icon"].MouseLeave( sender, args );
	local CtrLocX = VT["Ctr"]:GetLeft();
	local CtrWidth = VT["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end

	local CtrLocY = VT["Ctr"]:GetTop();
	local CtrHeight = VT["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	VT["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end