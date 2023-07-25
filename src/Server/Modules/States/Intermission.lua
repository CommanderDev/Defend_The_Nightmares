-- Intermission
-- Author(s): Jesse Appleton
-- Date: 07/24/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants
local INTERMISSION_TIME = 5

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local CoreLoopService = Knit.GetService("CoreLoopService")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Intermission = {}
Intermission.__index = Intermission


function Intermission.new( ): ( {} )
    local self = setmetatable( {}, Intermission )
    self._janitor = Janitor.new()

    local function Run(): ()
        for countdown = INTERMISSION_TIME, 1, -1 do 
            CoreLoopService.Client.UpdateIntermissionTimer:FireAll(countdown)
            task.wait(1)
        end

        CoreLoopService:SetState(Knit.Enums.State.InProgress)
    end

    task.spawn(Run)

    return self
end


function Intermission:Destroy(): ()
    self._janitor:Destroy()
end


return Intermission