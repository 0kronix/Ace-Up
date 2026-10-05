SMODS.Joker {
    key = "villian_hologram",

    atlas = "jokers",
    pos = { x = 2, y = 1 },

    rarity = 3,
    cost = 8,
    attributes = { "xmult" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { xmult = 1, xmult_gain = 0.2, hand = nil }
    },

    loc_vars = function(self, info_queue, card)
        local prev = card.ability.extra.hand
        local prev_name = localize('k_none')
        local colour = G.C.RED

        if prev and G.GAME.hands[prev] then
            prev_name = localize(prev, 'poker_hands')
            colour = G.C.GREEN
        end

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = ' ' .. prev_name .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                        }
                    }
                }
            }
        }

        return { 
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.xmult_gain,
            },
            main_end = main_end
        }
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.poker_hands[card.ability.extra.hand] and next(context.poker_hands[card.ability.extra.hand]) then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_table = card.ability.extra,
                    scalar_value = "xmult_gain",
                    operation = '+',
                    message_colour = G.C.MULT
                })
            end

            card.ability.extra.hand = context.scoring_name
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}
