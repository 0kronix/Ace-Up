SMODS.Joker {
    key = "target_joker",

    atlas = "jokers",
    pos = { x = 6, y = 0 },

    rarity = 1,
    cost = 4,
    attributes = { "mult" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { mult = 0, mult_gain = 7, target = nil }
    },

    loc_vars = function(self, info_queue, card)
        local target = card.ability.extra.target
        local display_name
        local colour

        if target then
            display_name = localize {
                type = 'name_text',
                key = target.key,
                set = target.set
            }
            colour = G.C.GREEN
            info_queue[#info_queue + 1] = target
        else
            display_name = localize('k_none')
            colour = G.C.RED
        end

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = ' ' .. display_name .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                        }
                    }
                }
            }
        }

        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.mult_gain,
            },
            main_end = main_end
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.starting_shop then
                local item = pseudorandom_element(G.shop_jokers.cards, "target")
                card.ability.extra.target = item and item.config.center or nil
            end

            if context.buying_card and card.ability.extra.target == context.card.config.center then
                card.ability.extra.target = nil

                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_table = card.ability.extra,
                    scalar_value = "mult_gain",
                    operation = '+',
                    message_colour = G.C.MULT
                })
            end

            if context.ending_shop then
                card.ability.extra.target = nil
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}
