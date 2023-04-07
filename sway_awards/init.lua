local gui = flow.widgets
local gui_nil = gui.Spacer{expand=false}
local function generate_award(self, title, description, unlocked, icon, progress)
	local current, target
	if progress then
		current, target = progress.current, progress.target
	end
	return gui.HBox {
		padding = .2,
		bgcolor = unlocked and "#555555" or "#aaaaaa",
		gui.Image{ w = 2, h = 2, texture_name = icon or "awards_unknown.png" },
		gui.VBox{
			gui.Label { label = title },
			gui.Label { label = description },
			progress and gui.Stack {
				gui.Box{
					w = self.bar_width,
					h = 1,
					color = "#333333",
					align_h = "left",
				},
				gui.Box{
					w = (current * self.bar_width) / target,
					h = 1,
					color = "#008800",
					align_h = "left",
				},
				gui.HBox{
					w = self.bar_width,
					align_h = "left",
					padding = .2,
					gui.Label{
						label = math.floor((current * 100) / target) .. "% ",
						align_h = "left",
						expand = true,
					},
					gui.Label{
						label = current .. " of " .. target,
						align_h = "right",
					}
				}
			} or gui_nil
		},
	}
end
sway.register_page("sway_awards:awards", {
	title = "Awards",
	bar_width = 6,
	get = function(self, player, context)
		local name = player:get_player_name()
		local award_list = awards.get_award_states(name)
		local awards_box = { name = "sway_awards:awards_box", h = 8.9 }
		for _, award in ipairs(award_list) do
			local def = award.def
			if def:can_unlock(player) and (award.unlocked or not def.secret) then
				table.insert(awards_box, generate_award(self, def.title, def.description, award.unlocked, def.icon, award.progress))
			end
		end
		return sway.make_form(player, context, gui.ScrollableVBox(awards_box))
	end
})
