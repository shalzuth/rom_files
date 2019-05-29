autoImport("RatingCell")
ActivityDungeonRate = class("ActivityDungeonRate", SubView)
local EvaConfig = GameConfig.EVA
local ratinglist = EvaConfig.time_rank_desc
function ActivityDungeonRate:Init()
  self:InitUI()
  self:SetRating()
  self:AddListen()
end
local tempVector3 = LuaVector3.zero
function ActivityDungeonRate:InitUI()
  self.rategrid = self:FindGO("rateGrid"):GetComponent(UIGrid)
  self.rateCtl = UIGridListCtrl.new(self.rategrid, RatingCell, "RatingCell")
  local headCellObj = self:FindGO("playercontainer")
  headCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), headCellObj)
  tempVector3:Set(0, 0, 0)
  headCellObj.transform.localPosition = tempVector3
  self.targetCell = PlayerFaceCell.new(headCellObj)
  self.targetCell:HideLevel()
  self.targetCell:HideHpMp()
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  self.targetCell:SetData(headData)
  local playername = self:FindGO("playername"):GetComponent(UILabel)
  playername.text = Game.Myself.data:GetName()
  local playerlv = self:FindGO("playerlv"):GetComponent(UILabel)
  playerlv.text = "LV." .. Game.Myself.data:GetBaseLv()
  self.myrate = self:FindGO("myrate")
  self.mymedal = self:FindGO("mymedal"):GetComponent(UIMultiSprite)
  self.mytitle = self:FindGO("mytitle"):GetComponent(UILabel)
  self.titlebg = self:FindGO("titlebg"):GetComponent(UISprite)
  self.rate = DungeonProxy.Instance:GetMyRate()
  self.myrate:SetActive(self.rate ~= 0)
  if self.rate ~= 0 then
    self.mymedal.CurrentState = self.rate - 1
    self.mytitle.text = ratinglist[self.rate].title
    self.titlebg.width = self.mytitle.width + 20
  end
end
function ActivityDungeonRate:SetRating()
  redlog("SetRating")
  self.rateCtl:ResetDatas(ratinglist)
  self.rate = DungeonProxy.Instance:GetMyRate()
  self.myrate:SetActive(self.rate ~= 0)
  if self.rate ~= 0 then
    self.mymedal.CurrentState = self.rate - 1
    self.mytitle.text = ratinglist[self.rate].title
    self.titlebg.width = self.mytitle.width + 20
  end
end
function ActivityDungeonRate:AddListen()
  self:AddListenEvt(ServiceEvent.NUserAltmanRewardUserCmd, self.SetRating)
end
function ActivityDungeonRate:OnExit()
  self.super.OnExit(self)
end
