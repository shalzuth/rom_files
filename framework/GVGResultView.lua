local baseView = autoImport("BaseView")
autoImport("GVGResultViewItem")
GVGResultView = class("GVGResultView",BaseView)
GVGResultView.ViewType = UIViewType.NormalLayer

function GVGResultView:Init()
	self:GetGameObjects()
	self:InitView()
	self:addViewEventListener()
	self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.CloseSelf);
end

function GVGResultView:InitView( )
	-- rewardinfo {
	--     guildid: 10009
	--     rank: 2
	--     items {
	--         itemid: 156
	--         count: 2000
	--     }
	-- }
	
	-- local data = {}
	-- for i=1,4 do
	-- 	data[i] = {}
	-- 	data[i].guildid = i + 100
	-- 	data[i].rank = i
	-- 	data[i].items = {{itemid = 156, count = 2000}, {itemid = 157, count = 20000}}
	-- end

	self.resultItem1.gameObject:SetActive(false)
	self.resultItem2.gameObject:SetActive(false)
	self.resultItem3.gameObject:SetActive(false)
	self.resultItem4.gameObject:SetActive(false)
	local rewardInfo = self.viewdata.rewardInfo
	table.sort(rewardInfo, function (x, y)
		return x.rank < y.rank
	end)
	local setedIndex = 0
	for i,v in ipairs(rewardInfo) do
		if setedIndex == 0 then
			self.resultItem1:SetData(v)
			self.resultItem1.gameObject:SetActive(true)
		elseif setedIndex == 1 then
			self.resultItem2:SetData(v)
			self.resultItem2.gameObject:SetActive(true)
		elseif setedIndex == 2 then
			self.resultItem3:SetData(v)
			self.resultItem3.gameObject:SetActive(true)
		elseif setedIndex == 3 then
			self.resultItem4:SetData(v)
			self.resultItem4.gameObject:SetActive(true)
		end
		setedIndex = setedIndex + 1	
	end
	-- self.resultItem2.gameObject.transform:SetSiblingIndex(v.rank - 1)
	self.rewardGrid:Reposition()
end

function GVGResultView:addViewEventListener(  )
	-- body
	self:AddButtonEvent("CloseButton",function (  )
		-- body
		ServiceNUserProxy.Instance:ReturnToHomeCity()
		self.viewCenter:SetActive(false)
	end)
	self:AddButtonEvent("Details",function (  )
		-- body
		GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "GVGDetailView"})
	end)
end

function GVGResultView:GetGameObjects()
	local resultItemGo1 = self:FindGO('GuildResultViewItem1', self.gameObject)
	self.resultItem1 = GVGResultViewItem.new(resultItemGo1)

	local resultItemGo2 = self:FindGO('GuildResultViewItem2', self.gameObject)
	self.resultItem2 = GVGResultViewItem.new(resultItemGo2)

	local resultItemGo3 = self:FindGO('GuildResultViewItem3', self.gameObject)
	self.resultItem3 = GVGResultViewItem.new(resultItemGo3)

	local resultItemGo4 = self:FindGO('GuildResultViewItem4', self.gameObject)
	self.resultItem4 = GVGResultViewItem.new(resultItemGo4)

	self.viewCenter = self:FindGO('ResultViewCenter')
	self.rewardGrid = self:FindComponent("Sec2Fourth", UIGrid)
end
