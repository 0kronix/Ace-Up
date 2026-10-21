SMODS.Seal {
    key = "silver",
    badge_colour = G.C.ACE_SILVER,
    atlas = "seals",
    pos = { x = 0, y = 0 },

    config = {
        extra = {}
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        if context.remove_playing_cards then
            for _, pcard in ipairs(context.removed) do
                if pcard == card and #G.consumeables.cards < G.consumeables.config.card_limit then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = function()
                            SMODS.add_card({ key = ACE.get_random_card_in_pool("weapon", "silver_seal") })
                        return true
                        end
                    }))

                    return {
                        message = localize('k_ace_plus_weapon'),
                        colour = HEX("a36868")
                    }
                end
            end
        end
    end,

    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end,
}