SMODS.Shader {
    key = 'lustre',
    path = 'lustre.fs',
}
SMODS.Edition {
    key = 'ace_lustre',
    shader = "lustre",

    config = { percent = 5 },

    in_shop = true,
    weight = 0.2,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.percent } }
    end,

    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                ace_blind_size = -card.edition.percent
            }
        end
    end,

	get_weight = function(self)
		return G.GAME.ace.rune_edition_rate * self.weight
	end
}