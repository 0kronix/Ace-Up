SMODS.Gradient {
    key = 'onfire',
    colours = {
        HEX("FF8C00"), HEX("FF4500")
    },
    cycle = 1,
    interpolation = 'trig'
}

G.C.ACE_PLASMA = { 0.8, 0.45, 0.85, 1 }
G.C.ACE_SILVER = HEX("c3cdd4")

local ace = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        ace()
    end

    G.ARGS.LOC_COLOURS.ace_silver = G.C.ACE_SILVER

    return ace(_c, _default)
end