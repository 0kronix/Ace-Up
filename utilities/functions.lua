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



function ACE.random_legendary_joker(seed, exclude_key)
    local pool = {}

    for _, center in ipairs(G.P_JOKER_RARITY_POOLS[4] or {}) do
        local in_pool = SMODS.add_to_pool(center)

        if in_pool
            and center.key ~= exclude_key
            and not G.GAME.banned_keys[center.key] then
            pool[#pool + 1] = center
        end
    end

    return pseudorandom_element(pool, pseudoseed(seed))
end



function ACE.create_tag(tag, seed)
    local tag_pool = get_current_pool('Tag')
    local it = 1

    if tag == nil then
        tag = pseudorandom_element(tag_pool, seed)
    else
        return add_tag(Tag(tag, false, 'Small'))
    end

    while tag == 'UNAVAILABLE' do
        it = it + 1
        tag = pseudorandom_element(tag_pool, seed .. it)
    end

    return add_tag(Tag(tag, false, 'Small'))
end



function ACE.consume(card, colour)
    SMODS.destroy_cards(card, nil, nil, true)
    return {
        message = localize('k_eaten_ex'),
        card = card,
        message_card = card,
        colour = colour or G.C.FILTER,
    }
end



function ACE.get_visible_hands()
    local visible = {}

    for _, hand_key in ipairs(G.handlist) do
        if G.GAME.hands[hand_key] and G.GAME.hands[hand_key].visible then
            table.insert(visible, hand_key)
        end
    end

    return visible
end



ACE.add_to_deck = function(card)
    card:add_to_deck()
    G.deck.config.card_limit = G.deck.config.card_limit + 1
    table.insert(G.playing_cards, card)

    G.deck:emplace(card)
    card.states.visible = nil

    G.E_MANAGER:add_event(Event({
        func = function()
            card:start_materialize()
            return true
        end
    }))
end



-- Special thanks for All In Jest mod! <3
ACE.card_area_preview = function(cardArea, desc_nodes, config)
    if not config then config = {} end
    local height = config.h or 1.25
    local width = config.w or 1
    local card_limit = config.card_limit or #config.cards or 1
    local override = config.override or false
    local cards = config.cards or {}
    local padding = config.padding or 0.07
    local margin_left = config.ml or 0
    local margin_top = config.mt or 0
    local alignment = config.alignment or "cm"
    local scale = config.scale or 1
    local type = config.type or "title"
    local box_height = config.box_height or 0
    local highlight_limit = config.highlight_limit or 0
    local x_offset = config.x_offset or 0
    if override or not cardArea then
        cardArea = CardArea(
            G.ROOM.T.x + margin_left * G.ROOM.T.w - x_offset, G.ROOM.T.h + margin_top
            , G.CARD_W <= width * G.CARD_W and width * G.CARD_W or G.CARD_W, height * G.CARD_H,
            { card_limit = card_limit, type = type, highlight_limit = highlight_limit, collection = true, temporary = true }
        )
        for i, card in ipairs(cards) do
            card.T.w = card.T.w * scale
            card.T.h = card.T.h * scale
            card.VT.h = card.T.h
            card.VT.h = card.T.h
            local area = cardArea
            if (card.config.center) then
                card:set_sprites(card.config.center)
            end
            area:emplace(card)
        end
    end
    local uiEX = {
        n = G.UIT.R,
        config = { align = alignment, padding = padding, no_fill = true, minh = box_height },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = padding, r = 0.12, colour = lighten(G.C.JOKER_GREY, 0.8), emboss = 0.07 },
                nodes = {
                    { n = G.UIT.O, config = { object = cardArea } }
                }
            }
        }
    }
    if cardArea then
        if desc_nodes then
            desc_nodes[#desc_nodes + 1] = {
                uiEX
            }
        end
    end
    return uiEX
end



function ACE.is_gold_card(card)
    return card
        and card.config.center
        and card.config.center.key == 'm_gold'
end

function ACE.get_gold_bar()
    for _, joker in ipairs(SMODS.find_card('j_ace_gold_bar')) do
        if not joker.debuff and not joker.getting_sliced then
            return joker
        end
    end
