ACE = SMODS.current_mod

ACE.optional_features = {
    retrigger_joker = true,
    post_trigger = true,
}

-- G.GAME variables
local init_game_object_ref = Game.init_game_object
function Game:init_game_object(...)
    local ret = init_game_object_ref(self, ...)
    ret.ace = {
        rune_edition_rate = 1
    }

    return ret
end

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
