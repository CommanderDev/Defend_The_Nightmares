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
local BaseHealthClass = require( Knit.Modules.UI.BaseHealth )
local IntermissionClass = require( Knit.Modules.UI.IntermissionClass )

local UIController = Knit.GetController("UIController")
local CoreLoopController = Knit.GetController("CoreLoopController")
-- Roblox Services

-- Variables

-- Objects
local SideDisplay: Frame = Knit.MainUI:WaitForChild("SideDisplay")
local CoinsDisplay: Frame = SideDisplay:WaitForChild("CoinsDisplay")
local WeaponShopButton: TextButton = Knit.MainUI:WaitForChild("WeaponShopButton")
local WeaponShop: Frame = Knit.MainUI:WaitForChild("WeaponShop")
local BaseHealth: Frame = Knit.MainUI:WaitForChild("BaseHealth")
local Intermission: Frame = Knit.MainUI:WaitForChild("Intermission")

---------------------------------------------------------------------

local HUD = Knit.CreateController { 
    Name = "HUD";
    ActiveClasses = {}
 }


function HUD:KnitStart(): ()

    -- Initialize classes
    HUDCash.new(CoinsDisplay)

    local function OnStateChanged( stateName: string ): ()
        -- Clean active classes
        for _, class in pairs( self.ActiveClasses ) do
            class:Destroy()
        end
         -- Load game HUD
        if( stateName == "InProgress" ) then
            table.insert( self.ActiveClasses, WeaponShopButtonClass.new(WeaponShopButton) )
            table.insert( self.ActiveClasses, WeaponShopClass.new(WeaponShop) )
            table.insert( self.ActiveClasses, BaseHealthClass.new(BaseHealth) )
        elseif stateName == "Intermission" then
            table.insert( self.ActiveClasses, IntermissionClass.new(Intermission) )
        end
    end

    CoreLoopController.StateChanged:Connect(OnStateChanged)
end


function HUD:KnitInit(): ()
    
end


return HUD