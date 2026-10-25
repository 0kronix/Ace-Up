SMODS.Blind {
    key = "the_friday",

    atlas = 'blinds',
    pos = { x = 0, y = 4},

    dollars = 5,
    mult = 2,
    boss = { min = 1 },

    boss_colour = HEX("56a4a7"),
    discovered = true,

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.after then
                local mv_joker = ACE.get_most_sell_item(G.jokers.cards)

                if mv_joker and mv_joker.sell_cost ~= 0 then
                    G.GAME.blind.triggered = true

                    mv_joker.sell_cost = 0

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            G.GAME.blind:wiggle()
                            return true
                        end
                    }))

                    return {
                        message = "$0",
                        colour = G.C.GOLD,
                        message_card = mv_joker,
                    }
                end
            end
        end
    end,
}