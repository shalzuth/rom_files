
autoImport ("MakeRole")

FunctionSelectCharacter = class("FunctionSelectCharacter")

FunctionSelectCharacterEvent = {
	Entered = 1,
	Selected = 2,
	Unselected = 3,
	SelectedInvalidate = 4,
}

FunctionSelectCharacter.PHASE_ENTERING = 1
FunctionSelectCharacter.PHASE_SELECTING = 2
FunctionSelectCharacter.PHASE_UNSELECTING = 3

FunctionSelectCharacter.ACTION_WAIT = "wait"
FunctionSelectCharacter.ACTION_OP = "OP"
FunctionSelectCharacter.ACTION_SELECT = "wait%d"
FunctionSelectCharacter.ACTION_CREATE = "create%d"
FunctionSelectCharacter.ACTION_UNSELECTED = "choose_wait"
FunctionSelectCharacter.ACTION_UNSELECTED_CROSS = "choose_turn2"
FunctionSelectCharacter.ACTION_SELECTED = "choose_wait2"
FunctionSelectCharacter.ACTION_SELECTED_CROSS = "choose_turn"
FunctionSelectCharacter.ACTION_SHOW = "choose_show"
FunctionSelectCharacter.ACTION_EASTER_EGGS = "choose_easter_eggs"

FunctionSelectCharacter.ACTION_CROSS_FADE_DURATION = 0

FunctionSelectCharacter.EASTER_EGGS_COUNT = 66

function FunctionSelectCharacter.Me()
	if nil == FunctionSelectCharacter.me then
		FunctionSelectCharacter.me = FunctionSelectCharacter.new()
	end
	return FunctionSelectCharacter.me
end

-- static function begin
function FunctionSelectCharacter.SetRoleVisibility(role, visibility)
	if nil == role then
		return
	end
	role:SetInvisible(not visibility)
end
function FunctionSelectCharacter.CreateStashInfo(role)
	if nil ~= role then
		local info = {
			avatar = {},
			rotation = LuaQuaternion.New()
		}
		role:GetPartsInfo(info.avatar)
		info.rotation:Set(LuaGameObject.GetLocalRotation(role.completeTransform))
		return info
	end
	return nil
end

function FunctionSelectCharacter.ApplyStashInfo(role, info)
	if nil == role or nil == info then
		return
	end
	role:Redress(info.avatar)
	role:SetRotation(info.rotation)
	role:PlayAction_Simple(FunctionSelectCharacter.ACTION_SELECTED, nil, 1)
end

function FunctionSelectCharacter.ApplyStashInfoHair(role, info)
	if nil == role or nil == info then
		return
	end
	local hairID = info.avatar[Asset_Role.PartIndex.Hair]
	role:RedressPart(Asset_Role.PartIndex.Hair, hairID)
end

function FunctionSelectCharacter.ApplyStashInfoAccessories(role, info)
	if nil == role or nil == info then
		return
	end
	local headID = info.avatar[Asset_Role.PartIndex.Head]
	role:RedressPart(Asset_Role.PartIndex.Head, headID)
end
-- static function end

function FunctionSelectCharacter:ctor()
	self.characterMap = {}
	self:Reset()
	self.selectedListener = function(obj)
		self:SetSelected(obj)
	end
	self.updateListener = function()
		self:Update()
	end
end

function FunctionSelectCharacter:Reset()
	self.running = false
	self:UnselectRole(true)
	self:ResetSelector(nil)
	self.phase = nil
	TableUtility.TableClear(self.characterMap)
end

function FunctionSelectCharacter:ResetSelector(newSelector)
	local oldSelector = self.selector
	if oldSelector == newSelector then
		return
	end

	self.selector = newSelector

	if nil ~= oldSelector then
		oldSelector.selectedListener = nil
		oldSelector.updateListener = nil
		oldSelector:Shutdown()
	end

	if nil ~= newSelector then
		newSelector.selectedListener = self.selectedListener
		newSelector.updateListener = self.updateListener
	end
end

function FunctionSelectCharacter:HandleOthers(visibility)
	for k,v in ipairs(self.characterMap) do
		if self.characterNumber ~= k then
			local info = CharacterSelectList[k]
			if CharacterGender.Male == info.gender then
				FunctionSelectCharacter.SetRoleVisibility(v.maleRole, visibility)
			else
				FunctionSelectCharacter.SetRoleVisibility(v.femaleRole, visibility)
			end
			FunctionSelectCharacter.SetRoleVisibility(v.petRole, visibility)
		end
	end
