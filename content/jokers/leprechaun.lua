SMODS.Joker {
    key = "leprechaun",

    atlas = "jokers",
    pos = { x = 1, y = 1 },

    rarity = 2,
    cost = 8,
    attributes = { "mod_chance", "economy" },

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { money = 25, prob_gain = 1, prob = 0, max_prob = 5 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.money,
                card.ability.extra.prob_gain,
                card.ability.extra.prob,
                card.ability.extra.max_prob,
            }
        }
    end,

    update = function(self, card, dt)
        card.ability.extra.prob = math.min(card.ability.extra.max_prob,
        math.floor(((G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)) / card.ability.extra.money))
    end,

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator + card.ability.extra.prob
            }
        end
    end
}
