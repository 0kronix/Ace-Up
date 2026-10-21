SMODS.Consumable {
    key = 'wizard',
    set = 'Tarot',

    atlas = 'tarots',
    pos = { x = 0, y = 0 },

    unlocked = true,
    discovered = true,

    config = { extra = { odds = 7 } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_ace_gilded
        info_queue[#info_queue + 1] = G.P_CENTERS.e_ace_lustre
        info_queue[#info_queue + 1] = G.P_CENTERS.e_ace_prismatic
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'wizard')
        return { vars = { num, den } }
    end,

    can_use = function(self, card)
        return next(SMODS.Edition:get_edition_cards(G.jokers, true))
    end,

    use = function(self, card, area, copier)
        if SMODS.pseudorandom_probability(card, 'wizard', 1, card.ability.extra.odds) then
            local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
            local eligible_card = pseudorandom_element(editionless_jokers, 'wizard')
            local edition = SMODS.poll_edition { key = "wizard", guaranteed = true, no_negative = true, options = { 'e_ace_gilded', 'e_ace_lustre', 'e_ace_prismatic' } }

            eligible_card:set_edition(edition, true)
            check_for_unlock({ type = 'have_edition' })
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end
}