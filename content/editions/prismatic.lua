SMODS.Shader {
    key = 'prismatic',
    path = 'prismatic.fs',
}
SMODS.Edition {
    key = 'ace_prismatic',
    shader = "prismatic",

    config = { odds = 3, repetitions = 1 },

    in_shop = true,
    weight = 0.5,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.edition.odds)
        return { vars = { num, den, card.edition.repetitions } }
    end,

    calculate = function(self, card, context)
        if ((context.repetition and context.cardarea == G.play) or context.retrigger_joker_check) and context.other_card == card then
            if SMODS.pseudorandom_probability(card, "prismatic" .. (G.GAME.round_resets.ante or 1), 1, card.edition.odds) then
                return {
                    repetitions = card.edition.repetitions
                }
            end
        end
    end,

	get_weight = function(self)
		return G.GAME.ace_rune_edition_rate * self.weight
	end
}