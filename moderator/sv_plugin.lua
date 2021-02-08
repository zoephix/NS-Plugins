local PLUGIN = PLUGIN

-- Create the bans table
nut.db.query("CREATE TABLE IF NOT EXISTS nut_bans (_steamID VARCHAR(20), _steamName VARCHAR(32), _adminName VARCHAR(32), _reason text)")

-- Bans someone from the server
function PLUGIN:BanPlayer(steamid, steamName, adminName, time, reason)
	-- TODO

	nut.db.query("INSERT INTO nut_bans (_steamID, _steamName, _adminName, _reason) VALUES("..sql.SQLStr(steamid)..", "..sql.SQLStr(steamName)..", "..sql.SQLStr(adminName)..", "..sql.SQLStr(time)..", "..sql.SQLStr(reason)..")")
end

-- Set the user group after spawning in
function PLUGIN:PlayerInitialSpawn(client)
	client:SetUserGroup(client:getNutData("group", user))
end

local playerMeta = FindMetaTable("Player")

function playerMeta:nutSetUserGroup(group)
	self:SetUserGroup(group)

	self:setNutData("group", group)
end