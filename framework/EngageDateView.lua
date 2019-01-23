autoImport("EngageDateCell")

EngageDateView = class("EngageDateView", SubView)

local _ViewEnumCheck = WeddingProxy.EngageViewEnum.Check
local _ViewEnumBook = WeddingProxy.EngageViewEnum.Book
local _MyselfProxy = MyselfProxy.Instance

function EngageDateView:OnEnter()
	EngageDateView.super.OnEnter(self)

	ServiceWeddingCCmdProxy.Instance:CallReqWeddingDateListCCmd()
end

function EngageDateView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function EngageDateView:FindObjs()
	self.gameObject = self:FindGO("DateRoot")
end

function EngageDateView:AddEvts()

end

function EngageDateView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.WeddingCCmdReqWeddingDateListCCmd, self.UpdateView)
end

function EngageDateView:InitShow()
	local container = self:FindGO("Container")
	self.itemWrapHelper = WrapListCtrl.new(container, EngageDateCell, "EngageDateCell", WrapListCtrl_Dir.Horizontal)
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDate, self)
end

function EngageDateView:ShowSelf(isShow)
	self.gameObject:SetActive(isShow)

	if isShow then
		local container = self.container
		if container.viewEnum == _ViewEnumCheck then
			local str = string.format(ZhString.Wedding_EngageCheckDialog, _MyselfProxy:GetZoneString())
			container:UpdateDialog(str)
		elseif container.viewEnum == _ViewEnumBook then
			container:UpdateDialog(ZhString.Wedding_EngageBookDateDialog)
		end
	end
end

function EngageDateView:UpdateView()
	local data = WeddingProxy.Instance:GetDateList()
	if self.container.viewEnum == _ViewEnumBook then
		table.remove(data, 1)
	end
	if data ~= nil then
		self.itemWrapHelper:ResetDatas(data)
	end
end

function EngageDateView:ClickDate(cell)
	local data = cell.data
	if data ~= nil then
		if WeddingProxy.Instance:IsEngageNeedRefresh(data.timeStamp) then
			MsgManager.ShowMsgByID(9615)
			ServiceWeddingCCmdProxy.Instance:CallReqWeddingDateListCCmd()
		else
			self.curDateData = data.timeStamp
			self.container:SwitchView(false)
		end
	end
end