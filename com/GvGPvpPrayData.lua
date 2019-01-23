local singlePray = class("singlePray")

function singlePray:_setSinglePrayData(serviceData)
	self.id=serviceData.prayid
	self.staticData=Table_Guild_Faith[self.id]
	self.lv=serviceData.praylv
	self.type=serviceData.type
	local serviceAttr = serviceData.attrs
	if(serviceAttr and #serviceAttr>0)then
		local attrId = serviceAttr[1].type
		self.attrStaticData=Table_RoleData[attrId]
		self.attrValue=serviceAttr[1].value
	else
		self.attrValue=0
	end
	local itemInfo = serviceData.costs
	if(itemInfo and #itemInfo>0)then
		local item = ItemData.new(itemInfo[1].guid,itemInfo[1].id)
		item.num=itemInfo[1].count
		self.itemCost=item
	end
end


GvGPvpPrayData = class("GvGPvpPrayData");

GvGPvpPrayData.pType={
	GODNESS = GuildCmd_pb.EPRAYTYPE_GODDESS,
	ATK = GuildCmd_pb.EPRAYTYPE_GVG_ATK,
	DEF = GuildCmd_pb.EPRAYTYPE_GVG_DEF,
	ELE = GuildCmd_pb.EPRAYTYPE_GVG_ELE,
}

function GvGPvpPrayData:SetPrayData(data)
	self.staticId=data.pray
	self.lv=data.lv
	self.curPray=singlePray.new()
	self.curPray:_setSinglePrayData(data.cur)
	self.nextPray=singlePray.new()
	self.nextPray:_setSinglePrayData(data.next)
	self:_SetPrayType()
	self.id=(0==self.curPray.lv) and self.nextPray.id or self.curPray.id
end

function GvGPvpPrayData:_SetPrayType()
	if(0==self.curPray.lv)then
		if(self.nextPray)then
			self.type=self.nextPray.type
		end
	else
		self.type=self.curPray.type
	end
end

local args={}
function GvGPvpPrayData:GetAddAttrValue()
	if(not self.nextPray or 0== self.nextPray.lv)then
		args[1]=false
		args[2]=self.curPray.staticData.AttrName;
		local cur = self.curPray.attrValue
		args[3]=self.curPray.attrStaticData.IsPercent==1 and string.format("%s%%", cur/100) or cur/10000;
	else
		args[1]=true
		args[2]=self.nextPray.staticData.AttrName;
		local curAttrValue = self.curPray.attrValue
		local nextAttrVal=self.nextPray.attrValue
		local IsPercent= self.nextPray.attrStaticData and self.nextPray.attrStaticData.IsPercent or self.curPray.attrStaticData.IsPercent
		args[3]=IsPercent==1 and string.format("%s%%", curAttrValue/100) or curAttrValue/10000;
		local deltaValue =  nextAttrVal-curAttrValue;
		args[4]= IsPercent==1 and string.format("%s%%", deltaValue/100) or deltaValue/10000;
		if(self.nextPray.itemCost)then
			args[5]=self.nextPray.itemCost.num
			args[6]=self.nextPray.itemCost.staticData.NameZh
		end
	end
	args[7]=self.type
	return args;
end




