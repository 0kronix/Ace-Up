SMODS.Joker {
    key = "jimbos_lost_coin",
    pixel_size = { w = 27, h = 27 },

    atlas = "jokers",
    pos = { x = 6, y = 3 },

    rarity = 3,
    cost = 9,
    attributes = { "xmult", "sell_value" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { xmult = 1, xmult_gain = 0.2, cur_sell = 0, sell = 20 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.sell,
                card.ability.extra.cur_sell,
                card.ability.extra.xmult,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint then
            card.ability.extra.cur_sell = card.ability.extra.cur_sell + context.card.sell_cost

            if card.ability.extra.cur_sell >= card.ability.extra.sell then
                card.ability.extra.cur_sell = card.ability.extra.cur_sell - card.ability.extra.sell

                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_table = card.ability.extra,
                    scalar_value = "xmult_gain",
                    operation = '+',
                    message_colour = G.C.MULT
                })
            else
                return {
                    message = "+$" .. tostring(context.card.sell_cost),
                    colour = G.C.MONEY
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
	end
}
