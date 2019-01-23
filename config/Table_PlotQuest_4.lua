--md5:4f2f871f6ebe213bf88958d0e1203a2e
Table_PlotQuest_4 = { 
	[1] = {id = 1, Type = 'camera', Params = {pos={31.25,10.56,49},rotate={0,-89.3112,0},fieldview=25}},
	[2] = {id = 2, Type = 'set_dir', Params = {player=1,dir=270}},
	[3] = {id = 3, Type = 'showview', Params = {panelid=800,showtype=1}},
	[4] = {id = 4, Type = 'summon', Params = {npcid=4601,npcuid=4601,groupid=1,pos={17.49, 7.51, 47.02},dir=90}},
	[5] = {id = 5, Type = 'summon', Params = {npcid=4602,npcuid=4602,groupid=1,pos={17.02, 7.51, 49.59},dir=90}},
	[6] = {id = 6, Type = 'summon', Params = {npcid=4603,npcuid=4603,groupid=1,pos={17.01, 7.51, 53.01},dir=90}},
	[7] = {id = 7, Type = 'wait_time', Params = {time=2000}},
	[8] = {id = 8, Type = 'addbutton', Params = {id=1,text="开始",eventtype="goon"}},
	[9] = {id = 9, Type = 'wait_ui', Params = {button=1}},
	[10] = {id = 10, Type = 'move', Params = {npcuid=4601,pos={17.01, 7.51, 53.01},dir=90,spd=1.2}},
	[11] = {id = 11, Type = 'move', Params = {npcuid=4602,pos={17.49, 7.51, 47.02},dir=90,spd=0.6}},
	[12] = {id = 12, Type = 'move', Params = {npcuid=4603,pos={17.02, 7.51, 49.59},dir=90,spd=0.6}},
	[13] = {id = 13, Type = 'wait_time', Params = {time=2000}},
	[14] = {id = 14, Type = 'move', Params = {npcuid=4601,pos={17.02, 7.51, 49.59},dir=90,spd=0.6}},
	[15] = {id = 15, Type = 'move', Params = {npcuid=4602,pos={17.01, 7.51, 53.01},dir=90,spd=1.2}},
	[16] = {id = 16, Type = 'move', Params = {npcuid=4603,pos={17.49, 7.51, 47.02},dir=90,spd=0.6}},
	[17] = {id = 17, Type = 'wait_time', Params = {time=1000}},
	[18] = {id = 18, Type = 'move', Params = {npcuid=4601,pos={17.01, 7.51, 53.01},dir=90,spd=1}},
	[19] = {id = 19, Type = 'move', Params = {npcuid=4602,pos={17.49, 7.51, 47.02},dir=90,spd=2}},
	[20] = {id = 20, Type = 'move', Params = {npcuid=4603,pos={17.02, 7.51, 49.59},dir=90,spd=1}},
	[21] = {id = 21, Type = 'wait_time', Params = {time=2000}},
	[22] = {id = 22, Type = 'addbutton', Params = {id=2,text="看清了",eventtype="goon"}},
	[23] = {id = 23, Type = 'wait_ui', Params = {button=2}},
	[24] = {id = 24, Type = 'wait_time', Params = {time=2000}},
}

Table_PlotQuest_4_fields = { "id","Type","Params",}
return Table_PlotQuest_4