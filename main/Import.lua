autoImportPathMap = {}

function autoImport(moduleName)
	local fullPath = autoImportPathMap[moduleName]
	if(fullPath == nil)then
		fullPath = MyLuaSrv.GetFullPath(moduleName)
		autoImportPathMap[moduleName] = fullPath
	end
	if(_G[fullPath])then
		return _G[fullPath];
	end
	if(fullPath ~= nil) then
		return require (fullPath)
	end
	return nil
end