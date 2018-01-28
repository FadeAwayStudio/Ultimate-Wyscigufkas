--init.lua
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

mapf = "maps/"..game.GetMap()..".lua"
AddCSLuaFile( mapf )
include( mapf )

resource.AddFile("sound/racestart.wav")

--Main Game Settings
local players = player.GetAll()

local readyrequests = 0

local laps = GetConVar("far_laps"):GetInt()
local sectostart = GetConVar("far_sec_to_start"):GetInt()
local winmoney = GetConVar("far_winmoney"):GetInt()

local gpos1 = MAPPOINTS[1]
local gpos2 = MAPPOINTS[2]
local rpos1 = MAPPOINTS[3]
local rpos2 = MAPPOINTS[4]

util.AddNetworkString("CarSelect")
util.AddNetworkString("StartMatch")
util.AddNetworkString("PlyInitialize")
util.AddNetworkString("RefHUD")
util.AddNetworkString("ReadyRequest")
util.AddNetworkString("SendSpawnRequest")
util.AddNetworkString("SendLap")
util.AddNetworkString("SendLapClient")
util.AddNetworkString("RefreshClient")
util.AddNetworkString("ClientMatchRefresh")
util.AddNetworkString("FinalCountdown")
util.AddNetworkString("ColorChange")
util.AddNetworkString("CreateMapFile")
util.AddNetworkString("GrabCash")
util.AddNetworkString("UnReadyRequest")

function GM:PlayerSpawn(ply)
ply:SetModel("models/player/Group01/male_02.mdl")
    net.Start("PlyInitialize")
    net.Send(ply)
end

function GM:PlayerInitialSpawn(ply)
if(ply:GetPData("far_money") != nil) then
    ply:SetPData("far_money", ply:GetPData("far_money"))
    ply:SetNWInt("far_money", tonumber(ply:GetPData("far_money")))
else
    ply:SetPData("far_money", 1000)
    ply:SetNWInt("far_money", 1000)
end
    ply:SetTeam(2)
end

--Main Game Mechanics
local mply = FindMetaTable( "Player" )
function GM:PlayerDeath( vic )

    MakeSpectator( vic )

end
function GM:Think()
    SetGlobalBool("FreeCars", GetConVar("far_freecars"):GetBool())
for k, v in pairs(player.GetAll()) do
    if(v:GetPos():WithinAABox(gpos1, gpos2) && v:GetNWInt("canGoal") == 1 && v:Team() == 0) then
    goaled = v
    SendCLLap(goaled)
    goaled:SetNWInt("canGoal", 0)
    goaled:SetFrags(goaled:Frags() + 1)
    print("Goal Achived!")
    end

    if(v:GetPos():WithinAABox(rpos1, rpos2) && v:GetNWInt("canGoal") == 0) then
    v:SetNWInt("canGoal", 1)
    print("NWInt Reseted")
    end
    if(v:GetPos().z <= KILLTRIGGER_H && KILLTRIGGER && v:Alive()) then
        MakeSpectator(v)
    end
    --v:SetDeaths(v:GetNWInt("far_money"))
