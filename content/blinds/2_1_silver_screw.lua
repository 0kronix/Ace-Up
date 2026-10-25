SMODS.Blind {
    key = "silver_screw",

    atlas = 'blinds_final',
    pos = { x = 0, y = 0},

    dollars = 8,
    mult = 2,
	boss = {
		min = 1,
		showdown = true,
	},

    boss_colour = HEX("b0c2d9"),
    discovered = true,

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.ace and context.ace.before_round_end_check then
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.4,
                    func = function()
                        G.GAME.chips = math.ceil(G.GAME.chips / #context.full_hand)
                        G.GAME.blind.triggered = true
                        G.GAME.blind:wiggle()
                        return true
                    end,
                }))
            end
        end
    end,
}
