local BaseCell = autoImport("BaseCell");
BaseCDCell = class("BaseCDCell", BaseCell)

function BaseCDCell:ctor(obj,cdCtrl)
	self.cdCtrl = cdCtrl
	BaseCDCell.super.ctor(self,obj)
end

function BaseCDCell:SetcdCtl(cdCtrl)
	self.cdCtrl = cdCtrl;
end

function BaseCDCell:GetCD()
	error("????????????BaseCDCell:GetCD()")
end

function BaseCDCell:GetMaxCD()
	error("????????????BaseCDCell:GetMaxCD()")
end

function BaseCDCell:RefreshCD(f)
	error("????????????BaseCDCell:RefreshCD()")
end

function BaseCDCell:ClearCD()
	error("????????????BaseCDCell:ClearCD()")
end