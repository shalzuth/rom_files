CommonFunHelper = class("CommonFunHelper")

function CommonFunHelper.HasBuffID(userid,buffid)
	local creature = SceneCreatureProxy.FindCreature(userid)
	if(creature) then
		return creature.data:HasBuffID(buffid)
	end
	return false
end

local _GetProperty = function ( userid, attrname )
	local creature = SceneCreatureProxy.FindCreature(userid)
	if(creature) then
		return creature.data:GetProperty(attrname)
	end
	return 0
end

function CommonFunHelper.GetUserHP(userid)
	return _GetProperty(userid, "Hp")
end

function CommonFunHelper.GetProperty(userid, attrname)
	return _GetProperty(userid, attrname)
end

function CommonFunHelper.GetBuffEffectByType(userid,typeParam)
	local creature = SceneCreatureProxy.FindCreature(userid)
	if(creature) then
		return creature.data:GetBuffEffectByType(typeParam)
	end
	return nil
end

function CommonFunHelper.GetBuffLayer(userid,buffid)
	local creature = SceneCreatureProxy.FindCreature(userid)
	if(creature) then
		return creature:GetBuffLayer(buffid)
	end
	return 0
end