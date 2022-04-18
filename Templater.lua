-- boxulator for Aseprite
-- iiviigames

--[[GOALS
- Create a list that stores data for the user permanently.
- This list is called "templates" and will store the width, height, and color
  space of the desired sprite.
- The list must be stored in a file outside of the program itself.
- The file should be called 

]]

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




-- ============================================================================
-- Functions
-- ============================================================================

---@func  file_exists(file)
---@arg {str} file    location/name of a file that needs to be opened
---@desc  Checks if a given file is on the hard drive.
---@ret  {bln}
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end


-- ============================================================================
-- Dialog Functionality
-- ============================================================================
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
