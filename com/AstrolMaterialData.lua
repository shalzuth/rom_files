AstrolMaterialData = class("AstrolMaterialData")

function AstrolMaterialData:ctor(serverdata)
	self.charid = serverdata.charid
	self.cost = {}
	if serverdata.materials then
		local n = #serverdata.materials
		for i=1,n do
			local single = serverdata.materials[i]
			if(self.cost[single.id] == nil)then
				self.cost[single.id] = single.count
			else
				self.cost[single.id] = self.cost[single.id] + single.count
			end
		end
	end
end

function AstrolMaterialData:CheckAstrolMaterial()
	if self.cost then
		local userdata = Game.Myself and Game.Myself.data.userdata
		local num = userdata:Get(UDEnum.CONTRIBUTE) or 0
		for k,v in pairs(self.cost) do
			if k == 140 then				
				if num < v then
					return false
				end
			end
			local n = BagProxy.Instance:GetItemNumByStaticID(k,BagProxy.BagType.MainBag)
			-- n = n + BagProxy.Instance:GetItemNumByStaticID(k,BagProxy.BagType.Storage)
			if n < v then
				return false
			end
			return true
		end
	end
	return false
end

function AstrolMaterialData:GetContribute()
	if self.cost[140] then return self.cost[140] end
end

function AstrolMaterialData:GetGoldMedal()
	if self.cost[5261] then return self.cost[5261] end
end