-- WaveTimer
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


local WaveTimer = {}
WaveTimer.__index = WaveTimer


function WaveTimer.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, WaveTimer )
    self._janitor = Janitor.new()

    local function OnUpdateWaveTimer( count: number, wave: number ): ()
        holder.Visible = true
        holder.Text = "Wave "..wave.." starts in: "..count
        if( count == 1 ) then
            task.wait(1)
            holder.Visible = false
        end
    end

    self._janitor:Add( CoreLoopService.UpdateWaveTimer:Connect(OnUpdateWaveTimer), "Disconnect")

    return self
end


function WaveTimer:Destroy(): ()
    self._janitor:Destroy()
end


return WaveTimer