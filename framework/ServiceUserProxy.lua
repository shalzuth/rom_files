-- user 
autoImport("DiskFileHandler")
autoImport("BeautifulAreaPhotoHandler")
autoImport("BeautifulAreaPhotoNetIngManager")
local ServiceUserProxy = class("ServiceUserProxy", ServiceProxy)

ServiceUserProxy.Instance = nil;

ServiceUserProxy.NAME = "ServiceUserProxy"

ServiceUserProxy.RecvLogin = "ServiceUserProxy.RecvLogin"

function ServiceUserProxy:ctor(proxyName)	
	if ServiceUserProxy.Instance == nil then
		self.proxyName = proxyName or ServiceUserProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()	
		self:InitMediator({
			[ServiceEvent.PlayerSAttrSyncData] = self.SelectSuccess,
		})

		ServiceUserProxy.Instance = self
	end
end

function ServiceUserProxy:Init()		
	self.roleInfo = nil
	self.roleInfos = nil
	self.newRoleInfo = nil

	self.isSelecting = false
	self.isReSelecting = false
	self.isReConnect = false
end

function ServiceUserProxy:IsReConnect(value)
	self.isReConnect = value
end

------------------------------- Role -------------------------------
function ServiceUserProxy:RecvRoleInfo(data)
	-- 断线重连
	if(data.data and #data.data > 0)then
		local tempArray = {}
		
		for i=1,#data.data do
			local single = data.data[i]
			local roleData = {}
			roleData.id = single.id
			roleData.baselv = single.baselv
			roleData.hair = single.hair
			roleData.haircolor = single.haircolor
			roleData.lefthand = single.lefthand
			roleData.righthand = single.righthand
			roleData.body = single.body
			roleData.head = single.head
			roleData.back = single.back
			roleData.face = single.face
			roleData.tail = single.tail
			roleData.mount = single.mount
			roleData.eye = single.eye or 0
			roleData.partnerid = single.partnerid
			roleData.portrait = single.portrait
			roleData.mouth = single.mouth
			roleData.eyecolor = single.eyecolor
			roleData.gender = single.gender
			roleData.profession = single.profession
			roleData.name = single.name
			roleData.sequence = single.sequence
			roleData.isopen = single.isopen
			roleData.deletetime = single.deletetime
			roleData.clothcolor = single.clothcolor==0 and 1 or single.clothcolor
			table.insert(tempArray,roleData)

			local oldRole = self:GetRoleInfoById(single.id)
			--TODO
			if(self.roleInfos and not oldRole)then
				self.newRoleInfo = roleData
			end 
		end

		self.roleInfos = tempArray
		self:checkReConnect()
	else
		self.roleInfos = {}
	end

	self:Notify(ServiceEvent.UserRecvRoleInfo)
end

function ServiceUserProxy:GetRoleInfoById( id )
 	-- body
 	if(self.roleInfos and #self.roleInfos>0)then
 		for i=1,#self.roleInfos do
 			local roleInfo = self.roleInfos[i]
 			if(roleInfo.id == id)then
 				return roleInfo
 			end
 		end
 	end
end

function ServiceUserProxy:GetRoleInfo()
	return self.roleInfo
end

function ServiceUserProxy:GetNewRoleInfo()
	return self.newRoleInfo
end

function ServiceUserProxy:GetAllRoleInfos()
	return self.roleInfos
end

function ServiceUserProxy:ClearRoleInfos()
	self.roleInfos = nil
	self.newRoleInfo = nil
	self.roleInfo = nil
end

------------------------------- Select -------------------------------
function ServiceUserProxy:CallSelect(id)
	
	if(not id and not self.roleInfo)then
		LogUtility.Info("<color=red>CallSelect id is nil!!!!</color>")
		return
	end
	if(not self.id and self.roleInfo)then
		id = self.roleInfo.id
	end

	if(self.roleInfo and self.roleInfo.id ~= id)then
		self.roleInfo = nil
	end
	if(not self.roleInfo)then
		if(self.roleInfos and #self.roleInfos>0)then
			for i=1,#self.roleInfos do
				local roleInfo = self.roleInfos[i]
				if(roleInfo.id == id)then
					self.roleInfo = roleInfo
					break
				end
			end
		end
	end

	if(not self.roleInfo)then
		LogUtility.Info("<color=red>CallSelect can't not find roleInfo!!!!</color>")
		return 
	end

	MyselfProxy.Instance:SetMySelfCurRole(self.roleInfo)

	if(not self.deviceInfo)then
		self.deviceInfo = DeviceInfo.GetID()
	end
	if not self.isReSelecting then		
		self.isSelecting = true
	end
	LogUtility.InfoFormat("CallSelect id:{0}",id)	
	ServiceLoginUserCmdProxy.Instance:CallSelectRoleUserCmd(id,nil,nil,self.deviceInfo)

	-- <RB> build local directories
	local roleID = id or 0
	DiskFileHandler.Ins():SetRole(roleID)
	-- <RE> build local directories
end

-- 断线重连
function ServiceUserProxy:CallReSelect()	
	self.isReSelecting = true
	if(self.roleInfo)then
		self:CallSelect(self.roleInfo.id)
	else
		printRed("function ServiceUserProxy:CallReSelect(func) null id")
	end
end-- 断线重连

function ServiceUserProxy:checkReConnect()	
	if self.isReConnect then
		self:CallReSelect()
	end
end

function ServiceUserProxy:SelectSuccess(data)
	-- 断线重连
	if self.isReSelecting then		
		self.isReSelecting = false
		ServiceConnProxy.Instance:NotifyReconnect()
		return
	end
	
	if self.isSelecting then
		self.isSelecting = false
		self:Notify(ServiceEvent.LoginInit, data)
	end
end

return ServiceUserProxy