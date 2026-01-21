-- Vault.lua

import(AppDirD .. "UIHelpers")
import(AppCtrD .. "VaultToolTip")
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

function SavePlayerVault()
    if string.sub(PN, 1, 1) == "~" then return end; --Ignore session play

    local vaultpackSize = vaultpack:GetCapacity();
    local vaultpackCount = vaultpack:GetCount();

    _G.PlayerVault[PN] = {};

    for ii = 1, vaultpackCount do
        local ind = tostring(ii);
        _G.PlayerVault[PN][ind] = vaultpack:GetItem(ii);
        local iteminfo = _G.PlayerVault[PN][ind]:GetItemInfo();

        _G.PlayerVault[PN][ind].Q = tostring(iteminfo:GetQualityImageID());
        _G.PlayerVault[PN][ind].B = tostring(iteminfo:GetBackgroundImageID());
        _G.PlayerVault[PN][ind].U = tostring(iteminfo:GetUnderlayImageID());
        _G.PlayerVault[PN][ind].S = tostring(iteminfo:GetShadowImageID());
        _G.PlayerVault[PN][ind].I = tostring(iteminfo:GetIconImageID());
        _G.PlayerVault[PN][ind].T = tostring(iteminfo:GetName());
        local tq = tostring(_G.PlayerVault[PN][ind]:GetQuantity());
        if tq == "1" then tq = ""; end
        _G.PlayerVault[PN][ind].N = tq;
        _G.PlayerVault[PN][ind].Z = tostring(vaultpackSize);
    end

    Turbine.PluginData.Save(
        Turbine.DataScope.Server, "TitanBarVault", _G.PlayerVault);
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
            settingsSection = settings.Vault,
            windowImportPath = AppCtrD .. "VaultWindow",
            windowFunction = "frmVault",
            tooltipKey = "VT",
            customTooltipHandler = ShowVaultToolTip
        })

        -- Load data
        LoadPlayerVault()

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
        settingsKey = "Vault",
        hasWhere = false,
        defaults = { show = false, x = 0, y = 0 },
        initFunc = InitializeVault
    })
end
