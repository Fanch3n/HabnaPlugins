-- functionsMenu.lua
-- Functions for the context menu

-- Generic Toggle Function to replace individual handlers
function ToggleControl(id)
	local controlData = _G.ControlData[id]
	if not controlData then return end

	-- Toggle state
	controlData.show = not controlData.show

	-- Update Settings
	local regData = _G.ControlRegistry.Get(id)
	if regData and regData.settingsKey then
		if not settings[regData.settingsKey] then settings[regData.settingsKey] = {} end
		settings[regData.settingsKey].V = controlData.show
		-- Preserving 'Where' if it exists (some existing functions do this)
		if controlData.where ~= nil then
			settings[regData.settingsKey].W = string.format("%.0f", controlData.where or Constants.Position.NONE)
		end
	end

	SaveSettings(false)

	-- Handle UI Update
	if controlData.show then
		ImportCtr(id)

		-- Set Background Color if control exists
		if controlData.controls and controlData.controls["Ctr"] and controlData.colors then
			local colors = controlData.colors
			controlData.controls["Ctr"]:SetBackColor(Turbine.UI.Color(colors.alpha, colors.red, colors.green, colors.blue))
			controlData.controls["Ctr"]:SetVisible(true)
		end

		-- Special case for Equipment callbacks (removed from legacy functions but logic was complex)
		-- Since Equipment Infos logic is quite specific (callbacks added in Toggle), we might need to handle EI/DI separately or move logic to Initialize
	else
		-- Cleanup Callbacks
		if controlData.callbacks then
			for _, cb in ipairs(controlData.callbacks) do
				if RemoveCallback then RemoveCallback(cb.obj, cb.evt, cb.func) end
			end
			controlData.callbacks = {}
		end

		-- Close Window
		local window = controlData.ui and controlData.ui.window
		if window then window:Close() end

		-- Hide Control
		if controlData.controls and controlData.controls["Ctr"] then
			controlData.controls["Ctr"]:SetVisible(false)
		end
	end

	-- Update Option Panel Checkbox
	-- Access the specific menu item stored in the control data
	local menuItem = controlData.ui and controlData.ui.menuItem
	if menuItem and menuItem.SetChecked then
		menuItem:SetChecked(controlData.show)
	end
end

function ShowHideEquipInfos()
	local controlData = _G.ControlData.EI
	controlData.show = not controlData.show
	if not settings.EquipInfos then settings.EquipInfos = {} end
	settings.EquipInfos.V = controlData.show
	SaveSettings(false);

	if controlData.show then
		GetEquipmentInfos();

		-- Use standardized callback management
		controlData.callbacks = controlData.callbacks or {}

		-- Helper to add and track callback
		local function AddAndTrack(obj, evt, func)
			local cb = AddCallback(obj, evt, func)
			table.insert(controlData.callbacks, { obj = obj, evt = evt, func = cb })
		end

		-- Callback 1: ItemEquipped
		AddAndTrack(PlayerEquipment, "ItemEquipped", function(sender, args)
			-- We call GetEquipmentInfos anyway to refresh data
			GetEquipmentInfos();
			if _G.ControlData.EI.show then UpdateEquipsInfos(); end
		end);

		-- Callback 2: ItemUnequipped
		AddAndTrack(PlayerEquipment, "ItemUnequipped", function(sender, args)
			ItemUnEquippedTimer:SetWantsUpdates(true);
		end);

		ImportCtr("EI");
		local colors = _G.ControlData.EI.colors
		if _G.ControlData.EI.controls and _G.ControlData.EI.controls["Ctr"] then
			_G.ControlData.EI.controls["Ctr"]:SetBackColor(Turbine.UI.Color(colors.alpha, colors.red, colors.green, colors
			.blue));
			_G.ControlData.EI.controls["Ctr"]:SetVisible(true)
		end
	else
		-- Remove callbacks
		if controlData.callbacks then
			for _, cb in ipairs(controlData.callbacks) do
				if RemoveCallback then RemoveCallback(cb.obj, cb.evt, cb.func) end
			end
			controlData.callbacks = {}
		end
		local window = _G.ControlData.EI.ui and _G.ControlData.EI.ui.window; if window then window:Close(); end

		if _G.ControlData.EI.controls and _G.ControlData.EI.controls["Ctr"] then
			_G.ControlData.EI.controls["Ctr"]:SetVisible(false)
		end
	end

	-- Update Menu Item
	if controlData.ui and controlData.ui.menuItem then
		controlData.ui.menuItem:SetChecked(controlData.show)
	end
end

