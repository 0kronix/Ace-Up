SMODS.Enhancement({
    key = "folded",

    atlas = "enhancements",
    pos = { x = 0, y = 0 },

    replace_base_card = false,
    no_rank = false,
    no_suit = false,
    always_scores = false,

    config = { xmult = 1, xmult_gain = 0.5 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.xmult_gain, card.ability.xmult } }
    end,

    calculate = function(self, card, context)
        if context.pre_discard then
            for _, hcard in ipairs(G.hand.highlighted) do
                if hcard == card then
                    SMODS.scale_card(card, {
                        ref_table = card.ability,
                        ref_value = "xmult",
                        scalar_table = card.ability,
                        scalar_value = "xmult_gain",
                        operation = '+',
                        message_colour = G.C.MULT
                    })
                end
            end
        end

        if context.after and context.cardarea == G.play then
            for _, scard in ipairs(context.scoring_hand) do
                if scard == card then
                    card.ability.xmult = 1

                    return {
                        message = localize("k_reset"),
                        colour = G.C.MULT
                    }
                end
            end
        end

        if context.main_scoring and context.cardarea == G.play then
            return {
                xmult = card.ability.xmult
            }
        end
    end,
})