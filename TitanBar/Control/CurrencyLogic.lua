-- Create tables in _G
_G.createCurrencyTable = function(currencyName)
	_G[currencyName] = {}

	-- Control of currency
	_G[currencyName].Ctr = Turbine.UI.Control()
	_G[currencyName].Ctr:SetParent(TB.win)
	_G[currencyName].Ctr:SetMouseVisible(false)
	_G[currencyName].Ctr:SetZOrder(2)
	_G[currencyName].Ctr:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
	_G[currencyName].Ctr:SetBackColor(
		Turbine.UI.Color(
			_G[currencyName .. bcAlpha],
			_G[currencyName .. bcRed],
			_G[currencyName .. bcGreen],
			_G[currencyName .. bcBlue]
		)
	)
	_G[currencyName].Ctr:SetBackColor(Turbine.UI.Color(DWbcAlpha, DWbcRed, DWbcGreen, DWbcBlue))

	-- Currency icon on TitanBar
	_G[currencyName].Icon = Turbine.UI.Control()
	_G[currencyName].Icon:SetParent(_G[currencyName].Ctr)
	_G[currencyName].Icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend)
	_G[currencyName].Icon:SetSize(32, 32)
	_G[currencyName].Icon:SetBackground(WalletItem[mapping[currencyName]].Icon)

	-- Icon event handlers
	_G[currencyName].Icon.MouseMove = function(sender, args)
		_G[currencyName].Lbl.MouseLeave(sender, args)
		TB.win.MouseMove()
		if dragging then
			MoveCurrencyCtr(sender, args, currencyName)
		end
	end

	_G[currencyName].Icon.MouseLeave = function(sender, args)
		_G[currencyName].Lbl.MouseLeave(sender, args)
	end

	_G[currencyName].Icon.MouseClick = function(sender, args)
		_G[currencyName].Lbl.MouseClick(sender, args)
	end

	_G[currencyName].Icon.MouseDown = function(sender, args)
		_G[currencyName].Lbl.MouseDown(sender, args)
	end

	_G[currencyName].Icon.MouseUp = function(sender, args)
		_G[currencyName].Lbl.MouseUp(sender, args)
	end

	-- Currency label on TitanBar
	_G[currencyName].Lbl = Turbine.UI.Label()
	_G[currencyName].Lbl:SetParent(_G[currencyName].Ctr)
	_G[currencyName].Lbl:SetFont(_G.TBFont)
	_G[currencyName].Lbl:SetPosition(0, 0)
	_G[currencyName].Lbl:SetFontStyle(Turbine.UI.FontStyle.Outline)
	_G[currencyName].Lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)

	-- Label event handlers
	_G[currencyName].Lbl.MouseMove = function(sender, args)
		_G[currencyName].Lbl.MouseLeave(sender, args)
		TB.win.MouseMove()
		if dragging then
			MoveCurrencyCtr(sender, args, currencyName)
		else
			ShowToolTipWin(currencyName)
		end
	end

	_G[currencyName].Lbl.MouseLeave = function(sender, args)
		ResetToolTipWin()
	end

	_G[currencyName].Lbl.MouseClick = function(sender, args)
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

	_G[currencyName].Lbl.MouseDown = function(sender, args)
		if args.Button == Turbine.UI.MouseButton.Left then
			_G[currencyName].Ctr:SetZOrder(3)
			dragStartX = args.X
			dragStartY = args.Y
			dragging = true
		end
	end

	_G[currencyName].Lbl.MouseUp = function(sender, args)
		_G[currencyName].Ctr:SetZOrder(2)
		dragging = false
		_G[currencyName .. "LocX"] = _G[currencyName].Ctr:GetLeft()
		settings[mapping[currencyName]].X = string.format("%.0f", _G[currencyName .. "LocX"])
		_G[currencyName .. "LocY"] = _G[currencyName].Ctr:GetTop()
		settings[mapping[currencyName]].Y = string.format("%.0f", _G[currencyName .. "LocY"])
		SaveSettings(false)
	end
end

mapping = {
	DW = "DelvingWrit",
	BOD = "BadgeOfDishonour",
	CP = "Commendation",
	AS = "AncientScript",
	BOT = "BadgeOfTaste",
	BB = "BingoBadge",
	LAT = "AnniversaryToken",
	EOE = "EmbersOfEnchantment",
	MST = "MidsummerToken",
	SPL = "SpringLeaf",
	FFAT = "FarmersFaireToken",
	FFT = "FallFestivalToken",
	MOE = "MotesOfEnchantment",
	FOS = "FigmentsOfSplendour",
	GGB = "GiftgiversBrand",
	CGSP = "CentralGondorSilverPiece",
	SOM = "StarsofMerit",
	ASP = "AmrothSilverPiece",
	SL = "Seals",
	MP = "Medallions",
	HT = "TokensOfHytbold",
	YT = "YuleToken",
	MC = "MithrilCoins",
	SM = "SkirmishMarks",
	SP = "Shards"
}

function MoveCurrencyCtr(sender, args, currencyName)
	local ctr = _G[currencyName]["Ctr"]
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

--for k,v in pairs(mapping) do
--	createCurrencyTable(k)
--end
