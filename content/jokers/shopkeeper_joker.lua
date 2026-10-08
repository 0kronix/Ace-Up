SMODS.Joker {
    key = "shopkeeper_joker",

    atlas = "jokers",
    pos = { x = 1, y = 2 },

    rarity = 1,
    cost = 4,
    attributes = { "reroll" },

    blueprint_compat = false,
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
        if context.open_booster and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                func = function()
                    SMODS.change_free_rerolls(1)
                    G.FUNCS.reroll_shop()
                    SMODS.change_free_rerolls(-1)
                    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - 1
                    G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - 1)
                    return true
                end
            }))
        end
    end,
}
