-- Intermission
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


local Intermission = {}
Intermission.__index = Intermission


function Intermission.new( ): ( {} )
    local self = setmetatable( {}, Intermission )
    self._janitor = Janitor.new()

    print("Begin intermission")

    return self
end


function Intermission:Destroy(): ()
    self._janitor:Destroy()
end


return Intermission