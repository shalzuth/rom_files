TaskQuestTip = class("TaskQuestTip", BaseTip);
autoImport("QuestTableCell")
autoImport("QuestTableRewardCell")
function TaskQuestTip:Init()
	TaskQuestTip.super.Init(self);
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.grid = self:FindComponent("QuestTable",UITable)
	self.questList = UIGridListCtrl.new(self.grid,QuestTableCell,"QuestTableCell")
	self.questList:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
	local Title = self:FindComponent("Title",UILabel)
	Title.text = ZhString.TaskQuestTip_Accepted
	local emptyLabel = self:FindComponent("emptyLabel",UILabel)
	emptyLabel.text = ZhString.TaskQuestTip_Empty

	self.empty = self:FindGO("empty")
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
	self:AddButtonEvent("CloseButton",function (  )
		-- body
		self:CloseSelf();
	end)
end

function TaskQuestTip:ClickItem(cell)
	local cells = self.questList:GetCells()
	for i=1,#cells do
		local single = cells[i]
		if(single == cell)then
			single:setIsSelected(true)
		else
			single:setIsSelected(false)
		end
	end
end

function TaskQuestTip:SetPos(pos)
	if(self.gameObject~=nil) then
		local p = self.gameObject.transform.position
		pos.z = p.z
		self.gameObject.transform.position = pos
	else
		self.pos = pos
	end 
end

function TaskQuestTip:SetData()
	local list = QuestProxy.Instance:getValidAcceptQuestList()
	if(list and #list>0)then
		self:Hide(self.empty)
		self:Show(self.grid.gameObject)
	else
		self:Show(self.empty)
		self:Hide(self.grid)
	end
	self.questList:ResetDatas(list)
end

function TaskQuestTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function TaskQuestTip:CloseSelf()
	if(self.callback)then
		self.callback(self.callbackParam);
	end
	TipsView.Me():HideCurrent();
end

function TaskQuestTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end	
end





