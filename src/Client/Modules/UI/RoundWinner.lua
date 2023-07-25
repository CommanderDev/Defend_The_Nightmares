-- RoundWinner
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

-- Roblox Services
local SoundService = game:GetService("SoundService")
-- Variables

-- Objects

---------------------------------------------------------------------


local RoundWinner = {}
RoundWinner.__index = RoundWinner


function RoundWinner.new( holder: TextLabel ): ( {} )
    local self = setmetatable( {}, RoundWinner )
    self._janitor = Janitor.new()

    self._holder = holder
    
    self._janitor:Add(function()
        holder.Visible = false
    end)

    holder.Visible = true

    return self
end

function RoundWinner:UpdateWinner( winner: string ): ()
    self._holder.Text = winner.." Win!"

    if( winner == "Survivors" ) then
        SoundService.SFX.WinSFX:Play()
    else
        SoundService.SFX.LoseSFX:Play()
    end
end

function RoundWinner:Destroy(): ()
    self._janitor:Destroy()
end


return RoundWinner