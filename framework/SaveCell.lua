autoImport("BaseCell")
SaveCell = class("SaveCell",BaseCell)

local blue = LuaColor.New(62/255, 88/255, 174/255, 1)

SaveCell.StatusChange = "SaveCell_StatusChange"
function SaveCell:Init()
	self:FindObjs()
	self:AddCellClickEvent()
	self:AddCellDoubleClickEvt()
	-- self:AddUnlcokEvt()

	self.selected = false
end

function SaveCell:FindObjs()
	self.bg = self.gameObject:GetComponent(UIMultiSprite)
	self.name = self:FindGO("name"):GetComponent(UILabel)
	self.time = self:FindGO("time"):GetComponent(UILabel)
	self.date = self:FindGO("date"):GetComponent(UILabel)
	self.icon = self:FindGO("icon"):GetComponent(UIMultiSprite)
	self.tip = self:FindGO("tip"):GetComponent(UILabel)
	self.selection = self:FindGO("selection"):GetComponent(UISprite)
	self.selection.gameObject:SetActive(false)
	self.rolename = self:FindGO("rolename"):GetComponent(UILabel)
end

function SaveCell:SetData(data)
	self.data = data
	self.id = data.id
	if data.status == 1 then
		if data.recordTime == 0 then
			self:SetSave()
		else
			self:SetInfo()
		end
	else
		if data.type == SceneUser2_pb.ESLOT_MONTH_CARD then
			self:SetTip()
		elseif data.type == SceneUser2_pb.ESLOT_BUY then
			self:SetAdd()
		end	
	end


	if data.type == SceneUser2_pb.ESLOT_MONTH_CARD
	and data.status == 1 then
		self:CreateTick()
	else
		self:ClearTick()
	end
end

function SaveCell:CreateTick()
	self.timeTick = TimeTickManager.Me():CreateTick(0,1000,self._refreshTime,self)
end

function SaveCell:_refreshTime()
	if(self:ObjIsNil(self.gameObject))then
		self:ClearTick()
		return
	end
	local leftTime = MultiProfessionSaveProxy.Instance:GetCardExpiration()-ServerTime.CurServerTime()/1000
	leftTime = math.max(0,leftTime)
	if leftTime == 0 then
		self:ClearTick()
		MultiProfessionSaveProxy.Instance:UpdateStatus(self.id,0)
		MultiProfessionSaveProxy.Instance:SortUserSave()
		self:PassEvent(SaveCell.StatusChange)
	end
end

function SaveCell:ClearAll()
	self.name.gameObject:SetActive(false)
	self.date.gameObject:SetActive(false)
	self.time.gameObject:SetActive(false)
	self.icon.gameObject:SetActive(false)
	self.tip.gameObject:SetActive(false)
	self.rolename.gameObject:SetActive(false)
end

function SaveCell:SetSave()
	self:ClearAll()
	self.bg.CurrentState = 0
	self.icon.gameObject:SetActive(true)
	self.icon.CurrentState = 1
	self.icon.color = blue
	self.icon:MakePixelPerfect()
end

function SaveCell:SetInfo()
	self:ClearAll()
	self.bg.CurrentState = 0
	local recordtime = os.date("*t", self.data.recordTime)
	self.date.text = string.format(ZhString.MultiProfession_SaveDate, recordtime.year, recordtime.month, recordtime.day)
	self.time.text = string.format(ZhString.MultiProfession_SaveTime, recordtime.hour, recordtime.min)
	self.name.text = self.data.recordName
	self.rolename.text = MultiProfessionSaveProxy.Instance:GetRoleName(self.id)
	self.date.gameObject:SetActive(true)
	self.time.gameObject:SetActive(true)
	self.name.gameObject:SetActive(true)
	self.rolename.gameObject:SetActive(true)
end

function SaveCell:SetTip()
	self:ClearAll()
	self.bg.CurrentState = 1
	self.tip.text = ZhString.MultiProfession_MonthCardTip
	self.tip.gameObject:SetActive(true)
end

function SaveCell:SetAdd()
	self:ClearAll()
	self.bg.CurrentState = 1
	self.icon.gameObject:SetActive(true)
	self.icon.CurrentState = 0
	self.icon.color = LuaColor.white
	self.icon:MakePixelPerfect()
end

function SaveCell:SetSelect()
	self.selection.gameObject:SetActive(true)
end

function SaveCell:SetUnselected()
	self.selection.gameObject:SetActive(false)
end

function SaveCell:ShowChoose(selectId)
	if selectId == self.id then
		self:SetSelect()
	else
		self:SetUnselected()
	end
end


function SaveCell:OnExit( )
	SaveCell.super.OnExit(self);
end

function SaveCell:ClearTick()
	if(self.timeTick)then
		TimeTickManager.Me():ClearTick(self)
	end
end

function SaveCell:OnDestroy() 
	self:ClearTick()
end