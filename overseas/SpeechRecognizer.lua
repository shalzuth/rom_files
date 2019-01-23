autoImport("MicrophoneManipulate")

function FindFunctionTable(ud, k)
    local t = ud
    repeat
        local fun=rawget(t,k)
        if fun then
            return t
        end
        t = rawget(t,'__parent')
    until t==nil
    return nil
end

function RedefineExternalSpeech(t)
    local mett = getmetatable(t)

    local function InitRecognizer(name)
    end
    local ft = FindFunctionTable(mett, "InitRecognizer")
    rawset(ft, "InitRecognizer", InitRecognizer)

    local function StartRecognizer()
        if not MicrophoneManipulate.CanSpeech() then
            return
        end
        UIManagerProxy.Instance.microphoneManipulate:StartRecord()
    end
    ft = FindFunctionTable(mett, "StartRecognizer")
    rawset(ft, "StartRecognizer", StartRecognizer)

    local function StopRecognizer()
        if not MicrophoneManipulate.CanSpeech() then
            return
        end
        UIManagerProxy.Instance.microphoneManipulate:StopRecord()
    end
    ft = FindFunctionTable(mett, "StopRecognizer")
    rawset(ft, "StopRecognizer", StopRecognizer)
end

function RedefineSpeechRecognizer(t)
    if not MicrophoneManipulate.CanSpeech() then
        return
    end
    
    local mett = getmetatable(t)

    local function GetAudio(self, url, action)
        if (url == nil or action == nil) then
            return;
        end 
        local urlAbsolute = "file://" .. FileDirectoryHandler.GetAbsolutePath(url);
        self:CallGetWWW(urlAbsolute, function(www)
            if www == nil then
                return
            end
            if www.error ~= nil and #(www.error) > 0 then
                Debug.Log(www.error)
            end
            local clip = UIManagerProxy.Instance.microphoneManipulate:GetRecord(www.bytes);
            action(clip);
        end)
    end
    local ft = FindFunctionTable(mett, "GetAudio")
    rawset(ft, "GetAudio", GetAudio)
end