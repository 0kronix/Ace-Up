SMODS.Blind {
    key = "mossy_ball",

    atlas = 'blinds_final',
    pos = { x = 0, y = 2},

    dollars = 8,
    mult = 2,
	boss = {
		min = 1,
		showdown = true,
	},

    attributes = { "debuff" },
    boss_colour = HEX("88cc8e"),
    discovered = true,

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.after then
                local undebuffed_cards = {}
                local cards_to_debuff = {}

                for _, card in ipairs(G.playing_cards) do
                    if not card.debuff then
                        table.insert(undebuffed_cards, card)
                    end
                end

                for i = 1, math.floor(#undebuffed_cards / 3) do
                    local dcard = pseudorandom_element(undebuffed_cards, 'mossy_ball' .. i)

                    table.insert(cards_to_debuff, dcard)
                    table.remove(undebuffed_cards, ACE.get_pos(dcard, undebuffed_cards))
                end

                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.2,
                    func = function()
                        for _, c in pairs(cards_to_debuff) do
                            SMODS.debuff_card(c, true, "mossy_ball")
                        end
                        G.GAME.blind.triggered = true
                        G.GAME.blind:wiggle()
                        return true
                    end,
                }))
            end
        end
    end,

    defeat = function(self)
        for _, c in pairs(G.playing_cards) do
            SMODS.debuff_card(c, false, "mossy_ball")
        end
    end,

	disable = function(self)
        if G.GAME.blind.triggered then
            for _, c in pairs(G.playing_cards) do
                SMODS.debuff_card(c, false, "mossy_ball")
            end
        end
	end,
}
