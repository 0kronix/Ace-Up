local is_suit_ref = Card.is_suit
function Card:is_suit(suit, ...)
    if next(SMODS.find_card('j_ace_crimson_joker')) then
        if suit == 'Hearts' then
            return true
        end
    end

    return is_suit_ref(self, suit, ...)
end



local highlight_ref = Card.highlight
function Card:highlight(is_highlighted)
    highlight_ref(self, is_highlighted)

    ACE.remove_gold_sell_button(self)

    if is_highlighted
        and ACE.is_gold_card(self)
        and self.area == G.hand
        and ACE.gold_selling_enabled()
    then
        ACE.attach_gold_sell_button(self)
    end
end

local can_sell_ref = Card.can_sell_card
function Card:can_sell_card(context)
    if ACE.can_sell_gold_card(self) then
        ACE.update_gold_sell_cost(self)
        return true
    end
    return can_sell_ref(self, context)
end

local sell_card_ref = Card.sell_card
function Card:sell_card()
    if ACE.is_gold_card(self) and self.area == G.hand then
        return ACE.sell_gold_card(self)
    end
    return sell_card_ref(self)
end

G.FUNCS.ace_can_sell_gold_card = function(e)
    local card = e.config.ref_table
    if ACE.can_sell_gold_card(card) then
        ACE.update_gold_sell_cost(card)
        e.config.colour = G.C.GREEN
        e.config.button = 'ace_sell_gold_card'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.ace_sell_gold_card = function(e)
    ACE.sell_gold_card(e.config.ref_table)
end