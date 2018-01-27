--shared.lua
GM.Name = "FadeAway's Ultimate Racing Wyscigufkas"
GM.Author = "barwa & blaster12354"
GM.Email = "N/A"
GM.Website = "N/A"

AddCSLuaFile( "carset.lua" )

include( "carset.lua" )

team.SetUp( 0, "Racers", Color(37, 227, 252) )
team.SetUp( 1, "Spectators", Color(150,150,150) )
team.SetUp( 2, "Lobby", Color(102, 255, 99) )

SetGlobalInt("RoundState", 0)
SetGlobalInt("RoundCountdown", 11)
SetGlobalBool("FreeCars", false)

SetGlobalInt("PlayerAlive", 0)

function GetPlayer(ply)

end

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

--ConVars
local flags = {
	FCVAR_SERVER_CAN_EXECUTE,
	FCVAR_NOTIFY
}

if !ConVarExists("far_laps") then
CreateConVar("far_laps", 3, flags, "Laps in the game.")
end

if !ConVarExists("far_sec_to_start") then
	CreateConVar("far_sec_to_start", 3, flags, "Seconds to start the game")
end

if !ConVarExists("far_lastmanstanding") then
	CreateConVar("far_lastmanstanding", 1, flags, "If true, last person wins.")
end

if !ConVarExists("far_freecars") then
	CreateConVar("far_freecars", 1, flags, "Set all cars to free.")
end

if !ConVarExists("far_winmoney") then
	CreateConVar("far_winmoney", 150, flags, "Money that you got for win")
end

function AddMoney(uply, value)
	for k,v in ipairs(uply) do
		--print("Added "..value.." money to "..v..".")
		v:SetNWInt("far_money", v:GetNWInt("far_money")+value)
		v:SetPData("far_money", v:GetNWInt("far_money"))
		print(v:GetPData("far_money"))
		net.Start("RefHUD")
		net.Send(v)
	end
end