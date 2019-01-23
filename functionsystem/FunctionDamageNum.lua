FunctionDamageNum = class("FunctionDamageNum")

autoImport("StaticHurtNum");
autoImport("DynamicHurtNum");

function FunctionDamageNum.Me()
	if nil == FunctionDamageNum.me then
		FunctionDamageNum.me = FunctionDamageNum.new()
	end
	return FunctionDamageNum.me
end

function FunctionDamageNum:ctor()
	self.sNumArrayMap = {
		[ HurtNumColorType.Combo ] = {},
	};
	local dNumArrayMap = {}
	for k,v in pairs(HurtNumColorType) do
		dNumArrayMap[v] = {}
	end
	self.dNumArrayMap = dNumArrayMap
end

function FunctionDamageNum:GetStaticHurtLabelWorker()
	local colorType = HurtNumColorType.Combo;
	local comboArray = self.sNumArrayMap[colorType];
	if( #comboArray >= HurtNumLimit[colorType] )then
		local numCell = table.remove(comboArray, 1);
		if(numCell.Hide)then
			numCell:Hide();
		end
	end
	
	local hurtHum = StaticHurtNum.CreateAsTable(colorType);
	hurtHum:RegisterWeakObserver(self);

	table.insert(comboArray, hurtHum);
	return hurtHum;
end

local hurtNumArgs = {};
function FunctionDamageNum:ShowDynamicHurtNum(pos, text, type, hurtNumColorType, critType)
	
	TableUtility.ArrayClear(hurtNumArgs);
	hurtNumArgs[1] = pos;
	hurtNumArgs[2] = text;
	hurtNumArgs[3] = type;
	hurtNumArgs[4] = hurtNumColorType;
	hurtNumArgs[5] = critType or HurtNum_CritType.None;

	local hurtHum = DynamicHurtNum.CreateAsTable(hurtNumArgs);
	hurtHum:RegisterWeakObserver(self);

	if(hurtNumColorType)then
		local arrayMap = self.dNumArrayMap[hurtNumColorType];
		if(#arrayMap >= HurtNumLimit[ hurtNumColorType ])then
			local numCell = arrayMap[1];
			numCell:Destroy();
		end

		table.insert(arrayMap, hurtHum);
	end
	return hurtHum;
end

function FunctionDamageNum:ObserverDestroyed(obj)
	if(not obj)then
		return;
	end

	local colorType = obj.colorType;

	local arrayMap = colorType and self.sNumArrayMap[colorType]
	if(arrayMap)then
		for i=1,#arrayMap do
			if(arrayMap[i] == obj)then
				table.remove(arrayMap, i);
				return;
			end
		end
	end

	local arrayMap = colorType and self.dNumArrayMap[colorType]
	if(arrayMap)then
		for i=1,#arrayMap do
			if(arrayMap[i] == obj)then
				table.remove(arrayMap, i);
				return;
			end
		end
	end
end



