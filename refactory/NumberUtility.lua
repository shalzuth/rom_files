NumberUtility = class("NumberUtility")

function NumberUtility.Repeat(a, len)
	return a - math.floor(a/len) * len
end

local repeatFunc = NumberUtility.Repeat

function NumberUtility.AlmostEqualWithDiff(a, b, diff)
	local c = a-b
	return -diff < c and diff > c
end

function NumberUtility.AlmostEqual(a, b)
	return NumberUtility.AlmostEqualWithDiff(a, b, 0.01)
end

function NumberUtility.AlmostEqualAngle(a, b)
	return NumberUtility.AlmostEqualWithDiff(repeatFunc(a-b,360), 0, 0.1)
end

function NumberUtility.Sign(a)
	return 0 < a and 1 or -1
end

function NumberUtility.Clamp01(a)
	if 0 > a then
		return 0
	end
	if 1 < a then
		return 1
	end
	return a
end

function NumberUtility.Clamp(a, min, max)
	if min > a then
		return min
	end
	if max < a then
		return max
	end
	return a
end

function NumberUtility.DeltaAngle(a, b)
	local c = repeatFunc(b-a, 360)
	if 180 < c then
		c = c - 360
	end
	return c
end

function NumberUtility.MoveTowards(a, b, max)
	local diff = b-a
	if 0 < diff then
		if diff <= max then
			return b
		end
		return a + max
	else
		if diff >= -max then
			return b
		end
		return a - max
	end
end

function NumberUtility.MoveTowardsAngle(a, b, max)
	b = a + NumberUtility.DeltaAngle(a, b)
	b = NumberUtility.MoveTowards(a, b, max)
	b = repeatFunc(b, 360)
	return b
end

function NumberUtility.Lerp(a, b, t)
	return a + (b - a) * NumberUtility.Clamp01(t)
end

function NumberUtility.LerpUnclamped(a, b, t)
	return a + (b - a) * t
end

function NumberUtility.TryLerpUnclamped(a, b, t)
	if nil ~= a and nil ~=  b then
		return NumberUtility.LerpUnclamped(a, b, t)
	else
		return b
	end
end

function NumberUtility.LerpAngle(a, b, t)
	return a + NumberUtility.DeltaAngle(a, b) * NumberUtility.Clamp01(t)
end

function NumberUtility.LerpAngleUnclamped(a, b, t)
	return a + NumberUtility.DeltaAngle(a, b) * t
end