-- Criar a janela centralizada
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 400)
Frame.Position = UDim2.new(0.5, -100, 0.5, -200) -- Centralizado na tela
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

-- Tornar o menu movível em dispositivos móveis (toques)
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        update(input)
    end
end)

-- Função para ajustar a cor dos botões
local function setButtonColor(button)
    button.BackgroundColor3 = Color3.fromRGB(169, 169, 169)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- Função para ativar o aimbot via URL
local function loadAimbotScript()
    loadstring(game:HttpGet('https://gist.githubusercontent.com/Aimboter477387/582af6aec49782899d5d375ab239039e/raw/51b6ddf5dc74731a24f912134061f150b6f6b316/gistfile1.txt'))()
end

-- Função de Fly
local function toggleFly()
    if flying then
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    else
        flying = true
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = character.HumanoidRootPart
        end
    end
end

-- Função de Hitbox
local function modifyHitbox(size)
    hitboxSize = size
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            humanoidRootPart.Size = size
            humanoidRootPart.Transparency = 0.5
            humanoidRootPart.Material = Enum.Material.Neon
            humanoidRootPart.Color = Color3.new(1, 0, 0)
        end
    end
end

-- Função de ESP
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local espPart = Instance.new("BillboardGui")
        espPart.Size = UDim2.new(0, 200, 0, 50)
        espPart.Adornee = player.Character.HumanoidRootPart
        espPart.Parent = player.Character
        espPart.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = player.Name .. " - " .. math.floor((player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. " studs"
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0.8
        label.TextSize = 14
        label.Parent = espPart
    end
end

-- Criando botões no menu
local ButtonFly = Instance.new("TextButton")
ButtonFly.Size = UDim2.new(0, 180, 0, 50)
ButtonFly.Position = UDim2.new(0, 10, 0, 40)
ButtonFly.Text = "Ativar Fly"
setButtonColor(ButtonFly)
ButtonFly.Parent = Frame
ButtonFly.MouseButton1Click:Connect(function()
    toggleFly()
end)

local ButtonAimbot = Instance.new("TextButton")
ButtonAimbot.Size = UDim2.new(0, 180, 0, 50)
ButtonAimbot.Position = UDim2.new(0, 10, 0, 100)
ButtonAimbot.Text = "Ativar Aimbot"
setButtonColor(ButtonAimbot)
ButtonAimbot.Parent = Frame
ButtonAimbot.MouseButton1Click:Connect(function()
    loadAimbotScript()  -- Chama a função para carregar o script do Aimbot
end)

local ButtonHitbox = Instance.new("TextButton")
ButtonHitbox.Size = UDim2.new(0, 180, 0, 50)
ButtonHitbox.Position = UDim2.new(0, 10, 0, 160)
ButtonHitbox.Text = "Alterar Hitbox"
setButtonColor(ButtonHitbox)
ButtonHitbox.Parent = Frame
ButtonHitbox.MouseButton1Click:Connect(function()
    modifyHitbox(Vector3.new(7, 7, 7))
end)

local ButtonESP = Instance.new("TextButton")
ButtonESP.Size = UDim2.new(0, 180, 0, 50)
ButtonESP.Position = UDim2.new(0, 10, 0, 220)
ButtonESP.Text = "Ativar ESP"
setButtonColor(ButtonESP)
ButtonESP.Parent = Frame
ButtonESP.MouseButton1Click:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end
end)

-- Slider para ajustar a velocidade de caminhada
local WalkSpeedSlider = Instance.new("TextButton")
WalkSpeedSlider.Size = UDim2.new(0, 180, 0, 50)
WalkSpeedSlider.Position = UDim2.new(0, 10, 0, 280)
WalkSpeedSlider.BackgroundColor3 = Color3.fromRGB(169, 169, 169)  -- Cor cinza
WalkSpeedSlider.Text = "WalkSpeed"
WalkSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkSpeedSlider.Parent = Frame
WalkSpeedSlider.MouseButton1Click:Connect(function()
    local newWalkSpeed = math.random(16, 100) -- Ajuste aleatório para exemplo
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character.Humanoid.WalkSpeed = newWalkSpeed
        WalkSpeedSlider.Text = "WalkSpeed: " .. newWalkSpeed
    end
end)

-- Slider para ajustar a velocidade de voo
local FlySpeedSlider = Instance.new("TextButton")
FlySpeedSlider.Size = UDim2.new(0, 180, 0, 50)
FlySpeedSlider.Position = UDim2.new(0, 10, 0, 340)
FlySpeedSlider.BackgroundColor3 = Color3.fromRGB(169, 169, 169)  -- Cor cinza
FlySpeedSlider.Text = "FlySpeed"
FlySpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedSlider.Parent = Frame
FlySpeedSlider.MouseButton1Click:Connect(function()
    local newFlySpeed = math.random(20, 200) -- Ajuste aleatório para exemplo
    flySpeed = newFlySpeed
    if flying and bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
    end
    FlySpeedSlider.Text = "FlySpeed: " .. flySpeed
end)
