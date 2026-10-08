return {
    descriptions = {
        Joker = {
            j_ace_bad_cupcake = {
                name = "Bad Cupcake",
                text = {
                    {
                        "Each {C:attention}scored card{} have",
                        "{C:green}#1# in #2#{} chance to get",
                        "{C:attention}random seal{} when scored",
                    },
                    {
                        "{C:red}Self destructs{} after",
                        "{C:red}#3#{} fails or {C:green}#4#{} seals",
                    }
                }
            },
            j_ace_balloon_jimbo = {
                name = "Balloon Jimbo",
                text = {
                    "Gains {C:chips}+#2#{} Chips if",
                    "{C:attention}nothing{} was bought",
                    "in the {C:attention}shop",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
                }
            },
            j_ace_bomb = {
                name = "Bomb",
                text = {
                    {
                        "Cards {C:attention}without{} enhancement",
                        "gives {X:mult,C:white}X#1#{} Mult when scored",
                    },
                    {
                        "{C:red}Destroys{} self and {C:attention}adjacent",
                        "Jokers, if hand is {C:ace_onfire}on fire",
                    }
                }
            },
            j_ace_brain_invaders = {
                name = "Brain Invaders",
                text = {
                    "This Joker gains {C:mult}+#2#{} Mult",
                    "per {C:attention}consecutive{} using",
                    "the same {C:planet}Planet{} card",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
                }
            },
            j_ace_computer_joker = {
                name = "Computer Joker",
                text = {
                    "{C:attention}+#1#{} hand size for each",
                    "{C:green}reroll{} in the {C:attention}shop",
                    "{C:inactive}(Resets each round, max of {C:attention}+#3#{C:inactive})",
                    "{C:inactive}(Currently {C:attention}+#2#{C:inactive} hand size)",
                }
            },
            j_ace_crimson_joker = {
                name = "Crimson Joker",
                text = {
                    "All {C:attention}suits{} are {C:attention}considered",
                    "to be {C:hearts}Hearts",
                }
            },
            j_ace_crumpled_banknote = {
                name = "Crumpled Banknote",
                text = {
                    "Changes its {C:attention}sell value{} to a",
                    "random one from {C:money}$#1#{} to {C:money}$#2#",
                    "at end of round",
                }
            },
            j_ace_grimoire_joker = {
                name = "Grimoire Joker",
                text = {
                    "If {C:attention}poker hand{} is a {C:attention}#1#",
                    "containing {C:attention}4{} different {C:attention}suits{},",
                    "create a random {C:spectral}Spectral{} card",
                    "{C:inactive}(Must have room)",
                }
            },
            j_ace_haunted_joker = {
                name = "Haunted Joker",
                text = {
                    "Decrease {C:attention}Blind requirement",
                    "by {C:attention}#1#%{} when {C:tarot}Tarot{}",
                    "card is used",
                }
            },
            j_ace_joke_bottom = {
                name = "Joke Bottom",
                text = {
                    "Gives {C:money}$#1#{} if played",
                    "{C:attention}poker hand{} is on {C:attention}1{} level",
                }
            },
            j_ace_joker_window = {
                name = "Joker Window",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "Lose {C:money}$#2#{} every",
                    "{C:attention}#4# {C:inactive}[#3#]{} rounds",
                }
            },
            j_ace_leprechaun = {
                name = "Leprechaun",
                text = {
                    "Gives {C:green}+#2#{} to all {C:attention}listed",
                    "{C:green}probabilities{} for every",
                    "{C:money}$#1#{} you have",
                    "{C:inactive}(max of {C:green}+#4#{C:inactive}, Currently {C:green}+#3#{C:inactive} prob.)",
                }
            },
            j_ace_parallax_joker = {
                name = "Parallax Joker",
                text = {
                    "Gives {X:mult,C:white}X#1#{} Mult, if {C:attention}number",
                    "of {C:attention}scored cards{} equals",
                    "the {C:attention}number{} of your {C:attention}Jokers",
                }
            },
            j_ace_schemajoker = {
                name = "Schemajoker",
                text = {
                    "Scored cards gives {C:mult}+Mult",
                    "equals to the {C:attention}number{} of cards in",
                    "{C:attention}full deck{} with the same {C:attention}suit",
                }
            },
            j_ace_shopkeeper_joker = {
                name = "Shopkeeper Joker",
                text = {
                    "Buying {C:attention}Booster Packs",
                    "{C:green}rerolls{} the {C:attention}shop",
                }
            },
            j_ace_stellar_dice = {
                name = "Stellar Dice",
                text = {
                    "{C:green}#1# in #2#{} chance to upgrade",
                    "every {C:legendary}poker hand{} by {C:attention}#3#{} level",
                    "after using {C:planet}Planet{} card",
                }
            },
            j_ace_target_joker = {
                name = "Target Joker",
                text = {
                    "When entering a {C:attention}shop{}, one",
                    "random card become a {C:attention}target",
                    "This Joker gains {C:mult}+#2#{} Mult when",
                    "{C:attention}target{} is {C:attention}purchased",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            },
            j_ace_the_end = {
                name = "The End?..",
                text = {
                    "Disables effect of {C:attention}Boss Blind",
                    "if no {C:attention}Blinds{} was",
                    "{C:red}skipped{} during {C:attention}Ante",
                }
            },
            j_ace_villian_hologram = {
                name = "Villian Hologram",
                text = {
                    "This Joker gains {X:mult,C:white}X#2#{} Mult",
                    "if {C:attention}played hand{} contains",
                    "the {C:attention}previous{} one",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
                }
            },
            j_ace_whale = {
                name = "Whale",
                text = {
                    "Reroll {C:attention}Boss Blind",
                    "when {C:red}skipping{} {C:attention}Blind",
                }
            },
        }
    }
}
