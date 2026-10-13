SMODS.Joker {
    key = "no_ink",

    atlas = "jokers",
    pos = { x = 2, y = 2 },
    attributes = { "tarot", "generation", "suit" },

    rarity = 1,
    cost = 4,

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { active = true }
    },

    loc_vars = function(self, info_queue, card)
        main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", minh = 0.4 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { ref_table = card, align = "m", colour = card.ability.extra.active and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                        nodes = {
                            { n = G.UIT.T, config = { text = ' ' .. (card.ability.extra.active and 'active' or 'inactive') .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                        }
                    }
                }
            }
        }
        if card.area and card.area == G.jokers then
            return { main_end = main_end }
        end
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and card.ability.extra.active then
            local suit_change = {"c_sun", "c_star", "c_moon", "c_world"}

            if ACE.in_table(suit_change, context.consumeable.config.center.key) then
                if G.consumeables.config.card_limit - #G.consumeables.cards then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            local new_card = pseudorandom_element(suit_change, "no_ink" .. G.GAME.round_resets.ante)
                            SMODS.add_card{ key = new_card }
                            return true
                        end
                    }))

                    card.ability.extra.active = false

                    return {
                        message = localize('k_plus_tarot'),
                        colour = G.C.SECONDARY_SET.Tarot
                    }
                end
            end
        end

        if context.setting_blind then
            card.ability.extra.active = true
        end
    end,
}
