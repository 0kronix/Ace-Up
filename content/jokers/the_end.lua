SMODS.Joker {
    key = "the_end",

    atlas = "jokers",
    pos = { x = 2, y = 0 },

    rarity = 3,
    cost = 8,

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
        if not context.blueprint then
            if context.skip_blind and card.ability.extra.active then
                card.ability.extra.active = false

                return {
                    message = localize("ace_failed_ex"),
                    colour = G.C.RED,
                    card = card
                }
            end

            if context.setting_blind and context.blind.boss and card.ability.extra.active then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.blind:disable()
                                play_sound('timpani')
                                delay(0.4)
                                return true
                            end
                        }))
                        SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                        return true
                    end
                }))
            end

            if context.end_of_round and G.GAME.blind.boss and not card.ability.extra.active then
                card.ability.extra.active = true

                return {
                    message = localize("k_active_ex"),
                    colour = G.C.GREEN,
                    card = card
                }
            end
        end
    end
}
