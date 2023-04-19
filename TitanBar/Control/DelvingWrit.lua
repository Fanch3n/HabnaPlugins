-- DelvingWrit.lua
-- Written by Fanchen


_G.DW = {}; -- Delving Writs table in _G

--**v Control of Delving Writs v**
DW["Ctr"] = Turbine.UI.Control();
DW["Ctr"]:SetParent( TB["win"] );
DW["Ctr"]:SetMouseVisible( false );
DW["Ctr"]:SetZOrder( 2 );
DW["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DW["Ctr"]:SetBackColor( Turbine.UI.Color( DWbcAlpha, DWbcRed, DWbcGreen, DWbcBlue ) );
--**^
--**v Delving Writs & icon on TitanBar v**
DW["Icon"] = Turbine.UI.Control();
DW["Icon"]:SetParent( DW["Ctr"] );
DW["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DW["Icon"]:SetSize( 32, 32 );
DW["Icon"]:SetBackground( WalletItem.DelvingWrit.Icon );-- in-game icon 32x32
--**^

DW["Icon"].MouseMove = function( sender, args )
	DW["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveDWCtr(sender, args); end
end

DW["Icon"].MouseLeave = function( sender, args )
	DW["Lbl"].MouseLeave( sender, args );
end

DW["Icon"].MouseClick = function( sender, args )
	DW["Lbl"].MouseClick( sender, args );
end

DW["Icon"].MouseDown = function( sender, args )
	DW["Lbl"].MouseDown( sender, args );
end

DW["Icon"].MouseUp = function( sender, args )
	DW["Lbl"].MouseUp( sender, args );
end


DW["Lbl"] = Turbine.UI.Label();
DW["Lbl"]:SetParent( DW["Ctr"] );
DW["Lbl"]:SetFont( _G.TBFont );
DW["Lbl"]:SetPosition( 0, 0 );
DW["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
DW["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );

DW["Lbl"].MouseMove = function( sender, args )
	DW["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveDWCtr(sender, args);
	else
		ShowToolTipWin( "DW" );
	end
end

DW["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

DW["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "DW";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

DW["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		DW["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

DW["Lbl"].MouseUp = function( sender, args )
	DW["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.DWLocX = DW["Ctr"]:GetLeft();
	settings.DelvingWrit.X = string.format("%.0f", _G.DWLocX);
	_G.DWLocY = DW["Ctr"]:GetTop();
	settings.DelvingWrit.Y = string.format("%.0f", _G.DWLocY);
	SaveSettings( false );
end
--**^

function MoveDWCtr(sender, args)
	local CtrLocX = DW["Ctr"]:GetLeft();
	local CtrWidth = DW["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = DW["Ctr"]:GetTop();
	local CtrHeight = DW["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	DW["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end