end

function FunctionSelectCharacter:GetCharacterNumber(roleComplete)
	for k,v in ipairs(self.characterMap) do
		if roleComplete == v.maleRole.complete 
			or roleComplete == v.femaleRole.complete then
			return k,v
		end
	end
	return 0
end

function FunctionSelectCharacter:SwitchGender(gender, number)
	number = number or self.characterNumber
	local characterInfo = self.characterMap[number]
	if nil ~= characterInfo then
		if CharacterGender.Male == gender then
			FunctionSelectCharacter.SetRoleVisibility(characterInfo.maleRole, true)
			FunctionSelectCharacter.SetRoleVisibility(characterInfo.femaleRole, false)
			if number == self.characterNumber then
				self.activeRole = characterInfo.maleRole
				FunctionSelectCharacter.ApplyStashInfo(characterInfo.femaleRole, self.stashedFemale)
			end
		else
			FunctionSelectCharacter.SetRoleVisibility(characterInfo.maleRole, false)
			FunctionSelectCharacter.SetRoleVisibility(characterInfo.femaleRole, true)
			if number == self.characterNumber then
				self.activeRole = characterInfo.femaleRole
				FunctionSelectCharacter.ApplyStashInfo(characterInfo.maleRole, self.stashedMale)
			end
		end
	end
end

function FunctionSelectCharacter:RestoreGender(number)
	number = number or self.characterNumber
	local info = CharacterSelectList[number]
	if nil ~= info then
		self:SwitchGender(info.gender, number)
	end
end

function FunctionSelectCharacter:RestoreHair()
	FunctionSelectCharacter.ApplyStashInfoHair(self.characterInfo.maleRole, self.stashedMale)
	FunctionSelectCharacter.ApplyStashInfoHair(self.characterInfo.femaleRole, self.stashedFemale)
	self:SelectedPlayAction(FunctionSelectCharacter.ACTION_SELECTED)
end

function FunctionSelectCharacter:RestoreAccessories()
	FunctionSelectCharacter.ApplyStashInfoAccessories(self.characterInfo.maleRole, self.stashedMale)
	FunctionSelectCharacter.ApplyStashInfoAccessories(self.characterInfo.femaleRole, self.stashedFemale)
	self:SelectedPlayAction(FunctionSelectCharacter.ACTION_SELECTED)
end

function FunctionSelectCharacter:SetHair(hairID, hairColorIndex)
	self.activeRole:RedressPart(Asset_Role.PartIndex.Hair, hairID)
	self.activeRole:SetHairColor(hairColorIndex)
	self:SelectedPlayAction(FunctionSelectCharacter.ACTION_SELECTED)
end

function FunctionSelectCharacter:SetHairColor(hairColorIndex)
	self.activeRole:SetHairColor(hairColorIndex)
end

function FunctionSelectCharacter:SetAccessories(headID)
	self.activeRole:RedressPart(Asset_Role.PartIndex.Head, headID)
	self:SelectedPlayAction(FunctionSelectCharacter.ACTION_SELECTED)
end

function FunctionSelectCharacter:Rotate(delta)
	self.activeRole:RotateDelta(delta)
end

function FunctionSelectCharacter:Show()
	-- self:SelectedPlayAction(FunctionSelectCharacter.ACTION_SHOW, true)
	-- self:SelectedPetPlayAction(FunctionSelectCharacter.ACTION_SHOW, true)
	if nil ~= self.rootAnimator then
		self.rootAnimator:Play(self.rootCreateAnimationName, -1, 0)
	end
end

function FunctionSelectCharacter:Unshow()
	-- self:SelectedPlayAction(FunctionSelectCharacter.ACTION_SELECTED, true)
	-- self:SelectedPetPlayAction(FunctionSelectCharacter.ACTION_SELECTED, true)
	if nil ~= self.rootAnimator then
		self.rootAnimator:Play(self.rootAnimationName, -1, 1)
	end
end

