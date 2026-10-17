SMODS.Joker {
    key = "okronix",

    atlas = "okronix",
    pos = { x = 0, y = 0 },

    rarity = 1,
    cost = 100,

    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    unlocked = true,
    discovered = true,

	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_ace_author_badge"), G.C.RARITY[4], G.C.WHITE, 1.2)
	end,

	in_pool = function(self)
		return false
	end,
}

ACE.custom_ui = function(mod_nodes)
	G.ace_main_jokers_list = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		G.CARD_W,
		G.CARD_H,
		{ card_limit = 1, type = "title", highlight_limit = 0, collection = true, invisible = true }
	)
	local silent = false
    G.GAME.viewed_back = Back(G.P_CENTERS.b_red)
    local card = Card(
        G.ace_main_jokers_list.T.x + (G.ace_main_jokers_list.T.w / 2),
        G.ace_main_jokers_list.T.y,
        G.CARD_W,
        G.CARD_H,
        G.P_CARDS.empty,
        G.P_CENTERS["j_ace_okronix"] or ACE.DescriptionDummies["j_ace_okronix"],
        {
            bypass_discovery_center = true,
            bypass_discovery_ui = true,
            bypass_lock = true,
            viewing_back = false,
            bypass_back = G.P_CENTERS["b_red"].pos,
        }
    )
    G.ace_main_jokers_list:emplace(card)
    card:hard_set_T(G.ace_main_jokers_list.T.x + (G.ace_main_jokers_list.T.w / 2))
    card.sprite_facing = "front"
    card.facing = "front"
    card:start_materialize({ G.C.RED }, silent)
    silent = true
	mod_nodes[#mod_nodes + 1] = {
		n = G.UIT.R,
		config = { minh = 0.2, padding = 0.2 },
	}
	mod_nodes[#mod_nodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm", minw = 6 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", no_fill = true },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", no_fill = true },
						nodes = {
							{ n = G.UIT.O, config = { object = G.ace_main_jokers_list } },
						},
					},
				},
			},
		},
	}
	return mod_nodes
end
