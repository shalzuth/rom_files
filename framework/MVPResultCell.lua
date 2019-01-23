autoImport("MVPResultHeadCell")

local baseCell = autoImport("BaseCell")
MVPResultCell = class("MVPResultCell", baseCell)

function MVPResultCell:Init()
	self:FindObjs()
	self:InitCell()
end

function MVPResultCell:FindObjs()
	self.num = self:FindGO("Num"):GetComponent(UILabel)
	self.teamName = self:FindGO("TeamName"):GetComponent(UILabel)
	self.killUserNum = self:FindGO("KillUserNum"):GetComponent(UILabel)
end

function MVPResultCell:InitCell()
	local mvpGrid = self:FindGO("MVPGrid"):GetComponent(UIGrid)
	self.mvpCtl = UIGridListCtrl.new(mvpGrid, MVPResultHeadCell, "MVPResultHeadCell")

	local miniGrid = self:FindGO("MINIGrid"):GetComponent(UIGrid)
	self.miniCtl = UIGridListCtrl.new(miniGrid, MVPResultHeadCell, "MVPResultHeadCell")
end

function MVPResultCell:SetData(data)
	self.data = data
	self.gameObject:SetActive(data ~= nil)

	if data ~= nil then
		-- todo xde 翻译_的队伍
		data.teamname = simpleReplace(data.teamname)
		self.teamName.text = data.teamname
		self.killUserNum.text = data.killusernum

		local killMvps = data:GetKillMvps()
		if killMvps ~= nil then
			self.mvpCtl:ResetDatas(killMvps)
		end
		local killMinis = data:GetKillMinis()
		if killMinis ~= nil then
			self.miniCtl:ResetDatas(killMinis)
		end
	end
end

function MVPResultCell:SetNum(num)
	self.num.text = num
end