SkillOptionManager = class("SkillOptionManager")

function SkillOptionManager:ctor()
	self._options = {}
	self._callBacks = {}
	self:AddChangeCallBack(SceneSkill_pb.ESKILLOPTION_AUTOQUEUE,self.HandleSkillAutoQueue)
end

function SkillOptionManager:AddChangeCallBack(t,func)
	self._callBacks[t] = func
end

function SkillOptionManager:GetSkillOptionByType(t)
	return self._options[t] or 0
end

function SkillOptionManager:AskSetSkillOption(t,value)
	if(value>=0) then
		local opt = SceneSkill_pb.SkillOption()
		opt.opt = t
		opt.value = value
		ServiceSkillProxy.Instance:CallSkillOptionSkillCmd(opt)
	end
end

function SkillOptionManager:RecvServerOpts(opts)
	if(opts~=nil and #opts>0) then
		for i=1,#opts do
			self:HandleOpt(opts[i].opt,opts[i].value)
		end
	end
end

function SkillOptionManager:HandleOpt(t,value)
	local callBack = self._callBacks[t]
	local oldValue = self._options[t]
	if(oldValue == nil) then
		oldValue = 0
	end
	self._options[t] = value
	if(callBack) then
		callBack(self,oldValue,value)
	end
end

function SkillOptionManager:GetSkillOption_AutoQueue()
	return self:GetSkillOptionByType(SceneSkill_pb.ESKILLOPTION_AUTOQUEUE)
end

function SkillOptionManager:SetSkillOption_AutoQueue(value)
	self:AskSetSkillOption(SceneSkill_pb.ESKILLOPTION_AUTOQUEUE,value == true and 0 or 1)
end

function SkillOptionManager:GetSkillOption_SummonBeing()
	return self:GetSkillOptionByType(SceneSkill_pb.ESKILLOPTION_SUMMONBEING)
end

function SkillOptionManager:SetSkillOption_SummonBeing(value)
	self:AskSetSkillOption(SceneSkill_pb.ESKILLOPTION_SUMMONBEING,value)
end

function SkillOptionManager:HandleSkillAutoQueue(oldValue,newValue)
	if(newValue ==0) then
		Game.SkillClickUseManager:Launch()
	else
		Game.SkillClickUseManager:ShutDown()
	end
end