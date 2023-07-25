-- CoreLoopController
-- Author(s): Jesse Appleton
-- Date: 07/24/2023

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Signal = require( Knit.Util.Signal )

-- Modules
local CoreLoopService = Knit.GetService("CoreLoopService")
-- Roblox Services
local SoundService = game:GetService("SoundService")
-- Variables

-- Objects

---------------------------------------------------------------------

local CoreLoopController = Knit.CreateController { 
    Name = "CoreLoopController";
    StateChanged = Signal.new();
    ShowRoundWinner = Signal.new();
 }

function CoreLoopController:GetState(): string  
    return CoreLoopService:GetState()
end

function CoreLoopController:KnitStart(): ()
    
    local function OnStateChanged( stateName: string ): ()

        if( stateName == "InProgress" ) then
            SoundService.Music.Lobby:Stop()
            SoundService.Music.Gameplay:Play()
        elseif( stateName == "Conclusion" ) then
            SoundService.Music.Gameplay:Stop()
        elseif( stateName == "Intermission" ) then
            SoundService.Music.Lobby:Play()
        end

        self.StateChanged:Fire(stateName)
    end

    local function OnShowRoundWinner( winner: string ): ()
        self.ShowRoundWinner:Fire(winner)
    end

    OnStateChanged(CoreLoopService:GetState())
    CoreLoopService.StateChanged:Connect(OnStateChanged)
    CoreLoopService.ShowRoundWinner:Connect(OnShowRoundWinner)
end


function CoreLoopController:KnitInit(): ()
    
end


return CoreLoopController