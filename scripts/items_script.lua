local CLASS_NAME = "Dawnbringer"
local DECK_NAME = "Dawnbringer Items Deck"
local DECK_ART = {
    face = "https://raw.githubusercontent.com/kiltev/Dawnbringer/refs/heads/main/items/items-front.png?v=2",
    back = "https://raw.githubusercontent.com/kiltev/Dawnbringer/main/items/items-back.png?v=1",
    width = 3,
    height = 3,
    number = 9,
    back_is_hidden = true,
    unique_back = true,
}
local SOLO_ITEM_NAME = "Dawnbringer Solo Scenario Item"
local SOLO_ITEM_CARD_ID = 100
local SOLO_ITEM_ART = {
    ["1"] = {
        FaceURL = "https://raw.githubusercontent.com/kiltev/Dawnbringer/main/items/solo/solo-front.png",
        BackURL = "https://raw.githubusercontent.com/kiltev/Dawnbringer/main/items/solo/solo-back.png",
        NumWidth = 1,
        NumHeight = 1,
        BackIsHidden = true,
        UniqueBack = true,
        Type = 0,
    },
}
local SOLO_ITEM_TRANSFORM = { scaleX = 0.93, scaleY = 1, scaleZ = 0.93 }
local SOLO_ITEM_LOAD_TIMEOUT_SECONDS = 8
local SOLO_ITEM_CIRCLES = {
    { across = 0.1921, down = 0.7570 },
    { across = 0.4719, down = 0.7577 },
    { across = 0.7517, down = 0.7570 },
}
local IMAGE_CENTER = 0.5
local SLOT_RIGHT_OF_LOCKED_MODIFIERS = { -0.192, 0.1, 0.912 }
local SLOT_BELOW_CHARACTER_BOX = { -0.384, 0.1, 0.912 }
local DECK_ROTATION = { 0, 180, 0 }
local ITEM_CARD_SCALE = { 0.93, 1, 0.93 }
local PLAYER_MAT_TAG = "Player Mat"
local OWNER_TAG_PREFIX = "Owner "
local REGISTER_DELAY_SECONDS = 0.5

local function exists(name)
    for _, object in ipairs(getObjects()) do
        if object.getName() == name then return true end
    end
    return false
end

local function playerMat(playerNumber)
    for _, object in ipairs(getObjectsWithTag(OWNER_TAG_PREFIX .. playerNumber)) do
        if object.hasTag(PLAYER_MAT_TAG) then return object end
    end
    return nil
end

local function dressDeck(deck)
    deck.setCustomObject(DECK_ART)
    deck.setName(DECK_NAME)
    deck.reload()
end

local function spawnItemDeck(mat)
    spawnObject({
        type = "DeckCustom",
        position = mat.positionToWorld(SLOT_RIGHT_OF_LOCKED_MODIFIERS),
        rotation = DECK_ROTATION,
        scale = ITEM_CARD_SCALE,
        sound = false,
        callback_function = dressDeck,
    })
end

local function soloItemData()
    return {
        Name = "Card",
        Nickname = SOLO_ITEM_NAME,
        CardID = SOLO_ITEM_CARD_ID,
        Transform = SOLO_ITEM_TRANSFORM,
        CustomDeck = SOLO_ITEM_ART,
    }
end

local function isLoaded(card)
    return not card.spawning and not card.loading_custom
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
            Wait.condition(function() addSnapPoints(card) end, function() return isLoaded(card) end, SOLO_ITEM_LOAD_TIMEOUT_SECONDS)
        end,
    })
end

local function spawnMissingItems(mat)
    if not exists(DECK_NAME) then spawnItemDeck(mat) end
    if not exists(SOLO_ITEM_NAME) then spawnSoloItem(mat) end
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
