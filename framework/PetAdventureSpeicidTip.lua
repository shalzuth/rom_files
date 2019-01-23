autoImport("BaseTip")
autoImport("PetSpecialMonsterCell")
PetAdventureSpeicidTip = class("PetAdventureSpeicidTip", BaseTip)

local defaultWidth=100
local maxWidth = 745

function PetAdventureSpeicidTip:Init()
	self.container = self:FindGO("Container")
	self:InitUIView()

	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace);
	
	self.closecomp.callBack = function (go)
		self:CloseSelf();
	end
	self.bg = self:FindComponent("bg", UISprite);
	
	PetAdventureSpeicidTip.super.Init(self);
end

function PetAdventureSpeicidTip:InitUIView()
	if(self.wrapHelper == nil)then
		local wrapConfig = {
			wrapObj = self.container, 
			pfbNum = 10, 
			cellName = "PetSpecialMonsterCell", 
			control = PetSpecialMonsterCell, 
			dir = 2,
		}
		self.wrapHelper = WrapCellHelper.new(wrapConfig)	
		self.wrapHelper:AddEventListener(PetSpecChooseEvent.OnClickMonster, self.OnClickMonster, self)
	end
end

function PetAdventureSpeicidTip:SetData(data)
	self.callback = data.callback;
	self.callbackParam = data.callbackParam;
	local data = data.itemdata
	if(not data)then return end
	self.wrapHelper:UpdateInfo(data)
	local count = #data
	self.bg.width=math.min(defaultWidth*count,maxWidth)
	self.wrapHelper:ResetPosition()
end

function PetAdventureSpeicidTip:OnClickMonster(cell)
	if(cell and cell.monsterID)then
		self.callbackParam = cell.monsterID
	end
	self:CloseSelf()
end

function PetAdventureSpeicidTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closecomp)then
		self.closecomp:AddTarget(obj.transform);
	end
end

function PetAdventureSpeicidTip:CloseSelf()
	if(self.callback)then
		self.callback(self.callbackParam);
	end
	self.bg.width=defaultWidth
	TipsView.Me():HideCurrent();
end

function PetAdventureSpeicidTip:DestroySelf()
	if(not Slua.IsNull(self.gameObject))then
		self.bg.width=defaultWidth
		GameObject.Destroy(self.gameObject);
	end	
end




