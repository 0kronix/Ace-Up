SMODS.Back {
    key = "hotwave",

    atlas = "backs",
    pos = { x = 1, y = 0},

    config = {
        dollars_gain = 2
    },

    loc_vars = function(self, info_queue, back)
        return {
            vars = {
                self.config.dollars_gain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.after and SMODS.last_hand_oneshot then
            return {
                dollars = self.config.dollars_gain
            }
        end
    end
}
