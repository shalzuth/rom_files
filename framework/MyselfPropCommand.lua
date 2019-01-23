local MyselfPropCommand = class("MyselfPropCommand",pm.SimpleCommand)

function MyselfPropCommand:execute(note)
	local data = note.body
	self.myself = Game.Myself
	if(data.type == SceneUser_pb.EUSERSYNCTYPE_INIT) then
		self:InitProp(data)
	elseif(data.type == SceneUser_pb.EUSERSYNCTYPE_SYNC) then
		self:UpdateProp(data)
	end
	
end

function MyselfPropCommand:InitProp(data)
	-- print("InitProp---Start----")
	Game.LogicManager_Myself_Props:ResetProps()
	MyselfProxy.Instance:SetProps(data)
	-- local male = self.myself.userData:Get(UDEnum.SEX)
	-- local body = self.myself.userData:Get(UDEnum.BODY)
	-- local hair = self.myself.userData:Get(UDEnum.HAIR)
	-- local rightHand = self.myself.userData:Get(UDEnum.RIGHTHAND)
	-- local accessory = self.myself.userData:Get(UDEnum.HEAD)
	-- local wing = self.myself.userData:Get(UDEnum.WING)
	-- print("InitProp---End----")
	-- print("my role-->id:"..self.myself.id.." hair:"..hair.." rightHand:"..rightHand.." body:"..body.." accessory"..accessory
	-- 	.." wing"..wing.." gender:"..male)
	-- self.myself:InitAvartar()
	-- self.myself:ResetNormalAtk()
	-- self.myself:ResetMyCollectSkill()
	local pro = self.myself.data.userdata:Get(UDEnum.PROFESSION)
	-- print("我的职业-"..pro)
	BagProxy.Instance:SetProToEquipTab(pro)
end

function MyselfPropCommand:UpdateProp(data)
	-- print("updateProp---Start----")
	MyselfProxy.Instance:SetProps(data,true)
	-- print("updateProp---End----")
	if(data.attrs ~= nil and #data.attrs >0) then
		GameFacade.Instance:sendNotification(MyselfEvent.MyPropChange, data.attrs)
	end

	if(data.datas ~= nil and #data.datas >0) then
		GameFacade.Instance:sendNotification(MyselfEvent.MyDataChange, data.datas)
	end

	GameFacade.Instance:sendNotification(MyselfEvent.MyAttrChange, UserAttrSyncCmd)
	GameFacade.Instance:sendNotification(MyselfEvent.PropChange, MyselfProxy.Instance.myself)
end

return MyselfPropCommand