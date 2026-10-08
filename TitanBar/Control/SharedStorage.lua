-- SharedStorage.lua

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "StoredItems")
import(AppDirD .. "ControlFactory")

function UpdateSharedStorage()
    AdjustIcon("SS");
end

function LoadPlayerSharedStorage()
    _G.PlayerSharedStorage = Turbine.PluginData.Load(Turbine.DataScope.Server, "TitanBarSharedStorage");
    if _G.PlayerSharedStorage == nil then _G.PlayerSharedStorage = {}; end
end

_G.LoadPlayerSharedStorage = LoadPlayerSharedStorage

function SavePlayerSharedStorage()
    if string.sub(PN, 1, 1) == "~" then return end;   --Ignore session play

    _G.PlayerSharedStorage = SaveableItems(sspack, sspack:GetCount(), sspack:GetCapacity());
    Turbine.PluginData.Save(Turbine.DataScope.Server, "TitanBarSharedStorage", _G.PlayerSharedStorage);
end

function InitializeSharedStorage()
    _G.ControlData.SS.controls = _G.ControlData.SS.controls or {}
    local SS = _G.ControlData.SS.controls

    local colors = _G.ControlData.SS.colors

    if not SS["Ctr"] then
        CreateTitanBarControl(SS, colors.alpha, colors.red, colors.green, colors.blue)
        _G.ControlData.SS.ui.control = SS["Ctr"]

        SS["Icon"] = CreateControlIcon(SS["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE,
            resources.Storage.Shared, Turbine.UI.BlendMode.AlphaBlend)

        SetupControlInteraction({
            icon = SS["Icon"],
            controlTable = SS,
            windowImportPath = AppCtrD .. "SharedStorageWindow",
            windowFunction = "frmSharedStorage",
            tooltipKey = "SS",
            customTooltipHandler = function() ShowStoredItemsToolTip(_G.PlayerSharedStorage, L["SSnd"]) end
        })

        -- Register callbacks. The data was loaded at startup (frmMain): PluginData can only be
        -- loaded synchronously while the plugin loads, and the control can be added later
        local ssData = _G.ControlData.SS
        ssData.callbacks = ssData.callbacks or {}
        local cb = AddCallback(sspack, "CountChanged",
            function(sender, args) SavePlayerSharedStorage(); end
        );
        table.insert(ssData.callbacks, { obj = sspack, evt = "CountChanged", func = cb })
    end

    UpdateSharedStorage()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
    _G.ControlRegistry.Register({
        id = "SS",
        menuText = "MStorage",
        freePeopleOnly = true,
        icon = { only = true },
        settingsKey = "SharedStorage",
        hasWhere = false,
        initFunc = InitializeSharedStorage
    })
end
