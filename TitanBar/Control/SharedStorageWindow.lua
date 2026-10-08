-- SharedStorageWindow.lua

-- The saved shared storage (see StoredItems.lua)
function frmSharedStorage()
	CreateStoredItemsWindow({
		id = "SS",
		settingsKey = "SharedStorage",
		title = L["MStorage"],
		width = 390,
		height = 475,
		items = function() return PlayerSharedStorage end,
		emptyMessage = "SSnd",
		searchTop = 40,
		listTop = 80,
		listHeight = Constants.LISTBOX_HEIGHT_MEDIUM,
		watch = { { object = sspack, event = "CountChanged" } },
	})
end
