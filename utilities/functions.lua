function ACE.ease_blind(percent)
    G.GAME.blind.chips = G.GAME.blind.chips + math.ceil(G.GAME.blind.chips * (percent * 0.01))
    G.E_MANAGER:add_event(Event({
        trigger = "ease",
        delay = 0.5,
        ref_table = G.GAME.blind,
        ref_value = "chip_text",
        ease_to = G.GAME.blind.chips,
        func = (function(t)
            return math.floor(t)
        end)
    }))
end
