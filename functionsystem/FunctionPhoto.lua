autoImport("PhotoCommandShowGhost")
FunctionPhoto = class("FunctionPhoto")

function FunctionPhoto.Me()
	if nil == FunctionPhoto.me then
		FunctionPhoto.me = FunctionPhoto.new()
	end
	return FunctionPhoto.me
end

function FunctionPhoto:ctor()
	self.cmds = {}
	self:Reset()
end

function FunctionPhoto:Reset()
	self.running = false
	self:RemoveCommand()
end

function FunctionPhoto:ShutDown()
	if not self.running then
		return
	end
	self:Reset()
end

function FunctionPhoto:Launch()
	if self.running then
		return
	end
	self.running = true
	self:StartCommand(PhotoCommandShowGhost)
end

function FunctionPhoto:IsRunningCmd(cmdClass)
	local cmd = self.cmds[cmdClass]
	if(cmd and cmd.running) then
		return true
	end
	return false
end

function FunctionPhoto:GetCmd(cmdClass)
	local cmd = self.cmds[cmdClass]
	return cmd
end

function FunctionPhoto:RemoveCommand(cmdClass)
	if(self.cmds) then
		if(cmdClass) then
			local cmd = self.cmds[cmdClass]
			if(cmd) then
				cmd:ShutDown()
				self.cmds[cmdClass] = nil
			end
		else
			for k,cmd in pairs(self.cmds) do
				cmd:ShutDown()
			end
			self.cmds = {}
		end
	end
end

function FunctionPhoto:StartCommand(cmdClass)
	local cmd = self.cmds[cmdClass]
	if(cmd==nil) then
		cmd = cmdClass.new()
		self.cmds[cmdClass] = cmd
	end
	cmd:Launch()
end