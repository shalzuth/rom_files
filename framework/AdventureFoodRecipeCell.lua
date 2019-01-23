local baseCell = autoImport("BaseCell")
AdventureFoodRecipeCell = class("AdventureFoodRecipeCell",baseCell)

function AdventureFoodRecipeCell:Init()
	self:initView()
end


function AdventureFoodRecipeCell:initView(  )
	-- body
	self.text = self:FindComponent("text",UILabel)
end

function AdventureFoodRecipeCell:SetData( data )
	-- body
	local starLv = data.lv
	local num = data.count
	self.text.text = string.format(ZhString.AdventureFoodPage_RecipeCellText,starLv,num)
end
