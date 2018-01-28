AddCSLuaFile()

ENT.Type = "anim"
ENT.Model = Model( "models/props_junk/wood_crate001a.mdl" )



function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_BREAKABLE_GLASS )
	self:SetHealth(1)
	self:SetPos(self:GetPos() + Vector(0,0,30))
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	phys:Wake()
	end
end

local destroyed = false

function ENT:StartTouch( car )
	driver = car:GetDriver()
	driver:Give("far_oneshot", true)
	destroyed = true
	driver:PrintMessage(3, "boom")
	self:Remove()
end