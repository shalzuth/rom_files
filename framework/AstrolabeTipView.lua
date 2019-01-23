AstrolabeTipView=class("AstrolabeTipView",BaseTip)
autoImport("AstrolabeMaterilaCell")
local tempVector3 = LuaVector3.zero
local minWidth = 200
local maxWidth = 360
local minHeight = 210
local maxHeight = 415
local singleLineHeight = 20
local fix = 80

function AstrolabeTipView:Init()
	self.closecomp = self.gameObject:GetComponent(CustomTouchUpCall)
	local root = self:FindGO("BG")
	self.closecomp.call = function (go)
		self:CloseSelf();

		-- helplog("click other")		
		-- self:CalculateWidth()
		-- self:_UpdateAnchor(); --test
		-- self:_ResetAttrPos()
	end
	self.BGImg = self:FindComponent("BG",UISprite)
	self.name = self:FindComponent("name", UILabel)
	self.top = self:FindComponent("Top", UIWidget)
	self.attri = self:FindComponent("attri", UILabel)
	self.material = self:FindComponent("material",UILabel)
	self.uiTable = self:FindComponent("materialRoot", UITable);
	self.bottomLine = self:FindComponent("seperatorflag_Bottom",UIWidget)
	self.line=self:FindComponent("line",UISprite)
	self.materialCtl = UIGridListCtrl.new(self.uiTable, AstrolabeMaterilaCell, "AstrolabeMaterilaCell");
	self.scrollPanel = self:FindComponent("AttrScroll",UIPanel)
	self.scrollView = self:FindComponent("AttrScroll",UIScrollView)

	self:_AddAnchor(self:FindComponent("TipValidArea",UIWidget))
	self:_AddAnchor(self:FindComponent("Top",UIWidget))
	self:_AddAnchor(self.bottomLine)
	self:_AddAnchor(self:FindComponent("Bottom",UIWidget))
	self:_AddAnchor(self:FindComponent("materialRoot",UIWidget))
	self:_AddAnchor(self:FindComponent("seperatorflag",UIWidget))
	self:_AddAnchor(self:FindComponent("DragCollider",UIWidget))
	self:_AddAnchor(self.scrollPanel)
end

function AstrolabeTipView:SetCheckClick(func)
	if(self.closecomp) then
		self.closecomp.check = function ()
			helplog("SetCheckClick", func);
			return func~=nil and func() or false
		end
	end
end

function AstrolabeTipView:CloseSelf()
	TipsView.Me():HideCurrent();
	self:sendNotification(AstrolabeEvent.TipClose);
end

function AstrolabeTipView:SetData(data)
	self.name.text= data:GetName()
	local materialData = data:GetCost()
	self:_ParseAttr(data)
	self.materialCtl:ResetDatas(materialData)

	self:CalculateWidth()
	self:_UpdateAnchor();
	self:_ResetAttrPos()
end

function AstrolabeTipView:OnEnter()
	AstrolabeTipView.super.OnEnter(self)
	self.closecomp.enabled = false
	self.closecomp.enabled = true
end

function AstrolabeTipView:GetSize()
	return self.BGImg.width,self.BGImg.height
end

function AstrolabeTipView:_ParseAttr(data)
	local base = data:GetEffect()
	if(base) then
		local sb = LuaStringBuilder.CreateAsTable()
		local config,displayName,value
		local PropNameConfig = Game.Config_PropName
		for k,v in pairs(base) do
			config = PropNameConfig[k]
			if(config) then
				displayName = config.RuneName ~= "" and config.RuneName or config.PropName;
				sb:Append(displayName)
				if(v>0) then
					sb:Append("+")
				end
				if(config.IsPercent==1)then
					sb:Append(v * 100)
					sb:AppendLine("%")
				else
					sb:AppendLine(v)
				end
			end
		end
		sb:RemoveLast()
		self.attri.text=sb:ToString()
		sb:Destroy()
	end
	local special = data:GetSpecialEffect()
	if(special) then
		local specialConfig = Table_RuneSpecial[special]
		if(specialConfig) then
			local str = specialConfig.Runetip
			if(Table_RuneSpecialDesc and Table_RuneSpecialDesc[str]) then
				str=Table_RuneSpecialDesc[str].Text
			end
			if(specialConfig.SkillTipParm) then
				str = string.format(str,unpack(specialConfig.SkillTipParm))
			end
			self.attri.text = str
		end
	end
