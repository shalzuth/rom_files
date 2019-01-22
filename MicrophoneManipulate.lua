MicrophoneManipulate = class("MicrophoneManipulate")

MicrophoneManipulate.sFrequency = 8000;
MicrophoneManipulate.rescaleFactor = 32767;
MicrophoneManipulate.EncodeMode = 0; -- BandMode.Narrow

function MicrophoneManipulate:ctor(speechRecognizer)
    self.speechRecognizer = speechRecognizer
    local manipulateObj = GameObject("MicrophoneManipulate")
    manipulateObj.transform.parent = speechRecognizer.transform
    self.audioSource = manipulateObj:AddComponent(AudioSource)
    
    self.MaxSecond = 0
    self:SetMaxSecond(60)
    self.EncodeFrameSize = MicrophoneFunction.GetSpeexEncoderFrameSize(MicrophoneManipulate.EncodeMode)
    self.volumeSampleBuffer = MicrophoneFunction.CreateFloatBuffer(128);
    
    self.recordingStartTime = -1
    self.preMicrophonePosition = 0
    self.processedSample = 0
    
    if Microphone.devices.Length == 0 then
        Debug.Log("no microphone found")
    end
    TimeTickManager.Me():CreateTick(0, 10, self.Update, self, 1)
end

function MicrophoneManipulate:Update()
    self:CalcVolume()
    self:EncodeAsync()
end

function MicrophoneManipulate:SetMaxSecond(sec)
    self.MaxSecond = sec;
    local sampleSize = MicrophoneFunction.AlignBytes(self.sFrequency * sec + 1024)
    self.sampleBuffer = MicrophoneFunction.CreateFloatBuffer(sampleSize);
    local combineSize = MicrophoneFunction.AlignBytes (self.sFrequency * sec * 2 + 1056);
    self.combineBuffer = MicrophoneFunction.CreateByteBuffer(combineSize);
end

function MicrophoneManipulate:DetermineEncode()
    if (self.recordingStartTime < 0 or not Microphone.IsRecording(nil)) then
        return 0
    end
    local currentPos = Microphone.GetPosition(nil);
    if (currentPos <= self.processedSample) then
        return 0
    end
    local sampleSize = currentPos - self.processedSample;
    if (sampleSize < self.EncodeFrameSize) then
        return 0
    end
    self.audioSource.clip:GetData(self.sampleBuffer, self.processedSample);
    MicrophoneFunction.Float2FloatBuffer(self.sampleBuffer, 0, self.sampleBuffer, 0, sampleSize, MicrophoneManipulate.rescaleFactor)
    return sampleSize
end

function MicrophoneManipulate:EncodeAsync()
    local sampleSize = self:DetermineEncode()
    if sampleSize <= 0 then
        return
    end
    self.processedSample = MicrophoneFunction.SpeexProcessEncodeAsync(MicrophoneManipulate.EncodeMode, self.sampleBuffer, 0, sampleSize)
end

function MicrophoneManipulate:EndEncodeAsync()
    if self.recordingStartTime < 0 or not Microphone.IsRecording(nil) then
        Debug.Log("MicrophoneManipulate:EndEncodeAsync cannot excute because is not start")
        return
    end
    local currentPos = Microphone.GetPosition(nil);
    local sampleSize = currentPos - self.processedSample;
    if sampleSize > 0 then
        self.audioSource.clip:GetData(self.sampleBuffer, self.processedSample);
        MicrophoneFunction.Float2FloatBuffer(self.sampleBuffer, 0, self.sampleBuffer, 0, sampleSize, MicrophoneManipulate.rescaleFactor)
    end
    self.processedSample = currentPos
    local encSize = MicrophoneFunction.SpeexEndEncodeAsync(MicrophoneManipulate.EncodeMode, self.sampleBuffer, 0, sampleSize, self.combineBuffer, 8, self.combineBuffer.Length - 8)
    return encSize
end

function MicrophoneManipulate:StartRecord()
    self.recordingStartTime = Time.realtimeSinceStartup;
    self.audioSource:Stop();
    self.audioSource.loop = false;
    self.audioSource.mute = true;
    self.audioSource.clip = Microphone.Start(nil, false, self.MaxSecond, MicrophoneManipulate.sFrequency);
    self.preMicrophonePosition = 0;
    self.processedSample = 0;
    while (Microphone.GetPosition(nil) <= 0) do end
    self.audioSource:Play();
    MicrophoneFunction.SpeexStartEncodeAsync(MicrophoneManipulate.EncodeMode);
    self:EncodeAsync();
end

