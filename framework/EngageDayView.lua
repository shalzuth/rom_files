autoImport("EngageDayCell")
autoImport("EngageBookView")
autoImport("EngageBookedView")

EngageDayView = class("EngageDayView",SubView)

local _ViewEnumCheck = WeddingProxy.EngageViewEnum.Check
local _ViewEnumBook = WeddingProxy.EngageViewEnum.Book
local _CreateTable = ReusableTable.CreateTable
local _DestroyTable = ReusableTable.DestroyTable
local _MyselfProxy = MyselfProxy.Instance
local empty = {}

function EngageDayView:OnExit()
	if self.bookedView ~= nil then
		self.bookedView:Exit()
	end
	EngageDayView.super.OnExit(self)
end

function EngageDayView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function EngageDayView:FindObjs()
	self.gameObject = self:FindGO("DayRoot")
end

function EngageDayView:AddEvts()
	local returnBtn = self:FindGO("ReturnBtn")
	self:AddClickEvent(returnBtn, function ()
		self:Return()
	end)

	local refreshBtn = self:FindGO("RefreshBtn")
	self:AddClickEvent(refreshBtn, function ()
		local data = self.container:GetCurDateData()
		if data ~= nil then
			local now = Time.unscaledTime
			if self._callReqWeddingOneDayList == nil or now - self._callReqWeddingOneDayList >= 3 then
				self._callReqWeddingOneDayList = now
				ServiceWeddingCCmdProxy.Instance:CallReqWeddingOneDayListCCmd(data.timeStamp)
			else
				MsgManager.ShowMsgByID(49)
			end
		end
	end)
end

function EngageDayView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.WeddingCCmdReqWeddingOneDayListCCmd, self.UpdateView)
	self:AddListenEvt(ServiceEvent.WeddingCCmdNtfWeddingInfoCCmd, self.HandleNtfWeddingInfo)
end

function EngageDayView:InitShow()
	local dateContainer = self:FindGO("DateContainer")
	local obj = self:LoadPreferb("cell/EngageDateCell", dateContainer)
	self.dateCell = EngageDateCell.new(obj)
	self.dateCell:AddEventListener(MouseEvent.MouseClick, self.Return, self)

	local container = self:FindGO("Container")
	self.itemWrapHelper = WrapListCtrl.new(container, EngageDayCell, "EngageDayCell", WrapListCtrl_Dir.Vertical, 4, 140)
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDay, self)
end

function EngageDayView:ShowSelf(isShow)
	self.gameObject:SetActive(isShow)

	if isShow then
		local container = self.container
		if container.viewEnum == _ViewEnumCheck then
			local str = string.format(ZhString.Wedding_EngageCheckDialog, _MyselfProxy:GetZoneString())
			container:UpdateDialog(str)
		elseif container.viewEnum == _ViewEnumBook then
			container:UpdateDialog(ZhString.Wedding_EngageBookDayDialog)
		end

		local data = self.container:GetCurDateData()
		if data ~= nil then
			self.dateCell:SetData(data)
			self.itemWrapHelper:ResetDatas(empty)

			ServiceWeddingCCmdProxy.Instance:CallReqWeddingOneDayListCCmd(data.timeStamp)
		end
	end
end

function EngageDayView:UpdateView()
	local data = self.container:GetCurDateData()
	if data ~= nil then
		self.itemWrapHelper:ResetDatas(data:GetDayList())
	end
end

function EngageDayView:ClickDay(cell)
	local data = cell.data
	if data then
		--已过期
		local date = self.container:GetCurDateData()
		if date ~= nil and WeddingProxy.Instance:IsEngageNeedRefresh(date.timeStamp) then
			MsgManager.ShowMsgByID(9615)
			self.container:SwitchView(true)
			ServiceWeddingCCmdProxy.Instance:CallReqWeddingDateListCCmd()
			return
		end

		if data.status == EngageDayData.Status.Free then
			--查看婚期
			if self.container.viewEnum == _ViewEnumCheck then
				MsgManager.ShowMsgByID(9610)
				return
			end

			local temp = _CreateTable()
			temp.date = self.container:GetCurDateData()
			temp.day = data

			if self.bookView == nil then
				self.bookView = self:AddSubView("EngageBookView", EngageBookView)
			end
			self.bookView:SetData(temp, cell.time , NGUIUtil.AnchorSide.Right, {-300,0})

			_DestroyTable(temp)

		elseif data.status == EngageDayData.Status.Booked then
			if self.bookedView == nil then
				self.bookedView = self:AddSubView("EngageBookedView", EngageBookedView)
			end
			self.bookedView:SetData(data, cell.time , NGUIUtil.AnchorSide.Right, {-300,0})
		end

		if self.lastDayCell ~= nil then
			self.lastDayCell:SetChoose(false)
		end

		cell:SetChoose(true)
		self.lastDayCell = cell
	end
end

function EngageDayView:Return()
	self.container:SwitchView(true)
end

function EngageDayView:HandleNtfWeddingInfo(note)
	local data = note.body
	if data ~= nil then
		if data.info.id ~= 0 then
			local curDate = self.container:GetCurDateData()
			if curDate ~= nil then
				ServiceWeddingCCmdProxy.Instance:CallReqWeddingOneDayListCCmd(curDate.timeStamp)
			end
		end
	end
end