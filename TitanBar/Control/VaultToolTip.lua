function ShowVaultToolTip()
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	
	VaultTTListBox = Turbine.UI.ListBox();
	VaultTTListBox:SetParent( _G.ToolTipWin );
	VaultTTListBox:SetZOrder( 1 );
	VaultTTListBox:SetPosition( 20, 20 );
	VaultTTListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );

	_G.ToolTipWin.lblmgs = _G.SS.GetSharedStorageNotFoundLabel(L["VTnd"]);
	_G.ToolTipWin.lblmgs:SetParent( _G.ToolTipWin );
	_G.ToolTipWin.lblmgs:SetSize( 350, 39 );

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
		_G.ToolTipWin:SetWidth(400);
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
		itemCtl:SetSize( 40, 40 );
				
		-- Item background
		local itemBG = Turbine.UI.Control();
		itemBG:SetParent( itemCtl );
		itemBG:SetPosition( 4, 4 );
		itemBG:SetSize( 32, 32 );
		if PlayerVault[PN][tostring(i)].B ~= "0" then itemBG:SetBackground( tonumber(PlayerVault[PN][tostring(i)].B) ); end
		itemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
		-- Item Underlay
		local itemU = Turbine.UI.Control();
		itemU:SetParent( itemCtl );
		itemU:SetSize( 32, 32 );
		itemU:SetPosition( 4, 4 );
		if PlayerVault[PN][tostring(i)].U ~= "0" then itemU:SetBackground( tonumber(PlayerVault[PN][tostring(i)].U) ); end
		itemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item Shadow
		local itemS = Turbine.UI.Control();
		itemS:SetParent( itemCtl );
		itemS:SetSize( 32, 32 );
		itemS:SetPosition( 4, 4 );
		if PlayerVault[PN][tostring(i)].S ~= "0" then itemS:SetBackground( tonumber(PlayerVault[PN][tostring(i)].S) ); end
		itemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item
		local item = Turbine.UI.Control();
		item:SetParent( itemCtl );
		item:SetSize( 32, 32 );
		item:SetPosition( 4, 4 );
		if PlayerVault[PN][tostring(i)].I ~= "0" then item:SetBackground( tonumber(PlayerVault[PN][tostring(i)].I) ); end
		item:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item Quantity
		local itemQTE = Turbine.UI.Label();
		itemQTE:SetParent( itemCtl );
		itemQTE:SetSize( 32, 15 );
		itemQTE:SetPosition( 0, 20 );
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
	
	VaultTTListBox:SetHeight( VaultTTHeight - 35 );
	VaultTTListBox:SetMaxItemsPerLine( MaxItemsPerLine );
		
	local w = 40 * MaxItemsPerLine + 40;
	
	if w + mouseX > screenWidth then x = w - 10; end
	
	_G.ToolTipWin:SetHeight( VaultTTHeight );
	_G.ToolTipWin:SetWidth( w );
	_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
	_G.ToolTipWin:SetVisible( true );

	VaultTTListBox:SetWidth( _G.ToolTipWin:GetWidth() - 40 );
end