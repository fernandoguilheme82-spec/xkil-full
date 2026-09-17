--[[
    XKil Full
    Object Manager
]]

local ObjectManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/fernandoguilheme82-spec/xkil-full/refs/heads/main/Games/ObjectManager.lua"
))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- =========================
-- SCAN
-- =========================

local ObjectNames = ObjectManager.Scan(workspace)

-- =========================
-- GUI
-- =========================

local Gui = Instance.new("ScreenGui")
Gui.Name = "XKilFull_ObjectManager"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    Gui.Parent = game:GetService("CoreGui")
end)

if not Gui.Parent then
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(360, 430)
Main.Position = UDim2.new(0.5, -180, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(70, 70, 85)
Stroke.Thickness = 1
Stroke.Parent = Main

-- =========================
-- HEADER
-- =========================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
Header.BorderSizePixel = 0
Header.Parent = Main

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "XKil Full — Objects"
Title.TextColor3 = Color3.fromRGB(235, 235, 245)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Count = Instance.new("TextLabel")
Count.Size = UDim2.fromOffset(100, 20)
Count.Position = UDim2.new(1, -110, 0, 13)
Count.BackgroundTransparency = 1
Count.Text = tostring(#ObjectNames) .. " objetos"
Count.TextColor3 = Color3.fromRGB(145, 145, 160)
Count.Font = Enum.Font.Gotham
Count.TextSize = 11
Count.TextXAlignment = Enum.TextXAlignment.Right
Count.Parent = Header

-- =========================
-- LISTA
-- =========================

local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1, -20, 1, -125)
List.Position = UDim2.fromOffset(10, 55)
List.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new()
List.Parent = Main

Instance.new("UICorner", List).CornerRadius = UDim.new(0, 7)

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 7)
Padding.PaddingBottom = UDim.new(0, 7)
Padding.PaddingLeft = UDim.new(0, 7)
Padding.PaddingRight = UDim.new(0, 7)
Padding.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.Name
Layout.Parent = List

local SelectedName = nil
local SelectedButton = nil

-- =========================
-- SELEÇÃO
-- =========================

local function SelectObject(name, button)

    SelectedName = name

    if SelectedButton then
        SelectedButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 32)
    end

    SelectedButton = button

    button.BackgroundColor3 =
        Color3.fromRGB(55, 45, 85)
end

-- =========================
-- CRIAR LISTA
-- =========================

for _, name in ipairs(ObjectNames) do

    local Button = Instance.new("TextButton")

    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(220, 220, 230)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.AutoButtonColor = false
    Button.Parent = List

    Instance.new("UICorner", Button).CornerRadius =
        UDim.new(0, 6)

    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 10)
    TextPadding.Parent = Button

    Button.MouseButton1Click:Connect(function()
        SelectObject(name, Button)
    end)
end

local function UpdateCanvas()
    List.CanvasSize = UDim2.fromOffset(
        0,
        Layout.AbsoluteContentSize.Y + 14
    )
end

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
    UpdateCanvas
)

UpdateCanvas()

-- =========================
-- PUXAR OBJETOS
-- =========================

local function PullObjects()

    if not SelectedName then
        warn("[XKil Full] Selecione um objeto.")
        return
    end

    local Character = LocalPlayer.Character
    local Root = Character
        and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    local Objects = ObjectManager.Get(SelectedName)

    if not Objects then
        return
    end

    local total = #Objects

    for index, data in ipairs(Objects) do

        local Object = data.Object

        if Object and Object.Parent then

            local angle =
                (index / math.max(total, 1))
                * math.pi * 2

            local radius = 5

            local offset = Vector3.new(
                math.cos(angle) * radius,
                2 + ((index - 1) % 3) * 1.5,
                math.sin(angle) * radius
            )

            Object.CFrame =
                Root.CFrame + offset
        end
    end
end

-- =========================
-- RESTAURAR
-- =========================

local function RestoreObjects()

    if not SelectedName then
        warn("[XKil Full] Selecione um objeto.")
        return
    end

    ObjectManager.Restore(SelectedName)
end

-- =========================
-- BOTÃO PUXAR
-- =========================

local PullButton = Instance.new("TextButton")

PullButton.Name = "PullButton"
PullButton.Size = UDim2.new(0.5, -15, 0, 42)
PullButton.Position = UDim2.new(0, 10, 1, -55)
PullButton.BackgroundColor3 =
    Color3.fromRGB(70, 50, 120)
PullButton.BorderSizePixel = 0
PullButton.Text = "Puxar"
PullButton.TextColor3 =
    Color3.fromRGB(245, 245, 250)
PullButton.Font = Enum.Font.GothamBold
PullButton.TextSize = 13
PullButton.Parent = Main

Instance.new("UICorner", PullButton).CornerRadius =
    UDim.new(0, 7)

PullButton.MouseButton1Click:Connect(PullObjects)

-- =========================
-- BOTÃO RESTAURAR
-- =========================

local RestoreButton = Instance.new("TextButton")

RestoreButton.Name = "RestoreButton"
RestoreButton.Size = UDim2.new(0.5, -15, 0, 42)
RestoreButton.Position = UDim2.new(0.5, 5, 1, -55)
RestoreButton.BackgroundColor3 =
    Color3.fromRGB(40, 40, 50)
RestoreButton.BorderSizePixel = 0
RestoreButton.Text = "Restaurar"
RestoreButton.TextColor3 =
    Color3.fromRGB(230, 230, 235)
RestoreButton.Font = Enum.Font.GothamBold
RestoreButton.TextSize = 13
RestoreButton.Parent = Main

Instance.new("UICorner", RestoreButton).CornerRadius =
    UDim.new(0, 7)

RestoreButton.MouseButton1Click:Connect(RestoreObjects)

-- =========================
-- ARRASTAR JANELA
-- =========================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position

        input.Changed:Connect(function()

            if input.UserInputState ==
                Enum.UserInputState.End then

                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not Dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Delta =
        input.Position - DragStart

    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)

print("[XKil Full] Object Manager carregado.")
print("[XKil Full] Tipos encontrados:", #ObjectNames)
