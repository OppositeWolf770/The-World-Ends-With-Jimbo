-- == MUS RATTUS
-- == Chips and bonus cards

local stuffToAdd = {}

-- Storm Warning
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "stormWarning",
	key = "stormWarning",
	config = {extra = {chips = 0, chipGain = 40}},
	pos = {x = 5, y = 0},
	loc_txt = {
		name = 'Storm Warning',
		text = {
			"This joker gains {C:chips}+#1#{} Chips",
			"when any card is sold. {C:attention}Resets{}",
			"when any card is bought",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
		}
	},
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chipGain, center.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.selling_card and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipGain
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!"})
		elseif context.buying_card and not context.blueprint and card.ability.extra.chips > 0 and context.card.ability.set ~= "Voucher" then
			card.ability.extra.chips = 0
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset!"})
		elseif context.cardarea == G.jokers and context.joker_main and card.ability.extra.chips > 0 then
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips,
			}
		end
	end
})

-- Candle Service
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "candleService",
	key = "candleService",
	config = {extra = {chips = 125, played = 0, req = 4}},
	pos = {x = 1, y = 0},
	loc_txt = {
		name = 'Candle Service',
		text = {
			"Every fourth scoring",
			"{C:attention}2{}, {C:attention}3{}, {C:attention}4{}, or {C:attention}5{} gives",
			"you {C:chips}+#1#{} Chips",
			"{C:inactive}(Currently #2#/#3#){}"
		}
	},
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chips, center.ability.extra.played, center.ability.extra.req}}
	end,
	calculate = function(self, card, context)
		if context.individual
		and context.other_card:get_id() <= 5
		and context.other_card:get_id() >= 2
		and context.cardarea == G.play then
			if card.ability.extra.played >= card.ability.extra.req-1 then
				card.ability.extra.played = 0
				return {
					chips = card.ability.extra.chips,
					card = card
				}
			else
				card.ability.extra.played = card.ability.extra.played + 1
				return { 
					extra = {
						message = card.ability.extra.played.."/"..card.ability.extra.req,
						colour = G.C.FILTER
					},
					card = card
				}
			end
		end
	end
})

-- Aqua Monster
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "aquaMonster",
	key = "aquaMonster",
	config = {extra = {}},
	pos = {x = 2, y = 0},
	loc_txt = {
		name = 'Aqua Monster',
		text = {
			"All scoring cards become",
			"{C:attention}Bonus Cards{} if played hand",
			"contains a {C:attention}Three of a Kind{}"
		}
	},
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before and next(context.poker_hands['Three of a Kind']) and not context.blueprint then
			local faces = {}
			for k, v in ipairs(context.scoring_hand) do
				if true then 
					faces[#faces+1] = v
					v:set_ability(G.P_CENTERS.m_bonus, nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end
					})) 
				end
			end
			if #faces > 0 then 
				return {
					message = "Splash!",
					colour = G.C.CHIPS,
					card = self
				}
			end
		end
	end
})

-- Aqua Ghost
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "aquaGhost",
	key = "aquaGhost",
	config = {extra = {}},
	pos = {x = 3, y = 0},
	loc_txt = {
		name = 'Aqua Ghost',
		text = {
			"All scoring cards become",
			"{C:dark_edition}Foil Cards{} if played hand",
			"contains a {C:attention}Three of a Kind{}"
		}
	},
	rarity = 3,
	cost = 9,
	discovered = true,
	blueprint_compat = false,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before and next(context.poker_hands['Three of a Kind']) and not context.blueprint then
			local faces = {}
			for k, v in ipairs(context.scoring_hand) do
				if true then 
					faces[#faces+1] = v
					v:set_edition({foil = true}, nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end
					})) 
				end
			end
			if #faces > 0 then 
				return {
					message = "Splash!",
					colour = G.C.CHIPS,
					card = self
				}
			end
		end
	end
})

-- Aqua Demon
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "aquaDemon",
	key = "aquaDemon",
	config = {extra = {chips = 666}},
	pos = {x = 4, y = 0},
	loc_txt = {
		name = 'Aqua Demon',
		text = {
			"{C:chips}+#1#{} Chips if played",
			"hand contains",
			"a {C:attention}Three of a Kind{}"
		}
	},
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main and next(context.poker_hands['Three of a Kind']) then 
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips,
			}
		end
	end
})

