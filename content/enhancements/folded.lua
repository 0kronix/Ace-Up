SMODS.Enhancement({
    key = "folded",

    atlas = "enhancements",
    pos = { x = 0, y = 0 },

    replace_base_card = false,
    no_rank = false,
    no_suit = false,
    always_scores = false,

    config = { xmult = 1, xmult_gain = 0.1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.xmult_gain, card.ability.xmult } }
    end,

    calculate = function(self, card, context)
        if context.discard then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "xmult",
                scalar_table = card.ability,
                scalar_value = "xmult_gain",
                operation = '+',
                message_colour = G.C.MULT
            })
        end

        if context.after and context.cardarea == G.play then
            card.ability.xmult = 1

            return {
                message = localize("k_reset"),
                colour = G.C.MULT
            }
        end

        if context.main_scoring and context.cardarea == G.play then
            return {
                xmult = card.ability.xmult
            }
        end
    end,
})