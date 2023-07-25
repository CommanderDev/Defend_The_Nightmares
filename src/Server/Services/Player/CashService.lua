-- CashService
-- Author(s): Jesse Appleton
-- Date: 07/24/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local DataService = Knit.GetService("DataService")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local CashService = Knit.CreateService {
    Name = "CashService";
    Client = {
        
    };
}

function CashService:GiveCash( player: Player, cashAmount: number ): ()
    DataService:IncrementPlayerData(player, "Cash", cashAmount)
end

function CashService:KnitStart(): ()
    
end


function CashService:KnitInit(): ()
    
end


return CashService