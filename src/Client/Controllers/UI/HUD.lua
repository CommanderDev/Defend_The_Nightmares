-- HUD
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local HUDCash = require( Knit.Modules.UI.HUDCash )

-- Roblox Services

-- Variables

-- Objects
local SideDisplay: Frame = Knit.MainUI:WaitForChild("SideDisplay")
local CoinsDisplay: Frame = SideDisplay:WaitForChild("CoinsDisplay")

---------------------------------------------------------------------

local HUD = Knit.CreateController { Name = "HUD" }


function HUD:KnitStart(): ()
    HUDCash.new(CoinsDisplay)
end


function HUD:KnitInit(): ()
    
end


return HUD