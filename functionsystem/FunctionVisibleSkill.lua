autoImport ("SkillInVisiblePlayerCmd")

FunctionVisibleSkill = class("FunctionVisibleSkill")

function FunctionVisibleSkill.Me()
	if nil == FunctionVisibleSkill.me then
		FunctionVisibleSkill.me = FunctionVisibleSkill.new()
	end
	return FunctionVisibleSkill.me
end

function FunctionVisibleSkill:ctor()
	self.coCmds = {}
	self:Reset()
end

function FunctionVisibleSkill:Reset()
	self:ShutdownAll()
end

function FunctionVisibleSkill:ResetCmd(cmdClass)
	if(self.cmd) then
		if(cmdClass and self.cmd.__cname == cmdClass.__cname) then
			return false
		end
		self.cmd:End()
	end
	self.cmd = nil
	if(cmdClass) then
		self.cmd = cmdClass.new()
		self.cmd:Start()
	end
end

function FunctionVisibleSkill:Start(master,cmdClass)
	return self:ResetCmd(cmdClass)
end

function FunctionVisibleSkill:End(master,cmdClass)
	if(self.cmd) then
		if(self.cmd.__cname ~= cmdClass.__cname) then
			return
		end
	end
	self:ResetCmd(nil)
end

function FunctionVisibleSkill:ShutdownAll()
	self:Shutdown()
	self:ShutdownCo()
end

function FunctionVisibleSkill:Shutdown()
	self:End(nil,self.cmd)
end

function FunctionVisibleSkill:ShutdownCo()
	for k,v in pairs(self.coCmds) do
		v:End()
	end
	self.coCmds = {}
end

function FunctionVisibleSkill:IsRunning(cmdClass)
	if(cmdClass) then
		if(self.cmd and self.cmd.__cname == cmdClass.__cname) then
			return true
		elseif(self.coCmds[cmdClass.__cname]) then
			return true
		end
		return false
	end
	return self.cmd~=nil
end

function FunctionVisibleSkill:CoStart(master,cmdClass)
	if(cmdClass) then
		local cmd = self.coCmds[cmdClass.__cname]
		if(not cmd) then
			cmd = cmdClass.new()
			self.coCmds[cmdClass.__cname] = cmd
			cmd:Start()
		end
		return cmd
	end
	return nil
end

function FunctionVisibleSkill:CoEnd(master,cmdClass)
	if(cmdClass) then
		local cmd = self.coCmds[cmdClass.__cname]
		if(cmd) then
			cmd:End()
			self.coCmds[cmdClass.__cname] = nil
		end
	end
end