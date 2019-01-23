autoImport("WeddingHeadCell")

EngageBookedView = class("EngageBookedView", SubView)

local funkey = {
	"InviteMember",
	"AddFriend",
	"SendMessage",
	"ShowDetail",
}
local tipData = {}

function EngageBookedView:Exit()
	EventManager.Me():RemoveEventListener(ServiceEvent.WeddingCCmdReqWeddingInfoCCmd, self.UpdateView, self)
end

function EngageBookedView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function EngageBookedView:FindObjs()
	self.gameObject = self:LoadPreferb("view/EngageBookedView", nil, true)
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
	self.zone = self:FindGO("Zone"):GetComponent(UILabel)
	self.date = self:FindGO("Date"):GetComponent(UILabel)
end

function EngageBookedView:AddEvts()
	self.closecomp.callBack = function (go)
		self:ShowSelf(false)
	end
end

function EngageBookedView:AddViewEvts()
	EventManager.Me():AddEventListener(ServiceEvent.WeddingCCmdReqWeddingInfoCCmd, self.UpdateView, self)
end

function EngageBookedView:InitShow()
	local grid = self:FindGO("Grid"):GetComponent(UIGrid)
	self.itemCtl = UIGridListCtrl.new(grid, WeddingHeadCell, "WeddingHeadCell")
	self.itemCtl:AddEventListener(MouseEvent.MouseClick, self.ClickHead, self)
end

function EngageBookedView:SetData(data, stick, side, offset)
	if data then
		local pos = NGUIUtil.GetAnchorPoint(self.gameObject, stick, side, offset)
		self.gameObject.transform.position = pos

		self.id = data.id

		ServiceWeddingCCmdProxy.Instance:CallReqWeddingInfoCCmd(data.id)
	end
end

function EngageBookedView:UpdateView()
	local data = WeddingProxy.Instance:GetWeddingData(self.id)
	if data then
		self:ShowSelf(true)

		self.zone.text = string.format(ZhString.Wedding_EngageBookZone, data:GetZoneStr())

		local starttime = os.date("*t", data.starttime)
		local endtime = os.date("*t", data.endtime)
		self.date.text = string.format(ZhString.Wedding_EngageBookDate, starttime.year, starttime.month, starttime.day, starttime.hour, endtime.hour)

		self.itemCtl:ResetDatas(data:GetCharList())
	end
end

function EngageBookedView:ClickHead(cell)
	local data = cell.data
	if data then
		local playerData = PlayerTipData.new()
		playerData:SetByWeddingcharData(data)

		FunctionPlayerTip.Me():CloseTip()

		tipData.playerData = playerData
		tipData.funckeys = funkey

		FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj , NGUIUtil.AnchorSide.Left, {80,60}, tipData)
	end
end

function EngageBookedView:ShowSelf(isShow)
	self.gameObject:SetActive(isShow)
end