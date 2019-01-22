local BaseCell = autoImport("BaseCell")
SceneBottomHpSpCell = reusableClass("SceneBottomHpSpCell", BaseCell);

SceneBottomHpSpCell.resId = ResourcePathHelper.UICell("SceneBottomHpSpCell")

local tempVector3 = LuaVector3.zero

SceneBottomHpSpCell.PoolSize = 30
function SceneBottomHpSpCell:Construct(asArray, args)	
	self:DoConstruct(asArray, args)
end

function SceneBottomHpSpCell:DoConstruct(asArray, args)
	self._alive = true
	local gameObject = args[1]
	local creature = args[2]
	self.gameObject = gameObject
	tempVector3:Set(0,0,0)
	self.gameObject.transform.localPosition = tempVector3
	self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
	tempVector3:Set(1,1,1)
	self.gameObject.transform.localScale = tempVector3
	self:initData(creature)
	self:initHpView()
	self:initSpView()

	self:setHpSpVisible(true)

	local value = creature.data.props.Hp:GetValue()
	local MaxValue = creature.data.props.MaxHp:GetValue()
	self:SetHp(value,MaxValue)

	value = creature.data.props.Sp:GetValue()
	MaxValue = creature.data.props.MaxSp:GetValue()
	self:SetSp(value,MaxValue)
end

function SceneBottomHpSpCell:Deconstruct(asArray)
	if(not LuaGameObject.ObjectIsNull(self.gameObject))then
		LeanTween.cancel(self.uibloodslider.gameObject)
		if(self.spSlider)then
			LeanTween.cancel(self.spSlider.gameObject)
		end
		Game.GOLuaPoolManager:AddToSceneUIPool(SceneBottomHpSpCell.resId, self.gameObject)
	end
	self._alive = false
end

function SceneBottomHpSpCell:Finalize()
	
end

function SceneBottomHpSpCell:initData( creature )
	-- body
	self.creatureType = creature:GetCreatureType()
	self.camp = creature.data:GetCamp()
	self.detailedType = creature.data.detailedType
	self.ismyself = self.creatureType == Creature_Type.Me	
	self.isFirstSpInit = true
	self.isFirstHpInit = true
	self.isBeHi = false
end

function SceneBottomHpSpCell:initHpView(  )
	-- body
	self.uibloodcontainer = self:FindGO("BloodContainer")
	self.uibloodslider = self:FindGO("BloodSlider"):GetComponent(UIProgressBar)
	self.uiblood = self:FindGO("Blood"):GetComponent(UISprite)
	self:initCreateBg()
	self:initDecorate()
	self:initHpValueLabel()
end

function SceneBottomHpSpCell:initHpValueLabel(  )
	self.bloodDetailContainer = self:FindGO("BloodDetailContainer")
	if((Game.MapManager:IsPVEMode() and self:isMvpOrMini()) or (GvgProxy.Instance.fire and self:isPlayer()))then
		self.bloodVolume = self:FindComponent("BloodVolume",UILabel)
		self.bloodVolume.text = ""
		self:Show(self.bloodDetailContainer)
	else
		self:Hide(self.bloodDetailContainer)
		self.bloodVolume = nil
	end	
end

function SceneBottomHpSpCell:initSpView(  )
	-- body
	local spContainer = self:FindGO("SpContainer")
	if(self.ismyself)then
		spContainer:SetActive(true)
		self.spContainer = spContainer
		local spSlider = self:FindGO("SpSlider"):GetComponent(UIProgressBar)
		self.spSlider = spSlider
	else
		spContainer:SetActive(false)
	end
end

function SceneBottomHpSpCell:setHpSpVisible( visible )
	-- body
	local objNull = self:ObjIsNil(self.gameObject)
	if(objNull)then
		return
	end	
	self.gameObject:SetActive(visible)
end

function SceneBottomHpSpCell:SetHpLabel( hp )
	if(self.bloodVolume)then
		hp = hp == 0 and "" or hp
		self.bloodVolume.text = hp
	end
end

function SceneBottomHpSpCell:SetHp( hp,maxhp )
	-- body
	local objNull = self:ObjIsNil(self.uibloodcontainer)
	if(objNull)then
		return
	end
	self:tweenHpSlider(hp,maxhp)
	local isLowBlood 
	if(hp/maxhp <= 0.2 and hp ~=0)then
		isLowBlood = true
	else
		isLowBlood = false
	end
	if self.ismyself and  isLowBlood then
		if(not LowBloodBlinkView.Instance)then
			LowBloodBlinkView.ShowLowBloodBlink()
		end
	elseif(self.ismyself and not isLowBlood)then
		if(LowBloodBlinkView.Instance)then
			LowBloodBlinkView.closeBloodBlink()
		end	
	end
	self:SetHpLabel(hp)
