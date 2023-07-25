-- Conclusion
-- Author(s): Jesse Appleton
-- Date: 07/25/2023

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
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Conclusion = {}
Conclusion.__index = Conclusion


function Conclusion.new( ): ( {} )
    local self = setmetatable( {}, Conclusion )
    self._janitor = Janitor.new()

    task.delay(5, function()
        CoreLoopService:SetState(Knit.Enums.State.Intermission)
    end)

    return self
end


function Conclusion:Destroy(): ()
    self._janitor:Destroy()
end


return Conclusion