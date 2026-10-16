SMODS.Voucher {
    key = 'rune',

    atlas = "vouchers",
    pos = { x = 0, y = 0 },

    config = { extra = { rate = 2 } },

    unlocked = true,
    discovered = true,

    attributes = { "editions" },
    requires = {},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rate } }
    end,

    redeem = function(self, card)
        G.GAME.ace.rune_edition_rate = card.ability.extra.rate
    end
}
