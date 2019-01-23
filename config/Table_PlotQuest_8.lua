--md5:c9894eb8d5f5e559e3ff3d40e3c9effa
Table_PlotQuest_8 = { 
	[1] = {id = 1, Type = 'play_effect_ui', Params = {path="BtoW"}},
	[2] = {id = 2, Type = 'wait_time', Params = {time=4000}},
	[3] = {id = 3, Type = 'onoff_camerapoint', Params = {groupid=2,on=true}},
	[4] = {id = 4, Type = 'wait_time', Params = {time=5000}},
	[5] = {id = 5, Type = 'onoff_camerapoint', Params = {groupid=2,on=false}},
	[6] = {id = 6, Type = 'onoff_camerapoint', Params = {groupid=6,on=true}},
	[7] = {id = 7, Type = 'wait_time', Params = {time=2000}},
	[8] = {id = 8, Type = 'scene_action', Params = {uniqueid=4747,id=506}},
	[9] = {id = 9, Type = 'play_sound', Params = {path="Common/CrystalTower_4_1"}},
	[10] = {id = 10, Type = 'wait_time', Params = {time=8000}},
	[11] = {id = 11, Type = 'onoff_camerapoint', Params = {groupid=6,on=false}},
	[12] = {id = 12, Type = 'onoff_camerapoint', Params = {groupid=8,on=true}},
	[13] = {id = 13, Type = 'wait_time', Params = {time=3000}},
	[14] = {id = 14, Type = 'onoff_camerapoint', Params = {groupid=8,on=false}},
}

Table_PlotQuest_8_fields = { "id","Type","Params",}
return Table_PlotQuest_8