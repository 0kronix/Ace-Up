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

function ACE.in_table(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function ACE.is_only_different_suits(hand)
    local suits = {}

    for _, scoring_card in ipairs(hand) do
        if ACE.in_table(suits, scoring_card.base.suit) then
            return false
        else
            table.insert(suits, scoring_card.base.suit)
        end
    end

    return true
end

ACE.get_pos = function(card, area)
    for i, v in ipairs(area) do
        if v == card then
            return i
        end
    end
    return 0
end

ACE.upgrade_all_hands = function(card, level)
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})

    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+' .. tostring(level)})
    delay(1.3)

    for k, v in pairs(G.GAME.hands) do
        level_up_hand(card, k, true, level)
    end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    card:juice_up(0.3, 0.5)
end

ACE.count_suits_in_deck = function(suit)
    local count = 0

    for _, card in ipairs(G.playing_cards) do
        if card:is_suit(suit) then
            count = count + 1
        end
    end

    return count
end

--#region Multi-layered Cards
-- Stolen from TWIMG mod
local max_layers = 3

ACE.layer_name = function(type, id)
    return "ace_" .. type .. "_layer_" .. tostring(id)
end

SMODS.DrawStep({
    key = "ace_main_layers",
    order = 59,
    func = function(self)
        if (
            self.config.center.pos and
            self.config.center.pos.layers and
            (self.config.center.discovered or self.bypass_discovery_center)
        ) then
            for i = 1, self.children[ACE.layer_name("main",1)].layercount do
                local layer = self.children[ACE.layer_name("main",i)]

                local phase = layer.anim_phase or 0
                local speed = layer.anim_speed or 1.0
                local scale_amp = layer.anim_scale_amp or 0.02
                local rot_amp = layer.anim_rot_amp or 0.02

                local time = G.TIMERS.REAL * speed + phase
                local scale_mod = 0.03 + (i/100)/2 + scale_amp * math.sin(2.5 * time)
                local rotate_mod = rot_amp * math.sin(1.219 * time)

                layer:draw_shader(
                    "dissolve",
                    0,
                    nil,
                    nil,
                    self.children.center,
                    scale_mod,
                    rotate_mod,
                    nil,
                    0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),
                    nil,
                    0.6
                )
                layer:draw_shader(
                    "dissolve",
                    nil,
                    nil,
                    nil,
                    self.children.center,
                    scale_mod,
                    rotate_mod
                )
                if self.edition then for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if self.edition[v.key:sub(3)] then
                        layer:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                    end
                end end
            end
        end
    end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.DrawStep({
    key = "ace_soul_layers",
    order = 61,
    func = function(self)
        if (
            self.config.center.soul_pos and
            self.config.center.soul_pos.layers and
            (self.config.center.discovered or self.bypass_discovery_center)
        ) then
            for i = 1, self.children[ACE.layer_name("soul",1)].layercount do
                local layer = self.children[ACE.layer_name("soul",i)]

                local phase = layer.anim_phase or 0
                local speed = layer.anim_speed or 1.0
                local scale_amp = layer.anim_scale_amp or 0.02
                local rot_amp = layer.anim_rot_amp or 0.05

                local time = G.TIMERS.REAL * speed + phase
                local scale_mod = 0.07 + (i/100)/2 + scale_amp * math.sin(2.5 * time)
                local rotate_mod = rot_amp * math.sin(1.219 * time)

                layer:draw_shader(
                    "dissolve",
                    0,
                    nil,
                    nil,
                    self.children.center,
                    scale_mod,
                    rotate_mod,
                    nil,
                    0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),
                    nil,
                    0.6
                )
                layer:draw_shader(
                    "dissolve",
                    nil,
                    nil,
                    nil,
                    self.children.center,
                    scale_mod,
                    rotate_mod
                )
                if self.edition then for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if v.apply_to_float then if self.edition[v.key:sub(3)] then
                        layer:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                    end end
                end end
            end
        end
    end,
	conditions = { vortex = false, facing = "front" },
})

for i = 1,max_layers do
    SMODS.draw_ignore_keys[ACE.layer_name("main",i)] = true
    SMODS.draw_ignore_keys[ACE.layer_name("soul",i)] = true
end

local set_spr_func = Card.set_sprites
function Card:set_sprites(_center, _front)
    set_spr_func(self, _center, _front)

    if _center and _center.pos and _center.pos.layers then
        for i,coords in pairs(_center.pos.layers) do if i <= max_layers then
            self.children[ACE.layer_name("main",i)] = Sprite(
                self.T.x,
                self.T.y,
                self.T.w,
                self.T.h,
                G.ASSET_ATLAS[_center.atlas or _center.set],
                coords
            )
            self.children[ACE.layer_name("main",i)].role.draw_major = self
            self.children[ACE.layer_name("main",i)].states.hover.can = false
            self.children[ACE.layer_name("main",i)].states.click.can = false

            local sprite = self.children[ACE.layer_name("main",i)]
            sprite.anim_phase = (i - 1) * 1.5
            sprite.anim_speed = 1.0 + (i - 1) * 0.3
            sprite.anim_scale_amp = 0.02 + (i - 1) * 0.005
            sprite.anim_rot_amp = 0.02 + (i - 1) * 0.02
        end end
        self.children[ACE.layer_name("main",1)].layercount = #_center.pos.layers
    end

    if _center and _center.soul_pos and _center.soul_pos.layers then
        for i,coords in pairs(_center.soul_pos.layers) do if i <= max_layers then
            self.children[ACE.layer_name("soul",i)] = Sprite(
                self.T.x,
                self.T.y,
                self.T.w,
                self.T.h,
                G.ASSET_ATLAS[_center.atlas or _center.set],
                coords
            )
            self.children[ACE.layer_name("soul",i)].role.draw_major = self
            self.children[ACE.layer_name("soul",i)].states.hover.can = false
            self.children[ACE.layer_name("soul",i)].states.click.can = false

            local sprite = self.children[ACE.layer_name("soul",i)]
            sprite.anim_phase = (i - 1) * 1.5
            sprite.anim_speed = 1.0 + (i - 1) * 0.3
            sprite.anim_scale_amp = 0.02 + (i - 1) * 0.005
            sprite.anim_rot_amp = 0.05 + (i - 1) * 0.2
        end end
        self.children[ACE.layer_name("soul",1)].layercount = #_center.soul_pos.layers
    end
end
--#endregion