end

function AstrolabeTipView:_AddAnchor(widget)
	if(self.anchors == nil) then
		self.anchors = {}
	end
	self.anchors[#self.anchors+1] = widget
end

function AstrolabeTipView:_UpdateAnchor()
	if(self.anchors) then
		for i=1,#self.anchors do
			self.anchors[i]:ResetAndUpdateAnchors()
		end
	end
end

function AstrolabeTipView:SetPos(pos)
	if(self.gameObject~=nil) then
		local p = self.gameObject.transform.position
		pos.z = p.z
		self.gameObject.transform.position = pos
		-- TipsView.Me().panel:ConstrainTargetToBounds(self.gameObject.transform,true)
	else
		self.pos = pos
	end 
end

function AstrolabeTipView:CalculateWidth()
	local maxLabelWidth =0 
	local childCells = self.materialCtl:GetCells();
	local singleMaterialHeight = 0
	if(self.materialCtl)then
		for i=1,#childCells do
			local childCell = childCells[i];
			local width = childCell:GetLabelWidth()
			singleMaterialHeight=childCell:GetHeight()
			if(width>maxLabelWidth)then
				maxLabelWidth=width
			end
		end
	end
	local materialCount = #childCells
	singleLineHeight = self.top.height + 82
	local fixedHeight = singleMaterialHeight* materialCount+singleLineHeight -- 材料高度+名字高度
	tempVector3:Set(0,singleMaterialHeight* materialCount,0)
	self.bottomLine.transform.localPosition = tempVector3
	local tempWidth = math.max(self.name.width,maxLabelWidth)
	local tempWidth = math.max(tempWidth,minWidth)
	local tempHeight = 0
	-- helplog(tempWidth,minWidth,fixedHeight)
	-- helplog(singleMaterialHeight,singleLineHeight)
	
	--fix
	local attrSizeX,attrSizeY = self:_WrapText(fix)
	self.attri.width = attrSizeX
	self.attri:ProcessText()
	tempWidth = math.max(tempWidth,attrSizeX + fix)
	local height = attrSizeY + fixedHeight
	-- helplog(attrSizeX,attrSizeY)
	tempHeight = math.max(minHeight,height)
	tempHeight = math.min(maxHeight,tempHeight)
	-- helplog(tempWidth,tempHeight)
	if(nil~=self.BGImg)then
		self.BGImg.width=tempWidth
		self.BGImg.height=tempHeight
	end
end

--return attrWidth,attrHeight
function AstrolabeTipView:_WrapText(fix)
	local width = 0
	self.attri:UpdateNGUIText()
	NGUIText.rectWidth = 10000
	NGUIText.regionWidth = 10000
	local size = NGUIText.CalculatePrintedSize(self.attri.text)
	width = math.max(size.x,minWidth-fix)
	width = math.min(width,maxWidth-fix)
	self.attri:UpdateNGUIText()
	NGUIText.rectWidth = width
	NGUIText.regionWidth = width
	size = NGUIText.CalculatePrintedSize(self.attri.text)
	return width,size.y
end

function AstrolabeTipView:_ResetAttrPos()
	tempVector3:Set(-(self.BGImg.width-fix)/2,0,0)
	self.attri.transform.localPosition = tempVector3
	self.scrollView:ResetPosition()
end

function AstrolabeTipView:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function AstrolabeTipView:DestroySelf()
	GameObject.Destroy(self.gameObject)
end

function AstrolabeTipView:OnExit()
	--这边发事件
	self.anchors = nil
	return true;
end