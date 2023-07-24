-- HUDCash
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
local NumberUtility = require( Knit.Util.NumberUtility )

-- Modules
local CoreLoopService = Knit.GetService("CoreLoopService")

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local HUDCash = {}
HUDCash.__index = HUDCash


function HUDCash.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, HUDCash )
    self._janitor = Janitor.new()

    local function UpdateCash( playerCash: number ): ()
        print(playerCash)
        holder.Amount.Text = NumberUtility.FormatWithCommas(playerCash)
    end

    CoreLoopService.UpdatePlayerCash:Connect(UpdateCash)

    return self
end


function HUDCash:Destroy(): ()
    self._janitor:Destroy()
end


return HUDCash