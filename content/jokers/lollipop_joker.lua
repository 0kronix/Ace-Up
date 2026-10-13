SMODS.Joker {
    key = "lollipop_joker",

    atlas = "jokers",
    pos = { x = 9, y = 2 },
    attributes = { "xmult", "food" },

    rarity = 2,
    cost = 7,

    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { xmult = 3, rounds = 3, rounds_gain = 1 }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.rounds,
                card.ability.extra.rounds_gain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if not context.blueprint and context.end_of_round and context.main_eval then
            if G.GAME.current_round.hands_played == 1 then
                card.ability.extra.rounds = card.ability.extra.rounds + card.ability.extra.rounds_gain
                return {
                    message = localize( {
                        type = "variable",
                        key = "k_ace_plus_round",
                        vars = { card.ability.extra.rounds_gain }
                    } )
                }
            else
                card.ability.extra.rounds = card.ability.extra.rounds - card.ability.extra.rounds_gain

                if card.ability.extra.rounds <= 0 then
                    ACE.consume(card)
                end

                return {
                    message = localize( {
                        type = "variable",
                        key = "k_ace_minus_round",
                        vars = { card.ability.extra.rounds_gain }
                    } )
                }
            end
        end
    end
}
