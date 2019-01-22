HeadImageData = class("HeadImageData")

HeadImageIconType = {
	Default = 0,
	Avatar = 1,
	Simple = 2,
}

function HeadImageData:ctor()
	self:Reset();
end

function HeadImageData:Reset()
	self.head = "DefaultFace";

	if(self.iconData)then
		TableUtility.TableClear(self.iconData);
	else
		self.iconData = {};
	end
	-- 1 ???????????? 2 simple??????
	self.iconData.type = HeadImageIconType.Default;
	self.iconData.id = nil;
	self.iconData.hairID = nil;
	self.iconData.haircolor = nil;
	self.iconData.bodyID = nil;
	self.iconData.gender = nil;
	self.iconData.icon = "";
	self.iconData.eyeID = nil;

	self.level = 1;
	self.profession = 1;
	self.vip = 1;
	self.name = "NO NAME";
	self.hp = 1;
	self.sp = 1;
end

function HeadImageData:TransByMyself()
	self:TransformByCreature(Game.Myself);
end

function HeadImageData:TransByLPlayer(lplayer)
	self:TransformByCreature(lplayer);
end

function HeadImageData:TransformByCreature(creature)
	if(creature == nil)then
		return;
	end

	self.camp = creature.data:GetCamp();
	self.name = creature.data.name;

	local userdata = creature.data.userdata;
	if(creature:GetCreatureType() == Creature_Type.Npc)then
		if(creature.data:IsMonster())then
			self:TransByMonsterData(creature.data.staticData);
		elseif(creature.data:IsNpc())then
			self:TransByNpcData(creature.data.staticData);
		end
		if(userdata)then
			local level = userdata:Get(UDEnum.ROLELEVEL);
			if(level)then
				self.level = level;
			end
		end
	elseif(creature:GetCreatureType() == Creature_Type.Player 
		or creature:GetCreatureType() == Creature_Type.Me)then

		if(userdata)then
			local userdata = creature.data.userdata;

			local portrait = userdata:Get(UDEnum.PORTRAIT)
			local portraitData = Table_HeadImage[portrait]
			if(creature.data:IsTransformed())then
				local monsterId = creature.data.props.TransformID:GetValue()
				local monsterIcon = monsterId and Table_Monster[monsterId].Icon;
				if(monsterIcon)then
					self.iconData.type = HeadImageIconType.Simple;
					self.iconData.icon = monsterIcon;
				end
			elseif portrait and portrait ~= 0 and portraitData and portraitData.Picture then	
				self.iconData.type = HeadImageIconType.Simple;
				self.iconData.icon = portraitData.Picture
			else
				self.iconData.type = HeadImageIconType.Avatar;
				self.iconData.id = creature.data.id;
				self.iconData.bodyID = userdata:Get(UDEnum.BODY);
				self.iconData.hairID = userdata:Get(UDEnum.HAIR);
				self.iconData.haircolor = userdata:Get(UDEnum.HAIRCOLOR);
				self.iconData.gender = userdata:Get(UDEnum.SEX);
				self.iconData.blink = creature.data:CanBlink();

				self.iconData.headID = userdata:Get(UDEnum.HEAD);
				self.iconData.faceID = userdata:Get(UDEnum.FACE);
				self.iconData.mouthID = userdata:Get(UDEnum.MOUTH);
				self.iconData.eyeID = userdata:Get(UDEnum.EYE);
			end
			if(creature:GetCreatureType() == Creature_Type.Me)then
				local myMemberData = TeamProxy.Instance:GetMyTeamMemberData();
				self.job = myMemberData and myMemberData.job;
				self.iconData.blink = FunctionPlayerHead.Me().blinkEnabled;
			end
			self.level = userdata:Get(UDEnum.ROLELEVEL);
			self.profession = userdata:Get(UDEnum.PROFESSION);
		end

	end

	local props = creature.data.props;
	if(props)then
		local hp = props.Hp:GetValue();
		local maxhp = props.MaxHp:GetValue();
		self.hp = hp/maxhp;
		local sp = props.Sp:GetValue();
		local maxSp = props.MaxSp:GetValue();
		self.sp = sp/maxSp;
	end
