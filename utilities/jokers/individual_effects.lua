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

local abn_balance_mixed = false
local abn_original_smods_calculate_effect = SMODS.calculate_individual_effect
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
                ease_colour(G.C.UI_CHIPS, mix_colours(G.C.ABN_PLASMA, G.C.UI_CHIPS, amount))
                ease_colour(G.C.UI_MULT, mix_colours(G.C.ABN_PLASMA, G.C.UI_MULT, amount))

                if not abn_balance_mixed then
                    abn_balance_mixed = true

                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        blockable = false,
                        blocking = false,
                        delay = 6.3,
                        func = (function()
                            if G.STATE ~= 2 then
                                ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                                ease_colour(G.C.UI_MULT, G.C.RED, 2)
                                abn_balance_mixed = false
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
                    colour = G.C.ABN_PLASMA,
                    sound = "gong",
                    edition = true
                })
            else
                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, "extra", nil, percent, nil, {
                    message = text,
                    colour = G.C.ABN_PLASMA,
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
        amount = amount / 100

        if effect.card and effect.card ~= scored_card then
            juice_card(effect.card)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = percent or 0.5,
            func = function()
                G.GAME.blind.chips = G.GAME.blind.chips + math.ceil(G.GAME.blind.chips * amount)
                return true
            end
        }))

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
    end

    return abn_original_smods_calculate_effect(effect, scored_card, key, amount, from_edition)
end
