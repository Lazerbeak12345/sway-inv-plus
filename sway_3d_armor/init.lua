local minetest, sway, armor = minetest, sway, armor
local has_technic = minetest.get_modpath("technic") ~= nil
local gui = sway.widgets
local widgets = {}
sway.mods.sway_3d_armor = { widgets = widgets }
function widgets.List(fields)
	local name = fields.player_name
	local w = fields.w
	local h = fields.h
	local location = "detached:" .. name .. "_armor"
	return gui.VBox{
		gui.List{
			inventory_location = location,
			list_name = "armor",
			w = w, h = h,
		},
		gui.Listring{
			inventory_location = location,
			list_name = "armor"
		},
		gui.Listring{
			inventory_location = "current_player",
			list_name = "main"
		}
	}
end
function widgets.Preview(fields)
	local name = fields.player_name
	return gui.Image{
		w = 2, h = 4,
		texture_name = armor.textures[name].preview
	}
end
function widgets.Stats(fields)
	local name = fields.player_name
	return gui.VBox{
		name = "sway_3d_armor_stats_box",
		gui.Label{ label = "Stats" },
		gui.Label{ label = "Level: " .. armor.def[name].level },
		gui.Label{ label = "Heal: " .. armor.def[name].heal },
		armor.config.fire_protect and gui.Label{
			label = "Fire: " .. armor.def[name].fire
		} or gui.Nil{},
		has_technic and gui.Label{
			label = "Radiation: " .. armor.def[name].groups["radiation"]
		} or gui.Nil{}
	}
end
sway.register_page("sway_3d_armor:3d_armor", {
	title = "Armor",
	slot_w = 2, slot_h = 3,
	get = function(self, player, context)
		local name = player:get_player_name()
		return gui.sway.Form{
			player = player,
			context = context,
			show_inv = true,
			gui.HBox{
				gui.sway_3d_armor.List{
					player_name = name,
					w = self.slot_w, h = self.slot_h
				},
				gui.sway_3d_armor.Preview{ player_name = name },
				gui.sway_3d_armor.Stats{ player_name = name }
			}
		}
	end
})
armor:register_on_update(function(player)
	sway.set_player_inventory_formspec(player)
end)
