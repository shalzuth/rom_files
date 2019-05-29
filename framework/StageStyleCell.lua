local BaseCell = autoImport("BaseCell")
StageStyleCell = class("StageStyleCell", BaseCell)
function StageStyleCell:Init()
  self.pic = self:FindGO("style"):GetComponent(UITexture)
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.bg = self:FindGO("bg"):GetComponent(UITexture)
  self:AddCellClickEvent()
end
function StageStyleCell:SetData(data)
  if not data then
    return
  end
  self.data = data
  self.name.text = self.data.name
  if self.data.picPath then
    PictureManager.Instance:SetStagePart(self.data.picPath, self.pic)
  end
  PictureManager.Instance:SetStagePart("ui_stage_bg_JM", self.bg)
end
function StageStyleCell:OnDestroy()
  PictureManager.Instance:UnLoadStagePart(self.data.picPath, self.pic)
  PictureManager.Instance:UnLoadStagePart("ui_stage_bg_JM", self.bg)
end
