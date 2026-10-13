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
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            local dollars = #ACE.get_jokers_with_rarity(card.config.center.rarity) or 0

            if dollars ~= 0 then
                return {
                    dollars = dollars * card.edition.dollars
                }
            end
        end
    end,
}