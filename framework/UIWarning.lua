autoImport("WarnPopup")
UIWarning = class("UIWarning",BaseView)

UIWarning.ViewType = UIViewType.WarnLayer
UIWarning.Instance = nil

UIWarning.txt = ZhString.UIWarning_ReconnectLabel
function UIWarning:Init()
	UIWarning.Instance = self
	self.warnPopupsData = {}
	self.warnPopup = nil
	self:FindObjs();
	self:HideBord();
	-- self.labelIndex = 1
end

function UIWarning:FindObjs()
	self.bords = {
		WaitingBord = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"WaitingBord"),
	}
	self.bgCollider = GameObjectUtil.Instance:DeepFindChild(self.gameObject,"bgCollider");
	local waitLabel = self:FindGO("waitLabel"):GetComponent(UILabel)
	waitLabel.text = ZhString.UIWarning_ReconnectLabel
	-- local len = StringUtil.getTextLen(text)
	-- -- printRed("FindObjs",len)
	-- self.labelObjs = {}
	-- for i=1,len-2 do
	-- 	local label = self:CopyGameObject(LabelModel,self.labelGrid.gameObject):GetComponent(UILabel)
	-- 	if(i == len -2)then
	-- 		label.text = StringUtil.getTextByIndex(text,i,len)
	-- 	else
	-- 		label.text = StringUtil.getTextByIndex(text,i,i)
	-- 	end
	-- 	self.labelObjs[i] = label
	-- end
	-- self.labelGrid:Reposition()	
end

function UIWarning:ShowBord(key)
	for k,v in pairs(self.bords) do
		v:SetActive(k == key);
	end
	-- if(key == "WaitingBord")then
	-- 	self.labelIndex = 1
	-- 	TimeTickManager.Me():CreateTick(0,200,self.setLabelPos,self)
	-- end
	self.bgCollider:SetActive(true);
end

function UIWarning:HideBord()
	for k,v in pairs(self.bords) do
		v:SetActive(false);
	end
	self.bgCollider:SetActive(false);
	-- TimeTickManager.Me():ClearTick(self)
end

function UIWarning:RestartEvt(note)
	self:HideBord()
	FunctionNetError.Me():ShowErrorById(4)
end

function UIWarning:WaitEvt(note)
	LogUtility.Info("WaitEvt")
	self:ShowBord("WaitingBord");
end

function UIWarning:ReConnEvt(note)
	LogUtility.Info("ReConnEvt")
	self:HideBord();
	-- self:CloseSelf()
end

function UIWarning:AddWarnPopUp(data)
	self.warnPopupsData[#self.warnPopupsData + 1] = data
	self:TryPopupWarning()
end

function UIWarning:TryPopupWarning()
	if(#self.warnPopupsData >0) then
		local data = table.remove(self.warnPopupsData,1)
		if(self.warnPopup == nil) then
			self.warnPopup = WarnPopup.new(data,self.gameObject)
			self.warnPopup:AddEventListener(UIEvent.CloseUI,self.HandleCloseWarnPopup,self)
		else
			self.warnPopup:ResetData(data)
		end
	elseif(self.warnPopup ~= nil) then
		self.warnPopup:RemoveEventListener(UIEvent.CloseUI,self.HandleCloseWarnPopup,self)
		self.warnPopup:Destroy()
		self.warnPopup = nil
	end
end

function UIWarning:HandleCloseWarnPopup()
	self:TryPopupWarning()
end