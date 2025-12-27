-- Constants.lua
-- Centralized constants for TitanBar
-- Created to eliminate magic numbers and improve maintainability

-- Export constants table globally
_G.Constants = {}

-- ============================================================================
-- DEFAULT VALUES
-- ============================================================================

-- Color Defaults
Constants.DEFAULT_ALPHA = 0.3
Constants.DEFAULT_RED = 0.3
Constants.DEFAULT_GREEN = 0.3
Constants.DEFAULT_BLUE = 0.3

-- Position Defaults
Constants.DEFAULT_X = 0
Constants.DEFAULT_Y = 0
Constants.DEFAULT_WINDOW_LEFT = 100
Constants.DEFAULT_WINDOW_TOP = 100

-- TitanBar Defaults
Constants.DEFAULT_TITANBAR_HEIGHT = 30
Constants.DEFAULT_TITANBAR_FONT_ID = 1107296268
Constants.DEFAULT_TITANBAR_FONT_NAME = "TrajanPro14"
Constants.DEFAULT_CONTROL_HEIGHT = 30

-- Icon Sizes
Constants.ICON_SIZE_SMALL = 16
Constants.ICON_SIZE_MEDIUM = 24
Constants.ICON_SIZE_MEDIUM_LARGE = 30
Constants.ICON_SIZE_LARGE = 32
Constants.ITEM_CONTROL_SIZE = 34  -- Turbine ItemControl size
Constants.ICON_SIZE_XLARGE = 40  -- Item slot size
Constants.ICON_SIZE_XXLARGE = 44 -- Equipment slot size
Constants.DEFAULT_ICON_SIZE = Constants.ICON_SIZE_LARGE

-- Money Icon Sizes
Constants.MONEY_ICON_WIDTH = 27
Constants.MONEY_ICON_HEIGHT = 21
Constants.DESTINY_POINTS_ICON_WIDTH = 21
Constants.DESTINY_POINTS_ICON_HEIGHT = 22
Constants.LOTRO_POINTS_ICON_WIDTH = 36
Constants.LOTRO_POINTS_ICON_HEIGHT = 43

-- UI Element Sizes
Constants.DROPDOWN_WIDTH = 159
Constants.DROPDOWN_HEIGHT = 19
Constants.DELETE_ICON_SIZE = 16
Constants.LISTBOX_HEIGHT_LARGE = 392  -- BagInfos ListBox
Constants.LISTBOX_HEIGHT_MEDIUM = 370 -- SharedStorage ListBox
Constants.LISTBOX_HEIGHT_STANDARD = 365 -- TrackItems, Vault ListBox
Constants.PROGRESS_BAR_WIDTH = 183
Constants.PROGRESS_BAR_HEIGHT = 9

-- Font Size Threshold
Constants.FONT_SIZE_THRESHOLD = 16

-- ============================================================================
-- LAYOUT & SPACING
-- ============================================================================

Constants.TOOLTIP_OFFSET_X = 10
Constants.TOOLTIP_OFFSET_Y = 10
Constants.TOOLTIP_MARGIN = 5
Constants.WINDOW_BORDER_WIDTH = 2
Constants.WINDOW_PADDING = 15
Constants.CONTROL_PADDING = 5

-- Default Control Positions on TitanBar
Constants.DEFAULT_MONEY_X = 400
Constants.DEFAULT_PLAYER_INFO_X = 210
Constants.DEFAULT_EQUIP_INFO_X = 75
Constants.DEFAULT_DURABILITY_INFO_X = 145
Constants.DEFAULT_PLAYER_LOC_WIDTH = 205  -- Width reserved for player location

-- Z-Order
Constants.ZORDER_TOOLTIP = 1
Constants.ZORDER_CONTROL = 2

-- ============================================================================
-- POSITION DISPLAY MODES
-- ============================================================================

Constants.Position = {
    TITANBAR = 1,
    TOOLTIP = 2,
    NONE = 3
}

-- ============================================================================
-- GAME TIME
-- ============================================================================

-- Game time cycle in seconds (3 hours and 6 minutes)
Constants.GAME_TIME_CYCLE = 11160

-- Dawn time offset
Constants.DAWN_TIME_OFFSET = 0

-- ============================================================================
-- DURABILITY SLOTS
-- ============================================================================

