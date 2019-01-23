SceneTopFuncWord = reusableClass("SceneTopFuncWord")

SceneTopFuncWord.PoolSize = 50

SceneTopFuncWord.ResID = ResourcePathHelper.UICell("SceneTopFuncWord")

function SceneTopFuncWord:InitCellGO()
	if(LuaGameObject.ObjectIsNull(self.gameObject))then
		return;
	end

	self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero;
	self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity;
	self.gameObject.transform.localScale = LuaGeometry.Const_V3_one;

	self.label = GameObjectUtil.Instance:DeepFind(self.gameObject, "Label"):GetComponent(UILabel);
	self.labelOriginalDepth = self.label.depth;

	self.leftlabel = GameObjectUtil.Instance:DeepFind(self.gameObject, "LeftLabel"):GetComponent(UILabel);
	self.leftlabelOriginalDepth = self.leftlabel.depth;

	self.rightlabel = GameObjectUtil.Instance:DeepFind(self.gameObject, "RightLabel"):GetComponent(UILabel);
	self.rightlabelOriginalDepth = self.rightlabel.depth;

	self.symbol = GameObjectUtil.Instance:DeepFind(self.gameObject, "Symbol"):GetComponent(UISprite);
	self.symbolOriginalDepth = self.symbol.depth;

	self.bg = GameObjectUtil.Instance:DeepFind(self.gameObject, "Bg1"):GetComponent(UISprite);
	self.bgOriginalDepth = self.bg.depth;
end

function SceneTopFuncWord:SetMinDepth(mindepth)
	self.label.depth = mindepth + self.labelOriginalDepth;
	self.leftlabel.depth = mindepth + self.leftlabelOriginalDepth;
	self.rightlabel.depth = mindepth + self.rightlabelOriginalDepth;
	self.symbol.depth = mindepth + self.symbolOriginalDepth;
	self.bg.depth = mindepth + self.bgOriginalDepth;
end


function SceneTopFuncWord:HelpSetLabel(label, text)
	if(text==nil or text=="")then
		label.gameObject:SetActive(false);
	else
		label.gameObject:SetActive(true);
		label.text = text;
		UIUtil.WrapLabel(label)
	end
end

function SceneTopFuncWord:Active(b)
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		self.gameObject:SetActive(b);
	end
end

-- override begin
-- args { gameObject, text icon clickFunc }
function SceneTopFuncWord:DoConstruct(asArray, args)
	self.gameObject = args[1];
	self:InitCellGO();

	local text = args[2];
	local icon = args[3];
	local clickFunc = args[4];
	local clickArgs = args[5];

	if(type(text) == "string")then
		self:HelpSetLabel(self.label, text);
		UIUtil.WrapLabel(self.label)

		self:HelpSetLabel(self.leftlabel, nil);
		self:HelpSetLabel(self.rightlabel, nil);
	elseif(type(text) == "table")then
		self:HelpSetLabel(self.label, nil);

		self:HelpSetLabel(self.leftlabel, text.left);
		self:HelpSetLabel(self.rightlabel, text.right);
	end

	if(icon)then
		self.symbol.gameObject:SetActive(true);
		IconManager:SetUIIcon(tostring(icon), self.symbol)
		self.symbol:MakePixelPerfect();
	else
		self.symbol.gameObject:SetActive(false);
	end

	if(clickFunc and self.bg)then
		self:AddClickEvent(self.bg.gameObject,function (go)
			clickFunc(clickArgs);
		end);
	end

end

function SceneTopFuncWord:DoDeconstruct(asArray)
	self.parent = nil;

	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		Game.GOLuaPoolManager:AddToSceneUIPool(SceneTopFuncWord.ResID, self.gameObject);

		self:AddClickEvent(self.bg.gameObject, nil);
	end
	self.gameObject = nil;
end
-- override end


----------------------------------------------------------------------
function SceneTopFuncWord:AddClickEvent( obj, event )
	if(event == nil)then
		UIEventListener.Get(obj).onClick = nil;
		return;
	end

	UIEventListener.Get(obj).onClick = function (go)
		if(event)then
			event(go);			
		end
	end
end


