-- ReputationWindow.lua
-- Written by many


function frmReputationWindow()
    _G.SelectedFaction = nil;
    import(AppClassD.."ComboBox");
    import(AppDirD .. "WindowFactory")
    RPDD = HabnaPlugins.TitanBar.Class.ComboBox();

    -- Create window via WindowFactory for consistent behavior
    _G.wRP = CreateWindow({
        text = L["MReputation"],
        width = 480,
        height = 640,
        left = RPWLeft,
        top = RPWTop,
        config = {
            dropdown = RPDD,
            settingsKey = "Reputation",
            windowGlobalVar = "wRP",
            formGlobalVar = "frmRP",
            onPositionChanged = function(left, top)
                RPWLeft, RPWTop = left, top
            end,
            onClosing = function(sender, args)
                -- ensure dropdown hidden and any extra cleanup
                if RPDD and RPDD.dropDownWindow then
                    RPDD.dropDownWindow:SetVisible(false)
                end
            end
        }
    })
   

    -- Use CreateTitleLabel for the reputation header
    local RPlbltext = CreateTitleLabel(_G.wRP, L["RPt"], 20, 35, nil, Color["green"], nil, _G.wRP:GetWidth() - 40, 35, Turbine.UI.ContentAlignment.MiddleCenter)

    local RPFilterlbl = Turbine.UI.Label();
    RPFilterlbl:SetParent(_G.wRP);
    RPFilterlbl:SetSize(60,20);
    RPFilterlbl:SetPosition(20,75);
    RPFilterlbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    RPFilterlbl:SetText("Search:");

    -- Use factory helper to create a search TextBox + delete icon
    local rpSearch = CreateSearchControl(_G.wRP, RPFilterlbl:GetLeft() + RPFilterlbl:GetWidth(), RPFilterlbl:GetTop(), _G.wRP:GetWidth() - 120, 20, Turbine.UI.Lotro.Font.Verdana16, resources)
    local RPFiltertxt = rpSearch.TextBox
    _G.wRP.RPFilterDelIcon = rpSearch.DelIcon
    RPFiltertxt.Text = ""
    RPFiltertxt.TextChanged = function(sender, args)
        local txt = RPFiltertxt:GetText() or ""
        RPFilter(txt)
    end

    -- RPFilter: hide/show list rows based on filter string.
    -- Accepts an optional filter parameter; if nil, reads the current textbox value.
    function RPFilter(filter)
        local f = filter
        if f == nil then f = RPFiltertxt:GetText() or "" end
        f = string.lower(f)

        local count = RPListBox:GetItemCount() or 0
        for i = 1, count do
            local row = RPListBox:GetItem(i)
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

