--	GOAL:	When highlighting a portion of a sprite on a given layer, create a shortcut that will copy the contents of that layer onto a new one.

--	FUNCTIONALITY
--[[https://www.aseprite.org/docs/selecting/
	-	Should be able to do the described goal.
	- Should also implement a way to "cut and paste" that part of the layer onto a new one.
	-	This already exists in a fashion, as you can copy a selection to a new sprite.
--]]

--[[TODO:
			1. https://github.com/aseprite/aseprite/blob/main/src/app/commands/cmd_new_layer.cpp
				- This has all the parameters when creating a new layer.
				- Check ~ Line 55

			2.	https://github.com/Windower/Lua/blob/dev/addons/libs/strings.lua
				- Implement utility functions for strings.
				- Check Lines 198 - 205
--]]
if not app.activeSprite then
	return
end

USESLIDER = false
USEDROPDOWN = true
CUTCONTENT = false
SELECTLOC = 'Above'
CLOSECHK = false

-- Get active layer
local layer = app.activeLayer
-- Get layer data
local data = layer.data
-- Get active sprite
local spr = app.activeSprite

--	HELPER FUNCTIONS
--	==========================================================================
	

	--	Shows the type of an item
	function st(v)

		print(type(v))
	end

	function str(v)
		if type(v) == 'table' then
			for k,v in pairs(v) do
				st(v)
				str(v)
			end
		else
			st(v)
		end
	end

	--	Prints the contents of a table to the console
	--	Stands for "print table"
	function pt(t)
		for k,v in pairs(t) do
			print(tostring(k)..":	"..tostring(v))
		end
	end

	-- Prints items in a table if they are of a type
	function ptp(t,...)
		local types = {...}
		local checked = {}
		local valid = {'table','number','string','function','userdata','nil','boolean'}
		for _, okay in ipairs(valid) do
			for i, name in ipairs(types) do
				local l = #checked + 1
				checked[l] = okay == name and name or nil
			end
		end

		if #checked == 0 then
			print("No valid types provided")
			return
		else
			for k,v in pairs(t) do
				for _, name in ipairs(checked) do
					local tp = type(v)
					if tp == name then
						print(tostring(k).." is a valid type of "..tp..".")
						print("Its value is: "..tostring(v)..'\n')
						print('')
					end
				end
			end
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
	-- Returns the string padded with zeroes until the length is len.
	function string.zfill(str, len)
		return str:lpad('0', len)
	end

	---@func  ptr(t)
	---@arg   {tbl}   t   	table
	---@arg   {num}   spc		number of spaces to add to the front of an item
	---@desc  Prints tables recursively.
	---				Use this if your table contains many tables of its own.
	---				Infinite looping is a potential, be careful
	function ptrw(t,spc)
		local ws = ''
		spc = type(spc) == 'number' and spc or 0
		ws = srpt(' ', spc)
		for k,v in pairs(t) do
			if type(k) == 'table' then
				print(ws.."TABLE: "..tostring(k))
				spc=spc+1
				ptr(v,spc)
				spc=spc-1
			else
				print(ws..tostring(k)..": "..tostring(v))
			end
		end
	end
	
	---@func	srpt(c, n)
	---@arg 	{str}	c		character or string
	---@arg 	{num}	n		number of repetitions
	---@desc	Creates a string of 'n' length made up of only 'c' characters
	---@exam	local star10 = srpt('*', 10) -- "**********"
	function srpt(c,n)
		local r = ""
		n = type(n) == 'number' and n or 1
		for i = 1, n do
			r = r .. tostring(c)
		end
		return r
	end


--	LAME FUNCTIONS
--	==========================================================================
	---@func	HistoryTest()
	---@desc	Can we get Frude Dude to the auditorium?
	function HistoryTest()
		-- Time circuits must be haywire...
		local ___RUFUS = not app.activeSprite 
		if ___RUFUS then
			app.alert("Dude, Missy...")
			app.loadfile("missy.gif")
		else
			TelephoneBoothTimeMachine()
		end
	end


	---@func	HistoryTest()
	---@desc	Bill and Ted's final showdown.
	function TelephoneBoothTimeMachine()
		return
	end

	function print_test()
		if type(layer) == 'table' then
			for k,v in pairs(popup) do
				if type(v)  == 'table' then 
					print("Inner table @ "..tostring(k))
					pt(v)
					print("=======================\n")
				else
					print(tostring(k)..": "..tostring(v))
				end
			end
		else
			local pre  = "TYPE:"
			local len = #pre
			local spc = srpt(" ", len)
			local mid  = type(v).." | "
			local com = pre..spc..mid
			local post = tostring(k)..": "..tostring(v)
			local final = com..post
			print(final)
		end
	end


