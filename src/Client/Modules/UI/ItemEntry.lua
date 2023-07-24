-- ItemEntry
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
local Create = require( Knit.Util.Create )
local NumberUtility = require( Knit.Util.NumberUtility )

-- Modules

-- Roblox Services

-- Variables

-- Objects
local template: Frame = Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(85, 0, 255);
    Size = UDim2.new(0, 100,1, 0);
    BackgroundTransparency = 0.5;
})

Create("UICorner", {
    Parent = template;
})

local PriceFrame: Frame = Create("Frame", {
    BackgroundTransparency = 0.5;
    Position = UDim2.new(0.2, 0, 0.7, 0);
    Size = UDim2.new(0.6, 0, 0.25, 0);
    Name = "PriceFrame";
    Parent = template;
})

local NameFrame: Frame = Create("Frame", {
    BackgroundTransparency = 0.5;
    Position = UDim2.new(0.2, 0, 0.4, 0);
    Size = UDim2.new(0.6, 0, 0.25, 0);
    Name = "NameFrame";
    Parent = template;
})

Create("TextLabel", {
    Position = UDim2.new(0.05, 0, 0, 0);
    Size = UDim2.new(0.9, 0, 1, 0);
    BackgroundTransparency = 1;
    TextColor3 = Color3.fromRGB(0, 49, 225);
    Font = Enum.Font.FredokaOne;
    TextScaled = true;
    Name = "NameLabel";
    Parent = NameFrame;
})

Create("UICorner", {
    Parent = NameFrame
})

Create("UICorner", {
    Parent = PriceFrame
})

Create("ImageLabel", {
    AnchorPoint = Vector2.new(1, 0.5);
    Position = UDim2.new(0.935, 0, 0.5, 0);
    Size = UDim2.new(0.201, 0, 0.667, 0);
    BackgroundTransparency = 1;
    Image = "rbxassetid://10925240027";
    Parent = PriceFrame;
})

Create("TextLabel", {
    Position = UDim2.new(0.05, 0, 0, 0);
    Size = UDim2.new(0.6, 0, 1, 0);
    BackgroundTransparency = 1;
    TextColor3 = Color3.fromRGB(0, 49, 225);
    Font = Enum.Font.FredokaOne;
    TextScaled = true;
    Name = "PriceLabel";
    Parent = PriceFrame;
})

Create("TextButton", {
    Size = UDim2.new(1,0,1,0);
    BackgroundTransparency = 1;
    TextTransparency = 1;
    Name = "Button";
    Parent = template;
})

---------------------------------------------------------------------


local ItemEntry = {}
ItemEntry.__index = ItemEntry


function ItemEntry.new( ): ( {} )
    local self = setmetatable( {}, ItemEntry )
    self._janitor = Janitor.new()

    self._holder = template:Clone()
    self._nameLabel = self._holder:WaitForChild("NameFrame"):WaitForChild("NameLabel")
    self._priceLabel = self._holder:WaitForChild("PriceFrame"):WaitForChild("PriceLabel")
    self._button = self._holder:WaitForChild("Button")

    return self
end

function ItemEntry:SetName( name: string ): ()
    self._nameLabel.Text = name
end

function ItemEntry:SetPrice( price: number ): ()
    self._priceLabel.Text = NumberUtility.FormatWithCommas(price) 
end

function ItemEntry:SetLayoutOrder( order: number ): ()
    self._holder.LayoutOrder = order
end

function ItemEntry:SetParent( parent: Instance ): ()
    self._holder.Parent = parent
end

function ItemEntry:Destroy(): ()
    self._janitor:Destroy()
end


return ItemEntry