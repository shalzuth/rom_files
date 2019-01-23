IconManager = {};

autoImport("UIAtlasConfig"); 
autoImport("PictureManager"); 

function IconManager:Init()
	self.atlas = {}

	PictureManager.new();
end

function IconManager:SetNpcMonsterIconByID(id,sprite)
	local data = Table_Npc[id] or Table_Monster[id]
	if(data) then
		return self:SetFaceIcon(data.Icon,sprite)
	end
end

function IconManager:SetUIIcon(sName, sprite)
	return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.uiicon)
end

function IconManager:SetItemIcon(sName,sprite)
	return self:SetIcon(sName,sprite, UIAtlasConfig.IconAtlas.Item)
end

--将从所有技能列表里查找，慎用！！！！！！！！！！
function IconManager:SetSkillIcon(sName,sprite)
	return self:SetIcon(sName,sprite, UIAtlasConfig.IconAtlas.Skill)
end

local skillAtlasName = {}
function IconManager:SetSkillIconByProfess(sName,sprite,professType,rollBackFindAll)
	local atlas = skillAtlasName[professType]
	if(atlas == nil) then
		atlas = UIAtlasConfig.IconAtlas["SkillProfess_"..professType]
		skillAtlasName[professType] = atlas
	end
	local res = self:SetIcon(sName,sprite,atlas)
	if(not res and rollBackFindAll) then
		res = self:SetSkillIcon(sName,sprite)
	end
	return res
end

function IconManager:SetKeyIcon(sName,sprite)
	return self:SetIcon(sName,sprite, UIAtlasConfig.IconAtlas.keyword)
end

function IconManager:SetActionIcon(sName,sprite)
	return self:SetIcon(sName,sprite, UIAtlasConfig.IconAtlas.Action)
end

function IconManager:SetMapIcon(sName,sprite)
	return self:SetIcon(sName,sprite, UIAtlasConfig.IconAtlas.Map)
end

function IconManager:SetProfessionIcon(sName, sprite)
	return self:SetIcon(sName,sprite, UIAtlasConfig.IconAtlas.career)
end

function IconManager:SetFaceIcon(sName, sprite)
	return self:SetIcon(sName,sprite, UIAtlasConfig.IconAtlas.face)
end

function IconManager:SetFrameIcon(sName, sprite)
	return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.frame)
end

function IconManager:SetHairStyleIcon(sName, sprite)
	return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.hairStyle)
end

function IconManager:SetGuildIcon(sName, sprite)
	return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.guild)
end

function IconManager:SetHeadAccessoryFrontIcon(sName, sprite)
	return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HeadAccessoryFront)
end

function IconManager:SetHeadAccessoryBackIcon(sName, sprite)
	return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HeadAccessoryBack)
end

function IconManager:SetHeadFaceMouthIcon(sName, sprite)
	return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HeadFaceMouth)
end

function IconManager:SetEyeIcon(sName, sprite)
	return self:SetIcon(sName, sprite, UIAtlasConfig.IconAtlas.HeadEye)
end

function IconManager:GetAtlasByType(type)
	local atlases = self.atlas[type]
	if(atlases==nil) then
		atlases = {}
		for k,v in pairs(type) do
			local rID = v
			local atlasObj = ResourceManager.Instance:SLoad(rID);
			if(atlasObj~=nil)then
				atlases[k] = atlasObj:GetComponent(UIAtlas);
			else
				print ("can not find atlas "..tostring(v));
			end
		end
		self.atlas[type] = atlases
	end
	return atlases
end

function IconManager:SetIcon(sName,sprite,atlasType)
	sName = tostring(sName);
	local atlases = self:GetAtlasByType(atlasType)
	if(atlases~=nil) then
		for k,v in pairs(atlases) do
			local getSData = v:GetSprite(sName);
			if(getSData ~= nil)then
				sprite.atlas = v;
				sprite.spriteName = sName;
				return true;
			end
		end
	end
	return false;
end

function IconManager:SetMoneyIcon(moneyType,sprite)
	if(moneyType and sprite)then
		local item=ItemData.new(0,100)
		if(moneyType==ProtoCommon_pb.EMONEYTYPE_DIAMOND)then
			--todo
		elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_SILVER)then
			item=ItemData.new(0,100)
		elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_GOLD)then
			item=ItemData.new(0,105)
		elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_GARDEN)then
			item=ItemData.new(0,110)
		elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_LABORATORY)then
			item=ItemData.new(0,115)
		elseif(moneyType==ProtoCommon_pb.EMONEYTYPE_FRIENDSHIP)then
			item=ItemData.new(0,147)
		end
		IconManager:SetItemIcon(item.staticData.Icon,sprite)
	end
end

IconManager:Init();

