---SCRIPT:        p8spritesheet.lua
---DESCRIPTION:   Creates a sdefault spritesheet for Pico-8.
---AUTHOR:        iiviigames - @iiviigames
---PACKAGE:       Asepritely
---WEBSITE:       https://iivii.itch.io/asepritely
---VERSION:       1.0.0
---DATE:          October 06, 2022
---UPDATED:       October 06, 2022
-------------------------------------------------------------------------------
-- 1.0.0 - Initial release
--[[AUTHORS NOTE: Finding Your Own Way
  A WHOLE LOT of non-documented functions are being used here.
  This is a great script to learn from in order to begin to find
  out how to take full advantage of Aseprite's extensibility, 
  even when it hasn't been documented yet.]]--

---INITIALIZE
--=============================================================================
-- Set this to true if you want some debugging data to display.
__p8debug = false



-- Create the canvas for the pico-8 spritesheet.
app.command.newFile{
  ui=false, -- Disables the ui from showing up.
  width=128, -- Size of the spreitesheet.
  height=128
}
-- Get the newly created sprite.
spr = app.activeSprite

-- LOCATE THE PATH TO THE PALETTE 'SecretPico.gpl' 
--[[TEACHABLE MOMENT: Finding the Hidden Path
  
  I like to leave these opportunities for other programmers to
   learn from my mistakes, and so I'm going to describe the way
   I found the best solution to this problem.
  
  This was quite tricky for me to figure out. 
  Yet, it shouldn't have been. It was my own fault.
  
  I started by simply seeing where the setPalette function
    began by running the code and printing the result. I'm on
    Windows, so it was in the program files folder. So, I just
    did this TERRIBLE UGLY THING, to get it working:

    palpath =
      ""..\\..\\..\\Users\\<myname>\\appdata\\Roaming\\Aseprite\\extensions\\Asepritely\\pals\\SecretPico.gpl"

  One should never be hardcoding paths like this.

  So, the app.fs part of the API is new-ish and I hadn't realized
   exactly every function it had. 

  This is why you always RTFD.

  So (without reading the ENTIRE PAGE), I discovered that the 
   a certain function could be hacked a bit and could ultimately
   deliver a far better (but platform specific) result.

  MUCH better code, which looked like this:
  
    local temp = app.fs.tempPath
    local backup = temp:sub(1, temp:find("Local")-1)

  'temp' had given me: 
    
    "C:\Users\<myname>\AppData\Local\Temp\

 
    I was on the right track, but I needed to be in the roaming
    folder. So, with a little shitty regexing, I managed to back
    that path up 

      "C:\Users\<myname>\AppData\"
  
  From there, I was happy enough, and considered it good enough.
  After all, who cares about Mac and Linux users? AMIRITE?
  ...NO, IMRONG.

  I couldn't upload this in good conscience without ensuring it
    would work for all who want it. PICO-8 is available to all,
    and so will my helpful script be.

  I returned to the docs. And wouldn't you know it, 
    by heading to https://www.aseprite.org/api/app_fs and doing
    a full read, (or, simply CTRL + F ) to find the necessary
    string/function:

     app.fs.userConfigPath 
  
  You will find that this takes you JUST WHERE YOU NEED TO GO.

  - WINDOWS:  "C:\Users\<myname>\AppData\Romaing\Aseprite"
  - MAC:      "~/Library/Application Support/Aseprite
  - LINUX:    "~/.config/aseprite"

  If you're planning on making something similar to me, a package
    with many different things inside, you'll find this useful
    in your future.
  I finished by simply appeneding the final bit of text to get
    me to the extensions folder, which contained my package and
    the palette, which this whole thing relies upon.

  I hope this has been of use to someone out there.


  Still curious? More can be found out about this at the link
   below, as well as the feature to set an ENVIRONMENT VARIABLE
   that can be used as a custom location for these files.

  https://www.aseprite.org/docs/preferences-folder/
]] 
--=============================================================================
-- The path to the palette file.
local configpath  = app.fs.userConfigPath
local palpath = configpath .. "\\extensions\\Asepritely\\pals\\SecretPico.gpl"

-- Logging path.
if __p8debug then 
  print(app.fs.userConfigPath )
end

-- Load the pallete
local pal = Palette{ fromFile = palpath }
-- Set the pallete.
spr:setPalette(pal)

-- LAYER INITIALIZATION
--=============================================================================
-- Get the layers table 
-- There will always be one in a new file.
local layers = spr.layers
-- This first layer will server as the background color
-- It will be locked after we make some changes.
local layerbg = layers[1]
-- Change its name.
layerbg.name = "BG"

-- COLOR AND PALETTE SETUP
--=============================================================================
-- Get the active foreground color.
local fgc = app.fgColor
if __p8debug then
   print("The starting fg color was " .. fgc.index)
end

-- Get the first color in the palette, black.
-- This is the default style for PICO-8 carts.
-- Palettes in Aseprite are 0 indexed, unlike tables.
--[[AUTHORS NOTE: ON COLOR INDEXING.
  Without using the argument 'index', aseprite's docs notes this:
    The Color(integer) constructor receives a pixel color and 
    the integer is interpreted depending on the active sprite.
  For further info, see https://www.aseprite.org/api/color#color]]--
local pcfg = Color{ index = 0 }
-- This should NEVER fail, thus this is a useful debug statement.
if pcfg ~= nil then
  if __p8debug then
    print("The active foreground color will be: " .. pcfg.index)
  end
end

-- Set the intended palette index for the active background color.
-- This is white is PICO-8.
local pcbg = Color{ index = 7 }
if pcbg ~= nil then
  if __p8debug then
    print("The active background color will be: " .. pcbg.index)
  end
end


-- Update the foreground/background colors.
app.fgColor = pcfg
app.bgColor = pcbg

-- FILLING THE BACKGROUND LAYER WITH THE BACKGROUND COLOR.
--=============================================================================
-- TODO: Improve this with an app.transaction.

-- Select the whole layer. 
-- This is equivalent to pressing CTRL+A.
app.command.maskAll()
-- https://youtu.be/O4irXQhgMqg?t=20
-- You're missing out if you don't click that link right now.
app.command.fill()
-- Deselect the layer.
app.command.deselectMask()
-- The above manner of doing things could likely be done in a 
-- better way, and I simply did it the first way I could think of.
-- Lock the bg layer.
layerbg.isEditable = false
--[[AUTHORS NOTE: Function Names
  A few functions break the established function naming convention.
  For example, the functions 'app.command' fill / deselectMask can
  be written as Fill or DeselectMask, and they will still run. This
  is NOT TRUE for most things though, and will throw an error. I
  believe it has something to do with the way certain functions are
  currently defined in the API, as many of these are not even 
  documented, and I had to infer their usage from the source .cpp
  files.]]--





-- Create the layer which the sprites will be drawn on.
local sprlayer = app.command.newLayer{name = 'Sprites'}
-- TODO: Draw the white 'x' sprite in the clear tile position.

-- ENABLE THE GRID SO IT LOOKS LIKE THE PICO-8 EDITOR.
--=============================================================================

-- Show the Grid.
app.command.showGrid()

-- Zoom to fit to the screen - this was the HARDEST THING TO FIGURE OUT.!
app.command.zoom{action="in",focus="center"}

-- END OF SCRIPT
--=============================================================================
return

-- BELOW, is the code I am working on to try to get the grid to
-- display without needing the UI showing up, as I did for the
-- new file dialogue. I'll get it though!
--=============================================================================
-- TODO: FIGURE OUT THE GRID SETTINGS WITHOUT DIALOGUE USAGE.
-- local gridrect = Rectangle{0,0,8,8}
-- app.command.gridSettings{false,0,0,32,32,false}
-- app.command.setGridBounds()
-- print(gridrect)
-- app.gridBounds = gridrect
-- local gb = app.gridBound
-- print(gb)
-- app.command.gridSettings{gridrect, 0, 0, 8, 8, true}
-- app.command.tab()
--=============================================================================