end
    if(#player.GetAll() == readyrequests && #player.GetAll() != 0) then
    StartRace()
    end
    
    if(#team.GetPlayers(0) == 0 && GetGlobalInt("RoundState") == 1) then
        for k, v in pairs(player.GetAll()) do
            v:PrintMessage(4, "Nobody won.")
            EndRace()
        end
    end
    if(#team.GetPlayers(0) == 1 && GetGlobalInt("RoundState") == 1 && GetConVar("far_lastmanstanding"):GetBool()) then
            Winner(team.GetPlayers(0)[1])
    end
end

function GM:PlayerDeath(victim, inf, att)
    if(GetGlobalInt("RoundState") == 1) then
        MakeSpectator(victim)
    end
    att:SetFrags(att:Frags() - 1)
    victim:SetDeaths(victim:Deaths() - 1)
end

function SendCLLap(ply)
    net.Start("SendLap")
    net.WriteString(ply:GetName())
    net.Send(ply)
end

function VectorToColor(Vector)
    return Color(Vector.x * 255, Vector.y * 255, Vector.z * 255, 255)
end

function AlivePlayers()
	local count = 0;
	
	for k, v in pairs( player.GetAll() ) do
		if( v:Alive() && v:Health() > 0 )then
			count = count + 1;
		end
	end
	
	return count;
end

function Winner(ply)
ply:SetNWInt("far_money", ply:GetNWInt("far_money") + winmoney)
ply:SetPData("far_money", ply:GetNWInt("far_money"))
for k,v in pairs(player.GetAll()) do
    v:PrintMessage(4, ply:GetName().." has won the race!")
end
EndRace()
end
function StartRace()
    if(#player.GetAll() > 1) then
    SetGlobalInt("RoundState", 1)
    readyrequests = 0
    for k, v in pairs(player.GetAll()) do
        v:SetPos(SPAWNPOINTS[k])
        v:SetEyeAngles(MAPPLYANGLE)
        v:Freeze(true)
        v:SetTeam(0)
        net.Start("SendSpawnRequest")
        net.Send(v)
        v:SetHealth(1000000)
        v:SetNWInt("canGoal", 0)
    end
    SetGlobalInt("PlayerAlive", AlivePlayers())
timer.Create("ToStart", 1, 11, function()
    SetGlobalInt("RoundCountdown", GetGlobalInt("RoundCountdown") - 1)
    for k, v in pairs(player.GetAll()) do
            v:PrintMessage(4, "The Race will begin in "..GetGlobalInt("RoundCountdown").." seconds.")
            if(GetGlobalInt("RoundCountdown") == 3) then
                net.Start("FinalCountdown")
                net.Send(v)
            end
            if(GetGlobalInt("RoundCountdown") == 0) then
                v:Freeze(false)
                net.Start("ClientMatchRefresh")
                net.Send(v)
            end
    end
end)
else
    player.GetAll()[1]:PrintMessage(3, "There must be at least 2 players.")
end
end

function MakeSpectator(ply)
local plycar = ply:GetVehicle()
ply:ExitVehicle()
plycar:Remove()
ply:KillSilent()
ply:Spawn()
ply:SetTeam(1)
ply:SetFrags(-1)
SetGlobalInt("PlayerAlive", AlivePlayers())
for k,v in pairs(player.GetAll()) do
    v:PrintMessage(3, ply:GetName().." is out of the race!")
end
end

function EndRace()
    SetGlobalInt("RoundState", 0)
    SetGlobalInt("RoundCountdown", 11)
    game.CleanUpMap()
    for k, v in pairs(player.GetAll()) do
        v:KillSilent()
        v:UnSpectate()
        v:Spawn()
        v:SetTeam(2)
        v:SetFrags(0)
        net.Start("RefreshClient")
        net.Send(v)
        v:SetTeam(2)
    end
end

function GM:CanExitVehicle( veh, ply )
	return
end

--Net Receives
net.Receive("CarSelect", function(len, ply)
    local ReadedString = tonumber(net.ReadString())
    print(ReadedString)

    local car = ents.Create("prop_vehicle_jeep")
if ( !IsValid( car ) ) then return end
car:SetModel(CARS[ReadedString].model) 
car:SetKeyValue("vehiclescript", CARS[ReadedString].script)
car:SetColor(VectorToColor(ply:GetNWVector("CarColor")))
car:SetPos( ply:GetPos() )
car:SetAngles(MAPCARANGLE)
car:Spawn()
ply:EnterVehicle(car)
end)

net.Receive("ReadyRequest", function(len, ply)
    if(GetGlobalInt("RoundState") == 0) then
        ply:SetTeam(3)
    readyrequests = readyrequests + 1
        for k, v in pairs(player.GetAll()) do
            v:PrintMessage(3, ply:GetName().." is ready.")
        end
    end
end)

net.Receive("UnReadyRequest", function(len, ply)
    if(GetGlobalInt("RoundState") == 0 && ply:Team() == 3) then
        ply:SetTeam(2)
    readyrequests = readyrequests - 1
        for k, v in pairs(player.GetAll()) do
            v:PrintMessage(3, ply:GetName().." is not ready.")
        end
    end
end)

net.Receive("SendLapClient", function(len, ply)
    for k, v in pairs(player.GetAll()) do
        lapc = net.ReadInt(32)
        print(lapc)
        if(ply:Frags() < GetConVar("far_laps"):GetInt() + 1) then
        v:PrintMessage(3, ply:GetName().." has reached the "..ply:Frags().." lap.")
        else
        Winner(ply)
        end
    end
end)

net.Receive("GrabCash", function(len, ply)
pricecar = net.ReadFloat()
ply:SetNWInt("far_money", ply:GetNWInt("far_money") - pricecar)
ply:SetPData("far_money", ply:GetNWInt("far_money"))
end)

net.Receive("CreateMapFile", function()
    mapi = net.ReadString()
    file.Write("maps/"..game.GetMap()..".lua", mapi)
end)

concommand.Add("far_forcestart", StartRace, nil, "", flags)
concommand.Add("far_forceend", EndRace, nil, "", flags)

concommand.Add("far_ppt", function()
PrintTable(player.GetAll())
end)

net.Receive("ColorChange", function(len, ply)
scolor = net.ReadVector()
ply:SetNWVector("CarColor", scolor)
end)
