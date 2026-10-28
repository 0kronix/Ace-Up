SMODS.Joker {
    key = "hug_ticket",

    atlas = "jokers",
    pos = { x = 7, y = 3 },
    attributes = { "generation" },

    rarity = 2,
    cost = 6,

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { voucher = 2, cur_rounds = 0, rounds = 3 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.voucher,
                card.ability.extra.cur_rounds,
                card.ability.extra.rounds,
            }
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.end_of_round and context.main_eval then
				card.ability.extra.cur_rounds = card.ability.extra.cur_rounds + 1

				if card.ability.extra.cur_rounds == card.ability.extra.rounds then
					local eval = function(card)
						return not card.REMOVED
					end

					juice_card_until(card, eval, true)
				end

				return {
					message = (card.ability.extra.cur_rounds < card.ability.extra.rounds)
						and (card.ability.extra.cur_rounds .. "/" .. card.ability.extra.rounds)
						or localize("k_active_ex"),
				}
            end

            if context.selling_self and card.ability.extra.cur_rounds >= card.ability.extra.rounds then
                for i = 1, card.ability.extra.voucher do
                    ACE.create_voucher(nil, "hug" .. i, 0)
                end
            end
        end
    end
}
