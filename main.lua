-- XKil Full
-- Rayfield Object Manager

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ObjectManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/fernandoguilheme82-spec/xkil-full/refs/heads/main/Games/ObjectManager.lua"
))()

local ObjectNames = ObjectManager.Scan(workspace)
local SelectedName = nil

local Window = Rayfield:CreateWindow({
    Name = "XKil Full",
    Icon = 0,
    LoadingTitle = "XKil Full",
    LoadingSubtitle = "Object Manager",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "XKilFull",
        FileName = "Config"
    }
})

local ObjectsTab = Window:CreateTab("Objects", "box")

ObjectsTab:CreateSection("Object Manager")

local ObjectDropdown = ObjectsTab:CreateDropdown({
    Name = "Objeto",
    Options = ObjectNames,
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "SelectedObject",

    Callback = function(Options)
        if type(Options) == "table" then
            SelectedName = Options[1]
        else
            SelectedName = Options
        end

        print("[XKil Full] Selecionado:", SelectedName)
    end
})

ObjectsTab:CreateButton({
    Name = "Puxar objetos",

    Callback = function()
        if not SelectedName then
            Rayfield:Notify({
                Title = "XKil Full",
                Content = "Selecione um objeto primeiro.",
                Duration = 3
            })
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

        local Total = #Objects

        for Index, Data in ipairs(Objects) do
            local Object = Data.Object

            if Object and Object.Parent then
                local Angle =
                    (Index / math.max(Total, 1))
                    * math.pi * 2

                local Radius = 5

                local Offset = Vector3.new(
                    math.cos(Angle) * Radius,
                    2 + ((Index - 1) % 3) * 1.5,
                    math.sin(Angle) * Radius
                )

                Object.CFrame = Root.CFrame + Offset
            end
        end

        Rayfield:Notify({
            Title = "XKil Full",
            Content = "Objetos puxados: " .. SelectedName,
            Duration = 3
        })
    end
})

ObjectsTab:CreateButton({
    Name = "Restaurar",

    Callback = function()
        if not SelectedName then
            Rayfield:Notify({
                Title = "XKil Full",
                Content = "Selecione um objeto primeiro.",
                Duration = 3
            })
            return
        end

        ObjectManager.Restore(SelectedName)

        Rayfield:Notify({
            Title = "XKil Full",
            Content = "Objetos restaurados.",
            Duration = 3
        })
    end
})

ObjectsTab:CreateButton({
    Name = "Restaurar tudo",

    Callback = function()
        ObjectManager.RestoreAll()

        Rayfield:Notify({
            Title = "XKil Full",
            Content = "Todos os objetos foram restaurados.",
            Duration = 3
        })
    end
})

ObjectsTab:CreateButton({
    Name = "Atualizar lista",

    Callback = function()
        ObjectNames = ObjectManager.Scan(workspace)

        ObjectDropdown:Refresh(ObjectNames)

        SelectedName = nil

        Rayfield:Notify({
            Title = "XKil Full",
            Content = tostring(#ObjectNames) .. " tipos de objetos encontrados.",
            Duration = 3
        })
    end
})

Rayfield:LoadConfiguration()

Rayfield:Notify({
    Title = "XKil Full",
    Content = tostring(#ObjectNames) .. " tipos de objetos encontrados.",
    Duration = 4
})

print("[XKil Full] Rayfield carregado.")
print("[XKil Full] Objetos:", #ObjectNames)
