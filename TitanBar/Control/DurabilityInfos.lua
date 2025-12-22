-- DurabilityInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")

_G.DI = {}; -- Items Durability Infos table in _G

--**v Control for durability infos v**
DI["Ctr"] = Turbine.UI.Control();
DI["Ctr"]:SetParent( TB["win"] );
DI["Ctr"]:SetMouseVisible( false );
DI["Ctr"]:SetZOrder( 2 );
DI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DI["Ctr"]:SetBackColor( Turbine.UI.Color( DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue ) );
--DI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Durability icon & infos on TitanBar v**
DI["Icon"] = Turbine.UI.Control();
DI["Icon"]:SetParent( DI["Ctr"] );
DI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DI["Icon"]:SetSize( 32, 32 );
--DI["Icon"]:SetBackground(  );-- in-game icon 32x32
--DI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose
	
DI["Icon"].MouseMove = function( sender, args )
	DI["Lbl"].MouseLeave( sender, args )
	TB["win"].MouseMove();
	if dragging then MoveDICtr(sender, args); end
end

DI["Icon"].MouseLeave = function( sender, args )
	DI["Lbl"].MouseLeave( sender, args );
end

DI["Icon"].MouseClick = function( sender, args )
	DI["Lbl"].MouseClick( sender, args );
end

DI["Icon"].MouseDown = function( sender, args )
	DI["Lbl"].MouseDown( sender, args );
end

DI["Icon"].MouseUp = function( sender, args )
	DI["Lbl"].MouseUp( sender, args );
end


DI["Lbl"] = Turbine.UI.Label();
DI["Lbl"]:SetParent( DI["Ctr"] );
DI["Lbl"]:SetFont( _G.TBFont );
DI["Lbl"]:SetPosition( 0, 0 );
--DI["Lbl"]:SetForeColor( Color["white"] );
DI["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
DI["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--DI["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose
	
DI["Lbl"].MouseMove = function( sender, args )
	--DI["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveDICtr(sender, args);
	else
		if not DITT then
			DITT = true;
			ShowDIWindow();
		else
			PositionToolTipWindow();
		end
	end
end

DI["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	DITT = false;
end

DI["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmDI then _G.frmDI = false; wDI:Close();
			else
				_G.frmDI = true;
				import (AppCtrD.."DurabilityInfosWindow");
				frmDurabilityInfosWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "DI";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

DI["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		StartDrag(DI["Ctr"], args)
	end
end

DI["Lbl"].MouseUp = function( sender, args )
	DI["Ctr"]:SetZOrder( 2 );
	_G.dragging = false;
	DI.SavePosition();
end

DI.SavePosition = function()
	SaveControlPosition(DI["Ctr"], settings.DurabilityInfos, "DILocX", "DILocY")
end
--**

function MoveDICtr(sender, args)
	DI["Lbl"].MouseLeave( sender, args );
	local CtrLocX = DI["Ctr"]:GetLeft();
	local CtrWidth = DI["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = DI["Ctr"]:GetTop();
	local CtrHeight = DI["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	DI["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end