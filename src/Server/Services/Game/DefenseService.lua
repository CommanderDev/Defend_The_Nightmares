-- DefenseService
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants
local TICK_COOLDOWN = 5
local MAX_DISTANCE: number = 8

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

            if ( Defense.IsBroken ) then 
                continue
            end

            for _, enemy in pairs( CollectionService:GetTagged("Enemy") ) do
                local humanoidRootPart = enemy:FindFirstChild("HumanoidRootPart")

                if( not humanoidRootPart ) then
                    continue
                end
                local enemyZ = humanoidRootPart.Position.Z
                local defenseZ = instance.PrimaryPart.Position.Z
                -- Check if the enemy is within range to damage 
                if( enemyZ-defenseZ < MAX_DISTANCE ) then
                    local enemyObject = ObjectsService:GetObjectByInstanceAsync(enemy)
                    -- Double check to make sure the defense didn't break
                    if( not Defense.IsBroken ) then
                        Defense:TakeDamage(enemyObject.Damage)
                    end
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