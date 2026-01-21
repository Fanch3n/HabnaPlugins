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
		currencyData.Icon:SetSize(Constants.DESTINY_POINTS_ICON_WIDTH, Constants.DESTINY_POINTS_ICON_HEIGHT)
	else
		currencyData.Icon:SetSize(Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)
	end
	currencyData.Icon:SetBackground(_G.currencies.byName[currencyName].icon)

	-- Icon event handlers will be set up after the label is created

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

	-- Set up move handler and icon event handlers after label is created
	local MoveCurrencyCtr = CreateMoveHandler(currencyData.Ctr, currencyData.Lbl)

	currencyData.Icon.MouseMove = function(sender, args)
		currencyData.Lbl.MouseLeave(sender, args)
		TB.win.MouseMove()
		if dragging then
			MoveCurrencyCtr(sender, args)
		else
			TooltipManager.ShowStandard(currencyName)
		end
	end

	currencyData.Icon.MouseLeave = function(sender, args)
		currencyData.Lbl.MouseLeave(sender, args)
	end

	-- Label event handlers
	currencyData.Lbl.MouseMove = function(sender, args)
		currencyData.Lbl.MouseLeave(sender, args)
		TB.win.MouseMove()
		if dragging then
			MoveCurrencyCtr(sender, args)
		else
			TooltipManager.ShowStandard(currencyName)
		end
	end

	currencyData.Lbl.MouseLeave = function(sender, args)
		TooltipManager.HideStandard()
	end

	currencyData.Lbl.MouseClick = function(sender, args)
		TB.win.MouseMove()
		if args.Button == Turbine.UI.MouseButton.Left then
			if not _G.WasDrag then
			end
		elseif args.Button == Turbine.UI.MouseButton.Right then
			_G.sFromCtr = currencyName
			ControlMenu:ShowMenu()
		end
		_G.WasDrag = false
	end

	local dragHandlers = CreateDragHandlers(currencyData.Ctr, settings[currencyName], currencyName .. "LocX",
		currencyName .. "LocY")
	currencyData.Lbl.MouseDown = dragHandlers.MouseDown
	currencyData.Lbl.MouseUp = dragHandlers.MouseUp

	-- Delegate Icon events to Lbl (except MouseMove which has custom logic)
	DelegateMouseEvents(currencyData.Icon, currencyData.Lbl, { "MouseClick", "MouseDown", "MouseUp" })
end
