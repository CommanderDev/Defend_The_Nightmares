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
local WeaponShopButtonClass = require( Knit.Modules.UI.WeaponShopButton )
local WeaponShopClass = require( Knit.Modules.UI.WeaponShop )

-- Roblox Services

-- Variables

-- Objects
local SideDisplay: Frame = Knit.MainUI:WaitForChild("SideDisplay")
local CoinsDisplay: Frame = SideDisplay:WaitForChild("CoinsDisplay")
local WeaponShopButton: TextButton = Knit.MainUI:WaitForChild("WeaponShopButton")
local WeaponShop: Frame = Knit.MainUI:WaitForChild("WeaponShop")

---------------------------------------------------------------------

local HUD = Knit.CreateController { Name = "HUD" }


function HUD:KnitStart(): ()

    -- Initialize classes
    HUDCash.new(CoinsDisplay)
    WeaponShopButtonClass.new(WeaponShopButton)
    WeaponShopClass.new(WeaponShop)

end


function HUD:KnitInit(): ()
    
end


return HUD