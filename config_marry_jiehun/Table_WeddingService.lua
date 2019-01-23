--md5:9b9e84cada2c4e70be843d3616637d3f
Table_WeddingService = { 
	[101] = {id = 101, Type = 1, Desc = '免费世界线婚礼祝福', Background = '', Price = {{id=151,num=0}}, Service = _EmptyTable, Effect = _EmptyTable, SuccessEffect = _EmptyTable},
	[102] = {id = 102, Type = 1, Desc = '婚礼豪华礼花', Background = '', Price = {{id=151,num=64}}, Service = _EmptyTable, Effect = _EmptyTable, SuccessEffect = {{type="scene_effect",pos={23,3,-2},effect="Common/Sakura_Show",cleartime=3600,map=1},{type="scene_effect",pos={0,3,-3},effect="Common/Sakura_Show",cleartime=3600,map=10008}}},
	[103] = {id = 103, Type = 1, Desc = '婚车环城巡游', Background = '', Price = {{id=151,num=64}}, Service = _EmptyTable, Effect = _EmptyTable, SuccessEffect = _EmptyTable},
	[104] = {id = 104, Type = 1, Desc = '专属婚礼天空', Background = '', Price = {{id=151,num=260}}, Service = _EmptyTable, Effect = {{type="rangeweather",pos={23,30,-2},weather=6,cleartime=3600,map=1,range=20},{type="rangeweather",pos={0,30,-3},weather=6,cleartime=3600,map=10008,range=20}}, SuccessEffect = _EmptyTable},
	[105] = {id = 105, Type = 1, Desc = '专属婚礼音乐bgm', Background = '', Price = {{id=151,num=260}}, Service = _EmptyTable, Effect = {{type="rangebgm",pos={0,1,-3},bgm="MusicBox_LoveF",cleartime=3600,map=10008,range=30},{type="rangebgm",pos={18,3,-5},bgm="MusicBox_LoveF",cleartime=3600,map=1,range=30}}, SuccessEffect = _EmptyTable},
	[6076] = {id = 6076, Type = 2, Desc = '', Background = 'marry_pic_1', Price = _EmptyTable, Service = {101}, Effect = _EmptyTable, SuccessEffect = _EmptyTable},
	[6077] = {id = 6077, Type = 2, Desc = '', Background = 'marry_pic_2', Price = _EmptyTable, Service = {101,102,103}, Effect = _EmptyTable, SuccessEffect = _EmptyTable},
	[6078] = {id = 6078, Type = 2, Desc = '', Background = 'marry_pic_3', Price = _EmptyTable, Service = {101,102,103,104,105}, Effect = _EmptyTable, SuccessEffect = _EmptyTable},
}

Table_WeddingService_fields = { "id","Type","Desc","Background","Price","Service","Effect","SuccessEffect",}
return Table_WeddingService