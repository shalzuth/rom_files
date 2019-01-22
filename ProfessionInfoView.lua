autoImport("ProfessionBaseView")
autoImport("BaseAttributeCell")
ProfessionInfoView = class("ProfessionInfoView",ProfessionBaseView)

local tempVector3 = LuaVector3.zero

ProfessionInfoView.LeftBtnClick = "ProfessionInfoView.LeftBtnClick"
ProfessionInfoView.LeftBtnClick2 = "ProfessionInfoView.LeftBtnClick2"
ProfessionInfoView.LeftBtnClick3 = "ProfessionInfoView.LeftBtnClick3"
ProfessionInfoView.LeftBtnClick4 = "ProfessionInfoView.LeftBtnClick4"

function ProfessionInfoView:Init()
	self:initView()	
	self:initData()
	self:ResetData()
	self:AddCloseButtonEvent()
end

function ProfessionInfoView:initData(  )
	self.currentPfn = nil
	local userData = Game.Myself.data.userdata
	self.sex = userData:Get(UDEnum.SEX)
	self.hair = userData:Get(UDEnum.HAIR)
	self.eye = userData:Get(UDEnum.EYE)
end

function ProfessionInfoView:initSelfObj(  )
	-- body
	self.parentObj = self:FindGO("professionInfoView")
	self.gameObject = self:LoadPreferb("view/ProfessionInfoView",self.parentObj)

end

function ProfessionInfoView:initView( )
	-- body
	ProfessionInfoView.super.initView(self)
	local panel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
	for i=1,#uipanels do
		uipanels[i].depth = uipanels[i].depth + panel.depth;
	end

	local grid = self:FindGO("professionSkillGrid"):GetComponent(UIGrid)
	self.gridList = UIGridListCtrl.new(grid,ProfessionSkillCell,"ProfessionSkillCell")
	self.gridList:AddEventListener(MouseEvent.MouseClick,self.clickHandler,self)
	self.gameObject.transform.position = Vector3(0,0,0)

	-----------?????????

	-- self.whitebgSP = self:FindGO("whitebgSP")
	-- self.Purchase = self:FindGO("Purchase")
	-- self.SaveLoad = self:FindGO("SaveLoad")
	-- self.lockContent = self:FindGO("lockContent")
	-- self.Switch = self:FindGO("Switch")
	-- self.PurchaseBtn = self:FindGO("PurchaseBtn",self.Purchase)
	-- self.SwitchBtn = self:FindGO("SwitchBtn",self.Switch)
	-- self.ScrollView = self:FindGO("ScrollView",self.lockContent)

	-- self.whitebgSP.gameObject:SetActive(false)
	-- self.Purchase.gameObject:SetActive(false)
	-- self.SaveLoad.gameObject:SetActive(false)
	-- self.Switch.gameObject:SetActive(false)

	-- self.ScrollView.gameObject.transform.localPosition = Vector3(6.5,-37,0)
	-- self:AddListenEvt(MyselfEvent.MyDataChange,self.UpdateTitleInfo)
	-- self.Condition = self:FindGO("Condition")

	-- self.whitebgSP = self:FindGO("whitebgSP")
	-- self.whitebgSP.gameObject:SetActive(true)
	-- self.whitebgSP_SwitchBtn = self:FindGO("whitebgSP",self.whitebgSP)
	-- self.whitebgSP_Btn1 = self:FindGO("EquipBtn",self.whitebgSP)
	-- self.whitebgSP_Btn2 = self:FindGO("AstroBtn",self.whitebgSP)
	-- self.whitebgSP_Btn3 = self:FindGO("SkillBtn",self.whitebgSP)
	-- --self.whitebgSP_Btn4 = self:FindGO("Btn4",self.whitebgSP)
	-- self.DownLabelsGrid = self:FindGO("DownLabelsGrid",self.whitebgSP)
	-- self.Btn5 = self:FindGO("Btn5",self.whitebgSP)
	-- self.SkillColumns = self:FindGO("SkillColumns",self.whitebgSP)

	-- self.DownLabelsGrid.gameObject:SetActive(false)
	-- self.SkillColumns.gameObject:SetActive(false)

	-- self:AddClickEvent(self.whitebgSP_Btn1.gameObject,function ()
	-- 	self:PassEvent(ProfessionInfoView.LeftBtnClick,nil)
	-- end)

	-- self:AddClickEvent(self.whitebgSP_Btn2.gameObject,function ()
	-- 	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AstrolabeView, viewdata = nil})
	-- end)

	-- self:AddClickEvent(self.whitebgSP_Btn3.gameObject,function ()
	-- 	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.CharactorProfessSkill, viewdata = nil})
	-- end)

	-- self.DownLabelsGrid_UIGrid = self.DownLabelsGrid:GetComponent(UIGrid)
	-- self.baseGridList = UIGridListCtrl.new(self.DownLabelsGrid_UIGrid,BaseAttributeCell,"BaseAttrCell")
	-- self.whitebgSP = self:FindGO("whitebgSP")
	-- self.DownLabelsGrid = self:FindGO("DownLabelsGrid",self.whitebgSP)
	-- self.DownLabelsGrid = self:FindGO("DownLabelsGrid",self.whitebgSP)

end

function ProfessionInfoView:clickHandler( target )
	local skillId = target.data
	-- printRed(skillId)
	local skillItem = SkillItemData.new(skillId)
	local tipData = {}
	tipData.data = skillItem
	TipsView.Me():ShowTip(SkillTip,tipData,"SkillTip")
	local tip = TipsView.Me().currentTip
	if(tip)then
		tempVector3:Set(0,50,0) --todo xde
		tip.gameObject.transform.localPosition = tempVector3
	end
