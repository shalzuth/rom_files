autoImport("DropSceneItemCommand")
autoImport("PickUpDropItemCommand")
FunctionSceneItemCommand = class("FunctionSceneItemCommand")
function FunctionSceneItemCommand.Me()
  if nil == FunctionSceneItemCommand.me then
    FunctionSceneItemCommand.me = FunctionSceneItemCommand.new()
  end
  return FunctionSceneItemCommand.me
end
function FunctionSceneItemCommand:ctor()
  self.dropCmd = DropSceneItemCommand.Me()
  self.pickUpCmd = PickUpDropItemCommand.Me()
  self:Reset()
end
function FunctionSceneItemCommand:Reset()
  self:Clear()
end
function FunctionSceneItemCommand:Clear()
  self.dropCmd:Clear()
  self.dropCmd.onGroundCmd:Clear()
end
function FunctionSceneItemCommand:DropItems(items)
  self.dropCmd:AddItems(items)
end
function FunctionSceneItemCommand:PickUpItem(creature, itemGuid)
  if self.dropCmd:RemoveWaitDrop(itemGuid) == false and self.dropCmd:PickUpDropping(creature, itemGuid) == false then
    self.dropCmd.onGroundCmd:Pick(itemGuid, creature.data.id)
  end
end
function FunctionSceneItemCommand:SetRemoveFlag(guid)
  self.dropCmd:SetRemoveFlag(guid)
end
function FunctionSceneItemCommand:RemoveItems(items)
  self.dropCmd:RemoveItems(items)
end
