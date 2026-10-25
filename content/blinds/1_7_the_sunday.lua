SMODS.Blind {
    key = "the_sunday",

    atlas = 'blinds',
    pos = { x = 0, y = 6},

    dollars = 5,
    mult = 2,
    boss = { min = 3 },

    boss_colour = HEX("a78be2"),
    discovered = true,

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.before then
                if #context.full_hand <= 1 then return end

                G.GAME.blind.triggered = true
                G.E_MANAGER:add_event(Event({
                    delay = 0.4,
                    trigger = "after",
                    func = function()
                        G.GAME.blind:wiggle()
                        return true
                    end,
                }))

                local function shuffle_step(suffix, pitch)
                    G.play:shuffle("sunday" .. suffix)
                    G.play:align_cards()
                    play_sound('cardSlide1', pitch)
                    for _, c in ipairs(G.play.cards) do
                        c:juice_up(0.15, 0.1)
                    end
                end

                shuffle_step('_1', 0.85)
                delay(0.15)
                shuffle_step('_2', 1.15)
                delay(0.15)
                shuffle_step('_3', 1.0)
                delay(0.2)
            end
        end
    end
}