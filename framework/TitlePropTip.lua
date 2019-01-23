autoImport("BaseTip")
autoImport("GAstrolabeAttriCell")
TitlePropTip = class("TitlePropTip", BaseTip)

-- function TitlePropTip:ctor(prefab,parent)
-- 	TitlePropTip.super.ctor(self,prefab,parent)	
-- end

function TitlePropTip:Init()
	local propGrid = self:FindComponent("propGrid", UIGrid);
	self.propCtl = UIGridListCtrl.new(propGrid, GAstrolabeAttriCell, "TitlelabeAttriCell")

	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
	TitlePropTip.super.Init(self);
end

function TitlePropTip:SetData()
	local props = TitleProxy.Instance:GetAllTitleProp()
	local data = {};
	for k, v in pairs(props) do
		local cdata = {k, v};
		table.insert(data, cdata);
	end
	self.propCtl:ResetDatas(data);
end

function TitlePropTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function TitlePropTip:CloseSelf()
	-- self:Exit()
	if(not self:ObjIsNil(self.gameObject))then
		GameObject.Destroy(self.gameObject)
		-- TipManager.Instance.formularTip=nil;
	end
end

function TitlePropTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end	
end




