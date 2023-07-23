-- EnemyHelper
-- Author(s): Jesse Appleton
-- Date: 7/22/2023

--[[

    SHARED
        FUNCTION    EnemyHelper.GetEnemyByName( enemyName: string ) -> ( {} )     
]]

-- Knit
local Knit = require( game.ReplicatedStorage.Knit )
local t = require( Knit.Util.t )

-- Modules
local EnemyData = require( Knit.GameData.EnemyData )

local EnemyHelper = {}

local tGetEnemyByName = t.tuple( t.string )
function EnemyHelper.GetEnemyByName( enemyName: string ): table | nil  
    assert( tGetEnemyByName(enemyName) )
    
    for _, data in pairs( EnemyData.Enemies ) do 
        if( data.Name == enemyName ) then
            return data
        end
    end
end

return EnemyHelper
