UIListItemViewControllerVIPDescription = class('UIListItemViewControllerVIPDescription', BaseCell)

function UIListItemViewControllerVIPDescription:Init()
	self:GetGameObjects()
end

function UIListItemViewControllerVIPDescription:SetData(data)
	self.depositFunctionConfID = data:GetDescriptionConfigID()
	self:GetModelSet()

	self:LoadView()
end

function UIListItemViewControllerVIPDescription:GetModelSet()
	self.depositFunctionConf = Table_DepositFunction[self.depositFunctionConfID]
end

function UIListItemViewControllerVIPDescription:GetGameObjects()
	self.goLab = self:FindGO('Lab', self.gameObject)
	self.lab = self.goLab:GetComponent(UILabel)
end

function UIListItemViewControllerVIPDescription:LoadView()
	local description = self.depositFunctionConf.Desc
	if self.depositFunctionConf.DescArgument ~= nil then
		local argumentCount = #self.depositFunctionConf.DescArgument
		if argumentCount == 1 then
			description = string.format(self.depositFunctionConf.Desc, self.depositFunctionConf.DescArgument[1])
		elseif argumentCount == 2 then
			description = string.format(self.depositFunctionConf.Desc, self.depositFunctionConf.DescArgument[1], self.depositFunctionConf.DescArgument[2])
		elseif argumentCount == 3 then
			description = string.format(self.depositFunctionConf.Desc, self.depositFunctionConf.DescArgument[1], self.depositFunctionConf.DescArgument[2], self.depositFunctionConf.DescArgument[3])
		end
	end
	self.lab.text = description
end