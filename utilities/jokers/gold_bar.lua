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

local can_sell_ref = Card.can_sell_card
function Card:can_sell_card(context)
    if ACE.can_sell_gold_card(self) then
        ACE.update_gold_sell_cost(self)
        return true
    end
    return can_sell_ref(self, context)
end

local sell_card_ref = Card.sell_card
function Card:sell_card()
    if ACE.is_gold_card(self) and self.area == G.hand then
        return ACE.sell_gold_card(self)
    end
    return sell_card_ref(self)
end

G.FUNCS.ace_can_sell_gold_card = function(e)
    local card = e.config.ref_table
    if ACE.can_sell_gold_card(card) then
        ACE.update_gold_sell_cost(card)
        e.config.colour = G.C.GREEN
        e.config.button = 'ace_sell_gold_card'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.ace_sell_gold_card = function(e)
    ACE.sell_gold_card(e.config.ref_table)
end
