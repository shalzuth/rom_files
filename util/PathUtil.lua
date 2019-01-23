PathUtil = {
	LOCAL_URL_PREFIX = PathHelper.LOCAL_URL_PREFIX,
}

function PathUtil.GetPathURL(path)
	return PathHelper.GetPathURL(path)
end

function PathUtil.GetSavePath(subPath)
	return PathHelper.GetSavePath(subPath)
end

--print (string.format("<color=red>LOCAL_URL_PREFIX=%s\nSavePath=%s</color>", PathUtil.LOCAL_URL_PREFIX, PathUtil.GetSavePath("")))