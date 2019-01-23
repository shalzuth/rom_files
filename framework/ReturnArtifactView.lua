autoImport("ReturnArtifactCell")
ReturnArtifactView = class("ReturnArtifactView",ContainerView)
ReturnArtifactView.ViewType = UIViewType.NormalLayer

function ReturnArtifactView:Init()
	self:FindObjs()
	self:ListenEvt()
	self:MapListenEvt()
	self:InitUIView()
end

function ReturnArtifactView:FindObjs()
	self.container = self:FindGO("Container")
	self.ReturnBtn = self:FindGO("ReturnBtn")
end

function ReturnArtifactView:ListenEvt()
	self:AddClickEvent(self.ReturnBtn, function ()
		self:OnReturnBtn()
	end)
end

function ReturnArtifactView:MapListenEvt()
	self:AddListenEvt(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, self.HandleNtf)
end

local queryGuid = {}
function ReturnArtifactView:OnReturnBtn()
	TableUtility.ArrayClear(queryGuid)
	local datas = ArtifactProxy.Instance:GetReturnArtifact()
	for k,v in pairs(datas) do
		queryGuid[#queryGuid+1]=k
	end
	if(#queryGuid>0)then
		ServiceGuildCmdProxy:CallArtifactOptGuildCmd(ArtifactProxy.OptionType.Return, queryGuid) 
	else
		MsgManager.ShowMsgByID(4022)
	end
end

function ReturnArtifactView:HandleNtf(note)
	self:UpdataView();
end

function ReturnArtifactView:_setCameraPos()
	local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata;
	self.npcTrans = npcData and npcData.assetRole.completeTransform;
	if(self.npcTrans)then
		local viewPort = CameraConfig.ArtifactReturn_ViewPort or Vector3(0.5,0.2,9) 
		local rotation = CameraConfig.ArtifactReturn_Rotation or Vector3(0,-80,0)
		self:CameraFocusAndRotateTo(self.npcTrans,viewPort,rotation)
	end
end

function ReturnArtifactView:InitUIView()
	if(self.wrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.container, 
			pfbNum = 5, 
			cellName = "ReturnArtifactCell", 
			control = ReturnArtifactCell, 
			dir = 1,
		}
		self.wrapHelper = WrapCellHelper.new(wrapConfig)
		self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnMultiChoose, self)
	end
	ArtifactProxy.Instance:InitReturnData()
	self:UpdataView()
end

function ReturnArtifactView:OnMultiChoose(cellctl)
	if(cellctl and cellctl.data)then
		ArtifactProxy.Instance:SetReturnArtifact(cellctl.data)
		self:_refreshChoose()
	end
end

function ReturnArtifactView:UpdataView()
	local data = ArtifactProxy.Instance:GetMySelfArtifact()
	if(data)then
		self.wrapHelper:UpdateInfo(data)
		self:_refreshChoose()
	end
	self.wrapHelper:ResetPosition()
	-- local data = {{itemID=5002,guid=11111},{itemID=5004,guid=2222}}
	-- self.wrapHelper:UpdateInfo(data)
end

function ReturnArtifactView:_refreshChoose()
	local cells=self.wrapHelper:GetCellCtls()
	if(cells)then
		for _,cell in pairs(cells) do
			cell:UpdateChoose();
		end
	end
end

function ReturnArtifactView:OnEnter()
	ReturnArtifactView.super.OnEnter(self);
	self:_setCameraPos()
end

function ReturnArtifactView:OnExit()
	ReturnArtifactView.super.OnExit(self);
	self:CameraReset()
end

