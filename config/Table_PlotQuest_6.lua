--md5:2103b4bc75f8265b55fedb9ea3a641cc
Table_PlotQuest_6 = { 
	[1] = {id = 1, Type = 'play_effect_ui', Params = {path="BtoW"}},
	[2] = {id = 2, Type = 'wait_time', Params = {time=6000}},
	[3] = {id = 3, Type = 'onoff_camerapoint', Params = {groupid=0,on=true}},
	[4] = {id = 4, Type = 'wait_time', Params = {time=5000}},
	[5] = {id = 5, Type = 'onoff_camerapoint', Params = {groupid=0,on=false}},
	[6] = {id = 6, Type = 'onoff_camerapoint', Params = {groupid=4,on=true}},
	[7] = {id = 7, Type = 'wait_time', Params = {time=2000}},
	[8] = {id = 8, Type = 'scene_action', Params = {uniqueid=5757,id=502}},
	[9] = {id = 9, Type = 'play_sound', Params = {path="Common/CrystalTower_2_1"}},
	[10] = {id = 10, Type = 'wait_time', Params = {time=8000}},
	[11] = {id = 11, Type = 'onoff_camerapoint', Params = {groupid=4,on=false}},
	[12] = {id = 12, Type = 'onoff_camerapoint', Params = {groupid=8,on=true}},
	[13] = {id = 13, Type = 'wait_time', Params = {time=3000}},
	[14] = {id = 14, Type = 'onoff_camerapoint', Params = {groupid=8,on=false}},
}

Table_PlotQuest_6_fields = { "id","Type","Params",}
return Table_PlotQuest_6