local baseCell = autoImport("BaseCell")
AdventureFoodBufferCell = class("AdventureFoodBufferCell",baseCell)

function AdventureFoodBufferCell:Init()
	self:initView()
end


function AdventureFoodBufferCell:initView(  )
	-- body
	self.text = self:FindComponent("text",UILabel)
end

function AdventureFoodBufferCell:SetData( data )
	-- body
	if(data.value>0)then
		self.text.text = "[c][1F74BF]"..data.propVO.displayName.."+"..data:ValueToString().."[-][/c]"
	else
		self.text.text = "[c][1F74BF]"..data.propVO.displayName..data:ValueToString().."[-][/c]"
	end
end
