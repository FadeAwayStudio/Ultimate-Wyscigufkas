AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model( "models/props_junk/wood_crate001a.mdl" )

local destroyed = false

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_BREAKABLE_GLASS )
	self:SetHealth(1)
	self:SetPos(self:GetPos() + Vector(0,0,30))
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	phys:Wake()
	end
end
function ENT:Touch( car )
	driver = car:GetDriver()
	if(!destroyed) then
		self:Remove()
		destroyed = true
		print(car:GetDriver())
		driver:PrintMessage(3, "boom")
		print(driver:GetName())
	end
end