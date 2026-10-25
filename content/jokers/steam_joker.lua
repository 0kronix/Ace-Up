SMODS.Joker {
    key = "steam_joker",

    atlas = "jokers",
    pos = { x = 4, y = 2 },

    rarity = 1,
    cost = 5,
    attributes = { "discard" },

    blueprint_compat = false,
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
        if context.discard and not context.blueprint then
            local card_played = G.hand.highlighted[1]
            if #G.hand.highlighted == 1 and card_played then
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
            end
        end
    end
}