end

function HeadImageData:TransByNpcData(npcdata)
	if(npcdata)then
		if(npcdata.Icon == "")then
			self.iconData.type = HeadImageIconType.Avatar;
			self.iconData.bodyID = npcdata.Body;
			self.iconData.hairID = npcdata.Hair;
			self.iconData.haircolor = npcdata.HeadDefaultColor;
			self.iconData.gender = npcdata.Gender;
			self.iconData.eyeID = npcdata.Eye;
		else
			self.iconData.type = HeadImageIconType.Simple;
			self.iconData.icon = npcdata.Icon;
		end
		
		self.name = npcdata.NameZh;
		self.profession = npcdata.Race;
		self.level = npcdata.Level;

		self.hide = npcdata.NoShowIcon == 1;
	end
end

function HeadImageData:TransByMonsterData(monsterdata)
	if(monsterdata)then
		self.iconData.type = HeadImageIconType.Simple;
		self.iconData.icon = monsterdata.Icon;

		self.name = monsterdata.NameZh;
		self.profession = monsterdata.Race;
		self.level = monsterdata.Level;

		self.isMonster = true;

		self.hide = monsterdata.NoShowIcon == 1;
	end
end

function HeadImageData:TransByTeamMemberData(mdata)
	if(mdata.id == Game.Myself.data.id)then
		self:TransByMyself();
		return;
	end

	local headData = mdata.portrait and Table_HeadImage[mdata.portrait];
	if(headData)then
		self.iconData.type = HeadImageIconType.Simple;
		self.iconData.icon = headData.Picture;
	elseif(mdata.catdata)then
		local monsterID = mdata.catdata.MonsterID;
		self:TransByNpcData(monsterID and Table_Monster[monsterID]);
	else
		self.iconData.type = HeadImageIconType.Avatar;
		self.iconData.id = mdata.id;
		self.iconData.bodyID = mdata.body;
		self.iconData.hairID = mdata.hair;
		self.iconData.haircolor = mdata.haircolor;
		self.iconData.gender = mdata.gender;
		self.iconData.blink = mdata:CanBlink();
		self.iconData.eyeID = mdata.eye;

		self.iconData.headID = mdata.head
		self.iconData.faceID = mdata.face
		self.iconData.mouthID = mdata.mouth
	end

	self.name = mdata.name;
	self.profession = mdata.profession;
	self.level = mdata.baselv;

	self.offline = mdata:IsOffline();
	if(mdata.hp and mdata.hpmax)then
		self.hp = mdata.hp/mdata.hpmax;
	else
		self.hp = 1;
	end
	if(mdata.sp and mdata.spmax)then
		self.mp = mdata.sp/mdata.spmax;
	else
		self.mp = 1;
	end
	self.job = mdata.job;
end

function HeadImageData:TransByChatMessageData(cdata)
	local portrait = cdata:GetPortrait()
	local portraitData = Table_HeadImage[portrait]
	if portrait ~= 0 and portraitData and portraitData.Picture then
		self.iconData.type = HeadImageIconType.Simple
		self.iconData.icon = portraitData.Picture
	else
		self.iconData.type = HeadImageIconType.Avatar
		self.iconData.bodyID = cdata:GetBody()
		self.iconData.hairID = cdata:GetHair()
		self.iconData.haircolor = cdata:GetHaircolor()
		self.iconData.headID = cdata:GetHead()
		self.iconData.faceID = cdata:GetFace()
		self.iconData.mouthID = cdata:GetMouth()
		self.iconData.eyeID = cdata:GetEye()
		self.iconData.gender = cdata:GetGender()
		self.iconData.blink = cdata:GetBlink()
	end

	self.iconData.id = cdata:GetId()
	self.name = cdata:GetName()
	self.profession = cdata:GetProfession()
	self.level = cdata:GetLevel()
