-- MoneyInfosWindow.lua
-- written by Habna
-- refactored by 4andreas

function frmMoneyInfosWindow()
	import(AppDirD .. "WindowFactory")
	-- Create window via helper
	local wMI = CreateControlWindow(
		"Money", "Money",
		L["MIWTitle"], 325, 640
	)

	MIListBox = Turbine.UI.ListBox();
	MIListBox:SetParent( wMI );
	MIListBox:SetPosition( 20, 35 );
	MIListBox:SetWidth( wMI:GetWidth() - 40 );
	ConfigureListBox(MIListBox)
	--MIListBox:SetBackColor( Color["darkgrey"] ); --debug purpose
	
	-- **v Display total money - check box v**
	AllCharCB = Turbine.UI.Lotro.CheckBox();
	AllCharCB:SetParent( wMI );
	AllCharCB:SetText( L["MIWAll"] );
	AllCharCB:SetSize( wMI:GetWidth(), 30 );
	AllCharCB:SetChecked( _G.STM );
	AllCharCB:SetForeColor( Color["rustedgold"] );

	AllCharCB.CheckedChanged = function( sender, args )
		_G.STM = AllCharCB:IsChecked();
		settings.Money.S = _G.STM;
		SaveSettings( false );
		UpdateMoney();
	end
	-- **^
	-- **v Display character money - check box v**
	ThisCharCB = Turbine.UI.Lotro.CheckBox();
	ThisCharCB:SetParent( wMI );
	ThisCharCB:SetText( L["MIWCM"] );
	ThisCharCB:SetSize( wMI:GetWidth(), 30 );
	ThisCharCB:SetChecked( _G.SCM );
	ThisCharCB:SetForeColor( Color["rustedgold"] );

	ThisCharCB.CheckedChanged = function( sender, args )
		_G.SCM = ThisCharCB:IsChecked();
		if _G.STM then AllCharCB:SetChecked( false ); SavePlayerMoney(true); AllCharCB:SetChecked( true );
		else SavePlayerMoney(true); end
		RefreshMIListBox();
	end
	-- **^
	-- **v Display to all character - check box v**
	ToAllCharCB = Turbine.UI.Lotro.CheckBox();
	ToAllCharCB:SetParent( wMI );
	ToAllCharCB:SetText( L["MIWCMAll"] );
	ToAllCharCB:SetSize( wMI:GetWidth(), 30 );
	ToAllCharCB:SetChecked( _G.SCMA );
	ToAllCharCB:SetForeColor( Color["rustedgold"] );

	ToAllCharCB.CheckedChanged = function( sender, args )
		_G.SCMA = ToAllCharCB:IsChecked();
		SavePlayerMoney( false );
	end
	-- **^
	-- **v Display session statistics - check box v**
	SSSCB = Turbine.UI.Lotro.CheckBox();
	SSSCB:SetParent( wMI );
	SSSCB:SetText( L["MIWSSS"] );
	SSSCB:SetSize( wMI:GetWidth(), 30 );
	SSSCB:SetChecked( _G.SSS );
	SSSCB:SetForeColor( Color["rustedgold"] );

	SSSCB.CheckedChanged = function( sender, args )
		_G.SSS = SSSCB:IsChecked();
		settings.Money.SS = _G.SSS;
		SaveSettings( false );
	end
	-- **^
	-- **v Display session statistics - check box v**
	STSCB = Turbine.UI.Lotro.CheckBox();
	STSCB:SetParent( wMI );
	STSCB:SetText( L["MIWSTS"] );
	STSCB:SetSize( wMI:GetWidth(), 30 );
	STSCB:SetChecked( _G.STS );
	STSCB:SetForeColor( Color["rustedgold"] );

	STSCB.CheckedChanged = function( sender, args )
		_G.STS = STSCB:IsChecked();
		settings.Money.TS = _G.STS;
		SaveSettings( false );
	end
	-- **^

	RefreshMIListBox();

	wMI:SetPosition( _G.ControlData.Money.window.left, _G.ControlData.Money.window.top );
end

function RefreshMIListBox()
	local wMI = _G.ControlData.Money.windowInstance
	MIListBox:ClearItems();
	local MIPosY = 0;
	local iFound = false;
	
	--Create an array of character name, sort it, then use it as a reference.
	local a = {};
    for n in pairs(wallet) do table.insert(a, n) end
    table.sort(a);
    --for i,n in ipairs(a) do write(n) end --degug purpose

	--for k,v in pairs(wallet) do
	for i = 1, #a do
		if a[i] == Player:GetName() then
			if wallet[a[i]].Show then 
        MITTShowData(MIListBox, a[i], wallet[a[i]].Money, Color["green"], Color["green"], true); 
        MIPosY = MIPosY + 19;
      end
		else
			if wallet[a[i]].ShowToAll or wallet[a[i]].ShowToAll == nil then 
        MITTShowData(MIListBox, a[i], wallet[a[i]].Money, Color["white"], Color["white"], true); 
        MIPosY = MIPosY + 19;
      end
		end
	end
	
	if not iFound then--No wallet info found, show a message
		--**v Control of message v**
		local MsgCtr = Turbine.UI.Control();
		MsgCtr:SetParent( MIListBox );
		MsgCtr:SetSize( MIListBox:GetWidth(), 19 );
		MsgCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--MsgCtr:SetBackColor( Color["red"] ); -- Debug purpose
		--**^
		--**v Message v**
		local MsgLbl = CreateTitleLabel(MsgCtr, L["MIMsg"], 0, 0, nil, Color["red"], nil, MsgCtr:GetWidth(), MsgCtr:GetHeight(), Turbine.UI.ContentAlignment.MiddleCenter)

		MIListBox:AddItem( MsgCtr );
		MIPosY = MIPosY + 19;
	end

	--**v Line Control v**
	local LineCtr = Turbine.UI.Control();
	LineCtr:SetParent( MIListBox );
	LineCtr:SetSize( MIListBox:GetWidth(), 7 );
	--LineCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );

	local LineLbl = Turbine.UI.Label();
	LineLbl:SetParent( LineCtr );
	LineLbl:SetText( "" );
	LineLbl:SetPosition( 0, 2 );
	LineLbl:SetSize( MIListBox:GetWidth(), 1 );
	LineLbl:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	LineLbl:SetBackColor( Color["trueblue"] );

	MIListBox:AddItem( LineCtr );
	MIPosY = MIPosY + 7;
	--**^
	MITTShowData(MIListBox, L["MIWTotal"], (GoldTot*100000+SilverTot*100+CopperTot), Color["white"], Color["white"]);
  MIPosY = MIPosY + 19;
	
	MIListBox:AddItem( TotMoneyCtr );
	MIPosY = MIPosY + 19;
	MIListBox:SetHeight( MIPosY );

	MIPosY = MIPosY + 50;
	AllCharCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	ThisCharCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	ToAllCharCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	SSSCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	STSCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	
	wMI:SetHeight( MIPosY + 45 );
end
