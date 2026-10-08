-- menu.lua
-- Written By Habna


-- Locale menu
local LocMenu = Turbine.UI.MenuItem( L["MCL"] );
LocMenu.Items = LocMenu:GetItems();

local MenuItem = { L["MCLen"], L["MCLfr"], L["MCLde"] };
local Lang = { "en", "fr", "de" };

for i = 1, 3 do
	local LocItems = Turbine.UI.MenuItem( MenuItem[i] );
	if TBLocale == Lang[i] then LocItems:SetChecked( true ); end
	LocItems.Click = function( sender, args )
		if TBLocale == Lang[i] then return end
		-- Choosing the game language means: follow the game language
		TBLocaleChoice = (Lang[i] == GLocale) and "auto" or Lang[i];
		ReloadTitanBar();
	end
	
	LocMenu.Items:Add( LocItems );
end


-- Reset back color of... menu
local RBCMenu = Turbine.UI.MenuItem( L["MCRBG"] );
RBCMenu.Items = RBCMenu:GetItems();

local RBCMenu1 = Turbine.UI.MenuItem( L["MCABTTB"] );
RBCMenu1.Click = function( sender, args ) BGColor( "reset" , "TitanBar" ); end
RBCMenu.Items:Add( RBCMenu1 );

local RBCMenu2 = Turbine.UI.MenuItem( L["MCABTA"] );
RBCMenu2.Click = function( sender, args ) BGColor( "reset", "applyToAllAndTitanBar" ); end
RBCMenu.Items:Add( RBCMenu2 );

--- Main menu
TitanBarMenu = Turbine.UI.ContextMenu();
TitanBarMenu.items = TitanBarMenu:GetItems();

-- Clicking an item closes the menu: open it again where it was, so that several controls can be switched in a row
local function ToggleMenuVisibility(menuToggle)
	menuToggle()
	TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos)
end

local opt_line = Turbine.UI.MenuItem("---------------------------------------------", false);
local opt_empty = Turbine.UI.MenuItem("", false);

local function CreateControlMenuItem(id, label, toggleFunc)
	local item = Turbine.UI.MenuItem(label)
	if _G.ControlData[id] then
		item:SetChecked(_G.ControlData[id].show)
		_G.ControlData[id].ui = _G.ControlData[id].ui or {}
		_G.ControlData[id].ui.menuItem = item
	end
	
	-- Use provided toggle function or default to generic ToggleControl
	local clickAction = toggleFunc or function() ToggleControl(id) end
	
	item.Click = function(sender, args) ToggleMenuVisibility(clickAction) end
	return item
end

-- Menu items of the controls, in the order they were registered (see main.lua)
local controlMenuItems = {}
_G.ControlRegistry.ForEachRegistered(function(id, data, meta)
	if meta.menuText and (PlayerAlign == 1 or not meta.freePeopleOnly) then
		table.insert(controlMenuItems, CreateControlMenuItem(id, L[meta.menuText]))
	end
end)

opt_options = Turbine.UI.MenuItem(L["MOP"]);
opt_options.Click = function( sender, args ) import (AppDirD.."frmOptions"); frmOptions(); opt_options:SetEnabled( false ); end

option_backcolor = Turbine.UI.MenuItem(L["MBG"]);
option_backcolor.Click = function( sender, args ) import (AppDirD.."background"); frmBackground(); option_backcolor:SetEnabled( false ); end

opt_profile = Turbine.UI.MenuItem(L["MPP"]);
opt_profile.Click = function( sender, args ) import (AppDirD.."profile"); frmProfile(); opt_profile:SetEnabled( false ); end

opt_shellcmd = Turbine.UI.MenuItem(L["MSC"]);
opt_shellcmd.Click = function( sender, args ) HelpInfo(); end

local opt_ResetAllSet = Turbine.UI.MenuItem(L["MRA"]);
opt_ResetAllSet.Click = function( sender, args ) ResetSettings(); end

local opt_unload = Turbine.UI.MenuItem(L["MUTB"] .. " TitanBar " .. Version);
opt_unload.Click = function( sender, args ) UnloadTitanBar(); end

local opt_reload = Turbine.UI.MenuItem(L["MRTB"] .. " TitanBar " .. Version);
opt_reload.Click = function( sender, args ) ReloadTitanBar(); end


for _, item in ipairs(controlMenuItems) do TitanBarMenu.items:Add(item); end
TitanBarMenu.items:Add(opt_line);
TitanBarMenu.items:Add(opt_options);
TitanBarMenu.items:Add(option_backcolor);
TitanBarMenu.items:Add(RBCMenu);
TitanBarMenu.items:Add(opt_empty);
TitanBarMenu.items:Add(LocMenu);
TitanBarMenu.items:Add(opt_empty);
TitanBarMenu.items:Add(opt_profile);
TitanBarMenu.items:Add(opt_shellcmd);
TitanBarMenu.items:Add(opt_ResetAllSet);
TitanBarMenu.items:Add(opt_empty);
TitanBarMenu.items:Add(opt_unload);
TitanBarMenu.items:Add(opt_reload);