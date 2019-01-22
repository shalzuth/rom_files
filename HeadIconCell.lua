BaseCell = autoImport("BaseCell") 
HeadIconCell = class("HeadIconCell", BaseCell)
HeadIconCell.path = ResourcePathHelper.UICell("HeadIconCell")

HeadIconCell.State = {
	StandFace = 1,
	Blink = 2,
	Emoji = 3,
	UnActive = 4,
}

HeadIconCell.BlinkConfig = Table_Avatar[1]
--????????????????????????
HeadIconCell.BlinkTimeCheck = {2000,5000}

function HeadIconCell:Init()
	self.active = true
	self.state = HeadIconCell.State.StandFace
	self:FindObjs()
end

function HeadIconCell:CreateSelf(parent)
	if(parent) then
		self.gameObject = self:CreateObj(HeadIconCell.path,parent)
		self:FindObjs()
	end
end

function HeadIconCell:SetClickEnable(val)
	if(self.clickObj~=nil) then
		self.clickObj.gameObject:SetActive(val)
	end
end

function HeadIconCell:SetScale(scale)
	if(self.gameObject)then
		self.gameObject.transform.localScale = Vector3.one * scale
	end
end

function HeadIconCell:FindObjs()
	if(self.gameObject) then
		--????????????
		self.clickObj = self.gameObject:GetComponent(UIWidget)
	else
		return
	end
	--???
	self.frameSp = self:FindGO("Frame"):GetComponent(UISprite)
	--????????????
	self.headAccessoryback = self:FindGO("Head_Accessory_back"):GetComponent(UISprite)
	--????????????
	self.hairback = self:FindGO("Hair_back"):GetComponent(UISprite)
	--??????
	self.body = self:FindGO("Body"):GetComponent(UISprite)
	--????????????
	self.baseFace = self:FindGO("BaseFace"):GetComponent(UISprite)
	--??????
	self.eye = self:FindGO("Eye"):GetComponent(UISprite)
	--????????????
	self.hairfront = self:FindGO("Hair_front"):GetComponent(UISprite)
	--??????
	self.hairAccessory = self:FindGO("Hair_Accessory"):GetComponent(UISprite)
	--????????????
	self.headAccessoryfront = self:FindGO("Head_Accessory_front"):GetComponent(UISprite)
	--??????
	self.faceAccessory = self:FindGO("Face_Accessory"):GetComponent(UISprite)
	--??????
	self.mouthAccessory = self:FindGO("Mouth_Accessory"):GetComponent(UISprite)
	--avatar?????????
	self.avatarPars = self:FindGO("FaceParts")
	--??????icon
	self.simpleIcon = self:FindGO("SimpleHeadIcon"):GetComponent(UISprite)
end

function HeadIconCell:SetMinDepth(minDepth)
	self:SetDepth(self.clickObj,minDepth)
	self:SetDepth(self.frameSp,minDepth+1)
	self:SetDepth(self.headAccessoryback,minDepth+2)
	self:SetDepth(self.hairback,minDepth+3)
	self:SetDepth(self.simpleIcon, minDepth+3)
	self:SetDepth(self.body,minDepth+4)
	self:SetDepth(self.baseFace,minDepth+5)
	self:SetDepth(self.eye,minDepth+6)
	self:SetDepth(self.hairfront,minDepth+7)
	self:SetDepth(self.hairAccessory,minDepth+8)
	self:SetDepth(self.headAccessoryfront,minDepth+9)
	self:SetDepth(self.faceAccessory,minDepth+10)
	self:SetDepth(self.mouthAccessory,minDepth+11)
end

function HeadIconCell:SetDepth(widget,depth)
	if(widget~=nil) then
		widget.depth = depth
	end
end

function HeadIconCell:SetCreatureID(guid)
	self.id = guid
	self:InitEmoji()
end

function HeadIconCell:InitEmoji()
	if(self.id and self.syncEmoji) then
		--???????????????
		local initEmojiID = FunctionPlayerHead.Me():GetEmojiCache(self.id)
		if(initEmojiID) then
			self:TryPlayEmojiID(initEmojiID)
		end
	end
end

function HeadIconCell:SetEnabelEmojiFace(val)
	self.enableEmojiFace = val
	if(not self.enableEmojiFace) then
		self:ForceToStandFace()
	end
end

--???????????????face???????????????????????????
function HeadIconCell:SetSimpleIcon(icon)
	self:SetEnabelEmojiFace(false)

	self:Hide(self.avatarPars)
	self:Show(self.simpleIcon.gameObject)

	if(self.simpleIcon~=nil and icon~=nil) then
		IconManager:SetFaceIcon(icon, self.simpleIcon)
	end
