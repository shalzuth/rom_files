autoImport("WrapCellHelper")
autoImport("PresetTextCombineCell")

HHPresetTextPage = class("HHPresetTextPage",SubView)

function HHPresetTextPage:Init()
	self.pfbNum=7
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function HHPresetTextPage:FindObjs()
	self.PopUpWindow=self.container.PopUpWindow
	self.itemContainer=self:FindGO("PresetText_Container",self.PopUpWindow)
	self.WrapContent=self.itemContainer:GetComponent(UIWrapContent)
	self.ContentScrollView=self:FindGO("PresetTextScrollView",self.PopUpWindow):GetComponent(UIScrollView)
end

function HHPresetTextPage:AddEvts()

end

function HHPresetTextPage:AddViewEvts()
	
end

function HHPresetTextPage:InitShow()
	self:UpdatePresetTextInfo()
	self.ContentScrollView:ResetPosition()
end

function HHPresetTextPage:PresetTextData()
	return ChatRoomProxy.Instance.presetTextData;
end

function HHPresetTextPage:ReUniteCellData(datas, Nums)
	local newData = {};
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/Nums)+1;
			local i2 = math.floor((i-1)%Nums)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end

function HHPresetTextPage:UpdatePresetTextInfo(datas)
	if(datas == nil)then
		datas = self:PresetTextData();
		print("UpdatePresetTextInfo : "..#datas)
	end
	local newData = self:ReUniteCellData(datas, 1);
	if(self.itemWrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.itemContainer, 
			pfbNum = self.pfbNum, 
			cellName = "PresetTextCombineCell", 
			control = PresetTextCombineCell, 
			dir = 1,
		}
		self.itemWrapHelper = WrapCellHelper.new(wrapConfig)	
		self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
		self.itemWrapHelper:AddEventListener(ChatRoomEvent.PresetText, self.HandleClickEditorBtn, self)
	end
	self.itemWrapHelper:UpdateInfo(newData)
end

function HHPresetTextPage:HandleClickItem(cellctl)
	print("HandleClickItem")
	local data = cellctl.data;
	local go = cellctl.gameObject;
	self.selectData=data
	local ci = self.container.uiInput
	ci.value=ci.value..cellctl.textInputLabel.text
	self:SavePresetText()
end

function HHPresetTextPage:HandleClickEditorBtn(cellctl)
	print("HandleClickEditorBtn")
	if(type(cellctl.data)=="table")then
		cellctl.textInput.isSelected=true;
	else
		ChatRoomProxy.Instance:AddPresetText()
		self:UpdatePresetTextInfo()
	end
end

function HHPresetTextPage:SavePresetText()
	if(ChatRoomProxy.Instance.isEditorPresetText)then
		local datas = {}
		local temp = ChatRoomProxy.Instance.presetTextData
		for i=1,#temp do
			if(type(temp[i])=="table")then
				table.insert(datas,temp[i][1])
				print(datas[i])
			end
		end
		ServiceNUserProxy.Instance:CallPresetMsgCmd(datas)
	end
end
