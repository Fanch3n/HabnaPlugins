import(AppDirD .. "UIHelpers")

function ShowVaultToolTip()
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	
	VaultTTListBox = Turbine.UI.ListBox();
	VaultTTListBox:SetParent( _G.ToolTipWin );
	VaultTTListBox:SetZOrder( 1 );
	VaultTTListBox:SetPosition( 20, 20 );
	VaultTTListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );

	_G.ToolTipWin.lblmgs = GetLabel(L["VTnd"]);
	_G.ToolTipWin.lblmgs:SetParent( _G.ToolTipWin );
	_G.ToolTipWin.lblmgs:SetSize( 350, Constants.LABEL_HEIGHT_MESSAGE );

	RefreshVaultTTListBox();

	ApplySkin();
end

function RefreshVaultTTListBox()
	local x, y = -5, -15;
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();

	VaultTTListBox:ClearItems();
	local vaultpackCount=0;
	--VaultItemHeight = 35;
	
	for k, v in pairs(PlayerVault[PN]) do vaultpackCount = vaultpackCount + 1; end

	local noItems = vaultpackCount == 0;

	_G.ToolTipWin.lblmgs:SetVisible(noItems);
	VaultTTListBox:SetVisible(not noItems);

	if (noItems) then
		_G.ToolTipWin:SetWidth(Constants.TOOLTIP_WIDTH_VAULT);
		_G.ToolTipWin:SetHeight(115);
		_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
		_G.ToolTipWin:SetVisible( true );

		return;
	end

	for i = 1, vaultpackCount do
		--local itemName = PlayerVault[PN][tostring(i)].T;
		
		-- Item control
		local itemCtl = Turbine.UI.Control();
		itemCtl:SetParent( VaultTTListBox );
		itemCtl:SetSize( Constants.ICON_SIZE_XLARGE, Constants.ICON_SIZE_XLARGE );
				
		-- Item background
		local itemBG = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		if PlayerVault[PN][tostring(i)].B ~= "0" then itemBG:SetBackground( tonumber(PlayerVault[PN][tostring(i)].B) ); end
		itemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
		-- Item Underlay
		local itemU = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		if PlayerVault[PN][tostring(i)].U ~= "0" then itemU:SetBackground( tonumber(PlayerVault[PN][tostring(i)].U) ); end
		itemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item Shadow
		local itemS = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		if PlayerVault[PN][tostring(i)].S ~= "0" then itemS:SetBackground( tonumber(PlayerVault[PN][tostring(i)].S) ); end
		itemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item
		local item = CreateControl(Turbine.UI.Control, itemCtl, 4, 4, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		if PlayerVault[PN][tostring(i)].I ~= "0" then item:SetBackground( tonumber(PlayerVault[PN][tostring(i)].I) ); end
		item:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item Quantity
		local itemQTE = CreateControl(Turbine.UI.Label, itemCtl, 0, 20, Constants.ICON_SIZE_LARGE, 15)
		itemQTE:SetFont( Turbine.UI.Lotro.Font.Verdana12 );
		itemQTE:SetFontStyle( Turbine.UI.FontStyle.Outline );
		itemQTE:SetOutlineColor( Color["black"] );
		itemQTE:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		itemQTE:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
		itemQTE:SetForeColor( Color["nicegold"] );
		itemQTE:SetText( tonumber(PlayerVault[PN][tostring(i)].N) );
		
		VaultTTListBox:AddItem( itemCtl );
	end
	
	MaxItemsPerLine = 15;
	
	VaultTTHeight = 40 * vaultpackCount / MaxItemsPerLine + 45;
	if VaultTTHeight > screenHeight then VaultTTHeight = screenHeight - 70; end
	
	VaultTTListBox:SetHeight( VaultTTHeight );
	VaultTTListBox:SetMaxItemsPerLine( MaxItemsPerLine );
		
	local w = 40 * MaxItemsPerLine + 40;
	
	if w + mouseX > screenWidth then x = w - 10; end
	
	_G.ToolTipWin:SetHeight( VaultTTHeight + 20);
	_G.ToolTipWin:SetWidth( w );
	_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
	_G.ToolTipWin:SetVisible( true );

	VaultTTListBox:SetWidth( _G.ToolTipWin:GetWidth() - 40 );
end