SMODS.Joker {
    key = "card_bender",

    atlas = "card_bender",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 83, h = 68 },
    display_size = { w = 83, h = 68 },
    attributes = { "discard" },

    rarity = 2,
    cost = 6,

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { active = true }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.pre_discard and card.ability.extra.active then
                local dcard = G.hand.highlighted[1]

                if not SMODS.has_enhancement(dcard, "m_ace_folded") then
                    dcard:set_ability("m_ace_folded", nil, true)
                    card.ability.extra.active = false

                    return {
                        message = localize("ace_enhanced_ex"),
                        message_card = dcard
                    }
                end
            end

            if context.setting_blind then
                card.ability.extra.active = true
            end
        end
    end
}
