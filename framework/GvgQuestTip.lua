GvgQuestTip = class("GvgQuestTip", BaseTip);
autoImport("GvgQuestTableCell")
function GvgQuestTip:Init()
	GvgQuestTip.super.Init(self);
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.grid = self:FindComponent("QuestTable",UITable)
	self.questList = UIGridListCtrl.new(self.grid,GvgQuestTableCell,"GvgQuestTableCell")
	local Title = self:FindComponent("Title",UILabel)
	Title.text = ZhString.MainViewGvgPage_GvgQuestTip_Accepted
	local emptyLabel = self:FindComponent("emptyLabel",UILabel)
	emptyLabel.text = ZhString.MainViewGvgPage_GvgQuestTip_Empty

	self.empty = self:FindGO("empty")
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
	self:AddButtonEvent("CloseButton",function (  )
		-- body
		self:CloseSelf();
	end)
end

function GvgQuestTip:SetPos(pos)
	if(self.gameObject~=nil) then
		local p = self.gameObject.transform.position
		pos.z = p.z
		self.gameObject.transform.position = pos
	else
		self.pos = pos
	end 
end

function GvgQuestTip:SetData()
	local infoDatas = GvgProxy.Instance.questInfoData
	local list = {}

	for i=1,#GvgProxy.GvgQuestListp do
		local single = GvgProxy.GvgQuestListp[i]
		list[#list+1] = {key = single,value = infoDatas[single] or 0}
	end
	
	if(list and #list>0)then
		self:Hide(self.empty)
		self:Show(self.grid.gameObject)
	else
		self:Show(self.empty)
		self:Hide(self.grid)
	end
	self.questList:ResetDatas(list)
end

function GvgQuestTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function GvgQuestTip:CloseSelf()
	if(self.callback)then
		self.callback(self.callbackParam);
	end
	TipsView.Me():HideCurrent();
end

function GvgQuestTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end	
end





