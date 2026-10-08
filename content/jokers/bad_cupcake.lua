SMODS.Joker {
    key = "bad_cupcake",

    atlas = "jokers",
    pos = { x = 3, y = 0 },

    rarity = 2,
    cost = 7,
    attributes = { "chance", "seals" },

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { odds = 12, fails = 25, seals = 5 }
    },

    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)

        return {
            vars = {
                num, den,
                card.ability.extra.fails,
                card.ability.extra.seals
            }
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.individual and context.cardarea == G.play then
                if SMODS.pseudorandom_probability(card, 'cupcake', 1, card.ability.extra.odds) then
                    card.ability.extra.seals = card.ability.extra.seals - 1
                    local target_card = context.other_card

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            local random_seal_key = SMODS.poll_seal({
                                guaranteed = true,
                                key_append = card.config.center.key,
                            })
                            if random_seal_key then
                                target_card:set_seal(random_seal_key, true, true)
                            end
                            target_card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                else
                    card.ability.extra.fails = card.ability.extra.fails - 1
                end

                if card.ability.extra.seals <= 0 or card.ability.extra.fails <= 0 then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return {
                        message = localize('k_eaten_ex'),
                        card = card,
                        message_card = card
                    }
                end
            end
        end
    end
}
