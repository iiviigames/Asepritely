tostr = tostring
ts = tostring
floor = math.floor
ceil = math.ceil
tonum = tonumber
--	HELPER FUNCTIONS
--	==========================================================================


--	Shows the type of an item
function st(v)

  print(type(v))
end

-- Show type recursively for tables.
function str(v)
  if type(v) == 'table' then
    for k, v in pairs(v) do
      st(v)
      str(v)
    end
  else
    st(v)
  end
end

-- Ensures items are of a set of types
-- 't' should be a list of strings containing valid types
-- EX: 'table','function'
-- It returns a function that you use to check the values you want.
function enforce_type(...)
  local types = {...}
  local checked = {}

  local ensure = function (types, ...)
    types = types
    local c = 0
    local args = {...}
    local checked = {}
    -- print(unpack("#"))
    for i = 1, #args do
      print(type(args[j]))
      for k, v in next, types do
        print(k)
        print("Type of Item: "..type(v))
        -- local arg = args[j]
        -- local t  = type(arg)
        print(t)
        -- print(arg)
        if v == type(args[j]) then
          c = c + 1
          checked[c] = arg
        end
      end
    end
    if #checked == 0 then
      print("No valid types provided")
      return false
    elseif #checked > 0 and #checked < args then
      print("Some args were valid, but not all.")
      return false
    else
      print("All args were valid!")
      return true
    end
  end

  return ensure
end

--	Prints the contents of a table to the console
--	Stands for "print table"
function pt(t)
  for k, v in pairs(t) do
    print(tostring(k)..":	"..tostring(v))
  end
end


---@func  ptp(t, ...)
---@arg   {str}  t  Argument Description
---@arg   {...}  types  any number of comma delineated strings, or, a table of strings.
---@desc  Prints items in a table if they match the given type(s)
---       The arguments can be a table of strings, or just strings separated by commas.
---@ret   {nil}  Prints, doesn't return anything
---@exam  EX:
---       t = {cat='cat',dog='dog',38,true,'false'={}}
---       ptp(t, 'string') OR...
---       ptp(t, 'table','boolean')
function ptp(t, ...)
  local types = {...}
  local checked = {}
  local valid = {'table', 'number', 'string', 'function', 'userdata', 'nil', 'boolean'}
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
    for k, v in pairs(t) do
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
  for k, v in pairs(t) do
    if type(k) == 'table' then
      print(tostring(k))
      pt(v)
    else
      print(tostring(k)..": "..tostring(v))
    end
  end
end


---@func  string.zfill(str)
---@arg   {str}  str  source string to be altered
---@desc  Takes a string, and pads it with zeroes on the front up to the desired length.
---@ret   {str}  Edited string.
-- Returns the string padded with zeroes until the length is len.
function string.zfill(str, len)
  return str:lpad('0', len)
end


