AddCSLuaFile()

SWEP.PrintName			= "One Shot .357" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			= "barwa & blaster12354" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions		= "Kill!"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"
SWEP.Primary.Automatic = false
SWEP.Primary.Sound = "Weapon_357.Single"
SWEP.Primary.Damage = 10000000000

SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

function SWEP:Initialize()

	self:SetHoldType( "revolver" )

end



function SWEP:PrimaryAttack()
	local eyeang = self.Owner:EyeAngles()
	local vehicle = self.Owner:GetVehicle()
	local bullet = {}	-- Set up the shot
	bullet.Num = 1
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(0,0,0)
	bullet.Tracer = 1
	bullet.Force = self.Primary.Force or ((self.Primary.Damage or 1) * 3)
	bullet.Damage = self.Primary.Damage
	if(SERVER) then
	self.Owner:ExitVehicle()
	end
	bullet.Src = self.Owner:GetShootPos()
	self.Owner:SetEyeAngles(eyeang)
	self.Owner:FireBullets(bullet)
	if(SERVER) then
		self:EmitSound( self.Primary.Sound )
		self.Owner:EnterVehicle(vehicle)
		self:Remove()
	end
	self.Owner:SetEyeAngles(eyeang)
end

function SWEP:SecondaryAttack()
end