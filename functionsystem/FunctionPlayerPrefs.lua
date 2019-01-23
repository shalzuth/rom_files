FunctionPlayerPrefs = class("FunctionPlayerPrefs")

function FunctionPlayerPrefs.Me()
	if nil == FunctionPlayerPrefs.me then
		FunctionPlayerPrefs.me = FunctionPlayerPrefs.new()
	end
	return FunctionPlayerPrefs.me
end

function FunctionPlayerPrefs:ctor()
end

function FunctionPlayerPrefs:Reset()
end

function FunctionPlayerPrefs:IsInited()
	return self.user~=nil
end

function FunctionPlayerPrefs:InitUser(user)
	self.user = user
end

function FunctionPlayerPrefs:DeleteKey(key)
	key = self.user.."_"..key
	PlayerPrefs.DeleteKey(key)
end

function FunctionPlayerPrefs:SetBool(key,value)
	value = value and 1 or 0
	key = self.user.."_"..key
	PlayerPrefs.SetInt(key,value)
end

function FunctionPlayerPrefs:GetBool(key,default)
	default = default and 1 or 0
	key = self.user.."_"..key
	local res = PlayerPrefs.GetInt(key,default)
	return res == 1 and true or false
end

function FunctionPlayerPrefs:SetInt(key,value)
	key = self.user.."_"..key
	PlayerPrefs.SetInt(key,value)
end

function FunctionPlayerPrefs:GetInt(key,default)
	key = self.user.."_"..key
	local res = PlayerPrefs.GetInt(key,default)
	return res
end

function FunctionPlayerPrefs:SetFloat(key,value)
	key = self.user.."_"..key
	PlayerPrefs.SetFloat(key,value)
end

function FunctionPlayerPrefs:GetFloat(key,default)
	key = self.user.."_"..key
	local res = PlayerPrefs.GetFloat(key,default)
	return res
end

--注意，保存的字符串超过1M就会报错
function FunctionPlayerPrefs:SetString(key,value)
	key = self.user.."_"..key
	PlayerPrefs.SetString(key,value)
end

function FunctionPlayerPrefs:AppendString(key,value,split)
	local res = self:GetString(key,"")
	split = split or ""
	key = self.user.."_"..key
	if(res==nil or res=="") then
		PlayerPrefs.SetString(key,res..value)
	else
		PlayerPrefs.SetString(key,res..split..value)
	end
end

function FunctionPlayerPrefs:GetString(key,default)
	key = self.user.."_"..key
	local res = PlayerPrefs.GetString(key,default)
	return res
end

function FunctionPlayerPrefs:hasKey( key )
	-- body
	key = self.user.."_"..key
	if PlayerPrefs.HasKey(key) then
		return true
	end
end

function FunctionPlayerPrefs:Save()
	PlayerPrefs.Save()
end