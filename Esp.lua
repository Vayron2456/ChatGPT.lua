local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Function to highlight a character
local function highlightCharacter(character)
    if character and not character:FindFirstChild("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Blue Color
        highlight.FillTransparency = 0.5 -- Adjust transparency if needed
        highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
    end
end

-- Apply highlights to existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        highlightCharacter(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        highlightCharacter(character)
    end)
end

-- Listen for new players joining the game
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        highlightCharacter(character)
    end)
end)
