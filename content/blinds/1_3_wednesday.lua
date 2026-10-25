SMODS.Blind {
    key = "the_wednesday",

    atlas = 'blinds',
    pos = { x = 0, y = 2},

    dollars = 5,
    mult = 2,
    boss = { min = 3 },

    boss_colour = HEX("c88b38"),
    discovered = true,

	debuff_hand = function(self, cards, hand, handname, check)
		local sum = 0

		if cards then
			for k, c in ipairs(cards) do
				sum = sum + c:get_id()
			end
		end

		if sum and sum > 40 then
			G.GAME.blind.triggered = true
			return true
		else
			return false
		end
	end,
}