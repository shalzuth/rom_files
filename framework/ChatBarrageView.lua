autoImport("ChatBarrageCell")

ChatBarrageView = class("ChatBarrageView",ContainerView)

ChatBarrageView.ViewType = UIViewType.ProcessLayer;

function ChatBarrageView:Init()
	ChatRoomProxy.ChatBarrageViewInstance = self
end

function ChatBarrageView:AddBarrage()
	local datas = ChatRoomProxy.Instance:GetBarrageContent()
	if #datas > 0 then
		local cellCtr = ChatBarrageCell.CreateAsTable(self.gameObject.transform)
		local cellData = ReusableTable.CreateTable()
		cellData.name = datas[1]:GetName()
		cellData.text = datas[1]:GetStr(true)
		cellCtr:SetData(cellData)
		ReusableTable.DestroyTable(cellData)
		table.remove(datas,1)
	end
end