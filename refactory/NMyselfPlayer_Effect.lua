local ChangeJobEffectWeakKey = "ChangeJobEffectWeakKey"
function NMyselfPlayer:OnObserverEffectDestroyed(key,effect)
	if(key == ChangeJobEffectWeakKey) then
		self:ChangeJobEnd()
	end
end

--转职
function NMyselfPlayer:PlayChangeJob()
	FunctionSystem.InterruptMyself()
	self:_PlayChangeJobBeginEffect()
end

function NMyselfPlayer:_PlayChangeJobBeginEffect()
	local effect = NMyselfPlayer.super._PlayChangeJobBeginEffect(self)
	self:SetWeakData(ChangeJobEffectWeakKey,effect)
end

function NMyselfPlayer:ChangeJobEnd()
	GameFacade.Instance:sendNotification(MyselfEvent.ChangeJobEnd, nil)
end