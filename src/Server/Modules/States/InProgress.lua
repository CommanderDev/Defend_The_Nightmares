-- InProgress
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

local Round = require( Knit.Modules.Round )

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local InProgress = {}
InProgress.__index = InProgress


function InProgress.new(): ( {} )
    local self = setmetatable( {}, InProgress )
    self._janitor = Janitor.new()

    self._round = Round.new()

    local function OnRoundEnded(): ()
        CoreLoopService:SetState( Knit.Enums.State.Intermission)
    end

    self._round.RoundEnded:Connect(OnRoundEnded)
    self._janitor:Add( self._round, "Destroy")
    return self
end


function InProgress:Destroy(): ()
    self._janitor:Destroy()
end


return InProgress