-- Vault.lua

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "StoredItems")
import(AppDirD .. "ControlFactory")

-- Moved from functions.lua
function UpdateVault()
    AdjustIcon("VT");
end

function LoadPlayerVault()
    _G.PlayerVault = Turbine.PluginData.Load(
        Turbine.DataScope.Server, "TitanBarVault");
    if _G.PlayerVault == nil then _G.PlayerVault = {}; end
    if _G.PlayerVault[PN] == nil then _G.PlayerVault[PN] = {}; end
end

_G.LoadPlayerVault = LoadPlayerVault

-- Writes the saved vaults of all characters to disk
function WritePlayerVault()
    Turbine.PluginData.Save(Turbine.DataScope.Server, "TitanBarVault", _G.PlayerVault);
end

-- Takes over the items of the vault. The vault only has items after it was opened in this session.
function SavePlayerVault()
    if string.sub(PN, 1, 1) == "~" then return end; --Ignore session play

    _G.PlayerVault[PN] = SaveableItems(vaultpack, vaultpack:GetCount(), vaultpack:GetCapacity());
    WritePlayerVault();
end

function InitializeVault()
    _G.ControlData.VT.controls = _G.ControlData.VT.controls or {}
    local VT = _G.ControlData.VT.controls

    local colors = _G.ControlData.VT.colors

    if not VT["Ctr"] then
        CreateTitanBarControl(VT, colors.alpha, colors.red, colors.green, colors.blue)
        _G.ControlData.VT.ui.control = VT["Ctr"]

        VT["Icon"] = CreateControlIcon(VT["Ctr"], Constants.ICON_SIZE_MEDIUM_LARGE, Constants.ICON_SIZE_MEDIUM_LARGE,
            resources.Storage.Vault, 4)

        SetupControlInteraction({
            icon = VT["Icon"],
            controlTable = VT,
            windowImportPath = AppCtrD .. "VaultWindow",
            windowFunction = "frmVault",
            tooltipKey = "VT",
            customTooltipHandler = function() ShowStoredItemsToolTip(_G.PlayerVault[PN], L["VTnd"]) end
        })

        -- The data was loaded at startup (frmMain): PluginData can only be loaded
        -- synchronously while the plugin loads, and the control can be added later

        -- Register callbacks
        local vtData = _G.ControlData.VT
        vtData.callbacks = vtData.callbacks or {}
        local cb = AddCallback(vaultpack, "CountChanged",
            function(sender, args) SavePlayerVault(); end
        );
        table.insert(vtData.callbacks, { obj = vaultpack, evt = "CountChanged", func = cb })
    end
    UpdateVault()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
    _G.ControlRegistry.Register({
        id = "VT",
        menuText = "MVault",
        freePeopleOnly = true,
        icon = { only = true },
        settingsKey = "Vault",
        hasWhere = false,
        initFunc = InitializeVault
    })
end