end

function SceneBottomHpSpCell:SetSp( sp,maxSp)
	-- body
	if self.ismyself then
		local objNull = self:ObjIsNil(self.spContainer)
		if(objNull)then
			return
		end

		maxSp = maxSp == 0 and 99999999999 or maxSp
		local curSp = self.spSlider.value * maxSp
		if(self.spContainer.activeSelf and not self.isFirstSpInit)then
			LeanTween.cancel(self.spSlider.gameObject)		
			LeanTween.value(self.spSlider.gameObject, function (v) 
				self.spSlider.value = v/maxSp									
			end, curSp, sp, math.abs((sp - curSp) / maxSp) * 0.5)	
		else
			self.spSlider.value = sp/maxSp
			self.isFirstSpInit = false
		end	
	end
end


function SceneBottomHpSpCell:tweenHpSlider(hp,maxhp  )
	-- body

	local objNull = self:ObjIsNil(self.uibloodcontainer)
	if(objNull)then
		return
	end

	if self.uibloodcontainer.gameObject.activeSelf then
		local curHp = self.uibloodslider.value * maxhp
		LeanTween.cancel(self.uibloodslider.gameObject)
		if( not self.isFirstHpInit)then
			LeanTween.value(self.uibloodslider.gameObject, function (v) 
				self:setHpValueAndColor(v / maxhp,hp)										
			end, curHp, hp, math.abs((hp - curHp) / maxhp) * 0.5)			
		else
			self:setHpValueAndColor(hp / maxhp,hp)
			self.isFirstHpInit = false
		end
	else
		local value = hp == 0 and 0 or hp / maxhp
		self:setHpValueAndColor(value,hp)
	end	
end

--finalhp  ??????finalHp ???????????????????????????????????????????????????????????????
function SceneBottomHpSpCell:setHpValueAndColor( value,finalHp )
	-- body
	self.uibloodslider.value = value	
	if(value <=0 and finalHp == 0)then
		self:setHpSpVisible(false)
		return
	end
	if self.uibloodslider.value <= 0.2 and self.uibloodslider.value > 0 then
		if(self.camp == RoleDefines_Camp.ENEMY )then
			self.uiblood.spriteName = "com_bg_hp_3s"
		else
			self.uiblood.spriteName = "com_bg_hp_2s"
		end
		self.uiblood:MarkAsChanged()
	else
		if(self.camp == RoleDefines_Camp.ENEMY )then
			self.uiblood.spriteName = "com_bg_hp_4s"
		else
			self.uiblood.spriteName = "com_bg_hp_s"
		end
		self.uiblood:MarkAsChanged()
	end	
end

function SceneBottomHpSpCell:isMvpOrMini(  )
	-- body
	local detailedType = self.detailedType
	if(detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP)then
		return true
	end
	return false
end

function SceneBottomHpSpCell:isMvp(  )
	-- body
	local detailedType = self.detailedType
	if(detailedType == NpcData.NpcDetailedType.MVP)then
		return true
	end
	return false
end

function SceneBottomHpSpCell:isPlayer(  )
	-- body
	if(self.creatureType == Creature_Type.Player)then
		return true
	end
	return false
end

function SceneBottomHpSpCell:initDecorate(  )
	-- body
	local decorator = self:FindGO("Decorate")
	if(self:isMvpOrMini())then		
		local rightBossBg = self:FindGO("rightBossBg"):GetComponent(UISprite)
		local leftBossBg = self:FindGO("leftBossBg"):GetComponent(UISprite)
		if(self.detailedType == NpcData.NpcDetailedType.MINI)then			
			rightBossBg.spriteName = "ui_head2_2_3"
			leftBossBg.spriteName = "ui_head2_2_1"
		elseif(self.detailedType == NpcData.NpcDetailedType.MVP)then
			rightBossBg.spriteName = "ui_head2_1_3"			
			leftBossBg.spriteName = "ui_head2_1"
		end
		decorator:SetActive(true)
	else
		decorator:SetActive(false)
	end
end

function SceneBottomHpSpCell:setCamp( camp )
	-- body
	self.camp = camp
	self:initCreateBg()
end

function SceneBottomHpSpCell:initCreateBg(  )
	-- body
	local camp = self.camp
	if(camp == RoleDefines_Camp.ENEMY )then
		self.uiblood.spriteName = "com_bg_hp_4s"
	else
		self.uiblood.spriteName = "com_bg_hp_s"
	end
end

function SceneBottomHpSpCell:Alive()
	return self._alive
end