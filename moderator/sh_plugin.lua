local PLUGIN = PLUGIN
PLUGIN.name = "Moderator"
PLUGIN.author = "Cheesenut & Zoephix"
PLUGIN.desc = "Moderation for NutScript."

-- Configuration
PLUGIN.ranks = {
	["user"] = {icon = "icon16/user.png", order = 5},
	["operator"] = {icon = "icon16/wrench.png", order = 4, isModerator = true},
	["admin"] = {icon = "icon16/star.png", order = 3, isAdmin = true},
	["superadmin"] = {icon = "icon16/shield.png", order = 2, isSuperAdmin = true},
	["owner"] = {icon = "icon16/key.png", order = 1, isSuperAdmin = true}
}

nut.util.include("cl_derma.lua")
nut.util.include("sh_commands.lua")
nut.util.include("sv_plugin.lua")

-- Get the player meta table
local playerMeta = FindMetaTable("Player")

-- Function to return whether a player is a moderator
function playerMeta:IsModerator()
	local rank = PLUGIN.ranks[self:GetUserGroup()]

	if (rank and rank.isModerator or rank.isAdmin or rank.isSuperAdmin) then
		return true
	end

	return false
end

-- Function to return whether a player is admin
function playerMeta:IsAdmin()
	local rank = PLUGIN.ranks[self:GetUserGroup()]

	if (rank and rank.isAdmin or rank.isSuperAdmin) then
		return true
	end

	return false
end

-- Function to return whether a player is super admin
function playerMeta:IsSuperAdmin()
	local rank = PLUGIN.ranks[self:GetUserGroup()]

	if (rank and rank.isSuperAdmin) then
		return true
	end

	return false
end

-- Returns if the player is in the specified usergroup
function playerMeta:IsUserGroup(group)
	return self:GetUserGroup() == group
end

-- Function to check if a player is allowed to run a certain command
function PLUGIN:IsAllowed(client, target)
	local clientGroup = client:GetUserGroup()
	
	-- Check if we got passed a group or actual target
	if (isstring(target)) then
		targetGroup = target
	else
		targetGroup = target:GetUserGroup()
	end

	-- Validate both user groups
	if (targetGroup and clientGroup) then
		-- Check if the targets group is higher
		if (self.ranks[targetGroup].order < self.ranks[clientGroup].order) then
			return false
		-- Check if the targets group is the same
		elseif (!isstring(target) and client ~= target and self.ranks[targetGroup].order == self.ranks[clientGroup].order) then
			return false
		end
	end

	return true
end

-- Fetches the user icon
function PLUGIN:GetUserIcon(ply)
	return PLUGIN.ranks[ply:GetUserGroup()].icon
end

-- Creates a menu tab for opening the moderator menu
function PLUGIN:CreateMenuButtons(tabs)
	if (LocalPlayer():IsModerator()) then
		tabs["moderator"] = function(panel)
			if (IsValid(nut.gui.mod)) then
				nut.gui.mod:Remove()
			end

			nut.gui.mod = vgui.Create("nut_Moderator", panel)
		end
	end
end