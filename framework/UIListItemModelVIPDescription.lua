UIListItemModelVIPDescription = class('UIListItemModelVIPDescription')

function UIListItemModelVIPDescription:GetCellType()
	return 'VIPDescription'
end

function UIListItemModelVIPDescription:GetDescriptionConfigID()
	return self.descriptionConfigID
end

function UIListItemModelVIPDescription:SetDescriptionConfigID(description_config_id)
	self.descriptionConfigID = description_config_id
end