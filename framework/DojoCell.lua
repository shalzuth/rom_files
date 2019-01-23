local baseCell = autoImport("BaseCell")
DojoCell = class("DojoCell", baseCell)

function DojoCell:Init()
	self:FindObjs()

	self:AddCellClickEvent()
end

function DojoCell:FindObjs()
	self.head = self:FindGO("Head"):GetComponent(UISprite)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.level = self:FindGO("Level"):GetComponent(UILabel)
	self.completed = self:FindGO("Completed")
	self.choose = self:FindGO("Choose")
	self.mask = self:FindGO("Mask")
	
	--todo xde
	OverseaHostHelper:FixLabelOverV1(self.name,3,200)
	OverseaHostHelper:FixLabelOverV1(self:FindGO("LevelTip"):GetComponent(UILabel),3,110)
	
end

function DojoCell:SetData(data)
	self.data = data
	self.gameObject:SetActive( data ~= nil )

	if data then
		local dojoData = Table_Guild_Dojo[data.id]
		if dojoData then
			if dojoData.HeadImage then
				IconManager:SetNpcMonsterIconByID(dojoData.HeadImage, self.head)
				self.head.gameObject.transform.localScale = Vector3(0.67,0.67,1)
			else
				errorLog("DojoCell SetData dojoData.HeadImage = nil")
			end

			if dojoData.Name then
				self.name.text = dojoData.Name
			else
				errorLog("DojoCell SetData dojoData.Name = nil")
			end
			if dojoData.Level then
				if dojoData.Level == -1 then
					self.level.text = dojoData.UnopenLevel
				else
					self.level.text = dojoData.Level
				end
			else
				errorLog("DojoCell SetData dojoData.Level = nil")
			end

			if data.isCompleted then
				self.completed:SetActive(true)
			else
				self.completed:SetActive(false)
			end

			self.choose:SetActive(data.isChoose)

			self.lock = data:GetLock()
			if dojoData.DojoOpen == 0 then
				self.mask:SetActive(true)
			else
				self.mask:SetActive(self.lock)
			end
		end
	end
end

function DojoCell:SetChoose(isChoose)
	if isChoose then
		self.choose:SetActive(true)
	else
		self.choose:SetActive(false)
	end
end