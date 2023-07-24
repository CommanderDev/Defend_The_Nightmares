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


    return self
end


function Round:Destroy(): ()
    self._janitor:Destroy()
end


return Round