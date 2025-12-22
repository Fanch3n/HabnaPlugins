-- TrackItemsWindow.lua
-- Written by Habna


local player = Turbine.Gameplay.LocalPlayer.GetInstance();
local backpack = player:GetBackpack();
local size = backpack:GetSize();

function frmTrackItemsWindow()
	import(AppDirD .. "WindowFactory")

	-- Create window via factory
	_G.wTI = CreateWindow({
		text = L["BIIL"],
		width = 390,
		height = 498,
		left = BIWLeft,
		top = BIWTop,
		config = {
			settingsKey = "BagInfos",
			windowGlobalVar = "wTI",
			formGlobalVar = "frmTI",
			onPositionChanged = function(left, top)
				BIWLeft, BIWTop = left, top
			end,
			onClosing = function(sender, args)
				-- Nothing extra required
			end,
		}
	})

	_G.wTI.lblBackPack = Turbine.UI.Label();
	_G.wTI.lblBackPack:SetParent( _G.wTI );
	_G.wTI.lblBackPack:SetText( L["BIT"] );
	_G.wTI.lblBackPack:SetPosition( 0, 35);
	_G.wTI.lblBackPack:SetSize( _G.wTI:GetWidth() , 15 );
	_G.wTI.lblBackPack:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	_G.wTI.lblBackPack:SetForeColor( Color["green"] );

	-- **v search label & text box v**
	-- **v search label & text box v**
	_G.wTI.searchLabel = CreateTitleLabel(_G.wTI, L["VTSe"], 15, 60, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = _G.wTI.searchLabel:GetLeft() + _G.wTI.searchLabel:GetWidth()
	local searchWidth = _G.wTI:GetWidth() - 150
	local search = CreateSearchControl(_G.wTI, searchLeft, _G.wTI.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	_G.wTI.SearchTextBox = search.TextBox
	_G.wTI.DelIcon = search.DelIcon

	_G.wTI.SearchTextBox.TextChanged = function( sender, args )
		ApplySearch();
	end
	-- Needed to handle deleting text with the delete key:
	_G.wTI.SearchTextBox.KeyUp = function(sender, args)
		ApplySearch();
	end

	_G.wTI.SearchTextBox.FocusLost = function( sender, args )
	end

	local lbTop = 85
	local lb = CreateListBoxWithBorder(_G.wTI, 15, lbTop, _G.wTI:GetWidth() - 30, 365, Color["grey"])
	_G.wTI.ListBoxBorder = lb.Border
	_G.wTI.ListBox = lb.ListBox
	_G.wTI.ListBoxScrollBar = lb.ScrollBar
	_G.wTI.ListBox:SetMaxItemsPerLine( 1 );
	ConfigureListBox(_G.wTI.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])

	CheckForStackableItems();
end

function ApplySearch()
    local searchTerm = string.lower(_G.wTI.SearchTextBox:GetText());

    if (_G.wTI.searchText ~= searchTerm) then
        _G.wTI.searchText = searchTerm;
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
	local itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( _G.wTI.ListBox:GetWidth(), 35 );

	local lblmgs = CreateTitleLabel(itemCtl, L["BIMsg"], 0, 0, nil, Color["red"], nil, itemCtl:GetWidth(), itemCtl:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

	_G.wTI.ListBoxBorder:SetPosition( 15, 85 );
	_G.wTI.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	_G.wTI.ListBox:SetPosition( _G.wTI.ListBoxBorder:GetLeft() + 2, _G.wTI.ListBoxBorder:GetTop() + 2 );
	_G.wTI.ListBox:SetHeight( lblmgs:GetHeight() );
	_G.wTI.ListBoxScrollBar:SetVisible( false );

	_G.wTI.ListBox:AddItem( itemCtl );
	_G.wTI:SetHeight( itemCtl:GetHeight() + 85 );
end

function ShowStackableItems()
	_G.wTI.ListBox:ClearItems();

	for i = 1, size do
		if item[i] ~= "zEmpty" and item[i].Stackable then -- Only show stackable item
			if not _G.wTI.searchText or string.find(string.lower( item[i].Name ), _G.wTI.searchText, 1, true) then
				-- Use CreateItemRow for player item
				local row = CreateItemRow(_G.wTI.ListBox, _G.wTI.ListBox:GetWidth(), 35, true, item[i])
				itemCtl[i] = row.Container
				itemLbl[i] = row.ItemLabel
				itemLbl[i]:SetSize( _G.wTI.ListBox:GetWidth() - 48, 33 )
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

				_G.wTI.ListBox:AddItem( itemCtl[i] );
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

	_G.wTI.ListBoxBorder:SetPosition( 15, _G.wTI.searchLabel:GetTop() + _G.wTI.searchLabel:GetHeight() + 5 );
	_G.wTI.ListBoxBorder:SetHeight( 365 );
	_G.wTI.ListBox:SetPosition( _G.wTI.ListBoxBorder:GetLeft() + 2, _G.wTI.ListBoxBorder:GetTop() + 2 );
	_G.wTI.ListBox:SetHeight( _G.wTI.ListBoxBorder:GetHeight() - 4 );
	_G.wTI.ListBoxScrollBar:SetHeight( _G.wTI.ListBox:GetHeight() );
	_G.wTI:SetHeight( 498 );
end