end

--??????avatar??????
function HeadIconCell:SetData(data)
	self.data = data

	local hairID,headID,faceID,mouthID,bodyID,eyeID = 
		self:ParseDisplayLogic(self.data.hairID, self.data.headID, self.data.faceID, self.data.mouthID, self.data.bodyID, self.data.eyeID)

	local bodydata = Table_Body[bodyID]
	if bodydata ~= nil and bodydata.HeadIcon ~= "" then
		self:SetSimpleIcon(bodydata.HeadIcon)
		return
	end

	self:SetEnabelEmojiFace(true)

	if(self.data~=nil and self.data.id~=nil) then
		self:SetCreatureID(self.data.id)
	end

	self:Show(self.avatarPars)
	self:Hide(self.simpleIcon.gameObject)

	self:SetHairColor(self.data.hairID,self.data.haircolor)

	self:SetHair(hairID)
	self:SetHairAccessory(hairID)
	self:SetBody(bodyID)
	self:SetFace(self.data.gender)
	self:SetHeadAccessory(headID)
	self:SetFaceAccessory(faceID)
	self:SetMouthAccessory(mouthID)
	self:SetEye(eyeID)

	if self.data.blink ~= nil then
		self:SetBlinkEnable(self.data.blink)
	end
end

local parts = Asset_Role.CreatePartArray()
local PartIndex = Asset_Role.PartIndexEx
--return hairID,headID,faceID,mouthID
function HeadIconCell:ParseDisplayLogic(hairID,headID,faceID,mouthID,bodyID,eyeID)
	parts[PartIndex.Hair] = hairID or 0
	parts[PartIndex.Head] = headID or 0
	parts[PartIndex.Face] = faceID or 0
	parts[PartIndex.Mouth] = mouthID or 0
	parts[PartIndex.Body] = bodyID or 0
	parts[PartIndex.Eye] = eyeID or 0

	Asset_Role.PreprocessParts(parts, 0)

	return parts[PartIndex.Hair], parts[PartIndex.Head], parts[PartIndex.Face], parts[PartIndex.Mouth], parts[PartIndex.Body], parts[PartIndex.Eye]
end

function HeadIconCell:SetClickWidthHeight(w,h)
	if(self.clickObj~=nil) then
		self.clickObj.width = w
		self.clickObj.height = h
	end
end

function HeadIconCell:MakePixelPerfect(uiwidget)
	if(uiwidget~=nil) then
		uiwidget:MakePixelPerfect()
	end
end

function HeadIconCell:SetHair(hairID)
	if(hairID~=nil) then
		local hair = Table_HairStyle[hairID]
		if(hair) then
			self:Show(self.hairback.gameObject)
			self:Show(self.hairfront.gameObject)

			--set back
			if hair.HairBack then
				self:SetSpriteName(self.hairback,hair.HairBack)
			else
				errorLog(string.format("HeadIconCell SetHair : %s HairBack = nil",tostring(hairID)))
			end
			--set front
			if hair.HairFront then
				self:SetSpriteName(self.hairfront,hair.HairFront)
			else
				errorLog(string.format("HeadIconCell SetHair : %s HairFront = nil",tostring(hairID)))
			end
			self:MakePixelPerfect(self.hairback)
			self:MakePixelPerfect(self.hairfront)
		else
			self:Hide(self.hairback.gameObject)
			self:Hide(self.hairfront.gameObject)
			-- errorLog("HeadIconCell try set Hair but cannot find config,id is :"..hairID)
		end
	else
		-- errorLog("HeadIconCell try set Hair but hairID is nil")
	end
end

function HeadIconCell:SetHairAccessory(hairID)
	if(hairID~=nil) then
		local hair = Table_HairStyle[hairID]
		if(hair) then
			self:Show(self.hairAccessory.gameObject)

			if hair.HairAdornment then
				self:SetSpriteName(self.hairAccessory,hair.HairAdornment)
			else
				errorLog(string.format("HeadIconCell SetHairAccessory : %s HairAdornment = nil",tostring(hairID)))
			end
			self:MakePixelPerfect(self.hairAccessory)
		else
			self:Hide(self.hairAccessory.gameObject)
			-- errorLog("HeadIconCell try set HairAccessory but cannot find config,id is :"..hairID)
		end
	else
		-- errorLog("HeadIconCell try set HairAccessory but hairID is nil")
	end
end

