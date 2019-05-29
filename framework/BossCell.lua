local BaseCell = autoImport("BaseCell")
BossCell = class("BossCell", BaseCell)
BossIconType = {
  Mvp = "map_mvpboss",
  Mini = "map_miniboss",
  Dead = ""
}
local leftColor = LuaColor.New(0.6313725490196078, 0.6862745098039216, 0.8823529411764706, 1)
local rightColor = LuaColor.New(0.9176470588235294, 0.9607843137254902, 0.996078431372549, 1)
function BossCell:Init()
  self:FindObjs()
  self:AddEvts()
end
function BossCell:FindObjs()
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.level = self:FindGO("level"):GetComponent(UILabel)
  self.time = self:FindGO("time"):GetComponent(UILabel)
  self.btnKiller = self:FindGO("btnKiller")
  self.killer = self:FindGO("killer", self.btnKiller):GetComponent(UILabel)
  self.map = self:FindComponent("map", UILabel)
  self.icontype = self:FindComponent("icontype", UIMultiSprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol"):GetComponent(UIMultiSprite)
  self.bgSprite = self:FindGO("bg"):GetComponent(GradientUISprite)
  self.bg2 = self:FindGO("bg2"):GetComponent(UISprite)
  self.content = self:FindGO("Content")
  self.deadicon = self:FindGO("deadIcon")
  OverseaHostHelper:FixLabelOverV1(self.killer, 3, 200)
  OverseaHostHelper:FixLabelOverV1(self.time, 3, 100)
end
function BossCell:AddEvts()
  self:AddCellClickEvent()
  self:AddClickEvent(self.btnKiller, function()
    self:OnClickKillerName()
  end)
end
function BossCell:SetView(bossView)
  self.bossView = bossView
end
function BossCell:SetData(data)
  self.data = data
  if data then
    self.lv = data.lv
    self.content:SetActive(true)
    self.bosstype = data.bosstype
    local monster = Table_Monster[data.id]
    self:UpdateInfo(monster)
    local validID = false
    local collider = self.btnKiller:GetComponent(BoxCollider)
    if data.killerID and 0 ~= data.killerID and Game.Myself.data.id ~= data.killerID then
      self.killerID = data.killerID
      collider.enabled = true
      validID = true
    else
      self.killerID = nil
      collider.enabled = false
    end
    local killerName = data.killer and data.killer ~= "" and data.killer or "--"
    self.killer.text = validID and string.format("[u]%s[/u]", killerName) or killerName
    if validID then
      local size = self.killer.printedSize
      local vec = collider.size
      vec.x = size.x
      vec.y = size.y
      collider.size = vec
      vec = collider.center
      vec.x = size.x / 2
      collider.center = vec
    end
    if self.data.listtype ~= 2 then
      self:UpdateTime(data.time)
      self.dietime = data.dietime
    end
    self.setTime = data.settime
    local mapid = data.mapid or data.staticData.Map[1]
    if mapid then
      local mapdata = Table_Map[mapid]
      if mapdata then
        self.map.text = mapdata.CallZh
        UIUtil.WrapLabel(self.map)
      end
    end
    if self.data.listtype == 1 then
      self.bgSprite.gameObject:SetActive(true)
      self.bg2.gameObject:SetActive(false)
      self:UpdateDeadBossTime()
      if self.bosstype == 1 then
        self.icontype.CurrentState = 0
        self.bgSprite.gradientTop = LuaColor.white
        self.bgSprite.gradientBottom = LuaColor.white
      elseif self.bosstype == 2 then
        self.icontype.CurrentState = 1
        self.bgSprite.gradientTop = LuaColor.white
        self.bgSprite.gradientBottom = LuaColor.white
      elseif self.bosstype == 3 then
        self.icontype.CurrentState = 2
        self.bgSprite.gradientTop = leftColor
        self.bgSprite.gradientBottom = rightColor
      end
    elseif self.data.listtype == 2 then
      self.icontype.CurrentState = 2
      self.bgSprite.gameObject:SetActive(false)
      self.bg2.gameObject:SetActive(true)
      self.deadicon:SetActive(false)
      if self.setTime == 0 then
        self.time.text = ZhString.BossCell_ToSet
      else
        self.time.text = ZhString.BossCell_Set
      end
    end
    self.icontype.width = 30
    self.icontype.height = 30
    self:UpdateChoose()
  else
    self.content:SetActive(false)
  end
end
function BossCell:UpdateInfo(monsterData)
  IconManager:SetFaceIcon(monsterData.Icon, self.icon)
  if self.data.lv then
    self.level.text = "Lv." .. self.data.lv
  else
    self.level.text = "Lv." .. monsterData.Level
  end
end
function BossCell:UpdateTime(time)
  self.refreshTime = time
  if self.data.listtype == 2 then
    return
  end
  self:RemoveUpdateTime()
  if self.timeTick == nil then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTime, self, 1)
  end
end
function BossCell:_UpdateTime()
  if self.data.listtype == 2 then
    return
  end
  local time = self.refreshTime
  if time == nil then
    self:RemoveUpdateTime()
    return
  end
  local deltaTime = ServerTime.ServerDeltaSecondTime(time * 1000)
  if deltaTime <= 0 then
    self.time.text = ZhString.Boss_Show
  else
    self.time.text = string.format(ZhString.Boss_RefreshTimeM, math.max(1, math.ceil(deltaTime / 60)))
  end
end
function BossCell:RemoveUpdateTime()
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
end
function BossCell:SetChoose(chooseId, chooseMap)
  self.chooseId = chooseId
  self.chooseMap = chooseMap
  self:UpdateChoose()
end
function BossCell:UpdateChoose()
  if self.data and self.chooseId and self.data.id == self.chooseId and self.chooseMap and self.data.mapid == self.chooseMap then
    if self.bosstype == 1 or self.bosstype == 2 then
      self.chooseSymbol.CurrentState = 0
    elseif self.bosstype == 3 then
      self.chooseSymbol.CurrentState = 1
    end
    self.chooseSymbol.gameObject:SetActive(true)
  else
    self.chooseSymbol.gameObject:SetActive(false)
  end
end
function BossCell:OnClickKillerName()
  if self.bossView then
    self.bossView:OnClickCellKillerName(self)
  end
end
function BossCell:UpdateDeadBossTime()
  if self.setTime == 0 or self.bosstype == 2 then
    self.deadicon:SetActive(false)
    return
  end
  local delta = ServerTime.ServerDeltaSecondTime(self.refreshTime * 1000)
  self.deadicon:SetActive(delta <= 0 and self.data.summontime > self.data.dietime)
end
