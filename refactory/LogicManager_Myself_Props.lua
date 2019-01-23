LogicManager_Myself_Props = class("LogicManager_Myself_Props",LogicManager_Player_Props)

function LogicManager_Myself_Props:ctor()
	LogicManager_Myself_Props.super.ctor(self)
	self:AddUpdateCall("StateEffect",self.UpdateStateEffect)
end

function LogicManager_Myself_Props:ResetProps()
	local myProps = Game.Myself.data.props
	myProps:ResetAllProps()
	local myself = Game.Myself
	local propName,p,propID
	local _NameMapID = LogicManager_Creature_Props.NameMapID
	for _, o in pairs(RolePropsContainer.config) do
		propName = o.name
		p = myProps:GetPropByName(propName)
		propID = _NameMapID[propName]
		self:CheckPropUpdateCall(myself,propID,0,p)
	end
end

function LogicManager_Myself_Props:_DirtyCall(ncreature,call,propName,oldValue,p)
	LogicManager_Myself_Props.super._DirtyCall(self,ncreature,call,propName,oldValue,p)
	FunctionCheck.Me():CheckProp(p)
	ncreature:Logic_CheckCanUseSkill(p)
end

function LogicManager_Myself_Props:CheckPropUpdateCall(ncreature,propName,oldValue,p)
	LogicManager_Myself_Props.super.CheckPropUpdateCall(self,ncreature,propName,oldValue,p)
	FunctionCheck.Me():CheckProp(p)
	ncreature:Logic_CheckCanUseSkill(p)
end

function LogicManager_Myself_Props:UpdateAttrEffect(ncreature,propName,oldValue,p)
	ncreature.data.attrEffect:Set(p:GetValue())
	GameFacade.Instance:sendNotification(MyselfEvent.UpdateAttrEffect)
end

function LogicManager_Myself_Props:UpdateTransformState(ncreature,propName,oldValue,p)
	LogicManager_Myself_Props.super.UpdateTransformState(self,ncreature,propName,oldValue,p)
	SkillProxy.Instance:ResetTransformSkills(p:GetValue())
	GameFacade.Instance:sendNotification(MyselfEvent.TransformChange)
	EventManager.Me():PassEvent(MyselfEvent.TransformChange)
end

function LogicManager_Myself_Props:UpdateHiding(ncreature,propName,oldValue,p)
	local visible = p:GetValue() > 0
	local partner = ncreature.partner
	ncreature:SetStealth (visible)
	if partner then
		partner:SetStealth (visible)
	end
end

function LogicManager_Myself_Props:UpdateSp(ncreature,propName,oldValue,p)
	LogicManager_Myself_Props.super.UpdateSp(self,ncreature,propName,oldValue,p)
	EventManager.Me():PassEvent(MyselfEvent.SpChange,p:GetValue())
end

function LogicManager_Myself_Props:UpdateHp(ncreature,propName,oldValue,p)
	LogicManager_Myself_Props.super.UpdateHp(self,ncreature,propName,oldValue,p)
	EventManager.Me():PassEvent(MyselfEvent.HpChange,p:GetValue())
end

function LogicManager_Myself_Props:UpdateStateEffect(ncreature,propName,oldValue,p)
	ItemsWithRoleStatusChange:Instance():OnReceiveStatusChange(p)
end