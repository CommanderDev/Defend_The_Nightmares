-- Round
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants
local WAVE_TIME: number = 5
-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )
local Signal = require( Knit.Util.Signal )

-- Modules
local EnemyService = Knit.GetService("EnemyService")
local PlacementService = Knit.GetService("PlacementService")
local CoreLoopService = Knit.GetService("CoreLoopService")
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

    self.Enemies = {}

    -- Initalize signals
    self.RoundEnded = Signal.new()

    -- Private functions
    local function OnBaseHealthChanged(): ()
        if( base:GetAttribute("Health") == 0 ) then
            self:EndRound("Enemies")
        end
    end

    task.spawn(function()
        self:TeleportPlayersToMap()
        self:StartWave()
    end)
    base:GetAttributeChangedSignal("Health"):Connect(OnBaseHealthChanged)
    self._janitor:Add(self.RoundEnded)

    return self
end

function Round:EndRound( winner: string ): ()
    self.Winner = winner
    self.RoundEnded:Fire()
    CoreLoopService.Client.ShowRoundWinner:FireAll(winner)
    task.wait(5)
    self:TeleportPlayersToLobby()
    PlacementService:ClearPlacedObjects()
    self:CleanEnemies()
    self:Destroy()
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

        -- Check if player is still in game
        if( player:IsDescendantOf(game) ) then
            player.Character:PivotTo( workspace.SpawnLocation.CFrame + Vector3.new(0, 3, 0) )
        end
    end
end

function Round:ClearEnemies(): ()
    for _, enemy in pairs( self.Enemies ) do 
        enemy._instance:Destroy()
    end

    table.clear(self.Enemies)
end

function Round:GetEnemiesAliveCount(): number
    local enemiesAlive: number = 0
    for _, enemy in pairs( self.Enemies ) do 
        if( not enemy._instance:GetAttribute("Ragdolled") ) then
            enemiesAlive += 1
        end
    end

    return enemiesAlive
end

function Round:StartWave(): ()

    self:ClearEnemies()

    local waveData = WaveHelper.GetWaveByIndex(self._wave)

    if( not waveData ) then
        -- No more waves left, assume players win
        self:EndRound("Survivors")
        return
    end

    for count = WAVE_TIME, 1, -1 do 
        CoreLoopService.Client.UpdateWaveTimer:FireAll(count, self._wave)
        task.wait(1)
    end

    self._spawningEnemies = true
    for _, enemyName in pairs( waveData.Enemies ) do
        local enemy = EnemyService:SpawnEnemy(enemyName)

        local function OnEnemyDied(): ()
            if( not self._spawningEnemies and self:GetEnemiesAliveCount() == 0 ) then
                self:StartWave()
            end
        end
        
        enemy.Ragdolled:Connect(OnEnemyDied)
        table.insert(self.Enemies, enemy)
        task.wait(1)
    end
    self._spawningEnemies = false
    self._wave += 1
end

function Round:Destroy(): ()
    self._janitor:Destroy()
end


return Round