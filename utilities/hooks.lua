local is_suit_ref = Card.is_suit

function Card:is_suit(suit, ...)
    if next(SMODS.find_card('j_ace_crimson_joker')) then
        if suit == 'Hearts' then
            return true
        end
    end

    return is_suit_ref(self, suit, ...)
end