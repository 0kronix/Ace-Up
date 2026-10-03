SMODS.Joker {
    key = "haunted_joker",

    atlas = "jokers",
    pos = { x = 9, y = 0 },

    rarity = 2,
    cost = 4,

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { percent = 10 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            card.ability.extra.percent
        }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Tarot" then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    ACE.ease_blind(-card.ability.extra.percent)
                    return true
                end
            }))

            return {
                message = "-" .. tostring(card.ability.extra.percent) .. "%"
            }
        end
    end,
}
