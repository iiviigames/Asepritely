
USEPOPUPS = false

function initialize() 
	-- Initialize Plugin
	print("Asepritely is running!")

	-- Use plugin.preferences as a table that stores data betweeen sessions
	if plugin.preferences.count == nil then
		plugin.preferences.count = 0
	end

	-- Create a new command
	plugin:newCommand({
		id="AsepritelyControl",
		title="Asepritely Control Center",
		group="cel_popup_properties",
		onclick=function()
			plugin.preferences.count = plugin.preferences.count+1
		end,
		onenabled=function()
			USEPOPUPS = not USEPOPUPS
			if USEPOPUPS then
				app.alert("Popups enabled.")
			end
		end
	})
end

function exit(plugin)
	print("Asepritely is shutting down!")
	print("AsepritelyControl was called a total of "..plugin.preferences.count.." times.")
end