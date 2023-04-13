local has_technic = minetest.get_modpath("technic") ~= nil
local gui = flow.widgets
local gui_nil = gui.Spacer{expand=false}
sway.register_page("sway_3d_armor:3d_armor", {
	title = "Armor",
	-- SUPER easy way to add new labels or stats
	stats_box_filter = function (self, stats_box)
		return stats_box
	end,
	slot_w = 2,
	slot_h = 3,
	get = function(self, player, context)
		local name = player:get_player_name()
		local location = "detached:" .. name .. "_armor"
		return sway.widgets.form{
			player = player,
			context = context,
			show_inv = true,
			gui.HBox{
				gui.VBox{
					gui.List{
						inventory_location = location,
						list_name = "armor",
						w = self.slot_w, h = self.slot_h,
					},
					gui.Listring{
						inventory_location = location,
						list_name = "armor"
					},
					gui.Listring{
						inventory_location = "current_player",
						list_name = "main"
					},
				},
				gui.Image{ w = 2, h = 4, texture_name = armor.textures[name].preview },
				self:stats_box_filter(gui.VBox{
					name = "sway_3d_armor_stats_box",
					gui.Label{ label = "Stats" },
					gui.Label{ label = "Level: " .. armor.def[name].level },
					gui.Label{ label = "Heal: " .. armor.def[name].heal },
					armor.config.fire_protect and gui.Label{ label = "Fire: " .. armor.def[name].fire } or gui_nil,
					has_technic and gui.Label{ label = "Radiation: " .. armor.def[name].groups["radiation"] } or gui_nil,
				})
			}
		}
	end
})
armor:register_on_update(function(player)
	sway.set_player_inventory_formspec(player)
end)
