-- TooltipManager.lua
-- Centralizes tooltip state tracking so controls do not rely on per-control globals

TooltipManager = TooltipManager or {}

local tooltipStates = TooltipManager.__states or {}
TooltipManager.__states = tooltipStates

local function ensureState(key)
	local state = tooltipStates[key]
	if not state then
		state = { visible = false }
		tooltipStates[key] = state
	end
	return state
end

local function isWindowVisible(window)
	if window then
		local ok, visible = pcall(function()
			return window:IsVisible()
		end)
		if ok then
			return visible
		end
	end

	if _G.ToolTipWin then
		local ok, visible = pcall(function()
			return _G.ToolTipWin:IsVisible()
		end)
		if ok then
			return visible
		end
	end

	return false
end

local function defaultReposition()
	if type(PositionToolTipWindow) == "function" then
		PositionToolTipWindow()
	end
end

local function defaultHide()
	if type(ResetToolTipWin) == "function" then
		ResetToolTipWin()
	end
end

local function captureWindow(options)
	if options.getWindow then
		local ok, result = pcall(options.getWindow)
		if ok then
			return result
		else
			Turbine.Shell.WriteLine(string.format("TitanBar: tooltip getWindow failed for %s (%s)", options.key, result))
		end
	end
	return _G.ToolTipWin
end

function TooltipManager.Show(options)
	if not options or not options.key or not options.show then
		return
	end

	local state = ensureState(options.key)

	if state.visible and not isWindowVisible(state.window) then
		state.visible = false
		state.window = nil
	end

	if not state.visible then
		local ok, err = pcall(options.show)
		if not ok then
			Turbine.Shell.WriteLine(string.format("TitanBar: tooltip show failed for %s (%s)", options.key, err))
			return
		end

		state.visible = true
		if options.captureWindow ~= false then
			state.window = captureWindow(options)
		end
	else
		local reposition = options.reposition
		if reposition == nil then
			reposition = defaultReposition
		elseif reposition == false then
			reposition = nil
		end

		if reposition then
			local ok, err = pcall(reposition)
			if not ok then
				Turbine.Shell.WriteLine(string.format("TitanBar: tooltip reposition failed for %s (%s)", options.key, err))
			end
		end
	end
end

function TooltipManager.Hide(options)
	if not options or not options.key then
		return
	end

	local state = tooltipStates[options.key]
	if state then
		state.visible = false
		state.window = nil
	end

	local hideFn = options.hide
	if hideFn == nil then
		hideFn = defaultHide
	elseif hideFn == false then
		hideFn = nil
	end

	if hideFn then
		local ok, err = pcall(hideFn)
		if not ok then
			Turbine.Shell.WriteLine(string.format("TitanBar: tooltip hide failed for %s (%s)", options.key, err))
		end
	end
end

function TooltipManager.Reset(key)
	if key then
		local state = tooltipStates[key]
		if state then
			state.visible = false
			state.window = nil
		end
	else
		for _, state in pairs(tooltipStates) do
			state.visible = false
			state.window = nil
		end
	end
end

-- ============================================================================
-- Standard Tooltip Implementation (Console/Legacy Style)
-- ============================================================================

function TooltipManager.ApplySkin(window)
	if not window then return end
	local Box = _G.resources.Box

	local function createPart(name, x, y, width, height, background)
		local part = Turbine.UI.Control()
		part:SetParent(window)
		part:SetPosition(x, y)
		part:SetSize(width, height)
		part:SetBackground(background)
		part:SetMouseVisible(false)
	end

	local w, h = window:GetSize()
	
	createPart("topLeftCorner", 0, 0, 36, 36, Box.TopLeft)
	createPart("TopBar", 36, 0, w - 36, 37, Box.Top)
	createPart("topRightCorner", w - 36, 0, 36, 36, Box.TopRight)
	createPart("midLeft", 0, 36, 36, h - 36, Box.MidLeft)
	createPart("MidMid", 36, 36, w - 36, h - 36, Box.Middle)
	createPart("midRight", w - 36, 36, 36, h - 36, Box.MidRight)
	createPart("botLeftCorner", 0, h - 36, 36, 36, Box.BottomLeft)
	createPart("BotBar", 36, h - 36, w - 36, 36, Box.Bottom)
	createPart("botRightCorner", w - 36, h - 36, 36, 36, Box.BottomRight)
end

function TooltipManager.CreateStandardWindow(xOffset, yOffset, w, h, header, texts)
	-- Remove old global window if it exists to prevent overlap
	if _G.ToolTipWin then
		_G.ToolTipWin:SetVisible(false)
		_G.ToolTipWin = nil
	end

	local win = Turbine.UI.Window()
	_G.ToolTipWin = win -- legacy global reference
	win:SetSize(w, h)
	win:SetZOrder(Constants.ZORDER_TOOLTIP)
	win.xOffset = xOffset -- stored for positioning calculation
	win.yOffset = yOffset

	TooltipManager.ApplySkin(win)

	local lblheader = Turbine.UI.Label()
	lblheader:SetParent(win)
	lblheader:SetPosition(40, 7)
	lblheader:SetSize(w, h)
	lblheader:SetForeColor(Color["green"])
	lblheader:SetFont(Turbine.UI.Lotro.Font.Verdana16)
	lblheader:SetText(header)
	
	local YPos = 25
	if texts then
		for _, txt in ipairs(texts) do
			if txt then
				local lbltext = Turbine.UI.Label()
				lbltext:SetParent(win)
				lbltext:SetPosition(40, YPos)
				lbltext:SetSize(w, 15)
				lbltext:SetForeColor(Color["white"])
				lbltext:SetFont(Turbine.UI.Lotro.Font.Verdana14)
				lbltext:SetText(txt)
				YPos = YPos + 15
			end
		end
	end
	
	return win
end

function TooltipManager.HideStandard()
	if _G.ToolTipWin then
		_G.ToolTipWin:SetVisible(false)
		_G.ToolTipWin = nil
	end
end

function TooltipManager.ShowStandard(key)
	local w = 350
	local x, y = -5, -15
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition()
	local h = 80
	
	if TBLocale == "fr" then w = 315
	elseif TBLocale == "de" then
		if key == "DI" then w = 225 
		else w = 305 end
	end

	if w + mouseX > screenWidth then
		x = w - 10
	end

	if not TBTop then
		y = h
	end

	local header
	local texts = {}

	local headerKeys = {
		BI = "MBI",
		GT = "GTh",
		VT = "MVault",
		SS = "MStorage",
		DN = "MDayNight",
		LP = "LotroPointsh",
	}

	if headerKeys[key] then
		header = L[headerKeys[key]]
		table.insert(texts, L["EIt1"]) -- Left click to move
		table.insert(texts, L["EIt2"]) -- Right click options
		table.insert(texts, L["EIt3"]) -- Ctrl + Left click
	elseif key == "DP" or key == "PL" or (_G.currencies and _G.currencies.byName[key]) then
		h = 65
		header = L[key .. "h"]
		table.insert(texts, L["EIt2"])
		table.insert(texts, L["EIt3"])
	elseif key == "IF" then
		h = 65
		header = L["Infamyh"]
		table.insert(texts, L["EIt2"])
		table.insert(texts, L["EIt3"])
	else
		Turbine.Shell.WriteLine("TitanBar: Unknown tooltip key " .. tostring(key))
		return
	end

	local win = TooltipManager.CreateStandardWindow(x, y, w, h, header, texts)
	win:SetPosition(mouseX - win.xOffset, mouseY - win.yOffset)
	win:SetVisible(true)
end
