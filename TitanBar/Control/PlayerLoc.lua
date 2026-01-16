-- PlayerLoc.lua
-- Written by Habna

import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function InitializePlayerLoc()
	local PL = {}
	_G.ControlData.PL.controls = PL

	local colors = _G.ControlData.PL.colors
	PL["Ctr"] = CreateTitanBarControl(PL, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.PL.ui.control = PL["Ctr"]

	PL["Lbl"] = CreateControlLabel(PL["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleLeft)

	SetupControlInteraction({
		icon = PL["Lbl"],
		controlTable = PL,
		settingsSection = settings.PlayerLoc,
		onLeftClick = function() end
	})

	-- Chat listener for location changes
	PLcb = AddCallback(Turbine.Chat, "Received",
		function(sender, args)
			if args.ChatType == Turbine.ChatType.Standard then
				local plMess = args.Message;
				if plMess ~= nil then
					local plPattern;
					if GLocale == "en" then
						plPattern = "Entered the%s+(.-)%s*%-";
					elseif GLocale == "fr" then
						plPattern = "Canal%s+(.-)%s*%-";
					elseif GLocale == "de" then
						plPattern = "Chat%-Kanal%s+'(.-)%s*%-";
					end

					local tmpPL = string.match( plMess, plPattern );
					if tmpPL ~= nil then
						_G.ControlData.PL.text = tmpPL
						UpdatePlayerLoc( tmpPL );
						settings.PlayerLoc.L = string.format( tmpPL );
						SaveSettings( false );
					end
				end
			end
		end);

	local plText = (_G.ControlData.PL and _G.ControlData.PL.text) or (settings.PlayerLoc and settings.PlayerLoc.L) or L["PLMsg"]
	UpdatePlayerLoc( plText );
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "PL",
	settingsKey = "PlayerLoc",
	hasWhere = true,
	defaults = { show = false, where = 1, x = 0, y = 0 },
	initFunc = InitializePlayerLoc
})
--**^