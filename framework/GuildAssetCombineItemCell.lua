autoImport("BaseCombineCell");
GuildAssetCombineItemCell = class("GuildAssetCombineItemCell",BaseCombineCell);
autoImport("GuildAssetItemCell")
function GuildAssetCombineItemCell:Init()
	self:InitCells(10, "GuildAssetItemCell", GuildAssetItemCell);
end