-- Lightning Moon
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "lightningMoon",
	key = "lightningMoon",
	config = {extra = {cardsNeeded = 4, chips = 30}},
	pos = {x = 6, y = 0},
	loc_txt = {
		name = 'Lightning Moon',
		text = {
			"{C:chips}+#1#{} Chips for each",
			"{C:clubs}Club{} held in hand",
		}
	},
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chips, center.ability.extra.cardsNeeded}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.hand and context.individual and not context.end_of_round
		--and #context.full_hand == card.ability.extra.cardsNeeded 
		and context.other_card:is_suit("Clubs") then
			if context.other_card.debuff then
				return {
					message = localize('k_debuffed'),
					colour = G.C.RED,
					card = card,
				}
			else
				return {
					h_chips = card.ability.extra.chips,
					card = card
				}
			end
		end
	end
})

-- Burning Cherry
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "burningCherry",
	key = "burningCherry",
	config = {extra = {chips = 200, chipsGain = -25, handReq = "High Card"}},
	pos = {x = 7, y = 0},
	loc_txt = {
		name = 'Burning Cherry',
		text = {
			"{C:chips}+#1#{} Chips",
			"{C:chips}#2#{} Chips when you play a",
			"hand that isn't {C:attention}#3#{}",
			"{C:inactive}(Hand changes each round){}"
		}
	},
	rarity = 1,
	cost = 3,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chips, center.ability.extra.chipsGain, center.ability.extra.handReq}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.after and context.scoring_name ~= card.ability.extra.handReq and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipsGain
			if card.ability.extra.chips <= 0 then 
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
							func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
								return true; end})) 
						return true
					end
				})) 
				return {
					message = "Eaten!",
					colour = G.C.CHIPS
				}
			end
			return {
				message = "Downgrade!",
				colour = G.C.CHIPS,
				card = card
			}
		end
		
		if context.cardarea == G.jokers and context.joker_main and card.ability.extra.chips > 0 then
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips,
			}
		end
		
		if context.end_of_round and not context.blueprint then
			local _poker_hands = {}
			for k, v in pairs(G.GAME.hands) do
				if v.visible and k ~= card.ability.extra.handReq then _poker_hands[#_poker_hands+1] = k end
			end
			card.ability.extra.handReq = pseudorandom_element(_poker_hands, pseudoseed('burningCherry'))
		end
	end,
	--add_to_deck = function(self, card, from_debuff)
	--	local _poker_hands = {}
	--	for k, v in pairs(G.GAME.hands) do
	--		if v.visible and k ~= card.ability.extra.handReq then _poker_hands[#_poker_hands+1] = k end
	--	end
	--	card.ability.extra.handReq = pseudorandom_element(_poker_hands, pseudoseed('burningCherry'))
	--end
})

-- Impact Warning
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "impactWarning",
	key = "impactWarning",
	config = {extra = {chips = 0, chipsGain = 20, lastUsed = "None"}},
	pos = {x = 8, y = 0},
	loc_txt = {
		name = 'Impact Warning',
		text = {
			"This joker gains {C:chips}+#1#{} Chips when a",
			"{C:planet}Planet{} card is used. {C:attention}Resets{} on using",
			"the same {C:planet}Planet{} twice in a row",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
			"{C:inactive}(Last used: {C:planet}#3#{C:inactive}){}"
		}
	},
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chipsGain, center.ability.extra.chips, center.ability.extra.lastUsed}}
	end,
	calculate = function(self, card, context)
		-- if context.cardarea == G.jokers and context.before and G.GAME.hands[context.scoring_name].level == 1 and card.ability.extra.chips > 0 then
			-- card.ability.extra.chips = 0
			-- card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset!"})
		-- end
		
		if context.cardarea == G.jokers and context.joker_main and card.ability.extra.chips > 0 then
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips,
			}
		end
		
		if context.using_consumeable and not context.blueprint then
			if context.consumeable.ability.set == "Planet" then
				if context.consumeable.ability.name == card.ability.extra.lastUsed then
					card.ability.extra.chips = 0
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset!"})
				else
					card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipsGain
					card.ability.extra.lastUsed = context.consumeable.ability.name
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
						chip_mod = card.ability.extra.chips,
					})
				end
			end
		end
	end
})

