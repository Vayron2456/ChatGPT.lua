local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

-- Function to apply highlight to a character
local function applyHighlight(character)
    if not character or CollectionService:HasTag(character, "Highlighted") then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Blue color
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.fromRGB(0, 0, 255)

    CollectionService:AddTag(character, "Highlighted") -- Prevent duplicate highlights
end

-- Function to highlight a character
local function highlightCharacter(character)
    if not character or CollectionService:HasTag(character, "Highlighted") then return end

    -- Ensure the character has a Humanoid
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    -- Wait for character parts if they haven't loaded yet
    local foundPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") 
                      or character:FindFirstChild("UpperTorso") or character:FindFirstChild("LowerTorso")

    if not foundPart then
        task.wait(1) -- Wait a bit longer for loading
        foundPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") 
                    or character:FindFirstChild("UpperTorso") or character:FindFirstChild("LowerTorso")
    end

    -- Highlight no matter what
    applyHighlight(character)
end

-- Function to scan and highlight every character (players & NPCs)
local function scanForCharacters()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            highlightCharacter(player.Character)
        end
        player.CharacterAdded:Connect(highlightCharacter)
    end

    -- Scan all NPCs or other humanoid models
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") and not CollectionService:HasTag(model, "Highlighted") then
            highlightCharacter(model)
        end
    end
end

-- Run an initial scan
scanForCharacters()

-- Ensure new players are highlighted
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(highlightCharacter)
end)

-- Detect new NPCs or late-loading characters
Workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") then
        task.wait(1) -- Small delay to ensure full loading
        highlightCharacter(descendant)
    end
end)

-- Re-scan every 2 seconds to catch anyone who was missed
task.spawn(function()
    while true do
        task.wait(2)
        scanForCharacters()
    end
end)
