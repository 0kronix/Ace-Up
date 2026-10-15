SMODS.Tag {
    key = 'star',

    atlas = 'tags',
    pos = { x = 0, y = 0 },

    discovered = true,

    config = {
        levels = 2
    },

    loc_vars = function(self, info_queue)
        return {
            vars = {
                self.config.levels
            }
        }
    end,

    apply = function(self, tag, context)
        if context.hand_played then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true

            tag:yep('+', G.C.MONEY, function()
                SMODS.smart_level_up_hand(nil, context.hand, nil, self.config.levels)
                G.CONTROLLER.locks[lock] = nil
                return true
            end)

            tag.triggered = true
        end
    end
}