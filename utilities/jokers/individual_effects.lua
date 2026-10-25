table.insert(SMODS.calculation_keys, "ace_balance")
if SMODS.other_calculation_keys then
    table.insert(SMODS.other_calculation_keys, "ace_balance")
end
table.insert(SMODS.calculation_keys, "ace_blind_size")
if SMODS.other_calculation_keys then
  table.insert(SMODS.other_calculation_keys, "ace_blind_size")
end

function calculate_balance_percent_values(input_hand_chips, input_mult, percent)
    local chip_mod = percent * input_hand_chips
    local mult_mod = percent * input_mult
    local avg = (chip_mod + mult_mod) / 2
    local new_hand_chips = input_hand_chips + (avg - chip_mod)
    local new_mult = input_mult + (avg - mult_mod)

    new_hand_chips = math.floor(new_hand_chips + 0.5)
    new_mult = math.floor(new_mult + 0.5)
    new_hand_chips = math.max(1, new_hand_chips)
    new_mult = math.max(1, new_mult)

    return new_hand_chips, new_mult
end

local ace_balance_mixed = false
local ace_original_smods_calculate_effect = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    if key == "ace_balance" then
        amount = amount / 100

        if effect.card and effect.card ~= scored_card then
            juice_card(effect.card)
        end

        local new_hand_chips, new_mult = calculate_balance_percent_values(hand_chips, mult, amount)
        SMODS.Scoring_Parameters.chips:modify(new_hand_chips - hand_chips)
        SMODS.Scoring_Parameters.mult:modify(new_mult - mult)
        local text = localize("k_balanced") .. " " .. (amount * 100) .. "%"

        G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            func = (function()
                ease_colour(G.C.UI_CHIPS, mix_colours(G.C.ACE_PLASMA, G.C.UI_CHIPS, amount))
                ease_colour(G.C.UI_MULT, mix_colours(G.C.ACE_PLASMA, G.C.UI_MULT, amount))

                if not ace_balance_mixed then
                    ace_balance_mixed = true

                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        blockable = false,
                        blocking = false,
                        delay = 6.3,
                        func = (function()
                            if G.STATE ~= 2 then
                                ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                                ease_colour(G.C.UI_MULT, G.C.RED, 2)
                                ace_balance_mixed = false
                                return true
                            end
                        end)
                    }))
                end
                return true
            end)
        }))
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, "jokers", nil, percent, nil, {
                    message = text,
                    colour = G.C.ACE_PLASMA,
                    sound = "gong",
                    edition = true
                })
            else
                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, "extra", nil, percent, nil, {
                    message = text,
                    colour = G.C.ACE_PLASMA,
                    sound = "gong"
                })
            end
        end
    end

    if key == "ace_blind_size" then
        local text = localize( {
            type = "variable",
            key = "k_ace_blind_size",
            vars = { amount }
        } )

        if effect.card and effect.card ~= scored_card then
            juice_card(effect.card)
        end

        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, "jokers", nil, percent, nil, {
                    message = text,
                    colour = G.C.GREEN
                })
            else
                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, "extra", nil, percent, nil, {
                    message = text,
                    colour = G.C.GREEN,
                })
            end
        end

        ACE.ease_blind(amount)
    end

    return ace_original_smods_calculate_effect(effect, scored_card, key, amount, from_edition)
end




ACE.ease_blind = function(percent, wiggle)
    local desired_chip_amount = G.GAME.blind.chips + math.ceil(G.GAME.blind.chips * (percent / 100))
    local chip_mod

    if type(G.GAME.blind.chips) ~= "table" then
        chip_mod = math.ceil(math.abs(desired_chip_amount - G.GAME.blind.chips) / 120)
    else
        chip_mod = ((desired_chip_amount - G.GAME.blind.chips):abs() / 120):ceil()
    end

    local step = 0
    local chips_text_integer = G.GAME.blind.chips
    G.BLIND_SIZE_DISPLAY_QUEUE = G.BLIND_SIZE_DISPLAY_QUEUE or {}

    if chips_text_integer < desired_chip_amount then
        while chips_text_integer < desired_chip_amount do
            table.insert(G.BLIND_SIZE_DISPLAY_QUEUE, chips_text_integer)
            chips_text_integer = chips_text_integer + G.SETTINGS.GAMESPEED * chip_mod
        end
    else
        while chips_text_integer > desired_chip_amount do
            table.insert(G.BLIND_SIZE_DISPLAY_QUEUE, chips_text_integer)
            chips_text_integer = chips_text_integer - G.SETTINGS.GAMESPEED * chip_mod
        end
    end

    G.E_MANAGER:add_event(Event({
        trigger = "after",
        blocking = true,
        func = function()
            if #G.BLIND_SIZE_DISPLAY_QUEUE > 0 then
                table.remove(G.BLIND_SIZE_DISPLAY_QUEUE, 1)
                if step % 5 == 0 then
                    play_sound("chips1", 0.8 + (step * 0.005))
                end
                step = step + 1
            else
                if wiggle then
                    G.GAME.blind:wiggle()
                end
                return true
            end
        end,
    }))

    G.GAME.blind.chips = desired_chip_amount
end
