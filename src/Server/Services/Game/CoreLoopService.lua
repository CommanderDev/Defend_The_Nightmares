-- CoreLoopService
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local RemoteSignal = require( Knit.Util.Remote.RemoteSignal )
local Signal = require( Knit.Util.Signal )

-- Modules

local StatesFolder: Folder = Knit.Modules.States

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local CoreLoopService = Knit.CreateService {
    Name = "CoreLoopService";
    Client = {
        UpdateIntermissionTimer = RemoteSignal.new();
        StateChanged = RemoteSignal.new();
        ShowRoundWinner = RemoteSignal.new();
    };

    StateChanged = Signal.new()
}


function CoreLoopService:KnitStart(): ()
    self:SetState(Knit.Enums.State.Intermission)
end

function CoreLoopService:GetActivePlayers()
    return game.Players:GetPlayers()
end

function CoreLoopService.Client:GetState(): string
    return self.Server:GetState()
end

function CoreLoopService:GetState(): string
    return self.State.Name
end

function CoreLoopService:SetState( stateName: string ): ()

    -- Destroy old state
    if( self.State ) then
        self.State:Destroy()
    end

    self.State = require( StatesFolder[stateName] ).new()
    self.State.Name = stateName

    self.StateChanged:Fire(stateName)
    self.Client.StateChanged:FireAll(stateName)
end

function CoreLoopService:KnitInit(): ()
    
end


return CoreLoopService