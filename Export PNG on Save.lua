--	SCRIPT:		Export PNG on Save.lua
--	DATE:			February 06, 2021
--	AUTHOR:		iivii		|		@odd_codes
--	WEBSITE:	https://odd.codes
--	GITHUB:		https://github.com/iiviigames/Asepritely
--	DESC:			Saves a png format image of current ase file on a save command.
--	USAGE:		Executes when ctrl+s is pressed.
--	==========================================================================

--	GLOBALS
--	=========================================================================
SAVEAS = app.command.SaveFileAs
SAVECOPY = app.command.SaveFileCopyAs
SAVE = app.command.SaveFile

saves = 0

--	FUNCTIONS
--	=========================================================================

-- Prints item to console.
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


--	MAIN
--	=========================================================================

if SAVE then 
	saves = saves + 1
	local t = saves > 1 and " times" or " time"
	p("SAVED FILE "..tostring(saves).. t)
end

app.alert{
	title="TEST",
	--text={"Line 1", "Line 2", ...}, 
	--buttons={"Yes", "No", "Cancel", ...},
	text={"Line 1", "Line 2"}, 
	buttons={"Yes", "No", "Cancel"}
}
