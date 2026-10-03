SMODS.Joker {
    key = "joke_bottom",

    atlas = "jokers",
    pos = { x = 1, y = 0 },

    rarity = 1,
    cost = 4,

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

	config = { extra = { dollars = 2 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars
            }
        }
	end,

    calculate = function(self, card, context)
        if context.after then
            if G.GAME.hands[context.scoring_name].level == 1 then
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end
}
