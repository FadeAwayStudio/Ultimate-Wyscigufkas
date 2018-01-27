--cl_init.lua
AddCSLuaFile( "carset.lua" )

include( "carset.lua" )

include( "shared.lua" )
--GOAL Pos: -6405.417480 - -4860.019043
net.Receive("PlyInitialize", function()
	print("LocalPlayer Succefully Initialized.")
	lply = LocalPlayer()
end)

surface.CreateFont( "GMFont", {
	font = "Arial",
	extended = false,
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
} )

surface.CreateFont( "LapFont", {
	font = "Arial",
	extended = false,
	size = 70,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
} )


surface.CreateFont( "PlyName", {
	font = "Impact",
	extended = true,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
} )
--Main Game Variables
local lap = 0
---------------------
local selectedcar = "Citroen C1"
local isReady = false;
local selectedcarent = "4"

function Menu()
--Main Frame
local MenuFrame = vgui.Create( "DFrame" )
MenuFrame:SetPos( ScrW()/3, ScrH()/3 )
MenuFrame:SetSize( 500, 350 ) 
MenuFrame:SetTitle( "FadeAway's Ultimate Racing Wyścigufkas Menu" )
MenuFrame:SetVisible( true )
MenuFrame:SetDraggable( false )
MenuFrame:ShowCloseButton( true )
MenuFrame:MakePopup()

local sheet = vgui.Create( "DPropertySheet", MenuFrame )
sheet:Dock( FILL )

--Game Panels
local CarSelectionPanel = vgui.Create( "DPanel", sheet )
CarSelectionPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 180, 180, 180, self:GetAlpha() ) ) end
sheet:AddSheet( "Car Selection", CarSelectionPanel, "icon16/car.png" )

local CarCustomizationPanel = vgui.Create( "DPanel", sheet )
CarCustomizationPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 180, 180, 180, self:GetAlpha() ) ) end
sheet:AddSheet( "Car Customization", CarCustomizationPanel, "icon16/car_add.png" )

local PlayerCustomizationPanel = vgui.Create( "DPanel", sheet )
PlayerCustomizationPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 180, 180, 180, self:GetAlpha() ) ) end
sheet:AddSheet( "Player Customization - WIP", PlayerCustomizationPanel, "icon16/user.png" )

--local AdminPanel = vgui.Create( "DPanel", sheet )
--AdminPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 180, 180, 180, self:GetAlpha() ) ) end
--sheet:AddSheet( "Admin Menu", AdminPanel, "icon16/lock.png" )

--local MapConfigurationPanel = vgui.Create( "DPanel", sheet )
--MapConfigurationPanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 100, 100, 100, self:GetAlpha() ) ) end
--sheet:AddSheet( "Map Configurator",  MapConfigurationPanel, "icon16/map_edit.png" )

--Panel Items
---Customization
local Mixer = vgui.Create( "DColorMixer", CarCustomizationPanel )
Mixer:Dock( RIGHT )			--Make Mixer fill place of Frame
Mixer:SetPalette( false ) 		--Show/hide the palette			DEF:true
Mixer:SetAlphaBar( false ) 		--Show/hide the alpha bar		DEF:true
Mixer:SetWangs( false )			--Show/hide the R G B A indicators 	DEF:true
Mixer:SetColor( Color( 30, 100, 160 ) )	--Set the default color

---Selection
local h = 10
local w = 10
for k, v in pairs(CARS) do
if(k > 6 && h >= 270) then
w = w + 140
h = 10
elseif(k > 13 && h >= 270) then
w = w + 140
h = 10
end

local cname = v.cname
local name = v.name
local cbutname = v.cbutname
local carprice = v.price

local cbutname = vgui.Create( "DButton", CarSelectionPanel )
if(!GetGlobalBool("FreeCars")) then
cbutname:SetText( name.." | "..tostring(carprice).."$" )
else
	cbutname:SetText( name )
