-- MoneyInfosToolTip.lua
-- written by Habna
-- refactored by 4andreas

import(AppDirD .. "UIHelpers")

function ShowMIWindow()
	local tt = CreateTooltipWindow({
		width = Constants.TOOLTIP_WIDTH_MEDIUM,
		hasListBox = true,
		listBoxPosition = {x = 15, y = 20}
	})
	
	MITTListBox = tt.listBox
	MITTListBox:SetWidth(_G.ToolTipWin:GetWidth() - 30)
	MITTListBox:SetMaxItemsPerLine(1)
	MITTListBox:SetOrientation(Turbine.UI.Orientation.Horizontal)

	MIRefreshMITTListBox()
	MITTListBox:SetHeight(MITTPosY)
	
	-- Resize tooltip window to fit content (top margin 20 + content + bottom margin ~20)
	if _G.ToolTipWin then
		_G.ToolTipWin:SetHeight(MITTPosY + 45)
	end

	ApplySkin()
end

function MoneyToCoins(m)
	local g = math.floor(m/100000);
	local s = math.floor(m/100)-g*1000;
	local c = m%100;
	return c,s,g;
end

function MIRefreshMITTListBox()	
	MITTListBox:ClearItems();
	MITTPosY = 0;
	iFound = false;
    
    MoneyIcons = {resources.MoneyIcon.Copper, resources.MoneyIcon.Silver, resources.MoneyIcon.Gold};
	--Create an array of character name, sort it, then use it as a reference.
	local a = {};
    for n in pairs(wallet) do table.insert(a, n) end
    table.sort(a);
    --for i,n in ipairs(a) do write(n) end --degug purpose

	for i = 1, #a do
		DecryptMoney(wallet[a[i]].Money);

		if a[i] == Player:GetName() then
			if wallet[a[i]].Show then 
        MITTShowData(MITTListBox, a[i], wallet[a[i]].Money, Color["green"], Color["green"]);
        MITTPosY = MITTPosY + 19; 
      end
		else
			if wallet[a[i]].ShowToAll or wallet[a[i]].ShowToAll == nil then 
        MITTShowData(MITTListBox, a[i], wallet[a[i]].Money, Color["white"], Color["white"]);
        MITTPosY = MITTPosY + 19; 
      end
		end
	end
	
	if not iFound then--No wallet info found, show a message
		--**v Control of message v**
		local MsgCtr = CreateControl(Turbine.UI.Control, MITTListBox, 0, 0, MITTListBox:GetWidth(), 19)
		MsgCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--**^
		--**v Message v**
		local MsgLbl = CreateControl(Turbine.UI.Label, MsgCtr, 0, 0, MsgCtr:GetWidth(), MsgCtr:GetHeight())
		MsgLbl:SetText( L["MIMsg"] );
		MsgLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		MsgLbl:SetForeColor( Color["red"] );
		--**^

		MITTListBox:AddItem( MsgCtr );
		MITTPosY = MITTPosY + 19;
	end

	--**v Line Control v**
	local LineCtr = CreateControl(Turbine.UI.Control, MITTListBox, 0, 0, MITTListBox:GetWidth(), 7)
	--LineCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );

	local LineLbl = CreateControl(Turbine.UI.Label, LineCtr, 0, 2, MITTListBox:GetWidth(), 1)
	LineLbl:SetText( "" );
	LineLbl:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	LineLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	LineLbl:SetBackColor( Color["trueblue"] );

	MITTListBox:AddItem( LineCtr );
	--**^
  MITTShowData(MITTListBox, L["MIWTotal"], (CopperTot + SilverTot*100 + GoldTot*100000), Color["white"], Color["white"]);
	MITTPosY = MITTPosY + 19;
    
	MITTListBox:AddItem( TotMoneyCtr );
	MITTPosY = MITTPosY + 8;

	--**v Statistics section v**
	local PN = Player:GetName();
	local moneyData = (_G.ControlData and _G.ControlData.Money) or {}
	
	if moneyData.sss == true then --Show session statistics if true
  	local space = Turbine.UI.Label();
    space:SetSize( Constants.LABEL_WIDTH_STANDARD, Constants.LABEL_HEIGHT_SMALL );
    MITTListBox:AddItem( space );
    MITTPosY = 	MITTPosY + 10;
    
		local LblStat = Turbine.UI.Label();
		LblStat:SetParent( MITTListBox );
		MITTListBox:AddItem( LblStat );
		LblStat:SetForeColor( Color["rustedgold"] );
		LblStat:SetSize( Constants.LABEL_WIDTH_STANDARD, Constants.LABEL_HEIGHT_LARGE );
		LblStat:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		LblStat:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		LblStat:SetText( L["MISession"] );

		local StatsSeparator = Turbine.UI.Control();
		StatsSeparator:SetParent( MITTListBox );
		StatsSeparator:SetSize( LblStat:GetWidth(), 1 );
		MITTListBox:AddItem( StatsSeparator );
		StatsSeparator:SetBackColor( Color["trueblue"] );
    MITTPosY = 	MITTPosY + 20;

    MITTShowData(MITTListBox, L["MIEarned"], walletStats[DOY][PN].Earned, Color["rustedgold"], Color["white"]);
		MITTShowData(MITTListBox, L["MISpent"], walletStats[DOY][PN].Spent, Color["rustedgold"], Color["white"]);
    if bSumSSS then color = Color["white"] else color = Color["red"] end
    MITTShowData(MITTListBox, L["MIWTotal"], walletStats[DOY][PN].SumSS, Color["rustedgold"], color);
	  MITTPosY = MITTPosY + 3*19;
  end
	

	if moneyData.sts == true then --Show today statistics if true
		local space = Turbine.UI.Label();
    space:SetSize( Constants.LABEL_WIDTH_STANDARD, Constants.LABEL_HEIGHT_SMALL );
    MITTListBox:AddItem( space );
    MITTPosY = 	MITTPosY + 10;
    
    local LblStat = Turbine.UI.Label();
		LblStat:SetParent( MITTListBox );
    MITTListBox:AddItem( LblStat );
		LblStat:SetForeColor( Color["rustedgold"] );
		LblStat:SetSize( Constants.LABEL_WIDTH_STANDARD, Constants.LABEL_HEIGHT_LARGE );
		LblStat:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		LblStat:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		LblStat:SetText( L["MIDaily"] );

		local StatsSeparator = Turbine.UI.Control();
		StatsSeparator:SetParent( MITTListBox );
		StatsSeparator:SetSize( LblStat:GetWidth(), 1 );
		MITTListBox:AddItem( StatsSeparator );
		StatsSeparator:SetBackColor( Color["trueblue"] );
		MITTPosY = MITTPosY + 20;

    MITTShowData(MITTListBox, L["MIEarned"], totem, Color["rustedgold"], Color["white"]);
		MITTShowData(MITTListBox, L["MISpent"], totsm, Color["rustedgold"], Color["white"]);
    if bSumSTS then color = Color["white"] else color = Color["red"] end
    MITTShowData(MITTListBox, L["MIWTotal"], walletStats[DOY][PN].SumTS, Color["rustedgold"], color);
    MITTPosY = MITTPosY + 3*19;
	end

	_G.ToolTipWin:SetSize( _G.ToolTipWin:GetWidth(), MITTPosY + 5 );

	PositionToolTipWindow();
