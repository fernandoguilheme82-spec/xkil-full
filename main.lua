local ObjectManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/fernandoguilheme82-spec/xkil-full/refs/heads/main/Games/ObjectManager.lua"
))()

local names = ObjectManager.Scan(workspace)

print("[XKil Full] Objetos físicos encontrados:")

for _, name in ipairs(names) do
    print(" - " .. name)
end

return ObjectManager
