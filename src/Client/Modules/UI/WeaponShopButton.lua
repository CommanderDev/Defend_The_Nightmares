-- WeaponShopButton
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
local UIController = Knit.GetController("UIController")

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local WeaponShopButton = {}
WeaponShopButton.__index = WeaponShopButton


function WeaponShopButton.new( holder: TextButton ): ( {} )
    local self = setmetatable( {}, WeaponShopButton )
    self._janitor = Janitor.new()

    local function OnButtonClicked(): ()
        local menuName: string | nil = if UIController.Menu == "WeaponShop" then nil else "WeaponShop"
        UIController:SetMenu(menuName)
    end

    self._janitor:Add( holder.MouseButton1Click:Connect(OnButtonClicked) )

    self._janitor:Add(function()
        UIController:SetMenu()
        holder.Visible = false
    end)

    holder.Visible = true
    
    return self
end


function WeaponShopButton:Destroy(): ()
    self._janitor:Destroy()
end


return WeaponShopButton