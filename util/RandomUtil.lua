RandomUtil = {}

function RandomUtil.Clamp( value, min, max )
	if min > value then
		return min
	end
	if max < value then
		return max
	end
	return value
end

function RandomUtil.Range(min, max)
	local p = math.random()
	p = min+p*(max-min)
	-- print(string.format("<color=yellow>RandomUtil.Range: </color>min=%f, max=%f, p=%f", min, max, p))
	return p
end

function RandomUtil.RoundTableSelect(arg)
	local p = math.random()

	local lastIndex = 0
	local mark = 0
	for i,v in ipairs(arg) do
		mark = mark + v
		lastIndex = i
		-- print(string.format("<color=yellow>RandomUtil.RoundTableSelect: </color>mark=%f, lastIndex=%d, p=%f", mark, lastIndex, p))
		if p <= mark then
			break
		end
	end

	return lastIndex, p
end

function RandomUtil.RoundInt(p)
	local p1 = math.floor(p)
	if p1+0.5 <= p then
		p = math.ceil(p)
	else
		p = p1
	end
	return p
end

function RandomUtil.RandomInTable(t)
	if(t and #t>0) then
		return t[math.random(1,#t)]
	end
	return nil
end

function RandomUtil.RandomInCircle()
	return RandomUtil.Range(-1, 1), RandomUtil.Range(-1, 1)
end

-- return newV, dirChanged
function RandomUtil.PingPong(v, min, max)
	local dirChanged = false
	if min > v then
		local dist = max-min

		repeat
		   v = v + dist
		until min < v
		v = max - v

		dirChanged = true
	elseif max < v then
		local dist = max-min

		repeat
		   v = v - dist
		until max > v
		v = max - v

		dirChanged = true
	end
	return v, dirChanged
end