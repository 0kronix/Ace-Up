function ACE.in_table(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end



function ACE.is_only_different_suits(hand)
    local suits = {}

    for _, scoring_card in ipairs(hand) do
        if ACE.in_table(suits, scoring_card.base.suit) then
            return false
        else
            table.insert(suits, scoring_card.base.suit)
        end
    end

    return true
end



ACE.get_pos = function(card, area)
    for i, v in ipairs(area) do
        if v == card then
            return i
        end
    end

    return 0
end



ACE.upgrade_all_hands = function(card, level)
    level = level or 1

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+' .. tostring(level)})
    delay(1.3)

    for k, v in pairs(G.GAME.hands) do
        SMODS.smart_level_up_hand(card, k, true, level)
    end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    card:juice_up(0.3, 0.5)
end



ACE.count_suits_in_deck = function(suit)
    local count = 0

    for _, card in ipairs(G.playing_cards) do
        if card:is_suit(suit) then
            count = count + 1
        end
    end

    return count
end



function ACE.create_tag(tag, seed)
    local tag_pool = get_current_pool('Tag')
    local it = 1

    if tag == nil then
        tag = pseudorandom_element(tag_pool, seed)
    else
        return add_tag(Tag(tag, false, 'Small'))
    end

    while tag == 'UNAVAILABLE' do
        it = it + 1
        tag = pseudorandom_element(tag_pool, seed .. it)
    end

    return add_tag(Tag(tag, false, 'Small'))
end



function ACE.consume(card, colour)
    colour = colour or G.C.FILTER

    SMODS.destroy_cards(card, nil, nil, true)

    return {
        message = localize('k_eaten_ex'),
        card = card,
        message_card = card,
        colour = colour,
    }
end



function ACE.get_visible_hands()
    local visible = {}

    for _, hand_key in ipairs(G.handlist) do
        if G.GAME.hands[hand_key] and G.GAME.hands[hand_key].visible then
            table.insert(visible, hand_key)
        end
    end

    return visible
end



ACE.add_to_deck = function(card)
    card:add_to_deck()
    G.deck.config.card_limit = G.deck.config.card_limit + 1
    table.insert(G.playing_cards, card)

    G.deck:emplace(card)
    card.states.visible = nil

    G.E_MANAGER:add_event(Event({
        func = function()
            card:start_materialize()
            return true
        end
    }))
end



ACE.get_of_a_kind_hands = function()
    if not G or not G.GAME or not G.GAME.hands then return nil end
    local of_a_kind = {}

    for hand_key, hand_data in pairs(G.GAME.hands) do
        if type(hand_key) == "string" and hand_key:lower():find("of a kind", 1, true) then
            table.insert(of_a_kind, hand_key)
        end
    end

    return of_a_kind
end



ACE.get_random_card_in_pool = function(pool, seed)
    local cards = {}

    for k, v in pairs(G.P_CENTER_POOLS[pool]) do
        cards[#cards + 1] = v.key
    end

    local chosen_key = pseudorandom_element(cards, seed)

    return chosen_key
end

