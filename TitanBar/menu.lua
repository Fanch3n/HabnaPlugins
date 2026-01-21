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
		settings.TitanBar.L = Lang[i];
		SaveSettings( false );
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

local function ToggleMenuVisibility(menuToggle)
	menuToggle()
	TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos) -- TODO what does this actually do?
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

-- Menu Items
local opt_WI = CreateControlMenuItem("WI", L["MBag"])
local opt_BI = CreateControlMenuItem("BI", L["MBI"])
local opt_PI = CreateControlMenuItem("PI", L["MPI"])
local opt_EI = CreateControlMenuItem("EI", L["MEI"], ShowHideEquipInfos)
local opt_DI = CreateControlMenuItem("DI", L["MDI"], ShowHideDurabilityInfos)
local opt_PL = CreateControlMenuItem("PL", L["MPL"])
local opt_TI = CreateControlMenuItem("TI", L["MTI"])
local opt_IF = CreateControlMenuItem("IF", L["IFWTitle"])
local opt_GT = CreateControlMenuItem("GT", L["MGT"])
local opt_VT = CreateControlMenuItem("VT", L["MVault"])
local opt_SS = CreateControlMenuItem("SS", L["MStorage"])
local opt_DN = CreateControlMenuItem("DN", L["MDayNight"])
local opt_RP = CreateControlMenuItem("RP", L["MReputation"])

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

local opt_about = Turbine.UI.MenuItem(L["MATB"] .. " TitanBar " .. Version);
opt_about.Click = function( sender, args ) AboutTitanBar(); end



TitanBarMenu.items:Add(opt_WI);
TitanBarMenu.items:Add(opt_BI);
TitanBarMenu.items:Add(opt_PI);
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_EI); end -- only show if in Free People mode
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_DI); end -- only show if in Free People mode
TitanBarMenu.items:Add(opt_PL);
TitanBarMenu.items:Add(opt_TI);
TitanBarMenu.items:Add(opt_IF);
TitanBarMenu.items:Add(opt_GT);
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_VT); end -- only show if in Free People mode
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_SS); end -- only show if in Free People mode
TitanBarMenu.items:Add(opt_DN);
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_RP); end -- only show if in Free People mode
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
--TitanBarMenu.items:Add(opt_empty); --Add when about function in plugin manager is available
--TitanBarMenu.items:Add(opt_about); --Add when about function in plugin manager is available