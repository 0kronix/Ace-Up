SMODS.Joker {
    key = "brain_invaders",

    atlas = "jokers",
    pos = { x = 0, y = 0 },

    rarity = 1,
    cost = 5,
    attributes = { "mult", "planet" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { mult = 0, mult_gain = 3, last_planet = nil }
    },

    loc_vars = function(self, info_queue, card)
        local last_planet = card.ability.extra.last_planet
        local display_name, colour

        if last_planet then
            display_name = localize {
                type = 'name_text',
                key = last_planet.key,
                set = last_planet.set
            }
            colour = G.C.GREEN
            info_queue[#info_queue + 1] = last_planet
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
                card.ability.extra.mult_gain
            },
            main_end = main_end
        }
    end,

    calculate = function(self, card, context)
    	if context.using_consumeable and context.consumeable.ability.set == "Planet" and not context.blueprint then
            if context.consumeable.config.center == card.ability.extra.last_planet then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_table = card.ability.extra,
                    scalar_value = "mult_gain",
                    operation = '+',
                    message_colour = G.C.MULT
                })
            else
                card.ability.extra.last_planet = context.consumeable.config.center

                return {
                    message = localize("k_reset"),
                    colour = G.C.RED
                }
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
	end
}