-- Durability slot background IDs
Constants.DURABILITY_SLOTS_BG = {
    0x41007eed,  -- Head
    0x41007ef6,  -- Shoulders
    0x41007ef7,  -- Chest
    0x41007eef,  -- Hands
    0x41007eee,  -- Legs
    0x41007ee9,  -- Feet
    0x41007ef0,  -- Main Hand
    0x41007ef9,  -- Off Hand
    0x41007ef8,  -- Ranged
    0x41007eea,  -- Class Item
    0x41007f29,  -- Necklace
    0x41007f2a,  -- Pocket
    0x41007f2b,  -- Cloak
    0x41007f2c,  -- Bracelet 1
    0x41007f2d,  -- Bracelet 2
    0x41007f2e,  -- Ring 1
    0x41007f2f,  -- Ring 2
    0x41007f30,  -- Earring 1
    0x41007f31   -- Earring 2
}

-- ============================================================================
-- WINDOW DIMENSIONS
-- ============================================================================

Constants.WALLET_WINDOW_WIDTH = 400
Constants.WALLET_WINDOW_MIN_HEIGHT = 100

Constants.REPUTATION_WINDOW_WIDTH = 380
Constants.REPUTATION_WINDOW_MIN_HEIGHT = 100

Constants.VAULT_WINDOW_WIDTH = 400
Constants.VAULT_WINDOW_HEIGHT = 520
Constants.VAULT_WINDOW_MIN_HEIGHT = 85

Constants.TRACK_ITEMS_WINDOW_WIDTH = 400
Constants.TRACK_ITEMS_WINDOW_HEIGHT = 498
Constants.TRACK_ITEMS_WINDOW_MIN_HEIGHT = 85

Constants.SHARED_STORAGE_WINDOW_WIDTH = 400
Constants.SHARED_STORAGE_WINDOW_HEIGHT = 475

Constants.MONEY_WINDOW_WIDTH = 300
Constants.MONEY_WINDOW_MIN_HEIGHT = 45

Constants.LOTRO_POINTS_WINDOW_WIDTH = 300
Constants.LOTRO_POINTS_WINDOW_HEIGHT = 80

Constants.INFAMY_WINDOW_WIDTH = 300
Constants.INFAMY_WINDOW_HEIGHT = 80

Constants.GAME_TIME_WINDOW_WIDTH = 300
Constants.GAME_TIME_WINDOW_MIN_HEIGHT = 80

Constants.DAY_NIGHT_WINDOW_WIDTH = 300
Constants.DAY_NIGHT_WINDOW_MIN_HEIGHT = 80

Constants.DURABILITY_WINDOW_WIDTH = 300
Constants.DURABILITY_WINDOW_MIN_HEIGHT = 80

Constants.BAG_INFOS_WINDOW_WIDTH = 400
Constants.BAG_INFOS_WINDOW_HEIGHT = 498

-- ============================================================================
-- LISTBOX & SCROLLBAR
-- ============================================================================

Constants.LISTBOX_BORDER_HEIGHT = 365
Constants.LISTBOX_BORDER_WIDTH = 30
Constants.LISTBOX_ITEM_HEIGHT = 35

Constants.SCROLLBAR_WIDTH = 10

-- ============================================================================
-- TOOLTIP DIMENSIONS
-- ============================================================================

Constants.TOOLTIP_WIDTH_SMALL = 100      -- Wallet tooltip minimum
Constants.TOOLTIP_WIDTH_DEFAULT = 300    -- Money, Track Items tooltips
Constants.TOOLTIP_WIDTH_MEDIUM = 325     -- Money tooltips with content
Constants.TOOLTIP_WIDTH_REP_CONTENT = 345 -- Reputation tooltip listbox
Constants.TOOLTIP_WIDTH_REPUTATION = 380 -- Reputation tooltip window
Constants.TOOLTIP_WIDTH_VAULT = 400      -- Vault/Shared Storage tooltips
Constants.TOOLTIP_HEIGHT_MIN = 37
Constants.TOOLTIP_HEIGHT_OFFSET = 30
Constants.TOOLTIP_HEIGHT_VAULT_MAX_OFFSET = 70

-- ============================================================================
-- UI CONTROL DIMENSIONS
-- ============================================================================

-- Small UI elements
Constants.ARROW_SIZE = 16               -- ComboBox arrow
Constants.HELP_BUTTON_WIDTH = 10
Constants.HELP_BUTTON_HEIGHT = 20
Constants.GMT_FIELD_WIDTH = 30
Constants.GMT_FIELD_HEIGHT = 20

