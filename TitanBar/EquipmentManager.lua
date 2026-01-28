-- EquipmentManager.lua
-- Centralizes player equipment data, stats, and wear state tracking

EquipmentManager = {}
local itemEquip = {}
local numItems = 0
local Wq = 4 -- weight Quality
local Wd = 1 -- weight Durability

-- Initialize empty item slots
for i = 1, 20 do
    itemEquip[i] = { Item = false, Score = 0, WearState = 0, WearStatePts = 0 }
end

local function GetWearStatePoints(wearState)
    if wearState == 2 then return 100    -- Pristine
    elseif wearState == 4 then return 99 -- Worn
    elseif wearState == 1 then return 20 -- Damaged
    else return 0 end                    -- Broken (3) or Undefined (0)
end

function EquipmentManager.GetItems()
    return itemEquip
end

function EquipmentManager.GetNumItems()
    return numItems
end

function EquipmentManager.ChangeWearState(index)
    if not itemEquip[index] or not PlayerEquipment then return end

    local equipItem = PlayerEquipment:GetItem(Constants.EquipmentSlots[index])
    if not equipItem then return end

    local WearState = equipItem:GetWearState()
    itemEquip[index].WearState = WearState
    itemEquip[index].WearStatePts = GetWearStatePoints(WearState)

    if UpdateDurabilityInfos then
        UpdateDurabilityInfos()
    end
end

function EquipmentManager.Refresh()
    if not PlayerEquipment then
        PlayerEquipment = Player:GetEquipment()
    end
    if PlayerEquipment == nil then return end

    numItems = 0

    for i, slotID in ipairs(Constants.EquipmentSlots) do
        -- Cleanup old handler to prevent leaks
        if itemEquip[i] and itemEquip[i].wsHandler and itemEquip[i].sourceItem then
            RemoveCallback(itemEquip[i].sourceItem, "WearStateChanged", itemEquip[i].wsHandler)
        end

        local PlayerEquipItem = PlayerEquipment:GetItem(slotID)

        -- We must recreate the ItemControl because it binds to a specific item instance
        itemEquip[i] = Turbine.UI.Lotro.ItemControl(PlayerEquipItem)
        -- Store the item wrapper reference so we can remove callbacks later
        itemEquip[i].sourceItem = PlayerEquipItem

        -- Item Name, WearState, Quality & Durability
        if PlayerEquipItem ~= nil then
            itemEquip[i].Item = true
            itemEquip[i].Name = PlayerEquipItem:GetName()
            itemEquip[i].Slot = Constants.EquipmentSlotNames[i]

            local Quality = 10 * ((6 - PlayerEquipItem:GetQuality()) % 6)

            local Durability = PlayerEquipItem:GetDurability()
            if Durability ~= 0 then
                Durability = 10 * ((Durability % 7) + 1)
            end

            -- Calculate Score
            local scoreVal = (Wq * Quality * 7 + Wd * Durability * 5) / (3.5 * (Wq + Wd))
            if round then
                itemEquip[i].Score = round(scoreVal)
            else
                itemEquip[i].Score = math.floor(scoreVal + 0.5)
            end

            itemEquip[i].WearState = PlayerEquipItem:GetWearState()
            itemEquip[i].WearStatePts = GetWearStatePoints(itemEquip[i].WearState)

            if itemEquip[i].WearState ~= 0 then
                numItems = numItems + 1
            end

            itemEquip[i].BImgID = PlayerEquipItem:GetBackgroundImageID()
            itemEquip[i].QImgID = PlayerEquipItem:GetQualityImageID()
            itemEquip[i].UImgID = PlayerEquipItem:GetUnderlayImageID()
            itemEquip[i].SImgID = PlayerEquipItem:GetShadowImageID()
            itemEquip[i].IImgID = PlayerEquipItem:GetIconImageID()

            -- Callbacks
            if AddCallback then
                itemEquip[i].wsHandler = AddCallback(
                    PlayerEquipItem, "WearStateChanged",
                    function(sender, args)
                        EquipmentManager.ChangeWearState(i)
                    end
                )
            end
        else
            itemEquip[i].Item = false
            itemEquip[i].Name = "zEmpty"
            itemEquip[i].Score = 0
            itemEquip[i].WearState = 0
            itemEquip[i].WearStatePts = 0
        end
    end
end

-- Initialize data immediately on load
EquipmentManager.Refresh()
