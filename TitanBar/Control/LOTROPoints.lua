-- LOTROPoints.lua
-- Written by Habna


_G.LP = {}; -- LOTRO Points table in _G

--**v Control of LOTRO Points v**
LP["Ctr"] = Turbine.UI.Control();
LP["Ctr"]:SetParent( TB["win"] );
LP["Ctr"]:SetMouseVisible( false );
LP["Ctr"]:SetZOrder( 2 );
LP["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
LP["Ctr"]:SetBackColor( Turbine.UI.Color( LPbcAlpha, LPbcRed, LPbcGreen, LPbcBlue ) );
--LP["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Destiny points & icon on TitanBar v**
LP["Icon"] = Turbine.UI.Control();
LP["Icon"]:SetParent( LP["Ctr"] );
LP["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
LP["Icon"]:SetSize( 36, 43 );
LP["Icon"]:SetBackground( _G.resources.LOTROPoints );
LP["Icon"]:SetStretchMode( 1 );
LP["Icon"]:SetSize( 32, 32 );

--LP["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

LP["Icon"].MouseMove = function( sender, args )
	LP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
        MoveLPCtr(sender, args);
    else
        ShowToolTipWin( "LP" );
    end
end

LP["Icon"].MouseLeave = function( sender, args )
	LP["Lbl"].MouseLeave( sender, args );
end

LP["Icon"].MouseClick = function( sender, args )
	LP["Lbl"].MouseClick( sender, args );
end

LP["Icon"].MouseDown = function( sender, args )
	LP["Lbl"].MouseDown( sender, args );
end

LP["Icon"].MouseUp = function( sender, args )
	LP["Lbl"].MouseUp( sender, args );
end


LP["Lbl"] = Turbine.UI.Label();
LP["Lbl"]:SetParent( LP["Ctr"] );
LP["Lbl"]:SetFont( _G.TBFont );
LP["Lbl"]:SetPosition( 0, 0 );
--LP["Lbl"]:SetForeColor( Color["white"] );
LP["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
LP["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--LP["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

LP["Lbl"].MouseMove = function( sender, args )
	LP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveLPCtr(sender, args);
	else
		ShowToolTipWin( "LP" );
	end
end

LP["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

LP["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmLP then _G.frmLP = false; wLP:Close();
			else
				_G.frmLP = true;
				import (AppCtrD.."LOTROPointsWindow");
				frmLOTROPointsWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "LP";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

LP["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		LP["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

LP["Lbl"].MouseUp = function( sender, args )
	LP["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.LPLocX = LP["Ctr"]:GetLeft();
	settings.LOTROPoints.X = string.format("%.0f", _G.LPLocX);
	_G.LPLocY = LP["Ctr"]:GetTop();
	settings.LOTROPoints.Y = string.format("%.0f", _G.LPLocY);
	SaveSettings( false );
end
--**^

function MoveLPCtr(sender, args)
	local CtrLocX = LP["Ctr"]:GetLeft();
	local CtrWidth = LP["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = LP["Ctr"]:GetTop();
	local CtrHeight = LP["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	LP["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end