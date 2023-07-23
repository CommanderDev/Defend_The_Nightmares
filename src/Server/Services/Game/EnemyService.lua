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

local EnemyClass = require( Knit.Modules.Enemy )

-- Roblox Services
local CollectionService = game:GetService("CollectionService")
-- Variables

-- Objects

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
        local distance: number | nil
        if( not nearestBarrier or distance < nearestDistance ) then
            nearestBarrier = barrier
            nearestDistance = (barrier.Point.Position-nearestBarrier.Point.Position).Magnitude
        end
    end

    return nearestBarrier.Point 
end

-- Public functions

function EnemyService:SpawnEnemy( enemyName: string ): ()
    local enemyData = EnemyHelper.GetEnemyByName(enemyName)
    
    -- Initialize enemy
    local enemy = EnemyClass.new(enemyData)
    enemy:Spawn( _getRandomEnemySpawn().CFrame )
    enemy:MoveTo( _getNearestBarrierFromPosition(enemy._instance.HumanoidRootPart.Position).Position )
    table.insert(self.Enemies, enemy)
end

function EnemyService:KnitStart(): ()
    self:SpawnEnemy("Nightmare")
end


function EnemyService:KnitInit(): ()
    
end


return EnemyService