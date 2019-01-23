FunctionMaskWord = class("FunctionMaskWord")

FunctionMaskWord.MaskWordType = {
	SpecialSymbol = 1,
	Chat = 2,
	SpecialName = 4,
	Soliloquize = 8,
	NameExclude = 16,
	GuildSpecialSymbol = 32, --todo xde
}

FunctionMaskWord.MaxLength = 32
function FunctionMaskWord.Me()
	if nil == FunctionMaskWord.me then
		FunctionMaskWord.me = FunctionMaskWord.new()
	end
	return FunctionMaskWord.me
end

function FunctionMaskWord:ctor()
	self.replaceSymbol = "*"
	self:InitFilterWords()
end

-- 把屏蔽字替换成***
-- ... = types (eg:MaskWordType.SpecialSymbol)
function FunctionMaskWord:OldReplaceMaskWord(word,...)
	if ...~=nil then
		for k,v in ipairs({...}) do
			local characterLibrary = self:OldGetCharacterLibraryByType(v)

			word = self:OldReplace( word , characterLibrary )
		end
	end

	return word
end

function FunctionMaskWord:OldCheckMaskWord(word,...)
	if ...~=nil then
		for k,v in ipairs({...}) do
			local characterLibrary = self:OldGetCharacterLibraryByType(v)

			local isMaskWord,maskWord = self:OldCheck( word , characterLibrary )
			if isMaskWord then
				return isMaskWord
			end
		end
	end

	return false
end

function FunctionMaskWord:OldGetCharacterLibraryByType(maskType)
	local library
	if maskType == FunctionMaskWord.MaskWordType.SpecialSymbol then
		library = ObscenceLanguage.SpecialSymbol
	elseif maskType == FunctionMaskWord.MaskWordType.Chat then
		library = ObscenceLanguage.Chat 
	elseif maskType == FunctionMaskWord.MaskWordType.SpecialName then
		library = ObscenceLanguage.Name
	end
	return library
end

function FunctionMaskWord:OldReplace(word,characterLibrary)
	for k,v in ipairs(characterLibrary) do
		if string.find(word , v) then
			local len = StringUtil.Utf8len(v)
			local replaceSymbol = ""
			for i=1,len do
				replaceSymbol = replaceSymbol..self.replaceSymbol
			end
			word = string.gsub(word,v,replaceSymbol)
		end
	end
	return word
end

function FunctionMaskWord:OldCheck(word,characterLibrary)
	for k,v in ipairs(characterLibrary) do
		if string.find(word , v) then
			return true,v
		end
	end

	return false
end


------Optimized

function FunctionMaskWord:CheckMaskWord(word,type)
	return self.csharpFilter:HasBadWord(word,type)
end

function FunctionMaskWord:Check(word,characterLibrary)
	for i=1,#characterLibrary do
		if string.find(word , characterLibrary[i]) then
			return true,characterLibrary[i]
		end
	end

	return false
end

-- 把屏蔽字替换成***
-- ... = types (eg:FunctionMaskWord.MaskWordType.SpecialSymbol)
function FunctionMaskWord:ReplaceMaskWord(word,type)
	return self.csharpFilter:ReplaceBadWord(word,type)
end

local concatTable = {}
function FunctionMaskWord:Replace(word,characterLibrary)
	for i=1,#characterLibrary do
		local lib = characterLibrary[i]
		if string.find(word , lib) then
			local len = StringUtil.Utf8len(lib)
			local replaceSymbol = ""
			TableUtility.ArrayClear(concatTable)
			for i=1,len do
				-- replaceSymbol = replaceSymbol..self.replaceSymbol
				concatTable[i] = self.replaceSymbol
			end
			replaceSymbol = table.concat(concatTable)
			word = string.gsub(word,lib,replaceSymbol)
		end
	end
	return word
end

function FunctionMaskWord:GetCharacterLibraryByType(maskType)
	if maskType == MaskWordType.SpecialSymbol then
		return self.fspecial
	elseif maskType == MaskWordType.Chat then
		return self.fchat
	elseif maskType == MaskWordType.SpecialName then
		return self.fname
	end
	return nil
end

function FunctionMaskWord:InitFilterWords()
	self.csharpFilter = DirtyWordFilter.Instance
	self.csharpFilter:ResetMaxLength( self.MaxLength )
	self:InitFilterWord(ObscenceLanguage.SpecialSymbol,FunctionMaskWord.MaskWordType.SpecialSymbol)
	self:InitFilterWord(ObscenceLanguage.GuildSpecialSymbol,FunctionMaskWord.MaskWordType.GuildSpecialSymbol) --todo xde
	self:InitFilterWord(ObscenceLanguage.Chat,FunctionMaskWord.MaskWordType.Chat)
	self:InitFilterWord(ObscenceLanguage.Name,FunctionMaskWord.MaskWordType.SpecialName)
	self:InitFilterWord(ObscenceLanguage.Soliloquize,FunctionMaskWord.MaskWordType.Soliloquize)
	self:InitFilterWord(ObscenceLanguage.NameExclude,FunctionMaskWord.MaskWordType.NameExclude)
end

function FunctionMaskWord:InitFilterWord(strs,type)
	for i=1,#strs do
		if strs[i] and #strs[i] > 0 and StringUtil.Utf8len(strs[i]) < self.MaxLength then
			self.csharpFilter:InitString(strs[i],type)
		else
			helplog("InitFilterWord is wrong",tostring(strs[i]),type)
		end
	end
end