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
