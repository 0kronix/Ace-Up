SMODS.Enhancement({
    key = "battery",

    atlas = "enhancements",
    pos = { x = 1, y = 0 },

    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,

    config = { percent = 20, percent_lose = 5, display_percent = 20 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.percent, card.ability.percent_lose } }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                ace_blind_size = -card.ability.percent
            }
        end

        if context.after and context.cardarea == G.play then
            card.ability.percent = card.ability.percent - card.ability.percent_lose

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    card.ability.display_percent = card.ability.percent

                    if card.ability.percent <= 0 then
                        SMODS.destroy_cards(card)
                        delay(0.5)
                    end
                    return true
                end
            }))

            if card.ability.percent > 0 then
                return {
                    message = "-" .. card.ability.percent_lose .. "%",
                    colour = G.C.GREEN
                }
            end
        end
    end,
})

SMODS.DrawStep {
    key = 'battery_visual_fix',
    order = -5,
    func = function(self, layer)
        if self.config.center.key == 'm_ace_battery' and self.sprite_facing == 'front' then
            local stage = self.ability.percent_lose - self.ability.display_percent / self.ability.percent_lose

            if self.children.center then
                self.children.center:set_sprite_pos({ x = stage, y = 0 })
            end
            if self.children.front then
                self.children.front:set_sprite_pos({ x = stage, y = 0 })
            end
        end
    end,
    conditions = { vortex = false, facing = "front" }
}