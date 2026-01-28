import(AppDirD .. "UIHelpers")


function ShowIFWindow()
	local tt = CreateTooltipWindow({})

	RefreshIFToolTip()

	ApplySkin()
	
	-- Position with custom logic for infamy
	local x, y = -5, -15
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition()
	
	if _G.ToolTipWin:GetWidth() + mouseX > screenWidth then 
		x = _G.ToolTipWin:GetWidth() - 10
	end
	
	if not TBTop then 
		y = _G.ToolTipWin:GetHeight()
	end
	
	_G.ToolTipWin:SetPosition(mouseX - x, mouseY - y)
end

function RefreshIFToolTip()
	local labelRank = Turbine.UI.Label();
	labelRank:SetParent( _G.ToolTipWin );
	labelRank:SetText( L["IFCR"] );
	labelRank:SetPosition( 15, 12 );
	labelRank:SetSize( labelRank:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	labelRank:SetForeColor( Color["white"] );
	labelRank:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	labelRank:SetVisible( true );
	labelRank:SetZOrder( 2 );
	--labelRank:SetBackColor( Color["red"] ); -- debug purpose

	local lblRank = Turbine.UI.Label();
	lblRank:SetParent( _G.ToolTipWin );
	lblRank:SetText( settings.Infamy.K );
	lblRank:SetPosition( labelRank:GetLeft()+labelRank:GetWidth()+5, labelRank:GetTop() );
	lblRank:SetSize( lblRank:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	lblRank:SetForeColor( Color["green"] );
	lblRank:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	lblRank:SetVisible( true );
	lblRank:SetZOrder( 2 );
	--lblRank:SetBackColor( Color["red"] ); -- debug purpose

	local labelInfamy = Turbine.UI.Label();
	labelInfamy:SetParent( _G.ToolTipWin );
	labelInfamy:SetText( L["IFIF"] );
	labelInfamy:SetPosition( labelRank:GetLeft(), lblRank:GetTop()+lblRank:GetHeight()+5 );
	labelInfamy:SetSize( labelInfamy:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	labelInfamy:SetForeColor( Color["white"] );
	labelInfamy:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	labelInfamy:SetVisible( true );
	labelInfamy:SetZOrder( 2 );
	--labelInfamy:SetBackColor( Color["red"] ); -- debug purpose

	local infamyRanks = _G.InfamyRanks or Constants.INFAMY_RANKS
	local lblInfamy = Turbine.UI.Label();
	lblInfamy:SetParent( _G.ToolTipWin );
	lblInfamy:SetText( settings.Infamy.P .. "/" .. infamyRanks[tonumber(settings.Infamy.K)+1]);
	lblInfamy:SetPosition( labelInfamy:GetLeft()+labelInfamy:GetWidth()+5, labelInfamy:GetTop() );
	lblInfamy:SetSize( lblInfamy:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	lblInfamy:SetForeColor( Color["green"] );
	lblInfamy:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	lblInfamy:SetVisible( true );
	lblInfamy:SetZOrder( 2 );
	--lblInfamy:SetBackColor( Color["red"] ); -- debug purpose

	local NextRankCtr = CreateControl(Turbine.UI.Control, _G.ToolTipWin, labelInfamy:GetLeft(), labelInfamy:GetTop()+labelInfamy:GetHeight()+5, 0, 0)
	NextRankCtr:SetZOrder( 2 );
	--NextRankCtr:SetBackColor( Color["red"] ); -- debug purpose
	
	local lblNextRank = Turbine.UI.Label();
	lblNextRank:SetParent( NextRankCtr );
	lblNextRank:SetText( infamyRanks[tonumber(settings.Infamy.K)+1] - settings.Infamy.P);
	lblNextRank:SetPosition( 0, 0 );
	lblNextRank:SetSize( lblNextRank:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	lblNextRank:SetForeColor( Color["green"] );
	lblNextRank:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--lblNextRank:SetBackColor( Color["red"] ); -- debug purpose

	local labelTN = Turbine.UI.Label();
	labelTN:SetParent( NextRankCtr );
	labelTN:SetText( L["IFTN"] );
	labelTN:SetPosition( lblNextRank:GetLeft()+lblNextRank:GetWidth()+5, 0 );
	labelTN:SetSize( labelTN:GetTextLength() * 7.2, 15 ); --Auto size with text lenght
	labelTN:SetForeColor( Color["white"] );
	labelTN:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--labelTN:SetBackColor( Color["red"] ); -- debug purpose

	NextRankCtr:SetSize( lblNextRank:GetWidth()+labelTN:GetWidth()+10, 15 );

	local percentage_done = string.format("%.1f", tonumber(settings.Infamy.P) / infamyRanks[tonumber(settings.Infamy.K)+1]*100);
	--percentage_done = string.format("%.1f", percentage_done);
	--percentage_done = 1; --debug purpose

	--**v Infamy progress bar v**		
	local IFPBCTr = CreateControl(Turbine.UI.Control, _G.ToolTipWin, NextRankCtr:GetLeft(), NextRankCtr:GetTop()+NextRankCtr:GetHeight()+5, 200, 15)
	IFPBCTr:SetZOrder( 2 );
	--IFPBCTr:SetBackColor( Color["red"] ); -- debug purpose
		
	local IFPBFill = CreateControl(Turbine.UI.Control, IFPBCTr, 9, 3, (Constants.PROGRESS_BAR_WIDTH*percentage_done)/100, Constants.PROGRESS_BAR_HEIGHT)--Filling
	IFPBFill:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	IFPBFill:SetBackground( resources.InfamyBG );
	--IFPBFill:SetBackColor( Color["red"] ); -- debug purpose
		
	local IFPB = CreateControl(Turbine.UI.Control, IFPBCTr, 0, 0, 0, 0) --Frame
	IFPB:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	IFPB:SetSize( Constants.LABEL_WIDTH_WIDE, Constants.LABEL_HEIGHT_STANDARD );
	IFPB:SetBackground( 0x41007e94 );
	-- pourcentage bar: 0x41007e94
	--IFPB:SetBackColor( Color["red"] ); -- debug purpose

	local labelPC = Turbine.UI.Label();
	labelPC:SetParent( IFPBCTr );
	labelPC:SetText( percentage_done .. "%" );
	labelPC:SetPosition( 0, 2 );
	labelPC:SetSize( Constants.LABEL_WIDTH_WIDE, Constants.LABEL_HEIGHT_STANDARD );
	labelPC:SetForeColor( Color["white"] );
	labelPC:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	--labelTN:SetBackColor( Color["red"] ); -- debug purpose
	--**^
	
	-- Calculate and set tooltip window size
	local h = IFPBCTr:GetTop() + IFPBCTr:GetHeight() + 20
	_G.ToolTipWin:SetSize( NextRankCtr:GetWidth()+40, h )
end