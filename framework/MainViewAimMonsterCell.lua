local baseCell = autoImport("BaseCell")
MainViewAimMonsterCell = class("MainViewAimMonsterCell", baseCell)
MainViewAimMonsterCellEvent = {
  ValueChange = "MainViewAimMonsterCellEvent_ValueChange",
  BossCellHasSet = "MainViewAimMonsterCellEvent_BossCellHasSet"
}
function MainViewAimMonsterCell:Init()
  self:FindObjs()
  self:InitShow()
  self:AddCellClickEvent()
end
function MainViewAimMonsterCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.level = self:FindGO("Level"):GetComponent(UILabel)
  self.choose = self:FindComponent("choose", UIToggle)
  self.all = self:FindGO("All")
end
function MainViewAimMonsterCell:InitShow()
end
function MainViewAimMonsterCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local id = data:GetId()
    if id == 0 then
      self.all:SetActive(true)
      self.level.gameObject:SetActive(false)
      self.name.gameObject:SetActive(false)
      self.icon.gameObject:SetActive(false)
      self.choose.gameObject:SetActive(false)
    else
      self.all:SetActive(false)
      self.level.gameObject:SetActive(true)
      self.name.gameObject:SetActive(true)
      self.choose.gameObject:SetActive(true)
      local monster = Table_Monster[id]
      local boss = Table_Boss[id]
      if monster then
        self.level.text = "Lv." .. data:GetLevel()
        self.name.text = monster.NameZh
        local symbolName
        if data:GetBossType() == 3 then
          symbolName = "ui_mvp_dead11_JM"
        elseif monster.Type == "MVP" then
          symbolName = "map_mvpboss"
        elseif monster.Type == "MINI" then
          symbolName = "map_miniboss"
        end
        if boss and boss.Type == 3 then
          symbolName = "ui_mvp_dead11_JM"
        end
        if symbolName then
          IconManager:SetMapIcon(symbolName, self.icon)
          self.icon.gameObject:SetActive(true)
          EventManager.Me():PassEvent(MainViewAimMonsterCellEvent.BossCellHasSet, id)
        else
          self.icon.gameObject:SetActive(false)
        end
      end
    end
  end
end
function MainViewAimMonsterCell:GetChooseValue()
  return self.choose.value
end
function MainViewAimMonsterCell:SetChoose(isChoose)
  self.choose.value = isChoose
end
