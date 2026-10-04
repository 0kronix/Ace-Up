SMODS.Joker {
    key = "computer_joker",

    atlas = "jokers",
    pos = { x = 5, y = 0 },

    rarity = 3,
    cost = 7,
    attributes = { "hand_size", "reroll" },

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { hand_size_gain = 1, hand_size = 0, max_hand_size = 5 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.hand_size_gain,
                card.ability.extra.hand_size,
                card.ability.extra.max_hand_size
            }
        }
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,

    calculate = function(self, card, context)
    	if context.reroll_shop and not context.blueprint then
            if card.ability.extra.hand_size < card.ability.extra.max_hand_size then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "hand_size",
                    scalar_table = card.ability.extra,
                    scalar_value = "hand_size_gain",
                    operation = '+',
                    message_colour = G.C.FILTER
                })
            end
        end

        if context.setting_blind and not context.blueprint then
            G.hand:change_size(card.ability.extra.hand_size)

            if card.ability.extra.hand_size > 0 then
                return {
                    message = localize( {
                        type = "variable",
                        key = "k_ace_plus_hand_size",
                        vars = { card.ability.extra.hand_size }
                    } )
                }
            end
        end

        if context.end_of_round and not context.blueprint and context.cardarea == G.jokers then
            G.hand:change_size(-card.ability.extra.hand_size)

            if card.ability.extra.hand_size > 0 then
                card.ability.extra.hand_size = 0

                return {
                    message = localize("k_reset")
                }
            end
        end
	end
}