end

function MITTShowData(parent,l,m,lc,mc,showDelIcon) -- l = label, m = money, lc = label color, money color
	iFound = true;
	local g = {};
	g[1], g[2], g[3] = MoneyToCoins(m);

	local MoneyCtr = Turbine.UI.Control();
	MoneyCtr:SetParent( parent );
	MoneyCtr:SetSize( parent:GetWidth(), 19 );
	MoneyCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );

	local lblName = Turbine.UI.Label();
	lblName:SetParent( MoneyCtr );
	lblName:SetText( l );
	lblName:SetPosition( 5, 0 );
	lblName:SetSize( lblName:GetTextLength() * 7.5, MoneyCtr:GetHeight() );
	lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	lblName:SetForeColor(lc);

	if showDelIcon then
    lblName:SetPosition( 15, 0 );  
    local DelIcon = CreateControl(Turbine.UI.Label, MoneyCtr, 0, 0, Constants.DELETE_ICON_SIZE, Constants.DELETE_ICON_SIZE);
  	DelIcon:SetBackground( resources.DelIcon );
  	DelIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
  	DelIcon:SetVisible( true );
		if l == Player:GetName() then DelIcon:SetVisible( false ); end

  	DelIcon.MouseClick = function( sender, args )
  		if ( args.Button == Turbine.UI.MouseButton.Left ) then
  			write(l .. L["MIWID"]);
  			wallet[l].ShowToAll = false;
				local showTotal = (_G.ControlData and _G.ControlData.Money and _G.ControlData.Money.stm) == true
				local moneyUi = _G.ControlData and _G.ControlData.Money and _G.ControlData.Money.ui
				local allCharCB = moneyUi and moneyUi.AllCharCB
				if showTotal and allCharCB then
					allCharCB:SetChecked( false );
					SavePlayerMoney(true);
					allCharCB:SetChecked( true );
				else
					SavePlayerMoney(true);
				end
  			RefreshMIListBox();
  		end
  	end
  end

  local pos = MoneyCtr:GetWidth() + 4;
	for i = 1,3 do
        local NewIcon = CreateControl(Turbine.UI.Control, MoneyCtr, pos - 34, -2, 27, 21);
        NewIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
        NewIcon:SetBackground(MoneyIcons[i]);

        local NewLbl = Turbine.UI.Label();
        NewLbl:SetParent(MoneyCtr);
        NewLbl:SetText(string.format("%.0f", g[i]));
        if i == 3 then size = 48 else size = 18 end;
        NewLbl:SetSize(size + 2, MoneyCtr:GetHeight());
        NewLbl:SetPosition(NewIcon:GetLeft() - size, 0);
        NewLbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
        NewLbl:SetForeColor(mc);
        pos = NewLbl:GetLeft();
    end

	parent:AddItem( MoneyCtr );
end
