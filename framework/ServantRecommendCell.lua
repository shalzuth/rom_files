local BaseCell = autoImport("BaseCell");
ServantRecommendCell = class("ServantRecommendCell", BaseCell);

local tmpPos = LuaVector3.zero
local OFFSET = 200

local btnStatus = 
{

	GO = {"com_btn_2s",ZhString.Servant_Recommend_Go,Color(158/255,86/255,0/255),},
	RECEIVE = {"com_btn_3s",ZhString.Servant_Recommend_Receive,Color(41/255,105/255,0/255)},
	RECEIVED = {"com_btn_3s",ZhString.Servant_Recommend_Received,Color(124/255,124/255,124/255)},
}

-- 活动、升级、赚钱、收集、社交
local typeCfgColor = {"[ffa0bf]","[6ca7ff]","[ffd44f]","[bde379]","[dbb8ef]"}

function ServantRecommendCell:Init()
	ServantRecommendCell.super.Init(self)
	self:FindObjs()
	self:AddUIEvts()
end

-- function ServantRecommendCell:PlayTrailEffect(worldpos)
-- 	self.pos = self.effectContainer.transform:InverseTransformPoint(worldpos)
-- 	self:Show(self.effectContainer)
-- 	self:PlayUIEffect(EffectMap.UI.LovelyTail,self.effectContainer,false)
-- 	self:SetTween()
-- end

function ServantRecommendCell:FindObjs()
	self.bg = self:FindGO("Bg")
	self.icon = self:FindComponent("Icon", UISprite)
	self.rewardNum = self:FindComponent("RewardNum",UILabel)
	self.rewardIcon = self:FindComponent("RewardIcon",UISprite)
	self.name = self:FindComponent("Name",UILabel)
	self.title = self:FindComponent("Title",UILabel)
	self.checkImg = self:FindGO("CheckImg")
	self.btn = self:FindComponent("Btn",UISprite)
	self.btnLab = self:FindComponent("BtnText",UILabel)
	self.finishedFlag = self:FindGO("FinishedImg")
	-- self.effectContainer = self:FindGO("EffectContainer");
	-- self.tweenPosition= self.effectContainer:GetComponent(TweenPosition)
end

-- function ServantRecommendCell:SetTween()
-- 	self.tweenPosition.duration = 2
-- 	local parentPos = self.gameObject.transform.localPosition
-- 	tmpPos:Set(OFFSET,0,0) 
-- 	self.tweenPosition.from = tmpPos
-- 	tmpPos:Set(self.pos.x+OFFSET,self.pos.y,0)
-- 	self.tweenPosition.to = tmpPos
-- 	self.tweenPosition:ResetToBeginning()
-- 	self.tweenPosition:PlayForward()
-- 	self.tweenPosition:SetOnFinished(function ()
-- 		self:Hide(self.effectContainer)
-- 	end)
-- end

function ServantRecommendCell:AddUIEvts()
	self:AddClickEvent(self.btn.gameObject,function ( obj )
		self:OnClickBtn()
	end)
end

function ServantRecommendCell:OnClickBtn()
	if(ServantRecommendProxy.STATUS.GO==self.status)then
		if(self.data and self.data:IsActive() and not self.data.real_open)then
			MsgManager.ShowMsgByID(25423)
			return
		end
		FuncShortCutFunc.Me():CallByID(self.gotoMode);
		GameFacade.Instance:sendNotification(UIEvent.CloseUI,UIViewType.NormalLayer)
	elseif(ServantRecommendProxy.STATUS.RECEIVE==self.status)then
		ServiceNUserProxy.Instance:CallReceiveServantUserCmd(false, self.id) 
	end
end

local reward_icon,reward_num
local CONST_GIFT_ID , CONST_GIFT_NUM , FAVOR_ICON = 700108, 1 , "food_icon_10"
local tempColor = LuaColor.white
function ServantRecommendCell:SetData(data)
	self.data = data;
	if(data)then
		self.bg:SetActive(true)
		-- TODO
		local cfg = data.staticData
		if(nil==cfg)then
			helplog("女仆今日推荐前后端表不一致")
			return
		end
		self.id = data.id
		self.status = data.status
		self.gotoMode = cfg.GotoMode
		self.name.text = cfg.Name
		self.title.text = data.finish_time and string.format(cfg.Title,data.finish_time) or cfg.Title
		if(cfg.Favorability)then
			self:Show(self.rewardNum)
			reward_num = cfg.Favorability
			IconManager:SetUIIcon(FAVOR_ICON,self.rewardIcon)
		else
			local rewards = ItemUtil.GetRewardItemIdsByTeamId(cfg.Reward);
			if(rewards)then
				reward_num = #rewards>1 and CONST_GIFT_NUM or rewards[1].num
				reward_icon = #rewards>1 and CONST_GIFT_ID or rewards[1].id
				reward_icon = Table_Item[reward_icon] and Table_Item[reward_icon].Icon or ""
				IconManager:SetItemIcon(reward_icon,self.rewardIcon)
				self:Show(self.rewardNum)
			else
				self:Hide(self.rewardNum)
			end
		end
		self.rewardNum.text = reward_num
		local exitIcon = IconManager:SetUIIcon(cfg.Icon,self.icon)
		if(not exitIcon)then
			exitIcon = IconManager:SetItemIcon(cfg.Icon,self.icon)
			if(not exitIcon)then
				-- helplog("ServantRecommendCell SetData SetIcon 未在v1、v2、item图集中找到对应icon. 错误ID: ",cfg.id)
			end
		end
		-- 3 -- 一次性引导任务 待配置
		ColorUtil.WhiteUIWidget(self.btn)
		self.checkImg:SetActive(false)
		if(ServantRecommendProxy.STATUS.FINISHED==data.status)then
			self:_setBtnStatue(false)
			self.checkImg:SetActive(true)
		elseif(ServantRecommendProxy.STATUS.RECEIVE==data.status)then
			self:_setBtnStatue(true,btnStatus.RECEIVE)
		elseif(ServantRecommendProxy.STATUS.GO==data.status)then
			self:_setBtnStatue(true,btnStatus.GO)
		end
	else
		self.bg:SetActive(false)
	end
end

function ServantRecommendCell:_setBtnStatue(showBtn,statusCfg)
	if(showBtn)then
		self.btn.spriteName = statusCfg[1]
		self.btnLab.text = statusCfg[2]
		self.btnLab.effectColor = statusCfg[3]
	end
	self.btn.gameObject:SetActive(showBtn)
	self.finishedFlag:SetActive(not showBtn)
end



