-- Create tables in _G
_G.createCurrencyTable = function(currencyName)
	_G.CurrencyData[currencyName].Ctr = Turbine.UI.Control()
	_G.CurrencyData[currencyName].Ctr:SetParent(TB.win)
	_G.CurrencyData[currencyName].Ctr:SetMouseVisible(false)
	_G.CurrencyData[currencyName].Ctr:SetZOrder(2)
	_G.CurrencyData[currencyName].Ctr:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
	_G.CurrencyData[currencyName].Ctr:SetBackColor(
		Turbine.UI.Color(
			_G.CurrencyData[currencyName].bcAlpha,
			_G.CurrencyData[currencyName].bcRed,
			_G.CurrencyData[currencyName].bcGreen,
			_G.CurrencyData[currencyName].bcBlue
		)
	)

	-- Currency icon on TitanBar
	_G.CurrencyData[currencyName].Icon = Turbine.UI.Control()
	_G.CurrencyData[currencyName].Icon:SetParent(_G.CurrencyData[currencyName].Ctr)
	_G.CurrencyData[currencyName].Icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
	_G.CurrencyData[currencyName].Icon:SetSize(32, 32)
	_G.CurrencyData[currencyName].Icon:SetBackground(WalletItem[currencyName].Icon)

	-- Icon event handlers
	_G.CurrencyData[currencyName].Icon.MouseMove = function(sender, args)
		_G.CurrencyData[currencyName].Lbl.MouseLeave(sender, args)
		TB.win.MouseMove()
		if dragging then
			MoveCurrencyCtr(sender, args, currencyName)
		end
	end

	_G.CurrencyData[currencyName].Icon.MouseLeave = function(sender, args)
		_G.CurrencyData[currencyName].Lbl.MouseLeave(sender, args)
	end

	_G.CurrencyData[currencyName].Icon.MouseClick = function(sender, args)
		_G.CurrencyData[currencyName].Lbl.MouseClick(sender, args)
	end

	_G.CurrencyData[currencyName].Icon.MouseDown = function(sender, args)
		_G.CurrencyData[currencyName].Lbl.MouseDown(sender, args)
	end

	_G.CurrencyData[currencyName].Icon.MouseUp = function(sender, args)
		_G.CurrencyData[currencyName].Lbl.MouseUp(sender, args)
	end

	-- Currency label on TitanBar
	_G.CurrencyData[currencyName].Lbl = Turbine.UI.Label()
	_G.CurrencyData[currencyName].Lbl:SetParent(_G.CurrencyData[currencyName].Ctr)
	_G.CurrencyData[currencyName].Lbl:SetFont(_G.TBFont)
	_G.CurrencyData[currencyName].Lbl:SetPosition(0, 0)
	_G.CurrencyData[currencyName].Lbl:SetFontStyle(Turbine.UI.FontStyle.Outline)
	_G.CurrencyData[currencyName].Lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)

	-- Label event handlers
	_G.CurrencyData[currencyName].Lbl.MouseMove = function(sender, args)
		_G.CurrencyData[currencyName].Lbl.MouseLeave(sender, args)
		TB.win.MouseMove()
		if dragging then
			MoveCurrencyCtr(sender, args, currencyName)
		else
			ShowToolTipWin(currencyName)
		end
	end

	_G.CurrencyData[currencyName].Lbl.MouseLeave = function(sender, args)
		ResetToolTipWin()
	end

	_G.CurrencyData[currencyName].Lbl.MouseClick = function(sender, args)
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

	_G.CurrencyData[currencyName].Lbl.MouseDown = function(sender, args)
		if args.Button == Turbine.UI.MouseButton.Left then
			_G.CurrencyData[currencyName].Ctr:SetZOrder(3)
			dragStartX = args.X
			dragStartY = args.Y
			dragging = true
		end
	end

	_G.CurrencyData[currencyName].Lbl.MouseUp = function(sender, args)
		_G.CurrencyData[currencyName].Ctr:SetZOrder(2)
		dragging = false
		_G.CurrencyData[currencyName].LocX = _G.CurrencyData[currencyName].Ctr:GetLeft()
		settings[currencyName].X = string.format("%.0f", _G.CurrencyData[currencyName].LocX)
		_G.CurrencyData[currencyName].LocY = _G.CurrencyData[currencyName].Ctr:GetTop()
		settings[currencyName].Y = string.format("%.0f", _G.CurrencyData[currencyName].LocY)
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