-- MoneyInfos.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import(AppCtrD .. "MoneyInfosToolTip")
import(AppCtrD .. "MoneyInfosWindow")


function UpdateMoney()
    -- Safety check: Ensure controls are initialized before updating UI
    if not (_G.ControlData and _G.ControlData.Money and _G.ControlData.Money.controls) then return end

	local where = (_G.ControlData and _G.ControlData.Money and _G.ControlData.Money.where) or Constants.Position.NONE
	if where == Constants.Position.TITANBAR then
		local moneyData = (_G.ControlData and _G.ControlData.Money) or {}
		local showTotal = moneyData.stm == true
		local money = GetPlayerAttributes():GetMoney();
	local gold, silver, copper = DecryptMoney(money);
	
	_G.ControlData.Money.controls[ "GLbl" ]:SetText( string.format( "%.0f", gold ) );
	_G.ControlData.Money.controls[ "SLbl" ]:SetText( string.format( "%.0f", silver ) );
	_G.ControlData.Money.controls[ "CLbl" ]:SetText( string.format( "%.0f", copper ) );	SavePlayerMoney( false );

	_G.ControlData.Money.controls[ "GLbl" ]:SetSize( _G.ControlData.Money.controls[ "GLbl" ]:GetTextLength() * NM, CTRHeight ); 
        --Auto size with text length
	_G.ControlData.Money.controls[ "SLbl" ]:SetSize( 4 * NM, CTRHeight ); --Auto size with text length
	_G.ControlData.Money.controls[ "CLbl" ]:SetSize( 3 * NM, CTRHeight ); --Auto size with text length	_G.ControlData.Money.controls[ "GLblT" ]:SetVisible( showTotal );
	_G.ControlData.Money.controls[ "GLbl" ]:SetVisible( not showTotal );	_G.ControlData.Money.controls[ "SLblT" ]:SetVisible( showTotal );
	_G.ControlData.Money.controls[ "SLbl" ]:SetVisible( not showTotal );

	_G.ControlData.Money.controls[ "CLblT" ]:SetVisible( showTotal );
	_G.ControlData.Money.controls[ "CLbl" ]:SetVisible( not showTotal );	if showTotal then --Add Total Money on TitanBar Money control.
		local strData = L[ "MIWTotal" ] .. ": ";
		local strData1 = string.format( "%.0f", GoldTot );
		local strData2 = L[ "You" ] .. _G.ControlData.Money.controls[ "GLbl" ]:GetText();
		local TextLen = string.len( strData ) * TM + string.len( strData1 ) * NM;
		if TBFontT == "TrajanPro25" then TextLen = TextLen + 7; end
		_G.ControlData.Money.controls[ "GLblT" ]:SetText(strData .. strData1 .. "\n" .. strData2 .. " ");
		_G.ControlData.Money.controls[ "GLblT" ]:SetSize( TextLen, CTRHeight );		strData1 = string.format( "%.0f", SilverTot );
		strData2 = _G.ControlData.Money.controls[ "SLbl" ]:GetText();
		TextLen = 4 * NM + 6;
		_G.ControlData.Money.controls[ "SLblT" ]:SetText( strData1 .. "\n" .. strData2 .. " " );
		_G.ControlData.Money.controls[ "SLblT" ]:SetSize( TextLen, CTRHeight );		strData1 = string.format( "%.0f", CopperTot );
		strData2 = _G.ControlData.Money.controls[ "CLbl" ]:GetText();
		TextLen = 3 * NM + 6;
		_G.ControlData.Money.controls[ "CLblT" ]:SetText( strData1 .. "\n" .. strData2 .. " " );
		_G.ControlData.Money.controls[ "CLblT" ]:SetSize( TextLen, CTRHeight );	end
    
    --Statistics section
    local PN = Player:GetName();
    local bIncome = true;
    bSumSSS, bSumSTS = true, true;
    local hadmoney = walletStats[DOY][PN].Had;

    local diff = money - hadmoney;
    if diff < 0 then diff = math.abs(diff); bIncome = false; end

    if bIncome then 
        walletStats[DOY][PN].Earned = 
            tostring(walletStats[DOY][PN].Earned + diff);
        walletStats[DOY][PN].TotEarned = 
            tostring(walletStats[DOY][PN].TotEarned + diff);
    else
        walletStats[DOY][PN].Spent = 
            tostring(walletStats[DOY][PN].Spent + diff);
        walletStats[DOY][PN].TotSpent = 
            tostring(walletStats[DOY][PN].TotSpent + diff);
    end

    walletStats[DOY][PN].Had = tostring(money);

    --Sum of session statistics
    local SSS = walletStats[DOY][PN].Earned - walletStats[DOY][PN].Spent;
    if SSS < 0 then SSS = math.abs(SSS); bSumSSS = false; end
    walletStats[DOY][PN].SumSS = tostring(SSS);

    -- Sum of today satistics
    --Calculate all character earned & spent
    totem, totsm = 0,0;
    for k,v in pairs(walletStats[DOY]) do
        totem = totem + v.TotEarned;
        totsm = totsm + v.TotSpent;
    end
    
    local STS = totem - totsm;
    if STS < 0 then STS = math.abs(STS); bSumSTS = false; end
    walletStats[DOY][PN].SumTS = tostring(STS);

    Turbine.PluginData.Save( 
        Turbine.DataScope.Server, "TitanBarPlayerWalletStats", walletStats);

	end
	AdjustIcon( "MI" );
