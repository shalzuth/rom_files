local baseCell = autoImport("BaseCell")
AdventureCollectionAchShowCell = class("AdventureCollectionAchShowCell",baseCell)

function AdventureCollectionAchShowCell:Init()
	self:initView()	
end

function AdventureCollectionAchShowCell:initView(  )
	-- body
	self.name = self:FindGO("name"):GetComponent(UILabel)
end

function AdventureCollectionAchShowCell:SetData(data)
-- 	self.level.text = data:GetLevelText()
	local tableData = Table_ItemTypeAdventureLog[data.type]
	local name = tableData.Name
	local progressStr = ""
	if(tableData.id == SceneManual_pb.EMANUALTYPE_ACHIEVE)then
		local unlock,total = AdventureAchieveProxy.Instance:getTotalAchieveProgress()
		progressStr = unlock.."/"..total
	elseif tableData.id == SceneManual_pb.EMANUALTYPE_PET then
		progressStr = data:GetUnlockNum().."/"..data.totalCount
	else
		progressStr = data:GetUnlockNum().."/"..data.allCount
	end
	self.name.text = name.."："..progressStr
end

