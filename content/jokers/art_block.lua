SMODS.Joker {
    key = "art_block",

    atlas = "jokers",
    pos = { x = 6, y = 2 },
    attributes = { "xmult" },

    rarity = 2,
    cost = 6,

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = {}
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        if context.skipping_booster then
            local random_hand = pseudorandom_element(ACE.get_visible_hands(), card.config.center.key)
            SMODS.smart_level_up_hand(card, random_hand, nil, 1)
        end
    end
}
