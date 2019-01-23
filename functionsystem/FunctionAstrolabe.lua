FunctionAstrolabe = {}

FunctionAstrolabe.SearchType = 
{
    Path = 1,
    Gold = 2,
    Count = 3
}

local noneIdx = 0
local invaildIdx = -1
local origin = 10000

function FunctionAstrolabe.GetPath(globalID, searchType)
    local activated =  AstrolabeProxy.Instance:GetActivePointsMap()
    return FunctionAstrolabe.BFS(globalID, activated, searchType)
end

local parent = nil
local astrolabeID = 0
local starID = 0
local id = 0
local connects = {}
local star = nil
local floor = math.floor
local visited = {}
local queue = {}

function FunctionAstrolabe.BFS(fpIdx, activated, searchType)
    if activated[fpIdx] then return nil end
    local tableAstrolabe = Table_Astrolabe
    local AssemblePath = FunctionAstrolabe.AssemblePath
    local ReuseAllNode = FunctionAstrolabe.ReuseAllNode
    local bordData = FunctionAstrolabe.bordData
    local Proxy = AstrolabeProxy.Instance
    local CheckPlateIsUnlock = AstrolabeProxy.Instance.CheckPlateIsUnlock
    local head = 0
    local last = 1
    queue[last] = fpIdx
    visited[fpIdx] = noneIdx
    while last > head do
        head = head + 1
        parent = queue[head]
        astrolabeID = floor(parent / origin)
        starID = parent % origin
        star = tableAstrolabe[astrolabeID].stars[starID]
        for i=1, #star do
            --1 innerConnect
            --2 outterConnect
            connects = star[i]
            for k=1, #connects do
                id = connects[k]
                if id < origin then id = id + astrolabeID * origin end
                if id == origin or activated[id] then
                    local path = AssemblePath(visited, id, parent)
                    ReuseAllNode(visited)
                    return path
                end
                
                if (not visited[id] or visited[id] == invaildIdx) and CheckPlateIsUnlock(Proxy, floor(id / origin, bordData)) then
                    visited[id] = parent
                    last = last + 1
                    queue[last] = id
                end
            end
        end
    end
    ReuseAllNode(visited)
    return nil
end

function FunctionAstrolabe.AssemblePath(visited, firstIdx, parentIdx)
    local path = { firstIdx }
    while parentIdx > 0 do
        path[#path + 1] = parentIdx
        parentIdx = visited[parentIdx]
    end
	--------------------LogStart------------------
	-- local str = ""
	-- for _,v in pairs(path) do
	-- 	str = str .. v .. "\n"
	-- end
	-- Debug.Log(str)
	--------------------LogEnd--------------------
    return path
end

function FunctionAstrolabe.ReuseAllNode(visited)
    for k,_ in pairs(visited) do
        visited[k] = invaildIdx
    end
end

function FunctionAstrolabe.ClearCache()
    visited = {}
    connects = {}
    queue = {}
    star = nil
end

FunctionAstrolabe.bordData = nil;
function FunctionAstrolabe.SetBordData(bordData)
    FunctionAstrolabe.bordData = bordData;
end
function FunctionAstrolabe.ReSetBordData()
    FunctionAstrolabe.SetBordData(nil)
end


