-- SharedStorage.lua

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "SharedStorageToolTip")
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

    local sspackSize = sspack:GetCapacity();
    local sspackCount = sspack:GetCount();

    _G.PlayerSharedStorage = {};

    for ii = 1, sspackCount do
        local ind = tostring(ii);
        _G.PlayerSharedStorage[ind] = sspack:GetItem(ii);
        local iteminfo = _G.PlayerSharedStorage[ind]:GetItemInfo();

        _G.PlayerSharedStorage[ind].Q = tostring(iteminfo:GetQualityImageID());
        _G.PlayerSharedStorage[ind].B = tostring(iteminfo:GetBackgroundImageID());
        _G.PlayerSharedStorage[ind].U = tostring(iteminfo:GetUnderlayImageID());
        _G.PlayerSharedStorage[ind].S = tostring(iteminfo:GetShadowImageID());
        _G.PlayerSharedStorage[ind].I = tostring(iteminfo:GetIconImageID());
        _G.PlayerSharedStorage[ind].T = tostring(iteminfo:GetName());
        local tq = tostring(_G.PlayerSharedStorage[ind]:GetQuantity());
        if tq == "1" then tq = ""; end
        _G.PlayerSharedStorage[ind].N = tq;
        _G.PlayerSharedStorage[ind].Z = tostring(sspackSize);
    end

    Turbine.PluginData.Save(
        Turbine.DataScope.Server, "TitanBarSharedStorage", _G.PlayerSharedStorage
    );
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
            settingsSection = settings.SharedStorage,
            windowImportPath = AppCtrD .. "SharedStorageWindow",
            windowFunction = "frmSharedStorage",
            tooltipKey = "SS",
            customTooltipHandler = ShowSharedToolTip
        })

        -- Load data and register callbacks
        LoadPlayerSharedStorage()

        AddCallback(sspack, "CountChanged",
            function(sender, args) SavePlayerSharedStorage(); end
        );
    end

    UpdateSharedStorage()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
    _G.ControlRegistry.Register({
        id = "SS",
        settingsKey = "SharedStorage",
        hasWhere = false,
        defaults = { show = false, x = 0, y = 0 },
        initFunc = InitializeSharedStorage
    })
end
