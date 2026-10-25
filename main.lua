ACE = SMODS.current_mod

ACE.optional_features = {
    retrigger_joker = true,
    post_trigger = true,
}

function ACE.recursive_load(path)
    local files = NFS.getDirectoryItems(ACE.path .. path)
    table.sort(files)

    for _, item in ipairs(files) do
        if string.sub(item, -4) == ".lua" then
            local f, err = SMODS.load_file(path .. "/" .. item)

            if err then
                error(err)
            elseif f then
                f()
            end
        elseif path:find("%.") == nil then
            ACE.recursive_load(path .. "/" .. item)
        end
    end
end

ACE.recursive_load("utilities")
ACE.recursive_load("content")



-- G.GAME variables
local init_game_object_ref = Game.init_game_object
function Game:init_game_object(...)
    local ret = init_game_object_ref(self, ...)
    ret.ace = {
        rune_edition_rate = 1,
        suits_played = 0,
        weapons_used = 0,
    }

    return ret
end



function ACE.reset_game_globals(run_start)
    reset_ace_golden_coin()
end

function ACE.calculate(self, context)
    if context.after then
        if G.GAME.blind.config.blind.key == "bl_ace_golden_coin" then
            reset_ace_golden_coin()

            if G.GAME.blind.set_text then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        G.GAME.blind:set_text()
                        return true
                    end
                }))
            end
        end
    end
end
