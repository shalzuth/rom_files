FakeNPlayerData = reusableClass("FakeNPlayerData", PlayerData);

function FakeNPlayerData:NoPlayShow()
	if(self.staticData)then
		return 1 == selfData.staticData.DisablePlayshow
	end
end

function FakeNPlayerData:NoPlayIdle()
	if(self.staticData)then
		return 1 == selfData.staticData.DisableWait
	end
end

function FakeNPlayerData:GetDefaultGear()
	if(self.staticData)then
		return self.staticData.DefaultGear
	end
end

function FakeNPlayerData:NoPlayIdle()
	if(self.staticData)then
		return 1 == self.staticData.DisableWait
	end
end

function FakeNPlayerData:NoPlayShow()
	if(self.staticData)then
		return 1 == self.staticData.DisablePlayshow
	end
end

function FakeNPlayerData:NoAutoAttack()
	if(self.staticData)then
		return 1 == self.staticData.NoAutoAttack
	end
end

function FakeNPlayerData:GetGroupID()
	return self.groupid;
end

function FakeNPlayerData:DoConstruct(asArray, fakeData)
	FakeNPlayerData.super.DoConstruct(self,asArray,fakeData);

	if(fakeData.npcid)then
		self.staticData = Table_Npc[fakeData.npcid];
	elseif(fakeData.monsterid)then
		self.staticData = Table_Monster[fakeData.monsterid];
	end

	self.groupid = fakeData.groupid;

	if(fakeData.name)then
		self.name = fakeData.name;
	end
end

function FakeNPlayerData:DoDeconstruct(asArray)
	FakeNPlayerData.super.DoDeconstruct(self,asArray);
	self.staticData = nil;
end



------------------------------------------------------------
------------------------------------------------------------



FakeNPlayer = reusableClass("FakeNPlayer", NPlayer)

function FakeNPlayer:SetNpcDress()
	if(self.data.staticData)then
		local parts = NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.data.staticData);
		local userData = self.data.userdata;
		local partIndex = Asset_Role.PartIndex;
		userData:Set(UDEnum.BODY, parts[partIndex.Body] or 0);
		userData:Set(UDEnum.HAIR, parts[partIndex.Hair] or 0);
		userData:Set(UDEnum.LEFTHAND, parts[partIndex.LeftWeapon] or 0);
		userData:Set(UDEnum.RIGHTHAND, parts[partIndex.RightWeapon] or 0);
		userData:Set(UDEnum.HEAD, parts[partIndex.Head] or 0);
		userData:Set(UDEnum.BACK, parts[partIndex.Wing] or 0);
		userData:Set(UDEnum.FACE, parts[partIndex.Face] or 0);
		userData:Set(UDEnum.TAIL, parts[partIndex.Tail] or 0);
		userData:Set(UDEnum.EYE, parts[partIndex.Eye] or 0);
		userData:Set(UDEnum.MOUNT, parts[partIndex.Mount] or 0);

		local partIndexEx = Asset_Role.PartIndexEx;
		userData:Set(UDEnum.SEX, parts[partIndexEx.Gender] or 0);
		userData:Set(UDEnum.HAIRCOLOR, parts[partIndexEx.HairColorIndex] or 0);
		-- userData:Set(UDEnum.EYECOLOR, parts[partIndexEx.EyeColorIndex] or 0);

		self:ReDress();
	end
end

function FakeNPlayer:_InitData(fakeData)
	if(self.data==nil) then
		return FakeNPlayerData.CreateAsTable(fakeData)
	end
	return nil
end

function FakeNPlayer:DoConstruct(asArray, fakeData)
	FakeNPlayer.super.DoConstruct(self, asArray, fakeData);
	self:SetNpcDress();

	self.data:SetDressEnable(true);
end

function FakeNPlayer:DoDeconstruct(asArray)
	FakeNPlayer.super.DoDeconstruct(self, asArray);
end

function FakeNPlayer:RegisterRoleDress()
end
function FakeNPlayer:UnregisterRoleDress()
end