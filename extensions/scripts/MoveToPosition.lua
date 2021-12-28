--	HELPER FUNCTIONS
--	==========================================================================

--	Prints the contents of a table to the console
--	Stands for "print table"
function pt(t)
	for k,v in pairs(t) do
		print(tostring(k)..":	"..tostring(v))
	end
end

--	Use this if your table contains many tables of its own.
--	Stands for "print table recursively".
function ptr(t)
	for k,v in pairs(t) do
		if type(k) == 'table' then
			print(tostring(k))
			pt(v)
		else
			print(tostring(k)..": "..tostring(v))
		end
	end
end


local window = Dialog("Enter Offset")
local size = window.bounds
local w,h = 130,100
window.bounds = Rectangle(1080/2 - w, size.y+h,w,h)

window:label{
	id="offsets",
	label="Offsets"
}
window:separator()

-- Add entry for x field
window:number{
	id="x_offset",
	label="X Offset: ",
	text="0",
	decimals=0
}

-- Add entry for y field
window:number{
	id="y_offset",
	label="Y Offset: ",
	text="0",
	decimals=0
}

window:newrow()

-- Add GO button
window:button{
	id="go",
	text="Go!",
	onclick=function()
		local data = window.data

		local x = data.x_offset
		local y = data.y_offset
		local xdir = tonumber(x) < 0 and "left" or "right"
		local ydir = tonumber(y) < 0 and "up" or "down"
		-- print(xdir..", "..ydir)
		x = x < 0 and x * -1 or x
		y = y < 0 and y * -1 or y
		-- print(x..", "..y)
		-- print("X: "..tostring(x)..", Y: "..tostring(y))

		--	Shorthand for Scroll
		local scroll = app.command.Scroll
		-- Move to 0,0


		app.command.Scroll{direction=xdir,units="zoomed-pixel", quantity=x}
		app.command.Scroll{direction=ydir,units="zoomed-pixel", quantity=y}

	end
}

--	Create the quit button
window:button{
	text="Cancel",
	onclick=function()
		window:close()
	end
}

-- ++++++++++++++++++++
-- Start Script
window:show{wait=false}
-- print(app.activeSprite.position)
