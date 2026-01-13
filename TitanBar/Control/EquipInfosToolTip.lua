-- EquipInfosWindow.lua
-- Written by Habna


SlotsText = {L["EWST1"], L["EWST2"], L["EWST3"], L["EWST4"], L["EWST5"], L["EWST6"], L["EWST7"], L["EWST8"], L["EWST9"],
		L["EWST10"], L["EWST11"], L["EWST12"], L["EWST13"], L["EWST14"], L["EWST15"], L["EWST16"], L["EWST17"],	L["EWST18"],
		L["EWST19"], L["EWST20"]};

import(AppDirD .. "UIHelpers")

function ShowEIWindow()
	local w, h = 592, 495
	
	local tt = CreateTooltipWindow({
		width = w,
		height = h
	})
	
	PositionAndShowTooltip(_G.ToolTipWin, -5, -15, true)

	--**v Control of all equipment infos v**
	local AEICtr = Turbine.UI.Control();
	AEICtr:SetParent( _G.ToolTipWin );
	AEICtr:SetZOrder( 1 );
	AEICtr:SetSize( w, h );
	AEICtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--AEICtr:SetBackColor( Color["red"] ); -- Debug purpose
	--**^

	lblBackPack = Turbine.UI.Label();
	lblBackPack:SetParent( AEICtr );
	lblBackPack:SetText( L["EWLbl"] );
	lblBackPack:SetPosition( 15, 15);
	lblBackPack:SetSize( 350, Constants.LABEL_HEIGHT_STANDARD );
	lblBackPack:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	lblBackPack:SetForeColor( Color["green"] );

	lblBackPackD = Turbine.UI.Label();
	lblBackPackD:SetParent( AEICtr );
	lblBackPackD:SetText( L["EWLblD"] );
	lblBackPackD:SetSize( Constants.LABEL_WIDTH_NARROW, Constants.LABEL_HEIGHT_STANDARD );
	lblBackPackD:SetPosition( AEICtr:GetWidth() - lblBackPackD:GetWidth() - 20 , 15);
	lblBackPackD:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	lblBackPackD:SetForeColor( Color["green"] );

	ListBoxBorder = CreateControl(Turbine.UI.Control, AEICtr, lblBackPack:GetLeft(), lblBackPack:GetTop() + lblBackPack:GetHeight() + 2, 562, 444);
	ListBoxBorder:SetBackColor( Color["grey"] );
	ListBoxBorder:SetVisible( true );

	EIListBox = CreateControl(Turbine.UI.ListBox, AEICtr, ListBoxBorder:GetLeft() + 2, ListBoxBorder:GetTop() + 2, ListBoxBorder:GetWidth() - 4, ListBoxBorder:GetHeight() - 4);
	ConfigureListBox(EIListBox, 6, Turbine.UI.Orientation.Horizontal, Color["black"])

	EIRefreshListBox();

	ApplySkin();
end

function EIRefreshListBox()
	local EIitemCtl = {};
	local EIitemLbl = {};
	local EIitemLblScore = {};
	local EIitemBG, EIitemU, EIitemS, EIitem = {}, {}, {}, {};
	EIListBox:ClearItems();
	
	for i = 1, 20 do
		-- Item background
		EIitemCtl[i] = Turbine.UI.Control();
		EIitemCtl[i]:SetSize( Constants.ICON_SIZE_XXLARGE, Constants.ICON_SIZE_XXLARGE );
		EIitemCtl[i]:SetBackground( DurabilitySlotsBG[i] );
		EIitemCtl[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item Background/Underlay/Shadow/Item
		if (itemEquip[i].BImgID and itemEquip[i].BImgID > 0) then
			EIitemBG[i] = CreateControl(Turbine.UI.Control, EIitemCtl[i], 6, 6, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
			EIitemBG[i]:SetBackground(itemEquip[i].BImgID);
			EIitemBG[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		end

		if (itemEquip[i].UImgID and itemEquip[i].UImgID > 0) then
			EIitemU[i] = CreateControl(Turbine.UI.Control, EIitemCtl[i], 6, 6, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
			EIitemU[i]:SetBackground(itemEquip[i].UImgID);
			EIitemU[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		end

		-- Added if statements because some items
		-- (e.g. Mended Dwarf-make Leather Tunic, minstrel L.I. Book)
		-- were getting 0 for their SImgID which messed up the final composite.
		if (itemEquip[i].SImgID and itemEquip[i].SImgID > 0) then
			EIitemS[i] = CreateControl(Turbine.UI.Control, EIitemCtl[i], 6, 6, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
			EIitemS[i]:SetBackground(itemEquip[i].SImgID);
			EIitemS[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		end

		EIitem[i] = CreateControl(Turbine.UI.Control, EIitemCtl[i], 6, 6, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
		EIitem[i]:SetBackground(itemEquip[i].IImgID);
		EIitem[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
		-- Item name
		EIitemLbl[i] = Turbine.UI.Label();
		EIitemLbl[i]:SetSize( 205, EIitemCtl[i]:GetHeight() );
		EIitemLbl[i]:SetFont(Turbine.UI.Lotro.Font.TrajanPro12 );
		EIitemLbl[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		--EIitemLbl[i]:SetForeColor( Color["white"] );
		
		if itemEquip[i].Item == false then 
			EIitemLbl[i]:SetForeColor( Color["red"] );
			EIitemLbl[i]:SetText( SlotsText[i] .. ":\n" .. L["EWItemNP"] );
		else
			EIitemLbl[i]:SetText( SlotsText[i] .. ":\n" .. itemEquip[i].Name );
		end

		-- Item Score
		EIitemLblScore[i] = Turbine.UI.Label();
		EIitemLblScore[i]:SetText( itemEquip[i].Score );
		EIitemLblScore[i]:SetSize( 30, EIitemCtl[i]:GetHeight() );
		EIitemLblScore[i]:SetFont( Turbine.UI.Lotro.Font.TrajanPro12 );
		EIitemLblScore[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		
		-- Show item
		EIListBox:AddItem( EIitemCtl[i] );
		EIListBox:AddItem( EIitemLbl[i] );
		EIListBox:AddItem( EIitemLblScore[i] );
	end
end