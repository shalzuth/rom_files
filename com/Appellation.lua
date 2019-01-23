--称号
Appellation = class("Appellation")

function Appellation:ctor(id,titleType,createTime)
	self:initData()
	self:ResetData(id,titleType,createTime)
end

function Appellation:initData(  )
	-- body
	self.id = -1
	self.titleType = -1
	self.createTime = 0
end

function Appellation:ResetData(id,titleType,createTime)
	self.id = id
	self.staticData = Table_Appellation[id]
	if(not self.staticData)then
		errorLog("Appellation:ResetData:can't find staticData in Table_Appellation by id:"..(id or 0))
		return
	end
	self.titleType  = titleType
	self.createTime = createTime
end
-- return Prop