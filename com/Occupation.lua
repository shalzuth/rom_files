--职业
Occupation = reusableClass("Occupation")

function Occupation:DoConstruct(asArray, data)
	
	-- print(self.id,self.name)
	local level = data[1]
	local exp = data[2]
	local profession = data[3]
	self:ResetData(level,exp,profession)
end

function Occupation:ResetData(level,exp,profession)
	if(not profession)then
		return
	end
	self.exp = exp
	self.profession = profession
	self.professionData  = Table_Class[self.profession]
	--实际显示等级	
	self:SetLevel(level)
	local curP = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
	self.isCurrent = profession ==  curP and true or false
	-- print(profession.." isCurrent.."..tostring(isCurrent))
end

function Occupation:GetLevelText(  )
	return self.levelText
end

function Occupation:GetLevel()	
	return self.level
end

--获取根据升职后的职业等级
function Occupation.GetFixedJobLevel(lv,profession)
	local professionData = profession
	if(type(professionData)=="number") then
		professionData = Table_Class[profession]
	end
	local previousClasses = professionData.previousClasses;
	local preMaxPJobLv = 0
	local preMaxJobLv = 0
	if(previousClasses)then
		preMaxPJobLv = previousClasses.MaxPeak or 0
		preMaxJobLv =  previousClasses.MaxJobLevel or 0
	end
	-- helplog("xxx:GetFixedJobLevel:",preMaxPJobLv,preMaxJobLv)
	if(lv<preMaxPJobLv)then
		lv = lv - preMaxJobLv
	else
		lv = lv - preMaxPJobLv
	end
	return lv
end

function Occupation.GetMyFixedJobLevelWithMax(lv,profession)
	local hasJobBreak = MyselfProxy.Instance:HasJobBreak()
	return Occupation.GetFixedJobLevelWithMax(lv,profession,hasJobBreak)
end

function Occupation.GetFixedJobLevelWithMax(lv,profession,hasJobBreak)
	local professionData = Table_Class[profession]
	local lv = Occupation.GetFixedJobLevel(lv,professionData)

	local maxJobLv = professionData.MaxJobLevel
	if(professionData.MaxPeak)then
		maxJobLv = professionData.MaxPeak
	end

	local previousClasses = professionData.previousClasses;
	local preMaxJobLv = 0 
	if(previousClasses)then
		preMaxJobLv = previousClasses.MaxPeak or previousClasses.MaxJobLevel
	end
	lv = math.max(0,math.min(lv, maxJobLv - preMaxJobLv or 0))
	return lv
end

function Occupation:SetLevel(lv)
	if(self.level ~= lv )then	
		self.level = lv
		self.levelText = Occupation.GetFixedJobLevel(lv,self.professionData)
		-- local list = SkillProxy.Instance.sameProfessionType[self.professionData.Type]
		-- for i=1,#list do
		-- 	local single = list[i]
		-- 	if single.id == self.profession then
		-- 		self.levelText = self.levelText - (single.previousClasses and single.previousClasses.MaxJobLevel or 0)
		-- 		break
		-- 	end
		-- end
	end
end

function Occupation:GetExp()	
	return self.exp	
end

function Occupation:SetExp(exp)	
	self.exp = exp
end

-- return Prop