end

function HeadImageData:TransByChatZoneMemberData(cdata)
	local portraitData = Table_HeadImage[cdata.portrait]
	if cdata.portrait ~= 0 and portraitData and portraitData.Picture then
		self.iconData.type = HeadImageIconType.Simple
		self.iconData.icon = portraitData.Picture
	else
		self.iconData.type = HeadImageIconType.Avatar
		self.iconData.bodyID = cdata.bodyID
		self.iconData.hairID = cdata.hairID
		self.iconData.haircolor = cdata.haircolor
		self.iconData.gender = cdata.gender
		self.iconData.blink = cdata.blink
		self.iconData.eyeID = cdata.eyeID
	end

	self.iconData.id = cdata.id
	self.name = cdata.name
	self.profession = cdata.rolejob
	self.level = cdata.level
end

function HeadImageData:TransByFriendData(frienddata)

	local portraitData = Table_HeadImage[frienddata.portrait]
	if frienddata.portrait ~= 0 and portraitData and portraitData.Picture then
		self.iconData.type = HeadImageIconType.Simple
		self.iconData.icon = portraitData.Picture
	else
		self.iconData.type = HeadImageIconType.Avatar
		self.iconData.bodyID = frienddata.bodyID
		self.iconData.hairID = frienddata.hairID
		self.iconData.headID = frienddata.headID
		self.iconData.faceID = frienddata.faceID
		self.iconData.mouthID = frienddata.mouthID
		self.iconData.eyeID = frienddata.eyeID
		self.iconData.haircolor = frienddata.haircolor
		self.iconData.gender = frienddata.gender
		self.iconData.blink = frienddata.blink
	end

	self.iconData.id = frienddata.id
	self.name = frienddata.name;
	self.profession = frienddata.profession;
	self.level = frienddata.level;
end

function HeadImageData:TransByGuildMemberData(guildMember)
	local portraitData = guildMember.portrait and Table_HeadImage[guildMember.portrait];
	if(portraitData)then
		self.iconData.type = HeadImageIconType.Simple;
		self.iconData.icon = portraitData.Picture;
	else
		self.iconData.type = HeadImageIconType.Avatar;
		self.iconData.id = guildMember.id
		self.iconData.bodyID = guildMember.body
		self.iconData.hairID = guildMember.hair
		self.iconData.haircolor = guildMember.haircolor

		self.iconData.headID = guildMember.head
		self.iconData.faceID = guildMember.face
		self.iconData.mouthID = guildMember.mouth
		self.iconData.eyeID = guildMember.eye

		self.iconData.gender = guildMember.gender
	end

	self.name = guildMember.name;
	self.profession = guildMember.profession;
	self.level = guildMember.baselevel;
end

function HeadImageData:TransByClassData(clasData)
	self.iconData.type = HeadImageIconType.Avatar;

	local userData = Game.Myself.data.userdata;
	-- self.iconData.creatureId = frienddata.id
	if(userData)then
		local gender = userData:Get(UDEnum.SEX)
		self.iconData.gender = gender
		if(gender == ProtoCommon_pb.EGENDER_FEMALE)then
			self.iconData.bodyID = clasData.FemaleBody
		else
			self.iconData.bodyID = clasData.MaleBody
		end
		self.profession = clasData.id;
		self.iconData.hairID = userData:Get(UDEnum.HAIR);
		self.iconData.haircolor = userData:Get(UDEnum.HAIRCOLOR);
		
		local headID = userData:Get(UDEnum.HEAD) or nil
		local faceID = userData:Get(UDEnum.FACE) or nil
		local mouthID = userData:Get(UDEnum.MOUTH) or nil
		local eye = userData:Get(UDEnum.EYE) or nil
		self.iconData.headID = headID
		self.iconData.faceID = faceID
		self.iconData.mouthID = mouthID
		self.iconData.eyeID = eye
	end
end

