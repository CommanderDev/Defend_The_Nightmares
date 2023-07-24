-- Round
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local CoreLoopService = Knit.GetService("CoreLoopService")

local RoundData = require( Knit.GameData.RoundData )
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Round = {}
Round.__index = Round


function Round.new( ): ( {} )
    local self = setmetatable( {}, Round )
    self._janitor = Janitor.new()

    --Public variables
    self.PlayerCash = {}

    -- Give starter cash to players
    for _, player in pairs( game.Players:GetPlayers() ) do 
        self:GivePlayerCash(player, RoundData.STARTING_CASH)
    end

    self._janitor:Add( game.Players.PlayerAdded:Connect(function(player)
        self:GivePlayerCash(player, RoundData.STARTING_CASH)
    end), "Disconnect")

    return self
end

function Round:GetPlayerCash( player: Player ): ()
    return self.PlayerCash[ player ]
end

function Round:GivePlayerCash( player: Player, cashAmount: number ): ()
    if( not self.PlayerCash[ player ] ) then
        self.PlayerCash[ player ] = cashAmount
    else
        self.PlayerCash[ player ] += cashAmount
    end
    print(self.PlayerCash[player])
    CoreLoopService.Client.UpdatePlayerCash:Fire(player, self.PlayerCash[ player ])
end

function Round:Destroy(): ()
    self._janitor:Destroy()
end


return Round