PetComposePreviewPopUp = class("PetComposePreviewPopUp", ContainerView)
PetComposePreviewPopUp.ViewType = UIViewType.PopUpLayer
autoImport("PetComposePreviewCell")
PetComposePreviewPopUp.CellResID = ResourcePathHelper.UICell("PetComposePreviewCell")
function PetComposePreviewPopUp:Init(parent)
  self.petID = self.viewdata.viewdata
  self:FindObjs()
  self:SetData()
end
function PetComposePreviewPopUp:FindObjs()
  self.rootIcon = self:FindComponent("Root", UISprite)
end
local tempVector3 = LuaVector3.zero
function PetComposePreviewPopUp:SetData()
  if self.petID then
    self.gameObject:SetActive(true)
    IconManager:SetNpcMonsterIconByID(self.petID, self.rootIcon)
    local obj = Game.AssetManager_UI:CreateAsset(PetComposePreviewPopUp.CellResID, self.gameObject)
    tempVector3:Set(0, -288, 0)
    obj.transform.localPosition = tempVector3
    obj.transform:SetParent(self.rootIcon.gameObject.transform, false)
    self.root = PetComposePreviewCell.new(obj, self.petID, true)
    local nodeLvCount = self.root.data:GetNodeLevel()
    if nodeLvCount > 1 then
      tempVector3:Set(0, 209, 0)
    else
      tempVector3:Set(0, 155, 0)
    end
    self.rootIcon.gameObject.transform.localPosition = tempVector3
  else
    self.gameObject:SetActive(false)
  end
end
