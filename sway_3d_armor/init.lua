local minetest, sway, armor = minetest, sway, armor
local has_technic = minetest.get_modpath"technic" ~= nil
local has_shields = minetest.get_modpath"shields" ~= nil
local gui = sway.widgets
local widgets = {}
sway.mods.sway_3d_armor = { widgets = widgets, slot_w = 2, slot_h = 2, slot_remainder = 0 }
if has_shields then
	sway.mods.sway_3d_armor.slot_remainder = 1
end
function widgets.List(fields)
	return gui.sway.List{
		align_v = "center",
		inventory_location = "detached:" .. fields.player_name .. "_armor",
		list_name = "armor",
		w = fields.w or sway.mods.sway_3d_armor.slot_w,
		h = fields.h or sway.mods.sway_3d_armor.slot_h,
		remainder = fields.remainder or sway.mods.sway_3d_armor.slot_remainder,
		remainder_v = true,
		listring = { { inventory_location = "current_player", list_name = "main" } }
	}
end
function widgets.Preview(fields)
	return gui.sway_player_model.Model{ player = minetest.get_player_by_name(fields.player_name) }
end
function widgets.Stats(fields)
	local name = fields.player_name
	return gui.VBox{
		name = "sway_3d_armor_stats_box",
		gui.Label{ label = "Stats" },
		gui.Label{ label = "Level: " .. armor.def[name].level },
		gui.Label{ label = "Heal: " .. armor.def[name].heal },
		armor.config.fire_protect and gui.Label{ label = "Fire: " .. armor.def[name].fire } or gui.Nil{},
		has_technic and gui.Label{ label = "Radiation: " .. armor.def[name].groups["radiation"] } or gui.Nil{} }
end
sway.register_page("sway_3d_armor:3d_armor", {
	title = "Armor",
	slot_w = nil, slot_h = nil, slot_remainder = nil, -- Use global defaults by default
	get = function(self, player, context)
		local name = player:get_player_name()
		return gui.sway.Form{
			player = player,
			context = context,
			show_inv = true,
			gui.HBox{
				gui.sway_3d_armor.List{
					player_name = name,
					w = self.slot_w,
					h = self.slot_h,
					remainder = self.slot_remainder
				},
				gui.sway_3d_armor.Preview{ player_name = name },
				gui.sway_3d_armor.Stats{ player_name = name }
			}
		}
	end
})
armor:register_on_update(function(player)
	if sway.enabled then
		sway.set_player_inventory_formspec(player)
	end
end)
local crafting_page_name = "sway:crafting"
local old_filter = sway.pages[crafting_page_name].filter
sway.override_page(crafting_page_name, {
	filter = function (self, player, context, elm)
		local name = player:get_player_name()
		table.insert(elm, 1, gui.HBox{
			gui.sway_3d_armor.List{ player_name = name },
			gui.sway_3d_armor.Preview{ player_name = name }
		})
		return old_filter(self, player, context, elm)
	end
})
