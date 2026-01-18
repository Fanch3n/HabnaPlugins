-- TrackItemsWindow.lua
-- Written by Habna


local player = Turbine.Gameplay.LocalPlayer.GetInstance();
local backpack = player:GetBackpack();
local size = backpack:GetSize();

function frmTrackItemsWindow()
	import(AppDirD .. "WindowFactory")

	-- Initialize UI state table
	_G.ControlData.TI = _G.ControlData.TI or {}
	_G.ControlData.TI.ui = _G.ControlData.TI.ui or {}
	local ui = _G.ControlData.TI.ui
	ui.itemState = {} -- Track per-item selection state

	-- Create window via helper
	local wTI = CreateControlWindow(
		"BagInfos", "TI",
		L["BIIL"], 390, 498,
		{
			onClosing = function(sender, args)
				_G.ControlData.TI.ui = { control = nil, optCheckbox = nil }
			end
		}
	)
	ui.window = wTI

	ui.lblBackPack = Turbine.UI.Label();
	ui.lblBackPack:SetParent( wTI );
	ui.lblBackPack:SetText( L["BIT"] );
	ui.lblBackPack:SetPosition( 0, 35);
	ui.lblBackPack:SetSize( wTI:GetWidth() , 15 );
	ui.lblBackPack:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	ui.lblBackPack:SetForeColor( Color["green"] );

	ui.searchLabel = CreateTitleLabel(wTI, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = ui.searchLabel:GetLeft() + ui.searchLabel:GetWidth()
	local searchWidth = wTI:GetWidth() - 150
	local search = CreateSearchControl(wTI, searchLeft, ui.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	ui.SearchTextBox = search.TextBox
	ui.DelIcon = search.DelIcon

	ui.SearchTextBox.TextChanged = function(sender, args)
		ApplySearch();
	end
	-- Needed to handle deleting text with the delete key:
	ui.SearchTextBox.KeyUp = function(sender, args)
		ApplySearch();
	end

	local lbTop = 85
	local lb = CreateListBoxWithBorder(wTI, 15, lbTop, wTI:GetWidth() - 30, Constants.LISTBOX_HEIGHT_STANDARD, Color["grey"])
	ui.ListBoxBorder = lb.Border
	ui.ListBox = lb.ListBox
	ui.ListBoxScrollBar = lb.ScrollBar
	ui.ListBox:SetMaxColumns(1);
	ConfigureListBox(ui.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])

	CheckForStackableItems();
end

function ApplySearch()
    local ui = _G.ControlData.TI and _G.ControlData.TI.ui
    if not ui then return end
    local searchTerm = string.lower(ui.SearchTextBox:GetText());

    if (ui.searchText ~= searchTerm) then
        ui.searchText = searchTerm;
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
	local ui = _G.ControlData.TI and _G.ControlData.TI.ui
	if not ui then return end
	local itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( ui.ListBox:GetWidth(), 35 );

	local lblmgs = CreateTitleLabel(itemCtl, L["BIMsg"], 0, 0, nil, Color["red"], nil, itemCtl:GetWidth(), itemCtl:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

	ui.ListBoxBorder:SetPosition( 15, 85 );
	ui.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	ui.ListBox:SetPosition( ui.ListBoxBorder:GetLeft() + 2, ui.ListBoxBorder:GetTop() + 2 );
	ui.ListBox:SetHeight( lblmgs:GetHeight() );
	ui.ListBoxScrollBar:SetVisible( false );

	ui.ListBox:AddItem( itemCtl );
	ui.window:SetHeight( itemCtl:GetHeight() + 85 );
end

function ShowStackableItems()
	local ui = _G.ControlData.TI and _G.ControlData.TI.ui
	if not ui then return end
	ui.ListBox:ClearItems();
	ui.itemState = {}

	for i = 1, size do
		if item[i] ~= "zEmpty" and item[i].Stackable then -- Only show stackable item
			if not ui.searchText or string.find(string.lower( item[i].Name ), ui.searchText, 1, true) then
				-- Use CreateItemRow for player item
				local row = CreateItemRow(nil, ui.ListBox:GetWidth(), 35, true, item[i])
				itemCtl[i] = row.Container
				itemLbl[i] = row.ItemLabel
				itemLbl[i]:SetSize( ui.ListBox:GetWidth() - 48, 33 )
				itemLbl[i]:SetPosition( 36, 3 )
				itemLbl[i]:SetText( item[i].Name )
				ui.itemState[i] = false

				itemLbl[i].MouseClick = function( sender, args )
					if ( args.Button == Turbine.UI.MouseButton.Left ) then
						if not ui.itemState[i] then
							ui.itemState[i] = true;
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
											ui.itemState[ii] = true;
										end
									end
								end
							end
						else
							ui.itemState[i] = false;
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
											ui.itemState[ii] = false;
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
					if ui.itemState[i] then itemLbl[i]:SetBackColor( Color["darkgrey"] ); else itemLbl[i]:SetBackColor( Color["black"] ); end
				end

				ui.ListBox:AddItem( itemCtl[i] );
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
						ui.itemState[ii] = true;
					end
				end
			end
		end
	end

	ui.ListBoxBorder:SetPosition( 15, ui.searchLabel:GetTop() + ui.searchLabel:GetHeight() + 5 );
	ui.ListBoxBorder:SetHeight( Constants.LISTBOX_HEIGHT_STANDARD );
	ui.ListBox:SetPosition( ui.ListBoxBorder:GetLeft() + 2, ui.ListBoxBorder:GetTop() + 2 );
	ui.ListBox:SetHeight( ui.ListBoxBorder:GetHeight() - 4 );
	ui.ListBoxScrollBar:SetHeight( ui.ListBox:GetHeight() );
	ui.window:SetHeight( 498 );
end