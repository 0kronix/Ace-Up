SMODS.Back {
    key = "fashion",

    atlas = "backs",
    pos = { x = 0, y = 0},

    config = {
        joker_slot = -2,
        dollars = 6
    },

    loc_vars = function(self, info_queue, back)
        return {
            vars = {
                self.config.dollars,
                self.config.joker_slot
            }
        }
    end,

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    local card = create_card("Joker", G.jokers, true, 4, nil, nil, nil, "")
                    card:add_to_deck()
                    card:start_materialize()
                    G.jokers:emplace(card)
                    return true
                end
            end,
        }))
    end
}
