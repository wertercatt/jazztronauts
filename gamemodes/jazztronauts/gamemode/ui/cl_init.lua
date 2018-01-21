include("dialog/cl_init.lua")
include("radar/cl_init.lua")
include("transition/cl_init.lua")
include("propfeed/cl_init.lua")
include("missions/cl_init.lua")

function GM:HUDPaint()

	self.BaseClass.HUDPaint(self)

	dialog.PaintAll()
	radar.Paint()
	propfeed.Paint()

end