local tempAssetRoleMap = {}
function FunctionSelectCharacter:Launch(selector)
	if self.running then
		return
	end

	local GameObjectType = Game.GameObjectType
	local gameObjectManagers = Game.GameObjectManagers

	self.running = true
	self.characterInfo = nil
	self:ResetSelector(selector)

	local localNPCManager = gameObjectManagers[GameObjectType.LocalNPC]
	for k,v in pairs(localNPCManager.npcs) do
		tempAssetRoleMap[v:GetNPCID()] = v.assetRole
	end

	for k,v in ipairs(CharacterSelectList) do
		local characterInfo = {}
		characterInfo.maleRole = tempAssetRoleMap[v.maleID]
		-- if nil ~= characterInfo.maleRole then
		-- 	characterInfo.maleRole.data.avatar.gender = Gender.MALE
		-- end
		characterInfo.femaleRole = tempAssetRoleMap[v.femaleID]
		-- if nil ~= characterInfo.femaleRole then
		-- 	characterInfo.femaleRole.data.avatar.gender = Gender.FEMALE
		-- end
		if nil ~= v.petID then
			characterInfo.petRole = tempAssetRoleMap[v.petID]
		end
		self.characterMap[k] = characterInfo
		self:RestoreGender(k)
	end

	if nil ~= self.selector then
		self.rootAnimator = self.selector.rootAnimator
		if nil ~= self.rootAnimator then
			self.rootAnimator:Play(FunctionSelectCharacter.ACTION_OP, -1, 0)
			self.phase = FunctionSelectCharacter.PHASE_ENTERING
		end
	end

	TableUtility.TableClear(tempAssetRoleMap)
end

function FunctionSelectCharacter:Shutdown()
	if not self.running then
		return
	end

	self:Reset()
end

function FunctionSelectCharacter:SelectedPlayAction(action, reset)
	if nil == self.characterInfo then
		return 
	end
	reset = reset or false

	local params = Asset_Role.GetPlayActionParams(action)
	params[6] = reset
	-- params[...] =  FunctionSelectCharacter.ACTION_CROSS_FADE_DURATION

	local role = self.characterInfo.maleRole
	if nil ~= role then
		role:PlayAction(params)
	end
	local role = self.characterInfo.femaleRole
	if nil ~= role then
		role:PlayAction(params)
	end
end

function FunctionSelectCharacter:SelectedPetPlayAction(action, reset)
	if nil == self.characterInfo then
		return 
	end
	reset = reset or false

	local params = Asset_Role.GetPlayActionParams(action)
	params[6] = reset
	-- params[...] = 0.1 -- cross fade duration

	local role = self.characterInfo.petRole
	if nil ~= role then
		role:PlayAction(params)
	end
end

function FunctionSelectCharacter:SetSelected(obj)
	if nil ~= self.phase then
		return
	end
	if nil ~= obj then
		self:SelectRole(obj)
	else
		self:UnselectRole()
	end
end

function FunctionSelectCharacter:SelectRole(obj)
	if nil ~= self.characterInfo then
		self:UnselectRole()
		return
	end
	local roleComplete = obj:GetComponentInChildren(RoleComplete)
	if nil == roleComplete then
		return
	end

	local characterNumber, characterInfo = self:GetCharacterNumber(roleComplete)

	LogUtility.InfoFormat("SelectRole: {0}, {1}", characterNumber, characterInfo)
	if nil ~= characterInfo then
		local info = CharacterSelectList[characterNumber]
		if info.invalidate then
			characterInfo.easterEggs = (characterInfo.easterEggs or 0) + 1
			if FunctionSelectCharacter.EASTER_EGGS_COUNT == characterInfo.easterEggs then
				-- easter eggs
				local gender = info.gender
				if CharacterGender.Male == gender then
					characterInfo.maleRole:PlayAction(FunctionSelectCharacter.ACTION_EASTER_EGGS, 1, true)
				else
					characterInfo.femaleRole:PlayAction(FunctionSelectCharacter.ACTION_EASTER_EGGS, 1, true)
				end
			else
				-- notify
				local data = {
					number = characterNumber,
					info = characterInfo
				}
				self:Notify(FunctionSelectCharacterEvent.SelectedInvalidate, data)
			end
			return
		end

		self.characterNumber = characterNumber
		self.characterInfo = characterInfo

		local gender = info.gender
		if CharacterGender.Male == gender then
			self.activeRole = self.characterInfo.maleRole
		else
			self.activeRole = self.characterInfo.femaleRole
		end

		self.rootAnimationName = string.format(FunctionSelectCharacter.ACTION_SELECT, self.characterNumber)
		self.rootCreateAnimationName = string.format(FunctionSelectCharacter.ACTION_CREATE, self.characterNumber)
		-- 1. play role action and hide other roles
		self:SelectedPlayAction(FunctionSelectCharacter.ACTION_SELECTED_CROSS)
		self:SelectedPetPlayAction(FunctionSelectCharacter.ACTION_SELECTED)
		self:HandleOthers(false)
		-- 2. play camera action
		if nil ~= self.selector then
			self.selector:Shutdown()

			self.rootAnimator = self.selector.rootAnimator
			if nil ~= self.rootAnimator then
				self.rootAnimator:SetFloat("speed", 1)
				self.rootAnimator:Play(self.rootAnimationName, -1, 0)
				self.phase = FunctionSelectCharacter.PHASE_SELECTING
			end
		end
	end
