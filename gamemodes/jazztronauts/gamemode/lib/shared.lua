include("sh_gc.lua")
include("sh_task.lua")
include("sh_mesh.lua")
include("sh_csent.lua")
include("sh_mathutils.lua")
include("sh_matrix.lua")
include("sh_quat.lua")
include("sh_space.lua")
include("sh_spline.lua")
include("sh_geomutils.lua")
include("sh_rect.lua")
include("sh_frustum.lua")
include("sh_camera.lua")
include("sh_scene.lua")
include("sh_irt.lua")
include("sh_gfx.lua")
include("sh_gradient.lua")
include("sh_download.lua")
include("sh_unlocks.lua")
include("sh_worldcanvas.lua")

include("sh_poly.lua")
include("sh_brush.lua")
include("sh_bsp.lua")
include("sh_csg.lua")
include("sh_tree.lua")
include("sh_aas.lua")
include("sh_flood.lua")
include("sh_snatch.lua")
include("sh_gmad.lua")

if SERVER then AddCSLuaFile("shared.lua") end