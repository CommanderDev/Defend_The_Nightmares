local data = {
    Kills = 0;
    Level = 0;
    build = game.ReplicatedStorage.GameVersion.Value;
}

local function GetPlayerDataTemplate()
    local formattedData = {}
    for key, value in pairs( data ) do
        if ( type(value) == "function" ) then
            formattedData[ key ] = value()
        else
            formattedData[ key ] = value
        end
    end
    return formattedData
end

return GetPlayerDataTemplate()