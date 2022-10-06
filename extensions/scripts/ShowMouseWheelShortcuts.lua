---SCRIPT:        ShowMouseWheelShortcuts.lua
---DESCRIPTION:   This is a script that you need to customize to your needs!
---               It's simply a reminder window to show you the modifiers for the
---               mouse wheel shortcuts. I forget them a lot!
---AUTHOR:        iiviigames - @iiviigames
---PACKAGE:       Asepritely
---WEBSITE:       https://iivii.itch.io/asepritely
---VERSION:       1.0.0
---DATE:          June 24, 2022
---UPDATED:       October 06, 2022
---NOTES:         I plan to make this work in a more automatic fashion, but for
---               now, you should just update it to match your functions, as mine are custom.
--------------------------------------



if not app.activeSprite then
  return
end
-- Create the window.
local shortcutwindow = Dialog("Mouse Wheel Shortcuts")

-- Set to true for Debug
SHORTCUTDEBUG = false
-- Debug functions
local function print_any(v)
  local t = type(v)
  local s = ""
  if t == 'table' then
    pt(v)
    return
  elseif t == 'string' or t == 'number' then
    s = v
  elseif t == nil then
    s = 'nil'
  elseif t == 'function' then
    s = tostring(v) .. ' is a function'
  else
    s = v
  end
  print(s)
end
local pa = print_any

--	Stands for "print table"
local function pt(t)
  for k,v in pairs(t) do
    print(tostring(k)..":	"..tostring(v))
  end
end

-- Combines the actions and the modifiers into a label.
local function create_entries(tbl1, tbl2)
  for i=1, #tbl1 do
    local name = tbl1[i]
    local shortcut = tbl2[i]
    shortcutwindow:label{
      label=name,
      text = shortcut
    }
  end
end

-- Window Setup
-- ==========================================

--[[NOTE ON THE ORDER OF THE ENTRIES:
  They need to match EXACTLY, as this is simply an iteration over
  two tables and putting the keys in each one beside each other 
  in the reminder window. Nothing fancier. 
]]--


-- These is the actions that the keyboard shortcuts will perform.
action_names = {
  "Zoom In/Out",
  "Scroll Layers",
  "Scroll Frames",
  "Scroll FG Color",
  "Scroll BG Color",
  "Inc/Dec Brush Size",
  "Scroll Tools",
  "Scroll Same Tools",
}

-- These are the modifiers that are held to cause the actions.
action_shortcuts = {
  "Wheel", -- Zoom
  "Alt + Shift + Wheel", -- Layers
  "Ctrl + Shift + Wheel",-- Frrames
  "Alt + Wheel", -- FG Color
  "Shift + Wheel",-- BG Color
  "Ctrl + Wheel", -- Brush Size
  "Ctrl + Alt + Wheel", -- Tools
  "Ctrl + Alt + Shift + Wheel", -- Tools Group
}

-- Create the window size.
local dim = shortcutwindow.bounds
local scwh = 150
scwh = SHORTCUTDEBUG and scwh + 25 or scwh 
shortcutwindow.bounds = Rectangle(50,50,208,scwh)


-- Add the shortcuts.
create_entries(action_names, action_shortcuts)

shortcutwindow:separator()

--  Add the functionality.
shortcutwindow:button{
  id="quit",
  label = "Exit",
  text="Close Window",
  onclick=function()
    shortcutwindow:close()
  end
}
if SHORTCUTDEBUG then
  shortcutwindow:button{
    id = "debug",
    text="Show Debug",
    label = "Debug",
    onclick = function()
      local s = tostring(shortcutwindow.bounds)
      print("Size of Window: ".. string.sub(s,11,#s-1))
    end
  }
end

shortcutwindow:show{wait=false}
