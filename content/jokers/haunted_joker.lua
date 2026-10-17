SMODS.Joker {
    key = "haunted_joker",

    atlas = "jokers",
    pos = { x = 9, y = 0 },
    attributes = { "tarot" },

    rarity = 2,
    cost = 4,

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { percent = 10 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.percent
            }
        }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Tarot" then
            return {
                ace_blind_size = -card.ability.extra.percent
            }
        end
    end,
}
