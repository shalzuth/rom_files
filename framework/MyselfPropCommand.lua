local MyselfPropCommand = class("MyselfPropCommand", pm.SimpleCommand)
function MyselfPropCommand:execute(note)
  local data = note.body
  self.myself = Game.Myself
  if data.type == SceneUser_pb.EUSERSYNCTYPE_INIT then
    self:InitProp(data)
  elseif data.type == SceneUser_pb.EUSERSYNCTYPE_SYNC then
    self:UpdateProp(data)
  end
end
function MyselfPropCommand:InitProp(data)
  Game.LogicManager_Myself_Props:ResetProps()
  MyselfProxy.Instance:SetProps(data)
  local pro = self.myself.data.userdata:Get(UDEnum.PROFESSION)
  BagProxy.Instance:SetProToEquipTab(pro)
end
function MyselfPropCommand:UpdateProp(data)
  MyselfProxy.Instance:SetProps(data, true)
  if data.attrs ~= nil and #data.attrs > 0 then
    GameFacade.Instance:sendNotification(MyselfEvent.MyPropChange, data.attrs)
  end
  if data.datas ~= nil and 0 < #data.datas then
    GameFacade.Instance:sendNotification(MyselfEvent.MyDataChange, data.datas)
  end
  GameFacade.Instance:sendNotification(MyselfEvent.MyAttrChange, UserAttrSyncCmd)
  GameFacade.Instance:sendNotification(MyselfEvent.PropChange, MyselfProxy.Instance.myself)
end
return MyselfPropCommand
