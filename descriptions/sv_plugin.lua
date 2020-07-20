util.AddNetworkString( "nutOpenDetailedDescriptions" )
util.AddNetworkString( "nutSetDetailedDescriptions" )
util.AddNetworkString( "nutModifyDetailedDescriptions" )

function PLUGIN:KeyPress(player, key)
	local entity = player:GetEyeTrace().Entity

	if (key == IN_USE and IsValid(entity) and entity:IsPlayer()) then
		if !(player:GetPos():Distance(entity:GetPos()) <= 100) then return end
		local URL = entity:getChar():getData("textDetDescDataURL", nil) || "No detailed description found."
		local description = entity:getChar():getData("textDetDescData", nil) || "No detailed description found."
		
		net.Start("nutOpenDetailedDescriptions")
			net.WriteEntity(entity)
			net.WriteString(URL)
			net.WriteString(description)
		net.Send(player)
	end
end

net.Receive("nutModifyDetailedDescriptions", function()
	local Client = net.ReadEntity()
	local URL = net.ReadString()
	local text = net.ReadString()
	
	for _, v in pairs(player.GetAll()) do
		if (v == Client) then
			v:getChar():setData("textDetDescData", text)
			v:getChar():setData("textDetDescDataURL", URL)
		end
	end
end)