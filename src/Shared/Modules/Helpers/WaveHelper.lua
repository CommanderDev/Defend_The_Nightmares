-- Knit 
local Knit = require( game.ReplicatedStorage.Knit )

-- Modules
local WaveData = require( Knit.GameData.WaveData )

local WaveHelper = {}

function WaveHelper.GetWaveByIndex( index: number ): ()
    for waveIndex, wave in pairs( WaveData.Waves ) do
        if( index == waveIndex ) then
            return wave
        end
    end
end

return WaveHelper