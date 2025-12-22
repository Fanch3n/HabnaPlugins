-- EquipInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.EI = {}; -- Equipment Infos table in _G

--  Control for equipment infos
EI[ "Ctr" ] = Turbine.UI.Control();
EI[ "Ctr" ]:SetParent( TB["win"] );
EI[ "Ctr" ]:SetMouseVisible( false );
EI[ "Ctr" ]:SetZOrder( 2 );
EI[ "Ctr" ]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
EI[ "Ctr" ]:SetSize( 32, 32 );
EI[ "Ctr" ]:SetBackColor( Turbine.UI.Color( EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue ) );

-- Player icon & infos on TitanBar
EI[ "Icon" ] = Turbine.UI.Control();
EI[ "Icon" ]:SetParent( EI[ "Ctr" ] );
EI[ "Icon" ]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
EI[ "Icon" ]:SetSize( 32, 32 );
--EI[ "Icon" ]:SetPosition( 0, 0 );
EI[ "Icon" ]:SetBackground( 0x410f2ea5 );-- in-game icon 32x32

EI[ "Icon" ].MouseMove = function( sender, args )
	TB[ "win" ].MouseMove();
	if dragging then
		MoveEICtr(sender, args);
	else
		if not EITT then
			EITT = true;
			ShowEIWindow();
		else
			local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
			
			if _G.ToolTipWin:GetWidth() + mouseX + 5 > screenWidth then x = _G.ToolTipWin:GetWidth() - 10;
			else x = -5; end
			
			if TBTop then y = -15;
			else y = _G.ToolTipWin:GetHeight() end

			_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
		end
	end
end

EI[ "Icon" ].MouseLeave = function( sender, args )
	ResetToolTipWin();
	EITT = false;
end

EI[ "Icon" ].MouseClick = function( sender, args )
	TB[ "win" ].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "EI";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(EI[ "Ctr" ], settings.EquipInfos, "EILocX", "EILocY")
EI[ "Icon" ].MouseDown = dragHandlers.MouseDown
EI[ "Icon" ].MouseUp = dragHandlers.MouseUp

--[[--]]-- I don't know why this label was commented out... But it's breaking things commented out - so let's uncomment and see what happens.
EI["Lbl"] = Turbine.UI.Label();
EI["Lbl"]:SetParent( EI[ "Ctr" ] );
EI["Lbl"]:SetFont( _G.TBFont );
EI["Lbl"]:SetPosition( 0, 0 );
--EI["Lbl"]:SetForeColor( Color["white"] );
EI["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
EI["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--EI["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose
	
EI["Lbl"].MouseMove = function( sender, args )
	--EI["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveEICtr(sender, args);
	else
		if not EITT then
			EITT = true;
			ShowEIWindow();
		else
			PositionToolTipWindow();
		end
	end
end

EI["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	EITT = false;
end

EI["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "EI";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

EI["Lbl"].MouseDown = dragHandlers.MouseDown
EI["Lbl"].MouseUp = dragHandlers.MouseUp
--**^
--]]
function MoveEICtr(sender, args)
	EI[ "Icon" ].MouseLeave( sender, args );
	MoveControlConstrained(EI[ "Ctr" ], args);
end