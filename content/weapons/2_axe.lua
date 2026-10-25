SMODS.Consumable {
    key = "axe",
    set = 'weapon',

    atlas = "weapons",
    pos = { x = 3, y = 0,
        layers = {
            { x = 4, y = 0, },
            { x = 5, y = 0, },
        }
    },

    unlocked = true,
    discovered = true,

    config = {
        extra = { count = 10, rank = "3", chips = 75 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.count,
                localize(card.ability.extra.rank, 'ranks'),
                card.ability.extra.chips,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local value = context.other_card.base.value

            if value == card.ability.extra.rank then
                if card.ability.extra.count ~= 0 then
                    card.ability.extra.count = card.ability.extra.count - 1

                    return {
                        chips = card.ability.extra.chips
                    }
                end
            end
        end

        if context.after and context.main_eval and not context.blueprint and card.ability.extra.count <= 0 then
            set_consumeable_usage(card)
            SMODS.calculate_effect({ message = localize('k_extinct_ex'), colour = G.C.MULT, sound = 'tarot1', }, card)
            SMODS.destroy_cards(card)
            SMODS.calculate_context({ ace_using_weapon = true })
            G.GAME.ace.weapons_used = (G.GAME.ace.weapons_used or 0) + 1
        end
    end,
}
