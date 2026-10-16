SMODS.Shader {
    key = 'gilded',
    path = 'gilded.fs',
}
SMODS.Edition {
    key = 'ace_gilded',
    shader = "gilded",

    config = { dollars_min = 1, dollars_max = 3 },

    in_shop = true,
    weight = 0.3,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.dollars_min, card.edition.dollars_max } }
    end,

    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                dollars = pseudorandom('gilded' .. (G.GAME.round_resets.ante or 1), -card.edition.dollars_min, card.edition.dollars_max)
            }
        end
    end,

	get_weight = function(self)
		return G.GAME.ace.rune_edition_rate * self.weight
	end
}