function HeadIconCell:SetHairColor(hairID,hairColorID,refresh)
	hairColorID = hairColorID or 0
	if(hairColorID~=nil) then
		self.hairID = hairID
		self.hairColorID = hairColorID
		local hair = Table_HairStyle[hairID]
		if(self.active) then
			if(hair) then
				if hair.PaintColor_Parsed then
					local c = hair.PaintColor_Parsed[hairColorID]
					--TODO???????????????????????????
					--set back
					if(c) then
						self.hairback.color = c
						self.hairfront.color = c
					end
				else
					errorLog("HeadIconCell SetHairColor : PaintColor_Parsed = nil")
				end
			elseif(not refresh) then
				-- errorLog("HeadIconCell try set HairColor but cannot find config,id is :"..hairColorID.." "..hairID)
			end
		end
	elseif(not refresh) then
		-- errorLog("HeadIconCell try set HairColor but hairColorID is nil")
	end
end

function HeadIconCell:SetBody(bodyID)
	if(bodyID~=nil) then
		local body = Table_Body[bodyID]
		if(body) then
			local bodyStr = body.AvatarBody;
			if(bodyStr==nil or bodyStr == "")then
				bodyStr = "Body_"..body.Texture;
			end
			self:SetSpriteName(self.body,bodyStr)
			self:MakePixelPerfect(self.body)
		else
			-- errorLog("HeadIconCell try set Body but cannot find config,id is :"..bodyID)
		end
	else
		-- errorLog("HeadIconCell try set Body but bodyID is nil")
	end
end

function HeadIconCell:SetFace(sex)
	if(sex~=nil) then
		if(self.sex ~= sex) then
			self.sex = sex
			self:RefreshFace()
		end
	else
		-- errorLog("HeadIconCell try set Face but sex is nil")
	end
end

function HeadIconCell:SetHeadAccessory(headAccessory)
	if headAccessory and headAccessory ~= 0 then
		local assesories = Table_Assesories[headAccessory]
		if assesories then
			self:Show(self.headAccessoryback.gameObject)
			self:Show(self.headAccessoryfront.gameObject)

			if assesories.Back then
				local isSet = IconManager:SetHeadAccessoryBackIcon(assesories.Back, self.headAccessoryback)
				self.headAccessoryback.gameObject:SetActive(isSet)
				self:MakePixelPerfect(self.headAccessoryback)
			end
			if assesories.Front then
				local isSet = IconManager:SetHeadAccessoryFrontIcon(assesories.Front, self.headAccessoryfront)
				self.headAccessoryfront.gameObject:SetActive(isSet)
				self:MakePixelPerfect(self.headAccessoryfront)
			end

			return
		end
	end

	self:Hide(self.headAccessoryback.gameObject)
	self:Hide(self.headAccessoryfront.gameObject)
end

function HeadIconCell:SetFaceAccessory(faceAccessory)
	if faceAccessory and faceAccessory ~= 0 then
		local assesories = Table_Assesories[faceAccessory]
		if assesories then
			self:Show(self.faceAccessory.gameObject)

			if assesories.Front then
				local isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.faceAccessory)
				self.faceAccessory.gameObject:SetActive(isSet)
				self:MakePixelPerfect(self.faceAccessory)
			end

			return
		end
	end

	self:Hide(self.faceAccessory.gameObject)
end

function HeadIconCell:SetMouthAccessory(mouthAccessory)
	if mouthAccessory and mouthAccessory ~= 0 then
		local assesories = Table_Assesories[mouthAccessory]
		if assesories then
			self:Show(self.mouthAccessory.gameObject)

			if assesories.Front then
				local isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.mouthAccessory)
				self.mouthAccessory.gameObject:SetActive(isSet)
				self:MakePixelPerfect(self.mouthAccessory)
			end

			return
		end
	end

	self:Hide(self.mouthAccessory.gameObject)
end

function HeadIconCell:SetEye(eye)
	if eye and eye ~= 0 then
		self:Show(self.eye.gameObject)

		local data = Table_Eye[eye]
		if data and data.HeadImage then
			local isSet = IconManager:SetEyeIcon(data.HeadImage, self.eye)
			self.eye.gameObject:SetActive(isSet)
			self:MakePixelPerfect(self.eye)

			if #data.EyeColor > 0 then
				local hasColor,eyeColor = ColorUtil.TryParseFromNumber(data.EyeColor[1])
				self.eye.color = eyeColor
			end
		end
	else
		self:Hide(self.eye.gameObject)
	end
end

