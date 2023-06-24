-- Largely based off of code in the `src/gui.lua` file of the `i3` mod (by kilbith), under MIT.
-- (has more features and extensibility though)
local armor, skins, minetest, flow = armor, skins, minetest, flow
local gui = flow.widgets
local has_armor = minetest.get_modpath"3d_armor" ~= nil
local has_skins = minetest.get_modpath"skinsdb" ~= nil
local sway_player_model = {}
_G.sway_player_model = sway_player_model
function sway_player_model.Model(fields)
	local player = fields.player
	local props = player:get_properties()
	--local armor_skin = has_armor or has_skins
	--local ctn_hgt = --[[data.legacy_inventory and 6.1 or]] 6.3
	local anim = player:get_local_animation()
	local frame_loop_begin, frame_loop_end, animation_speed
	if type(anim) == "table" and next(anim) then
		frame_loop_begin = anim.x
		frame_loop_end = anim.y
		animation_speed = 30
	end
	return props.mesh ~= "" and gui.HBox{
		gui.Model{
			--w = armor_skin and 4 or 3.4,
			-- TODO test this on older clients
			w = 2.2, h = 4,
			name = "player_model",
			mesh = props.mesh,
			textures = props.textures,
			rotation_x = 0,
			rotation_y = -150,
			continuous = false,
			mouse_control = false,
			frame_loop_begin = frame_loop_begin,
			frame_loop_end = frame_loop_end,
			animation_speed = animation_speed
		},
		gui.Spacer{ padding = -0.42, expand = false }
	} or sway_player_model.Preview{ player = player }
end
function sway_player_model.Preview(fields)
	local player = fields.player
	local props
	if not has_skins and not has_armor then
		props = fields.player:get_properties()
	end
	return has_armor and gui.Image{ w = 2, h = 4, texture_name = armor.textures[player:get_player_name()].preview }
	or has_skins and gui.Image{ w = 2, h = 4, texture_name = skins.get_player_skin(player):get_preview() }
	or gui.Image{ w = 2, h = 2 * props.visual_size.y, texture_name = props.textures[1] }
end
