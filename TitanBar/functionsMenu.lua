-- functionsMenu.lua
-- Functions for the context menu

-- Generic Toggle Function to replace individual handlers
function ToggleControl(id)
	local controlData = _G.ControlData[id]
	if not controlData then return end

	-- Toggle state
	controlData.show = not controlData.show

	SaveSettings()

	-- Handle UI Update
	if controlData.show then
		ImportCtr(id)

		-- Set Background Color if control exists
		if controlData.controls and controlData.controls["Ctr"] and controlData.colors then
			local colors = controlData.colors
			controlData.controls["Ctr"]:SetBackColor(Turbine.UI.Color(colors.alpha, colors.red, colors.green, colors.blue))
			controlData.controls["Ctr"]:SetVisible(true)
		end

		-- Custom OnShow Hook
		if controlData.onShow then controlData.onShow() end
		
	else
		-- Cleanup Callbacks
		if controlData.callbacks then
			for _, cb in ipairs(controlData.callbacks) do
				if RemoveCallback then RemoveCallback(cb.obj, cb.evt, cb.func) end
			end
			controlData.callbacks = {}
		end
		
		-- Custom OnHide Hook
		if controlData.onHide then controlData.onHide() end
		
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

-- reason: window to reopen after the reload ("Profile" or "Font"), nil for none
-- newSettings: settings table to reload with instead of the current state (a profile)
function ReloadTitanBar(reason, newSettings)
	TBReloaded = true;
	TBReloadedText = reason or "TB";
	if newSettings then
		settings = newSettings;
		settings.TitanBar.Z = TBReloaded;
		settings.TitanBar.ZT = TBReloadedText;
		WriteSettings();
	else
		SaveSettings();
	end
	Turbine.PluginManager.LoadPlugin('TitanBar Reloader');  --workaround
end

function AboutTitanBar()
end

function ShowHideCurrency(currency)
	local data = _G.ControlData[currency]
	data.show = not data.show
	SaveSettings();
	ImportCtr(currency);

	if _G.Debug then write("ShowHideCurrency:" .. currency); end
	if data.show then
		local colors = data.colors
		data.controls.Ctr:SetBackColor(Turbine.UI.Color(colors.alpha, colors.red, colors.green, colors.blue))
	end
	data.controls.Ctr:SetVisible(data.show);
end
