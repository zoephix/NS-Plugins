local PLUGIN = PLUGIN

PLUGIN.name = "Detailed Descriptions"
PLUGIN.author = "Zoephix"
PLUGIN.desc = "Adds the ability to create detailed descriptions, which can be examined."

nut.util.include("cl_plugin.lua")
nut.util.include("sv_plugin.lua")

nut.command.add("charsetdetdesc", {
	onRun = function(client)
		net.Start("nutSetDetailedDescriptions")
			net.WriteEntity(client)
		net.Send(client)
	end
})

nut.command.add("charselfexamine", {
	onRun = function(client)
		local URL = client:getChar():getData("textDetDescDataURL", nil) || "No detailed description found."
		local description = client:getChar():getData("textDetDescData", nil) || "No detailed description found."

		net.Start("nutOpenDetailedDescriptions")
			net.WriteEntity(client)
			net.WriteString(URL)
			net.WriteString(description)
		net.Send(client)
	end
})