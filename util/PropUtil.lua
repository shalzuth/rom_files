PropUtil = {}
PropUtil.CachedProps = {}

function PropUtil.FormatEffect(effect,factor,sperator)
	sperator = sperator or ":"
	return GameConfig.EquipEffect[effect.name]..sperator..tostring(factor * effect.value)
end

function PropUtil.FormatEffects(effects,factor,sperator,newLine)
	sperator = sperator or ":"
	newLine = newLine or "\n"
	local res = ""
	for i=1,#effects do
		res = res..PropUtil.FormatEffect(effects[i],factor,sperator)..(i~=#effects and newLine or "")
	end
	if(res=="") then res = ZhString.PropEffect_NoGrow end
	return res
end

function PropUtil.FormatEffectsByProp(effects,same,sperator,newLine)
	local effect
	local props
	local propsLast
	for i=1,#effects do
		effect = effects[i]
		if(effect.lv>0) then
			props = PropUtil.GetProp(effect)
			if(propsLast) then
				propsLast:Add(props,same)
			else
				propsLast = props
			end
		end
	end
	return propsLast:ToString(sperator,newLine)
end

function PropUtil.GetProp(effect)
	local res = PropUtil.CachedProps[effect.name]
	if(not res) then
		res = EquipProps.new()
		PropUtil.CachedProps[effect.name] = res
	end
	res:CreateByConfig(effect.effect,effect.lv)
	return res
end