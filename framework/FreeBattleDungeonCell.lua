FreeBattleDungeonCell = class("FreeBattleDungeonCell", BaseCell)
FreeBattleDungeonCell.TexDungeonName = "pvp_dungeon_"
function FreeBattleDungeonCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end
function FreeBattleDungeonCell:FindObjs()
  self.labDungeonName = self:FindComponent("labDungeonName", UILabel)
  self.texDungeon = self:FindComponent("texDungeon", UITexture)
  self.objSelect = self:FindGO("objSelect")
end
function FreeBattleDungeonCell:SetData(data)
  if self.texName then
    PictureManager.Instance:UnLoadPVP(self.texName, self.texDungeon)
  end
  self.gameObject:SetActive(data and true or false)
  if not data then
    return
  end
  self.id = data.id
  self.labDungeonName.text = data.Name
  self.texName = string.format("%s%s", FreeBattleDungeonCell.TexDungeonName, self.id)
  PictureManager.Instance:SetPVP(self.texName, self.texDungeon)
end
function FreeBattleDungeonCell:Select(isSelect)
  self.objSelect:SetActive(isSelect)
end
