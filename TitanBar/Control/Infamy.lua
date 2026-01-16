import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")
import(AppCtrD .. "InfamyToolTip")

function InitializeInfamy()
	-- Use _G.ControlData.IF.controls for all UI controls
	local IF = {}
	_G.ControlData.IF.controls = IF

	local colors = _G.ControlData.IF.colors
	IF["Ctr"] = CreateTitanBarControl(IF, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.IF.ui.control = IF["Ctr"]

	IF["Icon"] = CreateControlIcon(IF["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

	SetupControlInteraction({
		icon = IF["Icon"],
		controlTable = IF,
		settingsSection = settings.Infamy,
		windowImportPath = AppCtrD .. "InfamyWindow",
		windowFunction = "frmInfamyWindow",
		customTooltipHandler = ShowIFWindow
	})

	-- Chat listener for earning points
	IFcb = AddCallback(Turbine.Chat, "Received",
		function(sender, args)
			if args.ChatType == Turbine.ChatType.Advancement then
				local ifMess = args.Message;
				if ifMess ~= nil then
					local ifPattern;
					if PlayerAlign == 1 then
						if GLocale == "en" then
							ifPattern = "earned ([%d%p]*) renown points";
						elseif GLocale == "fr" then
							ifPattern = "gagn\195\169 ([%d%p]*) points " ..
								"renomm\195\169e";
						elseif GLocale == "de" then
							ifPattern = "habt ([%d%p]*) Ansehenspunkte";
						end
					else
						if GLocale == "en" then
							ifPattern = "earned ([%d%p]*) infamy points";
						elseif GLocale == "fr" then
							ifPattern = "gagn\195\169 ([%d%p]*) points " ..
								"d'infamie";
						elseif GLocale == "de" then
							ifPattern = "habt ([%d%p]*) Verrufenheitspunkte";
						end
					end

					local tmpIF = string.match(ifMess,ifPattern);
					if tmpIF ~= nil then
						_G.ControlData.IF = _G.ControlData.IF or {}
						local currentPoints = tonumber(_G.ControlData.IF.points) or 0
						local delta = tonumber((string.gsub(tmpIF, "%p+", ""))) or 0
						_G.ControlData.IF.points = currentPoints + delta

						for i=0, 14 do
							if (_G.ControlData.IF.points >= _G.InfamyRanks[i]) and
								(_G.ControlData.IF.points < _G.InfamyRanks[i+1]) then
								_G.ControlData.IF.rank = i
								break
							end
						end
						settings.Infamy.P = string.format("%.0f", _G.ControlData.IF.points);
						settings.Infamy.K = string.format("%.0f", _G.ControlData.IF.rank or 0);
						SaveSettings( false );
						UpdateInfamy();
					end
				end
			end
		end);

	UpdateInfamy();
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "IF",
	settingsKey = "Infamy",
	hasWhere = true,
	defaults = { show = false, where = 1, x = 0, y = 0 },
	initFunc = InitializeInfamy
})

IF["Icon"] = CreateControlIcon(IF["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

SetupControlInteraction({
	icon = IF["Icon"],
	controlTable = IF,
	settingsSection = settings.Infamy,
	windowImportPath = AppCtrD .. "InfamyWindow",
	windowFunction = "frmInfamyWindow",
	customTooltipHandler = ShowIFWindow
})