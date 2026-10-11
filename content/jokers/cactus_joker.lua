SMODS.Joker {
    key = "cactus_joker",

    atlas = "jokers",
    pos = { x = 8, y = 2 },
    attributes = { "tag" },

    rarity = 3,
    cost = 9,

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
        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.name == 'Big Blind' then
                local tags = G.GAME.current_round.hands_left or 0

                for i = 1, tags do
                    ACE.create_tag(nil, card.config.center.key)
                end
            end
        end
    end
}
