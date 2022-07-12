getgenv().Maid = Maid or {
    Connect = {},
}
Maid.__index = Maid
Maid.check = isexecutorclosure or is_synapse_function
Maid.WireBase = {}
local WireBase = Maid.WireBase
WireBase.__index = function(self,key)
    return self.cont[key]
end
WireBase.cd = function(self,cd)
    self.data.Cooldown = cd
end

function Maid.Clear(Connection,all)
    for i,v in pairs(getconnections(Connection)) do
        if v.Function and (all or Maid.check(v.Function)) then
            v:Disable()
        end
    end
end
function Maid.ClearMaid(Signal)
    local removed = 0
    for i,v in pairs(Maid.Connect) do
        if v.signal == Signal then
            v.cont:Disconnect()
            table.remove(Maid.Connect,i-removed)
            removed = removed + 1
        end
    end
end
function Maid.new(Signal,data)
	if type(data) == "function" then
		data = {
			func = data,
		}
	end
    data.Cooldown = 0
    local Cont = Signal:Connect(function(...)
        if data.delay then
            if tick() < data.Cooldown then return end
            data.Cooldown = tick() + data.delay
        end
        data.func(...)
    end)
    local CCont = setmetatable({
        cont = Cont,
        data = data,
        signal = Signal,
    },WireBase)
    CCont.Disconnect = function(self)
        self.cont:Disconnect()
    end
    table.insert(Maid.Connect,CCont)
    return CCont
end

return Maid
