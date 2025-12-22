-- TrackItemsToolTip.lua
-- written by Habna

import(AppDirD .. "UIHelpers")

local player = Turbine.Gameplay.LocalPlayer.GetInstance();
local backpack = player:GetBackpack();
local size = backpack:GetSize();

function ShowTIWindow()
	-- ( offsetX, offsetY, width, height, bubble side )
	--x, y, w, h, bblTo = -5, -15, 0, 0, "left";
	--mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	
	--if w + mouseX > screenWidth then bblTo = "right"; x = w - 10; end
	
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	--_G.ToolTipWin.xOffset = x;
	--_G.ToolTipWin.yOffset = y;
	_G.ToolTipWin:SetVisible( true );

	TITTListBox = Turbine.UI.ListBox();
	TITTListBox:SetParent( _G.ToolTipWin );
	TITTListBox:SetZOrder( 1 );
	TITTListBox:SetPosition( 15, 12 );
	TITTListBox:SetWidth( Constants.TOOLTIP_WIDTH_MEDIUM );
	ConfigureListBox(TITTListBox)
	--TITTListBox:SetBackColor( Color["darkgrey"] ); --debug purpose

	TIRefreshListBox();

	ApplySkin();
end

function TIRefreshListBox()
	TITTListBox:ClearItems();
	TITTPosY = 35;
	
	-- Convert the table key that is in string format into a number, so it can be viewed by lua correctly.
	local newt = {}
	for i, v in pairs(ITL) do newt[tonumber(i)] = v; end
	ITL = newt;

	if #ITL == 0 then
		local lblName = Turbine.UI.Label();
		lblName:SetParent( _G.ToolTipWin );
		--lblName:SetFont ( 12 );
		lblName:SetText( L["BINI"] );
		lblName:SetPosition( 0, 0 );
		lblName:SetSize( Constants.LABEL_WIDTH_ITEM, Constants.LABEL_HEIGHT_ITEM );
		lblName:SetForeColor( Color["green"] );
		lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		--lblName:SetBackColor( Color["red"] ); -- debug purpose

		TITTListBox:AddItem( lblName );

		TITTPosY = TITTPosY + 35;
	else
		bItemInListFoundInBag = false;
		for i = 1, #ITL do
			for k,v in pairs(ITL[i]) do
				BITTItemTot = 0;
				for ii = 1, size do
					local bFound = false;
					local item = backpack:GetItem( ii );
					
					if item ~= nil then
						local itemName = item:GetName();
					
						if itemName == k then
							bFound = true;
							bItemInListFoundInBag = true;
							--**v Control of all data v**
							local BITTCtr = Turbine.UI.Control();
							BITTCtr:SetParent( TITTListBox );
							BITTCtr:SetSize( TITTListBox:GetWidth(), 35 );
							BITTCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
							--BITTCtr:SetBackColor( Color["red"] ); -- Debug purpose
							--**^
	
							-- Item Background/Underlay/Shadow/Image
							local BITTitemBG = CreateControl(Turbine.UI.Control, BITTCtr, 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
							BITTitemBG:SetBackground(tonumber(ITL[i][itemName].B));
							BITTitemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
							local BITTitemU = CreateControl(Turbine.UI.Control, BITTCtr, 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
							if ITL[i][itemName].U ~= "0" then BITTitemU:SetBackground(tonumber(ITL[i][itemName].U)); end
							BITTitemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );

							local BITTitemS = CreateControl(Turbine.UI.Control, BITTCtr, 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
							if ITL[i][itemName].S ~= "0" then BITTitemS:SetBackground(tonumber(ITL[i][itemName].S)); end
							BITTitemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );

							local BITTitem = CreateControl(Turbine.UI.Control, BITTCtr, 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
							BITTitem:SetBackground(tonumber(ITL[i][itemName].I));
							BITTitem:SetBlendMode( Turbine.UI.BlendMode.Overlay );

							TITTListBox:AddItem( BITTCtr );
							TITTListBox:SetHeight( TITTPosY );

							-- Item Quantity
							BITTItemTot = item:GetQuantity();
							itemQTE = CreateQuantityLabel(BITTCtr, BITTItemTot)

							--Check the rest of bag for same item (in case user as multiple stack
							for iii = ii+1, size do
								local sameitem = backpack:GetItem( iii );
			
								if sameitem ~= nil then
									if sameitem:GetName() == k then	BITTItemTot = BITTItemTot + sameitem:GetQuantity();	end
								end
							end
							--
							itemQTE:SetText( BITTItemTot );
							--itemQTE:SetText( "9999" ); -- Debuf purpose

							-- Item name
							itemsLbl = CreateControl(Turbine.UI.Label, BITTCtr, 37, 2, TITTListBox:GetWidth() - 35, 35);
							itemsLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
							itemsLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
							itemsLbl:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
							itemsLbl:SetForeColor( Color["white"] );
							itemsLbl:SetText( itemName );

							--Put item name & quantity to red if quantity is < 10. Credit goes to Wicky71.
							if BITTItemTot < 10 then
								itemQTE:SetForeColor( Color["red"] );
								itemsLbl:SetForeColor( Color["red"] );
							end
		
							TITTPosY = TITTPosY + 35;
						end
						if bFound then break end
					end
				end
			end
		end
		if not bItemInListFoundInBag then --If no items in list was found in bag
			local lblName = Turbine.UI.Label();
			lblName:SetParent( _G.ToolTipWin );
			--lblName:SetFont ( 12 );
			lblName:SetText( L["BINI"] );
			lblName:SetPosition( 0, 0 );
			lblName:SetSize( Constants.LABEL_WIDTH_EXTRA_WIDE, Constants.LABEL_HEIGHT_ITEM );
			lblName:SetForeColor( Color["green"] );
			lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			--lblName:SetBackColor( Color["red"] ); -- debug purpose

			TITTListBox:AddItem( lblName );

			TITTPosY = TITTPosY + 35;
		end
	end

	TITTListBox:SetHeight( TITTPosY );

	if #ITL == 0 or not bItemInListFoundInBag then _G.ToolTipWin:SetSize( 300, TITTPosY - 7 );
	else _G.ToolTipWin:SetSize( 320, TITTPosY - 7 ); end

	PositionToolTipWindow();
end