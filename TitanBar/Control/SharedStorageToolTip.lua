import(AppDirD .. "UIHelpers")

function ShowSharedToolTip()
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	
	SharedTTListBox = Turbine.UI.ListBox();
	SharedTTListBox:SetParent( _G.ToolTipWin );
	SharedTTListBox:SetZOrder( 1 );
	SharedTTListBox:SetPosition( 20, 20 );
	SharedTTListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );

	_G.ToolTipWin.lblmgs = GetLabel(L["SSnd"]);
	_G.ToolTipWin.lblmgs:SetParent( _G.ToolTipWin );
	_G.ToolTipWin.lblmgs:SetSize( 350, Constants.LABEL_HEIGHT_MESSAGE );

	RefreshSharedTTListBox();

	ApplySkin();
end

function RefreshSharedTTListBox()
	local x, y = -5, -15;
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();

	SharedTTListBox:ClearItems();
	local sharedpackCount=0;
	--VaultItemHeight = 35;
	
	for k, v in pairs(PlayerSharedStorage) do sharedpackCount = sharedpackCount + 1; end

	local noItems = sharedpackCount == 0;

	_G.ToolTipWin.lblmgs:SetVisible(noItems);
	SharedTTListBox:SetVisible(not noItems);

	if (noItems) then
		_G.ToolTipWin:SetWidth(Constants.TOOLTIP_WIDTH_VAULT);
		_G.ToolTipWin:SetHeight(115);
		_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
		_G.ToolTipWin:SetVisible( true );

		return;
	end

	for i = 1, sharedpackCount do
		--local itemName = PlayerSharedStorage[tostring(i)].T;
		
		-- Item control
		local itemCtl = Turbine.UI.Control();
		itemCtl:SetParent( VaultTTListBox );
		itemCtl:SetSize( Constants.ICON_SIZE_XLARGE, Constants.ICON_SIZE_XLARGE );
				
		-- Item background
		local itemBG = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		if PlayerSharedStorage[tostring(i)].B ~= "0" then itemBG:SetBackground( tonumber(PlayerSharedStorage[tostring(i)].B) ); end
		itemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
		-- Item Underlay
		local itemU = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		if PlayerSharedStorage[tostring(i)].U ~= "0" then itemU:SetBackground( tonumber(PlayerSharedStorage[tostring(i)].U) ); end
		itemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item Shadow
		local itemS = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		if PlayerSharedStorage[tostring(i)].S ~= "0" then itemS:SetBackground( tonumber(PlayerSharedStorage[tostring(i)].S) ); end
		itemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item
		local item = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		if PlayerSharedStorage[tostring(i)].I ~= "0" then item:SetBackground( tonumber(PlayerSharedStorage[tostring(i)].I) ); end
		item:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item Quantity
		local itemQTE = CreateControl(Turbine.UI.Label, itemCtl, 0, 20, Constants.ICON_SIZE_LARGE, 15);
		itemQTE:SetFont( Turbine.UI.Lotro.Font.Verdana12 );
		itemQTE:SetFontStyle( Turbine.UI.FontStyle.Outline );
		itemQTE:SetOutlineColor( Color["black"] );
		itemQTE:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		itemQTE:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
		itemQTE:SetForeColor( Color["nicegold"] );
		itemQTE:SetText( tonumber(PlayerSharedStorage[tostring(i)].N) );
		
		SharedTTListBox:AddItem( itemCtl );
	end
	
	MaxItemsPerLine = 15;
	
	SharedTTHeight = 40 * sharedpackCount / MaxItemsPerLine + 50;
	if SharedTTHeight > screenHeight then SharedTTHeight = screenHeight - 70; end
	
	SharedTTListBox:SetHeight( SharedTTHeight - 35 );
	SharedTTListBox:SetMaxItemsPerLine( MaxItemsPerLine );
		
	local w = 40 * MaxItemsPerLine + 40;
	
	if w + mouseX > screenWidth then x = w - 10; end
	
	_G.ToolTipWin:SetHeight( SharedTTHeight );
	_G.ToolTipWin:SetWidth( w );
	_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
	_G.ToolTipWin:SetVisible( true );
	SharedTTListBox:SetWidth( _G.ToolTipWin:GetWidth() - 40 );
end