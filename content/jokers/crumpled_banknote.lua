SMODS.Joker {
    key = "crumpled_banknote",

    atlas = "jokers",
    pos = { x = 8, y = 0 },

    rarity = 1,
    cost = 2,
    attributes = { "sell_value" },

    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { min_money = 1, max_money = 19 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.min_money + 1,
                card.ability.extra.max_money + 1
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and context.cardarea == G.jokers then
			card.ability.extra_value = pseudorandom("banknote", card.ability.extra.min_money, card.ability.extra.max_money)
			card:set_cost()
			return {
				message = localize('k_val_up'),
				colour = G.C.MONEY
			}
		end
    end,
}
