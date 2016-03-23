local USES = 200
local mode = {}
local count = 0
local function parti(pos)
  	minetest.add_particlespawner(25, 0.3,
		pos, pos,
		{x=2, y=0.2, z=2}, {x=-2, y=2, z=-2},
		{x=0, y=-6, z=0}, {x=0, y=-10, z=0},
		0.2, 1,
		0.2, 2,
		true, "mymasonhammer_parti.png")
end
	mode = "1"
minetest.register_tool( "mymasonhammer:hammer",{
	description = "Mason Hammer",
	inventory_image = "mymasonhammer_hammer.png",
	wield_image = "mymasonhammer_hammer.png",
	wield_scale = {x=1,y=1,z=3},
on_use = function(itemstack, user, pointed_thing)
	if pointed_thing.type ~= "node" then
		return
	end
	local pos = pointed_thing.under
	local node = minetest.get_node(pos)
	local default_material = {
		{"default:cobble", "default_cobble", "Cobble","stairs:stair_cobble"},
		{"default:desert_cobble","default_desert_cobble", "Desert Cobble","stairs:stair_desert_cobble"},
		{"default:stone","default_stone", "Stone","stairs:stair_stone"},
		{"default:desert_stone","default_desert_stone", "Desert Stone","stairs:stair_desert_stone"},
		{"default:stonebrick","default_stone_brick", "Stone Brick","stairs:stair_stonebrick"},
		{"default:desert_stonebrick","default_desert_stone_brick", "Desert Stone Brick","stairs:stair_desert_stonebrick"},
		}
	for i in ipairs (default_material) do
	local item = default_material [i][1]
	local mat = default_material [i][2]
	local desc = default_material [i][3]
	local stair = default_material [i][4]
	if pointed_thing.type ~= "node" then
		return
	end
	if minetest.is_protected(pos, user:get_player_name()) then
		minetest.record_protection_violation(pos, user:get_player_name())
		return
	end
		if mode == "1" then
			if node.name == item then
				count = count + 1
				parti(pos)
					if count >= 3 then
						minetest.set_node(pos,{name = stair, param2=minetest.dir_to_facedir(user:get_look_dir())})
						count = 0
				end
			end
		end
		if mode == "2" then
			if node.name == item then
				minetest.set_node(pos,{name = "mymasonhammer:"..mat.."_ladder2", param2=minetest.dir_to_facedir(user:get_look_dir())})
				parti(pos)
			elseif node.name == "mymasonhammer:"..mat.."_ladder2" then
				minetest.set_node(pos,{name = "mymasonhammer:"..mat.."_ladder3", param2=minetest.dir_to_facedir(user:get_look_dir())})
				parti(pos)
			elseif node.name == "mymasonhammer:"..mat.."_ladder3" then
				minetest.set_node(pos,{name = "mymasonhammer:"..mat.."_ladder", param2=minetest.dir_to_facedir(user:get_look_dir())})
				parti(pos)
			end
		end
		if mode == "3" then
			if node.name == item then
				minetest.set_node(pos,{name = "mymasonhammer:"..mat.."_foot", param2=minetest.dir_to_facedir(user:get_look_dir())})
				parti(pos)
			end
		end
end
	if not minetest.setting_getbool("creative_mode") then
		itemstack:add_wear(65535 / (USES - 1))
	end
	return itemstack
end,
on_place = function(itemstack, user, pointed_thing)
	local usr = user:get_player_name()

		if mode == "1" then
			mode = "2"
			minetest.chat_send_player(usr,"Ladder Hammer")
		elseif mode == "2" then
			mode = "3"
			minetest.chat_send_player(usr,"Foot Hold Hammer")
		elseif mode == "3" then
			mode = "1"
			minetest.chat_send_player(usr,"Stair Hammer")
		end
	if not minetest.setting_getbool("creative_mode") then
		itemstack:add_wear(65535 / (USES - 1))
	end
	return itemstack
	end
})
minetest.register_craft({
		output = "mymasonhammer:hammer",
		recipe = {
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"default:steel_ingot", "wool:blue", "default:steel_ingot"},
			{"", "wool:blue", ""},
		},
})

minetest.register_craft({
		output = "mymasonhammer:hammer",
		recipe = {
			{"mymasonhammer:hammer", "default:steel_ingot"},
		},
})
