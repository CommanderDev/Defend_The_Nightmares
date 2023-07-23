-- BarrierService
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )

-- Modules

-- Roblox Services
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
-- Variables

-- Objects

---------------------------------------------------------------------


local BarrierService = Knit.CreateService {
    Name = "BarrierService";
    Client = {
        
    };

    EnemiesAttached = {}; 
    BarrierJanitor = Janitor.new()
}

function BarrierService:AttachEnemy( enemy: table, barrierPart: BasePart ): ()

end

function BarrierService:EnableBarriers(): ()
    
    local function OnHeartbeat( deltaTime: number ): ()
        --Damage barrier based on enemies attached
        for _, data in pairs( self.EnemiesAttached ) do 
            data.Barrier:TakeDamage(data.Enemy.Damage)
        end
    end

    self.BarrierJanitor:Add( RunService.Heartbeat:Connect(OnHeartbeat), "Disconnect" )
end

function BarrierService:DisableBarriers(): ()
    self.BarrierJanitor:Clean()
end

function BarrierService:KnitStart(): ()
    self:EnableBarriers()
end


function BarrierService:KnitInit(): ()
    
end


return BarrierService