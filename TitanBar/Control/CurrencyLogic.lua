-- Create tables in _G
import(AppDirD .. "UIHelpers")

_G.createCurrencyTable = function(currencyName)
	local currencyData = _G.CurrencyData[currencyName]
	currencyData.Ctr = Turbine.UI.Control()
	currencyData.Ctr:SetParent(TB.win)
	currencyData.Ctr:SetMouseVisible(false)
	currencyData.Ctr:SetZOrder(2)
	currencyData.Ctr:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
	currencyData.Ctr:SetBackColor(
		Turbine.UI.Color(
			currencyData.bcAlpha,
			currencyData.bcRed,
			currencyData.bcGreen,
			currencyData.bcBlue
		)
	)

	-- Currency icon on TitanBar
	currencyData.Icon = Turbine.UI.Control()
	currencyData.Icon:SetParent(currencyData.Ctr)
	currencyData.Icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)

	if currencyName == "DestinyPoints" then
		currencyData.Icon:SetSize(21, 22)
	else
		currencyData.Icon:SetSize(32, 32)
	end
	currencyData.Icon:SetBackground(_G.currencies.byName[currencyName].icon)

	-- Icon event handlers
	currencyData.Icon.MouseMove = function(sender, args)
		currencyData.Lbl.MouseLeave(sender, args)
		TB.win.MouseMove()
		if dragging then
			MoveCurrencyCtr(sender, args, currencyName)
		else
			ShowToolTipWin(currencyName)
		end
	end

	currencyData.Icon.MouseLeave = function(sender, args)
		currencyData.Lbl.MouseLeave(sender, args)
	end

	currencyData.Icon.MouseClick = function(sender, args)
		currencyData.Lbl.MouseClick(sender, args)
	end

	currencyData.Icon.MouseDown = function(sender, args)
		currencyData.Lbl.MouseDown(sender, args)
	end

	currencyData.Icon.MouseUp = function(sender, args)
		currencyData.Lbl.MouseUp(sender, args)
	end

	-- Currency label on TitanBar
	currencyData.Lbl = Turbine.UI.Label()
	currencyData.Lbl:SetParent(currencyData.Ctr)
	currencyData.Lbl:SetFont(_G.TBFont)
	currencyData.Lbl:SetPosition(0, 0)
	currencyData.Lbl:SetFontStyle(Turbine.UI.FontStyle.Outline)
	if currencyName == "DestinyPoints" then
		currencyData.Lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
	else
		currencyData.Lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
	end

	-- Label event handlers
	currencyData.Lbl.MouseMove = function(sender, args)
		currencyData.Lbl.MouseLeave(sender, args)
		TB.win.MouseMove()
		if dragging then
			MoveCurrencyCtr(sender, args, currencyName)
		else
			ShowToolTipWin(currencyName)
		end
	end

	currencyData.Lbl.MouseLeave = function(sender, args)
		ResetToolTipWin()
	end

	currencyData.Lbl.MouseClick = function(sender, args)
		TB.win.MouseMove()
		if args.Button == Turbine.UI.MouseButton.Left then
			if not WasDrag then
			end
		elseif args.Button == Turbine.UI.MouseButton.Right then
			_G.sFromCtr = currencyName
			ControlMenu:ShowMenu()
		end
		WasDrag = false
	end

	currencyData.Lbl.MouseDown = function(sender, args)
		if args.Button == Turbine.UI.MouseButton.Left then
			StartDrag(currencyData.Ctr, args)
		end
	end

	currencyData.Lbl.MouseUp = function(sender, args)
		currencyData.Ctr:SetZOrder(2)
		_G.dragging = false
		-- Note: SaveControlPosition expects global var names without _G prefix
		local globalXVarName = currencyName .. "LocX"
		local globalYVarName = currencyName .. "LocY"
		local x = currencyData.Ctr:GetLeft()
		local y = currencyData.Ctr:GetTop()
		currencyData.LocX = x
		currencyData.LocY = y
		settings[currencyName].X = string.format("%.0f", x)
		settings[currencyName].Y = string.format("%.0f", y)
		SaveSettings(false)
	end
end

function MoveCurrencyCtr(sender, args, currencyName)
	local ctr = _G.CurrencyData[currencyName].Ctr
	local ctrWidth, ctrHeight = ctr:GetSize()
	local ctrLocX, ctrLocY = ctr:GetPosition()

	-- calculate new position based on mouse movement
	ctrLocX = ctrLocX + args.X - dragStartX
	ctrLocY = ctrLocY + args.Y - dragStartY

	-- keep the control within the window bounds
	if ctrLocX < 0 then
		ctrLocX = 0
	elseif ctrLocX + ctrWidth > screenWidth then
		ctrLocX = screenWidth - ctrWidth
	end

	if ctrLocY < 0 then
		ctrLocY = 0
	elseif ctrLocY + ctrHeight > TB["win"]:GetHeight() then
		ctrLocY = TB["win"]:GetHeight() - ctrHeight
	end

	-- set the new position and mark as dragged
	ctr:SetPosition(ctrLocX, ctrLocY)
	WasDrag = true
end