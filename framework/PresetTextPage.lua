autoImport("WrapCellHelper")
autoImport("PresetTextCell")

PresetTextPage = class("PresetTextPage",SubView)

function PresetTextPage:Init()
	self:FindObjs()
	self:InitShow()
end

function PresetTextPage:FindObjs()
	self.PopUpWindow=self.container.PopUpWindow
	self.itemContainer=self:FindGO("PresetText_Container",self.PopUpWindow)
	self.WrapContent=self.itemContainer:GetComponent(UIWrapContent)
	self.ContentScrollView=self:FindGO("PresetTextScrollView",self.PopUpWindow):GetComponent(UIScrollView)
end

function PresetTextPage:InitShow()

	self.localData = {}

	self.localData.wrapObj = self.itemContainer
	self.localData.pfbNum = 5
	self.localData.cellName = "PresetTextCell"
	self.localData.control = PresetTextCell
	self.localData.dir = 1
	
	self.itemWrapHelper = WrapCellHelper.new(self.localData)	
	self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)

	self.ContentScrollView.gameObject:SetActive(false)

	self:UpdatePresetTextInfo()
	self.ContentScrollView:ResetPosition()
end

function PresetTextPage:PresetTextData()
	return ChatRoomProxy.Instance.presetTextData;
end

function PresetTextPage:UpdatePresetTextInfo(datas)
	if(datas == nil)then
		datas = self:PresetTextData();
	end

	self.itemWrapHelper:UpdateInfo(datas)
end

function PresetTextPage:HandleClickItem(cellctl)
	self.selectData = cellctl.data

	if self.container.contentInput.gameObject.activeInHierarchy then
		self.container:SetContentInputValue(cellctl.textInput.value)
	end
end

function PresetTextPage:SavePresetText()
	if(ChatRoomProxy.Instance.isEditorPresetText)then

		local datas = ChatRoomProxy.Instance.presetTextData
		TableUtility.TableClear(self.localData)

		for i=1,5 do
			if datas[i] then
				table.insert(self.localData , datas[i].msg)
			else
				table.insert(self.localData , "")
			end
		end
		ServiceNUserProxy.Instance:CallPresetMsgCmd(self.localData)
	end
end