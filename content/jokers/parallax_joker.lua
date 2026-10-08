SMODS.Joker {
    key = "parallax_joker",

    atlas = "jokers",
    pos = { x = 7, y = 1,
        layers = {
            { x = 8, y = 1 },
            { x = 9, y = 1 },
        }
    },

    rarity = 1,
    cost = 4,
    attributes = { "xmult", "joker" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { xmult = 3 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if #context.scoring_hand == #G.jokers.cards then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}