end
cbutname:SetPos( w, h )
h = h + 40
cbutname:SetSize( 130, 30 )
cbutname.DoClick = function()
	if(GetGlobalBool("FreeCars")) then --0 false, 1 true
    selectedcarent = tostring(k)
	selectedcar = name
	hook.Call( "HUDPaint" )
	print(k)
	elseif(carprice <= LocalPlayer():GetNWInt("far_money") && !GetGlobalBool("FreeCars")) then
		selectedcarent = tostring(k)
		selectedcar = name
		hook.Call( "HUDPaint" )
		print(k)
		net.Start("GrabCash")
		net.WriteFloat(carprice)
		net.SendToServer()
	else
	LocalPlayer():PrintMessage(3, "Insufficient Founds. This car costs "..carprice.."$")
	end
end
end
local ApplyColor = vgui.Create( "DButton", CarCustomizationPanel )
ApplyColor:SetText( "Apply Color" )
ApplyColor:SetPos( 50, 50 )
ApplyColor:SetSize( 130, 30 )
ApplyColor.DoClick = function()
	print(Mixer:GetVector())
	net.Start("ColorChange")
	net.WriteVector(Mixer:GetVector())
	net.SendToServer()
end

--Map Configurator
--local fstgoalvec = Vector(0,0,0)
--local secgoalvec = Vector(0,0,0)
--local fstnwvec = Vector(0,0,0)
--local secnwvec = Vector(0,0,0)
--local killtrigger = false;
--local killtriggerheight = 0

--local FirstGoalVector = vgui.Create( "DButton", MapConfigurationPanel)
--FirstGoalVector:SetText( "Set First Goal Vector" )
--FirstGoalVector:SetPos( 10, 10 )
--FirstGoalVector:SetSize( 250, 30 )
--FirstGoalVector.DoClick = function()
--	fstgoalvec = LocalPlayer():GetPos()
--	FirstGoalVector:SetText( tostring(fstgoalvec) )
--end

--local SecondGoalVector = vgui.Create( "DButton", MapConfigurationPanel)
--SecondGoalVector:SetText( "Set Second Goal Vector" )
--SecondGoalVector:SetPos( 10, 50 )
--SecondGoalVector:SetSize( 250, 30 )
--SecondGoalVector.DoClick = function()
--	secgoalvec = LocalPlayer():GetPos()
--	SecondGoalVector:SetText( tostring(secgoalvec) )
--end

--local FirstNWVector = vgui.Create( "DButton", MapConfigurationPanel)
--FirstNWVector:SetText( "Set First Reset Vector" )
--FirstNWVector:SetPos( 10, 110 )
--FirstNWVector:SetSize( 250, 30 )
--FirstNWVector.DoClick = function()
--	fstnwvec = LocalPlayer():GetPos()
--	FirstNWVector:SetText( tostring(fstnwvec) )
--end

--local SecondNWVector = vgui.Create( "DButton", MapConfigurationPanel)
--SecondNWVector:SetText( "Set Second Reset Vector" )
--SecondNWVector:SetPos( 10, 150 )
--SecondNWVector:SetSize( 250, 30 )
--SecondNWVector.DoClick = function()
--	secnwvec = LocalPlayer():GetPos()
--	SecondNWVector:SetText( tostring(secnwvec) )
--end

--local CreateMapFile = vgui.Create( "DButton", MapConfigurationPanel)
--CreateMapFile:SetText( "Create Map File" )
--CreateMapFile:SetPos( 10, 150 )
--CreateMapFile:SetSize( 250, 30 )
--CreateMapFile.DoClick = function()
--	net.Start("CreateMapFile")
--	net.WriteString("MAPPOINTS = {}\n".."MAPPOINTS[0] ="..fstgoalvec.."\n".."MAPPOINTS[1] ="..secgoalvec.."\n".."MAPPOINTS[2] ="..fstnwvec)
--	net.SendToServer()
--end


end
hook.Add("OnSpawnMenuOpen", "ShowMenu", Menu)

