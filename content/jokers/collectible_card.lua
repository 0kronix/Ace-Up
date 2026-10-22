SMODS.Joker {
    key = "collectible_card",

    atlas = "jokers",
    pos = { x = 3, y = 3 },

    rarity = 3,
    cost = 8,
    attributes = { "xmult", "generation", "weapon" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { xmult = 1, xmult_gain = 0.35 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult,
            }
        }
    end,

    update = function(self, card, dt)
        card.ability.extra.xmult = 1 + (G.GAME.ace.weapon_used or 0) * card.ability.extra.xmult_gain
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
	end
}