end

function ACE.gold_selling_enabled()
    return ACE.get_gold_bar() ~= nil
end

function ACE.get_gold_sell_price()
    local joker = ACE.get_gold_bar()
    return joker and joker.ability.extra.dollars
end

function ACE.update_gold_sell_cost(card)
    local price = ACE.get_gold_sell_price()
    if not price then return end
    card.sell_cost = price
    card.sell_cost_label = price
end

function ACE.can_sell_gold_card(card)
    if not ACE.gold_selling_enabled() then return false end
    if not ACE.is_gold_card(card) then return false end
    if not card.area or card.area ~= G.hand then return false end
    if not card.highlighted then return false end
    if G.play and #G.play.cards > 0 then return false end
    if G.CONTROLLER.locked then return false end
    if G.GAME.STOP_USE and G.GAME.STOP_USE > 0 then return false end
    return true
end

function ACE.remove_gold_sell_button(card)
    if card.ace_gold_sell_ui and card.children.use_button then
        card.children.use_button:remove()
        card.children.use_button = nil
        card.ace_gold_sell_ui = nil
    end
end

function ACE.gold_sell_button_def(card)
    local sell = {
        n = G.UIT.C,
        config = { align = 'cl' },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    ref_table = card,
                    align = 'cl',
                    padding = 0.1,
                    r = 0.08,
                    minw = 1.25,
                    hover = true,
                    shadow = true,
                    colour = G.C.UI.BACKGROUND_INACTIVE,
                    one_press = true,
                    button = 'ace_sell_gold_card',
                    func = 'ace_can_sell_gold_card',
                },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = 'tm' },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = 'cm', maxw = 1.25 },
                                nodes = {
                                    {
                                        n = G.UIT.T,
                                        config = {
                                            text = localize('b_sell'),
                                            colour = G.C.UI.TEXT_LIGHT,
                                            scale = 0.4,
                                            shadow = true,
                                        },
                                    },
                                },
                            },
                            {
                                n = G.UIT.R,
                                config = { align = 'cm' },
                                nodes = {
                                    {
                                        n = G.UIT.T,
                                        config = {
                                            text = localize('$'),
                                            colour = G.C.WHITE,
                                            scale = 0.4,
                                            shadow = true,
                                        },
                                    },
                                    {
                                        n = G.UIT.T,
                                        config = {
                                            ref_table = card,
                                            ref_value = 'sell_cost_label',
                                            colour = G.C.WHITE,
                                            scale = 0.55,
                                            shadow = true,
                                        },
                                    },
                                },
                            },
                        },
                    },
                    { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                },
            },
        },
    }

    return {
        n = G.UIT.ROOT,
        config = { padding = 0, colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.C,
                config = { padding = 0.15, align = 'cl' },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cl' }, nodes = { sell } },
                },
            },
        },
    }
end

function ACE.attach_gold_sell_button(card)
    ACE.update_gold_sell_cost(card)
    card.ace_gold_sell_ui = true
    card.children.use_button = UIBox {
        definition = ACE.gold_sell_button_def(card),
        config = {
            align = 'cl',
            offset = { x = 0.4, y = 0 },
            parent = card,
        },
    }
end

function ACE.sell_gold_card(card)
    if not ACE.can_sell_gold_card(card) then return end

    local price = card.sell_cost or ACE.get_gold_sell_price()
    if not price then return end

    G.CONTROLLER.locks.selling_card = true
    stop_use()
    ACE.remove_gold_sell_button(card)

    if card.area then
        card.area:remove_from_highlighted(card, true)
    end

    SMODS.calculate_context({
        remove_playing_cards = true,
        removed = { card },
    })

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            play_sound('coin2')
            card:juice_up(0.3, 0.4)
            return true
        end,
    }))
    delay(0.2)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            ease_dollars(price)
            card.paperback_dissolve_sell_flag = true
            card:start_dissolve({ G.C.GOLD })
            card.paperback_dissolve_sell_flag = false
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blocking = false,
                func = function()
                    G.CONTROLLER.locks.selling_card = nil
                    return true
                end,
            }))
            return true
        end,
    }))
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
