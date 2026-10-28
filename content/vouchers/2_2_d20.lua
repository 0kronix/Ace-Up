SMODS.Voucher {
    key = 'd20',

    atlas = "vouchers",
    pos = { x = 3, y = 0 },

    config = { extra = { rerolls = 2, reroll_cost = 2 } },

    unlocked = true,
    discovered = true,

    attributes = { "reroll", "shop" },
    requires = { "v_ace_d4" },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rerolls, card.ability.extra.reroll_cost } }
    end,

    redeem = function(self, card)
        G.GAME.round_resets.free_rerolls = G.GAME.round_resets.free_rerolls + card.ability.extra.rerolls
        G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - card.ability.extra.reroll_cost
    end
}
