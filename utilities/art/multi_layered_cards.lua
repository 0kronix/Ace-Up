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
