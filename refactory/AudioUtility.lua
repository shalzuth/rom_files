AudioUtility = class("AudioUtility")
function AudioUtility.GetOneShotAudioSource()
  local resPath = "Public/Audio/AudioOneShot"
  local source
  local go = GameObjPool.Instance:GetEx(resPath, "POOL_AUDIO", nil, true)
  if nil ~= go then
    source = go:GetComponent(AudioSource)
  end
  if nil == source then
    GameObject.Destroy(go)
    local prefab = Game.AssetManager:LoadByType(resPath, AudioSource)
    if nil == prefab then
      return nil
    end
    source = AudioSource.Instantiate(prefab)
  end
  return source
end
local volume = 1
local mute = 0
function AudioUtility.SetVolume(v)
  volume = v
  if mute > 0 then
    return
  end
  AudioHelper.volume = v
end
function AudioUtility.GetVolume()
  return volume
end
function AudioUtility.Mute(on)
  if on then
    mute = mute + 1
    if 1 == mute then
      AudioHelper.volume = 0
    end
  else
    mute = mute - 1
    if 0 == mute then
      AudioHelper.volume = volume
    end
  end
end
function AudioUtility.PlayOneShot2D_Clip(clip)
  Game.Object_AudioSource2D:PlayOneShot(clip, volume)
end
function AudioUtility.PlayOneShot2D_Path(path)
  local clip = Game.AssetManager:LoadByType(path, AudioClip)
  if nil == clip then
    return
  end
  AudioUtility.PlayOneShot2D_Clip(clip)
end
function AudioUtility.PlayOneShot2DSingle_Clip(clip)
  AudioUtility.PlayOn_Clip(clip, Game.Object_AudioSource2D)
end
function AudioUtility.PlayOneShot2DSingle_Path(path)
  local clip = Game.AssetManager:LoadByType(path, AudioClip)
  if nil == clip then
    return
  end
  AudioUtility.PlayOneShot2DSingle_Clip(clip)
end
function AudioUtility.PlayOneShotAt_Clip(clip, p)
  if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V6) then
    local source = AudioUtility.GetOneShotAudioSource()
    if nil == source then
      return nil
    end
    source.transform.position = p
    source.volume = volume
    source.clip = clip
    source:Play()
    source.loop = false
  else
    AudioHelper.PlayOneShotAt(clip, p)
  end
end
function AudioUtility.PlayOneShotAt_Path(path, p)
  local clip = Game.AssetManager:LoadByType(path, AudioClip)
  if nil == clip then
    return
  end
  AudioUtility.PlayOneShotAt_Clip(clip, p)
end
function AudioUtility.PlayOneShotOn_Clip(clip, audioSource)
  audioSource:PlayOneShot(clip, volume)
end
function AudioUtility.PlayOneShotOn_Path(path, audioSource)
  local clip = Game.AssetManager:LoadByType(path, AudioClip)
  if nil == clip then
    return
  end
  AudioUtility.PlayOneShotOn_Clip(clip, audioSource)
end
function AudioUtility.PlayOn_Clip(clip, audioSource)
  audioSource.volume = volume
  audioSource.clip = clip
  audioSource:Play()
end
function AudioUtility.PlayOn_Path(path, audioSource)
  local clip = Game.AssetManager:LoadByType(path, AudioClip)
  if nil == clip then
    return
  end
  AudioUtility.PlayOn_Clip(clip, audioSource)
end
