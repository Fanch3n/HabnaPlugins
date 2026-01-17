-- ReputationWindow.lua
-- Written by many


local function CreateCheckBox(parent, text, left, top, width, height, checked, foreColor, font, alignment)
    local cb = Turbine.UI.Lotro.CheckBox()
    cb:SetParent(parent)
    if text ~= nil then cb:SetText(text) end
    cb:SetPosition(left or 0, top or 0)
    if font then cb:SetFont(font) end
    if alignment then cb:SetTextAlignment(alignment) end
    cb:SetForeColor(foreColor or Color["rustedgold"])
    if checked ~= nil then cb:SetChecked(checked) end
    local h = height or 20
    local w = width
    if w == nil then
        w = cb:GetTextLength() * 8.5
    end
    cb:SetSize(w, h)
    return cb
end


function frmReputationWindow()
    _G.SelectedFaction = nil;
    import(AppClassD.."ComboBox");
    import(AppDirD .. "WindowFactory")
    import(AppDirD .. "UIHelpers")
	local rpData = _G.ControlData and _G.ControlData.RP
	if not rpData then return end
	rpData.ui = rpData.ui or {}
	local ui = rpData.ui

    local RPDD = HabnaPlugins.TitanBar.Class.ComboBox();
    ui.RPDD = RPDD

	-- Create window via helper for consistent behavior
	local wRP = CreateControlWindow(
		"Reputation", "RP",
		L["MReputation"], 480, 640,
		{
			dropdown = RPDD,
			onClosing = function(sender, args)
				-- ensure dropdown hidden and any extra cleanup
				if RPDD and RPDD.dropDownWindow then
					RPDD.dropDownWindow:SetVisible(false)
				end
                rpData.ui = nil
			end
		}
	)
	ui.window = wRP
	local window = ui.window
    -- Use CreateTitleLabel for the reputation header
    local RPlbltext = CreateTitleLabel(window, L["RPt"], 20, 35, nil, Color["green"], nil, window:GetWidth() - 40, 35, Turbine.UI.ContentAlignment.MiddleCenter)

    local RPFilterlbl = CreateFieldLabel(window, "Search:", 20, 75, 8, 60)

    -- Use factory helper to create a search TextBox + delete icon
    local rpSearch = CreateSearchControl(window, RPFilterlbl:GetLeft() + RPFilterlbl:GetWidth(), RPFilterlbl:GetTop(), window:GetWidth() - 120, 20, Turbine.UI.Lotro.Font.Verdana16, resources)
    local RPFiltertxt = rpSearch.TextBox
        ui.RPFilterDelIcon = rpSearch.DelIcon
        ui.RPFiltertxt = RPFiltertxt
    RPFiltertxt.TextChanged = function(sender, args)
        local txt = RPFiltertxt:GetText() or ""
		if ui.RPFilter then ui.RPFilter(txt) end
    end

    -- RPFilter: hide/show list rows based on filter string.
    -- Accepts an optional filter parameter; if nil, reads the current textbox value.
    local function RPFilter(filter)
        local f = filter
        if f == nil then f = RPFiltertxt:GetText() or "" end
        f = string.lower(f)

        local listBox = ui.RPListBox
        if not listBox then return end
        local count = listBox:GetItemCount() or 0
        for i = 1, count do
            local row = listBox:GetItem(i)
            if row and row.repLbl and row.repLbl:GetText() then
                local name = string.lower(row.repLbl:GetText())
                if string.find(name, f, 1, true) == nil then
                    row:SetHeight(0)
                else
                    row:SetHeight(20)
                end
            end
        end
    end
	ui.RPFilter = RPFilter

    -- Add a checkbox to hide all factions that reach max reputation.
    local RPPHMaxCtr = CreateAutoSizedCheckBox(
        window,
        L["RPPHMaxShow"],
        20, 95,
        (_G.ControlData and _G.ControlData.RP and _G.ControlData.RP.showMax) == true
    )

    RPPHMaxCtr.CheckedChanged = function(sender, args)
        _G.ControlData.RP = _G.ControlData.RP or {}
        _G.ControlData.RP.showMax = (RPPHMaxCtr:IsChecked() == true)
        settings.Reputation = settings.Reputation or {}
        -- Persist legacy key as hideMax for backward compatibility.
        settings.Reputation.H = (_G.ControlData.RP.showMax ~= true)

        SaveSettings(false)

        if type(RPRefreshListBox) == "function" and _G.ToolTipWin ~= nil and (_G.ToolTipWin.IsVisible == nil or _G.ToolTipWin:IsVisible()) then
            RPRefreshListBox()
        end
    end

    local rpLeft, rpTop = 20, 115
    local rpWidth, rpHeight = window:GetWidth() - 40, window:GetHeight() - 130
    local rplb = CreateListBoxWithBorder(window, rpLeft, rpTop, rpWidth, rpHeight, nil)
    local RPListBox = rplb.ListBox
    ui.RPListBox = RPListBox
    RPListBox:SetParent(window)
    RPListBox:SetZOrder(1)
    ConfigureListBox(RPListBox, 1, Turbine.UI.Orientation.Horizontal, Color["black"])
    local RPListBoxScrollBar = rplb.ScrollBar
    ui.RPListBoxScrollBar = RPListBoxScrollBar
    RPListBoxScrollBar:SetParent(RPListBox)
    RPListBoxScrollBar:SetZOrder(1)
    RPListBoxScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical)
    RPListBox:SetVerticalScrollBar(RPListBoxScrollBar)
    RPListBoxScrollBar:SetPosition(RPListBox:GetWidth() - 10, 0)
    RPListBoxScrollBar:SetSize(12, RPListBox:GetHeight())

    local RPWCtr = CreateControl(Turbine.UI.Control, window, RPListBox:GetLeft(), RPListBox:GetTop(), RPListBox:GetWidth(), RPListBox:GetHeight());
    ui.RPWCtr = RPWCtr
    RPWCtr:SetZOrder(0);
    RPWCtr:SetVisible(false);
    RPWCtr:SetBlendMode(5);
    RPWCtr:SetBackground(resources.Reputation.BGWindow);

    RPWCtr.MouseClick = function(sender, args)
        if (args.Button == Turbine.UI.MouseButton.Right) then
            RPDD.Cleanup();
            RPDD:ClearSelection();
            RPWCtr:SetVisible(false);
            RPWCtr:SetZOrder(0);
        end
    end

    local RPlblFN = CreateControl(Turbine.UI.Label, RPWCtr, 0, 120, RPWCtr:GetWidth(), 15); -- Faction Name label
    ui.RPlblFN = RPlblFN
    RPlblFN:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    RPlblFN:SetFontStyle(Turbine.UI.FontStyle.Outline);
    RPlblFN:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    RPlblFN:SetForeColor(Color["rustedgold"]);

    local RPlblRank = Turbine.UI.Label(); -- Rank label
    ui.RPlblRank = RPlblRank
    RPlblRank:SetParent(RPWCtr);
    RPlblRank:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    RPlblRank:SetPosition(
        RPlblFN:GetLeft() + 100, RPlblFN:GetTop() + RPlblFN:GetHeight() + 10);
    RPlblRank:SetText(L["IFCR"]);
    RPlblRank:SetSize(RPlblRank:GetTextLength() * 9, 15); 
    RPlblRank:SetForeColor(Color["rustedgold"]);
    RPlblRank:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);

    RPDD:SetParent(RPWCtr);
    RPDD:SetSize(Constants.DROPDOWN_WIDTH, Constants.DROPDOWN_HEIGHT);
    RPDD:SetPosition(
        RPlblRank:GetLeft() + RPlblRank:GetWidth() + 5, RPlblRank:GetTop());
    RPDD.dropDownWindow:SetParent(RPWCtr);
    RPDD.dropDownWindow:SetPosition(
        RPDD:GetLeft(), RPDD:GetTop() + RPDD:GetHeight() + 2);

    local RPlblTotal = Turbine.UI.Label();
    ui.RPlblTotal = RPlblTotal
    RPlblTotal:SetParent(RPWCtr);
    RPlblTotal:SetPosition(
        RPlblRank:GetLeft() + 10,
        RPlblRank:GetTop() + RPlblRank:GetHeight() + 10);
    RPlblTotal:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    RPlblTotal:SetText(L["MIWTotal"]);
    RPlblTotal:SetSize(RPlblTotal:GetTextLength() * 9, 15); 
    RPlblTotal:SetForeColor(Color["rustedgold"]);
    RPlblTotal:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);

    local RPtxtTotal = CreateInputTextBox(RPWCtr, nil, RPlblTotal:GetLeft() + RPlblTotal:GetWidth() + 5, RPlblTotal:GetTop() - 2, 90);
    ui.RPtxtTotal = RPtxtTotal
    if PlayerAlign == 2 then RPtxtTotal:SetBackColor(Color["red"]); end

    RPtxtTotal.FocusGained = function(sender, args)
        RPtxtTotal:SelectAll();
        RPtxtTotal:SetWantsUpdates(true);
    end

    RPtxtTotal.FocusLost = function(sender, args)
        RPtxtTotal:SetWantsUpdates(false);
    end

    RPtxtTotal.Update = function(sender, args)
        local parsed_text = RPtxtTotal:GetText();
        if tonumber(parsed_text) == nil or 
                string.find(parsed_text,"%.") ~= nil then
            RPtxtTotal:SetText(
                string.sub(parsed_text, 1, string.len(parsed_text) - 1));
            return
        elseif string.len(parsed_text) > 1 and 
                string.sub(parsed_text, 1, 1) == "0" then
            RPtxtTotal:SetText(string.sub(parsed_text, 2));
            return
        end
    end

    local RPbutSave = CreateAutoSizedButton(RPWCtr, L["PWSave"], RPtxtTotal:GetLeft() + RPtxtTotal:GetWidth() + 5, RPtxtTotal:GetTop())
    ui.RPbutSave = RPbutSave
    RPbutSave.Click = function(sender, args)
        if RPtxtTotal:GetText() == "" then
            RPtxtTotal:SetText("0");
            RPtxtTotal:Focus();
            return
        end
        RPtxtTotal:Focus();
        RPWCtr:SetVisible(false);
        RPWCtr:SetZOrder(0);
        local baseRankReputation = 0
        local numberOfRanks = #_G.Factions.byName[_G.SelectedFaction].ranks
        for i = 1, numberOfRanks do -- number of ranks in the drop down box
            if L[_G.Factions.byName[_G.SelectedFaction].ranks[i].name] == RPDD.label:GetText() then
                baseRankReputation = _G.Factions.byName[_G.SelectedFaction].ranks[i].requiredReputation
            end
        end
        RPDD:ClearSelection();
        local factionMaxReputation = _G.Factions.byName[_G.SelectedFaction].ranks[numberOfRanks].requiredReputation
        if _G.SelectedFaction == "ReputationAcceleration" then
            PlayerReputation[PN]["ReputationAcceleration"].Total = RPtxtTotal:GetText()
        else
            PlayerReputation[PN][_G.SelectedFaction].Total = tostring(math.min(RPtxtTotal:GetText() + baseRankReputation, factionMaxReputation));
        end
        if _G.Debug then
            write("saving reputation: "..PlayerReputation[PN][_G.SelectedFaction].Total)
        end
        SavePlayerReputation();
    end
    RefreshRPListBox();
