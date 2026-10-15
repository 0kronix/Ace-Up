SMODS.Joker {
    key = "pufferfish",

    atlas = "jokers",
    pos = { x = 5, y = 3 },

    rarity = 2,
    cost = 8,
    attributes = { "chance", "reroll" },

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { odds = 6 }
    },

    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
        return {
            vars = {
                num, den
            }
        }
    end,

    calculate = function(self, card, context)
        if context.reroll_shop and not context.blueprint then
            if SMODS.pseudorandom_probability(card, card.config.center.key, 1, card.ability.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    trigger = "before",
                    func = function()
                        card:juice_up(0.3, 0.3)
                        local voucher = SMODS.add_voucher_to_shop()
                        voucher.from_tag = true
                        return true
                    end
                }))
                return {
                    message = localize("ace_plus_voucher"),
                }
            end
        end
	end
}
