LogicManager_Creature_Props = class("LogicManager_Creature_Props")

if(LogicManager_Creature_Props.NameMapID == nil) then
	local map = {}
	for k,v in pairs(Table_RoleData) do
		map[v.VarName] = v.id
	end
	LogicManager_Creature_Props.NameMapID = map
end

function LogicManager_Creature_Props:ctor()
	self.dirtyCalls = {}
	self.updateCalls = {}
	--dirty begin
	self:AddDirtyCall("Hp",self.UpdateHp)
	self:AddDirtyCall("MaxHp",self.UpdateHp)
	self:AddDirtyCall("Sp",self.UpdateSp)
	self:AddDirtyCall("MaxSp",self.UpdateMaxSp)
	self:AddDirtyCall("FearRun",self.UpdateFearRun)
	self:AddDirtyCall("NoAct",self.UpdateNoAct)
	self:AddDirtyCall("Freeze",self.UpdateFreeze)
	--dirty end

	self:AddUpdateCall("AtkSpd",self.UpdateAtkSpd)
	self:AddUpdateCall("MoveSpd",self.UpdateMoveSpd)
	self:AddUpdateCall("NoStiff",self.UpdateNoStiff)
	self:AddUpdateCall("NoAttack",self.UpdateNoAttack)
	self:AddUpdateCall("NoAttacked",self.UpdateNoAttacked)
	self:AddUpdateCall("NoSkill",self.UpdateNoSkill)
	self:AddUpdateCall("NoMove",self.UpdateNoMove)
	self:AddUpdateCall("Hiding",self.UpdateHiding)
	self:AddUpdateCall("AttrEffect",self.UpdateAttrEffect)
	self:AddUpdateCall("AttrEffect2",self.UpdateAttrEffect2)
	self:AddUpdateCall("SlimHeight",self.UpdateSlimHeight)
	self:AddUpdateCall("SlimWeight",self.UpdateSlimWeight)
end

function LogicManager_Creature_Props:IsDirty(id)
	return self.dirtyCalls[id] ~= nil
end

--func(ncreature,userData id,oldValue,p)
function LogicManager_Creature_Props:AddDirtyCall(name,func)
	self.dirtyCalls[LogicManager_Creature_Props.NameMapID[name]] = func
end

--func(ncreature,userData id,oldValue,p)
function LogicManager_Creature_Props:AddUpdateCall(name,func)
	self.updateCalls[LogicManager_Creature_Props.NameMapID[name]] = func
end

function LogicManager_Creature_Props:CheckDirtyDatas(ncreature)
	local props = ncreature.data.props
	local call
	if(props and props.hasDirtyDatas) then
		for k,v in pairs(props.dirtyIDs) do
			call = self.dirtyCalls[k]
			self:_DirtyCall(ncreature,call,k,v,props:GetPropByID(k))
			props.dirtyIDs[k] = nil
		end
		props.hasDirtyDatas = false
	end
end

function LogicManager_Creature_Props:_DirtyCall(ncreature,call,propName,oldValue,p)
	if(call~=nil) then
		call(self,ncreature,propName,oldValue,p)
	end
end

function LogicManager_Creature_Props:CheckPropUpdateCall(ncreature,propName,oldValue,p)
	local call = self.updateCalls[propName]
	if(call) then
		call(self,ncreature,propName,oldValue,p)
	end
end

function LogicManager_Creature_Props:UpdateHp(ncreature,propName,oldValue,p)
	local ui = ncreature:GetSceneUI()
	if(ui) then
		ui.roleBottomUI:SetHp(ncreature)
	end
end

function LogicManager_Creature_Props:UpdateSp(ncreature,propName,oldValue,p)
	local ui = ncreature:GetSceneUI()
	if(ui) then
		ui.roleBottomUI:SetSp(ncreature)
	end
end

function LogicManager_Creature_Props:UpdateMaxSp(ncreature,propName,oldValue,p)
	local ui = ncreature:GetSceneUI()
	if(ui) then
		ui.roleBottomUI:SetSp(ncreature)
	end
end

function LogicManager_Creature_Props:UpdateAtkSpd(ncreature,propName,oldValue,p)
	ncreature:Server_SetAtkSpeed(p:GetValue())
end

function LogicManager_Creature_Props:UpdateMoveSpd(ncreature,propName,oldValue,p)
	ncreature:Server_SetMoveSpeed(p:GetValue())
end

function LogicManager_Creature_Props:UpdateNoStiff(ncreature,propName,oldValue,p)
	ncreature.data.noStiff = ncreature.data:PlusClientProp(p)
end

function LogicManager_Creature_Props:UpdateNoAttack(ncreature,propName,oldValue,p)
	ncreature.data.noAttack = ncreature.data:PlusClientProp(p)
end

function LogicManager_Creature_Props:UpdateNoAttacked(ncreature,propName,oldValue,p)
	ncreature.data.noAttacked = ncreature.data:PlusClientProp(p)
end

function LogicManager_Creature_Props:UpdateNoSkill(ncreature,propName,oldValue,p)
	ncreature.data.noSkill = ncreature.data:PlusClientProp(p)
end

function LogicManager_Creature_Props:UpdateNoMove(ncreature,propName,oldValue,p)
	ncreature.data.noMove = ncreature.data:PlusClientProp(p)
end

function LogicManager_Creature_Props:UpdateHiding(ncreature,propName,oldValue,p)
	if(1 > p:GetValue()) then
		ncreature:Show()
	else
		ncreature:Hide()
	end
	EventManager.Me():PassEvent(CreatureEvent.Hiding_Change,ncreature.data.id)
end

function LogicManager_Creature_Props:UpdateFearRun(ncreature,propName,oldValue,p)
	ncreature:Logic_FearRun(0 < p:GetValue())
end

function LogicManager_Creature_Props:UpdateNoAct(ncreature,propName,oldValue,p)
	ncreature:Logic_NoAct(0 < p:GetValue())
end

function LogicManager_Creature_Props:UpdateFreeze(ncreature,propName,oldValue,p)
	ncreature:Logic_Freeze(0 < p:GetValue())
end

function LogicManager_Creature_Props:UpdateAttrEffect(ncreature,propName,oldValue,p)
	ncreature.data.attrEffect:Set(p:GetValue())
end

function LogicManager_Creature_Props:UpdateAttrEffect2(ncreature,propName,oldValue,p)
	ncreature.data.attrEffect2:Set(p:GetValue())
end

function LogicManager_Creature_Props:UpdateSlimHeight(ncreature,propName,oldValue,p)
	ncreature:Server_SetFixHeightCmd(p:GetValue())
end

function LogicManager_Creature_Props:UpdateSlimWeight(ncreature,propName,oldValue,p)
	ncreature:Server_SetFixWeightCmd(p:GetValue())
end