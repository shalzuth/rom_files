PreQuestTip = class("PreQuestTip", BaseTip);

function PreQuestTip:Init()
	PreQuestTip.super.Init(self);
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	local grid = self:FindComponent("grid",UIGrid)
	self.preQuestGrid = UIGridListCtrl.new(grid,AchievementPreQuestCell,"AchievementPreQuestCell")
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
end

function PreQuestTip:SetPos(pos)
	if(self.gameObject~=nil) then
		local p = self.gameObject.transform.position
		pos.z = p.z
		self.gameObject.transform.position = pos
	else
		self.pos = pos
	end 
end

function PreQuestTip:SetData(preQuestS)
	self.preQuestGrid:ResetDatas(preQuestS)	
end

function PreQuestTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function PreQuestTip:CloseSelf()
	if(self.callback)then
		self.callback(self.callbackParam);
	end
	TipsView.Me():HideCurrent();
end

function PreQuestTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end	
end





