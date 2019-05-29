local BaseCell = autoImport("BaseCell")
MaintenanceMsgCell = class("MaintenanceMsgCell", BaseCell)
autoImport("CloudFileLuaManager")
MaintenanceMsgCell.CellType = {
  MainTite = "mainTitle",
  SubTitle = "subTitle",
  Content = "content",
  Pictures = "pictures"
}
function MaintenanceMsgCell:Init()
  self:FindObjs()
end
function MaintenanceMsgCell:FindObjs()
  self.mainTitle = self:FindGO("MainTitle")
  self.mainTitleLabel = self:FindComponent("MainTitleLabel", UILabel)
  self.subTitle = self:FindGO("SubTitle")
  self.subMainTitle = self:FindComponent("SubMainTitle", UILabel)
  self.subSubTitle = self:FindComponent("SubSubTitle", UILabel)
  self.content = self:FindGO("Content")
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  self.pictures = self:FindGO("Pictures")
  self.pictureCount1 = self:FindGO("Picture1")
  self.pictureCount2 = self:FindGO("Picture2")
  self.pictureCount3 = self:FindGO("Picture3")
  self.texture11 = self:FindComponent("Texture11", UITexture)
  self.texture21 = self:FindComponent("Texture21", UITexture)
  self.texture22 = self:FindComponent("Texture22", UITexture)
  self.texture31 = self:FindComponent("Texture31", UITexture)
  self.texture32 = self:FindComponent("Texture32", UITexture)
  self.texture33 = self:FindComponent("Texture33", UITexture)
  local titleIcon = self:FindGO("MainTitleIcon", self.mainTitle):GetComponent(UISprite)
  IconManager:SetItemIcon("item_45424", titleIcon)
end
function MaintenanceMsgCell:SetData(data)
  self.data = data
  self.mainTitle:SetActive(false)
  self.subTitle:SetActive(false)
  self.content:SetActive(false)
  self.pictures:SetActive(false)
  self.pictureCount1:SetActive(false)
  self.pictureCount2:SetActive(false)
  self.pictureCount3:SetActive(false)
  self.downloadRecord = {}
  local dataList = string.split(self.data, "////")
  if #dataList > 0 then
    local cellType = dataList[1]
    if cellType == MaintenanceMsgCell.CellType.MainTite then
      if #dataList > 1 then
        self.mainTitleLabel.text = dataList[2]
      end
      self.mainTitle:SetActive(true)
    elseif cellType == MaintenanceMsgCell.CellType.SubTitle then
      if #dataList > 2 then
        self.subMainTitle.text = dataList[2]
        self.subSubTitle.text = dataList[3]
      end
      self.subTitle:SetActive(true)
    elseif cellType == MaintenanceMsgCell.CellType.Content then
      if #dataList > 1 then
        self.contentLabel.text = dataList[2]
      end
      self.content:SetActive(true)
    elseif cellType == MaintenanceMsgCell.CellType.Pictures then
      self.pictures:SetActive(true)
      if #dataList == 2 then
        self.pictureCount1:SetActive(true)
        self:Download(dataList[2], self.texture11, 730, 100)
      elseif #dataList == 3 then
        self.pictureCount2:SetActive(true)
        self:Download(dataList[2], self.texture21, 355, 100)
        self:Download(dataList[3], self.texture22, 355, 100)
      elseif #dataList == 4 then
        self.pictureCount3:SetActive(true)
        self:Download(dataList[2], self.texture31, 230, 100)
        self:Download(dataList[3], self.texture32, 230, 100)
        self:Download(dataList[4], self.texture33, 230, 100)
      end
    end
  end
end
function MaintenanceMsgCell:Download(url, texture, width, height)
  local newUrl = string.gsub(url, "&amp;", "&")
  self.downloadRecord[#self.downloadRecord + 1] = {
    Url = newUrl,
    Tex = texture,
    Width = width,
    Height = height
  }
  ActivityTextureManager.Instance():AddActivityPicInfos({newUrl})
end
function MaintenanceMsgCell:OnDownloadComplete(url, bytes)
  for i = 1, #self.downloadRecord do
    if self.downloadRecord[i].Url == url then
      local pic = Texture2D(self.downloadRecord[i].Width, self.downloadRecord[i].Height, TextureFormat.RGB24, false)
      local bRet = ImageConversion.LoadImage(pic, bytes)
      local texture = self.downloadRecord[i].Tex
      if texture then
        texture.mainTexture = pic
        texture:MakePixelPerfect()
        local hwRatio = texture.height / texture.width
        texture.width = self.downloadRecord[i].Width
        texture.height = texture.width * hwRatio
      end
    end
  end
end
