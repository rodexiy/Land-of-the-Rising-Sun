local services = {}

for _,v in ipairs(script:GetDescendants()) do
    if v:IsA("ModuleScript") then 
        services[v.Name] = require(v)
    end
end

for _, v in pairs(services) do
    if v.ModuleMain == true then
        v:Main(services)
    end
end