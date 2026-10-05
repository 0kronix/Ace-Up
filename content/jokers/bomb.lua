SMODS.Joker {
    key = "bomb",

    atlas = "jokers",
    pos = { x = 0, y = 1 },

    rarity = 1,
    cost = 3,
    attributes = { "xmult" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { xmult = 2 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
    	if context.individual and context.cardarea == G.play then
            if next(SMODS.get_enhancements(context.other_card)) == nil then
                return {
                    xmult = card.ability.extra.xmult,
                    message_card = context.other_card
                }
            end
        end

        if context.after and SMODS.last_hand_oneshot then
            local left_joker, right_joker = G.jokers.cards[ACE.get_pos(card, G.jokers.cards) - 1], G.jokers.cards[ACE.get_pos(card, G.jokers.cards) + 1]
            local cards_to_destroy = {card}

            if left_joker and not left_joker.ability["eternal"] then
                table.insert(cards_to_destroy, left_joker)
            end
            if right_joker and not right_joker.ability["eternal"] then
                table.insert(cards_to_destroy, right_joker)
            end

            SMODS.destroy_cards(cards_to_destroy)
            return {
                message = localize("ace_boom_ex"),
                colour = G.C.RED
            } 
        end
	end
}
