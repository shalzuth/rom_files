autoImport("WeddingProcessCell")

WeddingProcessView = class("WeddingProcessView", ContainerView)

WeddingProcessView.ViewType = UIViewType.PopUpLayer

function WeddingProcessView:Init()
	self:InitShow()
end

function WeddingProcessView:InitShow()
	local table = self:FindGO("Table"):GetComponent(UITable)
	self.ctrl = UIGridListCtrl.new(table, WeddingProcessCell, "WeddingProcessCell")

	local data = GameConfig.Wedding.ManualIntroduce
	if data ~= nil then
		self.ctrl:ResetDatas(data)
	end

	table:Reposition()
end