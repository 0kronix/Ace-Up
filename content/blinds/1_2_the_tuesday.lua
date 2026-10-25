SMODS.Blind {
      key = "the_tuesday",

      atlas = 'blinds',
      pos = { x = 0, y = 1},

      dollars = 5,
      mult = 2,
      boss = { min = 2 },

      boss_colour = HEX("bb887a"),
      discovered = true,

      set_blind = function(self)
            for k, c in pairs(G.consumeables.cards) do
                  SMODS.debuff_card(c, true, "the_tuesday")
                  c:juice_up(0.3, 0.3)
            end
      end,

      defeat = function(self)
            for k, c in pairs(G.consumeables.cards) do
                  SMODS.debuff_card(c, false, "the_tuesday")
                  c:juice_up(0.3, 0.3)
            end
      end,
}