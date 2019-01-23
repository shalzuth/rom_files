local BaseCell = autoImport("BaseCell");
PetFashionCell = class("PetFashionCell", BaseCell);

function PetFashionCell:Init()
	self.lockTip = self:FindComponent("LockTip", UILabel);
	self.lockBord = self:FindGO("LockBord");
	self.texture = self:FindComponent("Texture", UITexture);
	self.isChoose = self:FindGO("IsChoose");

	self.noDataBord = self:FindGO("NoDataBord");
	self.dataBord = self:FindGO("DataBord");

	self:AddCellClickEvent();
end

function PetFashionCell:SetData(data)
	self.data = data;

	if(data == nil)then
		self.gameObject:SetActive(false);
		return;
	end
	self.gameObject:SetActive(true);

	local petid = data[1];
	if(petid == 0)then
		self.noDataBord:SetActive(true);
		self.dataBord:SetActive(false);
		return;
	end

	self.noDataBord:SetActive(false);
	self.dataBord:SetActive(true);

	local bodyid, nowbody, islock, tipStr = data[2], data[3], data[4], data[5];
	self.isChoose:SetActive(nowbody == bodyid);
	
	if(bodyid == 0 or bodyid == nil)then
		bodyid = petid;
	end
	if(bodyid)then
		self.model = UIModelUtil.Instance:SetMonsterModelTexture(self.texture, bodyid, nil, true);
		self.model:RegisterWeakObserver(self);
	end

	self.lockBord:SetActive(islock == true);
	if(tipStr)then
		self.lockTip.text = tipStr;
	end
end

function PetFashionCell:ObserverDestroyed(obj)
	if(obj == self.model)then
		self.model = nil;
	end
end
