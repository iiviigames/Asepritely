-- boxulator for Aseprite
-- iiviigames

--[[GOALS
- [x] Check that a file of a certain type exists. This is the templates file.
- [x] Check the  templates file has an identifier.
- [ ] Create a list that stores data for the user permanently.
[ ] This list is called "templates" and will store the width, height, and color
    space of the desired sprite.
[ ] The list must be stored in a file outside of the program itself.
[ ] The file should be called 'templates.json'.
[ ] The user should have the option to use a custom file with a different exten.
[ ] 
]]


-- ============================================================================
-- Requirements
-- ============================================================================
require('util')

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

---@desc  Ensures the appropriate ID is on the templates first line.
function check_identifier(file)
  local f = io.open(file,'r')
  local v = f:read()
  print(v)
  f:close()
  return v == IDENTIFIER 
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
    lines[#lines + 1] = line
    -- Debug logging
    if dbg then
      print("Location in table: " .. #lines + i)
      print("Line Number:       " .. line)
    end
  end
  
  return lines
end

---@desc
function file_to_table(file, strip)
  strip = type(strip) == 'boolean' and false or true
  
  local t = {}
  local f  = io.open(file,"r") 
  
  local line = f:read()
  
  -- Keep reading the file while you can.
  while line  do
    if line ~= IDENTIFIER then
      -- line=line:gsub("%s+", "")
      -- line=line:gsub("-", "")
      
      -- Strip whitespace.
      if strip then
        line = trim(line)
      end
      -- Strip out '-' chrs.
      line=stripchr(line, '-')
      -- Strip out ':'' chrs.
      line=stripchr(line, ':')
      
      -- Add the content into the table
      push(t, line)
    end
    line = f:read()
  end

  -- Close File.
  f:close()
  -- Return the file as a table.
  return t
end



---@desc  Creates a custom templates file.
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
end


function file_to_table2(file, strip)
  strip = type(strip) == 'boolean' and true or false
  
  local t = {}
  local f  = io.open(file,"r") 
  
  local line = f:read()
  local cnt = -1
  local current = {}
  -- Keep reading the file while you can.
  while line  do
    
    if line ~= IDENTIFIER then
      -- Strip whitespace.
      line=line:gsub("%s+", "")
      -- line = stripws(line)
      -- Strip out '-' chrs.
      line=line:gsub("-", "")
      -- line=stripchr(line, '-')
      
      -- Add the content into the table
      push(current, line)

      -- when current has a length of 3, we add it to "t" and make a new table.
      if #current == 2 then
        push(t, current)
        current = {}
      end
    end
    line = f:read()
  end

  -- Close File.
  f:close()
  -- Return the file as a table.
  return t
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

function tests(n,...)
  
  -- Testing values
  word = 'deoxyribonucleic'
  c = subchr(word, 5)
  syls = {substr(word, 1,2),substr(word, 3, 4),subchr(word,5)}
  tbl = {'cat', 68, p = function(s) print(s) end, 'hundred nips goken',syls}
  
  -- Total # of tests.
  testcount = 6
  
  local a = {...}
  local l = #a
  local tsts={n}
  
  -- Add to the tests if the arg is a number less than the max # of tests
  if l > 0 then
    for i=1, #a do
      local e = a[i]
      if type(e) == 'number' then
        if e > 0 and e <= testcount then
          push(tsts, e)
        end
      end
    end
  end
  
  
  -- Test Titles
  local titles = {
    "File Existence Check",
    "Identifier in First Line",
    "Whole File to Table",
    "Skip Line 1 , File to Table",
    "Skip Line 1 , File to Table of Tables",
    "Utility Tests",
  }
  
  -- loop through the test table and perform the requested ones.
  for i=1, #tsts do
    
    local t = tsts[i]
    
    -- Identrify the test number
    print(spad("TEST #"..tostr(t), "left", ' ', 40))
    print(spad(titles[i], "left", ' ', 40))
    print(srpt('=',80))
    
    if t == 1 then
      -- File Exists Test
      print(tostr(file_exists(DEFAULT_FILE)))
    elseif t == 2 then
      -- Identifier check test.
      local r = check_identifier(DEFAULT_FILE)
      local p = r and "Identifier found!" or "Unable to find proper identifier"
      print(p)
    elseif t == 3 then 
      -- Read Array TEST      
      a = read_array(DEFAULT_FILE)
      pt(a)
      print(#a)
    elseif t == 4 then 
      -- File to Table
      a = file_to_table(DEFAULT_FILE)
      for i=1, #a do
        print(a[i])
      end
    elseif t == 5 then 
      -- File to Table 2
      a = file_to_table2(DEFAULT_FILE)
      for i=1, #a do
        pt(a[i])
      end
    elseif t== 6 then
      -- Utitlity Tests
      pt(syls)
      ptp(tbl)
      z=spad(word, #word/2, '-', #word)
      print(z)
    else
      print('no test')
    end
    
    -- Create a separator for the next test
    if i == #tsts then
      print(spad('\n', 'left', ' ', 40))
      print(spad("TESTS COMPLETE!", 'left', ' ', 40))
      
    else
      -- print(srpt('-',80))
      print('\n')
    end
    
  end
  
end
  
tests(4)
