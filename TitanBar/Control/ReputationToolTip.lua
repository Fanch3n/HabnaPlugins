-- ReputationToolTip.lua
-- written by many

import(AppDirD .. "UIHelpers")


function ShowRPWindow()
    -- ( offsetX, offsetY, width, height, bubble side )
    --x, y, w, h, bblTo = -5, -15, 320, 0, "left";
    --mouseX, mouseY = Turbine.UI.Display.GetMousePosition();

    --if w + mouseX > screenWidth then bblTo = "right"; x = w - 10; end

    _G.ToolTipWin = Turbine.UI.Window();
    _G.ToolTipWin:SetZOrder( 1 );
    --_G.ToolTipWin.xOffset = x;
    --_G.ToolTipWin.yOffset = y;
    _G.ToolTipWin:SetWidth( Constants.TOOLTIP_WIDTH_REPUTATION );
    _G.ToolTipWin:SetVisible( true );

    RPTTListBox = Turbine.UI.ListBox();
    RPTTListBox:SetParent( _G.ToolTipWin );
    RPTTListBox:SetZOrder( 1 );
    RPTTListBox:SetPosition( 15, 12 );
    RPTTListBox:SetWidth( Constants.TOOLTIP_WIDTH_REP_CONTENT );
    ConfigureListBox(RPTTListBox)
    --RPTTListBox:SetBackColor( Color["darkgrey"] ); --debug purpose

    RPRefreshListBox();

    ApplySkin();
end

function RPRefreshListBox()
    RPTTListBox:ClearItems();
    RPTTPosY = 0;
    local bFound = false;

    for _, faction in ipairs(_G.Factions.list) do
        if PlayerReputation[PN][faction.name].V then
            HideMaxReps = true; -- TODO add option to hide/show
            HideBonus = true;
            if faction.name == "ReputationAcceleration" then
                if tonumber(PlayerReputation[PN][faction.name].Total) > 0 then
                    HideBonus = false;
                end
            end

            --**v Control of all data v**
            local RPTTCtr = Turbine.UI.Control();
            RPTTCtr:SetParent( RPTTListBox );
            RPTTCtr:SetSize( RPTTListBox:GetWidth(), 35 );
--          RPTTCtr:SetBackColor( Color["red"] ); -- Debug purpose
            --**^

            -- Reputation name
            local repLbl = CreateControl(Turbine.UI.Label, RPTTCtr, 0, 0, RPTTListBox:GetWidth() - 35, 15);
            repLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
            repLbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
            repLbl:SetForeColor( Color["nicegold"] );
            repLbl:SetText( L[faction.name] );

            local percentage_done = "0.00"
            local totalReputation = math.max(tonumber(PlayerReputation[PN][faction.name].Total) or 0, 0)
            local rankName = faction.ranks[1].name
            local currentRankPoints = 0
            local currentRankMax = 1

            for n, rank in ipairs(faction.ranks) do
                local required = tonumber(rank.requiredReputation) or 0

                if totalReputation < required then
                    local previousRankMax = faction.ranks[math.max(n-1, 1)].requiredReputation
                    rankName = faction.ranks[math.max(n-1, 1)].name
                    currentRankPoints = totalReputation - previousRankMax
                    currentRankMax = required - previousRankMax

                    if currentRankPoints and currentRankMax and currentRankMax ~= 0 then
                        local percent = (currentRankPoints / currentRankMax) * 100
                        percentage_done = string.format("%.2f", percent)
                    end
                    break
                elseif required == totalReputation and n == #faction.ranks then
                    rankName = rank.name
                elseif faction.name == "ReputationAcceleration" then
                    currentRankPoints = totalReputation
                    currentRankMax = 80000
                    local percent = (currentRankPoints / currentRankMax) * 100
                    percentage_done = string.format("%.2f", percent)
                end
            end
            if rankName == faction.ranks[#faction.ranks].name and HideBonus then
                percentage_done = "max"
            end

            local RPPBFill = CreateControl(Turbine.UI.Control, RPTTCtr, 9, 17, 0, 9)--Filling
            if percentage_done == "max" then RPPBFill:SetSize( Constants.PROGRESS_BAR_WIDTH, Constants.PROGRESS_BAR_HEIGHT );
            else RPPBFill:SetSize( ( Constants.PROGRESS_BAR_WIDTH * tonumber(percentage_done) ) / 100, Constants.PROGRESS_BAR_HEIGHT ); end
            RPPBFill:SetBackground( resources.Reputation.BGGood );
            --RPPBFill:SetBackground( resources.Reputation.BGBad );

            if faction.isCraftingGuild then
                RPPBFill:SetBackground( resources.Reputation.BGGuild );
            end

            local RPPB = CreateControl(Turbine.UI.Control, RPTTCtr, 0, 14, 200, 15) --Frame
            RPPB:SetBlendMode( 4 );
            RPPB:SetBackground( resources.Reputation.BGFrame );

            local RPPC = Turbine.UI.Label(); --percentage
            RPPC:SetParent( RPTTCtr );
            if percentage_done == "max" then
                RPPC:SetPosition( 1, 17 );
                RPPC:SetText( L["RPMSR"] );
            else
                bFound = true;
                RPPC:SetPosition( 9, 17 );
                RPPC:SetText( currentRankPoints.."/"..currentRankMax.."  "..percentage_done.."%" );
            end
            RPPC:SetSize( Constants.LABEL_WIDTH_WIDE, Constants.PROGRESS_BAR_HEIGHT );
            RPPC:SetForeColor( Color["white"] );
            RPPC:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

            local RPLvl = Turbine.UI.Label();
            RPLvl:SetForeColor( Color["white"] );
            if faction.name == "ReputationAcceleration" then RPLvl:SetForeColor( Color["purple"] ); end
            --RPLvl:SetForeColor( Color["red"] );
            --RPLvl:SetForeColor( Color["green"] );

            RPLvl:SetParent( RPTTCtr );
            RPLvl:SetText(L[rankName]);
            RPLvl:SetPosition( 205, 15 );
            RPLvl:SetSize( RPTTListBox:GetWidth() - RPPB:GetWidth(), 15 );
            RPLvl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );

            if HideMaxReps and percentage_done == "max" then
                repLbl:SetVisible( false );
                RPPBFill:SetVisible( false );
                RPPB:SetVisible( false );
                RPPC:SetVisible( false );
                RPLvl:SetVisible( false );
            else
                RPTTPosY = RPTTPosY + 35;
                RPTTListBox:AddItem( RPTTCtr );
            end

        end
    end
    
    if not bFound then --If not showing any faction
        local lblName = Turbine.UI.Label();
        lblName:SetParent( _G.ToolTipWin );
        lblName:SetText( L["RPnf"] );
        lblName:SetPosition( 0, 0 );
        lblName:SetSize( RPTTListBox:GetWidth(), 35 );
        lblName:SetForeColor( Color["green"] );
        lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
        --lblName:SetBackColor( Color["red"] ); -- debug purpose

        RPTTListBox:AddItem( lblName );

        RPTTPosY = RPTTPosY + 35;
    end

    RPTTListBox:SetHeight( RPTTPosY );
    _G.ToolTipWin:SetHeight( RPTTPosY + 30 );

    PositionToolTipWindow();
end
