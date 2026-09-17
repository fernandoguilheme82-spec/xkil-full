-- XKil Full
-- Physical Object Manager

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ObjectManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/fernandoguilheme82-spec/xkil-full/refs/heads/main/Games/ObjectManager.lua"
))()

local function GetRoot()
    local character = LocalPlayer.Character

    return character
        and character:FindFirstChild("HumanoidRootPart")
end

local Root = GetRoot()

local ObjectNames = ObjectManager.Scan(
    workspace,
    Root and Root.Position or Vector3.zero
)

local SelectedName = nil

local Window = Rayfield:CreateWindow({
    Name = "XKil Full",
    Icon = 0,
    LoadingTitle = "XKil Full",
    LoadingSubtitle = "Physical Objects",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "XKilFull",
        FileName = "Config"
    }
})

local ObjectsTab = Window:CreateTab("Objects", "box")

ObjectsTab:CreateSection("Physical Objects")

local ObjectDropdown = ObjectsTab:CreateDropdown({
    Name = "Objeto",
    Options = ObjectNames,
    CurrentOption = {},
    MultipleOptions = false,

    Callback = function(options)
        if type(options) == "table" then
            SelectedName = options[1]
        else
            SelectedName = options
        end
    end
})

ObjectsTab:CreateButton({
    Name = "Puxar objetos",

    Callback = function()
        if not SelectedName then
            Rayfield:Notify({
                Title = "XKil Full",
                Content = "Selecione um objeto.",
                Duration = 3
            })
            return
        end

        local root = GetRoot()

        if not root then
            return
        end

        local list = ObjectManager.Get(SelectedName)

        if not list then
            return
        end

        local total = #list

        -- Mantém uma distância mínima entre os objetos.
        local spacing = 4
        local columns = math.max(
            1,
            math.ceil(math.sqrt(total))
        )

        -- Processamento em lotes para evitar um pico enorme.
        local batchSize = 25

        for index, data in ipairs(list) do
            local object = data.Object

            if object and object.Parent then
                local row = math.floor((index - 1) / columns)
                local column = (index - 1) % columns

                local x = (column - (columns - 1) / 2) * spacing
                local z = row * spacing + 6

                local target =
                    root.CFrame
                    * CFrame.new(x, 3, -z)

                object.CFrame = target
            end

            if index % batchSize == 0 then
                task.wait()
            end
        end

        Rayfield:Notify({
            Title = "XKil Full",
            Content = total .. " objetos posicionados.",
            Duration = 3
        })
    end
})

ObjectsTab:CreateButton({
    Name = "Restaurar",

    Callback = function()
        if not SelectedName then
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
            Content = "Todos os objetos restaurados.",
            Duration = 3
        })
    end
})

ObjectsTab:CreateButton({
    Name = "Atualizar lista",

    Callback = function()
        local root = GetRoot()

        ObjectNames = ObjectManager.Scan(
            workspace,
            root and root.Position or Vector3.zero
        )

        ObjectDropdown:Refresh(ObjectNames)

        SelectedName = nil

        Rayfield:Notify({
            Title = "XKil Full",
            Content = #ObjectNames .. " tipos físicos encontrados em até 5000 studs.",
            Duration = 4
        })
    end
})

Rayfield:LoadConfiguration()

Rayfield:Notify({
    Title = "XKil Full",
    Content = #ObjectNames .. " tipos físicos encontrados.",
    Duration = 4
})
