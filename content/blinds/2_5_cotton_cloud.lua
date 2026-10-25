SMODS.Blind {
    key = "cotton_cloud",

    atlas = 'blinds_final',
    pos = { x = 0, y = 4},

    dollars = 8,
    mult = 2,
	boss = {
		min = 1,
		showdown = true,
	},

    attributes = { "hand_size", "discard" },
    boss_colour = HEX("f0f0f0"),
    discovered = true,

	calculate = function(self, blind, context)
        if not blind.disabled then
            if context.pre_discard or context.before then
                G.hand:change_size(-1)
                G.GAME.round_resets.temp_cotton_cloud_handsize = (G.GAME.round_resets.temp_cotton_cloud_handsize or 0) + 1
                G.GAME.blind.triggered = true
                G.GAME.blind:wiggle()
            end
        end
	end,

	disable = function(self)
		if G.GAME.blind.triggered and G.GAME.round_resets.temp_cotton_cloud_handsize then
			G.hand:change_size(G.GAME.round_resets.temp_cotton_cloud_handsize)
            G.GAME.temp_cotton_cloud_handsize = 0
		end
	end,

    defeat = function(self)
        if G.GAME.round_resets.temp_cotton_cloud_handsize then
            G.hand:change_size(G.GAME.temp_cotton_cloud_handsize)
            G.GAME.temp_cotton_cloud_handsize = 0
        end
    end,
}
