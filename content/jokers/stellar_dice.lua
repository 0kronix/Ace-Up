SMODS.Joker {
    key = "stellar_dice",

    atlas = "jokers",
    pos = { x = 5, y = 1 },

    rarity = 3,
    cost = 9,
    attributes = { "chance", "planet" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { odds = 8, level = 1 }
    },

    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)

        return {
            vars = {
                num, den,
                card.ability.extra.level
            }
        }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Planet" then
            if SMODS.pseudorandom_probability(card, 'stellar_dice', 1, card.ability.extra.odds) then
                ACE.upgrade_all_hands(card, card.ability.extra.level)
            end
        end
    end
}
