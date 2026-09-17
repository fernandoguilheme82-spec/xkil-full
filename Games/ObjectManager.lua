local ObjectManager = {}

local Objects = {}
local Names = {}

function ObjectManager.Scan(root)
    root = root or workspace

    table.clear(Objects)
    table.clear(Names)

    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and obj.Parent then
            local name = obj.Name

            if not Names[name] then
                Names[name] = true
                Objects[name] = {}
            end

            table.insert(Objects[name], {
                Object = obj,
                OriginalCFrame = obj.CFrame
            })
        end
    end

    return ObjectManager.GetNames()
end

function ObjectManager.GetNames()
    local result = {}

    for name in pairs(Names) do
        table.insert(result, name)
    end

    table.sort(result)

    return result
end

function ObjectManager.Get(name)
    return Objects[name]
end

function ObjectManager.Restore(name)
    local list = Objects[name]
    if not list then return end

    for _, data in ipairs(list) do
        if data.Object and data.Object.Parent then
            data.Object.CFrame = data.OriginalCFrame
        end
    end
end

function ObjectManager.RestoreAll()
    for name in pairs(Objects) do
        ObjectManager.Restore(name)
    end
end

return ObjectManager
