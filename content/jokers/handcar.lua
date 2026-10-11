SMODS.Joker {
    key = "handcar",

    atlas = "jokers",
    pos = { x = 7, y = 2 },
    attributes = { "chips", "hand_type" },

    rarity = 2,
    cost = 7,

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { chips = 0, chips_gain = 4 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.chips_gain,
            }
        }
    end,

    calculate = function(self, card, context)
		if context.pre_discard and not context.blueprint then
			if G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
                if G.FUNCS.get_poker_hand_info(G.hand.highlighted) == "Pair" then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chips",
                        scalar_table = card.ability.extra,
                        scalar_value = "chips_gain",
                        operation = '+',
                        message_colour = G.C.CHIPS
                    })
		        end
	        end
	    end

	    if context.joker_main then
	    	return {
	    		chips = card.ability.extra.chips,
	    	}
	    end
    end,
}