end

function RefreshRPListBox()
    local rpData = _G.ControlData and _G.ControlData.RP
    local ui = rpData and rpData.ui
    local RPListBox = ui and ui.RPListBox
    if not ui or not RPListBox then return end
    local RPDD = ui.RPDD
    local RPWCtr = ui.RPWCtr
    local RPlblFN = ui.RPlblFN
    local RPtxtTotal = ui.RPtxtTotal

    RPListBox:ClearItems();
    for _, faction in ipairs(_G.Factions.list) do
        local RPCtr = Turbine.UI.Control();
        RPCtr:SetSize(RPListBox:GetWidth() - 10, 20);

        -- Reputation name
        local repLbl = CreateCheckBox(
            RPCtr,
            L[faction.name],
            0, 0,
            RPListBox:GetWidth() - 10, 20,
            PlayerReputation[PN][faction.name].V,
            Color["nicegold"],
            Turbine.UI.Lotro.Font.TrajanPro16,
            Turbine.UI.ContentAlignment.MiddleLeft
        )
        RPCtr.repLbl = repLbl;
        repLbl.MouseClick = function(sender, args)
            if args.Button == Turbine.UI.MouseButton.Right then
                _G.SelectedFaction = faction.name
                RPlblFN:SetText(L[faction.name]);

                local currentRankPoints = "0"
                local currentRank = ""
                local totalReputation = tonumber(PlayerReputation[PN][faction.name].Total) or 0

                for i = #faction.ranks, 1, -1 do
                    if tonumber(faction.ranks[i].requiredReputation) <= totalReputation then
                        currentRankPoints = totalReputation - faction.ranks[i].requiredReputation
                        currentRank = faction.ranks[i].name
                        break
                    end
                end

                RPtxtTotal:SetText(tostring(currentRankPoints));
                RPDD:ClearItems();
                -- Build label/value entries for the dropdown and populate via helper
                local rankEntries = {}
                for _, rank in ipairs(faction.ranks) do
                    table.insert(rankEntries, { label = L[rank.name], value = rank.name })
                end
                PopulateDropDown(RPDD, rankEntries, false, nil, currentRank)
                RPWCtr:SetVisible(true);
                RPWCtr:SetZOrder(2);
                RPtxtTotal:Focus();
            end
        end

        repLbl.CheckedChanged = function(sender, args)
            PlayerReputation[PN][faction.name].V = repLbl:IsChecked();
            SavePlayerReputation();
        end

        RPListBox:AddItem(RPCtr);
    end

	if ui.RPFilter then ui.RPFilter() end
    RPListBox:SetMaxItemsPerLine(2)
    RPListBox:SetMaxItemsPerLine(1)
end

