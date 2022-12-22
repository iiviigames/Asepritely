--	SCRIPT:		Export PNG on Save.lua
--	DATE:			February 06, 2021
--	AUTHOR:		iivii		|		@odd_codes
--	WEBSITE:	https://odd.codes
--	GITHUB:		https://github.com/iiviigames/Asepritely
--	DESC:			Saves a png format image of current ase file on a save command.
--	USAGE:		Executes when the script is run. 
--	Set it to a keyboard shortcut like CTRL+ALT+SHIFT+S
--	==========================================================================

--	GLOBALS
--	=========================================================================

--	Make this next line false if you don't want the popup
POPUP = true

--	Sprite
local spr = app.activeSprite

--	Commands
SaveAs = app.command.SaveFileAs
SaveCopy = app.command.SaveFileCopyAs
Save = app.command.SaveFile

--	Naming variables
name = spr.filename
ase = '.ase'
png = '.png'


--	FUNCTIONS
--	=========================================================================

--	Prints item to console.
function p(item)
	local tp = type(item)
	if tp == nil then
		print("nil")
	elseif tp == "table" or tp == "function" then
		print(string.upper(tp)..tostring(item))
	elseif tp == "table" then
		pt(item)
	else
		print(tostring(item))
	end
end

--	Prints the contents of a table to the console
function pt(t)
	for k,v in pairs(t) do
		print(tostring(k)..":	"..tostring(v))
	end
end


--	Gets last occurrence of 'char' in "string"
--[[EXAMPLE
	s='my.string.here.'
	print(findlast(s,"%."))
	print(findlast(s,"e")
]]--
function findlast(str, chr)
    local i=str:match(".*"..chr.."()")
    if i==nil then return nil else return i-1 end
end


--	Gets sprite's name from path
function namestrip()
	local spr = app.activeSprite
	local path = spr.filename
	local i1 = findlast(path, '[/\\]') + 1
	local i2 = findlast(path, '%.') - 1
	local name = path:sub(i1, i2)
	return name
end

--	Gets sprite's path without name
function pathstrip()
	local spr = app.activeSprite
	local path = spr.filename
	local i1 = findlast(path, '[/\\]')
	local name = path:sub(0, i1)
	return name
end

--	MAIN
--	=========================================================================


-- Get name of current sprite and path.
local sprname  = namestrip()
local pathname = pathstrip()
-- If this is blank, then alert the user to save the document first.
if checkname == "" then
	app.alert("Must save the document first before using this script!")
end

-- ASE formatted name
local aseext = sprname..ase
-- PNG formatted name
local copyext = sprname..png
-- PNG Path
local copyfinal = pathname..copyext

-- First, save a copy as a png.
spr:saveCopyAs(copyfinal)
-- Then,  save the file as is.
Save(filename)

--	Output Notice
--	Will not display if POPUP is false
if POPUP then
	app.alert{
		title="Export and Save",
		text={
			"Destination: "..pathname,
			"Saved:       "..aseext,
			"Saved copy:  "..copyext,
		},
		buttons={"Okay!"}
	}
end
