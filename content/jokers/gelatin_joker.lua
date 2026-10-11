SMODS.Joker {
    key = "gelatin_joker",

    atlas = "jokers",
    pos = { x = 5, y = 2 },

    rarity = 1,
    cost = 10,
    attributes = { "joker" },

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = {}
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round
            and context.beat_boss
            and not card.ability.extra.transformed
            and not context.repetition
            and not context.individual
            and not context.blueprint
            and G.GAME.round_resets.ante == 7 then
            local legendary = ACE.random_legendary_joker(
                card.config.center.key .. '_legendary_ante7',
                card.config.center.key
            )

            if legendary then
                card.ability.extra.transformed = true

                local old_edition = card.edition and copy_table(card.edition)
                local old_eternal = card.ability.eternal
                local old_perishable = card.ability.perishable
                local old_perish_tally = card.ability.perish_tally
                local old_rental = card.ability.rental

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        play_sound('tarot1')
                        card:start_dissolve({ G.C.PURPLE, G.C.GOLD }, nil, 1.3)
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.8,
                    func = function()
                        local new_card = SMODS.create_card({
                            set = 'Joker',
                            area = G.jokers,
                            key = legendary.key,
                            no_edition = true,
                        })

                        if old_edition then
                            new_card:set_edition(old_edition, true, true)
                        end

                        new_card.ability.eternal = old_eternal
                        new_card.ability.perishable = old_perishable
                        new_card.ability.perish_tally = old_perish_tally
                        new_card.ability.rental = old_rental

                        new_card:add_to_deck()
                        G.jokers:emplace(new_card)
                        new_card:start_materialize({ G.C.PURPLE, G.C.GOLD })
                        play_sound('timpani')

                        return true
                    end
                }))
            end
        end
    end,
}
