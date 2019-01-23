autoImport("UIMapAreaListCell")
autoImport('UIModelMonthlyVIP')

UIMapAreaList = class("UIMapAreaList", ContainerView)

UIMapAreaList.ViewType = UIViewType.NormalLayer

UIMapAreaList.E_TransmitType = {
	Single = 0,
	Team = 1,
}
UIMapAreaList.transmitType = nil

function UIMapAreaList:Init()
	self.activeAreas = {}
	local amIMonthlyVIP = UIModelMonthlyVIP.Instance():AmIMonthlyVIP()
	local activeMaps = WorldMapProxy.Instance.activeMaps
	for mapid,_ in pairs(activeMaps) do
		local mapInfo = Table_Map[mapid]
		if mapInfo then
			local couldTransmit = true
			if mapInfo.MoneyType == 2 and not amIMonthlyVIP then
				couldTransmit = false
			end
			if couldTransmit then
				local areaID = mapInfo.Range
				if areaID ~= nil and not table.ContainsValue(self.activeAreas, areaID) then
					table.insert(self.activeAreas, areaID)
				end
			end
		end
	end
	table.sort(self.activeAreas, function (x, y)
		return self:Sort(x, y)
	end)

	self.transScrollList = self:FindGO("ScrollList").transform
	self.transRoot = self:FindGO("Root", self.transScrollList.gameObject).transform
	self.uiGrid = self.transRoot.gameObject:GetComponent(UIGrid)
	self.listCtrl = UIGridListCtrl.new(self.uiGrid, UIMapAreaListCell, "UIMapAreaListCell")
	self.listCtrl:ResetDatas(self.activeAreas)
	self.goButtonBack = self:FindGO("Back", self.transScrollList.gameObject)
	self:AddClickEvent(self.goButtonBack, function (go)
		self:OnButtonBackClick(go)
	end)
	self.goMyTeam = self:FindGO('MyTeam')
	self:HideMyTeam()

	self.goTutorial = self:FindGO('Tutorial')
	self.goTutorialLab = self:FindGO('Lab', self.goTutorial)
	self.labTutorial = self.goTutorialLab:GetComponent(UILabel)
	if UIMapAreaList.transmitType == UIMapAreaList.E_TransmitType.Single then
		local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
		if handInHandPlayerID ~= nil then
			local handInHandPlayer = UIModelKaplaTransmit.Ins():GetTeammateDetail(handInHandPlayerID)
			local handInHandPlayerName = handInHandPlayer and handInHandPlayer.name or ''
			self.labTutorial.text = string.format(ZhString.kaplaTransmit_HandInHandTransmitTutorial, handInHandPlayerName)
		else
			self.labTutorial.text = ZhString.KaplaTransmit_SelectTransmitDestination
		end
	elseif UIMapAreaList.transmitType == UIMapAreaList.E_TransmitType.Team then
		self.labTutorial.text = ZhString.KaplaTransmit_TeammateTransmitTutorial
	end
end

function UIMapAreaList:OnButtonBackClick(go)
	self:CloseSelf()
end

function UIMapAreaList:Sort(x, y)
	if x == nil then
		return true
	elseif y == nil then
		return false
	else
		return x < y
	end
end

function UIMapAreaList:HideMyTeam()
	self.goMyTeam:SetActive(false)
end