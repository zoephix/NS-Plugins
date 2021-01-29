PLUGIN.name = "Persistence"
PLUGIN.desc = "Saves persisted props and entities through restarts."
PLUGIN.author = "Zoephix"

if ( SERVER ) then
	function PLUGIN:SaveData()
		local data = {}

		for k, v in pairs(ents.GetAll()) do
			if (v:GetPersistent()) then
				local UID = #data + 1

				data[UID] = {
					pos = v:GetPos(),
					angles = v:GetAngles(),
					model = v:GetModel(),
					entity = v:GetClass(),
					skin = v:GetSkin(),
					color = v:GetColor(),
					material = v:GetMaterial()
				}

				-- save the motion state if the entity has one
				if (IsValid(v:GetPhysicsObject())) then
					data[UID].motion = v:GetPhysicsObject():IsMotionEnabled()
				end
			end
		end

		self:setData(data)
	end

	function PLUGIN:LoadData()
		for k, v in pairs(self:getData() or {}) do
			-- to make sure we don't duplicate the entities
			for _, entity in pairs(ents.FindInSphere(v.pos, 5)) do
				if (entity:GetClass() == v.entity and entity:GetModel() == v.model) then
					return
				end
			end

			-- spawn the entity
			local entity = ents.Create(v.entity)
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:SetModel(v.model)
			entity:SetSkin(v.skin)
			entity:SetColor(v.color)
			entity:SetMaterial(v.material)
			entity:Spawn()
			entity:Activate()
			entity:SetPersistent(true)

			if (IsValid(entity:GetPhysicsObject())) then
				entity:GetPhysicsObject():EnableMotion(v.motion)
			end
		end
	end
end
