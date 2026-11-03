local CLASS_NAME = "Dawnbringer"
local SLOT_THIRD_ROW_LEFTMOST = { 0.384, 0.1, 0.488 }
local SLOT_THIRD_ROW_CENTER = { 0, 0.1, 0.488 }
local SLOT_THIRD_ROW_RIGHTMOST = { -0.384, 0.1, 0.488 }
local ITEM_PACKS = {
    {
        name = "Dawnbringer Ammo Items",
        slot = SLOT_THIRD_ROW_LEFTMOST,
        items = {
            { name = "Concussive Quarrel", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ae933ce41223720faada097_itemCardFront_2026-11-03_01-12-59.png?generation=1793668380169616&alt=media" },
            { name = "Corrosive Darts", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ae936f941223720faada327_itemCardFront_2026-11-03_01-23-27.png?generation=1793669008837163&alt=media" },
            { name = "Silver Bolts", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ae937a441223720faada3a9_itemCardFront_2026-11-03_01-25-15.png?generation=1793669116315685&alt=media" },
        },
    },
    {
        name = "Dawnbringer Thrown Items",
        slot = SLOT_THIRD_ROW_CENTER,
        items = {
            { name = "Smoke Bomb", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ae9381641223720faada41c_itemCardFront_2026-11-03_01-29-18.png?generation=1793669359816702&alt=media" },
            { name = "Numbing Flask", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ae9390441223720faada4ed_itemCardFront_2026-11-03_01-32-21.png?generation=1793669542557628&alt=media" },
            { name = "Tainted Caltrops", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ae939b941223720faada59d_itemCardFront_2026-11-03_01-35-19.png?generation=1793669720792617&alt=media" },
        },
    },
    {
        name = "Dawnbringer Utility Items",
        slot = SLOT_THIRD_ROW_RIGHTMOST,
        items = {
            { name = "Harpoon Tether", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ac6b0acb907464b87ac73ba_itemCardFront_2026-11-03_01-35-55.png?generation=1793669757043240&alt=media" },
            { name = "Ancient Technology", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ae9232b41223720faad9d50_itemCardFront_2026-11-03_01-36-44.png?generation=1793669805000243&alt=media" },
            { name = "Mutagen Syringe", front = "https://storage.googleapis.com/download/storage/v1/b/gloomhaven/o/upload%2F6ae93aba41223720faada69f_itemCardFront_2026-11-03_01-40-12.png?generation=1793670012918715&alt=media" },
        },
    },
}
local ITEM_BACK_URL = "https://raw.githubusercontent.com/kiltev/Dawnbringer/main/items/item-back.png"
local CUSTOM_DECK_CARD_ID_MULTIPLIER = 100
local SOLO_ITEM_NAME = "Dawnbringer Solo Scenario Item"
local SOLO_ITEM_CARD_ID = 100
local SOLO_ITEM_ART = {
    ["1"] = {
        FaceURL = "https://raw.githubusercontent.com/kiltev/Dawnbringer/main/items/solo/solo-front.png?v=3",
        BackURL = "https://raw.githubusercontent.com/kiltev/Dawnbringer/main/items/solo/solo-back.png?v=3",
        NumWidth = 1,
        NumHeight = 1,
        BackIsHidden = true,
        UniqueBack = true,
        Type = 0,
    },
}
local ITEM_CARD_TRANSFORM = { scaleX = 0.93, scaleY = 1, scaleZ = 0.93 }
local LOAD_TIMEOUT_SECONDS = 8
local ITEM_SPREAD_DISTANCE = 0.75
local SOLO_ITEM_CIRCLES = {
    { across = 0.1777, down = 0.7804 },
    { across = 0.4805, down = 0.7797 },
    { across = 0.7822, down = 0.7797 },
}
local IMAGE_CENTER = 0.5
local SLOT_BELOW_CHARACTER_BOX = { -0.384, 0.1, 0.912 }
local DECK_ROTATION = { 0, 180, 0 }
local PLAYER_MAT_TAG = "Player Mat"
local OWNER_TAG_PREFIX = "Owner "
local REGISTER_DELAY_SECONDS = 0.5

local function addDeckCardNames(names, deck)
    for _, card in ipairs(deck.getObjects()) do
        names[card.name] = true
    end
end

local function namesOnTable()
    local names = {}
    for _, object in ipairs(getObjects()) do
        names[object.getName()] = true
        if object.type == "Deck" then addDeckCardNames(names, object) end
    end
    return names
end

local function isPackOnTable(pack, names)
    for _, item in ipairs(pack.items) do
        if names[item.name] then return true end
    end
    return false
end

local function isLoaded(object)
    return not object.spawning and not object.loading_custom
end

local function isSettled(object)
    return isLoaded(object) and object.resting
end

local function playerMat(playerNumber)
    for _, object in ipairs(getObjectsWithTag(OWNER_TAG_PREFIX .. playerNumber)) do
        if object.hasTag(PLAYER_MAT_TAG) then return object end
    end
    return nil
end

local function itemArt(frontUrl)
    return {
        FaceURL = frontUrl,
        BackURL = ITEM_BACK_URL,
        NumWidth = 1,
        NumHeight = 1,
        BackIsHidden = true,
        UniqueBack = false,
        Type = 0,
    }
end

local function itemCardData(name, cardId, customDeck)
    return { Name = "Card", Nickname = name, CardID = cardId, Transform = ITEM_CARD_TRANSFORM, CustomDeck = customDeck }
end

local function packDeckData(pack)
    local cards, cardIds, customDeck = {}, {}, {}
    for index, item in ipairs(pack.items) do
        local deckKey = tostring(index)
        customDeck[deckKey] = itemArt(item.front)
        cardIds[index] = index * CUSTOM_DECK_CARD_ID_MULTIPLIER
        cards[index] = itemCardData(item.name, cardIds[index], { [deckKey] = customDeck[deckKey] })
    end
    return {
        Name = "DeckCustom", Nickname = pack.name, Transform = ITEM_CARD_TRANSFORM,
        DeckIDs = cardIds, CustomDeck = customDeck, ContainedObjects = cards,
    }
end

local function spawnItemPack(mat, pack)
    spawnObjectData({
        data = packDeckData(pack),
        position = mat.positionToWorld(pack.slot),
        rotation = DECK_ROTATION,
        callback_function = function(deck)
            Wait.condition(function() deck.spread(ITEM_SPREAD_DISTANCE) end, function() return isSettled(deck) end, LOAD_TIMEOUT_SECONDS)
        end,
    })
end

local function soloItemData()
    return {
        Name = "Card",
        Nickname = SOLO_ITEM_NAME,
        CardID = SOLO_ITEM_CARD_ID,
        Transform = ITEM_CARD_TRANSFORM,
        CustomDeck = SOLO_ITEM_ART,
    }
end

local function snapPointOver(card, circle)
    local bounds = card.getBounds()
    return {
        position = card.positionToLocal({
            x = bounds.center.x + (circle.across - IMAGE_CENTER) * bounds.size.x,
            y = bounds.center.y + bounds.size.y / 2,
            z = bounds.center.z + (IMAGE_CENTER - circle.down) * bounds.size.z,
        }),
    }
end

local function addSnapPoints(card)
    local snapPoints = {}
    for index, circle in ipairs(SOLO_ITEM_CIRCLES) do
        snapPoints[index] = snapPointOver(card, circle)
    end
    card.setSnapPoints(snapPoints)
end

local function spawnSoloItem(mat)
    spawnObjectData({
        data = soloItemData(),
        position = mat.positionToWorld(SLOT_BELOW_CHARACTER_BOX),
        rotation = DECK_ROTATION,
        callback_function = function(card)
            Wait.condition(function() addSnapPoints(card) end, function() return isLoaded(card) end, LOAD_TIMEOUT_SECONDS)
        end,
    })
end

local function spawnMissingItems(mat)
    local names = namesOnTable()
    for _, pack in ipairs(ITEM_PACKS) do
        if not isPackOnTable(pack, names) then spawnItemPack(mat, pack) end
    end
    if not names[SOLO_ITEM_NAME] then spawnSoloItem(mat) end
end

function onCharacterLoad(character, playerNumber)
    if character.class ~= CLASS_NAME then return end
    local mat = playerMat(playerNumber)
    if mat ~= nil then spawnMissingItems(mat) end
end

function __callExtension(request)
    return _G[request.event](table.unpack(request.parameters))
end

function onLoad()
    Wait.time(function()
        Global.call("__registerExtensions", { __caller = self.getGUID() })
    end, REGISTER_DELAY_SECONDS)
end