function HeadImageData:TransByPetInfoData(petInfoData)
	if(petInfoData == nil)then
		return;
	end

	local petid = petInfoData.petid;
	if(petid)then
		self:TransByMonsterData(Table_Monster[petid]);
	end

	self.iconData.type = HeadImageIconType.Simple;
	self.iconData.icon = petInfoData:GetHeadIcon();

	self.name = petInfoData.name;
	self.level = petInfoData.lv;

	self.guid = petInfoData.guid;
end

function HeadImageData:TransByBeingInfoData(beingInfoData)
	if(beingInfoData == nil)then
		self:Reset();
		return;
	end

	self:TransByMonsterData(beingInfoData.staticData);

	self.iconData.type = HeadImageIconType.Simple;
	self.iconData.icon = beingInfoData:GetHeadIcon();

	self.name = beingInfoData.name;
	self.level = beingInfoData.lv;

end

function HeadImageData:TransByPetEggData(petEggData)
	if(not petEggData)then
		return;
	end
	local petid = petEggData.petid;
	if(petid)then
		self:TransByMonsterData(Table_Monster[petid]);
	end
	self.iconData.type = HeadImageIconType.Simple;
	self.iconData.icon = petEggData:GetHeadIcon();
	self.name = petEggData.name;
	self.level = petEggData.lv;
end

function HeadImageData:TransByWeddingCharData(weddingCharData)
	local portraitData = weddingCharData.portrait and Table_HeadImage[weddingCharData.portrait];
	if(portraitData)then
		self.iconData.type = HeadImageIconType.Simple;
		self.iconData.icon = portraitData.Picture;
	else
		self.iconData.type = HeadImageIconType.Avatar
		self.iconData.id = weddingCharData.charid
		self.iconData.bodyID = weddingCharData.bodyID
		self.iconData.hairID = weddingCharData.hairID
		self.iconData.haircolor = weddingCharData.haircolor

		self.iconData.headID = weddingCharData.headID
		self.iconData.faceID = weddingCharData.faceID
		self.iconData.mouthID = weddingCharData.mouthID
		self.iconData.eyeID = weddingCharData.eyeID

		self.iconData.gender = weddingCharData.gender
	end

	self.name = weddingCharData.name;
	self.profession = weddingCharData.profession;
	self.level = weddingCharData.level;
end

function HeadImageData:TransBySocialData(socialData)
	local portraitData = Table_HeadImage[socialData.portrait]
	if socialData.portrait ~= 0 and portraitData and portraitData.Picture then
		self.iconData.type = HeadImageIconType.Simple
		self.iconData.icon = portraitData.Picture
	else
		self.iconData.type = HeadImageIconType.Avatar
		self.iconData.bodyID = socialData.body
		self.iconData.hairID = socialData.hair
		self.iconData.haircolor = socialData.haircolor
		self.iconData.gender = socialData.gender
		self.iconData.blink = socialData.blink
		self.iconData.eyeID = socialData.eye
	end

	self.iconData.id = socialData.guid
	self.name = socialData.name
	self.profession = socialData.profession
	self.level = socialData.level	
end

function HeadImageData:TransByMatcherData(matcherdata)

	local portraitData = Table_HeadImage[matcherdata.portrait]
	if matcherdata.portrait ~= 0 and portraitData and portraitData.Picture then
		self.iconData.type = HeadImageIconType.Simple
		self.iconData.icon = portraitData.Picture
	else
		self.iconData.type = HeadImageIconType.Avatar
		self.iconData.bodyID = matcherdata.bodyID
		self.iconData.hairID = matcherdata.hairID
		self.iconData.headID = matcherdata.headID
		self.iconData.faceID = matcherdata.faceID
		self.iconData.mouthID = matcherdata.mouthID
		self.iconData.eyeID = matcherdata.eyeID
		self.iconData.haircolor = matcherdata.haircolor
		self.iconData.gender = matcherdata.gender
	end

	self.iconData.id = matcherdata.id
	self.name = matcherdata.name;
	self.profession = matcherdata.profession;
	self.level = matcherdata.level;
end