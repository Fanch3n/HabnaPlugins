-- TrackItemsToolTip.lua
-- written by Habna

import(AppDirD .. "UIHelpers")

local player = Turbine.Gameplay.LocalPlayer.GetInstance();
local backpack = player:GetBackpack();

function ShowTIWindow()
	local tt = CreateTooltipWindow({
		hasListBox = true,
		listBoxPosition = {x = 15, y = 12},
		listBoxWidth = Constants.TOOLTIP_WIDTH_MEDIUM
	})
	
	TITTListBox = tt.listBox
	ConfigureListBox(TITTListBox)

	TIRefreshListBox()

	ApplySkin()
end

function TIRefreshListBox()
	TITTListBox:ClearItems();
	TITTPosY = 35;

	-- Items tracked in another game language can't be found by name, they are not shown.
	-- Quantity of all stacks in the backpack; tracked items that are not there show 0, if the option is on.
	local showMissing = _G.ControlData.TI.showMissing ~= false;
	local tracked = {};
	for _, entry in ipairs(TrackedItemsOfLanguage()) do
		local total, found = 0, false;
		for ii = 1, backpack:GetSize() do
			local item = backpack:GetItem( ii );
			if item ~= nil and item:GetName() == entry.N then total = total + item:GetQuantity(); found = true; end
		end
		if found or showMissing then table.insert(tracked, { entry = entry, total = total }) end
	end

	if #tracked == 0 then
		local lblName = Turbine.UI.Label();
		lblName:SetParent( _G.ToolTipWin );
		lblName:SetText( L["BINI"] );
		lblName:SetPosition( 0, 0 );
		lblName:SetSize( Constants.LABEL_WIDTH_ITEM, Constants.LABEL_HEIGHT_ITEM );
		lblName:SetForeColor( Color["green"] );
		lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

		TITTListBox:AddItem( lblName );

		TITTPosY = TITTPosY + 35;
	else
		for _, shown in ipairs(tracked) do
			local entry, total = shown.entry, shown.total;

			--**v Control of all data v**
			local BITTCtr = Turbine.UI.Control();
			BITTCtr:SetParent( TITTListBox );
			BITTCtr:SetSize( TITTListBox:GetWidth(), 35 );
			BITTCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
			--**^

			-- Item Background/Underlay/Shadow/Image, from the list as the item may not be in the bags
			local BITTitemBG = CreateControl(Turbine.UI.Control, BITTCtr, 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
			BITTitemBG:SetBackground(tonumber(entry.B));
			BITTitemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			local BITTitemU = CreateControl(Turbine.UI.Control, BITTCtr, 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
			if entry.U ~= "0" then BITTitemU:SetBackground(tonumber(entry.U)); end
			BITTitemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			local BITTitemS = CreateControl(Turbine.UI.Control, BITTCtr, 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
			if entry.S ~= "0" then BITTitemS:SetBackground(tonumber(entry.S)); end
			BITTitemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			local BITTitem = CreateControl(Turbine.UI.Control, BITTCtr, 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
			BITTitem:SetBackground(tonumber(entry.I));
			BITTitem:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			TITTListBox:AddItem( BITTCtr );

			-- Item Quantity
			local itemQTE = CreateQuantityLabel(BITTCtr, total)
			itemQTE:SetText( total );

			-- Item name
			local itemsLbl = CreateControl(Turbine.UI.Label, BITTCtr, 37, 2, TITTListBox:GetWidth() - 35, 35);
			itemsLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
			itemsLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			itemsLbl:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
			itemsLbl:SetForeColor( Color["white"] );
			itemsLbl:SetText( entry.N );

			--Put item name & quantity to red if quantity is < 10 (also for missing items). Credit goes to Wicky71.
			if total < 10 then
				itemQTE:SetForeColor( Color["red"] );
				itemsLbl:SetForeColor( Color["red"] );
			end

			TITTPosY = TITTPosY + 35;
		end
	end

	TITTListBox:SetHeight( TITTPosY );

	if #tracked == 0 then _G.ToolTipWin:SetSize( 300, TITTPosY - 7 );
	else _G.ToolTipWin:SetSize( 320, TITTPosY - 7 ); end

	PositionToolTipWindow();
end