end

function FunctionSelectCharacter:DoUnselectRole()
	if self.running and nil ~= self.selector then
		self.selector:Launch()
	end
	self:SelectedPlayAction(FunctionSelectCharacter.ACTION_UNSELECTED_CROSS)
	self:SelectedPetPlayAction(FunctionSelectCharacter.ACTION_UNSELECTED)
	self:HandleOthers(true)
	self.characterNumber = 0
	self.characterInfo = nil
	-- notify
	self:Notify(FunctionSelectCharacterEvent.Unselected)
end

function FunctionSelectCharacter:UnselectRole(immediately)
	if nil == self.characterInfo then
		return
	end
	self:ApplySelected()

	local normalizedTime = 1
	local phase = FunctionSelectCharacter.PHASE_UNSELECTING
	if immediately then
		normalizedTime = 0
		phase = nil
		self:DoUnselectRole()
	end
	-- 1. play camera action reverse
	if nil ~= self.rootAnimator then
		self.rootAnimator:SetFloat("speed", -1)
		self.rootAnimator:Play(self.rootAnimationName, -1, normalizedTime)
		self.phase = phase
	end
end

function FunctionSelectCharacter:Update()
	if nil == self.phase or nil == self.rootAnimator then
		return
	end
	local currentState = self.rootAnimator:GetCurrentAnimatorStateInfo(0)
	if FunctionSelectCharacter.PHASE_ENTERING == self.phase then
		if not currentState:IsName(FunctionSelectCharacter.ACTION_OP) or 1 <= currentState.normalizedTime then
			self.rootAnimator:Play(FunctionSelectCharacter.ACTION_WAIT, -1, 0)
			self.phase = nil
			if nil ~= self.selector then
				self.selector:Launch()
			end
			-- notify
			self:Notify(FunctionSelectCharacterEvent.Entered)
		end
	elseif FunctionSelectCharacter.PHASE_SELECTING == self.phase then
		if not currentState:IsName(self.rootAnimationName) or 1 <= currentState.normalizedTime then
			self.phase = nil
			self:StashSelected()
			-- notify
			local data = {
				number = self.characterNumber,
				info = self.characterInfo
			}
			self:Notify(FunctionSelectCharacterEvent.Selected, data)
		end
	elseif FunctionSelectCharacter.PHASE_UNSELECTING == self.phase then
		if not currentState:IsName(self.rootAnimationName) or 0 >= currentState.normalizedTime then
			self.phase = nil
			self:DoUnselectRole()
		end
	end
end

function FunctionSelectCharacter:StashSelected()
	self.stashedMale = FunctionSelectCharacter.CreateStashInfo(self.characterInfo.maleRole)
	self.stashedFemale = FunctionSelectCharacter.CreateStashInfo(self.characterInfo.femaleRole)
end

function FunctionSelectCharacter:ApplySelected()
	self:RestoreGender()
	self:SelectedPlayAction(FunctionSelectCharacter.ACTION_SELECTED)
	self:SelectedPetPlayAction(FunctionSelectCharacter.ACTION_SELECTED)
	FunctionSelectCharacter.ApplyStashInfo(self.characterInfo.maleRole, self.stashedMale)
	FunctionSelectCharacter.ApplyStashInfo(self.characterInfo.femaleRole, self.stashedFemale)
end

function FunctionSelectCharacter:Notify(event, data)
	if nil == GameFacade then
		return
	end
	GameFacade.Instance:sendNotification(event, data)
end