function HeadIconCell:SetSpriteName(sprite,name)
	if(sprite~=nil) then
		if(sprite.atlas~=nil) then
			if(sprite.atlas:GetSprite(name)~=nil) then
				sprite.spriteName = name
				self:Show(sprite.gameObject)
			else
				sprite.spriteName = nil
				self:Hide(sprite.gameObject)
			end
		end
	end
end

function HeadIconCell:SetActive(val,emojiChange)
	if(self.active~=val) then
		self.active = val
		if(val) then
			ColorUtil.WhiteUIWidget(self.headAccessoryback)
			ColorUtil.WhiteUIWidget(self.body)
			ColorUtil.WhiteUIWidget(self.baseFace)
			ColorUtil.WhiteUIWidget(self.eye)
			ColorUtil.WhiteUIWidget(self.hairAccessory)
			ColorUtil.WhiteUIWidget(self.simpleIcon)
			ColorUtil.WhiteUIWidget(self.headAccessoryfront)
			ColorUtil.WhiteUIWidget(self.faceAccessory)
			ColorUtil.WhiteUIWidget(self.mouthAccessory)

			self:SetHairColor(self.hairID,self.hairColorID,true)
		else
			ColorUtil.ShaderGrayUIWidget(self.headAccessoryback)
			ColorUtil.ShaderGrayUIWidget(self.hairback)
			ColorUtil.ShaderGrayUIWidget(self.body)
			ColorUtil.ShaderGrayUIWidget(self.baseFace)
			ColorUtil.ShaderGrayUIWidget(self.eye)
			ColorUtil.ShaderGrayUIWidget(self.hairfront)
			ColorUtil.ShaderGrayUIWidget(self.hairAccessory)
			ColorUtil.ShaderGrayUIWidget(self.headAccessoryfront)
			ColorUtil.ShaderGrayUIWidget(self.faceAccessory)
			ColorUtil.ShaderGrayUIWidget(self.mouthAccessory)
			ColorUtil.ShaderLightGrayUIWidget(self.simpleIcon)
		end
	end
	if(emojiChange) then
		if(val)then
			if(self.state == HeadIconCell.State.UnActive) then
				self:SetFaceState(HeadIconCell.State.StandFace)
			end
		else
			self:SetFaceState(HeadIconCell.State.UnActive)
		end
	end
end

function HeadIconCell:SetBlinkEnable(val)
	if(val) then
		self:ResetBlinkTime()
		TimeTickManager.Me():CreateTick(0,500,self.TryBlink,self)	
	else
		if(self.state == HeadIconCell.State.Blink) then
			self:SetFaceState(HeadIconCell.State.StandFace)
		end
		TimeTickManager.Me():ClearTick(self)
	end
end

function HeadIconCell:ResetBlinkTime()
	self.blinkInteval = 0
	self.blinkTime = math.random(HeadIconCell.BlinkTimeCheck[1],HeadIconCell.BlinkTimeCheck[2])
end

function HeadIconCell:TryBlink(delta)
	if(GameObjectUtil.Instance:ObjectIsNULL(self.gameObject)) then
		TimeTickManager.Me():ClearTick(self)
	end
	self.blinkInteval = self.blinkInteval + delta
	if(self.blinkInteval>=self.blinkTime) then
		self:ResetBlinkTime()
		if(self.state == HeadIconCell.State.StandFace and not self.isEmojiInCD) then
			if(math.random(1,10000)<=HeadIconCell.BlinkConfig.Probability) then
				self:SetFaceState(HeadIconCell.State.Blink)
				LeanTween.delayedCall(self.gameObject,HeadIconCell.BlinkConfig.Duration,function ()
					if(self.state == HeadIconCell.State.Blink) then
						self:SetFaceState(HeadIconCell.State.StandFace)
					end
				end)
			end
		end
	end
end

function HeadIconCell:RefreshFace()
	if(GameObjectUtil.Instance:ObjectIsNULL(self.gameObject)) then
		return
	end
	local face
	if(self.state == HeadIconCell.State.Emoji)then
		local config = Table_Avatar[self.currentEmojiID]
		if config then
			face = config.NameEn
			self:Hide(self.eye.gameObject)
		end
	else
		self.currentEmojiID = nil
		if(self.state == HeadIconCell.State.StandFace) then
			face = "Head_stand"
			self:Show(self.eye.gameObject)
		elseif(self.state == HeadIconCell.State.Blink)then
			face = "Head_closeeye"
			self:Hide(self.eye.gameObject)
		elseif(self.state == HeadIconCell.State.UnActive)then
			face = "Head_closeeye"
			self:Hide(self.eye.gameObject)
		end
	end
	if(face~=nil) then
		face = face.."_"..(self.sex==RoleConfig.Gender.Male and "M" or "F")
		self:SetSpriteName(self.baseFace,face)
		self:MakePixelPerfect(self.baseFace)
	end
