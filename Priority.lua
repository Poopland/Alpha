local Priority = {
    Activity = nil,
    Weight = 0,
    Start = 0,
    Classes = {},
}
Priority.__index = Priority
function Priority:set(Data,Skip)
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if (not self.Activity or Skip) and self.Weight < Value.Weight then
        self.Activity = Value.Class
        self.Weight = Value.Weight
        self.Start = tick()
        Value.LastActive = self.Start
    end
end
function Priority:clear()
    self.Activity = nil
    self.Weight = 0
    self.Start = 0
end
function Priority:get(name)
    for i=1,#self.Classes do local v = self.Classes[i]
        if v.Class == name then
            return v
        end
    end
end
local WeightBase = setmetatable({},Priority)
WeightBase.__index = Priority
WeightBase.__tostring = function(self)
    return string.format("%s : [ %s ]",self.Class,self.Weight)
end
function Priority.new(Class,Weight)
    local Value = setmetatable({},WeightBase)
    Value.Class = Class ~= "" and Class or "Undifined"
    Value.Weight = Weight or #Value.Classes + 1
    Value.LastActive = 0
    table.insert(Priority.Classes,Value)
    table.sort(Priority.Classes,function(a,b)
        return a.Weight < b.Weight
    end)
    return Value
end
getgenv().Priority = getgenv().Priority or Priority
return Priority
