local BaseCell = autoImport("BaseCell")
BaseCDCell = class("BaseCDCell", BaseCell)
function BaseCDCell:ctor(obj, cdCtrl)
  self.cdCtrl = cdCtrl
  BaseCDCell.super.ctor(self, obj)
end
function BaseCDCell:SetcdCtl(cdCtrl)
  self.cdCtrl = cdCtrl
end
function BaseCDCell:GetCD()
  error("\230\178\161\230\156\137\229\164\141\229\134\153BaseCDCell:GetCD()")
end
function BaseCDCell:GetMaxCD()
  error("\230\178\161\230\156\137\229\164\141\229\134\153BaseCDCell:GetMaxCD()")
end
function BaseCDCell:RefreshCD(f)
  error("\230\178\161\230\156\137\229\164\141\229\134\153BaseCDCell:RefreshCD()")
end
function BaseCDCell:ClearCD()
  error("\230\178\161\230\156\137\229\164\141\229\134\153BaseCDCell:ClearCD()")
end
