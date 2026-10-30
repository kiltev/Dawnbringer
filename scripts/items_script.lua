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
local SLOT_BELOW_CHARACTER_BOX = { -0.384, 0.1, 0.912 }
local DECK_ROTATION = { 0, 180, 0 }
local ITEM_CARD_SCALE = { 0.93, 1, 0.93 }
local PLAYER_MAT_TAG = "Player Mat"
local OWNER_TAG_PREFIX = "Owner "
local REGISTER_DELAY_SECONDS = 0.5

local function deckExists()
    for _, object in ipairs(getObjects()) do
        if object.getName() == DECK_NAME then return true end
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
        position = mat.positionToWorld(SLOT_BELOW_CHARACTER_BOX),
        rotation = DECK_ROTATION,
        scale = ITEM_CARD_SCALE,
        sound = false,
        callback_function = dressDeck,
    })
end

function onCharacterLoad(character, playerNumber)
    if character.class ~= CLASS_NAME or deckExists() then return end
    local mat = playerMat(playerNumber)
    if mat ~= nil then spawnItemDeck(mat) end
end

function __callExtension(request)
    return _G[request.event](table.unpack(request.parameters))
end

function onLoad()
    Wait.time(function()
        Global.call("__registerExtensions", { __caller = self.getGUID() })
    end, REGISTER_DELAY_SECONDS)
end
