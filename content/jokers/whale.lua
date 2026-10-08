SMODS.Joker {
    key = "whale",

    atlas = "jokers",
    pos = { x = 0, y = 2 },
    attributes = { "tarot" },

    rarity = 2,
    cost = 6,

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = {}
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            G.from_boss_tag = true
            G.FUNCS.reroll_boss()
        end
    end,
}