-- Label and text widths
Constants.LABEL_WIDTH_NARROW = 80
Constants.LABEL_WIDTH_STANDARD = 140
Constants.LABEL_WIDTH_WIDE = 200
Constants.LABEL_WIDTH_EXTRA_WIDE = 210
Constants.LABEL_WIDTH_REPUTATION = 242
Constants.LABEL_WIDTH_ITEM = 275
Constants.LABEL_WIDTH_TOOLTIP = 250

-- Common label heights
Constants.LABEL_HEIGHT_SMALL = 10
Constants.LABEL_HEIGHT_STANDARD = 15
Constants.LABEL_HEIGHT_LARGE = 19
Constants.LABEL_HEIGHT_ITEM = 35
Constants.LABEL_HEIGHT_MESSAGE = 39

-- Window border and padding offsets
Constants.TOOLTIP_LIST_OFFSET_X = 15
Constants.TOOLTIP_LIST_OFFSET_Y = 12
Constants.TOOLTIP_LIST_OFFSET_Y_ALT = 20
Constants.LISTBOX_POSITION_TOP = 85
Constants.DROPDOWN_POSITION_TOP = 35
Constants.DROPDOWN_POSITION_LEFT = 15

-- ============================================================================
-- CONTROL OFFSETS
-- ============================================================================

Constants.PLAYER_LOC_DEFAULT_OFFSET = 205
Constants.GAME_TIME_DEFAULT_OFFSET = 60
Constants.MONEY_DEFAULT_X = 400

-- ============================================================================
-- STRING FORMATTING
-- ============================================================================

Constants.FORMAT_FLOAT = "%.3f"
Constants.FORMAT_INT = "%.0f"

-- ============================================================================
-- INFAMY RANKS
-- ============================================================================

-- Infamy/Renown point thresholds for each rank (Monster Play / Ettenmoors)
Constants.INFAMY_RANKS = {
    [0] = 0,
    [1] = 500,
    [2] = 1250,
    [3] = 2750,
    [4] = 5750,
    [5] = 14750,
    [6] = 33500,
    [7] = 71000,
    [8] = 146000,
    [9] = 258500,
    [10] = 408500,
    [11] = 633500,
    [12] = 1008500,
    [13] = 1608500,
    [14] = 2508500,
    [15] = 3708500
}

-- ============================================================================
-- BLEND MODES
-- ============================================================================

Constants.BlendMode = {
    COLOR = 1,
    NORMAL = 2,
    MULTIPLY = 3,
    ALPHA_BLEND = 4,
    OVERLAY = 5,
    GRAYSCALE = 6,
    SCREEN = 7,
    UNDEFINED = 8
}

-- ============================================================================
-- ALIGNMENT
-- ============================================================================

-- Stored as references since they're from Turbine API
-- These will be set at runtime
Constants.Alignment = {
    LEFT = nil,   -- Will be set to Turbine.UI.ContentAlignment.MiddleLeft
    RIGHT = nil,  -- Will be set to Turbine.UI.ContentAlignment.MiddleRight
    CENTER = nil  -- Will be set to Turbine.UI.ContentAlignment.MiddleCenter
}

-- ============================================================================
-- DATA SCOPE (will be initialized after Turbine is loaded)
-- ============================================================================

Constants.SETTINGS_SCOPE = nil  -- Will be set to Turbine.DataScope.Character in InitializeConstants
Constants.SETTINGS_NAME_DE = "TitanBarSettingsDE"
Constants.SETTINGS_NAME_EN = "TitanBarSettingsEN"
Constants.SETTINGS_NAME_FR = "TitanBarSettingsFR"

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Format a number as integer string
function Constants.FormatInt(value)
    return string.format(Constants.FORMAT_INT, value)
end

-- Format a number as float string (3 decimal places)
function Constants.FormatFloat(value)
    return string.format(Constants.FORMAT_FLOAT, value)
end

-- Get settings name for locale
function Constants.GetSettingsName(locale)
    if locale == "de" then
        return Constants.SETTINGS_NAME_DE
    elseif locale == "fr" then
        return Constants.SETTINGS_NAME_FR
    else
        return Constants.SETTINGS_NAME_EN
    end
end

-- Initialize Turbine-dependent constants
function Constants.InitializeAlignments()
    Constants.Alignment.LEFT = Turbine.UI.ContentAlignment.MiddleLeft
    Constants.Alignment.RIGHT = Turbine.UI.ContentAlignment.MiddleRight
    Constants.Alignment.CENTER = Turbine.UI.ContentAlignment.MiddleCenter
    Constants.SETTINGS_SCOPE = Turbine.DataScope.Character
end
