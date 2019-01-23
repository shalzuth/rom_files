autoImport("RepositoryDragItemCell")

RepositoryBagCell = class("RepositoryBagCell", RepositoryDragItemCell)

function RepositoryBagCell:SetData(data)
	RepositoryBagCell.super.SetData(self, data);
	self:SetCellLock()
end

function RepositoryBagCell:IsLock()
	local viewTab = RepositoryViewProxy.Instance:GetViewTab()
	local isLevelLock = viewTab == RepositoryView.Tab.CommonTab and MyselfProxy.Instance:RoleLevel() < GameConfig.Item.store_baselv_req
	local isStrengthLock = viewTab == RepositoryView.Tab.CommonTab and self.data.equipInfo and self.data.equipInfo.strengthlv > 0
	if isLevelLock or isStrengthLock then
		return true
	end

	if viewTab == RepositoryView.Tab.RepositoryTab then
		if not self.data:CanStorage(BagProxy.BagType.PersonalStorage) then
			return true
		end
	elseif viewTab == RepositoryView.Tab.CommonTab then
		if not self.data:CanStorage(BagProxy.BagType.Storage) then
			return true
		end
	end

	return false
end

function RepositoryBagCell:SetCellLock()
	if self.data then
		self:SetIconGrey( self:IsLock() )
	end
end