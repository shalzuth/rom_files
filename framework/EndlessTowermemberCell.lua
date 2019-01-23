local baseCell = autoImport("BaseCell")
EndlessTowermemberCell = class("EndlessTowermemberCell", baseCell)

function EndlessTowermemberCell:Init()
	EndlessTowermemberCell.super.Init(self)
	self:FindObjs()
end

function EndlessTowermemberCell:FindObjs()
	self.memberName = self:FindGO("memberName"):GetComponent(UILabel)
	self.memberState = self:FindGO("memberState"):GetComponent(UILabel)
end

function EndlessTowermemberCell:SetData(data)
	print("EndlessTowermemberCell")
	self.data = data;
	if(data)then
		if(data[1]==1)then
			self.memberState.text="OK"
		else
			self.memberState.text="NO"
		end
	else
		self.memberName.text=""
		self.memberState.text=""
	end
end

function EndlessTowermemberCell:SetCellData(data)
	self.cellData=data
	if(data)then
		self.memberName.text=data[2]
		self.memberState.text="..."
	else
		self.memberName.text=""
		self.memberState.text=""
	end
end