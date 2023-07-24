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
local PathfindingHelper = require( Knit.Helpers.PathfindingHelper )

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Catapult = {}
Catapult.__index = Catapult


function Catapult.new( instance: Model ): ( {} )
    local self = setmetatable( {}, Catapult )
    self._janitor = Janitor.new()

    local pathfindingModifier: PathfindingModifier = Instance.new("PathfindingModifier")
    pathfindingModifier.Label = "Weapon"

    PathfindingHelper.AddModifierToModel(instance, "Weapon")

    return self
end


function Catapult:Destroy(): ()
    self._janitor:Destroy()
end


return Catapult