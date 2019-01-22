autoImport("ProfessionTypeIconCell")
autoImport("ProfessionPage")
local baseCell = autoImport("BaseCell")
AdventureFriendCell = class("AdventureFriendCell",baseCell)

function AdventureFriendCell:Init()
	self:initView()	
end

local tempVector3 = LuaVector3.zero
function AdventureFriendCell:initView(  )
	-- body
	self.bg = self:FindComponent("bg",UISprite)
	self.appellationName = self:FindGO("appellationName"):GetComponent(UILabel)
	self.manualLevel = self:FindGO("manualLevel"):GetComponent(UILabel)
	self.userName = self:FindGO("userName"):GetComponent(UILabel)	

	self.rankIcon = self:FindComponent("rankIcon",UISprite)
	self.rankNum = self:FindComponent("rankNum",UILabel)
	self.userName = self:FindComponent("userName",UILabel)
end

function AdventureFriendCell:initHead(  )
	-- body	
	if(not self.targetCell)then
		local headCellObj = self:FindGO("PortraitCell")
		headCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), headCellObj);
		tempVector3:Set(0,0,0)
		headCellObj.transform.localPosition = tempVector3
		self.targetCell = PlayerFaceCell.new(headCellObj);
		self.targetCell:HideLevel()
		self.targetCell:HideHpMp()
	end
	local headData = HeadImageData.new()
	if(self.data and self.data.myself)then
		headData:TransByLPlayer(Game.Myself)
		-- ????????????
	elseif(self.data)then
		headData:TransByFriendData(self.data)
	end
	headData.job = nil;
	self.targetCell:SetData(headData)
end

local tempColor = LuaColor.white
function AdventureFriendCell:SetData(data)
	self.data = data
	if(self.data)then
		self:Show()
	else
		self:Hide()
		return
	end
-- 	IconManager:SetProfessionIcon(data.profession)
-- 	self.level.text = data:GetLevelText()

	-- local professionData = Table_Class[data.profession]
	-- professionData.portrait = data.portrait
	-- self.currentPfnTypeIconCell:SetData(professionData)
	-- self.currentPfnTypeIconCell:isShowName(false)
	self.manualLevel.text = "Lv."..data.adventureLv
	local itemData = Table_Item[data.appellation]
	if(itemData)then
		self.appellationName.text = itemData.NameZh
	else
		self.appellationName.text = ZhString.AdventureHomePage_NoneAppellation
	end
	self.rankNum.text = data.rank
	self.userName.text = data.name
	----[[ todo xde ?????????????????????
	self.userName.text = AppendSpace2Str(data.name)
	--]]
	if(data.rank <=3 )then
		self.rankIcon.spriteName = string.format("Adventure_icon_%d",data.rank)
		self:Show(self.rankIcon.gameObject)
	elseif(data.rank <=10)then
		self.rankIcon.spriteName = "Adventure_icon_4-10"
		self:Show(self.rankIcon.gameObject)
	else
		self:Hide(self.rankIcon.gameObject)
	end

	if(data.myself)then
		tempColor:Set(215/255,239/255,254/255,1)		
		self.bg.color = tempColor
	else
		tempColor:Set(1,1,1,1)		
		self.bg.color = tempColor
	end

	self:initHead()
end
