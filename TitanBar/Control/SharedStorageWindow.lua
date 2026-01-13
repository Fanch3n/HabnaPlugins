-- SharedStorageWindow.lua
-- written by Habna


function frmSharedStorage()
	tsspack = sspack;
	import(AppDirD .. "WindowFactory")

	-- Create window via helper
	local wSS = CreateControlWindow(
		"SharedStorage", "SS",
		L["MStorage"], 390, 475,
		{
			onClosing = function(sender, args)
				RemoveCallback( tsspack, "CountChanged" );
			end
		}
	)

	wSS.searchLabel = CreateTitleLabel(wSS, L["VTSe"], 15, 40, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = wSS.searchLabel:GetLeft() + wSS.searchLabel:GetWidth()
	local searchWidth = wSS:GetWidth() - 150
	local search = CreateSearchControl(wSS, searchLeft, wSS.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	wSS.SearchTextBox = search.TextBox
	wSS.DelIcon = search.DelIcon

	wSS.SearchTextBox.TextChanged = function(sender, args)
		wSS.searchText = string.lower(wSS.SearchTextBox:GetText());
		if wSS.searchText == "" then wSS.searchText = nil; end
		SetSharedStoragePack();
	end

	local lbTop = 80
	local lb = CreateListBoxWithBorder(wSS, 15, lbTop, wSS:GetWidth() - 30, Constants.LISTBOX_HEIGHT_MEDIUM, Color["grey"])
	wSS.ListBoxBorder = lb.Border
	wSS.ListBox = lb.ListBox
	wSS.ListBoxScrollBar = lb.ScrollBar
	wSS.ListBox:SetMaxItemsPerLine(1);
	ConfigureListBox(wSS.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])
	
	sspackCount = 0;
	if PlayerSharedStorage ~= nil then for k, v in pairs(PlayerSharedStorage) do sspackCount = sspackCount + 1; end end

	if sspackCount == 0 then --Shared storage is empty
		wSS.ListBoxBorder:SetVisible( false );
		wSS.ListBox:SetVisible( false );
		wSS.searchLabel:SetVisible( false );
		wSS.SearchTextBox:SetVisible( false );
		wSS.DelIcon:SetVisible( false );
		
		local lblmgs = GetLabel(L["SSnd"]);
		lblmgs:SetParent( wSS );
		lblmgs:SetSize( wSS:GetWidth()-32, 39 );
		
		wSS:SetHeight( lblmgs:GetHeight() + 65 );
		wSS.ListBoxScrollBar:SetVisible( false );
	else
		wSS:SetHeight( 475 );
		SetSharedStoragePack();
	end

	AddCallback(tsspack, "CountChanged", function(sender, args) local window = _G.ControlData.SS.windowInstance; if window then sspackCount = tsspack:GetCount(); SetSharedStoragePack(); end end);
end

function SetSharedStoragePack()
	local wSS = _G.ControlData.SS.windowInstance
	wSS.ListBox:ClearItems();
	itemCtl = {};

	for i = 1, sspackCount do
		local itemName = PlayerSharedStorage[tostring(i)].T;
		if not wSS.searchText or string.find(string.lower( itemName ), wSS.searchText, 1, true) then
				-- Use CreateItemRow helper for shared storage item
				local data = PlayerSharedStorage[tostring(i)]
				local row = CreateItemRow(wSS.ListBox, wSS.ListBox:GetWidth(), 35, false, data)
				itemCtl[i] = row.Container
				if row.ItemQuantity and data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
				row.ItemLabel:SetText( data.T )
				wSS.ListBox:AddItem( itemCtl[i] )
		end
	end
end