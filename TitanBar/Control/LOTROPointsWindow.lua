-- LOTROPointsWindow.lua
-- written by Habna


function frmLOTROPointsWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	_G.ControlData.LP = _G.ControlData.LP or {}
	_G.ControlData.LP.ui = _G.ControlData.LP.ui or {}
	local ui = _G.ControlData.LP.ui
	local wLP = CreateControlWindow(
		"LOTROPoints", "LP",
		L["MLotroPoints"], 300, 80,
		{
			onKeyDown = function(sender, args)
				if args.Action == Constants.KEY_ENTER then
					if buttonSave then buttonSave.Click(sender, args) end
					if ui.window then ui.window:Close() end
				end
			end,
			onClosing = function(sender, args)
				_G.ControlData.LP.ui = nil
			end
		}
	)
	ui.window = wLP


	local LPWCtr = Turbine.UI.Control();
	LPWCtr:SetParent( wLP );
	LPWCtr:SetPosition( 15, 50 );
	LPWCtr:SetZOrder( 2 );
	--LPWCtr:SetBackColor( Color["red"] ); -- debug purpose

	local lblLOTROPTS = CreateTitleLabel(LPWCtr, L["MLotroPoints"], 0, 2, nil, Color["rustedgold"], 7.5, nil, 15, Turbine.UI.ContentAlignment.MiddleLeft)

	local lpData = _G.ControlData and _G.ControlData.LP
	local initialPoints = (lpData and lpData.points) or "0"
	local txtLOTROPTS = CreateInputTextBox(LPWCtr, initialPoints, lblLOTROPTS:GetLeft()+lblLOTROPTS:GetWidth()+5, lblLOTROPTS:GetTop()-2);
	if PlayerAlign == 2 then txtLOTROPTS:SetBackColor( Color["red"] ); end

	txtLOTROPTS.FocusGained = function( sender, args )
		txtLOTROPTS:SelectAll();
		txtLOTROPTS:SetWantsUpdates( true );
	end

	txtLOTROPTS.FocusLost = function( sender, args )
		txtLOTROPTS:SetWantsUpdates( false );
	end

	txtLOTROPTS.Update = function( sender, args )
		local parsed_text = txtLOTROPTS:GetText();

		if tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil then
			txtLOTROPTS:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			return
		elseif string.len(parsed_text) > 1 and string.sub(parsed_text,1,1) == "0" then
			txtLOTROPTS:SetText( string.sub( parsed_text, 2 ) );
			return
		end
	end

	buttonSave = CreateAutoSizedButton(LPWCtr, L["PWSave"], txtLOTROPTS:GetLeft()+txtLOTROPTS:GetWidth()+5, txtLOTROPTS:GetTop())

	buttonSave.Click = function( sender, args )
		local parsed_text = txtLOTROPTS:GetText();

		if parsed_text == "" then
			txtLOTROPTS:SetText( "0" );
			txtLOTROPTS:Focus();
			return
		else
			local lpData = _G.ControlData and _G.ControlData.LP
			local currentPoints = (lpData and lpData.points) or "0"
			if parsed_text == currentPoints then
				txtLOTROPTS:Focus();
				return
			end
		end

		_G.ControlData.LP = _G.ControlData.LP or {}
		_G.ControlData.LP.points = txtLOTROPTS:GetText();
		UpdateLOTROPoints();
		txtLOTROPTS:Focus();
	end

	LPWCtr:SetSize( lblLOTROPTS:GetWidth()+txtLOTROPTS:GetWidth()+buttonSave:GetWidth()+10, 20 );
	wLP:SetSize( LPWCtr:GetWidth()+30, 80 );

	txtLOTROPTS:Focus();
end