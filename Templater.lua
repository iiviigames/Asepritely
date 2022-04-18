-- boxulator for Aseprite
-- iiviigames

--[[GOALS
[ ] Create a list that stores data for the user permanently.
[ ] This list is called "templates" and will store the width, height, and color
    space of the desired sprite.
[ ] The list must be stored in a file outside of the program itself.
[ ] The file should be called 'templates.json'.
[ ] The user should have the option to use a custom file with a different exten.
[ ] 
]]

-- ============================================================================
-- Globals
-- ============================================================================



-- FILE NAMES 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DEFAULT_NAME = "templates"
DEFAULT_EXTENSION = ".yaml"
DEFAULT_COMMENT = "#"
DEFAULT_FILE = DEFAULT_NAME .. DEFAULT_EXTENSION

-- If the custom_file function is used, this flag will be set.
-- When that happens, all future template entries will be set in it.
USE_CUSTOM_FILE = false
CUSTOM_FILE_NAME = ""
-- You cannot use a language that doesn't support comments. Therefore, no json!
CUSTOM_FILE_COMMENT = "" 
CUSTOM_FILE_EXTENSION = ""
CUSTOM_FILE = ""

--[[IDENTIFIER LINE

This is the first line of the templates file, and serves as an identifier.
If this is not present, the file will not be read, and will refuse to work.
It is defined as such, with a lowercase "c" denoting a comment character:

                          [c TEMPLATES c]

So, for the default yaml file it looks like this:

                          [# TEMPLATES #]
                          
You may use a custom file, as described later, but, the language must support 
commenting. Therefore, json is out, and if you don't like this, well, hack the
code yourself and make it more to your taste. I'm not your dad!]]

IDENTIFIER_TEXT = " TEMPLATES "
IDENTIFIER = DEFAULT_COMMENT .. IDENTIFIER_TEXT .. DEFAULT_COMMENT

-- LIST OF TEMPLATES
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
TEMPLATES = {}


-- ============================================================================
-- Functions
-- ============================================================================

---@func  push(t, v)
---@arg   {tbl}   a table
---@arg   {any}   value to place at end of table
---@desc  Adds a value onto the end of a table
function push(t, v)
  assert(type(t) == "table", "Tried to append a value onto a " .. type(t))
  local back = #t + 1
  table.insert(t, back, v)
end


---@func  file_exists(file)
---@arg {str} file    location/name of a file that will be checked
---@desc  Checks if a given file is on the hard drive.
---@ret  {bln}
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end


---@func  read_lines(file, dbg)
---@arg   {str} file    location/name of a file that needs to be read
---@arg   {bln} [dbg]   debug logging (default: false)
---@desc  Parses a local file and returns it as a table.
---@ret  {tbl}  A table w/ a line in each k/v pair OR a blank table if no file.
function read_lines(file, dbg)
  -- Set default values.
  dbg = type(dbg) == 'boolean' and dbg or false
  
  -- Empty table returned if nothing is found.
  if not file_exists(file) then return {} end
  
  -- Table to store the lines of the file
  local lines = {}
  -- Loop through each line in the file.
  for line in io.lines(file) do 
    -- Skip the first line 
    lines[#lines + 1] = line]
    -- Debug logging
    if dbg then
      print("Location in table: " .. #lines + i)
      print("Line Number:       " .. line)
    end
  end
  
  return lines
end


function custom_file(name, ext, comment, dbg)
  -- Custom file flag on.
  USE_CUSTOM_FILE = true
  
  -- Update the global custom values.
  CUSTOM_FILE_NAME = name
  CUSTOM_FILE_EXTENSION = ext
  CUSTOM_FILE_COMMENT = comment
  CUSTOM_FILE = CUSTOM_FILE_NAME .. CUSTOM_FILE_EXTENSION
  
  -- Create a file if none exists by this name
  if not file_exists(CUSTOM_FILE) then
    -- Log to console for debugs.
    if dbg then
      print("Creating a custom file '"..name.. "' and extension '" .. ext .. "'.")
    end
    -- This is the newly created file
    f = io.open(CUSTOM_FILE, "w")
    --  Update the id text.
    IDENTIFIER = CUSTOM_FILE_COMMENT .. IDENTIFIER_TEXT .. CUSTOM_FILE_COMMENT
    -- Create the mandatory identifier line at the top of the file
    f.write(IDENTIFIER)
    -- Returns an empty table
    return {}
end
-- ============================================================================
-- Dialog Functionality
-- ============================================================================
function make_box()  
  local box = Dialog("Template Creator")
  -- Make it big
  local size = box.bounds
  local w,h = 480, 640
  -- Center It
  box.bounds = Rectangle(
    1920/4, 
    52, 
    w/2.5, h/2
  )



  box:number{ 
    id="input",
    label=nil,
    -- text="Entry",
    decimals=0,
    onchange=function () 
      
    end
  }

  box:button{
    id="one",
    text="1",
    onclick = function() 
      -- print(box.data.input)
      box.data.input = 1
      box:modify{
        id='input',
        decimals = box.data.input
       }
    end
  }


  -- Show it
  box:show{wait=false}
end

-- ============================================================================
-- Testing
-- ============================================================================


read_lines("")
