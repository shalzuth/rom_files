local BaseCell = autoImport("BaseCell");
ProfessionIconCell = class("ProfessionIconCell", BaseCell)
ProfessionIconCell.AttrLightColor = Color(44/255,100/255,235/255)

function ProfessionIconCell:Init()
	self:initView()
	self:initData()
end

function ProfessionIconCell:initData(  )
	self.isSelected = true
	self:setIsSelected(false)
end

function ProfessionIconCell:setIsSelected( isSelected )
	if(isSelected ~= self.isSelected)then
		self.isSelected = isSelected
	end
	if isSelected then
		self.mark.gameObject:SetActive(true)
		ProfessionProxy.Instance:SetTopScrollChooseID(self:Getid())	
	else
		self.mark.gameObject:SetActive(false)
	end	
end

function  ProfessionIconCell:initView(  )
	self.Node = self:FindGO("Node")
	self.ProfessIcon = self:FindGO("ProfessIcon",self.Node)
	self.CostedPointBg = self:FindGO("CostedPointBg",self.Node)
	self.CostedPointLabel = self:FindGO("CostedPointLabel",self.CostedPointBg)
	self.AttrLabel = self:FindGO("AttrLabel",self.CostedPointBg)
	self.CareerBg = self:FindGO("CareerBg",self.Node)
	self.CareerBord  = self:FindGO("CareerBord",self.CareerBg)
	self.Plus = self:FindGO("Plus",self.Node)
	self.mark = self:FindGO("mark")
	self.ProfessIcon_UISprite = self.ProfessIcon:GetComponent(UISprite)	
	self.CostedPointLabel_UILabel = self.CostedPointLabel:GetComponent(UILabel)	
	self.AttrLabel_UILabel =  self.AttrLabel:GetComponent(UILabel)	
	self.CareerBg_UISprite = self.CareerBg:GetComponent(UISprite)
	self.mark.gameObject:SetActive(false)
end

function ProfessionIconCell:SetShowType(mType )
	if mType == 1 then
		self.CostedPointBg.gameObject:SetActive(false)
		self.CareerBg.gameObject:SetActive(false)
		self.Plus.gameObject:SetActive(false)
	elseif mType == 2 then
		self.CostedPointBg.gameObject:SetActive(true)
		self.CareerBg.gameObject:SetActive(true)
		if ProfessionProxy.Instance:IsMPOpen() then
			self.Plus.gameObject:SetActive(true)
		else
			self.Plus.gameObject:SetActive(false)
		end	
	else

	end	
end

function ProfessionIconCell:addViewEventListener(  )
	-- body	
end

local tempColor = LuaColor.white

function ProfessionIconCell:SetData(data)
	self.data = data
	if self.data ~=nil then
		self.ProfessIcon_UISprite.spriteName = "icon_"..self.data.Type.."_".."1"
		self.ProfessIcon_UISprite.color = LuaColor(1/255,2/255,3/255,1)
		if data.isGrey == true then
			self.ProfessIcon_UISprite.color = LuaColor(1/255,2/255,3/255,1)
		else
			self.ProfessIcon_UISprite.color = LuaColor(1,1,1,1)
		end	
		self:AddClickEvent(self.ProfessIcon,function ()
			self:PassEvent(MouseEvent.MouseClick, self);
		end)

	else
		helplog("review code !!")
	end	
end

local tempVector3 = LuaVector3.zero

function ProfessionIconCell:initHead(  )
end

function ProfessionIconCell:SetIcon(id)
	local thisidClass = Table_Class[id]
	local iconName = "icon_1_0"
	if id == 1 then
		iconName= "icon_1_0"
	else
		local geweishu = id%10
		local shiweishu = string.format("%d",(id-id%10)/10) 
		iconName= "icon_"..shiweishu.."_"..geweishu
	end	
	local thisidType = thisidClass.Type 
	local colorKey = "CareerIconBg"..thisidType;
	self.CareerBg_UISprite.color = ColorUtil[colorKey];
	self.ProfessIcon_UISprite.spriteName = iconName
	self.CostedPointLabel_UILabel.text = thisidClass.NameZh
	if ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) and ProfessionProxy.Instance:IsMPOpen() then
		self.AttrLabel_UILabel.color = ProfessionIconCell.AttrLightColor
	else
		self.AttrLabel_UILabel.color = Vector3(0,0,0)
	end	
end

function ProfessionIconCell:SetState( state ,id)
	local PlusNeedShow = false
	if state == 0 then
	elseif state == 1 then
		local sprites = UIUtil.GetAllComponentsInChildren(self.ProfessIcon_UISprite, UISprite, true);
		for i=1,#sprites do
			sprites[i].color = Color(1,1,1)
		end
		sprites = UIUtil.GetAllComponentsInChildren(self.CareerBg, UISprite, true);
		for i=1,#sprites do
			sprites[i].color = Color(1,1,1)
		end
		local thisidClass = Table_Class[id]
		local thisidType = thisidClass.Type 
		local colorKey = "CareerIconBg"..thisidType;
		self.CareerBg_UISprite.color = ColorUtil[colorKey];
	elseif state == 2 then
	elseif state == 3 	then	
		local sprites = UIUtil.GetAllComponentsInChildren(self.ProfessIcon_UISprite, UISprite, true);
		for i=1,#sprites do
			sprites[i].color = Color(1/255,2/255,3/255)
		end
		sprites = UIUtil.GetAllComponentsInChildren(self.CareerBg, UISprite, true);
		for i=1,#sprites do
			sprites[i].color = Color(1/255,2/255,3/255)
		end
		PlusNeedShow = true
		self:AddClickEvent(self.Plus.gameObject,function ()
				self:PassEvent(CheckAllProfessionPanel.PlusClick,id)
		end)
	elseif state == 4 then
		local sprites = UIUtil.GetAllComponentsInChildren(self.ProfessIcon_UISprite, UISprite, true);
		for i=1,#sprites do
			sprites[i].color =  Color(1/255,2/255,3/255)
		end
		sprites = UIUtil.GetAllComponentsInChildren(self.CareerBg, UISprite, true);
		for i=1,#sprites do
			sprites[i].color = Color(1/255,2/255,3/255)
		end
		local thisidClass = Table_Class[id]
		local thisidType = thisidClass.Type 
		local colorKey = "CareerIconBg"..thisidType;
	end	
	self.Plus.gameObject:SetActive(PlusNeedShow and ProfessionProxy.Instance:IsMPOpen())
	if ProfessionProxy.Instance:ShouldThisIdVisible(id) then
		self.Node.gameObject:SetActive(true)
	else
		self.Node.gameObject:SetActive(false)
	end
end	

function ProfessionIconCell:Setid( id )
	self.id =id
end

function ProfessionIconCell:Getid( )
	return self.id or 0
end

function ProfessionIconCell:GetData( )
	return self.data 
end

function ProfessionIconCell:isShowName( isShow )
end

function ProfessionIconCell:SetAttr( str )
	self.AttrLabel_UILabel.text = str
end





