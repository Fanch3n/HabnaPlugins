-- SharedStorage.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.SS = {}; -- Infamy table in _G

--**v Vault Control v**
SS["Ctr"] = Turbine.UI.Control();
SS["Ctr"]:SetParent( TB["win"] );
SS["Ctr"]:SetMouseVisible( false );
SS["Ctr"]:SetZOrder( 2 );
SS["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SS["Ctr"]:SetBackColor( Turbine.UI.Color( SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue ) );
--SS["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Vault icon on TitanBar v**
SS["Icon"] = Turbine.UI.Control();
SS["Icon"]:SetParent( SS["Ctr"] );
SS["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SS["Icon"]:SetSize( 32, 32 );
SS["Icon"]:SetBackground( resources.Storage.Shared );-- in-game icon 32x32
--SS["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

SS["Icon"].MouseMove = function( sender, args )
	--SS["Icon"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveSSCtr(sender, args);
	else
		if not SSTT then
			SSTT = true;
			ShowSharedToolTip();
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

SS["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	SSTT = false;
end

SS["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			if _G.frmSS then _G.frmSS = false; wSS:Close();
			else
				_G.frmSS = true;
				import (AppCtrD.."SharedStorageWindow");
				frmSharedStorage();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "SS";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(SS["Ctr"], settings.SharedStorage, "SSLocX", "SSLocY")
SS["Icon"].MouseDown = dragHandlers.MouseDown
SS["Icon"].MouseUp = dragHandlers.MouseUp
--**^

function MoveSSCtr(sender, args)
	SS["Icon"].MouseLeave( sender, args );
	MoveControlConstrained(SS["Ctr"], args);
end
