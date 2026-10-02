ACE = SMODS.current_mod

ACE.optional_features = {
  retrigger_joker = true,
  post_trigger = true,
}


-- G.GAME variables
local init_game_object_ref = Game.init_game_object
function Game:init_game_object(...)
  local ret = init_game_object_ref(self, ...)
  ret.ace = {}
  return ret
end



-- Utilities
local subdir = "utilities"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
  assert(SMODS.load_file(subdir .. "/" .. filename))()
end

-- Jokers
local subdir = "content/jokers"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
  assert(SMODS.load_file(subdir .. "/" .. filename))()
end

-- Tags
local subdir = "content/tags"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
  assert(SMODS.load_file(subdir .. "/" .. filename))()
end

-- Decks
local subdir = "content/decks"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
  assert(SMODS.load_file(subdir .. "/" .. filename))()
end
