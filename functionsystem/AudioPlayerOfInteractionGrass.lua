AudioPlayerOfInteractionGrass = class('AudioPlayerOfInteractionGrass')

function AudioPlayerOfInteractionGrass.Play(audio_path)
	-- local resPath = ResourcePathHelper.AudioSECommon(audio_path)
	-- if resPath then
	-- 	local audioSource = AudioHelper.GetAudioSource(resPath)
	-- 	if audioSource then
	-- 		local audioController = AudioHelper.SPlayOn(resPath, audioSource)
	-- 		return audioController
	-- 	end
	-- end
	-- return nil
end

function AudioPlayerOfInteractionGrass.PlayOneShot(audio_path, audio_source)
	local resPath = ResourcePathHelper.AudioSECommon(audio_path)
	if resPath then
		if audio_source then
			local audioSource = AudioHelper.SPlayOneShotOn(resPath, audio_source)
			return audioSource
		end
	end
	return nil
end

function AudioPlayerOfInteractionGrass.PlayOneShotAt(audio_path, position)
	local resPath = ResourcePathHelper.AudioSECommon(audio_path)
	if resPath then
		local audioSource = AudioHelper.SPlayOneShotAt(resPath, position)
		return audioSource
	end
	return nil
end