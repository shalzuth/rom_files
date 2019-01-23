--md5:e6af2923b95e92c53b0fc1998b6ea342
Table_ScreenFilter = { 
	[1] = {id = 1, Group = 1, Targets = {1,2}, Range = {1}, Content = {1,2,3,4,5,6}, Name = '显示公会'},
	[2] = {id = 2, Group = 1, Targets = {1,2}, Range = {2}, Content = {1,2,3,4,5,6}, Name = '显示组队'},
	[3] = {id = 3, Group = 1, Targets = {1,2}, Range = {3}, Content = {1,2,3,4,5,6,7}, Name = '显示自己'},
	[4] = {id = 4, Group = 2, Targets = {1,2}, Range = {1}, Content = {1,2,3,4,5,6}, Name = '显示公会'},
	[5] = {id = 5, Group = 2, Targets = {1,2}, Range = {2}, Content = {1,2,3,4,5,6}, Name = '显示组队'},
	[6] = {id = 6, Group = 2, Targets = {1,2}, Range = {3}, Content = {1,2,3,4,5,6}, Name = '显示自己'},
	[7] = {id = 7, Group = 2, Targets = {1,2,3}, Range = {5}, Content = {1,2,3,6}, Name = '屏蔽信息'},
	[8] = {id = 8, Group = 3, Targets = {1,2,3}, Range = {4}, Content = {1}, Name = '默认屏蔽'},
	[9] = {id = 9, Group = 4, Targets = {1,2,3}, Range = {5}, Content = {1,2,3,6}, Name = '屏蔽信息'},
	[10] = {id = 10, Group = 5, Targets = {1,2,3}, Range = {5}, Content = {1,6}, Name = '理发店屏蔽'},
	[11] = {id = 11, Group = 6, Targets = {3}, Range = {3}, Content = {1,2,3,6}, Name = '屏蔽NPC名字'},
	[12] = {id = 12, Group = 7, Targets = {1}, Range = {6}, Content = {1,2,3,4,5,6}, Name = '完全屏蔽自己'},
	[13] = {id = 13, Group = 13, Targets = {1,2}, Range = {6}, Content = {1,2,3,4,5,6,8}, Name = '显示自己'},
	[14] = {id = 14, Group = 14, Targets = {1,2}, Range = {1,7}, Content = {1,2,3,4,5,6,8}, Name = '显示队友'},
	[15] = {id = 15, Group = 15, Targets = {1,2}, Range = {2,8}, Content = {1,2,3,4,5,6,8}, Name = '显示公会'},
	[16] = {id = 16, Group = 16, Targets = {1,2}, Range = {1,2}, Content = {1,2,3,4,5,6,8}, Name = '显示路人'},
	[17] = {id = 17, Group = 17, Targets = {4}, Range = {5}, Content = {1,2,3,4,5,6,8}, Name = '显示魔物'},
	[18] = {id = 18, Group = 18, Targets = {3}, Range = {5}, Content = {1,2,3,4,5,6,7}, Name = '显示NPC'},
	[19] = {id = 19, Group = 19, Targets = {1,2,3,4}, Range = {5}, Content = {1,2,3,6,7,8}, Name = '显示界面'},
	[20] = {id = 20, Group = 20, Targets = {1,2,3,4}, Range = {5}, Content = {1,2}, Name = '屏蔽所有的名字，含自己'},
	[21] = {id = 21, Group = 21, Targets = {1,2,3,4}, Range = {3}, Content = {1,2,3,4,5,6,7,8}, Name = '理发店只显示自己'},
	[22] = {id = 22, Group = 22, Targets = {1,2}, Range = {5}, Content = {1,2,3,4,5,6,7,8}, Name = '屏蔽自己和其他玩家（祈祷用）'},
	[23] = {id = 23, Group = 23, Targets = {1,2}, Range = {7,8}, Content = {1,2,3,4,5,6,8}, Name = '拍照屏蔽队友并且是公会'},
	[24] = {id = 24, Group = 24, Targets = {1,4}, Range = {3}, Content = {3,5}, Name = '黑屏挂机时候屏蔽npc说话与emoji'},
	[25] = {id = 25, Group = 25, Targets = {1}, Range = {3}, Content = {8}, Name = '黑屏挂机时屏蔽怪物与其他玩家身上是伤害数字'},
	[26] = {id = 26, Group = 26, Targets = {1,2,3,4}, Range = {3}, Content = {3}, Name = '黑屏挂机时屏蔽怪物与玩家的技能喊话'},
	[27] = {id = 27, Group = 27, Targets = {1}, Range = {3}, Content = {2}, Name = '黑屏挂机时屏蔽其他玩家的名称'},
	[28] = {id = 28, Group = 28, Targets = {1,2}, Range = {2}, Content = {4}, Name = '黑屏挂机时屏蔽队伍外玩家的模型'},
}

Table_ScreenFilter_fields = { "id","Group","Targets","Range","Content","Name",}
return Table_ScreenFilter