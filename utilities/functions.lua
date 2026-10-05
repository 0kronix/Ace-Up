function ACE.ease_blind(percent)
    G.GAME.blind.chips = G.GAME.blind.chips + math.ceil(G.GAME.blind.chips * (percent * 0.01))
    G.E_MANAGER:add_event(Event({
        trigger = "ease",
        delay = 0.5,
        ref_table = G.GAME.blind,
        ref_value = "chip_text",
        ease_to = G.GAME.blind.chips,
        func = (function(t)
            return math.floor(t)
        end)
    }))
end

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
