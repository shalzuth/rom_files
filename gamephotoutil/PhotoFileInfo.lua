PhotoFileInfo = {}

PhotoFileInfo.PictureFormat = {
	JPG = 'jpg',
	PNG = 'png',
	BMP = 'bmp'
}

PhotoFileInfo.Extension = 'png'-- todo xde
PhotoFileInfo.OldExtension = 'png'

local fileHead = {}
local pngFileHead = {0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A}
function PhotoFileInfo.GetPictureFormat(file_bytes)
	TableUtility.ArrayClear(fileHead)
	for i = 1, 8 do
		table.insert(fileHead, file_bytes[i])
	end
	if file_head[1] == 0xd8 then
		return PhotoFileInfo.PictureFormat.JPG
	elseif file_head[1] == 0x4D then
		return PhotoFileInfo.PictureFormat.BMP
	elseif file_head[1] == 0x89 then
		if table.EqualTo(file_head, pngFileHead) then
			return PhotoFileInfo.PictureFormat.PNG
		end
	end
	return PhotoFileInfo.PictureFormat.JPG
end