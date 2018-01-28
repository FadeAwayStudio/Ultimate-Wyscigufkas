local cat = "FadeAway"
------------------------------------------------------------------------
function ulx.addmoney( calling_ply, target_ply, value, should_silent )
 if not GetConVar("gamemode") == "far" then ULib.tsayError( calling_ply, "WRONG GAMEMODE!", true ) else
        AddMoney(target_ply,value)
 end
 
ulx.fancyLogAdmin( calling_ply, should_silent, "#A gived #i money to #T.", value, target_ply )
end
 
local addmoney = ulx.command( cat, "ulx addmoney", ulx.addmoney, "!addmoney", true )
addmoney:addParam{ type=ULib.cmds.PlayersArg }
addmoney:addParam{ type=ULib.cmds.NumArg, default=0, hint="value", min=0, max=1000000 }
addmoney:addParam{ type=ULib.cmds.BoolArg, hint="Silent?", should_silent=true }
addmoney:defaultAccess( ULib.ACCESS_SUPERADMIN )
addmoney:help( "Give money to player" )
------------------------------------------------------------------------
function ulx.forcestart( calling_ply )
    StartRace()
   ulx.fancyLogAdmin( calling_ply, false, "#A forced match start." )
end
local forcestart = ulx.command( cat, "ulx forcestart", ulx.forcestart, "!forcestart", true )
forcestart:defaultAccess( ULib.ACCESS_ADMIN )
forcestart:help( "Force start match" )
-------------------------------------------------------------------------
function ulx.forceend( calling_ply )
    EndRace()
   ulx.fancyLogAdmin( calling_ply, false, "#A ended the match." )
end
local forceend = ulx.command( cat, "ulx forceend", ulx.forceend, "!forceend", true )
forceend:defaultAccess( ULib.ACCESS_ADMIN )
forceend:help( "Force start match" )
-----------------------------------------------------------------------------
function ulx.ready( calling_ply )
    calling_ply:ConCommand("far_getready")
end
local ready = ulx.command( cat, "ulx ready", ulx.ready, {"!ready","!reedie"}, true )
ready:defaultAccess( ULib.ACCESS_ALL )
ready:help( "Vote for match start" )
--------------------------------------------------------------------------------------------
function ulx.unready( calling_ply )
    calling_ply:ConCommand("far_unready")
end
local unready = ulx.command( cat, "ulx unready", ulx.unready, "!unready", true )
unready:defaultAccess( ULib.ACCESS_ALL )
unready:help( "Change to not ready." )
--------------------------------------------------------------------------------
