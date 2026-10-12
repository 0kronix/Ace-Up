SMODS.Shader {
    key = 'gilded',
    path = 'gilded.fs',
}
SMODS.Edition {
    key = 'ace_gilded',
    shader = "gilded",

    config = { dollars = 1 },

    in_shop = true,
    weight = 0.2,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.dollars } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local dollars = #ACE.count_jokers_with_rarity(card.config.center.rarity) or 0

            if dollars ~= 0 then
                return {
                    dollars = dollars * card.edition.dollars
                }
            end
        end
    end,
}