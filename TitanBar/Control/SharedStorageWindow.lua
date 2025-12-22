-- SharedStorageWindow.lua
-- written by Habna


function frmSharedStorage()
	tsspack = sspack;
	import(AppDirD .. "WindowFactory")

	-- Create window via factory
	_G.wSS = CreateWindow({
		text = L["MStorage"],
		width = 390,
		height = 475,
		left = SSWLeft,
		top = SSWTop,
		config = {
			settingsKey = "SharedStorage",
			windowGlobalVar = "wSS",
			formGlobalVar = "frmSS",
			onPositionChanged = function(left, top)
				SSWLeft, SSWTop = left, top
			end,
			onClosing = function(sender, args)
				RemoveCallback( tsspack, "CountChanged" );
			end,
		}
	})


	-- **v search label & text box v**
	_G.wSS.searchLabel = CreateTitleLabel(_G.wSS, L["VTSe"], 15, 40, Turbine.UI.Lotro.Font.TrajanPro15, Color["gold"], 8, nil, 18, Turbine.UI.ContentAlignment.MiddleLeft)

	local searchLeft = _G.wSS.searchLabel:GetLeft() + _G.wSS.searchLabel:GetWidth()
	local searchWidth = _G.wSS:GetWidth() - 150
	local search = CreateSearchControl(_G.wSS, searchLeft, _G.wSS.searchLabel:GetTop(), searchWidth + 24, 18, Turbine.UI.Lotro.Font.Verdana14, resources)
	_G.wSS.SearchTextBox = search.TextBox
	_G.wSS.DelIcon = search.DelIcon

	_G.wSS.SearchTextBox.TextChanged = function( sender, args )
		_G.wSS.searchText = string.lower( _G.wSS.SearchTextBox:GetText() );
		if _G.wSS.searchText == "" then _G.wSS.searchText = nil; end
		SetSharedStoragePack();
	end

	_G.wSS.SearchTextBox.FocusLost = function( sender, args )
	end

	local lbTop = 80
	local lb = CreateListBoxWithBorder(_G.wSS, 15, lbTop, _G.wSS:GetWidth() - 30, Constants.LISTBOX_HEIGHT_MEDIUM, Color["grey"])
	_G.wSS.ListBoxBorder = lb.Border
	_G.wSS.ListBox = lb.ListBox
	_G.wSS.ListBoxScrollBar = lb.ScrollBar
	_G.wSS.ListBox:SetMaxItemsPerLine( 1 );
	ConfigureListBox(_G.wSS.ListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])
	
	sspackCount = 0;
	if PlayerSharedStorage ~= nil then for k, v in pairs(PlayerSharedStorage) do sspackCount = sspackCount + 1; end end

	if sspackCount == 0 then --Shared storage is empty
		_G.wSS.ListBoxBorder:SetVisible( false );
		_G.wSS.ListBox:SetVisible( false );
		_G.wSS.searchLabel:SetVisible( false );
		_G.wSS.SearchTextBox:SetVisible( false );
		_G.wSS.DelIcon:SetVisible( false );
		
		local lblmgs = GetLabel(L["SSnd"]);
		lblmgs:SetParent( _G.wSS );
		lblmgs:SetSize( _G.wSS:GetWidth()-32, 39 );
		
		_G.wSS:SetHeight( lblmgs:GetHeight() + 65 );
		_G.wSS.ListBoxScrollBar:SetVisible( false );
	else
		_G.wSS:SetHeight( 475 );
		SetSharedStoragePack();
	end

	AddCallback(tsspack, "CountChanged", function(sender, args) if frmSS then sspackCount = tsspack:GetCount(); SetSharedStoragePack(); end end);
end

function SetSharedStoragePack()
	_G.wSS.ListBox:ClearItems();
	itemCtl = {};

	for i = 1, sspackCount do
		local itemName = PlayerSharedStorage[tostring(i)].T;
		if not _G.wSS.searchText or string.find(string.lower( itemName ), _G.wSS.searchText, 1, true) then
				-- Use CreateItemRow helper for shared storage item
				local data = PlayerSharedStorage[tostring(i)]
				local row = CreateItemRow(_G.wSS.ListBox, _G.wSS.ListBox:GetWidth(), 35, false, data)
				itemCtl[i] = row.Container
				if row.ItemQuantity and data and data.N then row.ItemQuantity:SetText( tonumber(data.N) ) end
				row.ItemLabel:SetText( data.T )
				_G.wSS.ListBox:AddItem( itemCtl[i] )
		end
	end
end