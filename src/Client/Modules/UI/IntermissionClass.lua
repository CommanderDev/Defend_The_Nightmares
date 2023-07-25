-- IntermissionClass
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
local CoreLoopService = Knit.GetService("CoreLoopService")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local IntermissionClass = {}
IntermissionClass.__index = IntermissionClass

-- Private functions
local function _formatSecondsIntoMinutes( seconds: number ): ()
    return string.format("%02.f:%02.f", seconds / 60, seconds % 60)
end

function IntermissionClass.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, IntermissionClass )
    self._janitor = Janitor.new()

    local function OnUpdateIntermissionTimer( countdown: number ): ()
        holder.IntermissionLabel.Text = "Round begins in: ".._formatSecondsIntoMinutes(countdown)
    end

    self._janitor:Add( CoreLoopService.UpdateIntermissionTimer:Connect(OnUpdateIntermissionTimer), "Disconnect" )
    self._janitor:Add(function()
        holder.Visible = false
    end)

    holder.Visible = true
    return self
end


function IntermissionClass:Destroy(): ()
    self._janitor:Destroy()
end


return IntermissionClass