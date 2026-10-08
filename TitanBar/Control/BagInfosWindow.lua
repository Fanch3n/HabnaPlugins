-- BagInfosWindow.lua
-- written by Habna

-- Options of the BagInfos control, below the list of items
local function BagSlotOptions(window, top)
	local biData = _G.ControlData.BI
	if biData.used == nil then biData.used = true end
	if biData.max == nil then biData.max = true end

	local usedSlots = CreateAutoSizedCheckBox(window, L["BIUsed"], 30, top + 6, biData.used);
	usedSlots.CheckedChanged = function(sender, args)
		biData.used = usedSlots:IsChecked();
		SaveSettings();
		UpdateBackpackInfos();
	end

	local maxSlots = CreateAutoSizedCheckBox(window, L["BIMax"], 30, usedSlots:GetTop() + usedSlots:GetHeight(), biData.max);
	maxSlots.CheckedChanged = function(sender, args)
		biData.max = maxSlots:IsChecked();
		SaveSettings();
		UpdateBackpackInfos();
	end

	return maxSlots:GetTop() + maxSlots:GetHeight()
end

-- The bags of all characters; the current character's items come from the backpack itself (see StoredItems.lua)
function frmBagInfos()
	CreateStoredItemsWindow({
		id = "BI",
		settingsKey = "BagInfos",
		title = L["BIh"],
		width = 390,
		height = 560,
		items = function() return PlayerBags end,
		perCharacter = true,
		write = SavePlayerBags,
		deletedMessage = "BID",
		live = backpack,
		listHeight = Constants.LISTBOX_HEIGHT_LARGE,
		extras = BagSlotOptions,
		-- ItemRemoved fires before the backpack was updated (Turbine API issue)
		watch = {
			{ object = backpack, event = "ItemAdded" },
			{ object = backpack, event = "ItemRemoved", delayed = true },
		},
		onChange = SavePlayerBags,
	})
end