function MicrophoneManipulate:CalcVolume()
    if (self.recordingStartTime < 0 or not Microphone.IsRecording(nil)) then
        return
    end
    local currentPos = Microphone.GetPosition(nil);
    if (currentPos <= self.preMicrophonePosition) then
        return;
    end
    local sampleSize = currentPos - self.preMicrophonePosition;
    if (sampleSize < 1000) then
        return;
    end
    sampleSize = 128;
    self.audioSource.clip:GetData(self.volumeSampleBuffer, currentPos - 128);
    local sampleValue = MicrophoneFunction.GetFloatMax(self.volumeSampleBuffer, 0, -1)
    local volume = math.ceil(sampleValue * 30);
    volume = math.min(math.max(volume, 0), 30);
    self.speechRecognizer:VolumeChangedByInt(volume);
    self.preMicrophonePosition = currentPos;
end

function MicrophoneManipulate:StopRecord()
    if (not Microphone.IsRecording(nil)) then
        self.recordingStartTime = -1;
        return;
    end
    local soundData, time, word = self:SaveRecord();
    Microphone.End(null);
    self.audioSource:Stop();
    self.recordingStartTime = -1;
    self.audioSource.mute = false;
    GameObject.Destroy(self.audioSource.clip);
    self.audioSource.clip = null;
    self.speechRecognizer:SetResultByBytes(soundData, time, word);
end

function MicrophoneManipulate:SaveRecord()
    local encSize = self:EndEncodeAsync()
    local rawDataSize = self.processedSample;
    local time = rawDataSize / MicrophoneManipulate.sFrequency
    time = math.ceil(time)
    if (time < 1) then
        Debug.Log("record time is " .. time .. " < 1")
        return
    end
--    local encSize = MicrophoneFunction.SpeexEncode(0, self.sampleBuffer, 0, rawDataSize, self.combineBuffer, 8, self.combineBuffer.Length - 8);
--  first 4 bytes store the raw data length,second 4 bytes store the encode data length
    MicrophoneFunction.WriteIntInBuffer(self.combineBuffer, 0, rawDataSize)
    MicrophoneFunction.WriteIntInBuffer(self.combineBuffer, 4, encSize)
    local combinedSize = 8 + encSize;
    local soundData = MicrophoneFunction.CreateByteBuffer(combinedSize);
    MicrophoneFunction.BlockCopy(self.combineBuffer, 0, soundData, 0, combinedSize);
    return soundData, time, "voice"
end

function MicrophoneManipulate:GetRecord(data)
    if self.recordingStartTime >= 0 then
        Debug.Log("Microphone is recording!!!")
        return nil
    end
    local rawDataLen = MicrophoneFunction.GetIntInBuffer (data, 0);
    local encodeDataLen = MicrophoneFunction.GetIntInBuffer (data, 4);
    local decSize = MicrophoneFunction.SpeexDecode(MicrophoneManipulate.EncodeMode, data, 8, encodeDataLen, self.sampleBuffer, 0, false)
    MicrophoneFunction.Float2FloatBuffer(self.sampleBuffer, 0, self.sampleBuffer, 0, rawDataLen, 1.0 / MicrophoneManipulate.rescaleFactor)
    local clip = AudioClip.Create ("", rawDataLen, 1, MicrophoneManipulate.sFrequency, false);
    clip:SetData (self.sampleBuffer, 0);
    return clip;
end

--function MicrophoneManipulate:GetClipData()
--    if (self.audioSource.clip == nil) then
--        Debug.Log("GetClipData audioSource.clip is null");
--        return 0;
--    end
--
--    local timeRate = (Time.realtimeSinceStartup - self.recordingStartTime) / self.audioSource.clip.length;
--    timeRate = math.min(math.max(timeRate, 0), 1);
--    local saveSamples = math.floor(timeRate * self.audioSource.clip.samples);
--    if (self.sampleBuffer.Length < self.audioSource.clip.samples) then
--        Debug.LogError ("sampleBuffer.Length[" .. self.sampleBuffer.Length .. "] < audioSource.clip.samples[" .. self.audioSource.clip.samples .. "]");
--    end
--    self.audioSource.clip:GetData(self.sampleBuffer, 0);
--    MicrophoneFunction.Float2FloatBuffer(self.sampleBuffer, 0, self.sampleBuffer, 0, saveSamples, MicrophoneManipulate.rescaleFactor)
--    return saveSamples;
--end

-- todo xde
function MicrophoneManipulate.CanSpeech()
    return false
    -- return RO.MicrophoneFunction ~= nil
end