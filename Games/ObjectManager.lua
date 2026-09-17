local ObjectManager = {}

local Objects = {}
local Names = {}

local MAX_DISTANCE = 5000

local function IsPhysicalObject(obj)
    if not obj:IsA("BasePart") then
        return false
    end

    if obj.Anchored then
        return false
    end

    if not obj.Parent then
        return false
    end

    -- Só considera peças que realmente participam da física.
    if obj.CanCollide or obj.Mass > 0 then
        return true
    end

    return false
end

function ObjectManager.Scan(root, origin)
    root = root or workspace

    table.clear(Objects)
    table.clear(Names)

    origin = origin or Vector3.zero

    for _, obj in ipairs(root:GetDescendants()) do
        if IsPhysicalObject(obj) then
            local distance = (obj.Position - origin).Magnitude

            if distance <= MAX_DISTANCE then
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

    if not list then
        return
    end

    for _, data in ipairs(list) do
        local object = data.Object

        if object and object.Parent then
            object.CFrame = data.OriginalCFrame
        end
    end
end

function ObjectManager.RestoreAll()
    for name in pairs(Objects) do
        ObjectManager.Restore(name)
    end
end

return ObjectManager
