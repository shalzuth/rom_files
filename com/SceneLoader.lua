local SceneLoader = class("SceneLoader")

local defaultLimitTime = 2
local defaultLerpSpd = 2.5
function SceneLoader:ctor()
	self.limitLoadingTime = defaultLimitTime
	self.fakeStopProgress = 100
	self.lerpSpd = defaultLerpSpd
	self.fadeBGM = true
	self:Init()
end

function SceneLoader:Init()
	self.autoAllowSceneActivation = true
	self.Progress = 0
	self.passedTime = 0
	self.isLoading = false
	self.sceneInfo = nil
	self.arriveLimitTime = false
end

function SceneLoader:EnableFadeBGM(value)
	self.fadeBGM = value
end

function SceneLoader:SyncLoad(name)
	self:TryLoadBundle(name)
	SceneUtil.SyncLoad(name)
end

function SceneLoader:SetLimitLoadTime(time,lerpSpd)
	self.limitLoadingTime = time
	self.lerpSpd = lerpSpd
end

function SceneLoader:RestoreLimitLoadTime()
	self.limitLoadingTime = defaultLimitTime
	self.lerpSpd = defaultLerpSpd
end

function SceneLoader:StartLoad(name,bundleName)
	if(self.asyncLoad ~= nil and self.asyncLoad.isDone==false)then
		return false
	end
	self:Init()
	self.isLoading = true
	self.sceneInfo = name
	self:TryLoadBundle(bundleName)
	self.asyncLoad = SceneManagement.SceneManager.LoadSceneAsync(name)
	self.asyncLoad.allowSceneActivation = false
	self.toProgress = 0
	self.percent = 0
	local bgMusic = FunctionBGMCmd.Me():GetDefaultBGM()
	if(bgMusic and AudioManager.Instance~=nil) then
		self.bgmVolume = bgMusic:GetVolume()
	else
		self.bgmVolume = FunctionBGMCmd.Me().currentVolume
	end
	if(self.asyncLoad) then
		TimeTickManager.Me():ClearTick(self)
		TimeTickManager.Me():CreateTick(0,16,self.Loading,self,1,true)
	end
	return true
end

function SceneLoader:TryLoadBundle(name)
	if(ApplicationHelper.AssetBundleLoadMode) then
		ResourceManager.Instance:SLoadScene(name)
	end
end

function SceneLoader:Loading(deltaTime)
	if(self.asyncLoad==nil) then
		return
	end
	self.passedTime = self.passedTime + Time.deltaTime
	self.arriveLimitTime = self.passedTime>=self.limitLoadingTime
	--unity的bug，progress到0.9后就不更新了
  	if(self.asyncLoad.progress < 0.89) then
  		self.toProgress = self.asyncLoad.progress * 100;
  	else
  		if(not self.arriveLimitTime) then
  			self.toProgress = self.fakeStopProgress
  		else
	  		self.toProgress = 100
	  	end
  	end
  	if(self.Progress < self.toProgress) then
		self.Progress = math.min(self.lerpSpd+self.Progress,self.toProgress)
        if(self.Progress>= self.toProgress and self.toProgress == 100) then
        	--加载到100%的时候，背景音乐不播放
        	if(AudioManager.Instance~=nil) then
	        	AudioManager.Instance.bgMusic.volume = 0
	        end
        	if(self.arriveLimitTime) then
	        	self.asyncLoad.allowSceneActivation = true;
	        end
        else
        	self.percent = self.Progress/100
        	local bgMusic = FunctionBGMCmd.Me():GetDefaultBGM()
        	if(bgMusic and self.fadeBGM and AudioManager.Instance~=nil) then
        		local v = 1 * (1-self.percent) + AudioManager.Instance.fadeOutEnd * self.percent
        		bgMusic:SetVolume(v*self.bgmVolume)
        	end
        end
    elseif(self.toProgress == 100 and self.arriveLimitTime) then
    	if(not self.asyncLoad.allowSceneActivation and self.autoAllowSceneActivation)then
    		self.asyncLoad.allowSceneActivation = true
    	else
			self:LoadFinish()
		end
  	end
end

function SceneLoader:SetAllowSceneActivation()
	if(self.asyncLoad and self.asyncLoad.allowSceneActivation) then
		self.asyncLoad.allowSceneActivation =true
		self.asyncLoad = nil
	end
end

function SceneLoader:SetDoneCallBack(callBack)
	self.DoneCallBack = callBack
end

function SceneLoader:SceneAwake()
	LeanTween.delayedCall(3,function ()
		if(self.isLoading) then
			self.isLoading = false
			if(self.asyncLoad and self.asyncLoad.allowSceneActivation) then
				self.asyncLoad = nil
			end

			if(self.sceneInfo) then
				ResourceManager.Instance:SUnLoadScene(self.sceneInfo,false)
			end

			if(self.DoneCallBack ~=nil) then
				self.DoneCallBack(self.sceneInfo)
				self.DoneCallBack = nil
			end
		end
	end):setUseFrames(true)
end

function SceneLoader:LoadFinish()
	self.Progress = 100
	self.fadeBGM = true
	TimeTickManager.Me():ClearTick(self)
end

return SceneLoader