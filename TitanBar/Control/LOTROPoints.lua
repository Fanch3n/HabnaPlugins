import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function InitializeLOTROPoints()
	local LP = {}
	_G.ControlData.LP.controls = LP

	local colors = _G.ControlData.LP.colors
	LP["Ctr"] = CreateTitanBarControl(LP, colors.alpha, colors.red, colors.green, colors.blue)
	_G.ControlData.LP.ui.control = LP["Ctr"]

	LP["Icon"] = CreateControlIcon(LP["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE, _G.resources.LOTROPoints, Turbine.UI.BlendMode.AlphaBlend, 1, Constants.LOTRO_POINTS_ICON_WIDTH, Constants.LOTRO_POINTS_ICON_HEIGHT)

	LP["Lbl"] = CreateControlLabel(LP["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

	SetupControlInteraction({
		icon = LP["Lbl"],
		controlTable = LP,
		settingsSection = settings.LOTROPoints,
		windowImportPath = AppCtrD .. "LOTROPointsWindow",
		windowFunction = "frmLOTROPointsWindow"
	})

	DelegateMouseEvents(LP["Icon"], LP["Lbl"])

	-- Chat listener for earning points
	LPcb = AddCallback(Turbine.Chat, "Received",
		function(sender, args)
			if args.ChatType == Turbine.ChatType.Advancement then
				local tpMess = args.Message;
				if tpMess ~= nil then
					local tpPattern;
					if GLocale == "en" then
						tpPattern = "earned ([%d%p]*) LOTRO Points";
					elseif GLocale == "fr" then
						tpPattern = "gagn\195\169 ([%d%p]*) points LOTRO";
					elseif GLocale == "de" then
						tpPattern = "habt ([%d%p]*) Punkte erhalten";
					end
					local tmpLP = string.match(tpMess,tpPattern);
					if tmpLP ~= nil then
						_G.ControlData.LP.points = tostring((tonumber(_G.ControlData.LP.points) or 0) + tonumber(tmpLP));
						UpdateLOTROPoints()
					end
				end
			end
		end);
	
	-- Initial update
	UpdateLOTROPoints()
end

-- Self-registration
_G.ControlRegistry.Register({
	id = "LP",
	settingsKey = "LOTROPoints",
	hasWhere = true,
	defaults = { show = false, where = 3, x = 0, y = 0 },
	initFunc = InitializeLOTROPoints
})
