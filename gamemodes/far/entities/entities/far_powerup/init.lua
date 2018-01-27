function ENT:Initialize()

	self:SetModel("models/items/item_item_crate.mdl")
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth(1)
	self:PhysicsInit( SOLID_VPHYSICS )
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	phys:Wake()
	end
end