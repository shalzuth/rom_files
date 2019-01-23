-- 邮件 对应服务器邮件系统（ServiceSessionMailProxy）
PostProxy = class('PostProxy', pm.Proxy)
PostProxy.Instance = nil;
PostProxy.NAME = "PostProxy"

autoImport("PostData");

function PostProxy:ctor(proxyName, data)
	self.proxyName = proxyName or PostProxy.NAME
	if(PostProxy.Instance == nil) then
		PostProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self.postDatas = {};
end

function PostProxy:AddUpdatePostDatas(mailDatas)
	for i=1,#mailDatas do
		local mailData = mailDatas[i];
		if(mailData and mailData.id)then
			local postData = self.postDatas[mailData.id];
			if(not postData)then
				postData = PostData.new(mailData);
				self.postDatas[mailData.id] = postData;
			else
				postData:SetData(mailData);
			end
		end
	end
end

function PostProxy:RemovePostData(deletes)
	for i=1,#deletes do
		local id = deletes[i];
		if(self.postDatas[id])then
			self.postDatas[id] = nil;
		end
	end
end

local result = {}
function PostProxy:GetPostList()
	TableUtility.ArrayClear(result)
	for k,v in pairs(self.postDatas)do
		if self:IsExpire(v.time) then
			ServiceSessionMailProxy.Instance:CallGetMailAttach(v.id)
		else
			table.insert(result, v)
		end
	end
	table.sort(result ,function(l,r)
		return l.time > r.time
	end)
	return result
end

function PostProxy:IsExpire(serverTime)
	local offlineSec = ServerTime.CurServerTime()/1000 - serverTime
	local offlineDay = math.floor(offlineSec / 86400)
	if offlineDay > GameConfig.System.sysmail_overtime then
		return true
	end
	
	return false
end