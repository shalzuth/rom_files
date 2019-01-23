autoImport("RepositoryDragItemCell")

RepositoryItemCell = class("RepositoryItemCell", RepositoryDragItemCell)

function RepositoryItemCell:SetData(data)
	RepositoryItemCell.super.SetData(self, data)
	self:SetCellLock()
end

function RepositoryItemCell:IsLock()
	return not RepositoryViewProxy.Instance:CanTakeOut()
end

function RepositoryItemCell:SetCellLock()
	if self.data then
		self:SetIconGrey( self:IsLock() )
	end
end