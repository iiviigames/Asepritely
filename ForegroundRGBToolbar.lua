--	SCRIPT:		Foreground RGB Toolbar.lua
--	DATE:			August 31, 2020
--	AUTHOR:		iivii		|		@odd_codes
--	WEBSITE:	https://odd.codes
--	GITHUB:		https://github.com/iiviigames/Asepritely
--	DESC:			Shows the RGB values of the current foreground color in a 
--						popup window.
--	USAGE:		Simply press the "GO" button to view the RGB values of your 
--						foreground color.
--	==========================================================================
if not app.activeSprite then
	return
end

--	GLOBALS
--	==========================================================================
	--	Initialize the Toolbar Popup
	local tool = Dialog("Palette Toolbar")
	--	Get the size of the Toolbar
	local size = tool.bounds
	--	Set the size of the Toolbar
	--	w,h = 298, 155
	w,h = 310, 200
	tool.bounds = Rectangle(size.x+600,size.y,w,h)

	--	Get the current Sprite being edited in Aseprite
	local spr = app.activeSprite
	--	Alert if no active sprite has been found

	--	Get the current Palette being used in Aseprite
	local pal = spr.palettes[1]


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


--	APP FUNCTIONS
--	==========================================================================

	--	Retrieves the active foreground color
	function getForeColor()
		return app.fgColor
	end

	--	Retrieves the RGB values that make up the foreground color.
	function getForeRGB()
		--	Store RGB values
		local color = getForeColor()
		local r = color.red
		local g = color.green
		local b = color.blue
		--	Return the individual components
		return r,g,b
	end

	--	Modifies existing toolbar RGB values with new ones
	function setBoxRGB()
		local r,g,b = getForeRGB()
		tool:modify{id="red", text=r}
		tool:modify{id="green", text=g}
		tool:modify{id="blue", text=b}
	end


--	DEBUG FUNCTIONS
--	==========================================================================	
	--	(Simply add functions to the the dbg table if you want to extend its use.)
	--	(Called only if dbg.run is true)
	local dbg = {
		run = true
	}

	--	Executes any of the dbg functions that you pass to it, with any bad keys
	--	being ignored.
	--	NOTE: THIS IS CALLED AT THE BOTTOM IN THE MAIN AREA
	--	dbg.run MUST BE TRUE or this won't execute.
	--	EX:		dbg:show('bounds', 'balette') 
	--		(in the above example, 'balette' would fail to run, as it's mispelled!)
	function dbg:show(...)
		--	Make sure the dbg.run is true, or this won't do anything
		if self.run == false then return end
		
		--	string arguments
		local a = {...}

		--	Performs the debug function after verification
		local function call(tab,fnc)
			fnc(tab)
			return
		end
		
		--	Loop through all arguments and perform functions
		for i=1, #a do

			local arg = a[i]
			local func = self[arg]
			local chk = type(func)

			--	Check if the resulting index is a function, and execute.
			if chk == "function" then
				--	func() on its own also works, but it might not depending on
				--	the way you write functions, so use this instead.
				call(self,func)
			end
		end
	end

	--	Print the toolbar boundaries
	function dbg:bounds()
		print("X: "..tostring(size.x))
		print("Y: "..tostring(size.y))
		print("W: "..tostring(size.width))
		print("H: "..tostring(size.height))
	end

	--	Print the palette colors
	function dbg:palette()
		for i=1, #pal-1 do
			local col = pal:getColor(i)
			print(col)
		end
	end


--	INITIALIZE TOOLBAR
--	==========================================================================
	

	--	LABELS/LAYOUT
	--	--------------------------------------------------------------------
		
		--	Create the Color Label
		tool:label{
			id="color_label",
			--	label="Foreground Color",
			label="Currently Selected Color"
		}
		--	Create a Separator
		tool:separator()
		--	Create a New Row
		tool:newrow()


		--	Create the color display box
		tool:color{
			id="current_color",
			label="Foreground Color",
			color=getForeColor()
		}

		--	Create a Separator
		tool:separator()

	--	CREATE RGB DISPLAY
	--	-----------------------------------------------------------------------

		--	Store RGB values
		local r,g,b = getForeRGB()

		--	Red
		tool:label{
			id="red",
			label="R:",
			text=r
		}
		--	Green
		tool:label{
			id="green",
			label="G:",
			text=g
		}
		--	Blue
		tool:label{
			id="blue",
			label="B:",
			text=b
		}

		--	Create a Separator
		tool:separator()

	--	BUTTONS
	--	-------------------------------------------------------------------------
		--	Create the button for getting current active color
		tool:button{
			id="get_current_color",
			label="Get Foreground Color",
			text="GO",
			onclick=function()
			
				--	Store and set color of foreground
				local c = getForeColor()
				tool:modify{
					id="current_color",
					color=c
				}

				--	Update the current RGB values with the new data
				local r,g,b=getForeRGB()
				tool:modify{id="red", text=r}
				tool:modify{id="green", text=g}
				tool:modify{id="blue", text=b}

			end
		}

		--	Create the quit button
		tool:button{
			text="Close",
			onclick=function()
				tool:close()
			end
		}

--	MAIN
--	==========================================================================
if not spr then
	-- return app.alert("Error! No sprite is being edited!")
	return 
	--	Shows the Window Toolbar
	-- tool:show{wait=false}

	--	Performs any dbg calls
	-- dbg:show('bounds','bad')
end
	--	Shows the Window Toolbar
	tool:show{wait=false}

	--	Performs any dbg calls
	dbg:show('bounds','bad')
