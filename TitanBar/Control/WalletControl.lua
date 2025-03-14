-- WalletControl.lua
-- Written by Thorondor

--[[
Mithril = { Icon = 0x411348E1,
			String = { DE = , EN = , FR = }, -- NAME = String.EN
			ToolTip = { DE = , EN = , FR = } },

init = { icon, str/PW, TT }						  
]]

function WalletControl(init)
  local self = {
    bcAlpha, bcRed, bcGreen, bcBlue;
	ShowMe, LocX, LocY, Where;
  };

  local IconHex = init.Icon;
  local PW = init.PW;
  local ToolTip = init.ToolTip;
  local NAME = string.gsub(PW, " ", "");
  
  LoadSettings();
  
  self.Ctr = Turbine.UI.Control()
  self.Ctr:SetParent( TB["win"] );
  self.Ctr:SetMouseVisible( false );
  self.Ctr:SetZOrder( 2 );
  self.Ctr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
  self.Ctr:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );

  self.Icon = Turbine.UI.Control();
  self.Icon:SetParent( self.Ctr );
  self.Icon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
  self.Icon:SetSize( 32, 32 );
  self.Icon:SetBackground( IconHex );

  self.Icon.MouseMove = function( sender, args )
	self.Lbl.MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveMCCtr(sender, args); end
  end

  self.Icon.MouseLeave = function( sender, args )
	self.Lbl.MouseLeave( sender, args );
  end

  self.Icon.MouseClick = function( sender, args )
	self.Lbl.MouseClick( sender, args );
  end

  self.Icon.MouseDown = function( sender, args )
	self.Lbl.MouseDown( sender, args );
  end

  self.Icon.MouseUp = function( sender, args )
	self.Lbl.MouseUp( sender, args );
  end

  self.Lbl = Turbine.UI.Label();
  self.Lbl:SetParent( self.Ctr );
  self.Lbl:SetFont( _G.TBFont );
  self.Lbl:SetPosition( 0, 0 );
  self.Lbl:SetFontStyle( Turbine.UI.FontStyle.Outline );
  self.Lbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );

  self.Lbl.MouseMove = function( sender, args )
	self.Lbl.MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveCtr(sender, args);
	else
		ShowToolTipWin();
	end
  end

  self.Lbl.MouseLeave = function( sender, args )
	ResetToolTipWin();
  end

  self.Lbl.MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then -- fix this
		_G.sFromCtr = "MC";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
  end

  self.Lbl.MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		self.Ctr:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
  end

  self.Lbl.MouseUp = function( sender, args )
	self.Ctr:SetZOrder( 2 );
	dragging = false;
	LocX = self.Ctr:GetLeft();
	settings.NAME.X = string.format("%.0f", LocX);
	LocY = self.Ctr:GetTop();
	settings.NAME.Y = string.format("%.0f", LocY);
	SaveSettings( false );
  end
  
  function ShowToolTipWin()
    local bblTo, x, y, w = "left", -5, -15, 0; 
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	
	w = 310;
	if TBLocale == "fr" then w = 315;
	elseif TBLocale == "de" then
		if ToShow == "DI" then w = 225; 
		else w = 305; end
	end
  
    if w + mouseX > screenWidth then bblTo = "right"; x = w - 10; end
	h = 65;
	if not TBTop then y = h; end
	createToolTipWin( x, y, w, h, bblTo, ToolTip, _G.L["EIt2"], _G.L["EIt3"] );
    -- TTW = createT...	
	
	_G.ToolTipWin:SetPosition( mouseX - _G.ToolTipWin.xOffset, mouseY - _G.ToolTipWin.yOffset);
	_G.ToolTipWin:SetVisible( true );
  end;
  
  function MoveCtr(sender, args)
	local CtrLocX = self.Ctr:GetLeft();
	local CtrWidth = self.Ctr:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = self.Ctr:GetTop();
	local CtrHeight = self.Ctr:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	self.Ctr:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
  end
    
  function self.initColour()
  end;

  function LoadSettings()
		if _G.Debug then write("WalletControl.lua");	end
		if GLocale == "en" then	tA, tR, tG, tB, tX, tY, tW = 0.3, 0.3, 0.3, 0.3, 0, 0, 3;
	else tA, tR, tG, tB, tX, tY, tW = "0,3", "0,3", "0,3", "0,3", "0", "0", "3"; end --Default alpha, red, green, blue, X, Y pos of control, Show where
	tL, tT = 100, 100; --Default position of control window
	
	if self.settings == nil then self.settings = {}; end
		
    if self.settings.NAME == nil then self.settings.NAME = {}; end
	if self.settings.NAME.V == nil then self.settings.NAME.V = false; end
	if self.settings.NAME.A == nil then self.settings.NAME.A = string.format("%.3f", tA); end
	if self.settings.NAME.R == nil then self.settings.NAME.R = string.format("%.3f", tR); end
	if self.settings.NAME.G == nil then self.settings.NAME.G = string.format("%.3f", tG); end
	if self.settings.NAME.B == nil then self.settings.NAME.B = string.format("%.3f", tB); end
	if self.settings.NAME.X == nil then self.settings.NAME.X = string.format("%.0f", tX); end
	if self.settings.NAME.Y == nil then self.settings.NAME.Y = string.format("%.0f", tY); end
	if self.settings.NAME.W == nil then self.settings.NAME.W = string.format("%.0f", tW); end
	ShowMe = self.settings.NAME.V;
	bcAlpha = tonumber(self.settings.NAME.A);
	bcRed = tonumber(self.settings.NAME.R);
	bcGreen = tonumber(self.settings.NAME.G);
	bcBlue = tonumber(self.settings.NAME.B);
	LocX = tonumber(self.settings.NAME.X);
	LocY = tonumber(self.settings.NAME.Y);
	Where = tonumber(self.settings.NAME.W);
	--if Where == 3 and ShowMe then Where = 1; self.settings.NAME.W = string.format("%.0f", Where); end --Remove after Oct, 15th 2013
    
	SavePluginData();
  end
  
  function self.SaveSettings()
    self.settings.NAME = {};
	self.settings.NAME.V = ShowMe;
	self.settings.NAME.A = string.format("%.3f", bcAlpha);
	self.settings.NAME.R = string.format("%.3f", bcRed);
	self.settings.NAME.G = string.format("%.3f", bcGreen);
	self.settings.NAME.B = string.format("%.3f", bcBlue);
	self.settings.NAME.X = string.format("%.0f", LocX);
	self.settings.NAME.Y = string.format("%.0f", LocY);
	self.settings.NAME.W = string.format("%.0f", Where);
	
	SavePluginData();
  end
  
  function self.ShowHide()
	ShowMe = not ShowMe;
	self.settings.NAME.V = ShowMe;
	self.settings.NAME.W = string.format("%.0f", Where);
	SavePluginData();
	ImportCtr();
	if ShowMe then
		self.Ctr:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );
	end
	self.Ctr:SetVisible( ShowMe );
  end
  
  function ImportCtr()
    if Where == 1 then	
		--import (AppCtrD.."MithrilCoins");
		self.Ctr:SetPosition( LocX, LocY ); 
	end
	if Where ~= 3 then
		UpdateCtr();
	end
  end

  function UpdateCtr()
	if Where == 1 then
		self.Lbl:SetText( GetCurrency( PW ) );
		self.Lbl:SetSize( self.Lbl:GetTextLength() * NM, CTRHeight ); --Auto size with text lenght
		AdjustIcon();
	end
  end
  
  function AdjustIcon()
    if TBHeight > 30 then CTRHeight = 30; end --Stop ajusting icon size if TitanBar height is > 30px

	local Y = -1 - ((TBIconSize - CTRHeight) / 2);
	
	self.Icon:SetStretchMode( 1 );
	self.Icon:SetPosition( self.Lbl:GetLeft() + self.Lbl:GetWidth() + 3, Y );
	self.Ctr:SetSize( self.Icon:GetLeft() + TBIconSize, CTRHeight );
	self.Icon:SetSize( TBIconSize, TBIconSize );
	self.Icon:SetStretchMode( 3 );
  end
  
  function SavePluginData()
	if GLocale == "de" then Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarSettingsDE", settings ); end
	if GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarSettingsEN", settings ); end
	if GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarSettingsFR", settings ); end
  end
  -- return the instance
  return self;
end;