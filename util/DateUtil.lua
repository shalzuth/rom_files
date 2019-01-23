DateUtil = {}

function DateUtil.ParseHHMMSSBySeconds(seconds)
	local hh=""
	local mm=""
	local ss=""
	local hours = math.floor(seconds/3600)
	if(hours>0) then
		seconds = seconds - hours*3600
		hh = string.format("%02d:",hours)
	end
	local minutes = math.floor(seconds/60)
	if(minutes>0) then
		seconds = seconds - minutes*60
		mm = string.format("%02d:",minutes)
	end
	ss = string.format("%02d",seconds)
	return hh..mm..ss
end