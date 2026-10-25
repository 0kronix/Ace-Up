SMODS.Blind {
    key = "golden_coin",

    atlas = 'blinds_final',
    pos = { x = 0, y = 1},

    dollars = 8,
    mult = 2,
	boss = {
		min = 1,
		showdown = true,
	},

    attributes = { "rank", "suit" },
    boss_colour = HEX("b0c2d9"),
    discovered = true,

    loc_vars = function(self)
        return {
            vars = {
                localize(G.GAME.current_round.ace_golden_coin.rank, "ranks"),
                localize(G.GAME.current_round.ace_golden_coin.suit, "suits_singular"),
            }
        }
    end,
    collection_loc_vars = function(self)
        return {
            vars = {
                localize('ph_ace_rank'),
                localize('ph_ace_suit')
            }
        }
    end,

	debuff_hand = function(self, cards, hand, handname, check)
        local ret1, ret2 = true, true

		for _, card in ipairs(cards) do
            if card:is_suit(G.GAME.current_round.ace_golden_coin.suit) then
                ret1 = false
            end
            if card:get_id() == G.GAME.current_round.ace_golden_coin.id then
                ret2 = false
            end
        end

        return ret1 or ret2
	end,
}

function reset_ace_golden_coin()
    G.GAME.current_round.ace_golden_coin = { rank = 'Ace', suit = 'Spades' }
    local valid_cards = {}

    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
            table.insert(valid_cards, playing_card)
        end
    end

    local golden_card_rank = pseudorandom_element(valid_cards, 'golden_coin1' .. G.GAME.current_round.hands_played)
    local golden_card_suit = pseudorandom_element(valid_cards, 'golden_coin2' .. G.GAME.current_round.hands_played)

    if golden_card_rank then
        G.GAME.current_round.ace_golden_coin.rank = golden_card_rank.base.value
        G.GAME.current_round.ace_golden_coin.id = golden_card_rank.base.id
    end
    if golden_card_suit then
        G.GAME.current_round.ace_golden_coin.suit = golden_card_suit.base.suit
    end
end
