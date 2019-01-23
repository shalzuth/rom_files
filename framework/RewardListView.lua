autoImport('RewardListViewCell')
RewardListView = class("RewardListView",BaseView)
RewardListView.ViewType = UIViewType.PopUpLayer

-- reusableArray = {}

function RewardListView:Init()
	self:GetGameObjects()
	self:InitView()
	self:addViewEventListener()
	--self:addListEventListener()
end

function RewardListView:OnExit()
	-- self:CancelListenServerResponse()
	-- if self.itemsController ~= nil then
	-- 	for i = 1, #self.itemsController do
	-- 		self.itemsController[i]:OnExit()
	-- 	end
	-- end
end

function RewardListView:InitView( )
	self.uiGridOfItems = self.goItemsRoot:GetComponent(UIGrid)
	if self.listControllerOfItems == nil then
		self.listControllerOfItems = UIGridListCtrl.new(self.uiGridOfItems, RewardListViewCell, "RewardListViewCell")
	end
	-- TableUtility.ArrayClear(reusableArray)
	-- for i=1, 5 do
	-- 	k = {}
	-- 	k.itemid = 155 + i
	-- 	k.count = i * 3000
 --   		table.insert(reusableArray, k)
 --   	end
 	local rewardList = self.viewdata.rewardList
 	if (rewardList and #rewardList > 0) then
		self.listControllerOfItems:ResetDatas(rewardList)
		self.itemsController = self.listControllerOfItems:GetCells()
	end
end

function RewardListView:GetGameObjects()
	self.goItemsRoot = self:FindGO("ItemsRoot", self.gameObject)
end

function RewardListView:addViewEventListener(  )
	-- body
	self:AddButtonEvent("CloseButton",function (  )
		-- body
		self:CloseSelf()
	end)
end

function RewardListView:addListEventListener(  )
	-- body
end

function RewardListView:setContent( status,content )
end
