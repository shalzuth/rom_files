-- errorLog
autoImport("ChatKeywordCell")

ChatKeywordView = class("ChatKeywordView",SubView)

function ChatKeywordView:Init()
	self:ResetData()

	self.effectContainer = self:FindGO("EffectContainer")

	self.chatKeywordList = ChatKeywordList.new(self.effectContainer)
end

function ChatKeywordView:AddKeywordEffect(data)
	if data.id ~= self.currentId then
		self.chatKeywordList:ResetList()
		self:AddEffect(data)
	else
		table.insert(self.waitingData , data)
	end
end

function ChatKeywordView:AddEffect(data)
	self.currentId = data.id

	self.chatKeywordList:SetData(data,self.targetPanel,function ()
		if #self.waitingData > 0 then
			self:AddEffect(self.waitingData[1])
			table.remove(self.waitingData , 1)
		else
			self:ResetData()
		end
	end)
	self.chatKeywordList:StartEffect()
end

function ChatKeywordView:Reset()
	self.chatKeywordList:ResetList()
	self:ResetData()
end

function ChatKeywordView:ResetData()
	self.currentId = 0
	self.waitingData = {}
end

function ChatKeywordView:SetPanel(panel)
	self.targetPanel = panel
end


ChatKeywordList = class("ChatKeywordList")

function ChatKeywordList:ctor(parent)
	self:Init(parent)

	self.timeTick = TimeTickManager.Me():CreateTick(0, 100 ,self.RefreshEffect , self)

	self:ResetData()
end

function ChatKeywordList:Init(parent)
	self.cellName = "ChatKeywordCell"
	self.parent = parent
end

function ChatKeywordList:SetData(data,panel,onFinish)
	self.animation = data.Animation	
	self.maxCount = data.Particles
	self.interval = tonumber(data.TimeInterval)

	local durationInterval = string.split( data.LifeInterval , "," )
	if #durationInterval == 2 then
		self.minDuration = tonumber(durationInterval[1]) * 10
		self.maxDuration = tonumber(durationInterval[2]) * 10
	else
		errorLog("Table_KeywordAnimation LifeInterval is not XX,XX")
	end

	local sizeInterval = string.split( data.SizeInterval , "," )
	if #sizeInterval == 2 then
		self.minSize = tonumber(sizeInterval[1]) * 10
		self.maxSize = tonumber(sizeInterval[2]) * 10
	else
		errorLog("Table_KeywordAnimation SizeInterval is not XX,XX")
	end

	self.onFinish = onFinish

	self.panel = panel	

	-- if self.timeTick then
	-- 	self.timeTick:ResetData(0, self.interval * 1000 ,self.RefreshEffect , self)
	-- end
end

function ChatKeywordList:ResetData()
	self.currentNum = 0		--累积当前cell数
	self.cellCtrList = {}
	if self.timeTick then
		self.timeTick:StopTick()
	end
end

function ChatKeywordList:StartEffect()

	self:ResetData()

	if self.timeTick then
		self.timeTick:StartTick()
	end
end

function ChatKeywordList:RefreshEffect()
	if self.currentNum < self.maxCount then
		self:LoadEffect()
	else
		self:ResetData()

		if self.onFinish then
			self.onFinish()
		end
	end
end

function ChatKeywordList:LoadEffect()

	self.currentNum = self.currentNum + 1

	-- local cellpfb = Game.AssetManager_UI:CreateAsset(ResourceID.Make(PfbPath.cell..self.cellName))
	-- cellpfb.transform:SetParent(self.parent.transform,false)
	-- --解决从资源池拿回后，物体不显示bug
	-- cellpfb:SetActive(false)
	-- cellpfb:SetActive(true)
	-- cellpfb.name = self.cellName..tostring(self.currentNum)

	-- local cellCtr = ChatKeywordCell.new(cellpfb)
	local cellCtr = ChatKeywordCell.CreateAsTable(self.parent.transform)
	local data = ReusableTable.CreateTable()	
	data.duration = math.random(self.minDuration , self.maxDuration) / 10
	data.size = math.random(self.minSize , self.maxSize) / 10
	data.spriteName = self.animation
	data.panel = self.panel
	cellCtr:SetData(data)
	ReusableTable.DestroyAndClearTable(data)
	table.insert(self.cellCtrList,cellCtr)
end

function ChatKeywordList:ResetList()
	for i=1,#self.cellCtrList do
		if self.cellCtrList[i]:Alive() then
			ReusableObject.Destroy(self.cellCtrList[i])
		end
	end

	self:ResetData()
end