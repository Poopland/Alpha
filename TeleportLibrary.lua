getgenv().Tlib = {
	task = {},
	lastData = {tick(),Vector3.new()},
	Finished = {tick(),CFrame.new()},
	TP = function(self,C,S)
		local Char = Client.Character
		local Root = Char.HumanoidRootPart
		local C = (typeof(C) == "Instance" and C.CFrame) or C
		local instance = {
			lib = self,
			_UID = game:GetService("HttpService"):GenerateGUID(false),
			feedback = true,
			getuid = function(self)
				return self._UID
			end,
			IsVaild = true,
			Running = true,
			target = C,
			new = function(self,C)
				self.target = C
				return self
			end,
			Statement = function()
				return true
			end,
			SetStatement = function(self,Function)
				self.Statement = Function
				return self
			end,
			Destroy = function(self)
				self.IsVaild = false
				self.Running = false
				table.remove(self.lib.task,table.find(self.lib.task,self))
				self:SendFeedback("Teleport Destroyed UID:/uid")
			end,
			Wait = function(self,check_every)
				repeat task.wait(check_every) until not self.Running
				return self
			end,
			SetFeedback = function(self,tf)
				self.feedback = tf
				return self
			end,
			SendFeedback = function(self,txt)
				if self.feedback then
					txt = txt:gsub("/uid",self:getuid())
					warn(txt)
				end
				return self
			end
		}
		task.spawn(function()
			local StartHeight = Root.Position.Y
			local Height = 10000
			local Default = CFrame.new(Root.Position.X,Height,Root.Position.Z)
			local _Distance = (Vector3.new(C.X,0,C.Z) - Vector3.new(Default.X,0,Default.Z)).magnitude
			local SubSpeed =  300
			local Duration = _Distance/SubSpeed
			local nDistance = _Distance
			local TpDist = 175
			local Length = 2
			local Speed = (S or 0.0125)
			if tick() - self.lastData[1] > 0.35 or (self.lastData[2] - C.p).magnitude > 100 then
				if (self.lastData[2] - C.p).magnitude > 50  then
					self.lastData[1] = tick()
					self.lastData[2] = C.p
				end
			else
				_Distance = (Vector3.new(C.X,0,C.Z) - Vector3.new(self.lastData[2].X,0,self.lastData[2].Z)).magnitude
			end
			if _Distance > 3000 then SubSpeed = 150 end
			if _Distance <= 3000 then SubSpeed = 175 end
			if _Distance <= 2000 then SubSpeed = 200 end
			if _Distance <= 1500 then SubSpeed = 225 end
			if _Distance <= 1000 then SubSpeed = 250 end
			if _Distance <= 500 then SubSpeed = 300 end
			if _Distance <= 400 then SubSpeed = 325 end
			if _Distance <= 300 then SubSpeed = 350 end
			if _Distance <= 200 then SubSpeed = 375 end
			warn(_Distance,SubSpeed)
			if _Distance < 2500 then
				Height = C.Y + 20
			end
			Root.CFrame = CFrame.new(Root.Position.X,Height,Root.Position.Z)
			if self.Finished[1] + 0.15 < tick() and NoYDis(self.Finished[2],C) > 500 then
				wait(.05)
			end
			wait(.1)
			local Success,Error = pcall(function()
				local AllStatement = nDistance > TpDist and instance.IsVaild and instance.Statement() and Root.Parent
				local lastDistance = nDistance
				local Target = CFrame.new(instance.target.X,Height,instance.target.Z)
				local oldTarget = Target
				local Paused = tick() + Length
				while AllStatement do
					NeedNoclip = true
					if not instance.obj or (Target.p - oldTarget.p).magnitude > TpDist then
						Target = CFrame.new(instance.target.X,Height,instance.target.Z)
						nDistance = (Vector3.new(Target.X,0,Target.Z) - Vector3.new(Root.Position.X,0,Root.Position.Z)).magnitude
						Duration = nDistance/SubSpeed
						if instance.obj then
							oldTarget = Target
							wait(.1)
							instance.obj:Cancel()
							instance.obj = nil
						end
						instance.obj = game.TweenService:Create(Root,TweenInfo.new(Duration),{CFrame = Target})
					end
					if instance.obj.PlaybackState ~= Enum.PlaybackState.Playing then
						instance.obj:Play()
					end
					Char.Humanoid:ChangeState(11)
					Target = CFrame.new(instance.target.X,Height,instance.target.Z)
					nDistance = (Vector3.new(Target.X,0,Target.Z) - Vector3.new(Root.Position.X,0,Root.Position.Z)).magnitude
					AllStatement = nDistance > TpDist and instance.IsVaild and instance.Statement() and Char
					if lastDistance - nDistance < -10 then
						instance.obj:Pause()
						task.wait(.75)
						end
						lastDistance = nDistance
						task.wait(.1)
						Root.Anchored = false
					end
					NeedNoclip = false
				end)
				if not Success then warn(Error) end
				if nDistance > TpDist or not instance.Statement() or not Root.Parent then
					instance.IsVaild = false
				end
				if instance.obj then
					instance.obj:Cancel()
					instance.obj = nil
				end
				instance.Running = false
				if instance.IsVaild and Root.Parent then
					Root.CFrame = instance.target
					self.Finished = {tick(),instance.target}
				end
				if table.find(self.task,instance) then
				instance:Destroy()
			end
		end) 
		table.insert(self.task,instance)
		return instance
	end,
}

return Tlib
