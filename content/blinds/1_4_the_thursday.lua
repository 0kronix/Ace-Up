local function get_example_cards(hand_key)
    local hand_data = G.GAME.hands[hand_key]
    local cards = {}

    if not hand_data or not hand_data.example then return {} end

    for _, card_info in ipairs(hand_data.example) do
        local suit_char = card_info[1]:sub(1, 1)
        local rank_char = card_info[1]:sub(3)

        local suit_map = { S = 1, H = 2, C = 3, D = 4 }
        local rank_map = { T = 10, J = 11, Q = 12, K = 13, A = 14 }

        local suit_id = suit_map[suit_char] or 1
        local rank_id = tonumber(rank_char) or rank_map[rank_char] or 2

        local fake_card = {
            base = { 
                id = rank_id, 
                suit = suit_id,
                nominal = rank_id > 10 and 10 or rank_id,
                value = tostring(rank_id) 
            },
            ability = { name = "Base", set = "Default" },
            playing_card = 1,
            debuff = false,

            config = {
                center = G.P_CENTERS.c_base,
                card = G.P_CARDS[suit_char .. "_" .. rank_char] or G.P_CARDS["S_A"]
            },
            children = {},
        }

        fake_card.get_nominal = function(self)
            return self.base.nominal
        end
        fake_card.get_id = function(self)
            return self.base.id
        end
        fake_card.is_suit = function(self, suit, ...)
            return self.base.suit == suit
        end

        table.insert(cards, fake_card)
    end

    return cards
end

SMODS.Blind {
    key = "the_thursday",

    atlas = 'blinds',
    pos = { x = 0, y = 3},

    dollars = 5,
    mult = 2,
    boss = { min = 3 },

    boss_colour = HEX("56a786"),
    discovered = true,

    loc_vars = function(self)
        return { vars = { localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') } }
    end,
    collection_loc_vars = function(self)
        return { vars = { localize('ph_most_played') } }
    end,

    debuff_hand = function(self, cards, hand, handname, check)
        local target_hand = get_example_cards(G.GAME.current_round.most_played_poker_hand)

        if not target_hand then return false end

        local hand_text, disp_text, hand_poker_hands = G.FUNCS.get_poker_hand_info(target_hand)

        if hand_poker_hands and hand_poker_hands[handname] and next(hand_poker_hands[handname]) then
            return false
        end

        G.GAME.blind.triggered = true
        return true
    end,
}