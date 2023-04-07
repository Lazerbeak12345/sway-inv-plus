local gui = flow.widgets
sway.register_page("sway_awards:awards", {
	title = "Awards",
	get = function(self, player, context)
		local name = player:get_player_name()
		local award_list awards.get_award_states(name)
		print(dump(award_list))
		return sway.make_form(player, context, gui.Label { label = "hi"})
	end
})
