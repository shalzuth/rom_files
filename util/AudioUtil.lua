AudioUtil = {}

function AudioUtil.PlayCommonAt(res,pos)
	AudioUtility.PlayOneShotAt_Path(ResourcePathHelper.AudioSECommon(res),pos)
end

function AudioUtil.PlayNpcVisitVocal(soundConfig)
 	local sSoundConfigs = string.split(soundConfig, ";");
 	local length = #sSoundConfigs;

 	if(length == 0)then
 		return;
 	end

 	local soundConfigMap = {};
 	local defaultConfig = nil;
 	for i=1,#sSoundConfigs do
 		local sConfigs = string.split(sSoundConfigs[i], ":");
 		if(#sConfigs == 1)then
 			defaultConfig = sConfigs[1];
		elseif(#sConfigs == 2)then
			soundConfigMap[sConfigs[1]] = sConfigs[2];
 		end
 	end
	
	if(soundConfigMap.M and soundConfigMap.F)then
		if(Game.Myself)then
			local gender = Game.Myself.data.userdata:Get(UDEnum.SEX);
			if(gender == 1)then
				AudioUtil.Play2DRandomSound(soundConfigMap.M);
			elseif(gender == 2)then
				AudioUtil.Play2DRandomSound(soundConfigMap.F);
			end
		end
	elseif(defaultConfig)then
		AudioUtil.Play2DRandomSound(defaultConfig);
	end
end

function AudioUtil.Play2DRandomSound(soundConfig)
	if(soundConfig~="")then
		local paths = string.split(soundConfig, '-');
		local rdmIndex = math.random(1,#paths);
		if(rdmIndex)then
			AudioUtil.PlaySound_ByLanguangeSetting( paths[rdmIndex] );
		end
	end
end

function AudioUtil.PlaySound_ByLanguangeSetting(path)
	local fullPath = nil;
	local voice = FunctionPerformanceSetting.Me():GetLanguangeVoice()
	if(voice == LanguageVoice.Jananese)then
		fullPath = ResourcePathHelper.AudioSE_JP( path );
	elseif voice  == LanguageVoice.Korean then --todo xde
		fullPath = ResourcePathHelper.AudioSE( path );
	elseif voice  == LanguageVoice.Chinese then
		fullPath = ResourcePathHelper.AudioSE_CN( path );
	end
	local clip = Game.AssetManager:LoadByType(fullPath, AudioClip)
	if(clip)then
		AudioUtility.PlayOneShot2DSingle_Clip(clip)
	end
end
