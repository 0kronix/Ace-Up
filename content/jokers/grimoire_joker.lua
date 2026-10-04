SMODS.Joker {
    key = "grimoire_joker",

    atlas = "jokers",
    pos = { x = 4, y = 0 },

    rarity = 2,
    cost = 6,
    attributes = { "hand_type", "suit", "generation", "spectral" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { hand_type = "Two Pair" }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extra.hand_type, 'poker_hands')
            }
        }
    end,

    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.hand_type then
            if ACE.is_only_different_suits(context.scoring_hand) and G.consumeables.config.card_limit - #G.consumeables.cards then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        local new_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'grimoire')
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)
                        return true
                    end
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral
                }
            end
        end
    end,
}
