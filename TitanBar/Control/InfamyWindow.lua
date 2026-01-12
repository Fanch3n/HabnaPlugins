-- InfamyWindow.lua
-- written by Habna


function frmInfamyWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")

	-- Create window via helper
	local wIF = CreateControlWindow(
		"Infamy", "IF",
		L["IFWTitle"], 300, 80,
		{
			onKeyDown = function(sender, args)
				if args.Action == Constants.KEY_ENTER then
					if buttonSave then buttonSave.Click(sender, args) end
				end
			end
		}
	)

	local IFWCtr = Turbine.UI.Control();
	IFWCtr:SetParent( wIF );
	IFWCtr:SetPosition( 15, 50 )
	IFWCtr:SetZOrder( 2 );
	--IFWCtr:SetBackColor( Color["red"] ); -- debug purpose

	local lblName = CreateTitleLabel(IFWCtr, L["IFIF"], 0, 2, nil, Color["rustedgold"], 7.5, nil, 15, Turbine.UI.ContentAlignment.MiddleLeft)

	_G.ControlData.IF = _G.ControlData.IF or {}
	local currentPoints = tonumber(_G.ControlData.IF.points) or 0
	local txtInfamy = CreateInputTextBox(IFWCtr, tostring(currentPoints), lblName:GetLeft()+lblName:GetWidth()+5, lblName:GetTop()-2);
	if PlayerAlign == 2 then txtInfamy:SetBackColor( Color["red"] ); end

	txtInfamy.FocusGained = function( sender, args )
		txtInfamy:SelectAll();
		txtInfamy:SetWantsUpdates( true );
	end

	txtInfamy.FocusLost = function( sender, args )
		txtInfamy:SetWantsUpdates( false );
	end

	txtInfamy.Update = function( sender, args )
		local parsed_text = txtInfamy:GetText();

		if tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil then
			txtInfamy:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			--txtInfamy:Focus();
			return
		elseif string.len(parsed_text) > 1 and string.sub(parsed_text,1,1) == "0" then
			txtInfamy:SetText( string.sub( parsed_text, 2 ) );
			return
		end
	end

	local buttonSave = CreateAutoSizedButton(IFWCtr, L["PWSave"], txtInfamy:GetLeft()+txtInfamy:GetWidth()+5, txtInfamy:GetTop())

	buttonSave.Click = function( sender, args )
		local parsed_text = txtInfamy:GetText();

		if parsed_text == "" then
			txtInfamy:SetText( "0" );
			txtInfamy:Focus();
			return
		elseif parsed_text == tostring(tonumber(_G.ControlData.IF.points) or 0) then
			txtInfamy:Focus();
			return
		end
		
		local newPoints = tonumber(parsed_text) or 0
		_G.ControlData.IF.points = newPoints
		
		for i = 0, 14 do
			if newPoints >= _G.InfamyRanks[i] and newPoints < _G.InfamyRanks[i+1] then
				_G.ControlData.IF.rank = i
				break
			end
		end

		settings.Infamy.P = string.format("%.0f", _G.ControlData.IF.points);
		settings.Infamy.K = string.format("%.0f", _G.ControlData.IF.rank or 0);
		SaveSettings( false );

		txtInfamy:Focus();

		UpdateInfamy();
	end

	IFWCtr:SetSize( lblName:GetWidth()+txtInfamy:GetWidth()+buttonSave:GetWidth()+10, 20 );
	wIF:SetSize( IFWCtr:GetWidth()+30, 80 );

	txtInfamy:Focus();
end