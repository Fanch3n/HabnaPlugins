import(AppDirD .. "UIHelpers")
import(AppDirD .. "ControlFactory")

function LoadPlayerLOTROPoints()
	PlayerLOTROPoints = Turbine.PluginData.Load(Turbine.DataScope.Account, "TitanBarLOTROPoints") or {}
	PlayerLOTROPoints["PTS"] = PlayerLOTROPoints.PTS or "0"
	_G.ControlData.LP = _G.ControlData.LP or {}
	_G.ControlData.LP.points = PlayerLOTROPoints.PTS;
	SavePlayerLOTROPoints()
end

function SavePlayerLOTROPoints()
	local lpData = _G.ControlData and _G.ControlData.LP
	local points = (lpData and tonumber(lpData.points)) or 0
	PlayerLOTROPoints = PlayerLOTROPoints or {}
	PlayerLOTROPoints["PTS"] = string.format("%.0f", points);
	Turbine.PluginData.Save(Turbine.DataScope.Account, "TitanBarLOTROPoints", PlayerLOTROPoints);
end

function UpdateLOTROPoints()
	local where = (_G.ControlData and _G.ControlData.LP and _G.ControlData.LP.where) or Constants.Position.NONE
	if where == Constants.Position.TITANBAR then
		local lpData = _G.ControlData and _G.ControlData.LP
		local points = (lpData and tonumber(lpData.points)) or 0
		_G.ControlData.LP.controls["Lbl"]:SetText(tostring(points))
		_G.ControlData.LP.controls["Lbl"]:SetSize(_G.ControlData.LP.controls["Lbl"]:GetTextLength() * NM, CTRHeight)
		AdjustIcon("LP")
	end
	SavePlayerLOTROPoints()
end

function InitializeLOTROPoints()
	_G.ControlData.LP.controls = _G.ControlData.LP.controls or {}
	local LP = _G.ControlData.LP.controls

	local colors = _G.ControlData.LP.colors

	if not LP["Ctr"] then
		CreateTitanBarControl(LP, colors.alpha, colors.red, colors.green, colors.blue)
		_G.ControlData.LP.ui.control = LP["Ctr"]

		LP["Icon"] = CreateControlIcon(LP["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE,
			_G.resources.LOTROPoints, Turbine.UI.BlendMode.AlphaBlend, 1, Constants.LOTRO_POINTS_ICON_WIDTH,
			Constants.LOTRO_POINTS_ICON_HEIGHT)

		LP["Lbl"] = CreateControlLabel(LP["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

		SetupControlInteraction({
			icon = LP["Lbl"],
			controlTable = LP,
			settingsSection = settings.LOTROPoints,
			windowImportPath = AppCtrD .. "LOTROPointsWindow",
			windowFunction = "frmLOTROPointsWindow",
			tooltipKey = "LP",
			leaveControl = LP["Lbl"]
		})

		DelegateMouseEvents(LP["Icon"], LP["Lbl"])
	end

	local lpWhere = (_G.ControlData.LP and _G.ControlData.LP.where) or Constants.Position.NONE
	if lpWhere == Constants.Position.TITANBAR then
		if LP["Ctr"] then
			LP["Ctr"]:SetPosition(_G.ControlData.LP.location.x, _G.ControlData.LP.location.y)
		end
		UpdateLOTROPoints()
	end

	if lpWhere ~= Constants.Position.NONE then
		if LPcb then
			RemoveCallback(Turbine.Chat, "Received", LPcb); LPcb = nil;
		end

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
						local tmpLP = string.match(tpMess, tpPattern);
						if tmpLP ~= nil then
							LPTS = tmpLP;
							_G.ControlData.LP = _G.ControlData.LP or {}
							local currentPoints = tonumber(_G.ControlData.LP.points) or 0
							_G.ControlData.LP.points = tostring(currentPoints + tonumber(LPTS));
							UpdateLOTROPoints()
						end
					end
				end
			end);
	else
		if LPcb then
			RemoveCallback(Turbine.Chat, "Received", LPcb); LPcb = nil;
		end
	end
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "LP",
		settingsKey = "LOTROPoints",
		hasWhere = true,
		defaults = { show = false, where = 3, x = 0, y = 0 },
		initFunc = InitializeLOTROPoints
	})
end

_G.LoadPlayerLOTROPoints = LoadPlayerLOTROPoints
_G.SavePlayerLOTROPoints = SavePlayerLOTROPoints
_G.UpdateLOTROPoints = UpdateLOTROPoints
