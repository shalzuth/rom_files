autoImport("BaseCell")
autoImport("BaseAttributeReCell")
autoImport("AttributeTabCell")
autoImport("PlayerAttriButeCell")
PlayerAttributeTabCell = class("PlayerAttributeTabCell", AttributeTabCell)
function PlayerAttributeTabCell:setPreferenceShow()
end
function PlayerAttributeTabCell:initData()
  if self.baseGridList then
    return
  end
  if self.data.id > 2 then
    self.baseGridList = UIGridListCtrl.new(self.grid, PlayerAttriButeCell, "BaseAttributeCell")
    self.grid.columns = 1
  else
    self.grid.columns = 2
    self.baseGridList = UIGridListCtrl.new(self.grid, PlayerAttriButeCell, "BaseAttrCell")
  end
end
