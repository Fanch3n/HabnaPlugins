import(AppDirD .. "UIHelpers")
import(AppCtrD .. "PlayerInfosToolTip")
import(AppDirD .. "ControlFactory")

function InitializePlayerInfos()
	-- Use _G.ControlData.PI.controls for all UI controls
	local PI = {}
	_G.ControlData.PI.controls = PI

	local colors = _G.ControlData.PI.colors
	PI["Ctr"] = CreateTitanBarControl(PI, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.PI.ui.control = PI["Ctr"]

	PI["Icon"] = CreateControlIcon(PI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

	PI["Lvl"] = CreateControlLabel(PI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

	PI["Name"] = CreateControlLabel(PI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleLeft)

	SetupControlInteraction({
		icon = PI["Name"],
		controlTable = PI,
		settingsSection = settings.PlayerInfos,
		onLeftClick = function() end,
		customTooltipHandler = ShowPIWindow
	})

	DelegateMouseEvents(PI["Icon"], PI["Name"])
	DelegateMouseEvents(PI["Lvl"], PI["Name"])

	-- Callbacks
	AddCallback(Player, "LevelChanged",
		function(sender, args)
			PI["Lvl"]:SetText( tostring(Player:GetLevel()) );
			PI["Lvl"]:SetSize( PI["Lvl"]:GetTextLength() * NM+1, CTRHeight );
			PI["Name"]:SetPosition( PI["Lvl"]:GetLeft() + PI["Lvl"]:GetWidth() + 5, 0 );
		end);

	AddCallback(Player, "NameChanged",
		function(sender, args)
			PI["Name"]:SetText( Player:GetName() );
			PI["Name"]:SetSize( PI["Name"]:GetTextLength() * TM, CTRHeight );
			AdjustIcon("PI");
		end);

	XPcb = AddCallback(Turbine.Chat, "Received",
		function(sender, args)
			if args.ChatType == Turbine.ChatType.Advancement then
				local xpMess = args.Message;
				if xpMess ~= nil then
					local xpPattern;
					if GLocale == "en" then
						xpPattern = "total of ([%d%p]*) XP";
					elseif GLocale == "fr" then
						xpPattern = "de ([%d%p]*) points d'exp\195\169rience";
					elseif GLocale == "de" then
						xpPattern = "\195\188ber ([%d%p]*) EP";
					end
					local tmpXP = string.match(xpMess,xpPattern);
					if tmpXP ~= nil then
						_G.ControlData.PI.xp = tmpXP;
						settings.PlayerInfos.XP = tmpXP;
						SaveSettings( false );
					end
				end
			end
		end);

	UpdatePlayersInfos();
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "PI",
	settingsKey = "PlayerInfos",
	hasWhere = true,
	defaults = { show = true, where = 1, x = 0, y = 0 },
	initFunc = InitializePlayerInfos
})
--**^