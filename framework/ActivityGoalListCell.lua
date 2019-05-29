local baseCell = autoImport("BaseCell")
ActivityGoalListCell = class("ActivityGoalListCell", baseCell)
function ActivityGoalListCell:Init()
  self:initView()
end
function ActivityGoalListCell:initView()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.goalName = self:FindComponent("GoalName", UILabel)
  self.goalProgress = self:FindComponent("GoalProgress", UILabel)
  self.lightUpAlreaday = self:FindComponent("LightUpAlreaday", UILabel)
  self.lightButton = self:FindGO("LightButton")
  self:AddButtonEvent("LightButton", function()
    ServicePuzzleCmdProxy.Instance:CallActivePuzzleCmd(self.data.ActivityID, self.data.PuzzleID)
  end)
  self.goButton = self:FindGO("GOButton")
  self:AddButtonEvent("GOButton", function()
    if self.data.GotoMode ~= _EmptyTable then
      self:PassEvent(ActivityPuzzleGoEvent.MouseClick, self)
    end
  end)
  self:AddCellClickEvent()
end
function ActivityGoalListCell:SetData(data)
  self.data = data
  self.goalName.text = data.Desc
  local atlas = self.data.Atlas
  atlas = UIAtlasConfig.IconAtlas[atlas]
  if not atlas or not atlas then
    atlas = UIAtlasConfig.IconAtlas.uiicon
  end
  if atlas == "" or data.Icon == "" then
    IconManager:SetItemIcon("item_45001", self.icon)
  else
    IconManager:SetIcon(data.Icon, self.icon, atlas)
  end
  local itemData = ActivityPuzzleProxy.Instance:GetActivityPuzzleItemData(data.ActivityID, data.PuzzleID)
  local trim = 0
  if itemData then
    if data.UnlockTime then
      if itemData.process then
        trim = itemData.process > data.UnlockTime and data.UnlockTime or itemData.process
        self.goalProgress.text = trim .. "/" .. data.UnlockTime
      else
        self.goalProgress.text = "0/" .. data.UnlockTime
      end
    else
      self.goalProgress.text = ""
    end
    if itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_CANACTIVE then
      self.goButton:SetActive(false)
      self.lightButton:SetActive(true)
      self.lightUpAlreaday.gameObject:SetActive(false)
    elseif itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_UNACTIVE then
      self.goButton:SetActive(true)
      self.lightButton:SetActive(false)
      self.lightUpAlreaday.gameObject:SetActive(false)
    elseif itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_ACTIVE then
      self.goButton:SetActive(false)
      self.lightButton:SetActive(false)
      self.lightUpAlreaday.gameObject:SetActive(true)
    else
      self.goButton:SetActive(true)
      self.lightButton:SetActive(false)
      self.lightUpAlreaday.gameObject:SetActive(false)
    end
  else
    self.goButton:SetActive(true)
    self.lightButton:SetActive(false)
    self.lightUpAlreaday.gameObject:SetActive(false)
    self.goalProgress.text = "0/" .. data.UnlockTime
  end
  if self.data.GotoMode == nil or self.data.GotoMode == _EmptyTable then
    self.goButton:SetActive(false)
  end
end
