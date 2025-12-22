-- PlayerInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.PI = {}; -- Player Infos table in _G

--**v Control for player infos v**
PI["Ctr"] = Turbine.UI.Control();
PI["Ctr"]:SetParent( TB["win"] );
PI["Ctr"]:SetMouseVisible( false );
PI["Ctr"]:SetZOrder( 2 );
PI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
PI["Ctr"]:SetBackColor( Turbine.UI.Color( PIbcAlpha, PIbcRed, PIbcGreen, PIbcBlue ) );
--PI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Player icon & infos on TitanBar v**
PI["Icon"] = Turbine.UI.Control();
PI["Icon"]:SetParent( PI["Ctr"] );
PI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
PI["Icon"]:SetSize( 32, 32 );
--PI["Icon"]:SetBackground(  );-- need in-game icon 32x32
--PI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

PI["Lvl"] = Turbine.UI.Label();
PI["Lvl"]:SetParent( PI["Ctr"] );
PI["Lvl"]:SetFont( _G.TBFont );
PI["Lvl"]:SetPosition( 0, 0 );
--PI["Lvl"]:SetForeColor( Color["white"] );
PI["Lvl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
PI["Lvl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--PI["Lvl"]:SetBackColor( Color["orange"] ); -- Debug purpose

PI["Name"] = Turbine.UI.Label();
PI["Name"]:SetParent( PI["Ctr"] );
PI["Name"]:SetFont( _G.TBFont );
--PI["Name"]:SetForeColor( Color["white"] );
PI["Name"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
PI["Name"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
--PI["Name"]:SetBackColor( Color["white"] ); -- Debug purpose

PI["Name"].MouseMove = function( sender, args )
	--PI["Name"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MovePICtr(sender, args);
	else
		if not PITT then
			PITT = true;
			ShowPIWindow();
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

PI["Name"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	PITT = false;
end

PI["Name"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "PI";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(PI["Ctr"], settings.PlayerInfos, "PILocX", "PILocY")
PI["Name"].MouseDown = dragHandlers.MouseDown
PI["Name"].MouseUp = dragHandlers.MouseUp

-- Delegate Icon and Lvl mouse events to Name
PI.Icon.MouseMove = function(sender, args)
	PI.Name.MouseLeave(sender, args);
	TB.win:MouseMove();
	if dragging then MovePICtr(sender, args); end
end
DelegateMouseEvents(PI.Icon, PI.Name, {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"})
DelegateMouseEvents(PI.Lvl, PI.Name)
--**^

function MovePICtr(sender, args)
	PI["Name"].MouseLeave( sender, args );
	MoveControlConstrained(PI["Ctr"], args);
end