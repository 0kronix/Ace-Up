SMODS.Consumable {
    key = "mace",
    set = 'weapon',

    atlas = "weapons",
    pos = { x = 0, y = 3,
        layers = {
            { x = 1, y = 3, },
            { x = 2, y = 3, },
        }
    },

    unlocked = true,
    discovered = true,

    config = {
        extra = { count = 10, rank = "8", percent = 15 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.count,
                localize(card.ability.extra.rank, 'ranks'),
                card.ability.extra.percent,
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
                        ace_balance = card.ability.extra.percent
                    }
                end
            end
        end

        if context.after and context.main_eval and not context.blueprint and card.ability.extra.count <= 0 then
            set_consumeable_usage(card)
            SMODS.calculate_effect({ message = localize('k_extinct_ex'), colour = G.C.MULT, sound = 'tarot1', }, card)
            SMODS.destroy_cards(card)
            SMODS.calculate_context({ ace_using_weapon = true })
            G.GAME.ace.weapon_used = (G.GAME.ace.weapon_used or 0) + 1
        end
    end,
}
