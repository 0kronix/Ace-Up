local is_suit_ref = Card.is_suit
function Card:is_suit(suit, ...)
    if next(SMODS.find_card('j_ace_crimson_joker')) then
        if suit == 'Hearts' then
            return true
        end
    end

    return is_suit_ref(self, suit, ...)
end



local play_cards_ref = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted(e)
    local result = play_cards_ref(e)

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()

            local hand,_,_,_,_ = G.FUNCS.get_poker_hand_info(G.play.cards)
            for _, tag in ipairs(G.GAME.tags) do
                if not tag.triggered then
                    tag:apply_to_run({ hand_played = true, hand = hand, cards = G.play.cards })
                end
            end

            return true
        end
    }))

    return result
end
