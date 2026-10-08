-- VaultWindow.lua
-- written by Habna

-- The saved vaults of all characters (see StoredItems.lua)
function frmVault()
	CreateStoredItemsWindow({
		id = "VT",
		settingsKey = "Vault",
		title = L["MVault"],
		width = 390,
		height = 520,
		items = function() return PlayerVault end,
		perCharacter = true,
		write = WritePlayerVault,
		deletedMessage = "VTID",
		emptyMessage = "VTnd",
		listHeight = Constants.LISTBOX_HEIGHT_STANDARD,
		watch = { { object = vaultpack, event = "CountChanged" } },
	})
end