--Custom HUD
local mply = FindMetaTable( "Player" )
hook.Add( "HUDPaint", "CustomHUD", function()
	surface.SetFont( "GMFont" )
    surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( 0, 0 )
	surface.DrawText("Car Selected: "..selectedcar)
if(!GetGlobalBool("FreeCars")) then
	surface.SetFont( "GMFont" )
    surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( 0, 40 )
	surface.DrawText("Money: "..LocalPlayer():GetNWInt("far_money").."$")
end
	surface.SetFont( "LapFont" )
    surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( ScrW()/23, ScrH()/1.1)
	surface.DrawText("Lap: "..lap)
end )

--Net Receives

function HoveringNames()

	surface.SetTextColor(255,255,255,100)
	surface.SetFont("PlyName")
	local ply = LocalPlayer()
	for _, target in pairs(player.GetAll()) do
		if target:Alive() && target:GetName() != LocalPlayer():GetName() then
		
			local name = target:Nick()
			local targetPos = target:GetPos() + Vector(0,0,64)
			local targetDistance = math.floor((ply:GetPos():Distance( targetPos ))/40)
			local targetScreenpos = targetPos:ToScreen()
			
			
			surface.SetTextPos(tonumber(targetScreenpos.x), tonumber(targetScreenpos.y) - 10)
			surface.DrawText(target:Nick())
			
		end
	end
end
hook.Add("HUDPaint", "HoveringNames", HoveringNames)

--Main Game

--Hide HUD
local hide = {
	CHudHealth = true,
	CHudBattery = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end

end )

concommand.Add("far_getready", function()
if(!isReady) then
isReady = true;
net.Start("ReadyRequest")
net.SendToServer()
else
LocalPlayer():PrintMessage(3, "You already voted.")
end
end)

concommand.Add("far_unready", function()
	if(isReady) then
	isReady = false;
	net.Start("UnReadyRequest")
	net.SendToServer()
	else
	LocalPlayer():PrintMessage(3, "You need to be ready first.")
	end
	end)

net.Receive("SendSpawnRequest", function()
	surface.PlaySound("sfx/racestart.wav")
	net.Start("CarSelect")
	print(selectedcarent)
	net.WriteString(selectedcarent)
    net.SendToServer()
end)

function SendLap(rece)
	
	if(rece == LocalPlayer():GetName()) then
		net.Start("SendLapClient")
		net.WriteInt(lap, 32)
		net.SendToServer()
		print(lap)
	end
end

net.Receive("SendLap", function()
lap = lap + 1
hook.Call("HUDPaint")
rece = net.ReadString()
SendLap(rece)
end)

net.Receive("RefreshClient", function()
isReady = false;
lap = 0
hook.Call("HUDPaint")
end)

local music = {}
music[0] = {links="https://lambadacorez.github.io/music/track1.mp3"}
music[1] = {links="https://lambadacorez.github.io/music/track2.mp3"}
music[2] = {links="https://lambadacorez.github.io/music/track3.mp3"}
music[3] = {links="https://lambadacorez.github.io/music/track4.mp3"}
music[4] = {links="https://lambadacorez.github.io/music/track5.mp3"}
music[5] = {links="https://lambadacorez.github.io/music/track6.mp3"}
music[6] = {links="https://lambadacorez.github.io/music/track7.mp3"}
music[7] = {links="https://lambadacorez.github.io/music/track8.mp3"}
music[8] = {links="https://lambadacorez.github.io/music/track9.mp3"}
music[9] = {links="https://lambadacorez.github.io/music/track10.mp3"}
music[10] = {links="https://lambadacorez.github.io/music/track11.mp3"}

net.Receive("ClientMatchRefresh", function()

	sound.PlayURL ( music[math.random(0, 10)].links, "", function( station )
		if ( IsValid( station ) ) then	
			station:Play()
		else
			LocalPlayer():ChatPrint( "Invalid URL!" )
		end
	end )

end)

net.Receive("FinalCountdown", function()
surface.PlaySound("sfx/countdown.wav")
end)

concommand.Add("printcars", function()
PrintTable(CARS)
end)

concommand.Add("printcar1", function()
	print(CARS[0].cname)
end)

concommand.Add("printalive", function()
	print(LocalPlayer():Alive())
end)