end

function ProfessionInfoView:showInfo( data )
	-- body
	self.currentPfn = data
	if(data == nil)then
		self:Hide(self.parentObj)
		return
	end
	--helplog("showInfo")
	self:Show(self.parentObj)
	self:ResetData()
end

function ProfessionInfoView:multiProfessionInfo( obj )
	-- body
	if obj == nil then
		self:Hide(self.parentObj)
		return
	end	

	self.currentPfn = obj.data
	if(self.currentPfn == nil)then
		self:Hide(self.parentObj)
		return
	end
	self:Show(self.parentObj)
	self:ResetData()

	local state = obj:GetHeadIconState() or 0
	local branch = self.currentPfn.TypeBranch or 0

	if state == 6 and branch~= 0 then
		self.Purchase.gameObject:SetActive(true)
		self.Switch.gameObject:SetActive(false)
		self.whitebgSP.gameObject:SetActive(false)
		self:AddClickEvent(self.PurchaseBtn.gameObject,function ()
			--????????????????????????????????????
			--?????????????????????
			local S_data = ProfessionProxy.Instance:GetProfessionQueryUserTable()
			local isOriginProfession = false
			for k,v in pairs(S_data) do
				if v.isbuy == false then
					local sClassData = Table_Class[v.profession]
					local thisClassData = Table_Class[obj:GetId()]
					if sClassData.Type == thisClassData.Type then
						isOriginProfession = true
						break
					end
				end
			end

			--delete
			ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
			--TODO:
			-- if isOriginProfession then
			-- 	local needmoney = GameConfig.Profession.price_z
			-- 	if needmoney>MyselfProxy.Instance:GetROB() then
			-- 		local sysMsgID = 3634
			-- 		helplog("@1")
			-- 		MsgManager.ShowMsgByID(sysMsgID)
			-- 	else
			-- 		ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
			-- 	end

			-- else
			-- 	local needmoney = GameConfig.Profession.price_gold
			-- 	if needmoney>MyselfProxy.Instance:GetGold() then
			-- 		helplog("@2")
			-- 		local sysMsgID = 3634
			-- 		MsgManager.ShowMsgByID(sysMsgID)
			-- 	else
			-- 		ServiceNUserProxy.Instance:CallProfessionBuyUserCmd(branch, true)
			-- 	end
			-- end
		end)
	end

		if state~=nil then
			self.old = self:FindGO("old")
			self.old.gameObject:SetActive(true)
		end

	if state == 7 and branch~= 0 then
		self:showShuXin()
		self.lockContent.gameObject:SetActive(false)
		self.Purchase.gameObject:SetActive(false)
		self.Switch.gameObject:SetActive(true)

		self:AddClickEvent(self.SwitchBtn.gameObject,function ()
			ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
		end)
	end

	if state == 1 and branch~= 0 then
		self:showShuXin()
		self.lockContent.gameObject:SetActive(false)
		self.Purchase.gameObject:SetActive(false)
		self.Switch.gameObject:SetActive(true)
		self:AddClickEvent(self.SwitchBtn.gameObject,function ()
			ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
		end)
	end

	if state == 4 and branch~= 0 then


	end

	if state == 5 and branch~= 0 then

	end

	if state == 2 and branch~= 0 then
		self.Purchase.gameObject:SetActive(false)
		self.Switch.gameObject:SetActive(false)
	end

	if state == 3 and branch~= 0 then
		self.Purchase.gameObject:SetActive(false)
		self.Switch.gameObject:SetActive(true)
		self.whitebgSP.gameObject:SetActive(true)

		local sprites = UIUtil.GetAllComponentsInChildren(self.Switch, UISprite, true);
		for i=1,#sprites do
			sprites[i].color = Color(1/255,2/255,3/255)
		end

		self:AddClickEvent(self.SwitchBtn.gameObject,function ()

		end)

	end
end

function ProfessionInfoView:showShuXin( )

	local GeneraData  = ProfessionProxy.Instance:GetGeneraData()
	local FixedData  = ProfessionProxy.Instance:GetFixedData()
	--helplog("ProfessionInfoView:showShuXin( )")
	--TableUtil.Print(GeneraData)
	--TableUtil.Print(FixedData)


	self.whitebgSP.gameObject:SetActive(true)

	self.DownLabelsGrid.gameObject:SetActive(true)


	local iwantshowDatas = {}
	for i = 1 ,#GeneraData do
		local data = GeneraData[i]
		if data.prop.propVO.name == "Hp" then
			table.insert(iwantshowDatas, data )
		elseif data.prop.propVO.name == "Sp" then
			table.insert(iwantshowDatas, data )
		elseif data.prop.propVO.name == "Cri" then
			table.insert(iwantshowDatas, data )
		elseif data.prop.propVO.name == "AtkSpd" then
			table.insert(iwantshowDatas, data )
		elseif data.prop.propVO.name == "Atk" then
			table.insert(iwantshowDatas, data )
		elseif data.prop.propVO.name == "MAtk" then
			table.insert(iwantshowDatas, data )
		elseif data.prop.propVO.name == "Def" then
			table.insert(iwantshowDatas, data )
		elseif data.prop.propVO.name == "MDef" then
			table.insert(iwantshowDatas, data )
		end
	end
	self.baseGridList:ResetDatas(iwantshowDatas)
end



