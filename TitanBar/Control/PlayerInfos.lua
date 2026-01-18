import(AppDirD .. "UIHelpers")
import(AppCtrD .. "PlayerInfosToolTip")
import(AppDirD .. "ControlFactory")

function UpdatePlayersInfos()
	--Race
	PlayerRaceIdIs = Player:GetRace();
	local PlayerRaceIsLkey = "PR"..PlayerRaceIdIs
	PlayerRaceIs = L[PlayerRaceIsLkey]
	if not PlayerRaceIs then
		PlayerRaceIs = PlayerRaceIsLkey -- show the expected localization key if not found
	end

	--Class
	PlayerClassIdIs = Player:GetClass()
	local PlayerClassIsLkey = "PC"..PlayerClassIdIs
	PlayerClassIs = L[PlayerClassIsLkey]
	if not PlayerClassIs then
		PlayerClassIs = PlayerClassIsLkey -- show the expected localization key if not found
	end

	--Update visuale
	_G.ControlData.PI.controls[ "Icon" ]:SetBackground(resources.PlayerIconCode[PlayerClassIdIs]) -- if class icon is unknown in the resource then background image is set to nil: nothing visible
	
	_G.ControlData.PI.controls["Lvl"]:SetText(tostring(Player:GetLevel()))
	_G.ControlData.PI.controls["Lvl"]:SetSize(_G.ControlData.PI.controls["Lvl"]:GetTextLength() * NM+1, CTRHeight)
	_G.ControlData.PI.controls["Name"]:SetPosition(_G.ControlData.PI.controls["Lvl"]:GetLeft() + _G.ControlData.PI.controls["Lvl"]:GetWidth() + 5, 0)
	--_G.ControlData.PI.controls["Name"]:SetText("OneVeryLongCharacterName") --Debug purpose
	_G.ControlData.PI.controls["Name"]:SetText(Player:GetName())
	
	_G.ControlData.PI.controls["Name"]:SetSize(_G.ControlData.PI.controls["Name"]:GetTextLength() * TM, CTRHeight)

	AdjustIcon( "PI" );
end

function InitializePlayerInfos()
    -- Cleanup existing controls to prevent duplication
    if _G.ControlData.PI.controls and _G.ControlData.PI.controls["Ctr"] then
        _G.ControlData.PI.controls["Ctr"]:SetParent(nil)
    end
    
    local piData = _G.ControlData.PI
    
    -- Cleanup existing callbacks
    if piData.callbacks then
        for _, cb in ipairs(piData.callbacks) do
            if RemoveCallback then
                RemoveCallback(cb.obj, cb.evt, cb.func)
            end
        end
    end
    piData.callbacks = {}

    -- Use _G.ControlData.PI.controls for all UI controls
    local PI = {}
    _G.ControlData.PI.controls = PI

    local colors = _G.ControlData.PI.colors
    CreateTitanBarControl(PI, colors.alpha, colors.red, colors.green, colors.blue)
    _G.ControlData.PI.ui = _G.ControlData.PI.ui or {}
    _G.ControlData.PI.ui.control = PI["Ctr"]

    PI["Icon"] = CreateControlIcon(PI["Ctr"], Constants.ICON_SIZE_LARGE, Constants.ICON_SIZE_LARGE)

    PI["Lvl"] = CreateControlLabel(PI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleCenter)

    PI["Name"] = CreateControlLabel(PI["Ctr"], _G.TBFont, Turbine.UI.ContentAlignment.MiddleLeft)

    SetupControlInteraction({
        icon = PI["Name"],
        controlTable = PI,
        settingsSection = settings.PlayerInfos,
        onLeftClick = function() end,
        customTooltipHandler = ShowPIWindow
    })

    DelegateMouseEvents(PI["Icon"], PI["Name"])
    DelegateMouseEvents(PI["Lvl"], PI["Name"])
    --**^

    -- Callback registration
    if AddCallback then
        -- Level Changed
        local cbLevel = function(sender, args)
            _G.ControlData.PI.controls["Lvl"]:SetText( tostring(Player:GetLevel()) );
            _G.ControlData.PI.controls["Lvl"]:SetSize( _G.ControlData.PI.controls["Lvl"]:GetTextLength() * NM+1, CTRHeight );
            _G.ControlData.PI.controls["Name"]:SetPosition( _G.ControlData.PI.controls["Lvl"]:GetLeft() + _G.ControlData.PI.controls["Lvl"]:GetWidth() + 5, 0 );
        end
        AddCallback(Player, "LevelChanged", cbLevel)
        table.insert(piData.callbacks, {obj=Player, evt="LevelChanged", func=cbLevel})

        -- Name Changed
        local cbName = function(sender, args)
            _G.ControlData.PI.controls["Name"]:SetText( Player:GetName() );
            _G.ControlData.PI.controls["Name"]:SetSize( _G.ControlData.PI.controls["Name"]:GetTextLength() * TM, CTRHeight );
            AdjustIcon("PI");
        end
        AddCallback(Player, "NameChanged", cbName)
        table.insert(piData.callbacks, {obj=Player, evt="NameChanged", func=cbName})

        -- Chat (XP Monitoring)
        local cbChat = function(sender, args)
            if args.ChatType == Turbine.ChatType.Advancement then
                local xpMess = args.Message;
                if xpMess ~= nil then
                    local xpPattern;
                    if GLocale == "en" then
                        xpPattern = "total of ([%d%p]*) XP";
                    elseif GLocale == "fr" then
                        xpPattern = "de ([%d%p]*) points d'exp\195\169rience";
                    elseif GLocale == "de" then
                        xpPattern = "\195\188ber ([%d%p]*) EP";
                    end
                    local tmpXP = string.match(xpMess,xpPattern);
                    if tmpXP ~= nil then
                        _G.ControlData.PI = _G.ControlData.PI or {}
                        _G.ControlData.PI.xp = tmpXP;
                        settings.PlayerInfos.XP = tmpXP;
                        SaveSettings( false );
                    end
                end
            end
        end
        AddCallback(Turbine.Chat, "Received", cbChat)
        table.insert(piData.callbacks, {obj=Turbine.Chat, evt="Received", func=cbChat})
    end

    UpdatePlayersInfos()
end

-- Self-registration
if _G.ControlRegistry and _G.ControlRegistry.Register then
	_G.ControlRegistry.Register({
		id = "PI",
		settingsKey = "PlayerInfos",
		hasWhere = false,
		defaults = { show = false, x = nil, y = 0 },
		initFunc = InitializePlayerInfos
	})
end