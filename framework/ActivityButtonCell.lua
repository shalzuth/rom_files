local baseCell = autoImport("BaseCell")
ActivityButtonCell = class("ActivityButtonCell",baseCell)

function ActivityButtonCell:Init()
	self:initView()
	self.iconWidth = 80
	self.iconHeight = 80
end

function ActivityButtonCell:initView(  )
	-- body
	self.activity_texture = self:FindComponent("activity_texture",UITexture)
	self.activity_label = self:FindComponent("activity_label",UILabel)
	self.holderSp = self:FindGO("holderSp")
	self:AddCellClickEvent();
end

function ActivityButtonCell:SetData( data )
	-- body
	self:Show(self.holderSp)

	local texture = self.activity_texture.mainTexture
	self.activity_texture.mainTexture = nil
	Object.DestroyImmediate(texture)
	self.data = data
	self:updateTime()
	self:PassEvent(MainviewActivityPage.GetIconTexture, self)
end

function ActivityButtonCell:updateTime(  )
	-- body
	local data = self.data
	if(data.countdown)then		
		local subActs = data.sub_activity
		if(subActs and #subActs>0)then
			local subActs = data.sub_activity
			local currentTime = ServerTime.CurServerTime()
			currentTime = math.floor(currentTime / 1000)
			local time = subActs[1].begintime
			local leftTime = time - currentTime

			-- local timeStr1 = os.date("%Y-%m-%d %H:%M:%S",time)
			-- local timeStr2 = os.date("%Y-%m-%d %H:%M:%S",subActs[1].endtime)
			-- local timeStr3 = os.date("%Y-%m-%d %H:%M:%S",currentTime)
			-- LogUtility.InfoFormat("ActivityButtonCell updateTime startT:{0},endT:{1},curTime:{2}",timeStr1,timeStr2,timeStr3)

			local preText = ZhString.ActivityData_Start
			if(leftTime < 0)then
				leftTime = subActs[1].endtime - currentTime
				preText = ZhString.ActivityData_Finish
			end
			if(leftTime >= 3600*24)then
				local day = math.floor(leftTime/(3600*24))
				local h = math.floor((leftTime - day*3600*24)/3600)
				self.activity_label.text = string.format(ZhString.ActivityData_HourDes,data.name,day,h,preText)
			else
				local h = math.floor(leftTime / 3600)
				local m = math.floor((leftTime - h*3600) / 60)
				local s = leftTime - h*3600 - m*60
				self.activity_label.text = string.format(ZhString.ActivityData_TimeLineDes,data.name,h,m,s,preText)
			end
		else
			self.activity_label.text = data.name
		end
	else
		self.activity_label.text = data.name
	end
end

function ActivityButtonCell:OnRemove(  )
	Object.DestroyImmediate(self.activity_texture.mainTexture)
end

function ActivityButtonCell:setTextureByBytes( bytes )
	local texture = Texture2D(2,2,TextureFormat.RGB24,false)
	local bRet = ImageConversion.LoadImage(texture, bytes)
	if(bRet)then
		self:setTexture(texture)
	else
		Object.DestroyImmediate(texture)
	end
end

function ActivityButtonCell:setTexture( texture )
	-- body
	if(texture)then
		self:Hide(self.holderSp)
		Object.DestroyImmediate(self.activity_texture.mainTexture)
		self.activity_texture.mainTexture = texture
		self.activity_texture:MakePixelPerfect()
	end
end