--[[-- Add a checkbox for people to be able to hide all factions that reach max 
    -- reputation (then reshow if they loose rep)
    RPPHMaxCtr = Turbine.UI.Lotro.CheckBox();
    RPPHMaxCtr:SetParent(_G.wRP);
    RPPHMaxCtr:SetText(L["RPPHMaxHide"]);
    RPPHMaxCtr:SetSize(_G.wRP:GetWidth() - 10, 20);
    RPPHMaxCtr:SetPosition(45, 65);
    RPPHMaxCtr:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    RPPHMaxCtr:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    RPPHMaxCtr:SetForeColor(Color["yellow"]);
    RPPHMaxCtr:SetChecked(HideMaxReps);

    RPPHMaxCtr.CheckedChanged = function(sender, args)
        HideMaxReps = RPPHMaxCtr:IsChecked();
            write("Hide maxed out reps: "..tostring(HideMaxReps));
        SaveSettings();
    end
--]]

    -- **v Set the reputation listbox v (using WindowFactory helper) **
    local rpLeft, rpTop = 20, 115
    local rpWidth, rpHeight = _G.wRP:GetWidth() - 40, _G.wRP:GetHeight() - 130
    local rplb = CreateListBoxWithBorder(_G.wRP, rpLeft, rpTop, rpWidth, rpHeight, nil)
    RPListBox = rplb.ListBox
    RPListBox:SetParent(_G.wRP)
    RPListBox:SetZOrder(1)
    RPListBox:SetMaxItemsPerLine(1)
    RPListBox:SetOrientation(Turbine.UI.Orientation.Horizontal)
    RPListBox:SetBackColor(Color["black"])
    RPListBoxScrollBar = rplb.ScrollBar
    RPListBoxScrollBar:SetParent(RPListBox)
    RPListBoxScrollBar:SetZOrder(1)
    RPListBoxScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical)
    RPListBox:SetVerticalScrollBar(RPListBoxScrollBar)
    RPListBoxScrollBar:SetPosition(RPListBox:GetWidth() - 10, 0)
    RPListBoxScrollBar:SetSize(12, RPListBox:GetHeight())
    -- **^

    RPWCtr = Turbine.UI.Control();
    RPWCtr:SetParent(_G.wRP);
    RPWCtr:SetPosition(RPListBox:GetLeft(), RPListBox:GetTop());
    RPWCtr:SetSize(RPListBox:GetWidth(), RPListBox:GetHeight());
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

    RPlblFN = Turbine.UI.Label(); -- Faction Name label
    RPlblFN:SetParent(RPWCtr);
    RPlblFN:SetPosition(0, 120);
    RPlblFN:SetSize(RPWCtr:GetWidth(), 15);
    RPlblFN:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    RPlblFN:SetFontStyle(Turbine.UI.FontStyle.Outline);
    RPlblFN:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    RPlblFN:SetForeColor(Color["rustedgold"]);

    RPlblRank = Turbine.UI.Label(); -- Rank label
    RPlblRank:SetParent(RPWCtr);
    RPlblRank:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    RPlblRank:SetPosition(
        RPlblFN:GetLeft() + 100, RPlblFN:GetTop() + RPlblFN:GetHeight() + 10);
    RPlblRank:SetText(L["IFCR"]);
    RPlblRank:SetSize(RPlblRank:GetTextLength() * 9, 15); 
    RPlblRank:SetForeColor(Color["rustedgold"]);
    RPlblRank:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);

    -- **v Create drop down box v**
    RPDD:SetParent(RPWCtr);
    RPDD:SetSize(159, 19);
    RPDD:SetPosition(
        RPlblRank:GetLeft() + RPlblRank:GetWidth() + 5, RPlblRank:GetTop());
    RPDD.dropDownWindow:SetParent(RPWCtr);
    RPDD.dropDownWindow:SetPosition(
        RPDD:GetLeft(), RPDD:GetTop() + RPDD:GetHeight() + 2);
    -- **^

    RPlblTotal = Turbine.UI.Label();
    RPlblTotal:SetParent(RPWCtr);
    RPlblTotal:SetPosition(
        RPlblRank:GetLeft() + 10,
        RPlblRank:GetTop() + RPlblRank:GetHeight() + 10);
    RPlblTotal:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    RPlblTotal:SetText(L["MIWTotal"]);
    RPlblTotal:SetSize(RPlblTotal:GetTextLength() * 9, 15); 
    RPlblTotal:SetForeColor(Color["rustedgold"]);
    RPlblTotal:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);

    RPtxtTotal = Turbine.UI.Lotro.TextBox();
    RPtxtTotal:SetParent(RPWCtr);
    RPtxtTotal:SetPosition( 
        RPlblTotal:GetLeft() + RPlblTotal:GetWidth() + 5, 
        RPlblTotal:GetTop() - 2);
    RPtxtTotal:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    RPtxtTotal:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    RPtxtTotal:SetSize(90, 20);
    RPtxtTotal:SetMultiline(false);
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

    RPbutSave = Turbine.UI.Lotro.Button();
    RPbutSave:SetParent(RPWCtr);
    RPbutSave:SetPosition(
        RPtxtTotal:GetLeft() + RPtxtTotal:GetWidth() + 5, 
        RPtxtTotal:GetTop());
    RPbutSave:SetText(L["PWSave"]);
    RPbutSave:SetSize(RPbutSave:GetTextLength() * 10, 15); 
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
    RPListBox:ClearItems();
    for _, faction in ipairs(_G.Factions.list) do
        --**v Control of all data v**
        local RPCtr = Turbine.UI.Control();
        RPCtr:SetParent(RPListBox);
        RPCtr:SetSize(RPListBox:GetWidth() - 10, 20);
        --**^
        -- Reputation name
        local repLbl = Turbine.UI.Lotro.CheckBox();
        RPCtr.repLbl = repLbl;
        repLbl:SetParent(RPCtr);
        repLbl:SetText(L[faction.name])
        repLbl:SetSize(RPListBox:GetWidth() - 10, 20);
        repLbl:SetPosition(0, 0);
        repLbl:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
        repLbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
        repLbl:SetForeColor(Color["nicegold"]);
        repLbl:SetChecked(PlayerReputation[PN][faction.name].V);
        repLbl.MouseClick = function(sender, args)
            if args.Button == Turbine.UI.MouseButton.Right then
                _G.SelectedFaction = faction.name
                RPlblFN:SetText(L[faction.name]);

                local currentRankPoints = "0"
                local currentRank = ""
                local totalReputation = PlayerReputation[PN][faction.name].Total

                for i = #faction.ranks, 1, -1 do
                    if tonumber(faction.ranks[i].requiredReputation) <= tonumber(totalReputation) then
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

    RPFilter();
end
