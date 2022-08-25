AddCSLuaFile()

module( "bsp2", package.seeall )

LUMPS_DEFAULT = {
	bsp3.LUMP_ENTITIES,				--All in-map entities
	bsp3.LUMP_PLANES,				--Plane equations for map geometry
	bsp3.LUMP_BRUSHES,				--Brushes
	bsp3.LUMP_BRUSHSIDES,			--Sides of brushes
	bsp3.LUMP_GAME_LUMP,				--Static props and detail props
	bsp3.LUMP_NODES,					--Spatial partitioning nodes
	bsp3.LUMP_LEAFS,					--Spatial partitioning leafs
	bsp3.LUMP_MODELS,				--Brush models (trigger_* / func_*)
	bsp3.LUMP_LEAFBRUSHES,			--Indexing between leafs and brushes
	bsp3.LUMP_TEXDATA,				--Texture data (width / height / name)
	bsp3.LUMP_TEXDATA_STRING_DATA,	--Names of textures
	bsp3.LUMP_TEXINFO				--Surface texture info
}

LUMPS_DEFAULT_CLIENT =
{
	bsp3.LUMP_VERTEXES,		--All vertices that make up map geometry
	bsp3.LUMP_EDGES,			--Edges between vertices in map geometry
	bsp3.LUMP_SURFEDGES,		--Indexing between vertices
	--bsp3.LUMP_FACES,		--Poligonal faces
	bsp3.LUMP_ORIGINALFACES,	--Original poligonal faces before BSP splitting
	bsp3.LUMP_LEAFFACES,		--Indexing between leafs and faces
	bsp3.LUMP_WORLDLIGHTS,	--Extended information for light_* entities
	bsp3.LUMP_CUBEMAPS,		--env_cubemap locations and sizes
}
table.Merge(LUMPS_DEFAULT_CLIENT, LUMPS_DEFAULT)

local function CreateBrushes( data )

	local bmeta = brush.GetBrushMetatable()
	local smeta = brush.GetSideMetatable()
	local blib = brush
	for k, brush in pairs( ( data[bsp3.LUMP_BRUSHSIDES] and data[bsp3.LUMP_BRUSHES] ) or {} ) do

		setmetatable(brush, bmeta)
		brush:Init()

		for i = brush.firstside+1, brush.firstside + brush.numsides do
			local side = data[bsp3.LUMP_BRUSHSIDES][i]
			setmetatable(side, smeta)
			side:Init()
			side.plane = side.plane.back
			side.bevel = side.bevel != 0
			brush:Add( side )
			task.YieldPer(5000, "progress")
		end

	end

end

local function CreateWindings( data )

	for k, brush in pairs( ( data[bsp3.LUMP_BRUSHSIDES] and data[bsp3.LUMP_BRUSHES] ) or {} ) do
		brush:CreateWindings()
		brush.center = (brush.min + brush.max) / 2
		task.YieldPer(200, "progress")
	end

end

local function ConvertEntities( data )

	local function ProcessKeyValue(t, k, v)
		if k == "origin" then
			local x,y,z = string.match( tostring(v), "([%+%-]?%d*%.?%d+) ([%+%-]?%d*%.?%d+) ([%+%-]?%d*%.?%d+)" )
			if x and y and z then
				return Vector(x,y,z)
			else
				print("FAILED TO PARSE: " .. tostring(v))
				return Vector()
			end
		end
		if k == "angles" then
			local x,y,z = string.match( tostring(v), "([%+%-]?%d*%.?%d+) ([%+%-]?%d*%.?%d+) ([%+%-]?%d*%.?%d+)" )
			return Angle(x,y,z)
		end
		if k == "model" then
			if v[1] == "*" then
				local index = string.match( v, "(%d+)")
				local model = data.models[ index+1 ]
				if model then
					t.bmodel = model
				end
			end
		end
		if string.Left( k, 2 ) == "On" then
			t.outputs = t.outputs or {}
			table.insert( t.outputs, {k, v} )
			return nil
		end
		return v
	end

	for k, ent in pairs( ( data[bsp3.LUMP_ENTITIES] and data[bsp3.LUMP_ENTITIES] ) or {} ) do

		for _, kv in ipairs(ent) do

			ent[kv.key] = ProcessKeyValue( ent, kv.key, kv.value )

		end

	end

end


local meta = {}

function meta:IsLoading() return false end
function meta:GetLoadTask() return nil end
function meta:GetLeaf( pos, node )

	node = node or self.models[1].headnode
	if node.is_leaf then return node end

	local d = node.plane.normal:Dot( pos ) - node.plane.dist
	return self:GetLeaf( pos, node.children[d > 0 and 1 or 2] )

end

local check_nop = function() return true end
function meta:GetBoxLeafs( list, mins, maxs, expand, check, node )

	check = check or check_nop
	node = node or self.models[1].headnode
	if node.is_leaf then
		if check( node ) then
			list[#list+1] = node
		end
		return
	end

	local test = TestBoxPlane( node.plane, mins, maxs, expand )

	if test == 0 then
		self:GetBoxLeafs( list, mins, maxs, expand, check, node.children[1] )
		self:GetBoxLeafs( list, mins, maxs, expand, check, node.children[2] )
	else
		self:GetBoxLeafs( list, mins, maxs, expand, check, node.children[test == -1 and 2 or 1] )
	end

end

function meta:GetAdjacentLeafs( leaf, list, check )

	self:GetBoxLeafs( list, leaf.mins, leaf.maxs, 10, function(l)
		if l == leaf then return false end
		if check and not check(l) then return false end
		return true
	end )

end

function meta:AreLeafsConnected(a, b, check, visited)

	if check and not check(a) then return false end
	if a == b then return true end

	visited = visited or {}
	visited[a] = true

	local connection = false
	local adjacent = {}
	self:GetAdjacentLeafs( a, adjacent, check )
	for _, l in pairs( adjacent ) do
		if l == b then return true end
	end

	for _, l in pairs( adjacent ) do
		if l == a then continue end

		if not visited[l] then
			connection = connection or self:AreLeafsConnected(l, b, check, visited)
		end
	end

	return connection

end

table.Merge( bsp3.GetMetaTable(), meta )

function LoadBSP( filename, path, requested_lumps, callback )

	local data = bsp3.LoadBSP( "maps/" .. filename .. ".bsp", requested_lumps, path )
	if not data then return end

	CreateBrushes(data)
	CreateWindings(data)
	ConvertEntities(data)

	return data

end

_G["LOADED_BSP"] = nil
if _G["LOADED_BSP"] == nil then
	_G["LOADED_BSP"] = LoadBSP( game.GetMap(), nil,
		SERVER and LUMPS_DEFAULT or LUMPS_DEFAULT_CLIENT,
		SERVER and BLOCK_THREAD or function()

		hook.Call( "CurrentBSPReady" )

	end )

	if SERVER then

		print("SERVER FINISHED LOADING BSP")
		print( PrintTable( _G["LOADED_BSP"].entities[1] ) )
		hook.Call( "CurrentBSPReady" )

	end
end

local current_map = _G["LOADED_BSP"]

function GetCurrent()

	return current_map

end