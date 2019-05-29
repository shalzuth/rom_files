PhotoFileInfo = {}
PhotoFileInfo.PictureFormat = {
  JPG = "jpg",
  PNG = "png",
  BMP = "bmp"
}
PhotoFileInfo.Extension = "jpg"
PhotoFileInfo.OldExtension = "png"
local fileHead = {}
local pngFileHead = {
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10
}
function PhotoFileInfo.GetPictureFormat(file_bytes)
  TableUtility.ArrayClear(fileHead)
  for i = 1, 8 do
    table.insert(fileHead, file_bytes[i])
  end
  if file_head[1] == 216 then
    return PhotoFileInfo.PictureFormat.JPG
  elseif file_head[1] == 77 then
    return PhotoFileInfo.PictureFormat.BMP
  elseif file_head[1] == 137 and table.EqualTo(file_head, pngFileHead) then
    return PhotoFileInfo.PictureFormat.PNG
  end
  return PhotoFileInfo.PictureFormat.JPG
end