function ShowHideDurabilityInfos()
	local controlData = _G.ControlData.DI
	controlData.show = not controlData.show
	if not settings.DurabilityInfos then settings.DurabilityInfos = {} end
	settings.DurabilityInfos.V = controlData.show
	SaveSettings(false);

	if controlData.show then
		GetEquipmentInfos();

		-- Use standardized callback management
		controlData.callbacks = controlData.callbacks or {}

		-- Helper to add and track callback
		local function AddAndTrack(obj, evt, func)
			local cb = AddCallback(obj, evt, func)
			table.insert(controlData.callbacks, { obj = obj, evt = evt, func = cb })
		end

		-- Callback 1: ItemEquipped
		AddAndTrack(PlayerEquipment, "ItemEquipped", function(sender, args)
			GetEquipmentInfos();
			if _G.ControlData.DI.show then UpdateDurabilityInfos(); end
		end);

		-- Callback 2: ItemUnequipped
		AddAndTrack(PlayerEquipment, "ItemUnequipped", function(sender, args)
			ItemUnEquippedTimer:SetWantsUpdates(true);
		end);

		ImportCtr("DI");
		local colors = _G.ControlData.DI.colors
		if _G.ControlData.DI.controls and _G.ControlData.DI.controls["Ctr"] then
			_G.ControlData.DI.controls["Ctr"]:SetBackColor(Turbine.UI.Color(colors.alpha, colors.red, colors.green, colors
			.blue));
			_G.ControlData.DI.controls["Ctr"]:SetVisible(true)
		end
	else
		-- Remove callbacks
		if controlData.callbacks then
			for _, cb in ipairs(controlData.callbacks) do
				if RemoveCallback then RemoveCallback(cb.obj, cb.evt, cb.func) end
			end
			controlData.callbacks = {}
		end

		local window = _G.ControlData.DI.ui and _G.ControlData.DI.ui.window; if window then window:Close(); end
		if _G.ControlData.DI.controls and _G.ControlData.DI.controls["Ctr"] then
			_G.ControlData.DI.controls["Ctr"]:SetVisible(false)
		end
	end

	-- Update Menu Item
	if controlData.ui and controlData.ui.menuItem then
		controlData.ui.menuItem:SetChecked(controlData.show)
	end
end

function LoadPlayerProfile()
	PProfile = Turbine.PluginData.Load(Turbine.DataScope.Account, "TitanBarPlayerProfile");
	if PProfile == nil then PProfile = {}; end
end

function SavePlayerProfile()
	-- The table key is saved with "," in DE & FR clients. Ex. [1,000000]. This causes a parse error.
	-- If you change [1,000000] to [1.000000] error is not there any more. [1] would be easier! Why all those zeroes!
	-- So LOTRO saves the table key in the client language, but lua is unable to read it since "," is a special character.
	-- LOTRO just has to save the key in English and the value in the client language.

	-- So I'm converting the key [1,000000] into a string like this ["1"]
	-- That's VindarPatch's doing, it converts the whole table into string (key and value)
	-- Now I only need to convert the key since the values are already in the correct language format.
	local newt = {};
	for i, v in pairs(PProfile) do newt[tostring(i)] = v; end
	PProfile = newt;

	Turbine.PluginData.Save(Turbine.DataScope.Account, "TitanBarPlayerProfile", PProfile);
end

function HelpInfo()
	if frmSC then
		wShellCmd:Close();
	else
		import(AppDirD .. "shellcmd"); -- LUA shell command file
		frmShellCmd();
	end
end

function UnloadTitanBar()
	Turbine.PluginManager.LoadPlugin('TitanBar Unloader');  --workaround
end

function ReloadTitanBar()
	settings.TitanBar.Z = true;
	SaveSettings(false);
	Turbine.PluginManager.LoadPlugin('TitanBar Reloader');  --workaround
end

function AboutTitanBar()
	--write( "TitanBar: About!" );
	--Turbine.PluginManager.ShowAbouts(Plugins.TitanBar); -- Add this when About is available
	--Turbine.PluginManager.ShowOptions(Plugins.TitanBar); --This will open plugin manager and show TitanBar options (THIS IS AN EXAMLPE)
end

function ShowHideCurrency(currency)
	_G.CurrencyData[currency].IsVisible = not _G.CurrencyData[currency].IsVisible
	settings[currency].V = _G.CurrencyData[currency].IsVisible
	settings[currency].W = string.format("%.0f", _G.CurrencyData[currency].Where);
	SaveSettings(false);
	ImportCtr(currency);

	if _G.Debug then write("ShowHideCurrency:" .. currency); end
	if _G.CurrencyData[currency].IsVisible then
		_G.CurrencyData[currency].Ctr:SetBackColor(Turbine.UI.Color(
			_G.CurrencyData[currency].bcAlpha,
			_G.CurrencyData[currency].bcRed,
			_G.CurrencyData[currency].bcGreen,
			_G.CurrencyData[currency].bcBlue
		))
	end
	_G.CurrencyData[currency].Ctr:SetVisible(_G.CurrencyData[currency].IsVisible);
end
