SMODS.Voucher {
    key = 'd4',

    atlas = "vouchers",
    pos = { x = 0, y = 0 },

    config = { extra = { rerolls = 1 } },

    unlocked = true,
    discovered = true,

    attributes = { "reroll", "shop" },
    requires = {},

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rerolls } }
    end,

    redeem = function(self, card)
        G.GAME.round_resets.free_rerolls = G.GAME.round_resets.free_rerolls + card.ability.extra.rerolls
    end
}
