SMODS.Joker {
    key = "match_three",

    atlas = "jokers",
    pos = { x = 3, y = 2 },
    attributes = { "hand_type" },

    rarity = 3,
    cost = 7,

    blueprint_compat = false,
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
        if context.after and not context.blueprint then
            if ACE.in_table(ACE.get_of_a_kind_hands(), context.scoring_name) then
                SMODS.destroy_cards(context.scoring_hand)
                card:juice_up(0.3, 0.5)
            end
        end
    end,
}
