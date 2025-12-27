-- LOTROPointsWindow.lua
-- written by Habna


function frmLOTROPointsWindow()
	import(AppDirD .. "WindowFactory")
	import(AppDirD .. "UIHelpers")
	_G.wLP = CreateWindow({
		text = L["MLotroPoints"],
		width = 300,
		height = 80,
		left = LPWLeft,
		top = LPWTop,
		config = {
			settingsKey = "LOTROPoints",
			windowGlobalVar = "wLP",
			formGlobalVar = "frmLP",
			onPositionChanged = function(left, top)
				LPWLeft, LPWTop = left, top
			end,
			onClosing = function(sender, args)
				-- nothing extra required
			end,
			onKeyDown = function(sender, args)
				if args.Action == Constants.KEY_ENTER then -- Enter
					if buttonSave then buttonSave.Click(sender, args) end
					if _G.wLP then _G.wLP:Close() end
					return
				end
			end
		}
	})


	local LPWCtr = Turbine.UI.Control();
	LPWCtr:SetParent( _G.wLP );
	LPWCtr:SetPosition( 15, 50 );
	LPWCtr:SetZOrder( 2 );
	--LPWCtr:SetBackColor( Color["red"] ); -- debug purpose

	local lblLOTROPTS = CreateTitleLabel(LPWCtr, L["MLotroPoints"], 0, 2, nil, Color["rustedgold"], 7.5, nil, 15, Turbine.UI.ContentAlignment.MiddleLeft)

	local txtLOTROPTS = CreateInputTextBox(LPWCtr, _G.LOTROPTS, lblLOTROPTS:GetLeft()+lblLOTROPTS:GetWidth()+5, lblLOTROPTS:GetTop()-2);
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
		elseif parsed_text == _G.LOTROPTS then
			txtLOTROPTS:Focus();
			return
		end

		_G.LOTROPTS = txtLOTROPTS:GetText();
		UpdateLOTROPoints();
		txtLOTROPTS:Focus();
	end

	LPWCtr:SetSize( lblLOTROPTS:GetWidth()+txtLOTROPTS:GetWidth()+buttonSave:GetWidth()+10, 20 );
	_G.wLP:SetSize( LPWCtr:GetWidth()+30, 80 );

	txtLOTROPTS:Focus();
end