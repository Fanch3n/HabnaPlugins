-- SharedStorageWindow.lua
-- written by Habna


function frmSharedStorage()
	tsspack = sspack;
	import(AppDirD .. "WindowFactory")

	-- Initialize UI state table
	_G.ControlData.SS = _G.ControlData.SS or {}
	_G.ControlData.SS.ui = _G.ControlData.SS.ui or {}
	local ui = _G.ControlData.SS.ui

	-- Create window via helper
	local wSS = CreateControlWindow(
		"SharedStorage", "SS",
		L["MStorage"], 390, 475,
		{
			onClosing = function(sender, args)
				RemoveCallback( tsspack, "CountChanged" );
				_G.ControlData.SS.ui = { control = nil, optCheckbox = nil }
			end
		}
	)
	ui.window = wSS

	ui.searchLabel = CreateTitleLabel(wSS, L["VTSe"], 15, 40, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = ui.searchLabel:GetLeft() + ui.searchLabel:GetWidth()
	local searchWidth = wSS:GetWidth() - 150
	local search = CreateSearchControl(wSS, searchLeft, ui.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	ui.SearchTextBox = search.TextBox
	ui.DelIcon = search.DelIcon

	ui.SearchTextBox.TextChanged = function(sender, args)
		ui.searchText = string.lower(ui.SearchTextBox:GetText());
		if ui.searchText == "" then ui.searchText = nil; end
		SetSharedStoragePack();
	end

	local lbTop = 80
	local lb = CreateListBoxWithBorder(wSS, 15, lbTop, wSS:GetWidth() - 30, Constants.LISTBOX_HEIGHT_MEDIUM, Color["grey"])
	ui.ListBoxBorder = lb.Border
	ui.ListBox = lb.ListBox
	ui.ListBoxScrollBar = lb.ScrollBar
	ui.ListBox:SetMaxItemsPerLine(1);
	ConfigureListBox(ui.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])
	
	sspackCount = 0;
	if PlayerSharedStorage ~= nil then for k, v in pairs(PlayerSharedStorage) do sspackCount = sspackCount + 1; end end

	if sspackCount == 0 then --Shared storage is empty
		ui.ListBoxBorder:SetVisible( false );
		ui.ListBox:SetVisible( false );
		ui.searchLabel:SetVisible( false );
		ui.SearchTextBox:SetVisible( false );
		ui.DelIcon:SetVisible( false );
		
		local lblmgs = GetLabel(L["SSnd"]);
		lblmgs:SetParent( wSS );
		lblmgs:SetSize( wSS:GetWidth()-32, 39 );
		
		ui.window:SetHeight( lblmgs:GetHeight() + 65 );
		ui.ListBoxScrollBar:SetVisible( false );
	else
		ui.window:SetHeight( 475 );
		SetSharedStoragePack();
	end

	AddCallback(tsspack, "CountChanged", function(sender, args) local ui = _G.ControlData.SS and _G.ControlData.SS.ui; if ui then sspackCount = tsspack:GetCount(); SetSharedStoragePack(); end end);
end

function SetSharedStoragePack()
	local ui = _G.ControlData.SS and _G.ControlData.SS.ui
	if not ui then return end
	ui.ListBox:ClearItems();
	itemCtl = {};

	for i = 1, sspackCount do
		local itemName = PlayerSharedStorage[tostring(i)].T;
		if not ui.searchText or string.find(string.lower( itemName ), ui.searchText, 1, true) then
				-- Use CreateItemRow helper for shared storage item
				local data = PlayerSharedStorage[tostring(i)]
				local row = CreateItemRow(nil, ui.ListBox:GetWidth(), 35, false, data)
				itemCtl[i] = row.Container
				if row.ItemQuantity and data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
				row.ItemLabel:SetText( data.T )
				ui.ListBox:AddItem( itemCtl[i] )
		end
	end
    ui.ListBox:SetMaxItemsPerLine(2)
    ui.ListBox:SetMaxItemsPerLine(1)
end