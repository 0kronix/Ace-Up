SMODS.Consumable {
    key = 'enchant',
    set = 'Spectral',

    atlas = "spectrals",
    pos = { x = 0, y = 0 },

    unlocked = true,
    discovered = true,

    config = { max_highlighted = 1 },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_ace_gilded
        info_queue[#info_queue + 1] = G.P_CENTERS.e_ace_lustre
        info_queue[#info_queue + 1] = G.P_CENTERS.e_ace_prismatic
        return { vars = { card.ability.max_highlighted } }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0 and
            (not G.hand.highlighted[1].edition)
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local edition = SMODS.poll_edition { key = "enchant", guaranteed = true, no_negative = true, options = { 'e_ace_gilded', 'e_ace_lustre', 'e_ace_prismatic' } }
                local enchant_card = G.hand.highlighted[1]

                enchant_card:set_edition(edition, true)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}