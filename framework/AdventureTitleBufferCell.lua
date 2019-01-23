local baseCell = autoImport("BaseCell")
AdventureTitleBufferCell = class("AdventureTitleBufferCell",baseCell)

function AdventureTitleBufferCell:Init()
	self:initView()
end


function AdventureTitleBufferCell:initView(  )
	-- body
	self.text = self:FindComponent("text",UILabel)
end

function AdventureTitleBufferCell:SetData( data )
	-- body
	local name = data[1]
	local value = data[2]
	local config = Game.Config_PropName[ data[1] ];
	if(config ~= nil)then
		local str = value;
		if(config.IsPercent==1)then
			str = value * 100 .. "%";
		end
		self.text.text = config.PropName.."[c][1F74BF]+"..str.."[-][/c]"
	else
		self.text.text = "can't not fine prop:"..name
	end
	
end
