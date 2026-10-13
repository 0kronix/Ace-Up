SMODS.Joker {
    key = "gold_bar",

    atlas = "jokers",
    pos = { x = 2, y = 3 },
    attributes = { "economy" },

    rarity = 3,
    cost = 7,

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { dollars = 4 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
    end,
}
