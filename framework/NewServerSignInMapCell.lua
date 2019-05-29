local baseCell = autoImport("BaseCell")
NewServerSignInMapCell = class("NewServerSignInMapCell", baseCell)
NewServerSignInMapCell.State = {
  Unsigned = 0,
  Signed = 1,
  Barrier = 2,
  SmallGift = 3,
  LargeGift = 4
}
function NewServerSignInMapCell:ctor(obj, day)
  self.day = day
  NewServerSignInMapCell.super.ctor(self, obj)
end
function NewServerSignInMapCell:Init()
  self:FindObjs()
  self:SwitchToState(NewServerSignInMapCell.State.Unsigned)
end
function NewServerSignInMapCell:FindObjs()
  self.signedGO = self:FindGO("Signed")
  self.barrierGO = self:FindGO("Flag")
  self.smallGiftGO = self:FindGO("SmallGift")
  self.largeGiftGO = self:FindGO("LargeGift")
  local state = NewServerSignInMapCell.State
  self.stateGOs = {
    [state.Signed] = self.signedGO,
    [state.Barrier] = self.barrierGO,
    [state.SmallGift] = self.smallGiftGO,
    [state.LargeGift] = self.largeGiftGO
  }
end
function NewServerSignInMapCell:SwitchToState(state)
  for _, obj in pairs(self.stateGOs) do
    obj:SetActive(false)
  end
  local go = self.stateGOs[state]
  if go then
    go:SetActive(true)
  end
  self.state = state
end
