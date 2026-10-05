SMODS.Joker {
    key = "balloon_jimbo",

    atlas = "jokers",
    pos = { x = 3, y = 1 },

    rarity = 1,
    cost = 6,
    attributes = { "chips" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { chips = 0, chips_gain = 10, active = false }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.chips_gain
            }
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.starting_shop then
                card.ability.extra.active = true
            end

            if context.buying_card and card.ability.extra.active then
                card.ability.extra.active = false

                return {
                    message = localize("ace_failed_ex"),
                    colour = G.C.RED
                }
            end

            if context.ending_shop and card.ability.extra.active then
                card.ability.extra.active = false

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

        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
	end
}
