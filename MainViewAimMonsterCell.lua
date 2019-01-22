local baseCell = autoImport("BaseCell")
MainViewAimMonsterCell = class("MainViewAimMonsterCell", baseCell)

function MainViewAimMonsterCell:Init()
	self:FindObjs()
	self:InitShow()

	self:AddCellClickEvent()
	self:fixLabel()
end

function MainViewAimMonsterCell:FindObjs()
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
	self.name = self:FindGO("Name"):GetComponent(UILabel)
	self.level = self:FindGO("Level"):GetComponent(UILabel)
--	self.choose = self:FindGO("Choose")
-- todo xde fix find bug
	self.choose = self:FindGO("choose")
	self.all = self:FindGO("All")
	self.bg = self:FindGO("Bg")
end

function MainViewAimMonsterCell:InitShow()
	-- body
end

function MainViewAimMonsterCell:SetData(data)
	self.data = data
	self.gameObject:SetActive( data ~= nil )

	if data then
		local id = data:GetId()
		if id == 0 then
			self.all:SetActive(true)
			self.level.gameObject:SetActive(false)
			self.name.gameObject:SetActive(false)
			self.icon.gameObject:SetActive(false)
		else
			self.all:SetActive(false)
			self.level.gameObject:SetActive(true)
			self.name.gameObject:SetActive(true)

			local monster = Table_Monster[id]
			if monster then
				self.level.text = "Lv."..data:GetLevel()
				self.name.text = monster.NameZh

				local symbolName
				if monster.Type == "MVP" then
					symbolName = "map_mvpboss"
				elseif monster.Type == "MINI" then
					symbolName = "map_miniboss"
				end

				if symbolName then
					IconManager:SetMapIcon(symbolName , self.icon)
					self.icon.gameObject:SetActive(true)
				else
					self.icon.gameObject:SetActive(false)
				end
			end
		end

		self.choose:SetActive(false)
	end
	self:fixLabel()
end

function MainViewAimMonsterCell:fixLabel()
	--todo xde
	OverseaHostHelper:FixAnchor(self.all:GetComponent(UILabel).leftAnchor,self.bg.transform,0,8)
	self.all:GetComponent(UILabel).fontSize = 18
	OverseaHostHelper:FixLabelOverV1(self.level,2,100)
	self.level.fontSize = 18
	OverseaHostHelper:FixAnchor(self.level.leftAnchor,self.bg.transform,0,8)

	OverseaHostHelper:FixAnchor(self.name.leftAnchor,self.level.transform,1,8)
	self.name.fontSize = 18
	OverseaHostHelper:FixLabelOverV1(self.name,1,200)
	UIUtil.WrapLabel(self.name)
end

function MainViewAimMonsterCell:SetChoose(isChoose)
	self.choose:SetActive(isChoose)
end