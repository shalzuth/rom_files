autoImport("LineChartTipCell")

local baseCell = autoImport("BaseCell")
LineChartCell = class("LineChartCell", baseCell)

local _lineChartDotCellPath = "cell/LineChartDotCell"
local _lineChartLineCellPath = "cell/LineChartLineCell"

local _vecPos = LuaVector3.zero
local _vecPos_1 = LuaVector3.zero
local _vecForward = LuaVector3.forward

local _ArrayClear = TableUtility.ArrayClear
local _ArrayPushBack = TableUtility.ArrayPushBack
local _Distance = LuaVector3.Distance
local _Angle = LuaVector3.Angle
local _AngleAxis = Quaternion.AngleAxis

function LineChartCell:Init()
	self:FindObjs()
	self:InitShow()
end

function LineChartCell:FindObjs()
	self.gridXObj = self:FindGO("GridX")
	self.gridYObj = self:FindGO("GridY")
	self.chartRoot = self:FindGO("ChartRoot")
end

function LineChartCell:InitShow()
	self.dotList = {}
	self.lineList = {}

	local gridX = self.gridXObj:GetComponent(UIGrid)
	self.tipXCtl = UIGridListCtrl.new(gridX, LineChartTipCell, "LineChartTipCell")

	local gridY = self.gridYObj:GetComponent(UIGrid)
	self.tipYCtl = UIGridListCtrl.new(gridY, LineChartTipCell, "LineChartTipCell")
end

function LineChartCell:SetXTips(data)
	if data then
		self.tipXCtl:ResetDatas(data)
	end
end

function LineChartCell:SetYTips(data)
	if data then
		self.tipYCtl:ResetDatas(data)
	end
end

function LineChartCell:SetXRange(min, max)
	self.minPosX = min
	self.maxPosX = max
end

function LineChartCell:SetYRange(min, max)
	self.minPosY = min
	self.maxPosY = max
end

function LineChartCell:SetChart(data, maxRatio, minRatio, color)
	if self.minPosX == nil or self.maxPosX == nil or self.minPosY == nil or self.maxPosY == nil then
		return
	end

	local dataCount = #data
	if dataCount == 0 then
		return
	end

	local intervalX = 0
	if dataCount > 1 then
		intervalX = (self.maxPosX - self.minPosX) / (dataCount - 1)
	end

	local rangeY = maxRatio - minRatio
	if rangeY == 0 then
		rangeY = 1
	end
	local rangePosY = self.maxPosY - self.minPosY

	for i=1,dataCount do
		--dot
		local dotSp = self.dotList[i]
		if dotSp == nil then
			local obj = self:LoadPreferb(_lineChartDotCellPath, self.chartRoot)
			dotSp = obj:GetComponent(UISprite)
			self.dotList[i] = dotSp
		else
			dotSp.gameObject:SetActive(true)
		end

		_vecPos:Set(self.minPosX + intervalX * (i - 1), self.minPosY + (data[i].ratio - minRatio) * rangePosY / rangeY, 0)
		dotSp.transform.localPosition = _vecPos

		if color ~= nil then
			dotSp.color = color
		end

		--line
		if i > 1 then
			local index = i - 1
			local lineSp = self.lineList[index]
			if lineSp == nil then
				local obj = self:LoadPreferb(_lineChartLineCellPath, self.chartRoot)
				lineSp = obj:GetComponent(UISprite)
				self.lineList[index] = lineSp
			else
				lineSp.gameObject:SetActive(true)
			end

			lineSp.transform.localPosition = _vecPos

			_vecPos_1:Set(LuaGameObject.GetLocalPosition(self.dotList[index].transform))
			lineSp.width = _Distance(_vecPos_1, _vecPos)

			_vecPos:Set(_vecPos.x - _vecPos_1.x, _vecPos.y - _vecPos_1.y, _vecPos.z - _vecPos_1.z)
			_vecPos_1:Set(1, 0, 0)
			local angle = _Angle(_vecPos, _vecPos_1)
			angle = _vecPos.y > 0 and angle or - angle
			lineSp.transform.localRotation = _AngleAxis(angle, _vecForward)

			if color ~= nil then
				lineSp.color = color
			end
		end
	end

	for i=dataCount+1,#self.dotList do
		self.dotList[i].gameObject:SetActive(false)
	end
	for i=dataCount,#self.lineList do
		self.lineList[i].gameObject:SetActive(false)
	end
end

function LineChartCell:ShowXTips(isShow)
	self.gridXObj:SetActive(isShow)
end

function LineChartCell:ShowYTips(isShow)
	self.gridYObj:SetActive(isShow)
end

function LineChartCell:ShowChart(isShow)
	self.chartRoot:SetActive(isShow)
end

function LineChartCell:ShowSelf(isShow)
	self.gameObject:SetActive(isShow)
end