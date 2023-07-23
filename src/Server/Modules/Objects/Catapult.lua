-- Catapult
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


local Catapult = {}
Catapult.__index = Catapult


function Catapult.new( instance ): ( {} )
    local self = setmetatable( {}, Catapult )
    self._janitor = Janitor.new()

    

    return self
end


function Catapult:Destroy(): ()
    self._janitor:Destroy()
end


return Catapult