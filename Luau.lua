
-- NOVA AIM | Menu UI
-- Colocar en StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "NovaAimMenu"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(320, 350)
main.Position = UDim2.new(0.5, -160, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(16, 19, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65, 205, 255)
stroke.Thickness = 1.5
stroke.Parent = main

-- Barra superior
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = Color3.fromRGB(25, 32, 49)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1
title.Text = "✦ NOVA AIM"
title.TextColor3 = Color3.fromRGB(90, 220, 255)
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -42, 0, 13)
close.BackgroundColor3 = Color3.fromRGB(190, 55, 75)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 15
close.Parent = header

Instance.new("UICorner", close).CornerRadius =
    UDim.new(0, 8)

-- Función para crear botones
local function createButton(text, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -32, 0, 43)
    button.Position = UDim2.fromOffset(16, y)
    button.BackgroundColor3 = Color3.fromRGB(31, 40, 59)
    button.TextColor3 = Color3.fromRGB(235, 242, 255)
    button.Text = text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.AutoButtonColor = false
    button.Parent = main

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 9)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(44, 65, 91)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(31, 40, 59)
        }):Play()
    end)

    return button
end

local aimButton = createButton("Aim Assist: OFF", 78)
local fovButton = createButton("Mostrar FOV: OFF", 132)
local trainingButton = createButton("Modo entrenamiento: OFF", 186)
local minimizeButton = createButton("Minimizar menú", 240)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -32, 0, 30)
status.Position = UDim2.fromOffset(16, 298)
status.BackgroundTransparency = 1
status.Text = "Sistema iniciado correctamente"
status.TextColor3 = Color3.fromRGB(135, 155, 180)
status.TextSize = 11
status.Font = Enum.Font.Gotham
status.Parent = main

-- Estados de la interfaz
local aimEnabled = false
local fovEnabled = false
local trainingEnabled = false
local minimized = false

aimButton.Activated:Connect(function()
    aimEnabled = not aimEnabled
    aimButton.Text = "Aim Assist: " ..
        (aimEnabled and "ON" or "OFF")
    status.Text = "Estado visual actualizado"
end)

fovButton.Activated:Connect(function()
    fovEnabled = not fovEnabled
    fovButton.Text = "Mostrar FOV: " ..
        (fovEnabled and "ON" or "OFF")
    status.Text = "FOV visual: " ..
        (fovEnabled and "activado" or "desactivado")
end)

trainingButton.Activated:Connect(function()
    trainingEnabled = not trainingEnabled
    trainingButton.Text = "Modo entrenamiento: " ..
        (trainingEnabled and "ON" or "OFF")
    status.Text = "Modo de entrenamiento actualizado"
end)

minimizeButton.Activated:Connect(function()
    minimized = not minimized

    for _, item in ipairs(main:GetChildren()) do
        if item ~= header and item ~= corner
            and item ~= stroke then
            item.Visible = not minimized
        end
    end

    main.Size = minimized
        and UDim2.fromOffset(320, 58)
        or UDim2.fromOffset(320, 350)
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- Permitir arrastrar el menú con ratón o pantalla táctil
local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
