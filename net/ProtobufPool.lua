ProtobufPool = {}
local ArrayPopBack = TableUtility.ArrayPopBack
local ArrayPushBack = TableUtility.ArrayPushBack
local pool = {}
local poolNum = 100

function ProtobufPool.Get(pb_class)
    local dataPool = pool[pb_class]
    if(dataPool~=nil) then
        local data = ArrayPopBack(dataPool)
        if(data~=nil) then
                -- LogUtility.InfoFormat("ProtobufPool.Get {0}",tostring(pb_class.name))
            return data
        end
    end
                -- LogUtility.InfoFormat("ProtobufPool.Get create {0}",tostring(pb_class.name))
    return pb_class()
end

function ProtobufPool.GetArray(arrayIndex)
    local dataPool = pool[arrayIndex]
    if(dataPool~=nil) then
        local data = ArrayPopBack(dataPool)
        if(data~=nil) then
            return data
        end
    end
    return nil
end

function ProtobufPool.Add(pb_class,data,num)
    num = num or poolNum
                -- LogUtility.InfoFormat("ProtobufPool.Add {0}",tostring(pb_class.name))
    local dataPool = pool[pb_class]
    if(dataPool==nil)then
        dataPool = {}
        pool[pb_class] = dataPool
    else
        if(#dataPool>=num) then
            return
        end
    end
    ArrayPushBack(dataPool,data)
end