MVPFightInfoBord = class("MVPFightInfoBord",SubView)

local tempVector3 = LuaVector3.zero

local calSize = NGUIMath.CalculateRelativeWidgetBounds
local getLocalPos = LuaGameObject.GetLocalPosition
local _MvpBattleActivityID = GameConfig.MvpBattle.ActivityID

function MVPFightInfoBord:Init()
	self:AddViewEvts()
	self:initView()
end

function MVPFightInfoBord:Show( tarObj )
	MVPFightInfoBord.super.Show(self,tarObj)
	if(not tarObj)then
		self:SetData()
	end
end

function MVPFightInfoBord:Hide(target)
	MVPFightInfoBord.super.Hide(self, target)
	if not target then
		self:ClearTick()
	end
end

local tempArray = {}
function MVPFightInfoBord:SetData(  )
	self:HandleUserInfoUpdate()
	self:HandleNUserVarUpdate()
	self:HandleUpdateBossesInfo()
	self:HandleUpdateLeftTime()
end

function MVPFightInfoBord:initView(  )
	-- body	
	self.gameObject = self:FindGO("MVPFightInfoBord")
	self.name = self:FindComponent("Title",UILabel)
	self.name.text = ZhString.MVPFightInfoBord_Title
	self.curPersonNum = self:FindComponent("curPersonNum",UILabel)
	self.mvpLeftNum = self:FindComponent("mvpLeftNum",UILabel)
	self.miniLeftNum = self:FindComponent("miniLeftNum",UILabel)
	self.leftTime = self:FindComponent("LeftTime",UILabel)

	self.bg = self:FindComponent("bg",UISprite)
	self.content = self:FindGO("content")
	self.bgSizeX = self.bg.width

	local cellObj = self:FindGO("TipLabelCell");
	self.tiplabelCell = TipLabelCell.new(cellObj);
	local objLua = self.gameObject:GetComponent(GameObjectForLua)
	objLua.onEnable = function (  )
		-- body
		LeanTween.delayedCall(0.8, function ()
			self:resizeContent()
		end)		
	end
end

function MVPFightInfoBord:AddViewEvts()
	self:AddListenEvt(ServiceEvent.FuBenCmdSyncMvpInfoFubenCmd, self.SetData)
	self:AddListenEvt(ServiceEvent.FuBenCmdUpdateUserNumFubenCmd, self.HandleUserInfoUpdate)
	self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.HandleNUserVarUpdate)
	self:AddListenEvt(ServiceEvent.FuBenCmdBossDieFubenCmd, self.HandleUpdateBossesInfo)
	self:AddListenEvt(ServiceEvent.ActivityCmdStartActCmd, self.HandleUpdateLeftTime)
	self:AddListenEvt(ServiceEvent.ActivityCmdStopActCmd, self.HandleUpdateLeftTime)
end

function MVPFightInfoBord:HandleUpdateBossesInfo( note )
	local contextlabel = {};
	contextlabel.label = {};
	contextlabel.tiplabel = ZhString.MVPFightInfoBord_LeftMonster
	-- contextlabel.hideline = true;
	local bosses = PvpProxy.Instance.bosses
	local txt

	if(bosses and next(bosses))then
		for k,v in pairs(bosses) do
			local npcData = Table_Monster[k]
			if(npcData and npcData.NameZh ~= "")then
				if(v.live and v.live>0)then
					txt = string.format("???%s X %s",npcData.NameZh,v.live)
				else
					txt = string.format("[c][9F9F9FFF] %s[-][/c]",npcData.NameZh)
				end
				table.insert(contextlabel.label, txt);
			end
		end
		self.tiplabelCell:SetData(contextlabel);
	else
		self.tiplabelCell:SetData();
	end
	self:resizeContent()
end

function MVPFightInfoBord:HandleNUserVarUpdate( note )
	if(Var_pb.EVARTYPE_MVPREWARDNUM)then
		local mvpLeft = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_MVPREWARDNUM) or 0
		mvpLeft = GameConfig.MvpBattle.MvpRewardTimes - mvpLeft
		mvpLeft = mvpLeft >=0 and mvpLeft or 0
		self.mvpLeftNum.text = string.format(ZhString.MVPFightInfoBord_MvpLeftTime,mvpLeft)
		local miniLeft = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_MINIREWARDNUM) or 0
		miniLeft = GameConfig.MvpBattle.MiniRewardTimes - miniLeft
		miniLeft = miniLeft >=0 and miniLeft or 0
		self.miniLeftNum.text = string.format(ZhString.MVPFightInfoBord_MiniLeftTime,miniLeft)
	end
end

function MVPFightInfoBord:HandleUserInfoUpdate( note )
	self.curPersonNum.text = string.format(ZhString.MVPFightInfoBord_LeftPerson,PvpProxy.Instance.usernum or 0)
end

function MVPFightInfoBord:HandleUpdateLeftTime(note)
	local actData = FunctionActivity.Me():GetActivityData(_MvpBattleActivityID)
	if actData ~= nil and not actData:IsEnd() then
		if self.timeTick == nil then
			self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateLeftTime, self)
		end
	else
		self:ClearTick()
	end
end

function MVPFightInfoBord:UpdateLeftTime()
	local actData = FunctionActivity.Me():GetActivityData(_MvpBattleActivityID)
	if actData ~= nil then
		local totalSec = actData:GetEndTime() - ServerTime.CurServerTime()/1000
		if totalSec > 0 then
			local day,hour,min,sec = ClientTimeUtil.FormatTimeBySec(totalSec)
			self.leftTime.text = string.format(ZhString.MVPFightInfoBord_LeftTime, hour, min, sec)
		end
	end
end

function MVPFightInfoBord:ClearTick()
	if self.timeTick ~= nil then
		TimeTickManager.Me():ClearTick(self)
		self.timeTick = nil
	end
end

function MVPFightInfoBord:resizeContent(  )
	-- body
	if(not self.container.gameObject.activeInHierarchy)then
		-- return
	end
	local bd = calSize(self.content.transform,false)
	local height = bd.size.y
	self.bg.height = height+10
end