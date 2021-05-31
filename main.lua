green = {
    name = 'Green',
    boardID = 'dc72a0',
    boardZoneID = '4c0482',
    deckID = '291c75',
    deckZoneID = 'df9514',
    discardID = 'ba36ae',
    discardZoneID = '40babd',
    rotation = { 0, 0, 0 }
}
blue = {
    name = 'Blue',
    boardID = 'e36209',
    boardZoneID = 'd749e0',
    deckID = '60c6e2',
    deckZoneID = 'f01c1b',
    discardID = '48597e',
    discardZoneID = '783ac7',
    rotation = { 0, 0, 0 }
}
red = {
    name = 'Red',
    boardID = 'fb9073',
    boardZoneID = 'b8931e',
    deckID = 'cd5025',
    deckZoneID = '95ca0a',
    discardID = '6236b8',
    discardZoneID = '38eafb',
    rotation = { 0, 180, 0 }
}
white = {
    name = 'White',
    boardID = '83f0f3',
    boardZoneID = 'afdc82',
    deckID = '37de21',
    deckZoneID = 'f7b928',
    discardID = '9fe20a',
    discardZoneID = 'e87c6a',
    rotation = { 0, 180, 0 }
}
purple = {
    name = 'Purple',
    boardID = 'b23052',
    boardZoneID = 'f97528',
    deckID = 'c1be07',
    deckZoneID = '109c3b',
    discardID = 'b43b0c',
    discardZoneID = '8913f3',
    rotation = { 0, 270, 0 }
}
orange = {
    name = 'Orange',
    boardID = '3b6387',
    boardZoneID = '55cd90',
    deckID = '410786',
    deckZoneID = '4a37c7',
    discardID = '4dd12b',
    discardZoneID = 'fef079',
    rotation = { 0, 90, 0 }
}
colors = {
    Green = green,
    Blue = blue,
    Red = red,
    White = white,
    Purple = purple,
    Orange = orange
}
kingdomCards = {
    '21b962',
    '0396bf',
    '166bf0',
    'd0f787',
    'e18313',
    '240721',
    'b4de93',
    'e371e2',
    'ae3581',
    'bb2a30'
}

-- ============================================================

function onLoad()
    print('Loading!')
    for key,value in pairs(colors) do
        createDiscardButton(value)
        createRefillButton(value)
    end
end

function onUpdate()
    
end

-- ============================================================

function createDiscardButton(player)
    discard = getObjectFromGUID(player.boardID)
    discard.createButton({
        click_function = "sendToDiscard"..player.name,
        function_owner = self,
        label = "Send to Discard",
        position = {-5, 0.6, -8},
        rotation = {0, 0, 0},
        width = 3000,
        height = 400,
        font_size = 340,
        color = {1, 1, 1},
        font_color = {0, 0, 0}
    })
end
for key,value in pairs(colors) do
    _G['sendToDiscard'..value.name] = function()
        sendToDiscard(value)
    end
end
function sendToDiscard(player)
    boardZone = getObjectFromGUID(player.boardZoneID)
    discardZone = getObjectFromGUID(player.discardZoneID)

    objects = boardZone.getObjects()
    for _,object in ipairs(objects) do
        if object.tag == 'Deck' or object.tag == 'Card' then
            object.setPositionSmooth(discardZone.getPosition())
            object.setRotationSmooth(player.rotation)
        end
    end
end

-- ============================================================

function createRefillButton(player)
    deck = getObjectFromGUID(player.deckID)
    deck.createButton({
        click_function = "refill"..player.name,
        function_owner = self,
        label = "Refill",
        position = {0, 0.3, 0},
        rotation = {0, 0, 0},
        width = 1000,
        height = 400,
        font_size = 340,
        color = {1, 1, 1},
        font_color = {0, 0, 0}
    })
end
for key,value in pairs(colors) do
    _G['refill'..value.name] = function()
        refill(value)
    end
end
function refill(player)
    discardZone = getObjectFromGUID(player.discardZoneID)
    deckZone = getObjectFromGUID(player.deckZoneID)

    objects = discardZone.getObjects()
    for _,object in ipairs(objects) do
        if object.tag == 'Deck' then
            object.flip()
            object.randomize()
            object.setPositionSmooth(deckZone.getPosition())
        end
    end
end

-- ============================================================

function createBuyButtons() 
    for i,cardGUID in ipairs(kingdomCards) do
        card = getObjectFromGUID(cardGUID)
        card.createButton({
            click_function = "buyCard"..cardGUID,
            function_owner = self,
            label = "Buy",
            position = {0, 0.3, i < 6 and -2 or 2},
            rotation = {0, 0, 0},
            width = 1000,
            height = 400,
            font_size = 340,
            color = {1, 1, 1},
            font_color = {0, 0, 0}
        })
    end
end
for i,cardGUID in ipairs(kingdomCards) do
    _G['buyCard'..cardGUID] = function()
        buyCard(cardGUID)
    end
end
function buyCard(cardGUID)
    print(cardGUID)
end