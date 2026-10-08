SMODS.Joker {
    key = "joker_window",

    atlas = "jokers",
    pos = { x = 6, y = 1 },

    rarity = 1,
    cost = 2,
    attributes = { "mult", "economy" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { mult = 20, cost = 4, cur_rounds = 5, rounds = 5 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.cost,
                card.ability.extra.cur_rounds,
                card.ability.extra.rounds,
            }
        }
    end,

    calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and context.cardarea == G.jokers then
			card.ability.extra.cur_rounds = card.ability.extra.cur_rounds - 1

            return {
                message = tostring(card.ability.extra.cur_rounds),
            }
		end

        if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
		end
    end,

	calc_dollar_bonus = function(self, card)
        if card.ability.extra.cur_rounds <= 0 then
        	card.ability.extra.rounds = 5
			return (-card.ability.extra.cost)
		end
    end
}
