-- DurabilityInfosToolTip.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")


SlotsText = {L["EWST1"], L["EWST2"], L["EWST3"], L["EWST4"], L["EWST5"], L["EWST6"], L["EWST7"], L["EWST8"], L["EWST9"],
		L["EWST10"], L["EWST11"], L["EWST12"], L["EWST13"], L["EWST14"], L["EWST15"], L["EWST16"], L["EWST17"],	L["EWST18"],
		L["EWST19"], L["EWST20"]};

function ShowDIWindow()
	-- ( offsetX, offsetY, width, height, bubble side )
	--x, y, w, h = -5, -15, 0, 0;
	--mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	
	--if w + mouseX > screenWidth then x = w - 10; end
	
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	--_G.ToolTipWin.xOffset = x;
	--_G.ToolTipWin.yOffset = y;
	_G.ToolTipWin:SetVisible( true );
	
	DIListBox = Turbine.UI.ListBox();
	DIListBox:SetParent( _G.ToolTipWin );
	DIListBox:SetZOrder( 1 );
	DIListBox:SetPosition( 15, 12 );
	ConfigureListBox(DIListBox)
	--DIListBox:SetBackColor( Color["darkgrey"] ); --debug purpose

	DIRefreshListBox();

	ApplySkin();
end

function DIRefreshListBox()
	local DIitemCtl = {};
	local Lblnint = {};
	local DIitemLbl = {};
	local DIitemLblScore = {};
	local DIitemBG, DIitemU, DIitemS, DIitem = {}, {}, {}, {};
	DIListBox:ClearItems();
	DITTPosY = 36;

	mis, mts, nint = 0, 0, false;

	if not DIIcon and not DIText then nint=true; end

	iFound = 0;

	for i = 1, #itemEquip do
		for k,v in pairs(itemEquip[i]) do
			if itemEquip[i].WearStatePts ~= 100 and itemEquip[i].WearState ~= 0 then
				iFound = iFound + 1; -- Count damaged item
				break
			end
		end
	end

	if iFound == 0 or nint then
		cw=250;
		local lblName = Turbine.UI.Label();
		lblName:SetParent( _G.ToolTipWin );
		--lblName:SetFont ( 12 );
		lblName:SetText( L["DWLblND"] );
		if iFound ~= 0 then
			if nint then
				if iFound == 1 then	lblName:SetText( "1 ".. L["DWLbl"].. "\n" .. L["DWnint"] );
				else lblName:SetText( iFound .. L["DWLbls"].. "\n" .. L["DWnint"] ); end
			cw=215;
			end
		end
		lblName:SetPosition( 0, 0 );
		lblName:SetSize( Constants.LABEL_WIDTH_EXTRA_WIDE, Constants.LABEL_HEIGHT_ITEM );
		lblName:SetForeColor( Color["green"] );
		lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		--lblName:SetBackColor( Color["red"] ); -- debug purpose

		DIListBox:SetWidth( Constants.LABEL_WIDTH_TOOLTIP );
		DIListBox:AddItem( lblName );
		
		DITTPosY = DITTPosY + 36;
	else
		for i = 1, 20 do
			if itemEquip[i].WearStatePts ~= 100 and itemEquip[i].WearState ~= 0 then
				cw=32;
				iFound = iFound + 1;

				TheColor = Color["SSGYellow"];
				if itemEquip[i].WearStatePts == "20" then TheColor = Color["orange"];
				elseif itemEquip[i].WearStatePts == "0" then TheColor = Color["red"]; end

				-- Item control
				DIitemCtl[i] = Turbine.UI.Control();
				DIitemCtl[i]:SetParent( DIListBox );
				--DIitemCtl[i]:SetSize( cw-mis-mts, 36 );
				DIitemCtl[i]:SetHeight( 36 );
				--DIitemCtl[i]:SetBackColor( Color["red"] ); -- debug purpose


				if DIIcon then
					-- Item Background/Underlay/Shadow/Item
				DIitemBG[i] = CreateControl(Turbine.UI.Control, DIitemCtl[i], 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
				DIitemBG[i]:SetBackground(itemEquip[i].BImgID);
				DIitemBG[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	
				DIitemU[i] = CreateControl(Turbine.UI.Control, DIitemCtl[i], 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
				DIitemU[i]:SetBackground(itemEquip[i].UImgID);
				DIitemU[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

				DIitemS[i] = CreateControl(Turbine.UI.Control, DIitemCtl[i], 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
				DIitemS[i]:SetBackground(itemEquip[i].SImgID);
				DIitemS[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

				DIitem[i] = CreateControl(Turbine.UI.Control, DIitemCtl[i], 0, 2, Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
				DIitem[i]:SetBackground(itemEquip[i].IImgID);
				DIitem[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

				-- Item Durability (over the icon)
				DIitemLblScore[i] = CreateControl(Turbine.UI.Label, DIitemCtl[i], 0, 26, 30, 15)
				DIitemLblScore[i]:SetText( itemEquip[i].WearStatePts .. "%" );
				DIitemLblScore[i]:SetForeColor( TheColor );
				DIitemLblScore[i]:SetFont( Turbine.UI.Lotro.Font.Verdana10 );
				DIitemLblScore[i]:SetFontStyle( Turbine.UI.FontStyle.Outline );
				DIitemLblScore[i]:SetOutlineColor( Color["black"] );
				DIitemLblScore[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
				--DIitemLblScore[i]:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
				else
					mis=37;
				end

				if DIText then
					cw=cw+208;
					-- Item name
					DIitemLbl[i] = CreateControl(Turbine.UI.Label, DIitemCtl[i], 37-mis, 2, 208, DIitemCtl[i]:GetHeight());
					DIitemLbl[i]:SetFont(Turbine.UI.Lotro.Font.TrajanPro12 );
					DIitemLbl[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
					--DIitemLbl[i]:SetForeColor( Color["white"] );
					--DIitemLbl[i]:SetBackColor( Color["blue"] ); -- debug purpose
		
					if itemEquip[i].Item == false then 
						DIitemLbl[i]:SetForeColor( Color["red"] );
						DIitemLbl[i]:SetText( SlotsText[i] .. ":\n" .. L["EWItemNP"] );
					else
						DIitemLbl[i]:SetText( SlotsText[i] .. ":\n" .. itemEquip[i].Name );
					end
					DIitemLbl[i]:SetForeColor( TheColor );

					if not DIIcon then
						-- Item Durability
						DIitemLblScore[i] = Turbine.UI.Label();
						DIitemLblScore[i]:SetParent( DIitemCtl[i] );
						DIitemLblScore[i]:SetPosition( 250-mis, 0 );
						DIitemLblScore[i]:SetText( itemEquip[i].WearStatePts .. "%" );
						DIitemLblScore[i]:SetForeColor( TheColor );
						DIitemLblScore[i]:SetSize( 30, DIitemCtl[i]:GetHeight() );
						DIitemLblScore[i]:SetFont( Turbine.UI.Lotro.Font.TrajanPro12 );
						DIitemLblScore[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
						--DIitemLblScore[i]:SetBackColor( Color["grey"] ); -- debug purpose
					end
				end

				DIitemCtl[i]:SetWidth( cw );
				DIListBox:SetSize( cw, DITTPosY );

				DIListBox:AddItem( DIitemCtl[i] );
			
				DITTPosY = DITTPosY + 36;
			end
		end
	end

	if iFound == 0 then _G.ToolTipWin:SetSize( cw, DITTPosY-10 );
	else _G.ToolTipWin:SetSize( cw+30, DITTPosY-10 ); end

	PositionToolTipWindow();
end