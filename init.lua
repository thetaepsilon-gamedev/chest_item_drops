
local f = assert(default.can_interact_with_node)
local swapped = function(pos, player) return f(player, pos) end

local yes = function() return true end

-- firstly, lift the restriction of chests having to be empty before removal.
-- for locked chests simply check the player is allowed to interact based on ownership.
minetest.override_item("default:chest", {can_dig=yes})
minetest.override_item("default:chest_locked", {can_dig=swapped})



-- then, for both kinds of chests, in on_destruct we want to get drops then give them midly randomised directions.
local ymax = 1
local ymin = 2
local rand = math.random
local vy = function()
	return (rand() * ymax) + ymin
end

local hrange = 0.5
local hmax = hrange * 2
local hmin = -hrange
local vh = function()
	return (rand() * hmax) + hmin
end


local on_destruct = function(pos)
	local drops = {}
	default.get_inventory_drops(pos, "main", drops)
	print("drops", #drops)

	local raw = {}
	for _, drop in ipairs(drops) do
		raw.x = vh()
		raw.y = vy()
		raw.z = vh()
		local ent = minetest.add_item(pos, drop)
		ent:set_velocity(raw)
	end
end

local override = {on_destruct=on_destruct}
minetest.override_item("default:chest", override)
minetest.override_item("default:chest_locked", override)

