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
	error("没有复写BaseCDCell:GetCD()")
end

function BaseCDCell:GetMaxCD()
	error("没有复写BaseCDCell:GetMaxCD()")
end

function BaseCDCell:RefreshCD(f)
	error("没有复写BaseCDCell:RefreshCD()")
end

function BaseCDCell:ClearCD()
	error("没有复写BaseCDCell:ClearCD()")
end