SMODS.Joker {
    key = "steam_joker",

    atlas = "jokers",
    pos = { x = 4, y = 2 },

    rarity = 1,
    cost = 4,
    attributes = { "reroll" },

    blueprint_compat = false,
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
        if context.discard and not context.blueprint then
            local card_played = G.hand.highlighted[1]
            if #G.hand.highlighted == 1 and card_played and card.ability.extra.active then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        card_played.ability.played_this_ante = true
                        G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
                        draw_card(G.discard, G.play, 100/#G.hand.highlighted, 'up', nil, card_played)
                        card:juice_up(0.3, 0.5)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                G.STATE = G.STATES.HAND_PLAYED
                                G.STATE_COMPLETE = true
                                G.FUNCS.evaluate_play()
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    func = function()
                                        draw_card(G.play, G.discard, 100,'down', false, card_played)
                                        G.STATE_COMPLETE = false
                                        return true
                                    end
                                }))
                                return true
                            end
                        }))
                        return true
                    end
                }))

                card.ability.extra.active = false
            end
        end

        if context.setting_blind then
            card.ability.extra.active = true
        end
    end
}