end

function HeadIconCell:SetFaceState(state)
	self.state = state
	self:RefreshFace()
end

function HeadIconCell:ForceToStandFace()
	self.isEmojiInCD = false
	self:SetFaceState(HeadIconCell.State.StandFace)
end

function HeadIconCell:TryPlayEmojiID(emojiID)
	if(self.enableEmojiFace) then
		local config = Table_Avatar[emojiID]
		if(config and self:IsPlayEmoji(config)) then
			local duration = config.Duration
			local cd = 1
			if(self.currentEmojiID ~= emojiID) then
				self.currentEmojiID = emojiID
				self:SetFaceState(HeadIconCell.State.Emoji)
				self.isEmojiInCD = true
				if(duration~=0) then
					LeanTween.cancel(self.gameObject)
					--????????????duration??????
					LeanTween.delayedCall(duration, function ()
						if(self.state==HeadIconCell.State.Emoji) then
							self:SetFaceState(HeadIconCell.State.StandFace)
						end
					end)
					--???????????????????????????1?????????????????????????????????CD
					LeanTween.delayedCall(duration + 1, function ()
						self.isEmojiInCD = false
					end)
				end
			end
		end
	end
end

function HeadIconCell:IsPlayEmoji(config)
	if self.state < HeadIconCell.State.Emoji and not self.isEmojiInCD then
		return true
	elseif self.state == HeadIconCell.State.Emoji then
		local curConfig = Table_Avatar[self.currentEmojiID]
		if curConfig and config.Priority and curConfig.Priority then
			if config.Priority < curConfig.Priority then
				return true
			end
		end
	end

	return false
end

function HeadIconCell:ServerSyncEmoji(sdata)
	if(sdata.charid == self.id) then
		self:TryPlayEmojiID(sdata.expressionid)
	end
end

function HeadIconCell:ServerSyncDefautEmoji(sdata)
	if(sdata.charid == self.id) then
		if(self.state ~= HeadIconCell.State.UnActive) then
			self:ForceToStandFace()
		end
	end
end

function HeadIconCell:EnableBlinkEye()
	self:SetBlinkEnable(true)
end

function HeadIconCell:HideFrame()
	self.frameSp.gameObject:SetActive(false)
end

function HeadIconCell:OnAdd()
	self.syncEmoji = true
	self:InitEmoji()
	FunctionPlayerHead.Me():AddEventListener(FunctionPlayerHead.PlayDefaultEmojiEvent,self.ServerSyncDefautEmoji,self)
	FunctionPlayerHead.Me():AddEventListener(FunctionPlayerHead.PlayEmojiEvent,self.ServerSyncEmoji,self)
	FunctionPlayerHead.Me():AddEventListener(FunctionPlayerHead.EnableBlinkEye,self.EnableBlinkEye,self)
end

function HeadIconCell:OnRemove()
	self.syncEmoji = false
	FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.PlayDefaultEmojiEvent,self.ServerSyncDefautEmoji,self)
	FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.PlayEmojiEvent,self.ServerSyncEmoji,self)
	FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.EnableBlinkEye,self.EnableBlinkEye,self)
	TimeTickManager.Me():ClearTick(self)
end


MyHeadIconCell = class("MyHeadIconCell",HeadIconCell)

function MyHeadIconCell:Refresh()
	local myself = Game.Myself
	if(myself) then
		local userData = myself.data.userdata
		if(userData) then
			local hairID = userData:Get(UDEnum.HAIR) or nil
			local bodyID = userData:Get(UDEnum.BODY) or nil
			local sex = userData:Get(UDEnum.SEX) or nil
			local haircolor = userData:Get(UDEnum.HAIRCOLOR) or nil
			local headID = userData:Get(UDEnum.HEAD) or nil
			local faceID = userData:Get(UDEnum.FACE) or nil
			local mouthID = userData:Get(UDEnum.MOUTH) or nil
			local eye = userData:Get(UDEnum.EYE) or nil

			self:SetHairColor(hairID,haircolor)

			hairID,headID,faceID,mouthID = self:ParseDisplayLogic(hairID, headID, faceID, mouthID)

			self:SetHair(hairID)
			self:SetHairAccessory(hairID)
			self:SetBody(bodyID)
			self:SetFace(sex)
			self:SetHeadAccessory(headID)
			self:SetFaceAccessory(faceID)
			self:SetMouthAccessory(mouthID)
			self:SetEye(eye)
		end
	end
end