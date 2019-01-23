local baseCell = autoImport("BaseCell")

PhotographSingleFilterText = class("PhotographSingleFilterText",baseCell)

function PhotographSingleFilterText:Init()
	self:initView()
end

function PhotographSingleFilterText:initView(  )
	-- body
	self.label = self:FindGO("Label"):GetComponent(UILabel)
	self.toggle = self.gameObject:GetComponent(UIToggle)
	self:SetEvent(self.gameObject,function ( obj )
		self:PassEvent(MouseEvent.MouseClick,self)
	end)
	
	--todo xde
	self.label.transform.localPosition = Vector3(-80,0,0)
	local selected = self:FindGO("selected")
	selected.transform.localPosition = Vector3(90,0,0)
	local selectedBg = self:FindGO("selectedBg")
	selectedBg.transform.localPosition = Vector3(90,0,0)

	self.btnCollider = self.gameObject:GetComponent(BoxCollider)
	self.btnCollider.size = Vector3(200,30,0)
end

function PhotographSingleFilterText:SetData( data )
	self.data = data
	if(data.text) then
		self.label.text = data.text
	else
		local config = Table_ScreenFilter[data.id]
		if(config) then
			self.label.text = config.Name
		end
	end
	self:setIsSelect(true)
	-- self:PassEvent(MouseEvent.MouseClick, self)
end

function PhotographSingleFilterText:setIsSelect( isSelect )
	-- body
	-- if(self.isSelect ~= isSelect)then
		self.toggle:Set(isSelect)
		-- self.isSelect = isSelect
	-- end
end

function PhotographSingleFilterText:getIsSelect(  )
	-- body
	return self.toggle.value
end