---@func  spad(str, place, chr, n)
---@arg   {str} str    string to modify
---@arg   {spc} can be: "left" "right" or a numerical value in the range of the string's length
---@arg   {str}  chr    character to use for padding
---@arg   {num}  n      number of times to use the character
---@desc  Pads a string with a given character in any location.
---       This can be the start, end, or anywhere in between.
---@ret   {str} Combined string
function spad(str, place, chr, n)
  local p
  if place == "right" then
    p = #str
  elseif place == 'left' then
    p = 0
  else
    if type(place) == 'number' then
      local n = math.floor(place)
      assert(n > 0 and n <= #str, "Must use a value within range of string length!")
      p = n
    end
  end


  local sc = str
  local one, two, three
  -- The first part of the string (beginning)
  one = substr(sc, 1, p)
  -- Get a string with the character repeated n times
  -- The second part of the string (middle)
  two = srpt(chr, n)
  -- The third part of the string (end)
  three = substr(sc, p + 1, #str)

  -- Combine them and return.
  return one .. two .. three
end

---@func  subchr(s, n)
---@desc  Gets a single character from a string
function subchr(s, n)
  local s = tostr(s)
  assert(n > 0 and n < #s, "index out of range of string "..s)
  return string.sub(s, n, n)
end


---@func  substr(s, f, l)
---@desc  Gets a range of characters from a string
function substr(s, f, l)
  f = type(f) == 'number' and f or nil
  l = type(l) == 'number' and l or f
  assert(f ~= nil and l ~= nil, "must provide a numerical value to substr")
  local s = tostring(s)
  return string.sub(s, f, l)
end



---@func  ptr(t)
---@arg   {tbl}   t   	table
---@arg   {num}   spc		number of spaces to add to the front of an item
---@desc  Prints tables recursively.
---				Use this if your table contains many tables of its own.
---				Infinite looping is a potential, be careful
function ptrw(t, spc)
  local ws = ''
  spc = type(spc) == 'number' and spc or 0
  ws = srpt(' ', spc)
  for k, v in pairs(t) do
    if type(k) == 'table' then
      print(ws.."TABLE: "..tostring(k))
      spc = spc + 1
      ptr(v, spc)
      spc = spc - 1
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
function srpt(c, n)
  local r = ""
  n = type(n) == 'number' and n or 1
  for i = 1, n do
    r = r .. tostring(c)
  end
  return r
end

-- Removes a given substring from a string
function stripchr(s, c)
  return s:gsub(c, "")
end

-- Removes some whitespace from a string
function stripws(s)
  return s:gsub("%s*", "")
end

-- Removes all whitespace from a string
function trim(s)
  return s:match( "^%s*(.-)%s*$" )
end

-- Reads a file into a lua table, line by line.
function read_array(file)
  local arr = {}
  local handle = assert( io.open(file, "r") )
  local value = handle:read()
  while value do
    table.insert( arr, value )
    value = handle:read()
  end
  handle:close()
  return arr
end

-- Nil Operation
function noop() return end
--	UTILITY FUNCTIONS
--	==========================================================================

---@func	newLayer(name)
---@arg 	{str}	name		name of the layer to create
---@desc	Creates a new layer
function newLayer(passedname)
  return app.command.newLayer({
    name = passedname,
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
  for i = 1, len do
    local cur = app.site
    names[i] = cur.layer.stackIndex
  end
  return names
end



--	CREATE THE DIALOG
--	==========================================================================
tostr = tostring
floor = math.floor
ceil = math.ceil
tonum = tonumber
--	HELPER FUNCTIONS
--	==========================================================================
mypi = 3.14159265359

-- Gets the type of an item
function gto(v, noprint)
  noprint = type(noprint) == 'boolean' and noprint or true
  if not noprint then
    print(type(v))

  end
  return type(v)
end

-- Show type recursively for tables.
function str(v)
  if type(v) == 'table' then
    for k, v in pairs(v) do
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
  for k, v in pairs(t) do
    print(tostring(k)..":	"..tostring(v))
  end
end

-- Prints items in a table if they are of a type
function ptp(t, ...)
  local types = {...}
  local checked = {}
  local valid = {'table', 'number', 'string', 'function', 'userdata', 'nil', 'boolean'}
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
    for k, v in pairs(t) do
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
  for k, v in pairs(t) do
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


---@func  spad(str, place, chr, n)
---@arg   {str} str    string to modify
---@arg   {spc} can be: "left" "right" or a numerical value in the range of the string's length
---@arg   {str}  chr    character to use for padding
---@arg   {num}  n      number of times to use the character
---@desc  Pads a string with a given character in any location.
---       This can be the start, end, or anywhere in between.
---@ret   {str} Combined string
function spad(str, place, chr, n)
  local p
  if place == "right" then
    p = #str
  elseif place == 'left' then
    p = 0
  else
    if type(place) == 'number' then
      local n = math.floor(place)
      assert(n > 0 and n <= #str, "Must use a value within range of string length!")
      p = n
    end
  end


  local sc = str
  local one, two, three
  -- The first part of the string (beginning)
  one = substr(sc, 1, p)
  -- Get a string with the character repeated n times
  -- The second part of the string (middle)
  two = srpt(chr, n)
  -- The third part of the string (end)
  three = substr(sc, p + 1, #str)

  -- Combine them and return.
  return one .. two .. three
end

---@func  subchr(s, n)
---@desc  Gets a single character from a string
function subchr(s, n)
  local s = tostr(s)
  assert(n > 0 and n < #s, "index out of range of string "..s)
  return string.sub(s, n, n)
end


---@func  substr(s, f, l)
---@desc  Gets a range of characters from a string
function substr(s, f, l)
  f = type(f) == 'number' and f or nil
  l = type(l) == 'number' and l or f
  assert(f ~= nil and l ~= nil, "must provide a numerical value to substr")
  local s = tostring(s)
  return string.sub(s, f, l)
end



---@func  ptr(t)
---@arg   {tbl}   t   	table
---@arg   {num}   spc		number of spaces to add to the front of an item
---@desc  Prints tables recursively.
---				Use this if your table contains many tables of its own.
---				Infinite looping is a potential, be careful
function ptrw(t, spc)
  local ws = ''
  spc = type(spc) == 'number' and spc or 0
  ws = srpt(' ', spc)
  for k, v in pairs(t) do
    if type(k) == 'table' then
      print(ws.."TABLE: "..tostring(k))
      spc = spc + 1
      ptr(v, spc)
      spc = spc - 1
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
function srpt(c, n)
  local r = ""
  n = type(n) == 'number' and n or 1
  for i = 1, n do
    r = r .. tostring(c)
  end
  return r
end

---@func	stripchr(s,c)
---@arg 	{str}	s		string to process
---@arg 	{num}	c		substring to remove from string
---@desc  Removes a given substring from a string
---@exam  hexonly = stripchr('0xffaa11','0x')
function stripchr(s, c)
  return s:gsub(c, "")
end

---@func	stripws(s)
---@arg 	{str}	s		string to remove all whitespace from
---@desc  Removes some whitespace from a string
---@exam  clean = stripchr('       cat         sup     ')
--->>>>>  print(clean) -- catsup
function stripws(s)
  return s:gsub("%s*", "")
end

-- Removes all whitespace from a string
function trim(s)
  return s:match( "^%s*(.-)%s*$" )
end

-- Reads a file into a lua table, line by line.
function read_array(file)
  local arr = {}
  local handle = assert( io.open(file, "r") )
  local value = handle:read()
  while value do
    table.insert( arr, value )
    value = handle:read()
  end
  handle:close()
  return arr
end
-- Alias for read_array
file_to_table = read_array


-- No Operation
function noop() return end

--	UTILITY FUNCTIONS
--	==========================================================================

---@func	newLayer(name)
---@arg 	{str}	name		name of the layer to create
---@desc	Creates a new layer
function newLayer(passedname)
  return app.command.newLayer({
    name = passedname,
  })
end

---@func	layer_count()
---@desc	Gets the number of layers in the document
---@ret		{num}
function layer_count()
  return app.activeLayer.stackIndex
end

---@func	layer_name()
---@desc	Gets the names of current layer in the document
---@ret		{str}
-- function layer_name()
--   return app.activeLayer.name
-- end
---@func	layer_names()
---@desc	Gets the names of layers in the document
---@ret		{tbl}
function layer_names()
  local names = {}
  local len = layer_count()

  len = type(len) == 'number' and len or 2
  for i = 1, len do
    local cur = app.site
    names[i] = cur.layer.stackIndex
  end
  return names
end

---@func  findlast(str, chr)
---@desc  Gets the last character index in a string.
function findlast(str, chr)
    local i=str:match(".*"..chr.."()")
    if i==nil then return nil else return i-1 end
end


--	Gets sprite's name from path
function namestrip()
	local spr = app.activeSprite
	local path = spr.filename
	local i1 = findlast(path, '\\') + 1
	local i2 = findlast(path, '%.') - 1
	local name = path:sub(i1, i2)
	return name
end

--	Gets sprite's path without name
function pathstrip()
	local spr = app.activeSprite
	local path = spr.filename
	local i1 = findlast(path, '\\')
	local name = path:sub(0, i1)
	return name
end

  
---@func filename_simple
function filename_simple()
  local sep = app.fs.pathSeparator
  -- local fn = "path" .. sep .. "filename.png"
  -- local fn1 = app.fs.fileName(fn)
  local fn2 = app.fs.fileTitle()
  return fn2
end
--	CREATE THE DIALOG
--	==========================================================================
-- print(trim('cat       '))
-- print(stripchr('0xff0011', '0x'))
-- print(string.gsub("hello world", "(%w+)", "%1 %1"))
-- print(string.gsub("4+5 = $return 4+5$", "%$(.-)%$", function (s)
--            return load(s)()
--          end))
