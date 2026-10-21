SMODS.Consumable {
    key = 'contract',
    set = 'Spectral',

    atlas = "spectrals",
    pos = { x = 1, y = 0 },

    unlocked = true,
    discovered = true,

    config = { cost = 15 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.cost } }
    end,

    can_use = function(self, card)
        return G.GAME.dollars >= card.ability.cost
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                ACE.create_voucher(nil, "contract", card.ability.cost)
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}