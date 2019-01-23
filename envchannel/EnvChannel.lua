EnvChannel = {}

EnvChannel.ServerListTableName = nil

EnvChannel.ChannelConfig = {
    Develop = {Name = "Develop",ServerList = "Table_ServerList_Oversea",ip={"kr-gateway.vvv.io"},port=8888},
    Release = {Name = "Release",ServerList = "Table_ServerList",ip={"kr-prod-gateway.ro.com"},port=8888},
    Alpha = {Name = "Alpha",ServerList = "Table_ServerList",ip={"gstar-gateway.kr.mmo.ro.com"},port=8888},
    Studio = {Name = "Studio",ServerList = "Table_ServerList",ip={"104.199.150.66"},port=8888},
	Oversea = {Name = "Oversea",ServerList = "Table_ServerList_Oversea",ip={"ww.vvv.io"},port=8888} --172.26.192.169
}

EnvChannel.BranchBitValue = {
	[EnvChannel.ChannelConfig.Develop.Name] = 1,
	[EnvChannel.ChannelConfig.Studio.Name] = 2,
	[EnvChannel.ChannelConfig.Alpha.Name] = 4,
	[EnvChannel.ChannelConfig.Release.Name] = 8,
	[EnvChannel.ChannelConfig.Oversea.Name] = 8, -- todo xde
}

EnvChannel.Channel = EnvChannel.ChannelConfig.Oversea -- todo xde

if(AppEnvConfig.Instance) then
	EnvChannel.Channel = EnvChannel.ChannelConfig[AppEnvConfig.Instance.channelEnv]
	if(EnvChannel.Channel==nil) then
		EnvChannel.Channel = EnvChannel.ChannelConfig.Oversea -- todo xde
        -- todo xde 新打包机制后Channel会用分支名，这里统一当做Develop，但是把网关改为和auth同样域名
        local auth = NetConfig.OverseasAuth
        auth = string.gsub(auth, 'https?://', '')
        auth = string.gsub(auth, ':%d+', '')
        auth = string.gsub(auth, 'prod%-', '')
        auth = string.gsub(auth, 'devel%-', '')
        auth = string.gsub(auth, 'auth', 'gateway')
        EnvChannel.Channel.ip = {auth}
	end
	EnvChannel.ServerListTableName = EnvChannel.Channel.ServerList
	if(ResourceID.CheckFileIsRecorded(EnvChannel.ServerListTableName)) then
		autoImport(EnvChannel.ServerListTableName)
		Table_ServerList = _G[EnvChannel.ServerListTableName]
	else
		autoImport("Table_ServerList")
	end
else
	autoImport("Table_ServerList")
end

function EnvChannel.GetPublicIP()
	local ipConfig = EnvChannel.Channel
	return ipConfig~=nil and ipConfig.ip or {NetConfig.PUBLIC_GAME_SERVER_IP}
end

function EnvChannel.GetPublicPort()
	local ipConfig = EnvChannel.Channel
	return ipConfig~=nil and ipConfig.port or NetConfig.PUBLIC_GAME_SERVER_PORT
end

function EnvChannel.GMButtonEnable()
	return EnvChannel.Channel.NeedGM == true;
end

function EnvChannel.SDKEnable()
	if(AppEnvConfig.Instance) then
		return AppEnvConfig.Instance.NeedSDK
	end
	return false
end

function EnvChannel.IsReleaseBranch()
	return EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Release.Name
end

function EnvChannel.IsTFBranch()
	return EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Alpha.Name
end

--urls;elements:{plat}
function EnvChannel.GetHttpOperationJson()
	local httpJson = HttpOperationJson.Instance
	if(httpJson) then
		local str = httpJson.rawString
		if(str) then
			EnvChannel.httpOptJson = StringUtil.Json2Lua(str)
		end
	end
	return EnvChannel.httpOptJson
end
