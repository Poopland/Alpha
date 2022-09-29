local Priority = {
    Activity = nil,
    Weightness = 0,
    Recently = nil,
    Start = 0,
    Classes = {},
}
Priority.__index = Priority
function Priority:set(Data,Skip)
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self,"Weight") then
        Value = self
        self = Priority
    end
    if (not self.Activity or (Skip and Value.Skipable)) and self.Weightness < Value.Weight then
        self.Activity = Value.Class
        self.Weightness = Value.Weight
        self.Recently = Value
        self.Start = tick()
        Value.LastActive = self.Start
        return true
    end
end
function Priority:check(Data,Skip)
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self,"Weight") then
        Value = self
        self = Priority
    end
    if type(Data) == "boolean" then Skip = Data end
    if (not self.Activity or (Skip and Value.Skipable)) and self.Weightness < Value.Weight or self.Recently == Value then
        return true
    end
end
function Priority:clear(Data)
    local Value = Data
    if type(Data) == "string" then
        Value = self:get(Data)
    end
    if rawget(self,"Weight") then
        Value = self
        self = Priority
    end
    if not Value or Value.Class ~= self.Activity or Value.LastActive ~= self.Start then return end
    self.Activity = nil
    self.Weightness = 0
    self.Start = 0
    return true
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
    Value.Skipable = true
    Value.LastActive = 0
    table.insert(Priority.Classes,Value)
    table.sort(Priority.Classes,function(a,b)
        return a.Weight < b.Weight
    end)
    return Value
end
getgenv().Priority = getgenv().Priority or Priority
return Priority
