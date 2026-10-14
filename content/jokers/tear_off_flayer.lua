SMODS.Joker {
    key = "tear_off_flayer",

    atlas = "jokers",
    pos = { x = 4, y = 3 },
    pixel_size = { w = 67, h = 62 },

    rarity = 2,
    cost = 6,
    attributes = { "xmult", "joker", "chips" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { xmult = 3, chips = 30 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.chips
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local left_joker, right_joker

            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    left_joker = G.jokers.cards[i - 1]
                    right_joker = G.jokers.cards[i + 1]
                end
            end

            if left_joker and right_joker and left_joker.config.center.rarity == right_joker.config.center.rarity then
                return {
                    xmult = card.ability.extra.xmult
                }
            else
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end,
}
