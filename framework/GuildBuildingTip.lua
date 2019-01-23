autoImport("BaseTip")
GuildBuildingTip = class("GuildBuildingTip", BaseTip)

GuildBuildingTipType = {
	synopsis = 1,
	FuncDesc = 2,
	LevelUpPreview = 3,
}
function GuildBuildingTip:Init()
	self:FindObj()
	self:InitData()
end

function GuildBuildingTip:InitData()
	self.contextDatas = {};
end

function GuildBuildingTip:FindObj()
	self.nameLab=self:FindComponent("name",UILabel)
	self.iconImg=self:FindComponent("icon",UISprite)
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	self.scrollview=self:FindComponent("ScrollView",UIScrollView)

	local table = self:FindComponent("Table", UITable);
	self.attriCtl = UIGridListCtrl.new(table, TipLabelCell, "TipLabelCell");
	
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
	GuildBuildingTip.super.Init(self);
end

function GuildBuildingTip:SetData(data)
	local data = data.itemdata
	self.data=data
	if(not self.data)then return end
	local level = data.staticData.Level
	self.nameLab.text= level>0 and string.format(ZhString.GuildBuilding_Title,data.staticData.Name,level) or data.staticData.Name
	IconManager:SetUIIcon(data.staticData.Icon,self.iconImg)

	local desc = data.staticData.Desc
	local funcDesc = data.staticData.FuncDesc
	local levelUpDesc = data.staticData.LevelUpPreview
	-- start Set Tip
	TableUtility.TableClear(self.contextDatas);
	local synopsisTip = {};
	synopsisTip.label = desc
	synopsisTip.hideline = (""~=funcDesc)
	self.contextDatas[#self.contextDatas+1] = synopsisTip;
	local temp = "\n"
	if(""~=funcDesc)then
		local FuncDescTip = {};
		if(string.match(funcDesc,temp))then
			local funcDescStrs = string.split(funcDesc,temp)
			FuncDescTip.label = {};
			for i=1,#funcDescStrs do
				local cell = "{uiicon=tips_icon_01} "..funcDescStrs[i];
				table.insert(FuncDescTip.label, cell);
			end
		else
			FuncDescTip.label = funcDesc
		end
		FuncDescTip.hideline = false
		self.contextDatas[#self.contextDatas+1] = FuncDescTip;
	end

	-- local myGuildLv = GuildProxy.Instance.myGuildData.level
	-- local needShow = level<myGuildLv
	-- if(needShow)then
		local levelUpDescTip = {};
		if(string.match(levelUpDesc,temp))then
			local strs = string.split(levelUpDesc, "\n")
			levelUpDescTip.label = {};
			table.insert(levelUpDescTip.label, ZhString.GuildBuilding_LevelUpPreview);
			for i=1,#strs do
				local cell = "{uiicon=tips_icon_01} "..strs[i];
				table.insert(levelUpDescTip.label, cell);
			end
		else
			levelUpDescTip.label = levelUpDesc
		end
		levelUpDescTip.hideline = true;
		self.contextDatas[#self.contextDatas+1] = levelUpDescTip;
	-- end

	self.attriCtl:ResetDatas(self.contextDatas);
	self.scrollview:ResetPosition()
end

function GuildBuildingTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function GuildBuildingTip:CloseSelf()
	if(self.callback)then
		self.callback(self.callbackParam);
	end
	TipsView.Me():HideCurrent();
end

function GuildBuildingTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		GameObject.Destroy(self.gameObject);
	end	
end




