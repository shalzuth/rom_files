FunctionPlayerDistance = class("FunctionPlayerDistance")

-- FunctionPlayerDistance.AreaRange = GameConfig.Optimized.Shieldingrange

FunctionPlayerDistance.CreatureType = {
	SceneUser = 1,
	SceneNpc = 2,
}

function FunctionPlayerDistance.Me()
	if nil == FunctionPlayerDistance.me then
		FunctionPlayerDistance.me = FunctionPlayerDistance.new()
	end
	return FunctionPlayerDistance.me
end

function FunctionPlayerDistance:ctor()
	self.reason = PUIVisibleReason.OutOfMyRange
	self.flag = FunctionPlayerDistance.CreatureType.SceneUser
end

function FunctionPlayerDistance:Launch()
	if self.timeTick == nil then
		self.timeTick = TimeTickManager.Me():CreateTick(0,500,self.SelfUpdate,self)
	end
end

function FunctionPlayerDistance:SelfUpdate(deltaTime)
	if Game.Myself ~= nil and Game.Myself.assetRole ~= nil and Game.Myself.data ~= nil then		
		self:Update(deltaTime)
	end
end

function FunctionPlayerDistance:Update(deltaTime)
	local maskRange = Game.MapManager:GetCreatureMaskRange()
	if maskRange == 0 then
		return
	end
	local pos = Game.Myself:GetPosition()
	local roles
	if self.flag == FunctionPlayerDistance.CreatureType.SceneUser then
		roles = NSceneUserProxy.Instance:GetAll()
		self.flag = FunctionPlayerDistance.CreatureType.SceneNpc

	elseif self.flag == FunctionPlayerDistance.CreatureType.SceneNpc then
		roles = NSceneNpcProxy.Instance:GetAll()
		self.flag = FunctionPlayerDistance.CreatureType.SceneUser
	end

	for k,v in pairs(roles) do
		if Game.Myself.data.id ~= k and v ~= nil then
			if VectorUtility.DistanceXZ( pos, v:GetPosition() ) <= maskRange then
				self:UnMaskUI(v)
			else
				self:MaskUI(v)
			end
		end
	end
end

function FunctionPlayerDistance:MaskUI(creature)
	FunctionPlayerUI.Me():MaskHurtNum(creature,self.reason,false)
	FunctionPlayerUI.Me():MaskChatSkill(creature,self.reason,false)
	FunctionPlayerUI.Me():MaskEmoji(creature,self.reason,false)
end

function FunctionPlayerDistance:UnMaskUI(creature)
	FunctionPlayerUI.Me():UnMaskHurtNum(creature,self.reason,false)
	FunctionPlayerUI.Me():UnMaskChatSkill(creature,self.reason,false)
	FunctionPlayerUI.Me():UnMaskEmoji(creature,self.reason,false)
end