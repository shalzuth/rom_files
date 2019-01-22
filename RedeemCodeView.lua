RedeemCodeView = class("RedeemCodeView",ContainerView)
RedeemCodeView.ViewType = UIViewType.NormalLayer
-- RedeemCodeView.URL="http://ro-xdcdn.b0.upaiyun.com/roActivity/line/f55554f90e42e15c0dd0b7831987d050.jpg";

local TextureRes=
{
	TitleBg="show_icon_txt",
	InfoBg="shop_bg_card",
	DescBg="shop_bg_bottom",
}
local DescTextureSize = 
{
	width=1056,
	height=590,
}
function RedeemCodeView:Init()
	local viewdata = self.viewdata and self.viewdata.viewdata;
	self.id = viewdata and viewdata.id or 453
	self:FindObjs()
	self:Listen()
	self:ListenEvt()
	self:InitData()
end

function RedeemCodeView:FindObjs()
	self.redeemPos = self:FindGO("redeemPos")
	self.descPos = self:FindGO("descPos")
	self.infoPos = self:FindGO("info")
	self.tips = self:FindComponent("tipsLab",UILabel);
	self.title = self:FindComponent("titleLab",UILabel);
	self.icon = self:FindComponent("iconImg",UISprite);
	self.redeemBtn = self:FindComponent("redeemBtn",UISprite);
	self.copyBtn = self:FindComponent("copyBtn",UISprite);
	self.descTexture = self:FindComponent("descTexture",UITexture)
	self.Loading = self:FindGO("Loading")
	self.inputLab = self:FindComponent("inputLab", UIInput);
	self.usedBoxColider = self:FindComponent("inputLab",BoxCollider)
	self.beUsedImg = self:FindComponent("beUsedImg",UISprite);
	self.returnBtn = self:FindComponent("returnBtn",UISprite);
	self.TextureBgLeftTex = self:FindComponent("TextureBgLeft",UITexture)
	self.TextureBgRightTex = self:FindComponent("TextureBgRight",UITexture)
	self.titleBgTex = self:FindComponent("titleBg",UITexture)
	local iconName = Table_Item[self.id] and Table_Item[self.id].Icon
	IconManager:SetItemIcon(iconName, self.icon);
end

function RedeemCodeView:ListenEvt()
	-- self:AddListenEvt(ActivityTextureManager.ActivityPicCompleteCallbackMsg ,self.picCompleteCallback);
	self:AddListenEvt(ServiceEvent.ItemUseCodItemCmd, self.HandleUseCodItem)
	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdataView);
end


function RedeemCodeView:HandleUseCodItem(note)
	self.sCode = note.body.code
	self:InitData()
end

function RedeemCodeView:Listen()
	self:AddClickEvent(self.redeemBtn.gameObject, function (go)
		-- self:AddPicInfos()
		self:OpenDescPanel()
	end)
	
	self:AddClickEvent(self.returnBtn.gameObject,function (go)
		-- Object.DestroyImmediate(self.descTexture.mainTexture)
		self:OpenRedeemPos(true);
	end)
	EventDelegate.Set(self.inputLab.onChange,function ()
		self:_ResetInputValue()
	end)
end

function RedeemCodeView:_ResetInputValue()
	self.inputLab.value=self.sCode or ""
end

local tempV3 = LuaVector3();
function RedeemCodeView:InitData()
	self.title.text=ZhString.RedeemCodeView_Desc
	self.tips.text=ZhString.RedeemCodeView_Tip
	self:_loadFixedTexture();
	self:Show(self.infoPos)
	self:Hide(self.Loading);
	self:OpenRedeemPos(true);
	self:UpdataView()
	if not BackwardCompatibilityUtil.CompatibilityMode_V17 then
		self:Show(self.copyBtn.gameObject);
		tempV3:Set(120,-130,0);
	else
		self:Hide(self.copyBtn.gameObject);
		tempV3:Set(0,-130,0);
	end
	self.redeemBtn.gameObject.transform.localPosition = tempV3;
end

function RedeemCodeView:UpdataView()
	self.itemCode=BagProxy.Instance:GetItemByStaticID(self.id)
	local used = self.itemCode:IsCodeCanSell()
	self.beUsedImg.gameObject:SetActive(used)
	self.usedBoxColider.enabled=not used
	if(self.itemCode.CodeData and self.itemCode.CodeData.code and ""~=self.itemCode.CodeData.code)then
		local code = self.itemCode.CodeData.code
		self.sCode=code
		self.inputLab.value=code
		self:AddClickEvent(self.copyBtn.gameObject, function (go)
			local result = ApplicationInfo.CopyToSystemClipboard(code)
			if(result)then
				MsgManager.ShowMsgByID(3635)	
			end
		end)
	else
		ServiceItemProxy.Instance:CallUseCodItemCmd(self.itemCode.id)
	end
end

function RedeemCodeView:_loadFixedTexture()
	PictureManager.Instance:SetUI(TextureRes.TitleBg, self.titleBgTex)
	PictureManager.Instance:SetUI(TextureRes.InfoBg, self.TextureBgLeftTex)
	PictureManager.Instance:SetUI(TextureRes.InfoBg, self.TextureBgRightTex)
end

-- function RedeemCodeView:picCompleteCallback( note )
-- 	local data = note.body
-- 	self:completeCallbackBytes(data.byte)
-- end

function RedeemCodeView:OpenRedeemPos(flag)
	self.redeemPos:SetActive(flag)
	self.descPos:SetActive(not flag)
end

-- function RedeemCodeView:completeCallbackBytes(bytes )
-- 	local texture = Texture2D(0,0,TextureFormat.RGB24,false)
-- 	local bRet = texture:LoadImage(bytes)
-- 	if( bRet)then
-- 		self:_setTexture(texture)
-- 	else
-- 		ActivityTextureManager.Instance():log("RedeemCodeView:completeCallbackBytes LoadImage failure")
-- 		Object.DestroyImmediate(texture)
-- 	end
-- end

-- function RedeemCodeView:_setTexture( texture )
-- 	self:Hide(self.Loading)
-- 	Object.DestroyImmediate(self.descTexture.mainTexture)
-- 	self.descTexture.mainTexture = texture
-- 	self.descTexture.width = DescTextureSize.width
-- 	self.descTexture.height = DescTextureSize.height
-- end

-- function RedeemCodeView:AddPicInfos()
-- 	self:OpenRedeemPos(false);
-- 	self:Show(self.Loading)
-- 	local texture = self.descTexture.mainTexture
-- 	self.descTexture.mainTexture = nil
-- 	Object.DestroyImmediate(texture)
-- 	ActivityTextureManager.Instance():AddActivityPicInfos({RedeemCodeView.URL})
-- end

function RedeemCodeView:OpenDescPanel()
	self:OpenRedeemPos(false);
	-- self:Show(self.Loading)
	PictureManager.Instance:SetUI(TextureRes.DescBg, self.descTexture)
end


function RedeemCodeView:OnEnter()
	RedeemCodeView.super.OnEnter(self);
end

function RedeemCodeView:OnExit()
	PictureManager.Instance:UnLoadUI(TextureRes.TitleBg, self.titleBgTex)
	PictureManager.Instance:UnLoadUI(TextureRes.InfoBg, self.TextureBgLeftTex)
	PictureManager.Instance:UnLoadUI(TextureRes.InfoBg, self.TextureBgRightTex)
	PictureManager.Instance:UnLoadUI(TextureRes.DescBg, self.descTexture)
	RedeemCodeView.super.OnExit(self);
end
