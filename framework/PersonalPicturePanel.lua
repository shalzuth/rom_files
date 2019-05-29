autoImport("PersonalListPage")
autoImport("SceneryListPage")
PersonalPicturePanel = class("PersonalPicturePanel", ContainerView)
PersonalPicturePanel.GetPersonPicThumbnail = "PersonalPicturePanel_GetPersonPicThumbnail"
PersonalPicturePanel.ReplacePersonPicThumbnail = "PersonalPicturePanel_ReplacePersonPicThumbnail"
PersonalPicturePanel.ReUploadingPersonPicThumbnail = "PersonalPicturePanel_ReUploadingPersonPicThumbnail"
PersonalPicturePanel.DelPersonPicThumbnail = "PersonalPicturePanel_DelPersonPicThumbnail"
PersonalPicturePanel.CancelPersonPicThumbnail = "PersonalPicturePanel_CancelPersonPicThumbnail"
PersonalPicturePanel.Album = {PersonalAlbum = 1, SceneryAlbum = 2}
PersonalPicturePanel.ViewType = UIViewType.Lv4PopUpLayer
PersonalPicturePanel.ShowMode = {
  ReplaceMode = 1,
  EditorMode = 2,
  NormalMode = 3
}
function PersonalPicturePanel:Init()
  self:initView()
  self:initData()
end
function PersonalPicturePanel:OnEnter()
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(false)
  self.bgTexture = self:FindComponent("bgTexture", UITexture)
  self.bgTexName = "bg_view_1"
  if self.bgTexture then
    PictureManager.Instance:SetUI(self.bgTexName, self.bgTexture)
    PictureManager.ReFitFullScreen(self.bgTexture, 1)
  end
  if self.bgTexture then
    local panel = self.bgTexture.gameObject.transform.parent.parent
    OverseaHostHelper:FixAnchor(self.bgTexture.leftAnchor, panel, 0, 0)
    OverseaHostHelper:FixAnchor(self.bgTexture.rightAnchor, panel, 1, 0)
    OverseaHostHelper:FixAnchor(self.bgTexture.topAnchor, panel, 1, 0)
    OverseaHostHelper:FixAnchor(self.bgTexture.bottomAnchor, panel, 0, 0)
  end
end
function PersonalPicturePanel:OnExit()
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(true)
  if self.SceneryListPage then
    self.SceneryListPage:OnExit()
  end
  if self.PersonalListPage then
    self.PersonalListPage:OnExit()
  end
  if self.bgTexture then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTexture)
  end
end
function PersonalPicturePanel:initData()
  ServicePhotoCmdProxy.Instance:CallQueryUserPhotoListPhotoCmd()
  if self.viewdata.viewdata then
    self.showMode = self.viewdata.viewdata.ShowMode
    self.callback = self.viewdata.viewdata.callback
  end
  self.showMode = self.showMode and self.showMode or PersonalPicturePanel.ShowMode.NormalMode
  if self.showMode == PersonalPicturePanel.ShowMode.ReplaceMode then
    self:Hide(self:FindGO("SceneryTab"))
  else
    self.SceneryListPage = self:AddSubView("SceneryListPage", SceneryListPage)
  end
end
function PersonalPicturePanel:initView()
  self:AddTabChangeEvent(self:FindGO("PersonalTab"), self:FindGO("PersonalListPage"), PersonalPicturePanel.Album.PersonalAlbum)
  self:AddTabChangeEvent(self:FindGO("SceneryTab"), self:FindGO("SceneryListPage"), PersonalPicturePanel.Album.SceneryAlbum)
  self.PersonalListPage = self:AddSubView("PersonalListPage", PersonalListPage)
  self.PersonalTabLabel = self:FindComponent("PersonalTabLabel", UILabel)
  self.SceneryTabLabel = self:FindComponent("SceneryTabLabel", UILabel)
  self:TabChangeHandler(PersonalPicturePanel.Album.PersonalAlbum)
end
local tempColor = LuaColor(0.14901960784313725, 0.2823529411764706, 0.5803921568627451)
function PersonalPicturePanel:handleCategoryClick(key)
  self:handleCategorySelect(key)
  if key == PersonalPicturePanel.Album.PersonalAlbum then
    self.PersonalTabLabel.effectStyle = UILabel.Effect.Outline8
    self.PersonalTabLabel.effectColor = tempColor
    self.SceneryTabLabel.effectStyle = UILabel.Effect.None
  elseif key == PersonalPicturePanel.Album.SceneryAlbum then
    self.PersonalTabLabel.effectStyle = UILabel.Effect.None
    self.SceneryTabLabel.effectColor = tempColor
    self.SceneryTabLabel.effectStyle = UILabel.Effect.Outline8
  end
end
function PersonalPicturePanel:handleCategorySelect(key)
  if key == PersonalPicturePanel.Album.PersonalAlbum then
  elseif key == PersonalPicturePanel.Album.SceneryAlbum and self.SceneryListPage then
    self.SceneryListPage:ResetPosition()
  end
end
function PersonalPicturePanel:TabChangeHandler(key)
  if self.currentKey ~= key then
    PersonalPicturePanel.super.TabChangeHandler(self, key)
    self:handleCategoryClick(key)
    self.currentKey = key
  end
end
