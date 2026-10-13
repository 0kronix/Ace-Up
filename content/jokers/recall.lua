SMODS.Joker {
    key = "recall",

    atlas = "jokers",
    pos = { x = 0, y = 3 },

    rarity = 1,
    cost = 4,
    attributes = {},

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

    config = {
        extra = { cards = 3 },
        removed_cards = {}
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cards
            }
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint then
            if context.remove_playing_cards then
                for _, removed in ipairs(context.removed) do
                    table.insert(card.ability.removed_cards, copy_table(removed:save()))

                    if #card.ability.removed_cards > card.ability.extra.cards then
                        table.remove(card.ability.removed_cards, 1)
                    end
                end
            end

            if context.end_of_round and #card.ability.removed_cards >= card.ability.extra.cards then
                local saved = pseudorandom_element(card.ability.removed_cards, card.config.center.key)
                local data = copy_table(saved)

                G.playing_card = (G.playing_card and G.playing_card + 1) or 1

                data.playing_card = G.playing_card
                data.added_to_deck = false
                data.highlighted = false
                data.flipping = nil

                local ccard = Card(
                    G.deck.T.x,
                    G.deck.T.y,
                    G.CARD_W,
                    G.CARD_H,
                    G.P_CARDS.empty,
                    G.P_CENTERS.c_base,
                    { playing_card = G.playing_card }
                )

                ccard:load(data)
                ACE.add_to_deck(ccard)

                card.ability.removed_cards = {}

                return {
                    message = localize('ace_return_ex'),
                    colour = G.C.BLUE
                }
            end
        end
    end,

    generate_ui = function(self, info_queue, cardd, desc_nodes, specific_vars, full_UI_table)
        SMODS.Joker.super.generate_ui(self, info_queue, cardd, desc_nodes, specific_vars, full_UI_table)
        if #cardd.ability.removed_cards > 0 and cardd and cardd.area == G.jokers then
            local cards = {}

            for i = 1, #cardd.ability.removed_cards do
                local data = copy_table(cardd.ability.removed_cards[i])

                local preview = Card(
                    0,
                    0,
                    G.CARD_W,
                    G.CARD_H,
                    G.P_CARDS.empty,
                    G.P_CENTERS.c_base
                )

                preview:load(data)
                table.insert(cards, preview)
            end

            ACE.card_area_preview(nil, desc_nodes, {
                override = true,
                cards = cards,
                w = 2.4,
                h = 0.6,
                scale = 0.6,
            })
        end
    end
}
