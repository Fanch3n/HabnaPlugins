-- TrackItemsWindow.lua
-- Written by Habna


local player = Turbine.Gameplay.LocalPlayer.GetInstance();
local backpack = player:GetBackpack();
local size = backpack:GetSize();

function frmTrackItemsWindow()
	import(AppDirD .. "WindowFactory")

	-- Create window via helper
	local wTI = CreateControlWindow(
		"BagInfos", "TI",
		L["BIIL"], 390, 498
	)

	wTI.lblBackPack = Turbine.UI.Label();
	wTI.lblBackPack:SetParent( wTI );
	wTI.lblBackPack:SetText( L["BIT"] );
	wTI.lblBackPack:SetPosition( 0, 35);
	wTI.lblBackPack:SetSize( wTI:GetWidth() , 15 );
	wTI.lblBackPack:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	wTI.lblBackPack:SetForeColor( Color["green"] );

	wTI.searchLabel = CreateTitleLabel(wTI, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = wTI.searchLabel:GetLeft() + wTI.searchLabel:GetWidth()
	local searchWidth = wTI:GetWidth() - 150
	local search = CreateSearchControl(wTI, searchLeft, wTI.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	wTI.SearchTextBox = search.TextBox
	wTI.DelIcon = search.DelIcon

	wTI.SearchTextBox.TextChanged = function(sender, args)
		ApplySearch();
	end
	-- Needed to handle deleting text with the delete key:
	wTI.SearchTextBox.KeyUp = function(sender, args)
		ApplySearch();
	end

	local lbTop = 85
	local lb = CreateListBoxWithBorder(wTI, 15, lbTop, wTI:GetWidth() - 30, Constants.LISTBOX_HEIGHT_STANDARD, Color["grey"])
	wTI.ListBoxBorder = lb.Border
	wTI.ListBox = lb.ListBox
	wTI.ListBoxScrollBar = lb.ScrollBar
	wTI.ListBox:SetMaxItemsPerLine(1);
	ConfigureListBox(wTI.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])

	CheckForStackableItems();
end

function ApplySearch()
    local wTI = _G.ControlData.TI.windowInstance
    local searchTerm = string.lower(wTI.SearchTextBox:GetText());

    if (wTI.searchText ~= searchTerm) then
        wTI.searchText = searchTerm;
        ShowStackableItems();
    end
end

function CheckForStackableItems()
	item = {};
	itemCtl = {};
	itemLbl = {};
	bFound = false;

	for i = 1, size do
		item[i] = backpack:GetItem( i );
		if item[i] ~= nil then
			local iteminfo = item[i]:GetItemInfo();
			item[i].Name = iteminfo:GetName();
			if iteminfo:GetMaxStackSize() > 1 then
				bFound = true
				item[i].Stackable = true;
			else
				item[i].Stackable = false;
			end
		else
			item[i] = "zEmpty";
		end
	end
	
	if bFound then ShowStackableItems();
	else SetEmptyTrackList(); end
end

function SetEmptyTrackList()
	local wTI = _G.ControlData.TI.windowInstance
	local itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( wTI.ListBox:GetWidth(), 35 );

	local lblmgs = CreateTitleLabel(itemCtl, L["BIMsg"], 0, 0, nil, Color["red"], nil, itemCtl:GetWidth(), itemCtl:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

	wTI.ListBoxBorder:SetPosition( 15, 85 );
	wTI.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	wTI.ListBox:SetPosition( wTI.ListBoxBorder:GetLeft() + 2, wTI.ListBoxBorder:GetTop() + 2 );
	wTI.ListBox:SetHeight( lblmgs:GetHeight() );
	wTI.ListBoxScrollBar:SetVisible( false );

	wTI.ListBox:AddItem( itemCtl );
	wTI:SetHeight( itemCtl:GetHeight() + 85 );
end

function ShowStackableItems()
	local wTI = _G.ControlData.TI.windowInstance
	wTI.ListBox:ClearItems();

	for i = 1, size do
		if item[i] ~= "zEmpty" and item[i].Stackable then -- Only show stackable item
			if not wTI.searchText or string.find(string.lower( item[i].Name ), wTI.searchText, 1, true) then
				-- Use CreateItemRow for player item
				local row = CreateItemRow(wTI.ListBox, wTI.ListBox:GetWidth(), 35, true, item[i])
				itemCtl[i] = row.Container
				itemLbl[i] = row.ItemLabel
				itemLbl[i]:SetSize( wTI.ListBox:GetWidth() - 48, 33 )
				itemLbl[i]:SetPosition( 36, 3 )
				itemLbl[i]:SetText( item[i].Name )
				itemLbl[i].Sel = false

				itemLbl[i].MouseClick = function( sender, args )
					if ( args.Button == Turbine.UI.MouseButton.Left ) then
						if not itemLbl[i].Sel then
							itemLbl[i].Sel = true;
							itemLbl[i]:SetForeColor( Color["green"] );

							local tITL = {};
							local iteminfo = item[i]:GetItemInfo();
							tITL[item[i].Name] = {};
							tITL[item[i].Name].Q = tostring(iteminfo:GetQualityImageID());
							tITL[item[i].Name].B = tostring(iteminfo:GetBackgroundImageID());
							tITL[item[i].Name].U = tostring(iteminfo:GetUnderlayImageID());
							tITL[item[i].Name].S = tostring(iteminfo:GetShadowImageID());
							tITL[item[i].Name].I = tostring(iteminfo:GetIconImageID());
							table.insert( ITL, tITL );
                            
							SavePlayerItemTrackingList(ITL);

							--Check all listbox for identical item name
							for ii = 1, size do
								if item[ii] ~= "zEmpty" and item[ii].Stackable then
									if ii ~= i then
										if item[ii].Name == itemLbl[i]:GetText() then
											itemLbl[ii]:SetForeColor( Color["green"] );
											itemLbl[ii]:SetBackColor( Color["darkgrey"] );
											itemLbl[ii].Sel = true;
										end
									end
								end
							end
						else
							itemLbl[i].Sel = false;
							itemLbl[i]:SetForeColor( Color["white"] );

							local iFoundAt = 0;
							for ii = 1, #ITL do
								for k, v in pairs(ITL[ii]) do
									if k == itemLbl[i]:GetText() then iFoundAt = ii; break end
								end
							end
                        
							table.remove( ITL, iFoundAt );
							SavePlayerItemTrackingList(ITL)

							--Check all listbox for identical item name
							for ii = 1, size do
								if item[ii] ~= "zEmpty" and item[ii].Stackable then
									if ii ~= i then
										if item[ii].Name == itemLbl[i]:GetText() then
											itemLbl[ii]:SetForeColor( Color["white"] );
											itemLbl[ii]:SetBackColor( Color["black"] );
											itemLbl[ii].Sel = false;
										end
									end
								end
							end
						end
					end
				end

				itemLbl[i].MouseHover = function(sender, args)
					itemLbl[i]:SetBackColor( Color["lightgrey"] );
				end

				itemLbl[i].MouseLeave = function(sender, args)
					if itemLbl[i].Sel then itemLbl[i]:SetBackColor( Color["darkgrey"] ); else itemLbl[i]:SetBackColor( Color["black"] ); end
				end

				wTI.ListBox:AddItem( itemCtl[i] );
			end
		end
	end
	
	for i = 1, #ITL do
		for k, v in pairs(ITL[i]) do
			for ii = 1, size do
				if item[ii] ~= "zEmpty" and item[ii].Stackable then
					if k == itemLbl[ii]:GetText() then
						itemLbl[ii]:SetForeColor( Color["green"] );
						itemLbl[ii]:SetBackColor( Color["darkgrey"] );
						itemLbl[ii].Sel = true;
					end
				end
			end
		end
	end

	wTI.ListBoxBorder:SetPosition( 15, wTI.searchLabel:GetTop() + wTI.searchLabel:GetHeight() + 5 );
	wTI.ListBoxBorder:SetHeight( Constants.LISTBOX_HEIGHT_STANDARD );
	wTI.ListBox:SetPosition( wTI.ListBoxBorder:GetLeft() + 2, wTI.ListBoxBorder:GetTop() + 2 );
	wTI.ListBox:SetHeight( wTI.ListBoxBorder:GetHeight() - 4 );
	wTI.ListBoxScrollBar:SetHeight( wTI.ListBox:GetHeight() );
	wTI:SetHeight( 498 );
end