SMODS.Blind {
    key = "the_saturday",

    atlas = 'blinds',
    pos = { x = 0, y = 5},

    dollars = 5,
    mult = 2,
    boss = { min = 2 },

    boss_colour = HEX("88cc8e"),
    discovered = true,

    set_blind = function(self)
        local suits = {}

        for _, card in ipairs(G.deck.cards) do
            if card.ability.played_this_ante then
                local suit = card.base.suit

                if suit and not ACE.in_table(suits, suit) then
                    table.insert(suits, suit)
                end
            end
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                ACE.ease_blind(50 * #suits, false)
                if #suits > 0 then
                    G.GAME.blind.triggered = true
                end
                G.GAME.blind:wiggle()
                return true
            end
        }))
    end,
}