-- Spikes
-- Author(s): Jesse Appleton
-- Date: 07/24/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Spikes = {}
Spikes.__index = Spikes


function Spikes.new( instance: Instance ): ( {} )
    local self = setmetatable( {}, Spikes )
    self._janitor = Janitor.new()

    print("Spikes created!")

    return self
end


function Spikes:Destroy(): ()
    self._janitor:Destroy()
end


return Spikes