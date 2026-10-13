SMODS.Joker {
    key = "sparky",

    atlas = "jokers",
    pos = { x = 1, y = 3 },

    rarity = 2,
    cost = 6,
    attributes = { "mult", "sell_value" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { mult = 0 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult
            }
        }
    end,

    calculate = function(self, card, context)
    	if context.end_of_round and not context.blueprint and context.main_eval then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_table = card,
                scalar_value = "sell_cost",
                operation = '+',
                message_colour = G.C.MULT
            })
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}