-- Shout!
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "shout",
	key = "shout",
	config = {extra = {chips = 150, currentStreak = 0}},
	pos = {x = 9, y = 0},
	loc_txt = {
		name = 'Shout!',
		text = {
			"{C:chips}+#1#{} Chips if your last {C:attention}3{} hands",
			"contained a scoring face card",
			"{C:inactive}(Current streak: {C:attention}#2#{C:inactive}){}"
		}
	},
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chips, center.ability.extra.currentStreak}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main then
			local hasFace = false
			for k, v in ipairs(context.scoring_hand) do
				if v:is_face() then
					hasFace = true
				end
			end
			if hasFace then
				card.ability.extra.currentStreak = card.ability.extra.currentStreak + 1
				if card.ability.extra.currentStreak >= 3 then
					return {
						message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
						chip_mod = card.ability.extra.chips,
					}
				end
			elseif card.ability.extra.currentStreak ~= 0 then
				card.ability.extra.currentStreak = 0
				return {
					message = "Reset!"
				}
			end			
		end
	end
})

-- Burning Melon
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "burningMelon",
	key = "burningMelon",
	config = {extra = {chips = 80, chipsLoss = -10, bigChips = 200}},
	pos = {x = 10, y = 0},
	loc_txt = {
		name = 'Burning Melon',
		text = {
			"{C:chips}+#1#{} Chips, {C:chips}#2#{} per round",
			"On the final hand of the",
			"round, gives {C:chips}+#3#{} extra chips",
			"and destroy this joker"
		}
	},
	rarity = 1,
	cost = 3,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chips, center.ability.extra.chipsLoss, center.ability.extra.bigChips}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main and card.ability.extra.chips > 0 then
			if G.GAME.current_round.hands_left == 0 then
				destroyCard(card)
				return {
					message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips + card.ability.extra.bigChips}},
					chip_mod = card.ability.extra.chips + card.ability.extra.bigChips,
				}
			end
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips,
			}
		end
	
		if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipsLoss
			if card.ability.extra.chips <= 0 then
				destroyCard(card)
				return {
					message = "Eaten!",
					colour = G.C.CHIPS
				}
			end
			return {
				message = card.ability.extra.chips.." Chips!",
				colour = G.C.CHIPS
			}
		end
	end
})

-- Lightning Storm
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "lightningStorm",
	key = "lightningStorm",
	config = {extra = {chips = 50}},
	pos = {x = 11, y = 0},
	loc_txt = {
		name = 'Lightning Storm',
		text = {
			"Scored cards that share",
			"a suit with {C:attention}Jacks{} held",
			"in hand give {C:chips}+#1#{} Chips"
		}
	},
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local matchSuit = false
			local matchedCard = nil
			for _, v in ipairs(G.hand.cards) do
				for _, suit in ipairs({"Spades", "Hearts", "Clubs", "Diamonds"}) do
					if v:is_suit(suit) and context.other_card:is_suit(suit) and v:get_id() == 11 then
						matchSuit = true
						matchedCard = v
					end
				end
			end
			if matchSuit then
				G.E_MANAGER:add_event(Event({
					func = function()
						matchedCard:juice_up()
						return true
					end
				})) 
				return {
					chips = card.ability.extra.chips,
					card = card
				}
			end
		end
	end
})

-- Stopper Spark
table.insert(stuffToAdd, {
	object_type = "Joker",
	name = "stopperSpark",
	key = "stopperSpark",
	config = {extra = {chips = 500}},
	pos = {x = 12, y = 0},
	loc_txt = {
		name = 'Stopper Spark',
		text = {
			"{C:attention}Stone Cards{} held in",
			"hand give {C:chips}+#1#{} Chips"
		}
	},
	rarity = 3,
	cost = 9,
	discovered = true,
	blueprint_compat = true,
	atlas = "jokers",
	loc_vars = function(self, info_queue, center)
		return {vars = {center.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.hand and context.individual and not context.end_of_round
		and context.other_card.ability.effect == "Stone Card" then
			if context.other_card.debuff then
				return {
					message = localize('k_debuffed'),
					colour = G.C.RED,
					card = card,
				}
			else
				return {
					h_chips = card.ability.extra.chips,
					card = card,
				}
			end
		end
	end
})

return{stuffToAdd = stuffToAdd}