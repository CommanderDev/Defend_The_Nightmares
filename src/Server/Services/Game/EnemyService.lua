-- EnemyService
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local EnemyHelper = require( Knit.Helpers.EnemyHelper )

local ObjectsService = Knit.GetService("ObjectsService")
local CashService = Knit.GetService("CashService")
-- Roblox Services
local CollectionService = game:GetService("CollectionService")
-- Variables

-- Objects
local EnemiesFolder: Folder = Knit.Assets.General.Enemies

---------------------------------------------------------------------

local EnemyService = Knit.CreateService { 
    Name = "EnemyService";
    Enemies = {}; 
 }

-- Local functions
local function _getRandomEnemySpawn(): BasePart
    local enemySpawns: ( { BasePart } ) = CollectionService:GetTagged("EnemySpawn")
    return enemySpawns[ math.random(1, #enemySpawns) ]
end

local function _getNearestDefenseFromPosition( position: Vector3 ): BasePart
    local Defenses: ( { BasePart } ) = CollectionService:GetTagged("Defense")

    local nearestDefense: BasePart | nil
    local nearestDistance: number | nil

    -- Find the nearest defense by magnitude
    for _, defense in pairs( Defenses )  do 
        local defenseClass = ObjectsService:GetObjectByInstanceAsync(defense)

        if( defenseClass.IsBroken ) then 
            continue
        end
        
        local distance: number | nil = (position-defense.PrimaryPart.Position).Magnitude
        if( not nearestDefense or distance < nearestDistance ) then
            nearestDefense = defense
            nearestDistance = distance
        end
    end

    return nearestDefense.PrimaryPart 
end

-- Public functions

function EnemyService:KillEnemy( killer: Player, enemy: Instance ): ()
    EnemyHelper.RagDollEnemy(enemy)
    local humanoid = enemy:FindFirstChild("Humanoid")

    if( humanoid ) then
        enemy.Humanoid.Health = 0
    end
    -- Check if killer still exists
    if( killer ) then
        CashService:GiveCash(killer, enemy:GetAttribute("Reward"))
    end
end

function EnemyService:SpawnEnemy( enemyName: string ): table
    
    -- Initialize enemy
    local enemy = EnemiesFolder[ enemyName ]:Clone()
    enemy:PivotTo( EnemyHelper.GetRandomEnemySpawn().CFrame )
    enemy.Parent = workspace
    CollectionService:AddTag(enemy, "Enemy")
    
    local enemyClass = ObjectsService:GetObjectByInstanceAsync(enemy)

    task.spawn(function()
        while enemy:FindFirstChild("HumanoidRootPart") and enemyClass.Health > 0 do 
            local nearestBarrier = _getNearestDefenseFromPosition(enemy.HumanoidRootPart.Position)
            --local nearestBarrier = _getNearestBarrierFromPosition(enemy.HumanoidRootPart.Position).Position
            -- Check if the barrier changed since last iteration
            if( enemyClass.NearestBarrier ~= nearestBarrier ) then
                enemyClass.NearestBarrier = nearestBarrier

                -- Give enemy a random spot on the wall
                local randomXPosition: number = if nearestBarrier.Parent:GetAttribute("IsBase") then math.random(-15, 15) else math.random(-20, 20)
                local destination: Vector3 = Vector3.new(nearestBarrier.Position.X + randomXPosition, workspace.Map.Base.Position.Y, nearestBarrier.Position.Z + nearestBarrier.Size.Z / 2)
                enemyClass:MoveTo(destination)
            end
        end
    end)

    return enemyClass
end

function EnemyService:KnitStart(): ()
end


function EnemyService:KnitInit(): ()
    
end


return EnemyService