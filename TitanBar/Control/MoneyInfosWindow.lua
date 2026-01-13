-- MoneyInfosWindow.lua
-- written by Habna
-- refactored by 4andreas

function frmMoneyInfosWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	_G.ControlData.Money = _G.ControlData.Money or {}
	local moneyData = _G.ControlData.Money
	if moneyData.stm == nil then moneyData.stm = false end
	if moneyData.sss == nil then moneyData.sss = true end
	if moneyData.sts == nil then moneyData.sts = true end
	if moneyData.scm == nil then moneyData.scm = true end
	if moneyData.scma == nil then moneyData.scma = true end
	-- Create window via helper
	local wMI = CreateControlWindow(
		"Money", "Money",
		L["MIWTitle"], 325, 640
	)
	moneyData.ui = moneyData.ui or {}
	local ui = moneyData.ui
	ui.window = wMI
	local window = ui.window

	local miListBox = Turbine.UI.ListBox();
	ui.MIListBox = miListBox
	miListBox:SetParent( window );
	miListBox:SetPosition( 20, 35 );
	miListBox:SetWidth( window:GetWidth() - 40 );
	ConfigureListBox(miListBox)
	--MIListBox:SetBackColor( Color["darkgrey"] ); --debug purpose

	local allCharCB = CreateAutoSizedCheckBox(window, L["MIWAll"], 0, 0, moneyData.stm)
	ui.AllCharCB = allCharCB

	allCharCB.CheckedChanged = function( sender, args )
		moneyData.stm = allCharCB:IsChecked();
		settings.Money.S = moneyData.stm;
		SaveSettings( false );
		UpdateMoney();
	end

	local thisCharCB = CreateAutoSizedCheckBox(window, L["MIWCM"], 0, 0, moneyData.scm)
	ui.ThisCharCB = thisCharCB

	thisCharCB.CheckedChanged = function( sender, args )
		moneyData.scm = thisCharCB:IsChecked();
		if moneyData.stm then allCharCB:SetChecked( false ); SavePlayerMoney(true); allCharCB:SetChecked( true );
		else SavePlayerMoney(true); end
		RefreshMIListBox();
	end

	local toAllCharCB = CreateAutoSizedCheckBox(window, L["MIWCMAll"], 0, 0, moneyData.scma)
	ui.ToAllCharCB = toAllCharCB

	toAllCharCB.CheckedChanged = function( sender, args )
		moneyData.scma = toAllCharCB:IsChecked();
		SavePlayerMoney( false );
	end

	local sssCB = CreateAutoSizedCheckBox(window, L["MIWSSS"], 0, 0, moneyData.sss)
	ui.SSSCB = sssCB

	sssCB.CheckedChanged = function(sender, args)
		moneyData.sss = sssCB:IsChecked();
		settings.Money.SS = moneyData.sss;
		SaveSettings(false);
	end

	local stsCB = CreateAutoSizedCheckBox(window, L["MIWSTS"], 0, 0, moneyData.sts)
	ui.STSCB = stsCB

	stsCB.CheckedChanged = function( sender, args )
		moneyData.sts = stsCB:IsChecked();
		settings.Money.TS = moneyData.sts;
		SaveSettings( false );
	end

	RefreshMIListBox();

	window:SetPosition( _G.ControlData.Money.window.left, _G.ControlData.Money.window.top );
end

function RefreshMIListBox()
	local moneyData = _G.ControlData and _G.ControlData.Money
	local ui = moneyData and moneyData.ui
	if not ui or not ui.window then return end
	local miListBox = ui and ui.MIListBox
	if not miListBox then return end
	local allCharCB = ui and ui.AllCharCB
	local thisCharCB = ui and ui.ThisCharCB
	local toAllCharCB = ui and ui.ToAllCharCB
	local sssCB = ui and ui.SSSCB
	local stsCB = ui and ui.STSCB

	miListBox:ClearItems();
	local MIPosY = 0;
	local found = false;
	
	--Create an array of character name, sort it, then use it as a reference.
	local a = {};
    for n in pairs(wallet) do table.insert(a, n) end
    table.sort(a);
    --for i,n in ipairs(a) do write(n) end --degug purpose

	--for k,v in pairs(wallet) do
	for i = 1, #a do
		if a[i] == Player:GetName() then
			if wallet[a[i]].Show then 
		MITTShowData(miListBox, a[i], wallet[a[i]].Money, Color["green"], Color["green"], true);
		found = true
        MIPosY = MIPosY + 19;
      end
		else
			if wallet[a[i]].ShowToAll or wallet[a[i]].ShowToAll == nil then 
		MITTShowData(miListBox, a[i], wallet[a[i]].Money, Color["white"], Color["white"], true);
		found = true
        MIPosY = MIPosY + 19;
      end
		end
	end
	
	if not found then--No wallet info found, show a message
		local MsgCtr = Turbine.UI.Control();
		MsgCtr:SetParent( miListBox );
		MsgCtr:SetSize( miListBox:GetWidth(), 19 );
		MsgCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--MsgCtr:SetBackColor( Color["red"] ); -- Debug purpose

		local MsgLbl = CreateTitleLabel(MsgCtr, L["MIMsg"], 0, 0, nil, Color["red"], nil, MsgCtr:GetWidth(), MsgCtr:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

		miListBox:AddItem( MsgCtr );
		MIPosY = MIPosY + 19;
	end

	local LineCtr = Turbine.UI.Control();
	LineCtr:SetParent( miListBox );
	LineCtr:SetSize( miListBox:GetWidth(), 7 );
	--LineCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );

	local LineLbl = Turbine.UI.Label();
	LineLbl:SetParent( LineCtr );
	LineLbl:SetText( "" );
	LineLbl:SetPosition( 0, 2 );
	LineLbl:SetSize( miListBox:GetWidth(), 1 );
	LineLbl:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	LineLbl:SetBackColor( Color["trueblue"] );

	miListBox:AddItem( LineCtr );
	MIPosY = MIPosY + 7;

	MITTShowData(miListBox, L["MIWTotal"], (GoldTot*100000+SilverTot*100+CopperTot), Color["white"], Color["white"]);
  MIPosY = MIPosY + 19;
	
	miListBox:AddItem( TotMoneyCtr );
	MIPosY = MIPosY + 19;
	miListBox:SetHeight( MIPosY );

	MIPosY = MIPosY + 50;
	allCharCB:SetPosition( miListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	thisCharCB:SetPosition( miListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	toAllCharCB:SetPosition( miListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	sssCB:SetPosition( miListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	stsCB:SetPosition( miListBox:GetLeft(), MIPosY );
	
	ui.window:SetHeight( MIPosY + 45 );
end
