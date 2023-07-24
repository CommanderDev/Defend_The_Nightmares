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

local function _getNearestDefenseFromPosition( position: Vector3 ): BasePart
    local Defenses: ( { BasePart } ) = CollectionService:GetTagged("Defense")

    local nearestDefense: BasePart | nil
    local nearestDistance: number | nil

    -- Find the nearest Defense by magnitude
    for _, defense in pairs( Defenses )  do 
        local distance: number | nil = (position-defense.Point.Position).Magnitude
        if( not nearestDefense or distance < nearestDistance ) then
            nearestDefense = defense
            nearestDistance = distance
        end
    end

    return nearestDefense.Point 
end

-- Public functions

function EnemyService:SpawnEnemy( enemyName: string ): ()
    
    -- Initialize enemy
    local enemy = EnemiesFolder[ enemyName ]:Clone()
    enemy.Parent = workspace
    CollectionService:AddTag(enemy, "Enemy")
    
    local enemyClass = ObjectsService:GetObjectByInstanceAsync(enemy)
    enemyClass:MoveTo( _getNearestDefenseFromPosition(enemy.HumanoidRootPart.Position).Position )
end

function EnemyService:KnitStart(): ()
    self:SpawnEnemy("Nightmare")
end


function EnemyService:KnitInit(): ()
    
end


return EnemyService