SMODS.Joker {
    key = "sparky",

    atlas = "jokers",
    pos = { x = 1, y = 3 },

    rarity = 1,
    cost = 4,
    attributes = { "tag", "hands" },

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
    	if context.end_of_round and context.main_eval then
            if G.GAME.current_round.hands_left == 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        ACE.create_tag("tag_ace_star")
                        return true
                    end
                }))
            end

            return {
                message = localize("k_ace_plus_tag"),
            }
        end
    end,
}
