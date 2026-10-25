SMODS.Blind {
    key = "caramel_candy",

    atlas = 'blinds_final',
    pos = { x = 0, y = 3},

    dollars = 8,
    mult = 2,
	boss = {
		min = 1,
		showdown = true,
	},

    attributes = { "debuff" },
    boss_colour = HEX("fd5f55"),
    discovered = true,

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.after then
                local hand = G.GAME.current_round.hands_played + 1
                local cards_to_debuff = {}

                for _, c in pairs(G.playing_cards) do
                    SMODS.debuff_card(c, false, "caramel_candy")
                end

                if hand % 2 == 1 then
                    for _, c in pairs(G.playing_cards) do
                        if c:get_id() % 2 == 0 then
                            table.insert(cards_to_debuff, c)
                        end
                    end
                else
                    for _, c in pairs(G.playing_cards) do
                        if c:get_id() % 2 == 1 then
                            table.insert(cards_to_debuff, c)
                        end
                    end
                end

                for _, c in pairs(cards_to_debuff) do
                    SMODS.debuff_card(c, true, "caramel_candy")
                end

                if #cards_to_debuff > 0 then
                    G.GAME.blind.triggered = true
                end

                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.4,
                    func = function()
                        G.GAME.blind:wiggle()
                        return true
                    end,
                }))
            end
        end
    end,

    defeat = function(self)
        for _, c in pairs(G.playing_cards) do
            SMODS.debuff_card(c, false, "caramel_candy")
        end
    end,

	disable = function(self)
        for _, c in pairs(G.playing_cards) do
            SMODS.debuff_card(c, false, "caramel_candy")
        end
	end,
}
