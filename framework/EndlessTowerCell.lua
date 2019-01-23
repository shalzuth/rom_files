local baseCell = autoImport("BaseCell")
EndlessTowerCell = class("EndlessTowerCell", baseCell)

function EndlessTowerCell:Init()
	EndlessTowerCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function EndlessTowerCell:FindObjs()
	self.curFloor = self:FindGO("curFloor"):GetComponent(UILabel)
	self.bg = self.gameObject:GetComponent(UIMultiSprite)
	self.MaxLayer=self:FindGO("MaxLayer")
end

function EndlessTowerCell:SetData(data)
	self.data = data;
	self.gameObject:SetActive(data ~= nil)

	if(data)then
	 	self.MaxLayer:SetActive(false)
	 	self.curFloor.text= string.format( ZhString.EndlessTower_layer , tostring(data) ) 
	 	if(TeamProxy.Instance:IHaveTeam())then
	 		local layers = EndlessTowerProxy.Instance.leaderLayersDic
	 		if(layers)then
	 			self.myData=layers[data]
	 		end
	 		if(data==EndlessTowerProxy.Instance.leaderOldmaxlayer)then
	 			self.MaxLayer:SetActive(true)
	 		end
	 	else
	 		local layers = EndlessTowerProxy.Instance.myLayersInfo
	 		if(layers)then
		 		self.myData=layers[data]
		 	end
		 	if(data==EndlessTowerProxy.Instance.historyMaxLayer)then
	 			self.MaxLayer:SetActive(true)
	 		end
	 	end
	 	if(EndlessTowerProxy.Instance:IsCurLayerCanChallenge(data))then
	 		self.bg.color = Color(1,1,1,1)
	 		if(self.myData)then
		 		if(not self.myData.rewarded)then
		 			-- print("not rewarded")
		 			self.bg.CurrentState = 0
		 		else
		 			-- print("rewarded")
		 			self.bg.CurrentState = 1
		 		end
	 		else
	 			print("default not rewarded")
	 			self.bg.CurrentState = 0
	 		end
	 	else
	 		self:SetTextureGrey( self.bg.gameObject )
	 		self.bg.CurrentState = 0
	 	end
	end
end