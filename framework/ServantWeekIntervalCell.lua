autoImport("ServantWeekActivityCell")
ServantWeekIntervalCell = class("ServantWeekIntervalCell", ItemCell)
function ServantWeekIntervalCell:Init()
  self.grid = self.gameObject:GetComponent(UIGrid)
  self.weekIntervalCtl = UIGridListCtrl.new(self.grid, ServantWeekActivityCell, "ServantWeekActivityCell")
end
function ServantWeekIntervalCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.weekIntervalCtl:ResetDatas(data)
  else
    self.gameObject:SetActive(false)
  end
end
