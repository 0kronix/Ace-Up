SMODS.Joker {
    key = "schemajoker",

    atlas = "jokers",
    pos = { x = 4, y = 1 },

    rarity = 3,
    cost = 9,
    attributes = { "mult", "suit", "full_deck" },

    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = {}
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
            local suit = context.other_card.base.suit

            if suit then
                local mult = ACE.count_suits_in_deck(suit)

                return {
                    mult = mult or 1
                }
            end
        end
    end,
}
