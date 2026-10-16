SMODS.Voucher {
    key = 'glyph',

    atlas = "vouchers",
    pos = { x = 1, y = 0 },

    config = { extra = { rate = 4 } },

    unlocked = true,
    discovered = true,

    attributes = { "editions" },
    requires = { "v_ace_rune" },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rate } }
    end,

    redeem = function(self, card)
        G.GAME.ace.rune_edition_rate = card.ability.extra.rate
    end
}
