local sway, awards = sway, awards
local gui = sway.widgets
sway.mods.sway_awards = { widgets = {} }
function gui.sway_awards.ProgressBar(fields)
	local bar_width = fields.w
	local bar_height = fields.h or 1
	local current = fields.current
	local target = fields.target
	local bg_color = fields.bg_color or "#333333"
	local color = fields.color or "#008800"
	return gui.Stack {
		gui.Box{ w = bar_width, h = bar_height, color = bg_color, align_h = "left" },
		current > 0 and gui.Box{
			w = (current * bar_width) / target,
			h = bar_height,
			color = color,
			align_h = "left"
		} or gui.Nil{},
		gui.HBox{
			w = bar_width,
			align_h = "left",
			padding = .2,
			gui.Label{ label = math.floor((current * 100 * 100) / target) / 100 .. "% ", align_h = "left", expand = true },
			gui.Label{ label = current .. " of " .. target, align_h = "right" } or gui.Nil{}
		}
	}
end
function gui.sway_awards.Award(fields)
	local bar_width = fields.bar_width
	local award = fields.award

	local def = award.def
	local title = def.title
	local description = def.description
	local icon = def.icon
	local unlocked = award.unlocked

	local progress = award.progress
	local current, target
	local started = award.started
	if progress then
		current, target = progress.current, progress.target
	end
	return gui.HBox {
		padding = .2,
		bgcolor = unlocked and "#005500" or "#aaaaaa",
		gui.Image{ w = 2, h = 2, texture_name = icon or "awards_unknown.png" },
		gui.VBox{
			gui.Label { label = title },
			gui.Label { label = description },
			progress and gui.sway_awards.ProgressBar{ w = bar_width, current = current, target = target }
			or unlocked and gui.Label{ label = "Complete!" }
			or (not started) and gui.Label{ label = "Not started!" }
			or gui.Label{ label = " ??? " }
		}
	}
end
function gui.sway_awards.ScrollableAwards(fields)
	local player = fields.player
	fields.player = nil
	local bar_width = fields.bar_width
	fields.bar_width = nil
	local name = player:get_player_name()
	local award_list = awards.get_award_states(name)
	for _, award in ipairs(award_list) do
		local def = award.def
		if def:can_unlock(player) and (award.unlocked or not def.secret) then
			fields[#fields+1] = gui.sway_awards.Award{ bar_width = bar_width, award = award }
		end
	end
	return gui.ScrollableVBox(fields)
end
sway.register_page("sway_awards:awards", {
	title = "Awards",
	bar_width = 6,
	h = 8.9,
	get = function(self, player, context)
		return gui.sway.Form{
			player = player,
			context = context,
			gui.sway_awards.ScrollableAwards{
				name = "sway_awards_scrollbox",
				player = player,
				bar_width = self.bar_width,
				h = self.h
			}
		}
	end
})
