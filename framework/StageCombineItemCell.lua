autoImport("BaseCombineCell")
StageCombineItemCell = class("StageCombineItemCell", BaseCombineCell)
autoImport("StageItemCell")
function StageCombineItemCell:Init()
  self:InitCells(4, "StageItemCell", StageItemCell)
end
function StageCombineItemCell:SetData(data)
  StageCombineItemCell.super.SetData(self, data)
end
function StageCombineItemCell:TestInfo()
  for i = 1, #self.childCells do
    local testLab = self:FindChild("TestLabel", self.childCells[i].Obj):GetComponent(UILabel)
    local cData = self:GetDataByChildIndex(i)
    if cData ~= nil then
      testLab.gameObject:SetActive(true)
      testLab.text = "index: " .. cData.index .. "\n" .. "type: " .. cData.staticData.Type .. "\n" .. "id: " .. cData.staticData.id .. "\n" .. "quality: " .. cData.staticData.Quality .. "\n"
    else
      testLab.gameObject:SetActive(false)
    end
  end
end