end

function InitializeMoneyInfos()
	-- Use _G.ControlData.Money.controls for all UI controls
	local MI = {}
	_G.ControlData.Money.controls = MI
	local moneyData = _G.ControlData.Money
	-- Cleanup existing controls to prevent duplication
	if moneyData.controls and moneyData.controls["Ctr"] and moneyData.controls["Ctr"] ~= MI["Ctr"] then
		moneyData.controls["Ctr"]:SetParent(nil)
	end

	-- Cleanup existing callbacks
	if moneyData.callbacks then
		for _, cb in ipairs(moneyData.callbacks) do
			if RemoveCallback then
				RemoveCallback(cb.obj, cb.evt, cb.func)
			end
		end
	end
	moneyData.callbacks = {}

	-- Initialize settings from saved data or defaults
	local moneyData = _G.ControlData.Money
	if moneyData.stm == nil then moneyData.stm = settings.Money.S end
	if moneyData.stm == nil then moneyData.stm = false end

	if moneyData.sss == nil then moneyData.sss = settings.Money.SSS end
	if moneyData.sss == nil then moneyData.sss = true end

	if moneyData.sts == nil then moneyData.sts = settings.Money.STS end
	if moneyData.sts == nil then moneyData.sts = true end

	if moneyData.scm == nil then moneyData.scm = settings.Money.SCM end
	if moneyData.scm == nil then moneyData.scm = true end

	if moneyData.scma == nil then moneyData.scma = settings.Money.SCMa end
	if moneyData.scma == nil then moneyData.scma = true end

	--**v Control of Gold/Silver/Copper currencies v**
	local colors = _G.ControlData.Money.colors
	MI["Ctr"] = CreateTitanBarControl(MI, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.Money.ui.control = MI["Ctr"]
	--**^
	--**v Control of Gold currencies v**
	MI["GCtr"] = Turbine.UI.Control();
	MI["GCtr"]:SetParent( MI["Ctr"] );
	MI["GCtr"]:SetMouseVisible( false );
	--MI["GCtr"]:SetZOrder( 2 );
	--MI["GCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
	--**^
	--**v Gold & total amount on TitanBar v**
	MI["GLblT"] = Turbine.UI.Label();
	MI["GLblT"]:SetParent( MI["GCtr"] );
	MI["GLblT"]:SetPosition( 0, 0 );
	MI["GLblT"]:SetFont( _G.TBFont );
	--MI["GLblT"]:SetForeColor( Color["white"] );
	MI["GLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
	MI["GLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--MI["GLblT"]:SetBackColor( Color["white"] ); -- Debug purpose
	--**^
	--**v Gold amount & icon on TitanBar v**
	MI["GLbl"] = Turbine.UI.Label();
	MI["GLbl"]:SetParent( MI["GCtr"] );
	MI["GLbl"]:SetPosition( 0, 0 );
	MI["GLbl"]:SetFont( _G.TBFont );
	--MI["GLbl"]:SetForeColor( Color["white"] );
	MI["GLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
	MI["GLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--MI["GLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

	MI["GIcon"] = CreateControlIcon(MI["GCtr"], Constants.MONEY_ICON_WIDTH, Constants.MONEY_ICON_HEIGHT, resources.MoneyIcon.Gold)

	MI["GIcon"].MouseMove = function( sender, args )
		MI["CIcon"].MouseMove( sender, args );
	end
	--**^

	--**v Control of Silver currencies v**
MI["SCtr"] = Turbine.UI.Control();
MI["SCtr"]:SetParent( MI["Ctr"] );
MI["SCtr"]:SetMouseVisible( false );
--MI["SCtr"]:SetZOrder( 2 );
--MI["SCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
--**^
--**v Silver & total amount on TitanBar v**
MI["SLblT"] = Turbine.UI.Label();
MI["SLblT"]:SetParent( MI["SCtr"] );
MI["SLblT"]:SetPosition( 0, 0 );
MI["SLblT"]:SetFont( _G.TBFont );
--MI["SLblT"]:SetForeColor( Color["white"] );
MI["SLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["SLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["SLblT"]:SetBackColor( Color["white"] ); -- Debug purpose

--**^
--**v Silver amount & icon on TitanBar v**
MI["SLbl"] = Turbine.UI.Label();
MI["SLbl"]:SetParent( MI["SCtr"] );
MI["SLbl"]:SetPosition( 0, 0 );
MI["SLbl"]:SetFont( _G.TBFont );
--MI["SLbl"]:SetForeColor( Color["white"] );
--MI["SLbl"]:SetSize( 20, 30 );
MI["SLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["SLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["SLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["SIcon"] = CreateControlIcon(MI["SCtr"], Constants.MONEY_ICON_WIDTH, Constants.MONEY_ICON_HEIGHT, resources.MoneyIcon.Silver)

MI["SIcon"].MouseMove = function( sender, args )
	MI["CIcon"].MouseMove( sender, args );
end
--**^

--**v Control of Copper currencies v**
MI["CCtr"] = Turbine.UI.Control();
MI["CCtr"]:SetParent( MI["Ctr"] );
MI["CCtr"]:SetMouseVisible( false );
--MI["CCtr"]:SetZOrder( 2 );
--MI["CCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
--**^
--**v Copper & total amount on TitanBar v**
MI["CLblT"] = Turbine.UI.Label();
MI["CLblT"]:SetParent( MI["CCtr"] );
MI["CLblT"]:SetPosition( 0, 0 );
MI["CLblT"]:SetFont( _G.TBFont );
--MI["CLblT"]:SetForeColor( Color["white"] );
MI["CLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["CLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["CLblT"]:SetBackColor( Color["white"] ); -- Debug purpose

--**^
--**v Copper amount & icon on TitanBar v**
MI["CIcon"] = CreateControlIcon(MI["CCtr"], Constants.MONEY_ICON_WIDTH, Constants.MONEY_ICON_HEIGHT, resources.MoneyIcon.Copper)

local MoveMICtr = CreateMoveHandler(MI["Ctr"], MI["CLbl"])

MI["CIcon"].MouseMove = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveMICtr(sender, args); end
end


MI["CLbl"] = Turbine.UI.Label();
MI["CLbl"]:SetParent( MI["CCtr"] );
MI["CLbl"]:SetPosition( 0, 0 );
MI["CLbl"]:SetFont( _G.TBFont );
--MI["CLbl"]:SetForeColor( Color["white"] );
--MI["CLbl"]:SetSize( 20, 30 );
MI["CLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["CLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["CLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["CLbl"].MouseMove = function( sender, args )
	--MI["CLbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveMICtr(sender, args);
	else
		if not MITT or not _G.ToolTipWin then
			MITT = true;
			ShowMIWindow();
		else
			PositionToolTipWindow();
		end
	end
end

MI["CLbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	MITT = false;
end

MI["CLbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not _G.WasDrag then
			local window = _G.ControlData.Money.ui and _G.ControlData.Money.ui.window
			if window then
				window:Close();
			else
				import (AppCtrD.."MoneyInfosWindow");
				frmMoneyInfosWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "Money";
		ControlMenu:ShowMenu();
	end
	_G.WasDrag = false;
end

local dragHandlers = CreateDragHandlers(MI["Ctr"], settings.Money, "Money")
MI["CLbl"].MouseDown = dragHandlers.MouseDown
MI["CLbl"].MouseUp = dragHandlers.MouseUp

-- Delegate mouse events from child controls to CLbl
DelegateMouseEvents(MI["GLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["GLbl"], MI["CLbl"]);
DelegateMouseEvents(MI["GIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});
DelegateMouseEvents(MI["SLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["SLbl"], MI["CLbl"]);
DelegateMouseEvents(MI["SIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});
DelegateMouseEvents(MI["CLblT"], MI["CLbl"]);
DelegateMouseEvents(MI["CIcon"], MI["CLbl"], {"MouseLeave", "MouseClick", "MouseDown", "MouseUp"});

-- Register callbacks for dynamic updates
local where = moneyData.where or Constants.Position.NONE
if where ~= Constants.Position.NONE then
    local cb1 = function(sender, args) UpdateMoney(); end
    if AddCallback then
        AddCallback(GetPlayerAttributes(), "MoneyChanged", cb1);
        table.insert(moneyData.callbacks, {obj=GetPlayerAttributes(), evt="MoneyChanged", func=cb1})
        
        if sspack and UpdateSharedStorageGold then
            AddCallback(sspack, "CountChanged", UpdateSharedStorageGold);
            table.insert(moneyData.callbacks, {obj=sspack, evt="CountChanged", func=UpdateSharedStorageGold})
        end
    end
end

UpdateMoney()

end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "Money",
		settingsKey = "Money",
		hasWhere = true,
		defaults = { show = true, where = 1, x = nil, y = 0 },
		initFunc = InitializeMoneyInfos
	})
end