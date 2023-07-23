-- Barrier
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

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Barrier = {}
Barrier.__index = Barrier


function Barrier.new( barrier: BasePart ): ( {} )
    local self = setmetatable( {}, Barrier )
    self._janitor = Janitor.new()

    

    return self
end


function Barrier:Destroy(): ()
    self._janitor:Destroy()
end


return Barrier