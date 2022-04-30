if (CLIENT) then

    net.Receive("GPM.Where_Are_You?", function()
        net.Start( "GPM.Where_Are_You?" )
            net.WriteString( system.GetCountry():lower() )
        net.SendToServer()
    end)

end

local default_language = "gb"
local cvar = GetConVar( "default_language" )
if (cvar) then
    default_language = cvar:GetString()
end

local PLAYER = FindMetaTable("Player")

do

    function PLAYER:Country()
        return self:GetNWString( "GPM.Where_Am_I", default_language )
    end

end

if (SERVER) then

    function PLAYER:SetCountry( country_code )
        return self:SetNWString( "GPM.Where_Am_I", country_code or default_language )
    end

    util.AddNetworkString( "GPM.Where_Are_You?" )
    hook.Add("PlayerInitialized", "GPM.Where_Are_You?", function( ply )
        net.Start( "GPM.Where_Are_You?" )
        net.Send( ply )
    end)

    local net_ReadString = net.ReadString
    net.Receive("GPM.Where_Are_You?", function( len, ply )
        if IsValid( ply ) and (ply:GetNWString( "GPM.Where_Am_I", false ) == false) then
            ply:SetCountry( net_ReadString() )
        end
    end)

end
