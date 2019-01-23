local BaseCell = autoImport("BaseCell");
YoyoRoomToggleCell = class("YoyoRoomToggleCell", BaseCell);
local choosen = "com_bg_money3"
local unChoosen = "com_bg_property"
local choosenLabCol = "[365A96]"
local unChoosenLabCol = "[383838]"
function YoyoRoomToggleCell:Init()
	YoyoRoomToggleCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function YoyoRoomToggleCell:FindObjs()
	self.chooseImg = self.gameObject:GetComponent("UISprite")
	self.roomName = self:FindComponent("roomName",UILabel);
end

function YoyoRoomToggleCell:ShowChooseImg(mapID)
	if(mapID==self.data)then
		self.chooseImg.spriteName = choosen
		self.roomName.text=string.format("[c]%s%s[-][/c]",choosenLabCol,self.name)
	else
		self.chooseImg.spriteName = unChoosen
		self.roomName.text=string.format("[c]%s%s[-][/c]",unChoosenLabCol,self.name)
	end
end

function YoyoRoomToggleCell:SetData(data)
	self.data=data
	-- data is mapID
	local mapCsv = Table_Map[data]
	if(mapCsv and mapCsv.NameZh)then
		self.roomName.text=mapCsv.NameZh;
		self.name=mapCsv.NameZh
	else
		helplog("can't find Table_Map csvData ,error mapID: ",tostring(data))
	end
end

