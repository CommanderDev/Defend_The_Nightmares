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

local function _getNearestBarrierFromPosition( position: Vector3 ): BasePart
    local barriers: ( { BasePart } ) = CollectionService:GetTagged("Barrier")

    local nearestBarrier: BasePart | nil
    local nearestDistance: number | nil

    -- Find the nearest barrier by magnitude
    for _, barrier in pairs( barriers )  do 
        local barrierClass = ObjectsService:GetObjectByInstanceAsync(barrier)

        if( barrierClass.IsBroken ) then
            continue
        end 

        local distance = (position-barrier.Point.Position).Magnitude
        if( not nearestBarrier or distance < nearestDistance ) then
            nearestBarrier = barrier
            nearestDistance = distance
        end
    end

    return nearestBarrier.Point 
end

-- Public functions

function EnemyService:SpawnEnemy( enemyName: string ): ()
    
    -- Initialize enemy
    local enemy = EnemiesFolder[ enemyName ]:Clone()
    enemy.Parent = workspace
    CollectionService:AddTag(enemy, "Enemy")
    
    local enemyClass = ObjectsService:GetObjectByInstanceAsync(enemy)

    while enemyClass do 
        local nearestBarrier = _getNearestBarrierFromPosition(enemy.HumanoidRootPart.Position).Position
        -- Check if the barrier changed since last iteration
        if( enemyClass.NearestBarrier ~= nearestBarrier ) then
            enemyClass.NearestBarrier = nearestBarrier
            enemyClass:MoveTo(nearestBarrier)
        end
        task.wait()
    end
end

function EnemyService:KnitStart(): ()
    self:SpawnEnemy("Nightmare")
end


function EnemyService:KnitInit(): ()
    
end


return EnemyService