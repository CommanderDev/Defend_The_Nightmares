-- Round
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )
local Signal = require( Knit.Util.Signal )

-- Modules
local EnemyService = Knit.GetService("EnemyService")
local PlacementService = Knit.GetService("PlacementService")

local DefenseHelper = require( Knit.Helpers.DefenseHelper )
local WaveHelper = require( Knit.Helpers.WaveHelper )

-- Roblox Services
local CollectionService = game:GetService("CollectionService")
-- Variables

-- Objects

---------------------------------------------------------------------


local Round = {}
Round.__index = Round


function Round.new( players: { Player } ): ( {} )
    local self = setmetatable( {}, Round )
    self._janitor = Janitor.new()

    local base = DefenseHelper.GetBaseDefense()

    -- Private variables
    self._wave = 1

    -- Public variables
    self.Winner = nil
    self.Players = players

    -- Initalize signals
    self.RoundEnded = Signal.new()

    -- Private functions
    local function OnBaseHealthChanged(): ()
        if( base:GetAttribute("Health") == 0 ) then
            self.Winner = "Enemies"
            self.RoundEnded:Fire()
            self:TeleportPlayersToLobby()
            PlacementService:ClearPlacedObjects()
            self:CleanEnemies()
            self:Destroy()
        end
    end

    task.spawn(function()
        self:TeleportPlayersToMap()
        self:StartWave()
    end)
    base:GetAttributeChangedSignal("Health"):Connect(OnBaseHealthChanged)
    self._janitor:Add( self.RoundEnded, "Destroy")

    return self
end

function Round:CleanEnemies(): ()
    for _, enemy in pairs( CollectionService:GetTagged("Enemy") ) do
        CollectionService:RemoveTag(enemy, "Enemy")
        enemy:Destroy()
    end
end

function Round:TeleportPlayersToMap(): ()
    local playerSpawns = CollectionService:GetTagged("PlayerSpawn")
    for _, player in pairs( self.Players ) do
        player.Character:PivotTo( playerSpawns[ math.random(1, #playerSpawns) ].CFrame + Vector3.new(0, 3, 0) )
    end
end

function Round:TeleportPlayersToLobby(): ()
    for _, player: Player in pairs( self.Players ) do
        player.Character:PivotTo( workspace.SpawnLocation.CFrame + Vector3.new(0, 3, 0) )
    end
end

function Round:StartWave(): ()
    local waveData = WaveHelper.GetWaveByIndex(self._wave)

    for enemyName, amountOfEnemies in pairs( waveData.Enemies ) do
        for index = 1, amountOfEnemies do 
            EnemyService:SpawnEnemy(enemyName)
            task.wait(1)
        end
    end
end

function Round:Destroy(): ()
    self._janitor:Destroy()
end


return Round