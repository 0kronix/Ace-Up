SMODS.Blind {
    key = "the_monday",

    atlas = 'blinds',
    pos = { x = 0, y = 0},

    dollars = 7,
    mult = 2,
    boss = { min = 3 },

    boss_colour = HEX("ddebe5"),
    discovered = true,

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.before then
                blind.triggered = true
                G.E_MANAGER:add_event(Event({
                    delay = 0.4,
                    trigger = "after",
                    func = function()
                        G.GAME.blind:wiggle()
                        return true
                    end,
                }))
                ease_dollars(-G.GAME.hands[context.scoring_name].level)
            end
        end
    end,
}