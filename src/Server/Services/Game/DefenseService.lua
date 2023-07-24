-- DefenseService
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants
local TICK_COOLDOWN = 5;
-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )

-- Modules
local ObjectsService = Knit.GetService("ObjectsService")
-- Roblox Services
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
-- Variables

-- Objects

---------------------------------------------------------------------


local DefenseService = Knit.CreateService {
    Name = "DefenseService";
    Client = {
        
    };

    DefenseJanitor = Janitor.new()
}

function DefenseService:KnitStart(): ()

    local function _getNearestEnemyFromDefense( DefensePosition: Vector3 ): Model
        local nearestEnemy: Model | nil
        local nearestDistance: number | nil
        for _, enemy in pairs( CollectionService:GetTagged("Enemy") ) do 
            local distance = (DefensePosition-enemy.HumanoidRootPart.Position).Magnitude
            if( not nearestEnemy or distance > nearestDistance ) then 
                nearestEnemy = enemy
                nearestDistance = distance
            end
        end

        return nearestEnemy, nearestDistance
    end

    local tickCounter: number = 0

    local function OnHeartbeat( deltaTime: number ): ()
        if( tickCounter < TICK_COOLDOWN ) then 
            tickCounter += 1
            return
        end


        for _, instance: Instance in pairs( CollectionService:GetTagged("Defense") ) do 
            local Defense = ObjectsService:GetObjectByInstanceAsync(instance)
            -- Check if Defense should be active
            if( Defense.Health > 0 ) then
                local targetEnemy, targetDistance = _getNearestEnemyFromDefense(instance.Point.Position)

                -- Check if target is within damaging range
                if( targetDistance < 2 ) then
                    local enemyObject = ObjectsService:GetObjectByInstanceAsync(targetEnemy)
                    Defense:TakeDamage(enemyObject.Damage)
                end
            end
        end

        -- Reset tick counter
        tickCounter = 0
    end

    RunService.Heartbeat:Connect(OnHeartbeat)
end


function DefenseService:KnitInit(): ()
    
end


return DefenseService