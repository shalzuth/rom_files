autoImport("CoreView")
BarrageView = class("BarrageView",CoreView)
BarrageView.yScale = 8
BarrageView.activeWidth = 1280

BarrageView.cellPath = ResourcePathHelper.UICell("MessageFlyer2D")

function BarrageView:ctor(go)
	BarrageView.super.ctor(self,go)
	self:Init()
end

function BarrageView:Init()
	self.cacheLabel = {}
	self.panel = self.gameObject:GetComponentInChildren(UIPanel)
end

function BarrageView:AddText(data)
	local go = Game.AssetManager_UI:CreateAsset(BarrageView.cellPath, self.panel.gameObject);
	local label = go:GetComponentInChildren(UILabel)
	label.text = data.text
	local size = math.random(GameConfig.Barrage.SizeMin, GameConfig.Barrage.SizeMax) / 10
	local localScale = label.transform.localScale
	localScale.x = size
	localScale.y = size
	label.transform.localScale = localScale
	label.color = data.color

	local fontSize = label.fontSize

	-- caculate x value
	local panelWidthPer = data.percent
	local width = BarrageView.activeWidth
	local maxX = width / 2 - string.len(label.text) * fontSize * localScale.x
	local x = (panelWidthPer - 0.5) * BarrageView.activeWidth
	if x > maxX then
		x = maxX
	end

	-- caculate y value
	local height = self:GetActiveHeight()
	local minY = -height / 2 + fontSize * localScale.y * BarrageView.yScale / 2
	local maxY = height / 2 - fontSize * localScale.y * BarrageView.yScale / 2
	local y = math.random(minY,maxY)
	go.transform.localPosition = Vector3(x , y, 0)
	self.cacheLabel[data] = go
	return go
end

function BarrageView:RemoveText(data)
	local go = self.cacheLabel[data]
	Game.GOLuaPoolManager:AddToUIPool(BarrageView.cellPath,go)
	self.cacheLabel[data] = nil
	return go
end

function BarrageView:GetActiveHeight()
	local uiRoot = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIRoot)
	if uiRoot ~= nil then
		return uiRoot.activeHeight
	end
	return 0
end