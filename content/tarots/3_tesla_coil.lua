SMODS.Consumable {
    key = 'tesla_coil',
    set = 'Tarot',

    atlas = 'tarots',
    pos = { x = 2, y = 0 },

    unlocked = true,
    discovered = true,

    config = { max_highlighted = 1, mod_conv = "m_ace_battery" },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}