--	UTILITY FUNCTIONS
--	==========================================================================

	---@func	newLayer(name)
	---@arg 	{str}	name		name of the layer to create
	---@desc	Creates a new layer
	function newLayer(passedname)
		return app.command.newLayer({
			name=passedname,
		})
	end

	---@func	layer_count()
	---@desc	Gets the number of layers in the document
	---@ret		{num}
	function layer_count()
		return app.activeLayer.stackIndex
	end


	---@func	layer_names()
	---@desc	Gets the names of layers in the document
	---@ret		{tbl}
	function layer_names()
		local names = {}
		local len = layer_count()

		len = type(len) == 'number' and len or 2
		for i=1, len do
			local cur = app.site
			names[i] = cur.layer.stackIndex
		end
		return names
	end



--	CREATE THE DIALOG
--	==========================================================================


	popup = Dialog("Selection to Layer")
	
	local size = popup.bounds
	local w,h = 210,100
	-- popup.bounds = Rectangle(1080/2 - w, size.y+h,w+h-h/2,h)
	popup.bounds = Rectangle(50, 50,w+h-h/2,h)
	
	popup:entry{
		id="newname",
		label="New Layer:",
		text="Layer",
		focus=true
	}



	-- Create a slider
	if USESLIDER then
		popup:slider{
			id="placement",
			label="Location",

		}
	end

	-- Create a Dropdown
	if USEDROPDOWN then
		-- CHANGING
		--[[local layercount = layer_count()
		popup:combobox{
			id = "placement",
			label = "Layer Position",
			option = "Above",
			options = layer_names(),
			onchange = function() popup.id.option = popup.combobox.active end
		}]]--
		popup:combobox{
			id='placement',
			label='Layer Location',
			option='Above',
			options={'Above','Below'},
			onchange = function()
				-- SELECTLOC = option == 'Above'
				SELECTLOC = popup.data.placement == 'Above'
				app.alert(SELECTLOC)
				-- app.alert(popup.data.placement == 'Above' and 'Should be Above' or 'Should be Below')
			end
		}
	end


	-- Make the Separator
	popup:separator()

	-- Make the layer go
	popup:button{
		id="creator",
		label="Selector",
		text="Layer from Selection",
		focus=false,
		onclick=function()
			-- newLayer(popup.creator.text)
			-- app.command.TogglePreview()
			-- pt(popup.data)
		end
	}		
	
	-- Make the action destructive 
	popup:check{
		id="cutter",
		label="Cut Selection",
		text="Remove selection from current layer.",
		selected=false,
		onclick=function()
			-- CUTCONTENT = CUTCONTENT == false and true or false
			CUTCONTENT = not CUTCONTENT 
		end
	}
	
	-- Close the window on go
	popup:check{
		id="closeongo",
		label="Close",
		text="Close window after 'GO!'",
		selected=false,
		onclick=function()
			-- CUTCONTENT = CUTCONTENT == false and true or false
			CLOSECHK = not CLOSECHK 
		end
	}

	popup:newrow()
	
	
	-- Make the magic happen.
	popup:button{
		id="go",
		label="Make Layer",
		text="GO!",
		focus=false,
		onclick=function()
			-- TODO: Try to get this in app.transaction
			
			-- Check if the selection should be cut or copied.
			-- local command = self.cutter.selected and 
			local command = 
				CUTCONTENT and
				app.command.Cut or
				app.command.Copy
				
			-- Perform the action.
			command()
			
			-- Debuggery
			-- app.alert(CUTCONTENT == app.command.Copy and "Cutting" or "Copying" )
			-- app.command.NewLayer({viacopy=true})	
			
			-- Position of the layer relative to current.
			pt(popup.data)
			-- app.command.NewLayer({before=SELECTLOC == popup.data.placement})	
			app.command.NewLayer({before=not SELECTLOC})	
			-- Lay it down.
			app.command.Paste()
			-- Set the name.
			app.activeLayer.name = popup.data.newname
			
			
			-- Close the window if the checkbox is ticked.
			if CLOSECHK then
				popup:close()
			end
			
			--[[Make the new layer completely copied.
				app.command.NewLayer{
					name = popup.data.newname,
					group = false,
					reference = false,
					ask = false, -- User can enter name here.
					fromFile = false,
					fromClipboard = true,
					viaCut = CUTCONTENT,
					viaCopy = not CUTCONTENT,
					top = false,
					before = SELECTLOC == 'Above'
				}]]--

		end
	}



	--	Create the quit button
	popup:button{
		text="Cancel",
		onclick=function()
			popup:close()
		end
	}



-- THE SHOW MUST GO ON!
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	popup:show{wait=false}



--	WYLD STALYNS
--	==========================================================================
-- San Dimas High School Football Rules!
-- HistoryTest()
