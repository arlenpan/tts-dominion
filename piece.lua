colors = Global.getTable('colors')
kingdomCards = Global.getTable('kingdomCards')
deckIds = {
    copper = '499603',
    silver = '3e0dca',
    gold = '2e96bd',
    curse = 'a9beff',
    estate = '89d0fb',
    duchy = 'a9bffc',
    province = '53c022'
}
kingdomZones = {
    '964164',
    'e857a8',
    '98e05d',
    'adc377',
    '309cf4',
    'bb6a9f',
    'bb1559',
    '5cbbaf',
    '8c43f1',
    '272370'   
}
victoryPointCards = {
    ['4b1abe'] = true,
    ['d2fe74'] = true,
    ['2aeca2'] = true,
    ['6b18e9'] = true,
    ['752a52'] = true
}
text = {'0df7ac', '9b0ea3'}
expansions = { 
    dominion = '499432', 
    intrigue = '81d37f',
    prosperity = 'b69a12'
}

function onLoad()
    self.createButton({
        click_function = "onGameStart",
        function_owner = self,
        label = "Start Game",
        position = {0, 0.2, 0},
        rotation = {0, 180, 0},
        width = 2000,
        height = 400,
        scale = {5, 5, 5},
        font_size = 340,
        color = {1, 1, 1},
        font_color = {0, 0, 0}
    })
end

function onGameStart()
    removeExtraCards()
    dealStartingHand()
    createKingdomCards()
    cleanUpBoard()
    calculateFirstPlayer()
end

function removeExtraCards()
    print('Settings cards for player count...')
    playerCount = #getSeatedPlayers()
    copperDeck = getObjectFromGUID(deckIds.copper)
    silverDeck = getObjectFromGUID(deckIds.silver)
    goldDeck = getObjectFromGUID(deckIds.gold)
    estateDeck = getObjectFromGUID(deckIds.estate)
    duchyDeck = getObjectFromGUID(deckIds.duchy)
    provinceDeck = getObjectFromGUID(deckIds.province)
    curseDeck = getObjectFromGUID(deckIds.curse)

    -- 1-4 cut treasures in half
    if (playerCount < 5) then
        copperDeck.split(2)[1].destruct()
        silverDeck.split(2)[1].destruct()
        goldDeck.split(2)[1].destruct()
    end

    if playerCount == 2 then
        cutCurseDeck(20)
        cutEstateDeck(playerCount * 3 + 8)
        cutDuchyDeck(8)
        cutProvinceDeck(8)
    elseif playerCount == 3 or playerCount == 4 then
        cutCurseDeck(30)
        cutEstateDeck(playerCount * 3 + 12)
        cutProvinceDeck(12)
    elseif playerCount == 5 then
        cutCurseDeck(40)
        cutEstateDeck(playerCount * 3 + 12)
        cutProvinceDeck(15)
    end
end

function cutCurseDeck(num)
    initialCount = 50
    curseDeck = getObjectFromGUID(deckIds.curse)
    curseDeck.cut(initialCount - num)[2].destruct()
end
function cutEstateDeck(num, playerCount)
    initialCount = 30
    estateDeck = getObjectFromGUID(deckIds.estate)
    estateDeck.cut(initialCount - num)[2].destruct()
end
function cutDuchyDeck(num, playerCount)
    initialCount = 12
    duchyDeck = getObjectFromGUID(deckIds.duchy)
    duchyDeck.cut(initialCount - num)[2].destruct()
end
function cutProvinceDeck(num)
    initialCount = 18
    provinceDeck = getObjectFromGUID(deckIds.province)
    provinceDeck.cut(initialCount - num)[2].destruct()
end

function dealStartingHand()
    print('Dealing starting deck...')
    for _,playerColor in ipairs(getSeatedPlayers()) do
        copperDeck = getObjectFromGUID(deckIds.copper)
        estateDeck = getObjectFromGUID(deckIds.estate)
        deckZoneID = colors[playerColor].deckZoneID
        deckZone = getObjectFromGUID(deckZoneID)
        
        copperSplit = copperDeck.cut(7)
        copperSplit[2].setPositionSmooth(deckZone.getPosition())

        estateSplit = estateDeck.cut(3)
        estateSplit[2].setPositionSmooth(deckZone.getPosition())
    end
    Wait.frames(shuffleDecks, 120)
    Wait.frames(dealDecks, 120)
end

function shuffleDecks()
    for _,playerColor in ipairs(getSeatedPlayers()) do
        deckZoneID = colors[playerColor].deckZoneID
        deckZone = getObjectFromGUID(deckZoneID)
        startingDeck = deckZone.getObjects()

        for _,object in ipairs(startingDeck) do
            print(object.tag)
            if (object.tag == 'Deck') then
                object.setRotation(colors[playerColor].rotation)
                object.randomize()
                object.flip()
            end
        end
    end
end

function dealDecks()
    for _,playerColor in ipairs(getSeatedPlayers()) do
        deckZoneID = colors[playerColor].deckZoneID
        deckZone = getObjectFromGUID(deckZoneID)
        handZonePos = Player[playerColor].getHandTransform().position
        startingDeck = deckZone.getObjects()

        for _,object in ipairs(startingDeck) do
            if (object.tag == 'Deck') then
                object.deal(5, playerColor)
            end
        end
    end
end

function createKingdomCards()
    for i,zoneId in ipairs(kingdomZones) do
        zone = getObjectFromGUID(zoneId)
        objects = zone.getObjects()
        for _,obj in ipairs(objects) do
            if (obj.getGUID() ~= kingdomCards[i]) then
                count = victoryPointCards[obj.getGUID()] ~= nil and 11 or 9
                for i = 1, count do
                    obj.clone({ position = zone.getPosition() })
                end
            end
        end
    end
end

function cleanUpBoard()
    for _,objGUID in ipairs(text) do
        obj = getObjectFromGUID(objGUID)
        obj.destruct()
    end
    for name,objGUID in pairs(expansions) do
        obj = getObjectFromGUID(objGUID)
        obj.destruct()
    end

    self.destruct()
end

function calculateFirstPlayer()
    players = getSeatedPlayers()
    print('First Player: ', players[ math.random(#players) ])
end