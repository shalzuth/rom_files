Table_Menu = {
[1]={id = 1, type = 1, PanelID = 4, text = '完成后解锁技能功能', Condition = {quest = {11500006}}, event = _EmptyTable, sysMsg = {id = 801}, Tip = '技能 已开放', Show = 1, Icon = {uiicon = 'Skill'}},
----------
[3]={id = 3, type = 1, PanelID = 121, text = '职业页签', Condition = {quest = {11500006}}, event = _EmptyTable, sysMsg = {id = 801}, Tip = '', Icon = _EmptyTable},
[2001]={id = 2001, PanelID = 10005, text = '万圣节活动', Condition = {level = 1}, sysMsg = _EmptyTable},
[2002]={id = 2002, PanelID = 10007, text = '双十一活动', Condition = {level = 1}, sysMsg = _EmptyTable},
----------
[4]={id = 4, type = 2, PanelID = 300, text = '完成后解锁精炼功能', Condition = {quest = {99120001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '精炼 已开放', Show = 1, Icon = {uiicon = 'refine'}, Enterhide = 1},
----------
[5]={id = 5, type = 2, PanelID = 301, text = '修理', Condition = {quest = {99120001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '修理 已开放', Icon = _EmptyTable, Enterhide = 1},
----------
[6]={id = 6, type = 1, PanelID = 71, text = '完成后解锁照相机功能', Condition = {quest = {40002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '照相机 已开放', Show = 1, Icon = {uiicon = 'photo'}, Enterhide = 1},
----------
[7]={id = 7, type = 1, PanelID = 91, text = '完成后解锁强化功能', Condition = {quest = {99130011}}, event = _EmptyTable, sysMsg = {id = 803}, Tip = '强化 已开放', Show = 1, Icon = {uiicon = 'Forging'}},
----------
[8]={id = 8, type = 2, PanelID = 302, text = '分解', Condition = {level = 1}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '分解 已开放', Icon = _EmptyTable},
----------
[9]={id = 9, type = 1, PanelID = 191, text = '完成后解锁表情功能', Condition = {quest = {10003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '表情 已开放', Show = 1, Icon = {uiicon = 'icon_50'}, Enterhide = 1},
----------
[10]={id = 10, type = 3, text = '技能栏', Condition = {level = 1}, event = {type = 'skillgrid'}, sysMsg = _EmptyTable, Tip = '获得新的技能栏', Icon = _EmptyTable},
[11]={id = 11},
[12]={id = 12},
[13]={id = 13, Condition = {quest = {11500006}}},
[14]={id = 14, Condition = {quest = {99070001, 11500006}}},
[15]={id = 15, Condition = {level = 40}},
----------
[16]={id = 16, type = 3, text = '可习得·紧急治疗', Condition = {quest = {10120}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '习得技能·紧急治疗', Show = 1, Icon = {uiicon = 'Skill'}},
----------
[17]={id = 17, type = 3, text = '普攻', Condition = {level = 1}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '习得技能·普攻', Icon = _EmptyTable},
----------
[18]={id = 18, type = 3, text = '重击', Condition = {level = 1}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '习得技能·重击', Icon = _EmptyTable},
----------
[19]={id = 19, type = 1, PanelID = 201, text = '完成后委托看板开放', Condition = {quest = {99090011}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '委托看板 已开放', Show = 1, Icon = {uiicon = 'Wanted'}},
----------
[20]={id = 20, type = 1, PanelID = 920, text = '完成后斗技场开放', Condition = {level = 40}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '斗技场 已开放', Show = 1, Icon = {uiicon = 'Arena'}, Enterhide = 1},
----------
[21]={id = 21, type = 3, text = '可习得·装死', Condition = {quest = {99070001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '习得技能·装死', Show = 1, Icon = {uiicon = 'Skill'}},
----------
[22]={id = 22, type = 1, PanelID = 351, text = '组队', Condition = {level = 1}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '组队 已开放', Icon = {uiicon = 'Party'}},
----------
[23]={id = 23, type = 1, PanelID = 400, text = '可获得冒险手册', Condition = {quest = {60030002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '冒险手册 已开放', Show = 1, Acc = 1, Icon = {uiicon = 'RiskBook'}, Enterhide = 1},
----------
[24]={id = 24, type = 2, PanelID = 1100, text = '完成后训练场开放', Condition = {quest = {310080001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '训练场 已开放', Show = 1, Icon = {uiicon = 'Activities'}},
----------
[25]={id = 25, type = 2, PanelID = 1101, text = '训练场组队', Condition = {quest = {310080001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '训练场便捷组队', Icon = _EmptyTable},
----------
[26]={id = 26, type = 2, text = '完成后恩德勒斯塔开放', Condition = {quest = {310020002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '恩德勒斯塔 已开放', Show = 1, Icon = {uiicon = 'Dungeon'}},
----------
[27]={id = 27, type = 2, text = '便捷组队', Condition = {quest = {310020002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '恩德勒斯塔便捷组队', Icon = _EmptyTable},
----------
[28]={id = 28, type = 3, text = '冒险手册·魔物图鉴开放', Condition = {quest = {60030002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁·魔物图鉴', Show = 1, Acc = 1, Icon = {uiicon = 'RiskBook'}},
----------
[29]={id = 29, type = 3, text = '冒险手册·卡片图鉴开放', Condition = {quest = {60040003}}, event = {type = 'unlockmanual', param = {2, 20001, 20002, 20003, 20005, 20007, 20009, 20010, 20012, 20013, 20018, 20021, 20023, 20025, 20026, 20029, 20033, 20036, 20040, 20046, 20047, 20049, 20052, 20054, 20055, 20058, 20062, 20063, 20066, 20071, 20080, 20081, 20094, 20102, 23200, 23201, 23202, 23204, 23206, 20004, 20006, 20008, 20011, 20015, 20016, 20022, 20028, 20032, 20034, 20035, 20037, 20039, 20042, 20045, 20048, 20050, 20051, 20059, 20060, 20061, 20064, 20065, 20068, 20069, 20070, 20072, 20074, 20075, 20079, 20082, 20083, 20085, 20087, 20089, 20090, 20095, 20097, 23203, 20101, 20014, 20017, 20019, 20020, 20024, 20027, 20030, 20031, 20038, 20041, 20043, 20044, 20053, 20056, 20057, 20067, 20073, 20076, 20077, 20084, 20086, 20088, 20096, 20098, 20100, 23205, 24003, 24004, 24005, 24006, 24014, 24017, 24018, 24020, 24021, 24022, 24023, 24024, 24025, 24026, 24027, 24028, 24029}}, sysMsg = _EmptyTable, Tip = '解锁·卡片图鉴', Show = 1, Acc = 1, Icon = {uiicon = 'RiskBook'}, Enterhide = 1},
----------
[30]={id = 30, type = 3, text = '冒险手册·NPC图鉴开放', Condition = {quest = {60040004}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁·NPC图鉴', Show = 1, Acc = 1, Icon = {uiicon = 'RiskBook'}, Enterhide = 1},
----------
[31]={id = 31, type = 3, text = '冒险手册·头饰图鉴开放', Condition = {quest = {344010002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁·头饰图鉴', Show = 1, Acc = 1, Icon = {uiicon = 'RiskBook'}, Enterhide = 1},
----------
[32]={id = 32, type = 3, text = '冒险手册·坐骑页签', Condition = {level = 200}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁·坐骑图鉴', Icon = _EmptyTable, Enterhide = 1},
----------
[33]={id = 33, type = 2, PanelID = 1300, text = '完成后修复裂隙开放', Condition = {quest = {310100011}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '裂隙修复 已开放', Show = 1, Icon = {uiicon = 'daily'}},
----------
[34]={id = 34, type = 3, text = '冒险手册·景点图鉴开放', Condition = {quest = {60030002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁·景点图鉴', Show = 1, Acc = 1, Icon = {uiicon = 'RiskBook'}},
----------
[36]={id = 36, type = 2, PanelID = 1200, text = '完成后抗击魔潮开放', Condition = {quest = {99090033}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '抗击魔潮 已开放', Show = 1, Icon = {uiicon = 'daily'}},
----------
[37]={id = 37, type = 3, text = '完成后解锁妙勒尼山脉裂隙', Condition = {quest = {90140004}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '妙勒尼出现了裂隙[多人]', Show = 1, Icon = {uiicon = 'daily'}},
----------
[38]={id = 38, type = 3, text = '完成后解锁海底洞穴裂隙', Condition = {quest = {90110004}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '海底洞穴出现了裂隙[多人]', Show = 1, Icon = {uiicon = 'daily'}},
----------
[39]={id = 39, type = 3, text = '完成后解锁西门裂隙', Condition = {quest = {310100002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '西门出现了裂隙[多人]', Show = 1, Icon = {uiicon = 'daily'}},
----------
[40]={id = 40, type = 3, text = '完成后解锁苏克拉特沙漠裂隙', Condition = {quest = {90350005}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '苏克拉特沙漠出现了裂隙[多人]', Show = 1, Icon = {uiicon = 'daily'}},
----------
[41]={id = 41, type = 3, text = '完成后解锁斐杨树林裂隙', Condition = {quest = {90320005}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '斐扬树林出现了裂隙[多人]', Show = 1, Icon = {uiicon = 'daily'}},
----------
[42]={id = 42, type = 3, text = '完成后解锁兽人村落裂隙', Condition = {quest = {90250005}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '兽人村落出现了裂隙[多人]', Show = 1, Icon = {uiicon = 'daily'}},
----------
[51]={id = 51, type = 3, text = '克雷斯特勋章收集者', Condition = {level = 80}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '', Icon = _EmptyTable},
[52]={id = 52, text = '破碎时空指针收集者', Condition = {level = 90}},
[713]={id = 713, text = '闪电冲击', Condition = {level = 1}, event = {type = 'unlockhair', param = {7}}},
[714]={id = 714, text = '天使之力', Condition = {level = 1}, event = {type = 'unlockhair', param = {18}}},
[715]={id = 715, text = '火柱术', Condition = {level = 1}, event = {type = 'unlockhair', param = {10}}},
[716]={id = 716, text = '苍鹰之眼', Condition = {level = 1}, event = {type = 'unlockhair', param = {17}}},
[750]={id = 750, text = '解锁美瞳', Condition = {level = 1}, event = {type = 'unlockeye', param = {1, 2}}},
[1201]={id = 1201, text = '解锁佣兵数量：1', Condition = {level = 15}, event = {type = 'unlock_cat_num'}},
[1402]={id = 1402, text = '喷射哥布灵卡片', Condition = {level = 40}},
[1404]={id = 1404, text = '邪骸士兵', Condition = {level = 50}},
[1406]={id = 1406, text = '恶魔女仆卡片', Condition = {level = 70}},
[1407]={id = 1407, text = '白素贞卡片', Condition = {level = 70}},
[1408]={id = 1408, text = '贝思波卡片', Condition = {level = 70}},
[1410]={id = 1410, text = '圣诞波利卡片', Condition = {level = 60}},
[1411]={id = 1411, text = '黄蛇卡片', Condition = {level = 60}},
[1412]={id = 1412, text = '刺猬虫卡片', Condition = {level = 40}},
[1413]={id = 1413, text = '卡浩卡片', Condition = {level = 60}},
[1414]={id = 1414, text = '蝎子卡片', Condition = {level = 40}},
[1415]={id = 1415, text = '狐仙卡片', Condition = {level = 60}},
[1416]={id = 1416, text = '海豹宝宝卡片', Condition = {level = 50}},
[1417]={id = 1417, text = '木乃伊犬卡片', Condition = {level = 50}},
[1418]={id = 1418, text = '库克雷卡片', Condition = {level = 60}},
[1419]={id = 1419, text = '森灵卡片', Condition = {level = 60}},
[1420]={id = 1420, text = '杰洛米卡片', Condition = {level = 60}},
[1421]={id = 1421, text = '螳螂卡片', Condition = {level = 60}},
[3001]={id = 3001, type = 2, text = 'NPC解锁可见', Condition = {quest = {270016}}, event = {type = 'SeeNpc', param = {4369}}},
[3002]={id = 3002, type = 2, text = 'NPC解锁可见', Condition = {quest = {99560009}}, event = {type = 'SeeNpc', param = {4352}}},
[3003]={id = 3003, type = 2, text = 'NPC解锁可见', Condition = {quest = {270029}}, event = {type = 'SeeNpc', param = {4405}}},
[3004]={id = 3004, type = 2, text = 'NPC解锁可见', Condition = {quest = {270116}}, event = {type = 'SeeNpc', param = {6077}}},
[3005]={id = 3005, type = 2, text = 'NPC解锁可见', Condition = {quest = {270116}}, event = {type = 'SeeNpc', param = {6236}}},
[3006]={id = 3006, type = 2, text = 'NPC解锁可见', Condition = {quest = {200090010}}, event = {type = 'SeeNpc', param = {6578}}},
[3007]={id = 3007, type = 2, text = '联动NPC', Condition = {quest = {390760001}}, event = {type = 'SeeNpc', param = {6782}}},
[3008]={id = 3008, type = 2, text = 'NPC解锁可见', Condition = {quest = {200370002}}, event = {type = 'SeeNpc', param = {6924}}},
[3009]={id = 3009, type = 2, text = 'NPC隐藏', Condition = {quest = {201140007}}, event = {type = 'HideNpc', param = {7151}}},
[3010]={id = 3010, type = 2, text = 'NPC解锁可见', Condition = {quest = {201230005}}, event = {type = 'SeeNpc', param = {7189}}},
[3011]={id = 3011, type = 2, text = 'NPC解锁可见', Condition = {quest = {201290001}}, event = {type = 'SeeNpc', param = {5542}}},
[3012]={id = 3012, type = 2, text = 'NPC隐藏', Condition = {quest = {201480001}}, event = {type = 'HideNpc', param = {5757}}},
[3013]={id = 3013, type = 2, text = 'NPC解锁可见', Condition = {quest = {201480001}}, event = {type = 'SeeNpc', param = {5771}}},
[3014]={id = 3014, type = 2, text = 'NPC解锁可见', Condition = {quest = {201780001}}, event = {type = 'SeeNpc', param = {4747}}},
[3015]={id = 3015, type = 2, text = 'NPC解锁可见', Condition = {quest = {201820001}}, event = {type = 'SeeNpc', param = {4748}}},
[4033]={id = 4033, text = '炼金术士的日记本', Condition = {manualgroup = {24}}},
[4034]={id = 4034, text = '坎卜斯的礼物', Condition = {manualgroup = {25}}},
[4035]={id = 4035, text = '腹语师之死', Condition = {manualgroup = {26}}},
[4036]={id = 4036, text = '魔灵娃娃的诅咒', Condition = {manualgroup = {27}}},
[4037]={id = 4037, text = '永恒的夏宫', Condition = {manualgroup = {28}}},
[4038]={id = 4038, text = '圣诞香包', Condition = {manualgroup = {29}}},
[4039]={id = 4039, text = '樱城的故事', Condition = {manualgroup = {30}}},
[4040]={id = 4040, text = '狐狸旧事', Condition = {manualgroup = {31}}},
[100000]={id = 100000, text = '10w~100w为海外字段', Condition = _EmptyTable},
[3000000]={id = 3000000, text = '3000000~4000000为活动字段', Condition = _EmptyTable},
----------
[54]={id = 54, type = 1, text = '完成后解锁强化精炼功能', Condition = {quest = {390750001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '强化精炼 已开放', Show = 1, Icon = {uiicon = 'refine'}},
----------
[71]={id = 71, type = 2, PanelID = 305, text = '完成后解锁初级附魔', Condition = {quest = {303100001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '初级附魔 已开放', Show = 1, Icon = {uiicon = 'daily'}},
----------
[72]={id = 72, type = 2, PanelID = 306, text = '完成后解锁中级附魔', Condition = {quest = {690010006}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '中级附魔 已开放', Show = 1, Icon = {uiicon = 'daily'}},
----------
[73]={id = 73, type = 2, PanelID = 307, text = '完成后解锁高级附魔', Condition = {quest = {690020006}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '高级附魔 已开放', Show = 1, Icon = {uiicon = 'daily'}},
----------
[74]={id = 74, type = 1, PanelID = 83, text = '可获得个人相册', Condition = {quest = {40002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '个人相册 已开放', Show = 1, Icon = {uiicon = 'PersonalAlbum'}, Enterhide = 1},
----------
[75]={id = 75, type = 3, text = '可习得技能·烹饪', Condition = {quest = {600930002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '习得技能·烹饪', Show = 1, Acc = 1, Icon = {uiicon = 'Skill'}},
----------
[76]={id = 76, type = 3, text = '冒险手册·料理图鉴开放', Condition = {quest = {600930002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁·料理图鉴', Show = 1, Acc = 1, Icon = {uiicon = 'RiskBook'}},
----------
[77]={id = 77, type = 3, text = '料理收纳盒', Condition = {quest = {600930002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '料理收纳盒 开启', Icon = _EmptyTable},
----------
[87]={id = 87, type = 3, text = '姜饼城玩法头饰入册', Condition = {quest = {340450001}}, event = {type = 'unlockmanual', param = {1, 45400, 47039, 45401, 45402, 45403, 45404, 45405}}, sysMsg = _EmptyTable, Tip = '', Acc = 1, Icon = _EmptyTable},
[88]={id = 88, text = '姜饼城微笑小姐入册', event = {type = 'unlockshop', param = {800, 71, 1, 0, 0}}},
[89]={id = 89, text = '成就头饰1入册', Condition = {level = 1}, event = {type = 'unlockmanual', param = {1, 561104, 561105, 561106, 561107, 561108, 561109, 561110, 561111, 561112, 561113, 561114, 561115, 145242}}},
[90]={id = 90, text = 'B格猫活动+神秘箱子+星座占卜的头饰入册', Condition = {level = 1}, event = {type = 'unlockmanual', param = {1, 48547, 48008, 45143, 47021, 45075, 48530, 45127, 45160, 45161, 45162, 45163, 45164, 45165, 45166, 45167, 45168, 45169, 45158, 45159, 145222, 145223, 145224, 145225, 145226, 145227, 145228, 145229, 145230, 145231, 145220, 145221}}},
[91]={id = 91, text = '艾尔帕兰玩法头饰补漏入册', Condition = {quest = {340440001}}, event = {type = 'unlockmanual', param = {1, 48569, 145251, 47026, 45248, 45249, 145250}}},
[92]={id = 92, text = '艾尔帕兰微笑小姐入册', Condition = {quest = {340440001}}, event = {type = 'unlockshop', param = {800, 61, 1, 0, 0}}},
[93]={id = 93, text = '月卡商城头饰1~6月', Condition = {level = 1}, event = {type = 'unlockshop', param = {950, 1, 1, 0, 0}}},
[94]={id = 94, text = '古城玩法头饰补漏入册', Condition = {quest = {340290001, 340300001}}, event = {type = 'unlockmanual', param = {1, 45190, 48542, 145207, 45208, 45209, 48563, 145104, 47011, 47017, 48564, 145090}}},
[180]={id = 180, text = '卡普拉', Condition = {level = 1}, event = {type = 'unlockmanual', param = {1, 45847, 45625, 47090, 48032, 51147}}},
[527]={id = 527, text = '天使魅影', Condition = {level = 200}, event = _EmptyTable},
[1101]={id = 1101, text = '下水道★魔物', Condition = {quest = {60030002}}, event = {type = 'unlockmanual', param = {6, 120009}}},
[1106]={id = 1106, text = '迷藏森林★魔物', Condition = {quest = {340060001}}, event = {type = 'unlockmanual', param = {6, 120014}}},
[1112]={id = 1112, text = '海底洞穴2F★魔物', Condition = {quest = {340100001}}, event = {type = 'unlockmanual', param = {6, 120017, 120026, 120028}}},
[1113]={id = 1113, text = '哥布灵森林★魔物', Condition = {quest = {340330001}}, event = {type = 'unlockmanual', param = {6, 120029, 120030, 120031, 120032, 120033}}},
[1115]={id = 1115, text = '蚂蚁秘穴★魔物', Condition = {quest = {340160001}}, event = {type = 'unlockmanual', param = {6, 120040}}},
[1116]={id = 1116, text = '斐扬洞穴★魔物', Condition = {quest = {340200001}}, event = {type = 'unlockmanual', param = {6, 120058, 120065}}},
[1117]={id = 1117, text = '古城大厅★魔物', Condition = {quest = {340300001}}, event = {type = 'unlockmanual', param = {6, 120093, 120094}}},
[1118]={id = 1118, text = '古城大厅玩法魔物', Condition = {quest = {340300001}}, event = {type = 'unlockmanual', param = {6, 30019, 30030, 30031, 30032, 17301}}},
[1119]={id = 1119, text = '钟楼★魔物', Condition = {quest = {340440001}}, event = {type = 'unlockmanual', param = {6, 120114, 120115}}},
[1120]={id = 1120, text = '玩具工厂★魔物', Condition = {quest = {340460001}}, event = {type = 'unlockmanual', param = {6, 120121, 120122}}},
[1501]={id = 1501, text = '遗迹·巫毒木吊死鬼', Condition = {quest = {340340001}}, event = {type = 'scenery', param = {101}}, Icon = {uiicon = 'photo'}},
[1503]={id = 1503, text = '遗迹·还算坚固的营地', Condition = {quest = {340260001}}, event = {type = 'scenery', param = {103}}, Icon = {uiicon = 'photo'}},
[1506]={id = 1506, text = '遗迹·山脉·猩红裂爪', Condition = {quest = {340260001}}, event = {type = 'scenery', param = {106}}, Icon = {uiicon = 'photo'}},
[1509]={id = 1509, text = '发现景点·古城遗迹', Condition = {quest = {340270001}}, event = {type = 'scenery', param = {109, 110, 114}}},
[1513]={id = 1513, text = '古城下水道遗迹', Condition = {quest = {340280001}}, event = {type = 'scenery', param = {115, 117}}},
[1522]={id = 1522, text = '古城墓地遗迹', Condition = {quest = {340370001}}, event = {type = 'scenery', param = {125}}},
[1523]={id = 1523, text = '古城骑士团遗迹', Condition = {quest = {340290001}}, event = {type = 'scenery', param = {112, 126, 127, 128, 129, 130, 131}}},
[1524]={id = 1524, text = '古城大厅遗迹', Condition = {quest = {340300001}}, event = {type = 'scenery', param = {107, 132, 135, 136, 138}}},
[1543]={id = 1543, text = '普隆德拉北部隐藏景点4个', Condition = {quest = {340420001}}, event = {type = 'scenery', param = {143, 144, 145, 146}}},
[1544]={id = 1544, text = '钟楼地下隐藏景点5个', Condition = {quest = {340440001}}, event = {type = 'scenery', param = {158, 159, 160, 161, 162}}},
[1554]={id = 1554, text = '玩具工厂2楼', Condition = {quest = {340460001}}, event = {type = 'scenery', param = {181, 182, 183, 184, 185, 186}}},
[1901]={id = 1901, text = '宠物冒险手册入册', Condition = {level = 1}, event = {type = 'unlockmanual', param = {19, 500010, 500020, 500030, 500040, 500050, 500060, 500070, 500080, 500090, 500100, 500110}}},
[4001]={id = 4001, text = '古城珍藏品', Condition = {quest = {340270001}}, event = {type = 'unlockmanual', param = {14, 27}}},
[4002]={id = 4002, text = '古城下水道珍藏品', Condition = {quest = {340280001}}, event = {type = 'unlockmanual', param = {14, 28}}},
[4003]={id = 4003, text = '古城地下墓地珍藏品', Condition = {quest = {340370001}}, event = {type = 'unlockmanual', param = {14, 37}}},
[4004]={id = 4004, text = '古城骑士团珍藏品', Condition = {quest = {340290001}}, event = {type = 'unlockmanual', param = {14, 29}}},
[4005]={id = 4005, text = '古城大厅珍藏品', Condition = {quest = {340300001}}, event = {type = 'unlockmanual', param = {14, 30}}},
[4006]={id = 4006, text = '钟楼珍藏品', Condition = {quest = {340440001}}, event = {type = 'unlockmanual', param = {14, 44, 45}}},
[4007]={id = 4007, text = '普隆德拉北部珍藏品', Condition = {quest = {340420001}}, event = {type = 'unlockmanual', param = {14, 42}}},
[4008]={id = 4008, text = 'GLC.A031号档案', Condition = {manualgroup = {1}}, event = _EmptyTable},
[4009]={id = 4009, text = 'GLC.X114号档案', Condition = {manualgroup = {2}}, event = _EmptyTable},
[4010]={id = 4010, text = 'GLC.E109号档案', Condition = {manualgroup = {3}}, event = _EmptyTable},
[4011]={id = 4011, text = '永恒之翼', Condition = {manualgroup = {4}}, event = _EmptyTable},
[4012]={id = 4012, text = 'GLC.A014号档案', Condition = {manualgroup = {5}}, event = _EmptyTable},
[4013]={id = 4013, text = 'GLC.X157号档案', Condition = {manualgroup = {6}}, event = _EmptyTable},
[4014]={id = 4014, text = 'GLC.X163号档案', Condition = {manualgroup = {7}}, event = _EmptyTable},
[4015]={id = 4015, text = 'GLC.X185号档案', Condition = {manualgroup = {8}}, event = _EmptyTable},
[4016]={id = 4016, text = '米莫斯的战袍', Condition = {manualgroup = {9}}, event = _EmptyTable},
[4017]={id = 4017, text = '无形箭', Condition = {manualgroup = {10}}, event = _EmptyTable},
[4018]={id = 4018, text = '生命魔剑', Condition = {manualgroup = {11}}, event = _EmptyTable},
[4019]={id = 4019, text = '命运纸牌', Condition = {manualgroup = {12}}, event = _EmptyTable},
[4020]={id = 4020, text = '钟楼异闻录·毁灭卷', Condition = {manualgroup = {13}}, event = _EmptyTable},
[4021]={id = 4021, text = '钟楼异闻录·噩梦卷', Condition = {manualgroup = {14}}, event = _EmptyTable},
[4022]={id = 4022, text = '时光匕首', Condition = {manualgroup = {15}}, event = _EmptyTable},
[4023]={id = 4023, text = '时间轮盘', Condition = {manualgroup = {16}}, event = _EmptyTable},
[4024]={id = 4024, text = '星界棱晶', Condition = {manualgroup = {17}}, event = _EmptyTable},
[4025]={id = 4025, text = '钟楼异闻录·丧钟卷', Condition = {manualgroup = {18}}, event = _EmptyTable},
[4026]={id = 4026, text = '钟楼异闻录·魅影卷', Condition = {manualgroup = {19}}, event = _EmptyTable},
[4027]={id = 4027, text = '森灵之心', Condition = {manualgroup = {20}}, event = _EmptyTable},
[4028]={id = 4028, text = '时钟守卫者勋章', Condition = {manualgroup = {21}}, event = _EmptyTable},
[4029]={id = 4029, text = '灵魂静谧', Condition = {manualgroup = {22}}, event = _EmptyTable},
[4030]={id = 4030, text = '修密兹的王冠', Condition = _EmptyTable, event = {type = 'unlockmanual', param = {14, 53535}}},
[4031]={id = 4031, text = '水晶残片', Condition = _EmptyTable, event = {type = 'unlockmanual', param = {14, 53536}}},
[4032]={id = 4032, text = '圣诞树的铃铛', Condition = {manualgroup = {23}}, event = _EmptyTable},
----------
[95]={id = 95, type = 3, text = '古城微笑小姐入册', Condition = {quest = {340270001, 340280001, 340370001, 340290001, 340300001}}, event = {type = 'unlockshop', param = {800, 51, 1, 0, 0}}, sysMsg = _EmptyTable, Tip = '微笑小姐·追加新的头饰', Acc = 1, Icon = _EmptyTable},
[96]={id = 96, text = '依斯鲁得微笑小姐入册', Condition = {quest = {340080001}}, event = {type = 'unlockshop', param = {800, 12, 1, 0, 0}}},
[97]={id = 97, text = '斐扬微笑小姐入册', Condition = {quest = {340190001}}, event = {type = 'unlockshop', param = {800, 41, 1, 0, 0}}},
[98]={id = 98, text = '梦罗克微笑小姐入册', Condition = {quest = {340160001}}, event = {type = 'unlockshop', param = {800, 31, 1, 0, 45}}},
[99]={id = 99, text = '吉芬微笑小姐入册', Condition = {quest = {340130001}}, event = {type = 'unlockshop', param = {800, 21, 1, 0, 0}}},
[100]={id = 100, text = '普隆德拉微笑小姐入册', Condition = {level = 1}, event = {type = 'unlockshop', param = {800, 11, 1, 0, 0}}},
----------
[101]={id = 101, type = 3, text = '默认魔物', Condition = {quest = {60030002}}, event = {type = 'unlockmanual', param = {9, 1, 2, 1001}}, sysMsg = _EmptyTable, Tip = '冒险手册·默认魔物', Acc = 1, Icon = _EmptyTable},
----------
[104]={id = 104, type = 3, text = '冒险手册·追加下水道新内容', Condition = {quest = {340040001}}, event = {type = 'unlockmanual', param = {9, 3, 4}}, sysMsg = _EmptyTable, Tip = '冒险手册·追加新的内容', Show = 1, Acc = 1, Icon = {uiicon = 'RiskBook'}},
[105]={id = 105, text = '冒险手册·追加西门新内容', Condition = {quest = {340050001}}, event = {type = 'unlockmanual', param = {9, 5}}},
[106]={id = 106, text = '冒险手册·追加迷藏森林新内容', Condition = {quest = {340060001}}, event = {type = 'unlockmanual', param = {9, 6}}},
[108]={id = 108, text = '冒险手册·追加沉没之船新内容', Condition = {quest = {340080001}}, event = {type = 'unlockmanual', param = {9, 7, 8, 31}}},
[109]={id = 109, text = '冒险手册·追加幽灵船新内容', Condition = {quest = {340090001}}, event = {type = 'unlockmanual', param = {9, 9}}},
[110]={id = 110, text = '冒险手册·追加海底洞穴新内容', Condition = {quest = {340100001}}, event = {type = 'unlockmanual', param = {9, 10}}},
[114]={id = 114, text = '冒险手册·追加妙勒尼山脉新内容', Condition = {quest = {340140001}}, event = {type = 'unlockmanual', param = {9, 13, 14}}},
[115]={id = 115, text = '冒险手册·追加蚂蚁秘穴新内容', Condition = {quest = {340160001}}, event = {type = 'unlockmanual', param = {9, 16, 15, 38}}},
[117]={id = 117, text = '冒险手册·追加金字塔新内容', Condition = {quest = {340170001}}, event = {type = 'unlockmanual', param = {9, 17}}},
[119]={id = 119, text = '冒险手册·追加斐扬南部新内容', Condition = {quest = {340190001}}, event = {type = 'unlockmanual', param = {9, 18, 19}}},
[120]={id = 120, text = '冒险手册·追加斐扬洞窟新内容', Condition = {quest = {340200001}}, event = {type = 'unlockmanual', param = {9, 20}}},
[123]={id = 123, text = '冒险手册·追加兽人村落新内容', Condition = {quest = {340230001}}, event = {type = 'unlockmanual', param = {9, 23}}},
[124]={id = 124, text = '冒险手册·追加吉芬塔地下新内容', Condition = {quest = {340240001}}, event = {type = 'unlockmanual', param = {9, 24}}},
[125]={id = 125, text = '冒险手册·追加兽人地下洞窟新内容', Condition = {quest = {340250001}}, event = {type = 'unlockmanual', param = {9, 25}}},
[126]={id = 126, text = '冒险手册·追加龙区新内容', Condition = {quest = {340260001}}, event = {type = 'unlockmanual', param = {9, 26}}},
[127]={id = 127, text = '冒险手册·追加克雷斯特汉姆新内容', Condition = {quest = {340270001}}, event = {type = 'unlockmanual', param = {9, 27}}},
[128]={id = 128, text = '冒险手册·追加古城下水道新内容', Condition = {quest = {340280001}}, event = {type = 'unlockmanual', param = {9, 28}}},
[129]={id = 129, text = '冒险手册·追加古城骑士团新内容', Condition = {quest = {340290001}}, event = {type = 'unlockmanual', param = {9, 29}}},
[130]={id = 130, text = '冒险手册·追加古城大厅新内容', Condition = {quest = {340300001}}, event = {type = 'unlockmanual', param = {9, 30}}},
[131]={id = 131, text = '冒险手册·追加斐扬树林新内容', Condition = {quest = {340320001}}, event = {type = 'unlockmanual', param = {9, 32}}},
[132]={id = 132, text = '冒险手册·追加哥布灵森林新内容', Condition = {quest = {340330001}}, event = {type = 'unlockmanual', param = {9, 33}}},
[134]={id = 134, text = '冒险手册·追加苏克拉特沙漠新内容', Condition = {quest = {340350001}}, event = {type = 'unlockmanual', param = {9, 35}}},
[135]={id = 135, text = '冒险手册·追加克特森林新内容', Condition = {quest = {340340001}}, event = {type = 'unlockmanual', param = {9, 34}}},
[137]={id = 137, text = '冒险手册·追加古城地下墓地新内容', Condition = {quest = {340370001}}, event = {type = 'unlockmanual', param = {9, 37}}},
[138]={id = 138, text = '冒险手册·追加普隆德拉北部新内容', Condition = {quest = {340420001}}, event = {type = 'unlockmanual', param = {9, 42}}},
[139]={id = 139, text = '冒险手册·追加钟楼新内容', Condition = {quest = {340440001}}, event = {type = 'unlockmanual', param = {9, 43, 44, 45, 46}}},
[140]={id = 140, text = '冒险手册·追加姜饼城新内容', Condition = {quest = {340450001}}, event = {type = 'unlockmanual', param = {9, 48}}, Icon = _EmptyTable},
[141]={id = 141, text = '冒险手册·追加玩具工厂新内容', Condition = {quest = {340460001}}, event = {type = 'unlockmanual', param = {9, 49, 50}}, Icon = _EmptyTable},
[142]={id = 142, text = '冒险手册·追加朱诺新内容', Condition = {quest = {396420001}}, event = {type = 'unlockmanual', param = {9, 63}}},
[143]={id = 143, text = '冒险手册·追加国界检查站新内容', Condition = {quest = {396430001}}, event = {type = 'unlockmanual', param = {9, 64}}},
[144]={id = 144, text = '冒险手册·追加艾因布洛克原野新内容', Condition = {quest = {396440001}}, event = {type = 'unlockmanual', param = {9, 65}}},
[145]={id = 145, text = '冒险手册·追加熔岩洞窟新内容', Condition = {quest = {396450001}}, event = {type = 'unlockmanual', param = {9, 66, 67, 68}}},
----------
[107]={id = 107, type = 3, text = '依斯鲁得', Condition = {quest = {340080001}}, event = {type = 'unlockmanual', param = {9, 7}}, sysMsg = _EmptyTable, Tip = '冒险手册·追加新的内容', Acc = 1, Icon = _EmptyTable},
[111]={id = 111, text = '海底洞穴1F', Condition = {quest = {340100001}}, event = {type = 'unlockmanual', param = {9, 11}}, Icon = {uiicon = 'RiskBook'}},
[112]={id = 112, text = '海底洞穴2F', Condition = {quest = {340100001}}, event = {type = 'unlockmanual', param = {9, 12}}, Icon = {uiicon = 'RiskBook'}},
[113]={id = 113, text = '吉芬', Condition = {quest = {340130001}}, event = {type = 'unlockmanual', param = {9, 13}}, Icon = {uiicon = 'RiskBook'}},
[116]={id = 116, text = '梦罗克魔物', Condition = {quest = {340160001}}, event = {type = 'unlockmanual', param = {9, 16}}, Icon = {uiicon = 'RiskBook'}},
[118]={id = 118, text = '斐扬魔物', Condition = {quest = {340190001}}, event = {type = 'unlockmanual', param = {9, 18}}, Icon = {uiicon = 'RiskBook'}},
[121]={id = 121, text = '金字塔上层', Condition = {quest = {340170001}}, event = {type = 'unlockmanual', param = {9, 21}}, Icon = {uiicon = 'RiskBook'}},
[122]={id = 122, text = '斐扬洞窟2F', Condition = {quest = {340200001}}, event = {type = 'unlockmanual', param = {9, 22}}, Icon = {uiicon = 'RiskBook'}},
[146]={id = 146, text = '朱诺微笑小姐入册', Condition = {quest = {396420001}}, event = {type = 'unlockshop', param = {800, 91, 1, 0, 0}}},
----------
[202]={id = 202, type = 3, text = '新的卡片', Condition = {quest = {340050001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '冒险手册·追加新的卡片', Acc = 1, Icon = {uiicon = 'RiskBook'}},
[203]={id = 203, Condition = {quest = {340060001}}},
[204]={id = 204, Condition = {quest = {340080001}}},
[205]={id = 205, Condition = {quest = {340100001}}},
[206]={id = 206, Condition = {quest = {340130001}}},
[207]={id = 207, Condition = {quest = {340140001}}},
[208]={id = 208, Condition = {quest = {340160001}}},
[209]={id = 209, Condition = {quest = {340170001}}},
[210]={id = 210, Condition = {quest = {340190001}}},
[214]={id = 214, Condition = {quest = {340330001}}},
[216]={id = 216, Condition = {quest = {340320001}}},
[217]={id = 217, Condition = {quest = {340350001}}},
[218]={id = 218, Condition = {quest = {340200001}}},
[219]={id = 219, Condition = {quest = {340230001}}},
[220]={id = 220, Condition = {quest = {340250001}}},
[221]={id = 221, Condition = {quest = {340340001}}},
[222]={id = 222, Condition = {quest = {340260001}}},
----------
[223]={id = 223, type = 3, text = '完成后料理协会开放食材购买', Condition = {title = {1003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '料理协会·材料购买开放', Show = 1, Acc = 1, Icon = {uiicon = 'Shopping'}},
----------
[224]={id = 224, type = 3, text = '追加·新的宠物捕获道具', Condition = {title = {1003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物商店·追加新的捕获道具', Show = 1, Acc = 1, Icon = {uiicon = 'Shopping'}},
[225]={id = 225, Condition = {title = {1004}}},
[226]={id = 226, Condition = {title = {1005}}},
[227]={id = 227, Condition = {title = {1006}}},
----------
[301]={id = 301, type = 3, text = '发现景点·冒险者工会', Condition = {quest = {40002}}, event = {type = 'scenery', param = {1}}, sysMsg = _EmptyTable, Tip = '发现景点·%s', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
[302]={id = 302, text = '发现景点·普隆德拉大教堂', event = {type = 'scenery', param = {2}}},
[303]={id = 303, text = '发现景点·普-伊跨海大桥', Condition = {quest = {10131}}, event = {type = 'scenery', param = {3}}},
[304]={id = 304, text = '发现景点·波利气球营地', Condition = {quest = {10450001}}, event = {type = 'scenery', param = {4}}},
[305]={id = 305, text = '发现景点·旅行者营地', event = {type = 'scenery', param = {5}}},
[306]={id = 306, text = '发现景点·曾经的办公室', Condition = {quest = {80009}}, event = {type = 'scenery', param = {6}}},
[307]={id = 307, text = '发现景点·虹色的普勒花园', Condition = {quest = {99150001}}, event = {type = 'scenery', param = {7}}},
[308]={id = 308, text = '发现景点·贤者之间', Condition = {quest = {60010}}, event = {type = 'scenery', param = {8}}},
[309]={id = 309, text = '发现景点·某位骑士的劲敌', Condition = {quest = {99150011}}, event = {type = 'scenery', param = {9}}},
[310]={id = 310, text = '发现景点·下水道入口', Condition = {quest = {60009}}, event = {type = 'scenery', param = {10}}},
[313]={id = 313, text = '发现景点·森林深处的吊桥', Condition = {quest = {99150031}}, event = {type = 'scenery', param = {13}}},
[314]={id = 314, text = '发现景点·香槟蓝集市', Condition = {quest = {70002}}, event = {type = 'scenery', param = {14}}},
[315]={id = 315, text = '发现景点·飞空艇', Condition = {quest = {70004}}, event = {type = 'scenery', param = {15}}},
[316]={id = 316, text = '发现景点·古之勇者', Condition = {quest = {99150151}}, event = {type = 'scenery', param = {16}}},
[317]={id = 317, text = '发现景点·剑士公会', Condition = {quest = {70009}}, event = {type = 'scenery', param = {17}}},
[318]={id = 318, text = '发现景点·利维亚桑号', Condition = {quest = {70012}}, event = {type = 'scenery', param = {18}}},
[319]={id = 319, text = '发现景点·船长室(投降者）', Condition = {quest = {90019}}, event = {type = 'scenery', param = {19}}},
[320]={id = 320, text = '发现景点·直到投降都没开过火', Condition = {quest = {90011}}, event = {type = 'scenery', param = {20}}},
[321]={id = 321, text = '发现景点·大小姐的房间', Condition = {quest = {99150041}}, event = {type = 'scenery', param = {21}}},
[322]={id = 322, text = '发现景点·海盗船长室', Condition = {quest = {99150051}}, event = {type = 'scenery', param = {22}}},
[324]={id = 324, text = '发现景点·海底神殿入口', Condition = {quest = {100001}}, event = {type = 'scenery', param = {24}}},
[325]={id = 325, text = '发现景点·海神像', Condition = {quest = {110002}}, event = {type = 'scenery', param = {25}}},
[326]={id = 326, text = '发现景点·虚假的藏宝库', Condition = {quest = {110015}}, event = {type = 'scenery', param = {26}}},
[327]={id = 327, text = '发现景点·海妖的庭院', Condition = {quest = {99150061}}, event = {type = 'scenery', param = {27}}},
[329]={id = 329, text = '发现景点·亚德兰蒂斯入口', Condition = {quest = {110017}}, event = {type = 'scenery', param = {29}}},
[331]={id = 331, text = '黑曜石方尖碑（伪）', Condition = {quest = {99150071}}, event = {type = 'scenery', param = {31}}},
[332]={id = 332, text = '黑曜石方尖碑', Condition = {quest = {99150071}}, event = {type = 'scenery', param = {32}}},
[335]={id = 335, text = '发现景点·魔法门', Condition = {quest = {130001}}, event = {type = 'scenery', param = {35}}},
[336]={id = 336, text = '发现景点·吉芬塔', Condition = {quest = {130001}}, event = {type = 'scenery', param = {36}}},
[337]={id = 337, text = '发现景点·魔法喷泉', Condition = {quest = {130001}}, event = {type = 'scenery', param = {37}}},
[338]={id = 338, text = '发现景点·梦境摩天轮', Condition = {quest = {350400001}}, event = {type = 'scenery', param = {38}}},
[339]={id = 339, text = '发现景点·邪恶营地', Condition = {quest = {130004}}, event = {type = 'scenery', param = {39}}},
[340]={id = 340, text = '发现景点·妙勒尼大瀑布', Condition = {quest = {140116}}, event = {type = 'scenery', param = {40}}},
[342]={id = 342, text = '发现景点·飞空艇残骸', Condition = {quest = {140016}}, event = {type = 'scenery', param = {42}}},
[343]={id = 343, text = '发现景点·迷之小屋', Condition = {quest = {99150081}}, event = {type = 'scenery', param = {43}}},
[347]={id = 347, text = '发现景点·梦罗克宫殿', Condition = {quest = {140012}}, event = {type = 'scenery', param = {47}}},
[348]={id = 348, text = '发现景点·古代守墓人遗迹', Condition = {quest = {99150091}}, event = {type = 'scenery', param = {48}}},
[350]={id = 350, text = '发现景点·金字塔迷宫', Condition = {quest = {160002}}, event = {type = 'scenery', param = {50}}},
[351]={id = 351, text = '发现景点·刺客公会', Condition = {quest = {160012}}, event = {type = 'scenery', param = {51}}},
[352]={id = 352, text = '发现景点·法老王的机关', Condition = {quest = {170001}}, event = {type = 'scenery', param = {52}}},
[353]={id = 353, text = '发现景点·祭祀祭坛', Condition = {quest = {99150101}}, event = {type = 'scenery', param = {53}}},
[354]={id = 354, text = '发现景点·王者之像', Condition = {quest = {99150021}}, event = {type = 'scenery', param = {54}}},
[356]={id = 356, text = '发现景点·爷爷的海', Condition = {quest = {99150111}}, event = {type = 'scenery', param = {56}}},
[358]={id = 358, text = '发现景点·斐扬瀑布', Condition = {quest = {320003}}, event = {type = 'scenery', param = {58}}},
[359]={id = 359, text = '发现景点·消失的村庄', Condition = {quest = {320005}}, event = {type = 'scenery', param = {59}}},
[362]={id = 362, text = '发现景点·南瓜田', Condition = {quest = {180011}}, event = {type = 'scenery', param = {62}}},
[363]={id = 363, text = '发现景点·竹林水车', Condition = {quest = {180012}}, event = {type = 'scenery', param = {63}}},
[364]={id = 364, text = '发现景点·绵羊帽子村', Condition = {quest = {99150121}}, event = {type = 'scenery', param = {64}}},
[365]={id = 365, text = '发现景点·弓箭手公会', Condition = {quest = {180013}}, event = {type = 'scenery', param = {65}}},
[366]={id = 366, text = '发现景点·猎人公会', Condition = {quest = {180014}}, event = {type = 'scenery', param = {66}}},
[368]={id = 368, text = '发现景点·靶场', Condition = {quest = {180005}}, event = {type = 'scenery', param = {68}}},
[369]={id = 369, text = '发现景点·爷爷的家', Condition = {quest = {99150131}}, event = {type = 'scenery', param = {69}}},
[371]={id = 371, text = '发现景点·希望绿洲', Condition = {quest = {340350001}}, event = {type = 'scenery', param = {71}}},
[372]={id = 372, text = '发现景点·维因斯特街道', Condition = {quest = {340350001}}, event = {type = 'scenery', param = {72}}},
[374]={id = 374, text = '发现景点·永生之间', Condition = {quest = {99150141}}, event = {type = 'scenery', param = {74}}},
[379]={id = 379, text = '发现景点·被焚毁的戒灵村', Condition = {quest = {99150181}}, event = {type = 'scenery', param = {79}}},
[382]={id = 382, text = '发现景点·古代王的终末之所', Condition = {quest = {99150191}}, event = {type = 'scenery', param = {82}}},
[389]={id = 389, text = '发现景点·凛冬墓地', Condition = {quest = {99150202}}, event = {type = 'scenery', param = {89}}},
[391]={id = 391, text = '发现景点·酋长大厅', Condition = {quest = {230014}}, event = {type = 'scenery', param = {91}}},
[392]={id = 392, text = '发现景点·处决场', Condition = {quest = {230011}}, event = {type = 'scenery', param = {92}}},
[393]={id = 393, text = '发现景点·巫毒山寨', Condition = {quest = {230001}}, event = {type = 'scenery', param = {93}}},
[397]={id = 397, text = '发现景点·先知陵寝入口', Condition = {quest = {340012}}, event = {type = 'scenery', param = {97}}},
[398]={id = 398, text = '发现景点·犬神祭坛', Condition = {quest = {350790010}}, event = {type = 'scenery', param = {98}}},
[399]={id = 399, text = '发现景点·先知遗迹', Condition = {quest = {340014}}, event = {type = 'scenery', param = {99}}},
----------
[311]={id = 311, type = 3, text = '遗迹·渔夫小站', Condition = {quest = {60008}}, event = {type = 'scenery', param = {11}}, sysMsg = _EmptyTable, Tip = '发现景点·%s', Acc = 1, Icon = {uiicon = 'photo'}},
[312]={id = 312, text = '遗迹·魔女之石', Condition = {quest = {340060001}}, event = {type = 'scenery', param = {12}}},
[323]={id = 323, text = '遗迹·最后的晚餐', Condition = {quest = {340090001}}, event = {type = 'scenery', param = {23}}},
[328]={id = 328, text = '遗迹·海生树', Condition = {quest = {340100001}}, event = {type = 'scenery', param = {28}}},
[330]={id = 330, text = '遗迹·沉没的企业号', Condition = {quest = {340100001}}, event = {type = 'scenery', param = {30}}},
[333]={id = 333, text = '遗迹·深海神殿', Condition = {quest = {340100001}}, event = {type = 'scenery', param = {33}}},
[334]={id = 334, text = '遗迹·海底神殿遗迹', Condition = {quest = {340100001}}, event = {type = 'scenery', param = {34}}},
[341]={id = 341, text = '遗迹·废弃矿坑', Condition = {quest = {340140001}}, event = {type = 'scenery', param = {41}}},
[344]={id = 344, text = '遗迹·观察者灯塔', Condition = {quest = {340140001}}, event = {type = 'scenery', param = {44}}},
[345]={id = 345, text = '遗迹·虫王的陵寝', Condition = {quest = {340160001}}, event = {type = 'scenery', param = {45}}},
[346]={id = 346, text = '遗迹·隐藏的地下遗迹', Condition = {quest = {340160001}}, event = {type = 'scenery', param = {46}}},
[349]={id = 349, text = '遗迹·古代港口', Condition = {quest = {342110001}}, event = {type = 'scenery', param = {49}}},
[355]={id = 355, text = '广场喷泉', Condition = {quest = {40100}}, event = {type = 'scenery', param = {55}}},
[357]={id = 357, text = '遗迹·古祠堂遗迹', Condition = {quest = {340320001}}, event = {type = 'scenery', param = {57}}},
[360]={id = 360, text = '遗迹·角斗场', Condition = {quest = {340320001}}, event = {type = 'scenery', param = {60}}},
[361]={id = 361, text = '遗迹·后山古道场', Condition = {quest = {340190001}}, event = {type = 'scenery', param = {61}}},
[367]={id = 367, text = '遗迹·大宫殿', Condition = {quest = {340190001}}, event = {type = 'scenery', param = {67}}},
[370]={id = 370, text = '遗迹·蚁地狱！', Condition = {quest = {340350001}}, event = {type = 'scenery', param = {70}}},
[373]={id = 373, text = '遗迹·崩塌的神殿遗迹', Condition = {quest = {340350001}}, event = {type = 'scenery', param = {73}}},
[375]={id = 375, text = '遗迹·太阳神王座', Condition = {quest = {340170001}}, event = {type = 'scenery', param = {75}}},
[376]={id = 376, text = '遗迹·守护者', Condition = {quest = {340170001}}, event = {type = 'scenery', param = {76}}},
[377]={id = 377, text = '遗迹·幻梦潭', Condition = {quest = {340200001}}, event = {type = 'scenery', param = {77}}},
[378]={id = 378, text = '遗迹·往生之树', Condition = {quest = {340200001}}, event = {type = 'scenery', param = {78}}},
[380]={id = 380, text = '遗迹·青麟门', Condition = {quest = {340200001}}, event = {type = 'scenery', param = {80}}},
[381]={id = 381, text = '遗迹·祸', Condition = {quest = {340200001}}, event = {type = 'scenery', param = {81}}},
[383]={id = 383, text = '遗迹·孽', Condition = {quest = {340200001}}, event = {type = 'scenery', param = {83}}},
[384]={id = 384, text = '遗迹·凶', Condition = {quest = {340200001}}, event = {type = 'scenery', param = {84}}},
[385]={id = 385, text = '遗迹·魍魉', Condition = {quest = {340200001}}, event = {type = 'scenery', param = {85}}},
[386]={id = 386, text = '遗迹·敏特拉奇水晶塔', Condition = {quest = {340130001}}, event = {type = 'scenery', param = {86}}},
[387]={id = 387, text = '遗迹·世袭伯爵的山庄', Condition = {quest = {340130001}}, event = {type = 'scenery', param = {87}}},
[388]={id = 388, text = '遗迹·“___”长眠于此', Condition = {quest = {340130001}}, event = {type = 'scenery', param = {88}}},
[390]={id = 390, text = '遗迹·被玷污的圣堂', Condition = {quest = {340130001}}, event = {type = 'scenery', param = {90}}},
[394]={id = 394, text = '遗迹·枯骨山堆', Condition = {quest = {340250001}}, event = {type = 'scenery', param = {94}}},
[395]={id = 395, text = '遗迹·死斗洞窟', Condition = {quest = {340250001}}, event = {type = 'scenery', param = {95}}},
[396]={id = 396, text = '遗迹·废坑', Condition = {quest = {340250001}}, event = {type = 'scenery', param = {96}}},
[400]={id = 400, text = '遗迹·克特大瀑布', Condition = {quest = {340340001}}, event = {type = 'scenery', param = {100}}},
----------
[401]={id = 401, type = 3, text = '默认打开', Condition = {level = 1}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '道场已开启', Icon = {uiicon = 'photo'}},
----------
[402]={id = 402, type = 3, text = '追加·新的道场', Condition = {level = 201}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '2号道场已开启', Show = 1, Icon = {uiicon = 'Skill'}},
----------
[403]={id = 403, type = 3, text = '追加·新的道场', Condition = {level = 201}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '3号道场已开启', Show = 1, Icon = {uiicon = 'Skill'}},
----------
[404]={id = 404, type = 3, text = '追加·新的道场', Condition = {level = 201}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '4号道场已开启', Show = 1, Icon = {uiicon = 'Skill'}},
----------
[405]={id = 405, type = 3, text = '追加·新的道场', Condition = {level = 201}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '5号道场已开启', Show = 1, Icon = {uiicon = 'Skill'}},
----------
[450]={id = 450, type = 3, text = '巅峰开放', Condition = {quest = {395020001}}, event = {type = 'addjoblv', param = {3}}, sysMsg = {id = 3434}, Tip = '职业等级突破上限', Show = 1, Icon = {uiicon = 'Skill'}},
----------
[501]={id = 501, type = 3, text = '首都微笑小姐·追加变身树叶', Condition = {quest = {350570001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '首都微笑小姐·追加变身树叶', Show = 1, Acc = 1, Icon = {itemicon = 'item_45180'}},
----------
[502]={id = 502, type = 3, text = '首都微笑小姐·追加兔耳发圈[1]', Condition = {quest = {350590001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '首都微笑小姐·追加兔耳发圈[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45079'}},
----------
[503]={id = 503, type = 3, text = '吉芬微笑小姐·追加圣职之帽', Condition = {quest = {99170520}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加圣职之帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45081'}},
----------
[504]={id = 504, type = 3, text = '吉芬微笑小姐·追加光环[1]', Condition = {quest = {350620001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '吉芬微笑小姐·追加光环[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45080'}},
----------
[505]={id = 505, type = 3, text = '梦罗克微笑小姐·追加红晕', Condition = {quest = {350660001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '梦罗克微笑小姐·追加红晕', Show = 1, Acc = 1, Icon = {itemicon = 'item_48533'}},
----------
[506]={id = 506, type = 3, text = '首都微笑小姐·追加花发圈', Condition = {quest = {350580001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '首都微笑小姐·追加花发圈', Show = 1, Acc = 1, Icon = {itemicon = 'item_45078'}},
----------
[508]={id = 508, type = 3, text = '梦罗克微笑小姐·追加沙漠王子头巾[1]', Condition = {quest = {350680001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '梦罗克微笑小姐·追加沙漠王子头巾[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45170'}},
----------
[509]={id = 509, type = 3, text = '吉芬微笑小姐·追加魔法帽', Condition = {quest = {99170220}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加魔法帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45107'}},
----------
[510]={id = 510, type = 3, text = '吉芬微笑小姐·追加花叶', Condition = {quest = {390020001}}, event = _EmptyTable, sysMsg = {id = 797}, Tip = '吉芬微笑小姐·追加花叶', Show = 1, Acc = 1, Icon = {itemicon = 'item_48557'}},
----------
[511]={id = 511, type = 3, text = '吉芬微笑小姐·追加侦探之帽[1]', Condition = {quest = {350600001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '吉芬微笑小姐·追加侦探之帽[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45116'}},
----------
[512]={id = 512, type = 3, text = '吉芬微笑小姐·追加金属头盔', Condition = {quest = {99170120}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加金属头盔', Show = 1, Acc = 1, Icon = {itemicon = 'item_45097'}},
----------
[513]={id = 513, type = 3, text = '吉芬微笑小姐·追加时髦眼罩', Condition = {quest = {99170320}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加时髦眼罩', Show = 1, Acc = 1, Icon = {itemicon = 'item_48505'}},
----------
[514]={id = 514, type = 3, text = '吉芬微笑小姐·追加羽毛帽', Condition = {quest = {99170420}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加羽毛帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45029'}},
----------
[515]={id = 515, type = 3, text = '吉芬微笑小姐·追加草叶', Condition = {quest = {99610001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加草叶', Show = 1, Acc = 1, Icon = {itemicon = 'item_48534'}},
----------
[516]={id = 516, type = 3, text = '吉芬微笑小姐·追加猫耳贝雷帽[1]', Condition = {quest = {390040005}}, event = _EmptyTable, sysMsg = {id = 797}, Tip = '吉芬微笑小姐·追加猫耳贝雷帽[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45146'}},
----------
[517]={id = 517, type = 3, text = '吉芬微笑小姐·追加冒险者背包', Condition = {quest = {390060006}}, event = _EmptyTable, sysMsg = {id = 797}, Tip = '吉芬微笑小姐·追加冒险者背包', Show = 1, Acc = 1, Icon = {itemicon = 'item_47002'}},
----------
[518]={id = 518, type = 3, text = '吉芬微笑小姐·追加巧克力甜甜圈', Condition = {quest = {99650002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加巧克力甜甜圈', Show = 1, Acc = 1, Icon = {itemicon = 'item_45245'}},
----------
[519]={id = 519, type = 3, text = '吉芬微笑小姐·追加金色信仰', Condition = {quest = {99650001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加金色信仰', Show = 1, Acc = 1, Icon = {itemicon = 'item_45246'}},
----------
[520]={id = 520, type = 3, text = '吉芬微笑小姐·追加耳罩', Condition = {quest = {350610001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '吉芬微笑小姐·追加耳罩', Show = 1, Acc = 1, Icon = {itemicon = 'item_45181'}},
----------
[521]={id = 521, type = 3, text = '吉芬微笑小姐·追加小恶魔气球', Condition = {quest = {350640001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '吉芬微笑小姐·追加小恶魔气球', Show = 1, Acc = 1, Icon = {itemicon = 'item_47008'}},
----------
[522]={id = 522, type = 3, text = '吉芬微笑小姐·追加哥夫内的头具[1]', Condition = {quest = {300101310, 99650003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加哥夫内的头具[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45122'}},
----------
[523]={id = 523, type = 3, text = '吉芬微笑小姐·追加摩菲斯的头巾[1]', Condition = {quest = {300104310}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加摩菲斯的头巾[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45120'}},
----------
[524]={id = 524, type = 3, text = '吉芬微笑小姐·追加魔法师帽[1]', Condition = {quest = {300102310}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加魔法师帽[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45172'}},
----------
[525]={id = 525, type = 3, text = '吉芬微笑小姐·追加黄色驾驶员头带[1]', Condition = {quest = {600340003, 12210001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '吉芬微笑小姐·追加黄色驾驶员头带[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45144'}},
----------
[526]={id = 526, type = 3, text = '吉芬微笑小姐·追加眼镜', Condition = {quest = {350630001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '吉芬微笑小姐·追加眼镜', Show = 1, Acc = 1, Icon = {itemicon = 'item_48559'}},
----------
[528]={id = 528, type = 3, text = '斐扬微笑小姐·追加红蝶丝带[1]', Condition = {quest = {350690001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '斐扬微笑小姐·追加红蝶丝带[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45125'}},
----------
[530]={id = 530, type = 3, text = '斐扬微笑小姐·追加贝雷帽', Condition = {quest = {350710001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '斐扬微笑小姐·追加贝雷帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45128'}},
----------
[531]={id = 531, type = 3, text = '斐扬微笑小姐·追加丸子头饰[1]', Condition = {quest = {300105310, 99650004}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '斐扬微笑小姐·追加丸子头饰[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45084'}},
----------
[532]={id = 532, type = 3, text = '斐扬微笑小姐·追加铁钉口罩', Condition = {quest = {300103310, 12250001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '斐扬微笑小姐·追加铁钉口罩', Show = 1, Acc = 1, Icon = {itemicon = 'item_48548'}},
----------
[533]={id = 533, type = 3, text = '斐扬微笑小姐·追加狐狸假面', Condition = {quest = {350720001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '斐扬微笑小姐·追加狐狸假面', Show = 1, Acc = 1, Icon = {itemicon = 'item_48539'}},
----------
[534]={id = 534, type = 3, text = '梦罗克微笑小姐·追加银色冕状头饰', Condition = {quest = {350650001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '梦罗克微笑小姐·追加银色冕状头饰', Show = 1, Acc = 1, Icon = {itemicon = 'item_45126'}},
----------
[535]={id = 535, type = 3, text = '古城微笑小姐·追加小树椿帽', Condition = {quest = {99560105}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '古城微笑小姐·追加小树椿帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45204'}},
----------
[536]={id = 536, type = 3, text = '古城微笑小姐·追加符文冠冕[1]', Condition = {quest = {270065}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '古城微笑小姐·追加符文冠冕[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45154'}},
----------
[537]={id = 537, type = 3, text = '古城微笑小姐·追加额掩[1]', Condition = {quest = {270111}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '古城微笑小姐·追加额掩[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45129'}},
----------
[538]={id = 538, type = 3, text = '古城微笑小姐·追加小恶魔尾巴', Condition = {quest = {270083}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '古城微笑小姐·追加小恶魔尾巴', Show = 1, Acc = 1, Icon = {itemicon = 'item_48006'}},
----------
[539]={id = 539, type = 3, text = '古城微笑小姐·追加女仆发圈[1]', Condition = {quest = {99590003}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '古城微笑小姐·追加女仆发圈[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45186'}},
----------
[540]={id = 540, type = 3, text = '古城微笑小姐·追加死神头巾[1]', Condition = {quest = {99590024}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '古城微笑小姐·追加死神头巾[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45185'}},
----------
[541]={id = 541, type = 3, text = '古城微笑小姐·追加兔女郎发圈', Condition = {quest = {99590014}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '古城微笑小姐·追加兔女郎发圈', Show = 1, Acc = 1, Icon = {itemicon = 'item_45141'}},
----------
[542]={id = 542, type = 3, text = '古城微笑小姐·追加花蝴蝶发夹', Condition = {quest = {270126}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '古城微笑小姐·追加花蝴蝶发夹', Show = 1, Acc = 1, Icon = {itemicon = 'item_45190'}},
----------
[543]={id = 543, type = 3, text = '皇家徽章收集商·追加邪骨黑帽', Condition = {quest = {270200}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '皇家徽章收集商·追加邪骨黑帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45208'}},
----------
[544]={id = 544, type = 3, text = '皇家徽章收集商·追加邪骨兜帽', Condition = {quest = {270210}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '皇家徽章收集商·追加邪骨兜帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45209'}},
----------
[545]={id = 545, type = 3, text = '皇家徽章收集商·追加暗黑假面', Condition = {quest = {270220}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '皇家徽章收集商·追加暗黑假面', Show = 1, Acc = 1, Icon = {itemicon = 'item_48542'}},
----------
[546]={id = 546, type = 3, text = '皇家徽章收集商·追加骷髅黑帽[1]', Condition = {quest = {270230}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '皇家徽章收集商·追加骷髅黑帽[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45207'}},
----------
[547]={id = 547, type = 3, text = '皇家徽章收集商·追加暗黑舞会假面', Condition = {quest = {270240}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '皇家徽章收集商·追加暗黑舞会假面', Show = 1, Acc = 1, Icon = {itemicon = 'item_48563'}},
----------
[548]={id = 548, type = 3, text = '皇家徽章收集商·追加暗黑头盔[1]', Condition = {achieve = {1451051}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '皇家徽章收集商·追加暗黑头盔[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45104'}},
----------
[549]={id = 549, type = 3, text = '皇家徽章收集商·追加恶魔的翅膀', Condition = {achieve = {1451071}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '皇家徽章收集商·追加恶魔的翅膀', Show = 1, Acc = 1, Icon = {itemicon = 'item_47011'}},
----------
[550]={id = 550, type = 3, text = '时光馈赠商店·追加风车头饰[1]', Condition = {quest = {601230003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '时光馈赠商店·追加风车头饰[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45264'}},
----------
[551]={id = 551, type = 3, text = '艾尔帕兰微笑小姐·追加雨伞帽', Condition = {quest = {601240003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '艾尔帕兰微笑小姐·追加雨伞帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45265'}},
----------
[552]={id = 552, type = 3, text = '艾尔帕兰微笑小姐·追加时光洞察', Condition = {achieve = {1452001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '艾尔帕兰微笑小姐·追加时光洞察', Show = 1, Acc = 1, Icon = {itemicon = 'item_48569'}},
----------
[553]={id = 553, type = 3, text = '时光馈赠商店·追加黄金时钟守备官[1]', Condition = {achieve = {1452002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '时光馈赠商店·追加黄金时钟守备官[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45251'}},
----------
[554]={id = 554, type = 3, text = '时光馈赠商店·追加时光倒流', Condition = {achieve = {1452011}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '时光馈赠商店·追加时光倒流', Show = 1, Acc = 1, Icon = {itemicon = 'item_47026'}},
----------
[555]={id = 555, type = 3, text = '时光馈赠商店·追加布谷布谷', Condition = {achieve = {1452006}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '时光馈赠商店·追加布谷布谷', Show = 1, Acc = 1, Icon = {itemicon = 'item_45248'}},
----------
[556]={id = 556, type = 3, text = '时光馈赠商店·追加穆拉辛小姐的微笑[1]', Condition = {achieve = {1452010}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '时光馈赠商店·追加穆拉辛小姐的微笑[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45250'}},
----------
[557]={id = 557, type = 3, text = '时光馈赠商店·追加时之吟游诗人', Condition = {achieve = {1452012}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '时光馈赠商店·追加时之吟游诗人', Show = 1, Acc = 1, Icon = {itemicon = 'item_45249'}},
----------
[559]={id = 559, type = 3, text = '梦罗克微笑小姐·追加生命药瓶', Condition = {quest = {12200001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '梦罗克微笑小姐·追加生命药瓶', Show = 1, Acc = 1, Icon = {itemicon = 'item_45427'}},
----------
[560]={id = 560, type = 3, text = '姜饼城·追加仓鼠号手', Condition = {quest = {200460005}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城·追加仓鼠号手', Show = 1, Acc = 1, Icon = {itemicon = 'item_45404'}},
----------
[561]={id = 561, type = 3, text = '姜饼城·追加暖洋洋圣诞树', Condition = {quest = {200550004}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城·追加暖洋洋圣诞树', Show = 1, Acc = 1, Icon = {itemicon = 'item_45405'}},
----------
[562]={id = 562, type = 3, text = '姜饼城·追加驯鹿毛线帽', Condition = {achieve = {1453005}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城·追加驯鹿毛线帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45403'}},
----------
[563]={id = 563, type = 3, text = '姜饼城·追加冰皇冠[1]', Condition = {achieve = {1453009}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城·追加冰皇冠[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45401'}},
----------
[564]={id = 564, type = 3, text = '姜饼城·追加圣诞蝴蝶结[1]', Condition = {achieve = {1453008}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城·追加圣诞蝴蝶结[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45402'}},
----------
[565]={id = 565, type = 3, text = '姜饼城·追加冰苹果[1]', Condition = {level = 200}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城·追加冰苹果[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45400'}},
----------
[566]={id = 566, type = 3, text = '姜饼城·追加金色圣诞铃铛', Condition = {achieve = {1453010}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城·追加金色圣诞铃铛', Show = 1, Acc = 1, Icon = {itemicon = 'item_47039'}},
----------
[567]={id = 567, type = 3, text = '姜饼城微笑小姐·追加莎蔓芭亚帽[1]', Condition = {level = 96}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城微笑小姐·追加莎蔓芭亚帽[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_145433'}},
----------
[568]={id = 568, type = 3, text = '姜饼城微笑小姐·魔菇帽[1]', Condition = {level = 97}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城微笑小姐·魔菇帽[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_145093'}},
----------
[569]={id = 569, type = 3, text = '姜饼城微笑小姐·铃铛发带[1]', Condition = {level = 98}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城微笑小姐·铃铛发带[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_145139'}},
----------
[570]={id = 570, type = 3, text = '姜饼城微笑小姐·鹿角头饰[1]', Condition = {level = 99}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城微笑小姐·鹿角头饰[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_145096'}},
----------
[571]={id = 571, type = 3, text = '姜饼城微笑小姐·狐耳铃铛发带[1]', Condition = {level = 99}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城微笑小姐·狐耳铃铛发带[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_145142'}},
----------
[572]={id = 572, type = 3, text = '梦罗克微笑小姐·追加眼部疤痕', Condition = {quest = {12220001}}, event = _EmptyTable, sysMsg = {id = 798}, Tip = '梦罗克微笑小姐·追加眼部疤痕', Show = 1, Acc = 1, Icon = {itemicon = 'item_46614'}},
----------
[573]={id = 573, type = 3, text = '朱诺微笑小姐·追加曙光队长帽', Condition = {achieve = {1454201}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '朱诺微笑小姐·追加曙光队长帽', Show = 1, Acc = 1, Icon = {itemicon = 'item_45621'}},
----------
[574]={id = 574, type = 3, text = '朱诺微笑小姐·追加天空护卫头盔[1]', Condition = {achieve = {1454206}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '朱诺微笑小姐·追加天空护卫头盔[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45635'}},
----------
[575]={id = 575, type = 3, text = '朱诺微笑小姐·追加风车', Condition = {achieve = {1454205}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '朱诺微笑小姐·追加风车', Show = 1, Acc = 1, Icon = {itemicon = 'item_45639'}},
----------
[576]={id = 576, type = 3, text = '朱诺微笑小姐·追加羽毛发夹[1]', Condition = {achieve = {1454203}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '朱诺微笑小姐·追加羽毛发夹[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45634'}},
----------
[577]={id = 577, type = 3, text = '朱诺微笑小姐·追加曙光之眼', Condition = {achieve = {1454202}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '朱诺微笑小姐·追加曙光之眼', Show = 1, Acc = 1, Icon = {itemicon = 'item_48625'}},
----------
[578]={id = 578, type = 3, text = '朱诺微笑小姐·追加黄金触角[1]', Condition = {achieve = {1454207}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '朱诺微笑小姐·追加黄金触角[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45690'}},
----------
[601]={id = 601, type = 3, text = '制作配方·追加恢复之杖[1]', Condition = {quest = {311110001}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加恢复之杖[1]', Show = 1, Icon = {itemicon = 'item_41518'}},
----------
[602]={id = 602, type = 3, text = '制作配方·追加迪斯凯特的便靴', Condition = {quest = {311110011}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加迪斯凯特的便靴', Show = 1, Icon = {itemicon = 'item_43536'}},
----------
[603]={id = 603, type = 3, text = '玩具商·追加恶作剧魔棒-冰波利', Condition = {quest = {311110021}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '玩具商·追加恶作剧魔棒-冰波利', Show = 1, Icon = {itemicon = 'item_500400'}},
----------
[604]={id = 604, type = 3, text = '制作配方·追加魔力书籍', Condition = {quest = {311120011}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加魔力书籍', Show = 1, Icon = {itemicon = 'item_42519'}},
----------
[605]={id = 605, type = 3, text = '制作配方·追加小可的玫瑰手镯', Condition = {quest = {311120001}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加小可的玫瑰手镯', Show = 1, Icon = {itemicon = 'item_61507'}},
----------
[606]={id = 606, type = 3, text = '玩具商·追加伪装卷轴', Condition = {quest = {311120021}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '玩具商·追加伪装卷轴', Show = 1, Icon = {itemicon = 'toy_504'}},
----------
[607]={id = 607, type = 3, text = '制作配方·追加龙之衬衣', Condition = {quest = {311650004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加龙之衬衣', Show = 1, Icon = {itemicon = 'item_42018'}},
----------
[608]={id = 608, type = 3, text = '制作配方·追加哥夫内肩饰', Condition = {quest = {311660004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加哥夫内肩饰', Show = 1, Icon = {itemicon = 'item_43014'}},
----------
[609]={id = 609, type = 3, text = '玩具商·追加嘎嘎嘎！', Condition = {quest = {311130021}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '玩具商·追加嘎嘎嘎！', Show = 1, Icon = {itemicon = 'toy_505'}},
----------
[610]={id = 610, type = 3, text = '制作配方·追加刺藤拳刃[1]', Condition = {quest = {311140001}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加刺藤拳刃[1]', Show = 1, Icon = {itemicon = 'item_40904'}},
----------
[611]={id = 611, type = 3, text = '制作配方·追加坚定斗篷', Condition = {quest = {311140011}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加坚定斗篷', Show = 1, Icon = {itemicon = 'item_43027'}},
----------
[612]={id = 612, type = 3, text = '制作配方·追加秘剑眷恋[1]', Condition = {quest = {311150001}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加秘剑眷恋[1]', Show = 1, Icon = {itemicon = 'item_40317'}},
----------
[613]={id = 613, type = 3, text = '制作配方·追加许愿之杖[1]', Condition = {quest = {311150011}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加许愿之杖[1]', Show = 1, Icon = {itemicon = 'item_40615'}},
----------
[614]={id = 614, type = 3, text = '玩具商·追加艾娃', Condition = {quest = {311670004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '玩具商·追加玩具商·追加艾娃', Show = 1, Icon = {itemicon = 'toy_502'}},
----------
[615]={id = 615, type = 3, text = '制作配方·追加秘银之衣', Condition = {quest = {311160001}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加秘银之衣', Show = 1, Icon = {itemicon = 'item_42004'}},
----------
[616]={id = 616, type = 3, text = '制作配方·追加谎言纪录本', Condition = {quest = {311160011}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加谎言纪录本', Show = 1, Icon = {itemicon = 'item_42515'}},
----------
[617]={id = 617, type = 3, text = '制作配方·追加柱枪[1]', Condition = {quest = {311680004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加柱枪[1]', Show = 1, Icon = {itemicon = 'item_40016'}},
----------
[618]={id = 618, type = 3, text = '制作配方·追加沙漠之暮[1]', Condition = {quest = {311180011}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加沙漠之暮[1]', Show = 1, Icon = {itemicon = 'item_40724'}},
----------
[619]={id = 619, type = 3, text = '制作配方·追加红色闪电[1]', Condition = {quest = {311180021}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加红色闪电[1]', Show = 1, Icon = {itemicon = 'item_41216'}},
----------
[620]={id = 620, type = 3, text = '制作配方·追加布袋熊长靴', Condition = {quest = {311190001}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加布袋熊长靴', Show = 1, Icon = {itemicon = 'item_43537'}},
----------
[621]={id = 621, type = 3, text = '制作配方·追加魔磨长靴', Condition = {quest = {311190021}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加魔磨长靴', Show = 1, Icon = {itemicon = 'item_43538'}},
----------
[622]={id = 622, type = 3, text = '玩具商·追加变傻光线枪', Condition = {quest = {311150021}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '玩具商·追加变傻光线枪', Show = 1, Icon = {itemicon = 'toy_501'}},
----------
[623]={id = 623, type = 3, text = '玩具商·追加绝对领域', Condition = {quest = {311190011}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '玩具商·追加绝对领域', Show = 1, Icon = {itemicon = 'toy_503'}},
----------
[624]={id = 624, type = 3, text = '制作配方·追加斩首拳刃[1]', Condition = {quest = {311200002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加斩首拳刃[1]', Show = 1, Icon = {itemicon = 'item_40912'}},
----------
[625]={id = 625, type = 3, text = '制作配方·追加元素融合之杖[1]', Condition = {quest = {311210002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加元素融合之杖[1]', Show = 1, Icon = {itemicon = 'item_40616'}},
----------
[626]={id = 626, type = 3, text = '制作配方·追加圣符长靴', Condition = {quest = {311220002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加圣符长靴', Show = 1, Icon = {itemicon = 'item_43539'}},
----------
[627]={id = 627, type = 3, text = '制作配方·追加森林之杖[1]', Condition = {quest = {600100004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加森林之杖[1]', Show = 1, Icon = {itemicon = 'item_40622'}},
----------
[628]={id = 628, type = 3, text = '制作配方·追加言灵护甲', Condition = {quest = {600130004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加言灵护甲', Show = 1, Icon = {itemicon = 'item_42038'}},
----------
[629]={id = 629, type = 3, text = '制作配方·追加华丽短剑[1]', Condition = {quest = {600170004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加华丽短剑[1]', Show = 1, Icon = {itemicon = 'item_40711'}},
----------
[630]={id = 630, type = 3, text = '制作配方·追加血斧[1]', Condition = {quest = {311630003}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加血斧[1]', Show = 1, Icon = {itemicon = 'item_41814'}},
----------
[631]={id = 631, type = 3, text = '吉芬微笑小姐·追加包袱', Condition = {quest = {311610003}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '吉芬微笑小姐·追加包袱', Show = 1, Acc = 1, Icon = {itemicon = 'item_45187'}},
----------
[632]={id = 632, type = 3, text = '吉芬理发店·追加能量外套（男）、暗之壁障（女）', Condition = {quest = {311590003}}, event = {type = 'unlockhair', param = {25, 36}}, sysMsg = {id = 799}, Tip = '吉芬理发店·追加新发型', Show = 1, Icon = {uiicon = 'hair'}},
[709]={id = 709, text = '吉芬理发店·追加螺旋刺击（男）', Condition = {quest = {300130007}}, event = {type = 'unlockhair', param = {21}}, sysMsg = _EmptyTable},
[710]={id = 710, text = '吉芬理发店·追加暖心料理（女）', Condition = {quest = {300130007}}, event = {type = 'unlockhair', param = {32}}, sysMsg = _EmptyTable},
[711]={id = 711, text = '吉芬理发店·追加反击（男）', Condition = {quest = {99440006}}, event = {type = 'unlockhair', param = {22}}, sysMsg = _EmptyTable},
[712]={id = 712, text = '吉芬理发店·追加最爱BABY（女）', Condition = {quest = {99440006}}, event = {type = 'unlockhair', param = {31}}, sysMsg = _EmptyTable},
----------
[633]={id = 633, type = 3, text = '制作配方·追加希尔之斧[1]', Condition = {quest = {600320003}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加希尔之斧[1]', Show = 1, Icon = {itemicon = 'item_41813'}},
----------
[634]={id = 634, type = 3, text = '制作配方·追加虎爪拳套[1]', Condition = {quest = {311180021}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加虎爪拳套[1]', Show = 1, Icon = {itemicon = 'item_62503'}},
----------
[635]={id = 635, type = 3, text = '制作配方·追加钢铁拳套[1]', Condition = {quest = {311200002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加钢铁拳套[1]', Show = 1, Icon = {itemicon = 'item_62504'}},
----------
[636]={id = 636, type = 3, text = '制作配方·追加秘银金属铠甲', Condition = {quest = {311220002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加秘银金属铠甲', Show = 1, Icon = {itemicon = 'item_42020'}},
----------
[637]={id = 637, type = 3, text = '制作配方·追加镜盾', Condition = {quest = {600170004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加镜盾', Show = 1, Icon = {itemicon = 'item_42508'}},
----------
[638]={id = 638, type = 3, text = '制作配方·追加秘拳套闪光[1]', Condition = {quest = {600530003}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加秘拳套闪光[1]', Show = 1, Icon = {itemicon = 'item_62510'}},
----------
[639]={id = 639, type = 3, text = '制作配方·追加坚固盾牌', Condition = {quest = {600540003}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加坚固盾牌', Show = 1, Icon = {itemicon = 'item_42539'}},
----------
[640]={id = 640, type = 3, text = '钟楼理发店·追加六合拳（男）、圣十字攻击（女）', Condition = {quest = {600550003}}, event = {type = 'unlockhair', param = {41, 52}}, sysMsg = _EmptyTable, Tip = '艾尔帕兰理发店·追加新发型', Show = 1, Icon = {uiicon = 'hair'}},
[641]={id = 641, text = '钟楼理发店·追加光之盾（男）、移花接木（女）', Condition = {quest = {99680003}}, event = {type = 'unlockhair', param = {42, 51}}},
----------
[642]={id = 642, type = 3, text = '制作配方·追加炼金铠甲[1]', Condition = {quest = {311180011}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加炼金铠甲[1]', Show = 1, Icon = {itemicon = 'item_42074'}},
----------
[643]={id = 643, type = 3, text = '制作配方·追加强袭战斧[1]', Condition = {quest = {311680004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加强袭战斧[1]', Show = 1, Icon = {itemicon = 'item_41850'}},
----------
[644]={id = 644, type = 3, text = '制作配方·追加熟练者之锤[1]', Condition = {quest = {311210002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加熟练者之锤[1]', Show = 1, Icon = {itemicon = 'item_41543'}},
----------
[645]={id = 645, type = 3, text = '制作配方·追加手术刀[1]', Condition = {quest = {600100004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加手术刀[1]', Show = 1, Icon = {itemicon = 'item_40744'}},
----------
[646]={id = 646, type = 3, text = '制作配方·追加预言者披风', Condition = {quest = {601540003}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加预言者披风', Show = 1, Icon = {itemicon = 'item_43038'}},
----------
[647]={id = 647, type = 3, text = '制作配方·追加化学防护手套', Condition = {quest = {601560003}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加化学防护手套', Show = 1, Icon = {itemicon = 'item_61014'}},
----------
[648]={id = 648, type = 3, text = '制作配方·追加象牙匕首[1]', Condition = {quest = {600130004}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加象牙匕首[1]', Show = 1, Icon = {itemicon = 'item_40743'}},
----------
[649]={id = 649, type = 3, text = '制作配方·追加黑翼[1]', Condition = {quest = {311190021}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加黑翼[1]', Show = 1, Icon = {itemicon = 'item_40747'}},
----------
[650]={id = 650, type = 3, text = '制作配方·追加盗贼之弓[1]', Condition = {quest = {311200002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加盗贼之弓[1]', Show = 1, Icon = {itemicon = 'item_41237'}},
----------
[651]={id = 651, type = 3, text = '制作配方·追加放浪者外套', Condition = {quest = {311210002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加放浪者外套', Show = 1, Icon = {itemicon = 'item_42073'}},
----------
[652]={id = 652, type = 3, text = '制作配方·追加援护者皮靴', Condition = {quest = {311220002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加援护者皮靴', Show = 1, Icon = {itemicon = 'item_43551'}},
----------
[653]={id = 653, type = 3, text = '制作配方·追加考尔德短剑[1]', Condition = {quest = {311190001}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·追加考尔德短剑[1]', Show = 1, Icon = {itemicon = 'item_40742'}},
----------
[654]={id = 654, type = 3, text = '天津町微笑小姐·追加般若之面', Condition = {achieve = {1454101}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '天津町微笑小姐·追加般若之面', Show = 1, Acc = 1, Icon = {itemicon = 'item_48606'}},
----------
[655]={id = 655, type = 3, text = '天津町微笑小姐·追加狐王的笑脸[1]', Condition = {achieve = {1454102}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '天津町微笑小姐·追加狐王的笑脸[1]', Show = 1, Acc = 1, Icon = {itemicon = 'item_45466'}},
----------
[656]={id = 656, type = 3, text = '天津町微笑小姐·追加樱偶', Condition = {achieve = {1454103}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '天津町微笑小姐·追加樱偶', Show = 1, Acc = 1, Icon = {itemicon = 'item_47057'}},
----------
[657]={id = 657, type = 3, text = '制作配方·皇家之矛[1]', Condition = {quest = {601820003}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·皇家之矛[1]', Show = 1, Icon = {itemicon = 'item_40015'}},
----------
[658]={id = 658, type = 3, text = '制作配方·工程扳手[1]', Condition = {quest = {601840002}}, event = _EmptyTable, sysMsg = {id = 799}, Tip = '制作配方·工程扳手[1]', Show = 1, Icon = {itemicon = 'item_41556'}},
----------
[701]={id = 701, type = 3, text = '首都理发店·追加怪物互击（男）', Condition = {quest = {99100001}}, event = {type = 'unlockhair', param = {4}}, sysMsg = _EmptyTable, Tip = '首都理发店·追加新发型', Show = 1, Icon = {uiicon = 'hair'}},
[702]={id = 702, text = '首都理发店·追加治愈术（女）', event = {type = 'unlockhair', param = {13}}},
[703]={id = 703, text = '首都理发店·追加地雷陷阱（男）', Condition = {quest = {100091}}, event = {type = 'unlockhair', param = {1}}},
[704]={id = 704, text = '首都理发店·追加冰冻术（女）', Condition = {quest = {100091}}, event = {type = 'unlockhair', param = {16}}},
[705]={id = 705, text = '首都理发店·追加雷暴术（男）', Condition = {quest = {390030001}}, event = {type = 'unlockhair', param = {5}}},
[706]={id = 706, text = '首都理发店·追加大地之击（女）', Condition = {quest = {390030001}}, event = {type = 'unlockhair', param = {20}}},
[720]={id = 720, text = '首都理发店·追加精英冒险家发型（男）', Condition = {other = 1}, event = {type = 'unlockhair', param = {62}}},
[721]={id = 721, text = '首都理发店·追加裂风之刃发型（男）', Condition = {other = 1}, event = {type = 'unlockhair', param = {63}}},
[722]={id = 722, text = '首都理发店·追加风之步发型（男）', Condition = {other = 1}, event = {type = 'unlockhair', param = {64}}},
[723]={id = 723, text = '首都理发店·追加精英冒险家发型（女）', Condition = {other = 1}, event = {type = 'unlockhair', param = {59}}},
[724]={id = 724, text = '首都理发店·追加女神之吻发型（女）', Condition = {other = 1}, event = {type = 'unlockhair', param = {60}}},
[725]={id = 725, text = '首都理发店·追加撒水祈福发型（女）', Condition = {other = 1}, event = {type = 'unlockhair', param = {71}}},
----------
[707]={id = 707, type = 3, text = '梦罗克理发店·追加二刀连击（女）', Condition = {quest = {99460018}}, event = {type = 'unlockhair', param = {19}}, sysMsg = _EmptyTable, Tip = '梦罗克理发店·追加新发型', Show = 1, Icon = {uiicon = 'hair'}},
[708]={id = 708, text = '梦罗克理发店·追加暴风雪（男）', event = {type = 'unlockhair', param = {9}}},
----------
[717]={id = 717, type = 3, text = '古城理发店·追加蜂蜜（男）、剑速增加（女）', Condition = {quest = {99560009}}, event = {type = 'unlockhair', param = {23, 33}}, sysMsg = _EmptyTable, Tip = '古城理发店·追加新发型', Show = 1, Icon = {uiicon = 'hair'}},
[719]={id = 719, text = '古城理发店·追加火焰之环（男）、魔力增幅（女）', Condition = {quest = {270141}}, event = {type = 'unlockhair', param = {26, 35}}},
----------
[718]={id = 718, type = 3, text = '斐扬理发店·追加冰冻陷阱（男）、光猎（女）', Condition = {quest = {99530009}}, event = {type = 'unlockhair', param = {24, 34}}, sysMsg = _EmptyTable, Tip = '斐扬理发店·追加新发型', Show = 1, Icon = {uiicon = 'hair'}},
----------
[801]={id = 801, type = 3, text = '可习得动作·飞吻', Condition = {quest = {21100001}}, event = {type = 'unlockaction', param = {32}}, sysMsg = _EmptyTable, Tip = '习得动作·飞吻', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[802]={id = 802, type = 3, text = '可习得动作·鼓掌', Condition = {quest = {21200001}}, event = {type = 'unlockaction', param = {31}}, sysMsg = _EmptyTable, Tip = '习得动作·鼓掌', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[803]={id = 803, type = 3, text = '可习得动作·鞠躬', Condition = {quest = {30000001}}, event = {type = 'unlockaction', param = {34}}, sysMsg = _EmptyTable, Tip = '习得动作·鞠躬', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[804]={id = 804, type = 3, text = '可习得动作·跑步', Condition = {quest = {10003}}, event = {type = 'unlockaction', param = {1}}, sysMsg = _EmptyTable, Tip = '习得动作·跑步', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[805]={id = 805, type = 3, text = '可习得动作·被击', Condition = {quest = {10003}}, event = {type = 'unlockaction', param = {5}}, sysMsg = _EmptyTable, Tip = '习得动作·被击', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[806]={id = 806, type = 3, text = '可习得动作·战斗', Condition = {achieve = {1402021}}, event = {type = 'unlockaction', param = {8}}, sysMsg = _EmptyTable, Tip = '习得动作·战斗', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[807]={id = 807, type = 3, text = '可习得动作·普通攻击', Condition = {quest = {10003}}, event = {type = 'unlockaction', param = {11}}, sysMsg = _EmptyTable, Tip = '习得动作·普通攻击', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[808]={id = 808, type = 3, text = '可习得动作·吟唱', Condition = {quest = {10003}}, event = {type = 'unlockaction', param = {22}}, sysMsg = _EmptyTable, Tip = '习得动作·吟唱', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[809]={id = 809, type = 3, text = '可习得动作·睡觉', Condition = {achieve = {1402014}}, event = {type = 'unlockaction', param = {37}}, sysMsg = _EmptyTable, Tip = '习得动作·睡觉', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[810]={id = 810, type = 3, text = '可习得动作·采集', Condition = {quest = {99670002}}, event = {type = 'unlockaction', param = {38}}, sysMsg = _EmptyTable, Tip = '习得动作·采集', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[811]={id = 811, type = 3, text = '可习得动作·胜利', Condition = {achieve = {1401051}}, event = {type = 'unlockaction', param = {39}}, sysMsg = _EmptyTable, Tip = '习得动作·胜利', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[812]={id = 812, type = 3, text = '可习得动作·投掷', Condition = {quest = {10003}}, event = {type = 'unlockaction', param = {56}}, sysMsg = _EmptyTable, Tip = '习得动作·投掷', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[813]={id = 813, type = 3, text = '可习得动作·摆拍动作-职业专属', Condition = {quest = {10003}}, event = {type = 'unlockaction', param = {73}}, sysMsg = _EmptyTable, Tip = '习得动作·摆拍动作-职业专属', Show = 1, Icon = {uiicon = 'sit_down'}},
----------
[831]={id = 831, type = 3, text = '可习得表情·大爱心', Condition = {quest = {90000002}}, event = {type = 'unlockexpression', param = {27}}, sysMsg = _EmptyTable, Tip = '习得表情·大爱心', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[832]={id = 832, type = 3, text = '可习得表情·○', Condition = {quest = {99150031}}, event = {type = 'unlockexpression', param = {32}}, sysMsg = _EmptyTable, Tip = '习得表情·○', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[833]={id = 833, type = 3, text = '可习得表情·×', Condition = {quest = {99150031}}, event = {type = 'unlockexpression', param = {31}}, sysMsg = _EmptyTable, Tip = '习得表情·×', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[834]={id = 834, type = 3, text = '可习得表情·剪刀', Condition = {quest = {306000001}}, event = {type = 'unlockexpression', param = {34}}, sysMsg = _EmptyTable, Tip = '习得表情·剪刀', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[835]={id = 835, type = 3, text = '可习得表情·石头', Condition = {quest = {306000002}}, event = {type = 'unlockexpression', param = {33}}, sysMsg = _EmptyTable, Tip = '习得表情·石头', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[836]={id = 836, type = 3, text = '可习得表情·布', Condition = {quest = {306000003}}, event = {type = 'unlockexpression', param = {35}}, sysMsg = _EmptyTable, Tip = '习得表情·布', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[837]={id = 837, type = 3, text = '可习得默认表情', Condition = {quest = {10003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '习得6个新表情和1个新动作', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[838]={id = 838, type = 3, text = '可习得表情·高兴', Condition = {quest = {99040001}}, event = {type = 'unlockexpression', param = {9}}, sysMsg = _EmptyTable, Tip = '习得表情·高兴', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[839]={id = 839, type = 3, text = '可习得表情·无奈', Condition = {quest = {60000002}}, event = {type = 'unlockexpression', param = {15}}, sysMsg = _EmptyTable, Tip = '习得表情·无奈', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[841]={id = 841, type = 3, text = '可习得表情·出发', Condition = {quest = {99150021}}, event = {type = 'unlockexpression', param = {23}}, sysMsg = _EmptyTable, Tip = '习得表情·出发', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[842]={id = 842, type = 3, text = '可习得表情·哭泣', Condition = {quest = {99080001}}, event = {type = 'unlockexpression', param = {24}}, sysMsg = _EmptyTable, Tip = '习得表情·哭泣', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[843]={id = 843, type = 3, text = '可习得表情·一级棒', Condition = {quest = {21200001}}, event = {type = 'unlockexpression', param = {20}}, sysMsg = _EmptyTable, Tip = '习得表情·一级棒', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[844]={id = 844, type = 3, text = '可习得表情·接吻', Condition = {quest = {99150001}}, event = {type = 'unlockexpression', param = {3}}, sysMsg = _EmptyTable, Tip = '习得表情·亲吻', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[845]={id = 845, type = 3, text = '可习得表情·求救', Condition = {quest = {99150031}}, event = {type = 'unlockexpression', param = {22}}, sysMsg = _EmptyTable, Tip = '习得表情·求救', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[846]={id = 846, type = 3, text = '可习得表情·寻找', Condition = {quest = {100004}}, event = {type = 'unlockexpression', param = {21}}, sysMsg = _EmptyTable, Tip = '习得表情·寻找', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[847]={id = 847, type = 3, text = '可习得表情·喷汗', Condition = {quest = {100009}}, event = {type = 'unlockexpression', param = {18}}, sysMsg = _EmptyTable, Tip = '习得表情·喷汗', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[848]={id = 848, type = 3, text = '可习得表情·睡觉', Condition = {quest = {21350001}}, event = {type = 'unlockexpression', param = {36}}, sysMsg = _EmptyTable, Tip = '习得表情·睡觉', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[849]={id = 849, type = 3, text = '可习得表情·惊讶', Condition = {quest = {99170001}}, event = {type = 'unlockexpression', param = {1}}, sysMsg = _EmptyTable, Tip = '习得表情·惊讶', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[850]={id = 850, type = 3, text = '可习得表情·冷汗', Condition = {quest = {99160101}}, event = {type = 'unlockexpression', param = {10}}, sysMsg = _EmptyTable, Tip = '习得表情·冷汗', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[851]={id = 851, type = 3, text = '可习得表情·双眼爱心', Condition = {quest = {330010001}}, event = {type = 'unlockexpression', param = {29}}, sysMsg = _EmptyTable, Tip = '习得表情·双眼爱心', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[852]={id = 852, type = 3, text = '可习得表情·摸头', Condition = {quest = {350100001}}, event = {type = 'unlockexpression', param = {30}}, sysMsg = _EmptyTable, Tip = '习得表情·摸头', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[853]={id = 853, type = 3, text = '可习得表情·口水', Condition = {quest = {350200001}}, event = {type = 'unlockexpression', param = {28}}, sysMsg = _EmptyTable, Tip = '习得表情·口水', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[854]={id = 854, type = 3, text = '可习得表情·坏笑', Condition = {quest = {350300001}}, event = {type = 'unlockexpression', param = {5}}, sysMsg = _EmptyTable, Tip = '习得表情·坏笑', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[855]={id = 855, type = 3, text = '可习得表情·呼', Condition = {quest = {21150001}}, event = {type = 'unlockexpression', param = {25}}, sysMsg = _EmptyTable, Tip = '习得表情·呼', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[856]={id = 856, type = 3, text = '可习得表情·迷惑', Condition = {quest = {99230003}}, event = {type = 'unlockexpression', param = {19}}, sysMsg = _EmptyTable, Tip = '习得表情·迷惑', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[857]={id = 857, type = 3, text = '可习得表情·害怕', Condition = {quest = {270134}}, event = {type = 'unlockexpression', param = {37}}, sysMsg = _EmptyTable, Tip = '习得表情·害怕', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[858]={id = 858, type = 3, text = '可习得表情·亲吻', Condition = {quest = {99160001}}, event = {type = 'unlockexpression', param = {4}}, sysMsg = _EmptyTable, Tip = '习得表情·接吻', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[859]={id = 859, type = 3, text = '可习得表情·爱心', Condition = {quest = {99670005}}, event = {type = 'unlockexpression', param = {2}}, sysMsg = _EmptyTable, Tip = '习得表情·爱心', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[860]={id = 860, type = 3, text = '可习得表情·感叹号', Condition = {quest = {99660005}}, event = {type = 'unlockexpression', param = {7}}, sysMsg = _EmptyTable, Tip = '习得表情·感叹号', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[861]={id = 861, type = 3, text = '可习得表情·问号', Condition = {quest = {99660005}}, event = {type = 'unlockexpression', param = {8}}, sysMsg = _EmptyTable, Tip = '习得表情·问号', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[862]={id = 862, type = 3, text = '可习得表情·灵感', Condition = {level = 9999}, event = {type = 'unlockexpression', param = {11}}, sysMsg = _EmptyTable, Tip = '习得表情·灵感', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[863]={id = 863, type = 3, text = '可习得表情·金钱', Condition = {level = 9999}, event = {type = 'unlockexpression', param = {13}}, sysMsg = _EmptyTable, Tip = '习得表情·金钱', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[864]={id = 864, type = 3, text = '可习得表情·品客好吃美味', Condition = {level = 9999}, event = {type = 'unlockexpression', param = {500}}, sysMsg = _EmptyTable, Tip = '习得表情·品客好吃美味', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[865]={id = 865, type = 3, text = '可习得表情·害羞', Condition = {level = 9999}, event = {type = 'unlockexpression', param = {38}}, sysMsg = _EmptyTable, Tip = '习得表情·害羞', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[866]={id = 866, type = 3, text = '可习得表情·鼓掌', Condition = {level = 9999}, event = {type = 'unlockexpression', param = {39}}, sysMsg = _EmptyTable, Tip = '习得表情·鼓掌', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[867]={id = 867, type = 3, text = '可习得表情·闭嘴', Condition = {level = 9999}, event = {type = 'unlockexpression', param = {40}}, sysMsg = _EmptyTable, Tip = '习得表情·闭嘴', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[868]={id = 868, type = 3, text = '可习得表情·点赞', Condition = {level = 9999}, event = {type = 'unlockexpression', param = {41}}, sysMsg = _EmptyTable, Tip = '习得表情·点赞', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[869]={id = 869, type = 3, text = '可习得表情·泪奔', Condition = {level = 9999}, event = {type = 'unlockexpression', param = {42}}, sysMsg = _EmptyTable, Tip = '习得表情·泪奔', Show = 1, Icon = {uiicon = 'icon_50'}},
----------
[901]={id = 901, type = 3, text = '自动技能栏格子解锁', Condition = {level = 1}, event = {type = 'AutoSkill'}, sysMsg = _EmptyTable, Tip = '获得新的自动技能栏', Icon = _EmptyTable},
[903]={id = 903, Condition = {skill = {50004001}}},
[904]={id = 904, Condition = {skill = {50005001}}},
----------
[902]={id = 902, type = 3, text = '可获得自动技能栏格子', Condition = {quest = {50001}}, event = {type = 'AutoSkill'}, sysMsg = _EmptyTable, Tip = '获得新的自动技能栏', Show = 1, Icon = {uiicon = 'Skill'}},
[905]={id = 905, text = '自动技能栏格子解锁', Condition = {skill = {50047001}}},
[906]={id = 906, text = '自动技能栏格子解锁', Condition = {skill = {50048001}}},
----------
[910]={id = 910, type = 3, text = '冒险技能栏I', Condition = {skill = {50027001}}, event = {type = 'ExtendSkill'}, sysMsg = _EmptyTable, Tip = '获得新的快捷技能栏', Icon = _EmptyTable},
[911]={id = 911},
[912]={id = 912, text = '冒险技能栏II', Condition = {skill = {50028001}}},
[913]={id = 913, text = '冒险技能栏II', Condition = {skill = {50028001}}},
[914]={id = 914, text = '冒险技能栏III', Condition = {skill = {50029001}}},
[915]={id = 915, text = '冒险技能栏III', Condition = {skill = {50029001}}},
[917]={id = 917},
[918]={id = 918},
[919]={id = 919},
[920]={id = 920},
[921]={id = 921, text = '冒险技能栏II', Condition = {skill = {50028001}}},
[922]={id = 922, text = '冒险技能栏II', Condition = {skill = {50028001}}},
[923]={id = 923, text = '冒险技能栏II', Condition = {skill = {50028001}}},
[924]={id = 924, text = '冒险技能栏II', Condition = {skill = {50028001}}},
[925]={id = 925, text = '冒险技能栏III', Condition = {skill = {50029001}}},
[926]={id = 926, text = '冒险技能栏III', Condition = {skill = {50029001}}},
[927]={id = 927, text = '冒险技能栏III', Condition = {skill = {50029001}}},
[928]={id = 928, text = '冒险技能栏III', Condition = {skill = {50029001}}},
----------
[916]={id = 916, type = 3, text = '可新增1个角色栏位', Condition = {quest = {13010001, 13020011, 13030021, 13040031, 13050041}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '获得新的角色栏位', Show = 1, Icon = {uiicon = 'Pet'}},
----------
[1000]={id = 1000, type = 2, text = '完成后可创建公会', Condition = {level = 25}, event = _EmptyTable, sysMsg = {id = 802}, Tip = '创建公会开启', Show = 1, Icon = {uiicon = 'Guild'}},
----------
[1001]={id = 1001, type = 1, PanelID = 520, text = '公会功能', Condition = {level = 1}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '公会已开启', Icon = {uiicon = 'Guild'}, Enterhide = 1},
----------
[1202]={id = 1202, type = 3, text = '解锁佣兵数量：2', Condition = {skill = {50033001}}, event = {type = 'unlock_cat_num'}, sysMsg = _EmptyTable, Tip = '解锁佣兵猫参战人数', Icon = _EmptyTable},
----------
[1203]={id = 1203, type = 4, text = '可租借佣兵猫：五郎', Condition = {quest = {600120004}}, event = {type = 'unlock_cat_id', param = {1}, effect = '123Takecat_born_ui'}, sysMsg = _EmptyTable, Tip = '解锁佣兵猫·五郎', Show = 1, Icon = _EmptyTable},
----------
[1204]={id = 1204, type = 4, text = '可租借佣兵猫：阿宝', Condition = {quest = {600230001}}, event = {type = 'unlock_cat_id', param = {2}, effect = '126Monkcat_born_ui'}, sysMsg = _EmptyTable, Tip = '解锁佣兵猫：阿宝', Show = 1, Icon = _EmptyTable},
----------
[1205]={id = 1205, type = 4, text = '可租借佣兵猫：山葵', Condition = {quest = {600300001}}, event = {type = 'unlock_cat_id', param = {3}, effect = '127SoldierCat4_born_ui'}, sysMsg = _EmptyTable, Tip = '解锁佣兵猫：山葵', Show = 1, Icon = _EmptyTable},
----------
[1206]={id = 1206, type = 4, text = '可租借佣兵猫：莎子', Condition = {quest = {600310001}}, event = {type = 'unlock_cat_id', param = {4}, effect = '128SoldierCat3_born_ui'}, sysMsg = _EmptyTable, Tip = '解锁佣兵猫：莎子', Show = 1, Icon = _EmptyTable},
----------
[1301]={id = 1301, type = 5, text = '铁匠技能：魔石制作Lv.1', Condition = {skill = {269001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '铁匠技能：魔石制作Lv.1', Icon = _EmptyTable},
----------
[1302]={id = 1302, type = 5, text = '铁匠技能：魔石制作Lv.5', Condition = {skill = {269005}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '铁匠技能：魔石制作Lv.5', Icon = _EmptyTable},
----------
[1303]={id = 1303, type = 5, text = '铁匠技能：精锐合金制作Lv.1', Condition = {skill = {218001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '铁匠技能：精锐合金制作Lv.1', Icon = _EmptyTable},
----------
[1304]={id = 1304, type = 5, text = '铁匠技能：精锐合金制作Lv.3', Condition = {skill = {218003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '铁匠技能：精锐合金制作Lv.3', Icon = _EmptyTable},
----------
[1305]={id = 1305, type = 5, text = '铁匠技能：精锐合金制作Lv.5', Condition = {skill = {218005}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '铁匠技能：精锐合金制作Lv.5', Icon = _EmptyTable},
----------
[1306]={id = 1306, type = 5, text = '铁匠技能：属性武器制作Lv.1', Condition = {skill = {261001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '铁匠技能：属性武器制作Lv.1', Icon = _EmptyTable},
----------
[1401]={id = 1401, type = 3, text = '弓箭哥布灵卡片', Condition = {level = 40}, event = {type = 'unlockmanual', param = {2, 20030, 20031, 24011, 24013}}, sysMsg = _EmptyTable, Tip = '国王波利定制卡 已开放', Show = 1, Icon = {uiicon = 'CardMech'}},
----------
[1403]={id = 1403, type = 3, text = '大嘴鸟卡片', Condition = {level = 50}, event = {type = 'unlockmanual', param = {2, 20041, 20044, 24016, 24030}}, sysMsg = _EmptyTable, Tip = '国王波利·追加新的定制卡', Show = 1, Icon = {uiicon = 'CardMech'}},
[1405]={id = 1405, text = '绿贝勒斯卡片', Condition = {level = 70}, event = {type = 'unlockmanual', param = {2, 20073, 20076, 24001, 24002}}},
[1409]={id = 1409, text = '阿加波卡片', Condition = {level = 60}, event = {type = 'unlockmanual', param = {2, 24008, 24009, 24010, 24012, 24015, 24031, 24032, 24033, 24034}}},
----------
[1502]={id = 1502, type = 3, text = '发现景点·幼龙巢穴', Condition = {quest = {260011}}, event = {type = 'scenery', param = {102}}, sysMsg = _EmptyTable, Tip = '发现景点·幼龙巢穴', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1504]={id = 1504, type = 3, text = '发现景点·古之护城河艾伊克', Condition = {quest = {260009}}, event = {type = 'scenery', param = {104}}, sysMsg = _EmptyTable, Tip = '发现景点·古之护城河艾伊克', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1505]={id = 1505, type = 3, text = '发现景点·就在眼前的古城', Condition = {quest = {260013}}, event = {type = 'scenery', param = {105}}, sysMsg = _EmptyTable, Tip = '发现景点·就在眼前的古城', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1508]={id = 1508, type = 3, text = '发现景点·国王大桥', Condition = {quest = {270005}}, event = {type = 'scenery', param = {108}}, sysMsg = _EmptyTable, Tip = '发现景点·国王大桥', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1510]={id = 1510, type = 3, text = '发现景点·古之避难所', Condition = {quest = {270002}}, event = {type = 'scenery', param = {111}}, sysMsg = _EmptyTable, Tip = '发现景点·古之避难所', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1512]={id = 1512, type = 3, text = '发现景点·古城下水道入口', Condition = {quest = {270017}}, event = {type = 'scenery', param = {113}}, sysMsg = _EmptyTable, Tip = '发现景点·古城下水道入口', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1514]={id = 1514, type = 3, text = '发现景点·虎蜥人巢穴', Condition = {quest = {270077}}, event = {type = 'scenery', param = {116}}, sysMsg = _EmptyTable, Tip = '发现景点·虎蜥人巢穴', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1515]={id = 1515, type = 3, text = '发现景点·古之水牢', Condition = {quest = {270082}}, event = {type = 'scenery', param = {118}}, sysMsg = _EmptyTable, Tip = '发现景点·古之水牢', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1516]={id = 1516, type = 3, text = '发现景点·水闸仪器', Condition = {quest = {270075}}, event = {type = 'scenery', param = {119}}, sysMsg = _EmptyTable, Tip = '发现景点·水闸仪器', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1517]={id = 1517, type = 3, text = '发现景点·贤者的终点', Condition = {quest = {270100}}, event = {type = 'scenery', param = {120}}, sysMsg = _EmptyTable, Tip = '发现景点·贤者的终点', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1518]={id = 1518, type = 3, text = '发现景点·海姆达尔的守候', Condition = {quest = {270097}}, event = {type = 'scenery', param = {121}}, sysMsg = _EmptyTable, Tip = '发现景点·海姆达尔的守候', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1519]={id = 1519, type = 3, text = '发现景点·海姆达尔的坚持', Condition = {quest = {270101}}, event = {type = 'scenery', param = {122}}, sysMsg = _EmptyTable, Tip = '发现景点·海姆达尔的坚持', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1520]={id = 1520, type = 3, text = '发现景点·海姆达尔的勇气', Condition = {quest = {270098}}, event = {type = 'scenery', param = {123}}, sysMsg = _EmptyTable, Tip = '发现景点·海姆达尔的勇气', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1521]={id = 1521, type = 3, text = '发现景点·海姆达尔的智慧', Condition = {quest = {270096}}, event = {type = 'scenery', param = {124}}, sysMsg = _EmptyTable, Tip = '发现景点·海姆达尔的智慧', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1525]={id = 1525, type = 3, text = '发现景点·王权的象征', Condition = {quest = {99620007}}, event = {type = 'scenery', param = {134}}, sysMsg = _EmptyTable, Tip = '发现景点·王权的象征', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1526]={id = 1526, type = 3, text = '发现景点·禁书库', Condition = {quest = {99630008}}, event = {type = 'scenery', param = {137}}, sysMsg = _EmptyTable, Tip = '发现景点·禁书库', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1527]={id = 1527, type = 3, text = '发现景点·皇家国会议政厅', Condition = {quest = {270150}}, event = {type = 'scenery', param = {133}}, sysMsg = _EmptyTable, Tip = '发现景点·皇家国会议政厅', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1528]={id = 1528, type = 3, text = '发现景点·水城船坞', Condition = {quest = {200040001}}, event = {type = 'scenery', param = {140}}, sysMsg = _EmptyTable, Tip = '发现景点·水城船坞', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1529]={id = 1529, type = 3, text = '发现景点·纹章之间', Condition = {quest = {200040005}}, event = {type = 'scenery', param = {152}}, sysMsg = _EmptyTable, Tip = '发现景点·纹章之间', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1530]={id = 1530, type = 3, text = '发现景点·炼金师工会', Condition = {quest = {200090006}}, event = {type = 'scenery', param = {142}}, sysMsg = _EmptyTable, Tip = '发现景点·炼金师工会', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1531]={id = 1531, type = 3, text = '发现景点·机关室', Condition = {quest = {200090007}}, event = {type = 'scenery', param = {149}}, sysMsg = _EmptyTable, Tip = '发现景点·机关室', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1532]={id = 1532, type = 3, text = '发现景点·回音之墙', Condition = {quest = {200090010}}, event = {type = 'scenery', param = {150}}, sysMsg = _EmptyTable, Tip = '发现景点·回音之墙', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1533]={id = 1533, type = 3, text = '发现景点·荒弃的小教堂', Condition = {quest = {200100001}}, event = {type = 'scenery', param = {141}}, sysMsg = _EmptyTable, Tip = '发现景点·荒弃的小教堂', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1534]={id = 1534, type = 3, text = '发现景点·星空回廊', Condition = {quest = {200100002}}, event = {type = 'scenery', param = {151}}, sysMsg = _EmptyTable, Tip = '发现景点·星空回廊', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1535]={id = 1535, type = 3, text = '发现景点·逆转的星盘', Condition = {quest = {200100004}}, event = {type = 'scenery', param = {153}}, sysMsg = _EmptyTable, Tip = '发现景点·逆转的星盘', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1536]={id = 1536, type = 3, text = '发现景点·古语记录碑', Condition = {quest = {200100005}}, event = {type = 'scenery', param = {154}}, sysMsg = _EmptyTable, Tip = '发现景点·古语记录碑', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1537]={id = 1537, type = 3, text = '发现景点·占星平台', Condition = {quest = {200100006}}, event = {type = 'scenery', param = {155}}, sysMsg = _EmptyTable, Tip = '发现景点·占星平台', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1538]={id = 1538, type = 3, text = '发现景点·停摆的古钟', Condition = {quest = {200100007}}, event = {type = 'scenery', param = {156}}, sysMsg = _EmptyTable, Tip = '发现景点·停摆的古钟', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1539]={id = 1539, type = 3, text = '发现景点·时之回廊', Condition = {quest = {200100008}}, event = {type = 'scenery', param = {157}}, sysMsg = _EmptyTable, Tip = '发现景点·时之回廊', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1540]={id = 1540, type = 3, text = '发现景点·国境线的田野', Condition = {quest = {601200001}}, event = {type = 'scenery', param = {147}}, sysMsg = _EmptyTable, Tip = '发现景点·国境线的田野', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1541]={id = 1541, type = 3, text = '发现景点·齿车的巨柱', Condition = {quest = {99680005}}, event = {type = 'scenery', param = {148}}, sysMsg = _EmptyTable, Tip = '发现景点·齿车的巨柱', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1542]={id = 1542, type = 3, text = '发现景点·卡普拉总部', Condition = {quest = {99690005}}, event = {type = 'scenery', param = {139}}, sysMsg = _EmptyTable, Tip = '发现景点·卡普拉总部', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1545]={id = 1545, type = 3, text = '发现景点·冰之河', Condition = {quest = {200400003}}, event = {type = 'scenery', param = {163}}, sysMsg = _EmptyTable, Tip = '发现景点·冰之河', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1546]={id = 1546, type = 3, text = '发现景点·糖果屋的马戏团', Condition = {quest = {200400001}}, event = {type = 'scenery', param = {164}}, sysMsg = _EmptyTable, Tip = '发现景点·糖果屋马戏团', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1547]={id = 1547, type = 3, text = '发现景点·圣树银铃', Condition = {quest = {200400001}}, event = {type = 'scenery', param = {165}}, sysMsg = _EmptyTable, Tip = '发现景点·圣树银铃', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1548]={id = 1548, type = 3, text = '发现景点·雪人公园', Condition = {quest = {200540003}}, event = {type = 'scenery', param = {166}}, sysMsg = _EmptyTable, Tip = '发现景点·雪人公园', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1549]={id = 1549, type = 3, text = '发现景点·圣夜礼拜堂', Condition = {quest = {200540003}}, event = {type = 'scenery', param = {167}}, sysMsg = _EmptyTable, Tip = '发现景点·圣夜礼拜堂', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1550]={id = 1550, type = 3, text = '发现景点·玩具工场入口', Condition = {quest = {200530005}}, event = {type = 'scenery', param = {168}}, sysMsg = _EmptyTable, Tip = '发现景点·玩具工场入口', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1551]={id = 1551, type = 3, text = '发现景点·驯鹿飞行场', Condition = {quest = {200540002}}, event = {type = 'scenery', param = {169}}, sysMsg = _EmptyTable, Tip = '发现景点·驯鹿飞行场', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1552]={id = 1552, type = 3, text = '发现景点·拐杖糖小广场', Condition = {quest = {200510006}}, event = {type = 'scenery', param = {170}}, sysMsg = _EmptyTable, Tip = '发现景点·拐杖糖小广场', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1553]={id = 1553, type = 3, text = '发现景点·圣诞老人之家', Condition = {quest = {200530002}}, event = {type = 'scenery', param = {171}}, sysMsg = _EmptyTable, Tip = '发现景点·圣诞老人之家', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1555]={id = 1555, type = 3, text = '发现景点·礼物之城堡', Condition = {level = 200}, event = {type = 'scenery', param = {172}}, sysMsg = _EmptyTable, Tip = '发现景点·礼物之城堡', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1556]={id = 1556, type = 3, text = '发现景点·微笑小径', Condition = {level = 200}, event = {type = 'scenery', param = {173}}, sysMsg = _EmptyTable, Tip = '发现景点·微笑小径', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1557]={id = 1557, type = 3, text = '发现景点·甜腻方糖迷宫', Condition = {level = 200}, event = {type = 'scenery', param = {174}}, sysMsg = _EmptyTable, Tip = '发现景点·甜腻方糖迷宫', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1558]={id = 1558, type = 3, text = '发现景点·玩具包装车间NO.W', Condition = {level = 200}, event = {type = 'scenery', param = {175}}, sysMsg = _EmptyTable, Tip = '发现景点·玩具包装车间NO.W', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1559]={id = 1559, type = 3, text = '发现景点·草莓马卡龙迷宫', Condition = {level = 200}, event = {type = 'scenery', param = {176}}, sysMsg = _EmptyTable, Tip = '发现景点·草莓马卡龙迷宫', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1560]={id = 1560, type = 3, text = '发现景点·玩具包装车间NO.D', Condition = {level = 200}, event = {type = 'scenery', param = {177}}, sysMsg = _EmptyTable, Tip = '发现景点·玩具包装车间NO.D', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1561]={id = 1561, type = 3, text = '发现景点·快乐人偶中心', Condition = {level = 200}, event = {type = 'scenery', param = {178}}, sysMsg = _EmptyTable, Tip = '发现景点·快乐人偶中心', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1562]={id = 1562, type = 3, text = '发现景点·美蒂欣的化妆间', Condition = {level = 200}, event = {type = 'scenery', param = {179}}, sysMsg = _EmptyTable, Tip = '发现景点·美蒂欣的化妆间', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1563]={id = 1563, type = 3, text = '发现景点·红鼻子的储藏室', Condition = {level = 200}, event = {type = 'scenery', param = {180}}, sysMsg = _EmptyTable, Tip = '发现景点·红鼻子的储藏室', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1564]={id = 1564, type = 3, text = '发现景点·昔日的勇士', Condition = {quest = {201380001}}, event = {type = 'scenery', param = {194}}, sysMsg = _EmptyTable, Tip = '发现景点·昔日的勇士', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1565]={id = 1565, type = 3, text = '发现景点·魔物研究馆', Condition = {quest = {201420003}}, event = {type = 'scenery', param = {191}}, sysMsg = _EmptyTable, Tip = '发现景点·魔物研究馆', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
[1571]={id = 1571, Condition = {quest = {601920004}}},
----------
[1566]={id = 1566, type = 3, text = '发现景点·贤者广场', Condition = {quest = {201410004}}, event = {type = 'scenery', param = {192}}, sysMsg = _EmptyTable, Tip = '发现景点·贤者广场', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1567]={id = 1567, type = 3, text = '发现景点·通天台阶', Condition = {quest = {201400004}}, event = {type = 'scenery', param = {199}}, sysMsg = _EmptyTable, Tip = '发现景点·通天台阶', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1568]={id = 1568, type = 3, text = '发现景点·朱诺国境管理所', Condition = {quest = {201390001}}, event = {type = 'scenery', param = {196}}, sysMsg = _EmptyTable, Tip = '发现景点·朱诺国境管理所', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1569]={id = 1569, type = 3, text = '发现景点·朱诺飞空艇', Condition = {quest = {601870003}}, event = {type = 'scenery', param = {190}}, sysMsg = _EmptyTable, Tip = '发现景点·朱诺飞空艇', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1570]={id = 1570, type = 3, text = '发现景点·总统府', Condition = {quest = {601880003}}, event = {type = 'scenery', param = {188}}, sysMsg = _EmptyTable, Tip = '发现景点·总统府', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1572]={id = 1572, type = 3, text = '发现景点·朱诺皇宫', Condition = {quest = {601940002}}, event = {type = 'scenery', param = {193}}, sysMsg = _EmptyTable, Tip = '发现景点·朱诺皇宫', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1573]={id = 1573, type = 3, text = '发现景点·精灵怪圈', Condition = {quest = {601950003}}, event = {type = 'scenery', param = {198}}, sysMsg = _EmptyTable, Tip = '发现景点·精灵怪圈', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1574]={id = 1574, type = 3, text = '发现景点·熔洞入口', Condition = {quest = {601960004}}, event = {type = 'scenery', param = {197}}, sysMsg = _EmptyTable, Tip = '发现景点·熔洞入口', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1575]={id = 1575, type = 3, text = '发现景点·末日广场', Condition = {quest = {201730001}}, event = {type = 'scenery', param = {200}}, sysMsg = _EmptyTable, Tip = '发现景点·末日广场', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1576]={id = 1576, type = 3, text = '发现景点·友谊大桥', Condition = {quest = {201640001}}, event = {type = 'scenery', param = {195}}, sysMsg = _EmptyTable, Tip = '发现景点·友谊大桥', Show = 1, Acc = 1, Icon = {uiicon = 'photo'}},
----------
[1902]={id = 1902, type = 3, text = '激活月卡', Condition = {other = 1}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物打工·卡普拉公司开启', Show = 1, Acc = 1, Icon = {uiicon = 'Capraroom'}},
----------
[1903]={id = 1903, type = 3, text = '成为C级冒险家', Condition = {title = {1006}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物打工·公会开启', Show = 1, Acc = 1, Icon = {uiicon = 'Guildroom'}},
----------
[1904]={id = 1904, type = 3, text = '成为D级冒险家', Condition = {title = {1005}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物打工·竞技场开启', Show = 1, Acc = 1, Icon = {uiicon = 'Arenaroom'}},
----------
[1905]={id = 1905, type = 3, text = '冒险手册中激活%s/5只宠物', Condition = {manualunlock = {{19, 5}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物打工·宠物协会开启', Show = 1, Acc = 1, Icon = {uiicon = 'Petroom'}},
----------
[1906]={id = 1906, type = 3, text = '厨师等级达到Lv.%s/6', Condition = {cooklv = {6}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物打工·料理协会开启', Show = 1, Acc = 1, Icon = {uiicon = 'Foodroom'}},
----------
[1907]={id = 1907, type = 3, text = '需任意宠物好感度Lv.5并且BaseLv.45', Condition = {unlock = {petlv = {0, 5, 45}, itemid = 5542}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '打工穿梭器 开启', Show = 1, Icon = {itemicon = 'item_5542'}},
----------
[1908]={id = 1908, type = 3, text = '达到BaseLv.70', Condition = {level = 70}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物打工·烹饪中心开启', Show = 1, Icon = {uiicon = 'Cookroom'}},
----------
[3050]={id = 3050, type = 1, PanelID = 1620, text = '执事', Condition = {level = 20}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '执事 已开放', Show = 1, Icon = {uiicon = 'Housekeeper'}, Enterhide = 1},
----------
[5000]={id = 5000, type = 1, PanelID = 547, text = '可获得阿萨神碑', Condition = {quest = {600440001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '阿萨神碑 已开放', Show = 1, Icon = {uiicon = 'Rune'}},
----------
[5001]={id = 5001, type = 3, text = '阿萨神碑·追加进阶二转', Condition = {quest = {600510003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '阿萨神碑追加进阶二转', Show = 1, Icon = {uiicon = 'Rune'}},
----------
[5002]={id = 5002, type = 3, text = '阿萨神碑·追加三转', Condition = {quest = {396530001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '阿萨神碑追加三转', Show = 1, Icon = {uiicon = 'Rune'}},
----------
[6000]={id = 6000, type = 2, PanelID = 6008, text = '完成后解锁预订婚期功能', Condition = {quest = {396030006}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '订婚功能已解锁', Show = 1, Icon = {uiicon = 'lovering'}},
----------
[6001]={id = 6001, type = 2, PanelID = 6013, text = '完成后解锁进入樱花之间功能', Condition = {quest = {396050002}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '樱花之间已开放', Show = 1, Icon = {uiicon = 'lovering'}},
----------
[6010]={id = 6010, type = 3, text = '通关恩德勒斯塔10层·追加便捷通关道具', Condition = {towerlayer = 10}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁古塔·金质弹射器I 购买权限', Show = 1, Acc = 1, Icon = {itemicon = 'item_5580'}},
----------
[6011]={id = 6011, type = 3, text = '通关恩德勒斯塔20层·追加便捷通关道具', Condition = {towerlayer = 20}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁古塔·金质弹射器Ⅱ 购买权限', Show = 1, Acc = 1, Icon = {itemicon = 'item_5581'}},
----------
[6012]={id = 6012, type = 3, text = '通关恩德勒斯塔30层·追加便捷通关道具', Condition = {towerlayer = 30}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁古塔·金质弹射器Ⅲ 购买权限', Show = 1, Acc = 1, Icon = {itemicon = 'item_5582'}},
----------
[6013]={id = 6013, type = 3, text = '通关恩德勒斯塔40层·追加便捷通关道具', Condition = {towerlayer = 40}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁古塔·金质弹射器Ⅳ 购买权限', Show = 1, Acc = 1, Icon = {itemicon = 'item_5583'}},
----------
[6014]={id = 6014, type = 3, text = '通关恩德勒斯塔50层·追加便捷通关道具', Condition = {towerlayer = 50}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁古塔·金质弹射器Ⅴ 购买权限', Show = 1, Acc = 1, Icon = {itemicon = 'item_5584'}},
----------
[6015]={id = 6015, type = 3, text = '通关恩德勒斯塔60层·追加便捷通关道具', Condition = {towerlayer = 60}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁古塔·金质弹射器Ⅵ 购买权限', Show = 1, Acc = 1, Icon = {itemicon = 'item_5585'}},
----------
[6016]={id = 6016, type = 3, text = '通关恩德勒斯塔70层·追加便捷通关道具', Condition = {towerlayer = 70}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '解锁古塔·金质弹射器Ⅶ 购买权限', Show = 1, Acc = 1, Icon = {itemicon = 'item_5586'}},
----------
[8001]={id = 8001, type = 3, text = '南门宠物商店·追加宠物书包', Condition = {pet = {500010, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加宠物书包', Show = 1, Icon = {itemicon = 'item_47031'}},
----------
[8002]={id = 8002, type = 3, text = '南门宠物商店·追加猴子发箍', Condition = {pet = {500030, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加猴子发箍', Show = 1, Icon = {itemicon = 'item_45302'}},
----------
[8003]={id = 8003, type = 3, text = '南门宠物商店·追加宠物围裙', Condition = {pet = {500050, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加宠物围裙', Show = 1, Icon = {itemicon = 'item_45304'}},
----------
[8004]={id = 8004, type = 3, text = '南门宠物商店·追加潜水头盔', Condition = {pet = {500040, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加潜水头盔', Show = 1, Icon = {itemicon = 'item_45273'}},
----------
[8005]={id = 8005, type = 3, text = '南门宠物商店·追加蛇饰发簪', Condition = {pet = {500070, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加蛇饰发簪', Show = 1, Icon = {itemicon = 'item_45033'}},
----------
[8006]={id = 8006, type = 3, text = '南门宠物商店·追加宠物围兜兜', Condition = {pet = {500020, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加宠物围兜兜', Show = 1, Icon = {itemicon = 'item_45301'}},
----------
[8007]={id = 8007, type = 3, text = '南门宠物商店·追加宠物发带', Condition = {pet = {500110, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加宠物发带', Show = 1, Icon = {itemicon = 'item_45069'}},
----------
[8008]={id = 8008, type = 3, text = '南门宠物商店·追加宠物铃铛', Condition = {pet = {500060, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加宠物铃铛', Show = 1, Icon = {itemicon = 'item_45094'}},
----------
[8009]={id = 8009, type = 3, text = '南门宠物商店·追加宠物奶嘴', Condition = {pet = {500080, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加宠物奶嘴', Show = 1, Icon = {itemicon = 'item_48524'}},
----------
[8010]={id = 8010, type = 3, text = '南门宠物商店·追加宠物发夹', Condition = {pet = {500090, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加宠物发夹', Show = 1, Icon = {itemicon = 'item_45052'}},
----------
[8011]={id = 8011, type = 3, text = '南门宠物商店·追加牛骨头盔', Condition = {pet = {500100, 7}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '南门宠物商店·追加牛骨头盔', Show = 1, Icon = {itemicon = 'item_42727'}},
----------
[8100]={id = 8100, type = 3, text = '完成后宠物冒险开放', Condition = {quest = {300310001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物冒险 已开启', Show = 1, Icon = {itemicon = 'item_5504'}},
----------
[8101]={id = 8101, type = 3, text = '完成后宠物打工开放', Condition = {quest = {700030001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物打工 已开启', Icon = {itemicon = 'item_5542'}},
----------
[9000]={id = 9000, type = 3, PanelID = 485, text = '导师系统开放', Condition = {level = 10}, event = _EmptyTable, sysMsg = {id = 3200}, Tip = '导师系统 已开启', Show = 1, Icon = {itemicon = 'item_5506'}},
----------
[9001]={id = 9001, type = 3, text = '完成后可成为导师', Condition = {quest = {391010001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '恭喜！进阶为导师', Show = 1, Icon = {itemicon = 'item_5506'}},
----------
[9002]={id = 9002, type = 3, text = '成为导师后追加新美瞳', Condition = {achieve = {1206001}}, event = {type = 'unlockeye', param = {46531, 46587}}, sysMsg = _EmptyTable, Tip = '美瞳商店追加新美瞳', Show = 1, Icon = {uiicon = 'Girl2'}},
[9101]={id = 9101, text = '追加新美瞳爱丽丝·绿', Condition = {other = 1}, event = {type = 'unlockeye', param = {46500, 46556}}},
[9102]={id = 9102, text = '追加新美瞳爱丽丝·红', Condition = {other = 1}, event = {type = 'unlockeye', param = {46501, 46557}}},
[9103]={id = 9103, text = '追加新美瞳爱丽丝·黑', Condition = {other = 1}, event = {type = 'unlockeye', param = {46502, 46558}}},
[9104]={id = 9104, text = '追加新美瞳爱丽丝·白', Condition = {other = 1}, event = {type = 'unlockeye', param = {46503, 46559}}},
[9105]={id = 9105, text = '追加新美瞳爱丽丝·紫', Condition = {other = 1}, event = {type = 'unlockeye', param = {46504, 46560}}},
[9106]={id = 9106, text = '追加新美瞳爱丽丝·黄', Condition = {other = 1}, event = {type = 'unlockeye', param = {46505, 46561}}},
[9107]={id = 9107, text = '追加新美瞳爱丽丝·蓝', Condition = {other = 1}, event = {type = 'unlockeye', param = {46506, 46562}}},
[9108]={id = 9108, text = '追加新美瞳爱丽丝·棕', Condition = {other = 1}, event = {type = 'unlockeye', param = {46507, 46563}}},
[9109]={id = 9109, text = '追加新美瞳黄金午后·绿', Condition = {other = 1}, event = {type = 'unlockeye', param = {46508, 46564}}},
[9110]={id = 9110, text = '追加新美瞳黄金午后·红', Condition = {other = 1}, event = {type = 'unlockeye', param = {46509, 46565}}},
[9111]={id = 9111, text = '追加新美瞳黄金午后·黑', Condition = {other = 1}, event = {type = 'unlockeye', param = {46510, 46566}}},
[9112]={id = 9112, text = '追加新美瞳黄金午后·白', Condition = {other = 1}, event = {type = 'unlockeye', param = {46511, 46567}}},
[9113]={id = 9113, text = '追加新美瞳黄金午后·紫', Condition = {other = 1}, event = {type = 'unlockeye', param = {46512, 46568}}},
[9114]={id = 9114, text = '追加新美瞳黄金午后·黄', Condition = {other = 1}, event = {type = 'unlockeye', param = {46513, 46569}}},
[9115]={id = 9115, text = '追加新美瞳黄金午后·蓝', Condition = {other = 1}, event = {type = 'unlockeye', param = {46514, 46570}}},
[9116]={id = 9116, text = '追加新美瞳黄金午后·棕', Condition = {other = 1}, event = {type = 'unlockeye', param = {46515, 46571}}},
[9117]={id = 9117, text = '追加新美瞳人鱼之心·绿', Condition = {other = 1}, event = {type = 'unlockeye', param = {46516, 46572}}},
[9118]={id = 9118, text = '追加新美瞳人鱼之心·红', Condition = {other = 1}, event = {type = 'unlockeye', param = {46517, 46573}}},
[9119]={id = 9119, text = '追加新美瞳人鱼之心·黑', Condition = {other = 1}, event = {type = 'unlockeye', param = {46518, 46574}}},
[9120]={id = 9120, text = '追加新美瞳人鱼之心·白', Condition = {other = 1}, event = {type = 'unlockeye', param = {46519, 46575}}},
[9121]={id = 9121, text = '追加新美瞳人鱼之心·紫', Condition = {other = 1}, event = {type = 'unlockeye', param = {46520, 46576}}},
[9122]={id = 9122, text = '追加新美瞳人鱼之心·黄', Condition = {other = 1}, event = {type = 'unlockeye', param = {46521, 46577}}},
[9123]={id = 9123, text = '追加新美瞳人鱼之心·蓝', Condition = {other = 1}, event = {type = 'unlockeye', param = {46522, 46578}}},
[9124]={id = 9124, text = '追加新美瞳人鱼之心·棕', Condition = {other = 1}, event = {type = 'unlockeye', param = {46523, 46579}}},
[9125]={id = 9125, text = '追加新美瞳时之轮·绿', Condition = {other = 1}, event = {type = 'unlockeye', param = {46524, 46580}}},
[9126]={id = 9126, text = '追加新美瞳时之轮·红', Condition = {other = 1}, event = {type = 'unlockeye', param = {46525, 46581}}},
[9127]={id = 9127, text = '追加新美瞳时之轮·黑', Condition = {other = 1}, event = {type = 'unlockeye', param = {46526, 46582}}},
[9128]={id = 9128, text = '追加新美瞳时之轮·白', Condition = {other = 1}, event = {type = 'unlockeye', param = {46527, 46583}}},
[9129]={id = 9129, text = '追加新美瞳时之轮·紫', Condition = {other = 1}, event = {type = 'unlockeye', param = {46528, 46584}}},
[9130]={id = 9130, text = '追加新美瞳时之轮·黄', Condition = {other = 1}, event = {type = 'unlockeye', param = {46529, 46585}}},
[9131]={id = 9131, text = '追加新美瞳时之轮·蓝', Condition = {other = 1}, event = {type = 'unlockeye', param = {46530, 46586}}},
[9132]={id = 9132, text = '追加新美瞳时之轮·棕', Condition = {other = 1}},
[9133]={id = 9133, text = '追加新美瞳夜之狂想·绿', Condition = {other = 1}, event = {type = 'unlockeye', param = {46532, 46588}}},
[9134]={id = 9134, text = '追加新美瞳夜之狂想·红', Condition = {other = 1}, event = {type = 'unlockeye', param = {46533, 46589}}},
[9135]={id = 9135, text = '追加新美瞳夜之狂想·黑', Condition = {other = 1}, event = {type = 'unlockeye', param = {46534, 46590}}},
[9136]={id = 9136, text = '追加新美瞳夜之狂想·白', Condition = {other = 1}, event = {type = 'unlockeye', param = {46535, 46591}}},
[9137]={id = 9137, text = '追加新美瞳夜之狂想·紫', Condition = {other = 1}, event = {type = 'unlockeye', param = {46536, 46592}}},
[9138]={id = 9138, text = '追加新美瞳夜之狂想·黄', Condition = {other = 1}, event = {type = 'unlockeye', param = {46537, 46593}}},
[9139]={id = 9139, text = '追加新美瞳夜之狂想·蓝', Condition = {other = 1}, event = {type = 'unlockeye', param = {46538, 46594}}},
[9140]={id = 9140, text = '追加新美瞳夜之狂想·棕', Condition = {other = 1}, event = {type = 'unlockeye', param = {46539, 46595}}},
[9141]={id = 9141, text = '追加新美瞳宇宙之风·绿', Condition = {other = 1}, event = {type = 'unlockeye', param = {46540, 46596}}},
[9142]={id = 9142, text = '追加新美瞳宇宙之风·红', Condition = {other = 1}, event = {type = 'unlockeye', param = {46541, 46597}}},
[9143]={id = 9143, text = '追加新美瞳宇宙之风·黑', Condition = {other = 1}, event = {type = 'unlockeye', param = {46542, 46598}}},
[9144]={id = 9144, text = '追加新美瞳宇宙之风·白', Condition = {other = 1}, event = {type = 'unlockeye', param = {46543, 46599}}},
[9145]={id = 9145, text = '追加新美瞳宇宙之风·紫', Condition = {other = 1}, event = {type = 'unlockeye', param = {46544, 46600}}},
[9146]={id = 9146, text = '追加新美瞳宇宙之风·黄', Condition = {other = 1}, event = {type = 'unlockeye', param = {46545, 46601}}},
[9147]={id = 9147, text = '追加新美瞳宇宙之风·蓝', Condition = {other = 1}, event = {type = 'unlockeye', param = {46546, 46602}}},
[9148]={id = 9148, text = '追加新美瞳宇宙之风·棕', Condition = {other = 1}, event = {type = 'unlockeye', param = {46547, 46603}}},
[9149]={id = 9149, text = '追加新美瞳朝之幻想·绿', Condition = {other = 1}, event = {type = 'unlockeye', param = {46548, 46604}}},
[9150]={id = 9150, text = '追加新美瞳朝之幻想·红', Condition = {other = 1}, event = {type = 'unlockeye', param = {46549, 46605}}},
[9151]={id = 9151, text = '追加新美瞳朝之幻想·黑', Condition = {other = 1}, event = {type = 'unlockeye', param = {46550, 46606}}},
[9152]={id = 9152, text = '追加新美瞳朝之幻想·白', Condition = {other = 1}, event = {type = 'unlockeye', param = {46551, 46607}}},
[9153]={id = 9153, text = '追加新美瞳朝之幻想·紫', Condition = {other = 1}, event = {type = 'unlockeye', param = {46552, 46608}}},
[9154]={id = 9154, text = '追加新美瞳朝之幻想·黄', Condition = {other = 1}, event = {type = 'unlockeye', param = {46553, 46609}}},
[9155]={id = 9155, text = '追加新美瞳朝之幻想·蓝', Condition = {other = 1}, event = {type = 'unlockeye', param = {46554, 46610}}},
[9156]={id = 9156, text = '追加新美瞳朝之幻想·棕', Condition = {other = 1}, event = {type = 'unlockeye', param = {46555, 46611}}},
[9157]={id = 9157, text = '追加新美瞳秋之喜悦·枫叶', Condition = {other = 1}, event = {type = 'unlockeye', param = {46616, 46620}}},
[9158]={id = 9158, text = '追加新美瞳秋之喜悦·麦田', Condition = {other = 1}, event = {type = 'unlockeye', param = {46617, 46621}}},
[9159]={id = 9159, text = '追加新美瞳秋之喜悦·软糖', Condition = {other = 1}, event = {type = 'unlockeye', param = {46618, 46622}}},
[9160]={id = 9160, text = '追加新美瞳秋之喜悦·金焰', Condition = {other = 1}, event = {type = 'unlockeye', param = {46619, 46623}}},
[9170]={id = 9170, text = '追加新美瞳白色恋季', Condition = {other = 1}, event = {type = 'unlockeye', param = {46626, 46627}}},
[9180]={id = 9180, text = '追加新美瞳炽热馈赠', Condition = {other = 1}, event = {type = 'unlockeye', param = {46628, 46632}}},
[9190]={id = 9190, text = '追加新美瞳静谧回响', Condition = {other = 1}, event = {type = 'unlockeye', param = {46629, 46633}}},
[9200]={id = 9200, text = '追加新美瞳水色祝福', Condition = {other = 1}, event = {type = 'unlockeye', param = {46630, 46634}}},
[9210]={id = 9210, text = '追加新美瞳禁忌凝视', Condition = {other = 1}, event = {type = 'unlockeye', param = {46631, 46635}}},
----------
[9003]={id = 9003, type = 2, PanelID = 960, text = '成为C级冒险家后开启美瞳', Condition = {title = {1006}}, event = _EmptyTable, sysMsg = {id = 816}, Tip = '普隆德拉·美瞳商店开启', Show = 1, Icon = {uiicon = 'Girl2'}},
----------
[9005]={id = 9005, type = 3, text = '学习时空断裂解锁存档功能', Condition = {skill = {50053001}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '伊米尔的记事簿 已开放', Show = 1, Acc = 1, Icon = {uiicon = 'Part'}},
----------
[9006]={id = 9006, type = 3, text = '达成进阶二转开启多职业功能', Condition = {evo = 3}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '多职业功能 已开启', Show = 1, Icon = {uiicon = 'Part'}},
----------
[9011]={id = 9011, type = 3, text = '斐扬微笑小姐·追加人鱼之心·白礼盒', Condition = {level = 75}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '斐扬微笑小姐·追加人鱼之心·白礼盒', Show = 1, Icon = {itemicon = 'Eye_23_4'}},
----------
[9012]={id = 9012, type = 3, text = '艾尔帕兰微笑小姐·追加朝之幻想·蓝礼盒', Condition = {level = 95}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '艾尔帕兰微笑小姐·追加朝之幻想·蓝礼盒', Show = 1, Icon = {itemicon = 'Eye_27_7'}},
----------
[9013]={id = 9013, type = 3, text = '姜饼城微笑小姐·追加时之轮·红礼盒', Condition = {quest = {601700003}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '姜饼城微笑小姐·追加时之轮·红礼盒', Show = 1, Icon = {itemicon = 'Eye_24_2'}},
----------
[9300]={id = 9300, type = 3, text = '达到角色三转', Condition = {evo = 4}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '服装店功能·开启', Show = 1, Icon = {uiicon = 'Couture_Clothes'}},
----------
[9301]={id = 9301, type = 3, text = '追加新服装矢车菊·藏蓝', Condition = {title = {1007}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '服装商店追加新服装', Show = 1, Icon = {itemicon = 'item_3927'}},
[9302]={id = 9302, text = '追加新服装忘忧草·橙色', Condition = {quest = {201420004}}},
[9303]={id = 9303, text = '追加新服装酢浆草·紫红', Condition = {wedding = 2}},
[9304]={id = 9304, text = '追加新服装木绣球·蓝绿', Condition = {pro = {count = 3}}},
[9305]={id = 9305, text = '追加新服装野蔷薇·玫红', Condition = {other = 1}},
[9306]={id = 9306, text = '追加新服装金盏花·雌黄', Condition = {other = 1}},
[9307]={id = 9307, text = '追加新服装薰衣草·淡紫', Condition = {other = 1}},
[9308]={id = 9308, text = '追加新服装玄英子·黛黑', Condition = {other = 1}},
[9309]={id = 9309, text = '追加新服装风信子·浅驼', Condition = {other = 1}},
[9310]={id = 9310, text = '追加新服装芬落香·樱花', Condition = {other = 1}},
[9311]={id = 9311, text = '追加新服装玉兰花·银白', Condition = {other = 1}},
----------
[9500]={id = 9500, type = 3, text = '已解锁3张限定特典', Condition = {manualunlock = {{0, 3}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁3张限定特典', Acc = 1, Icon = _EmptyTable},
[100003]={id = 100003},
----------
[9501]={id = 9501, type = 3, text = '已解锁5张限定特典', Condition = {manualunlock = {{0, 5}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁5张限定特典', Acc = 1, Icon = _EmptyTable},
----------
[9502]={id = 9502, type = 3, text = '已解锁7张限定特典', Condition = {manualunlock = {{0, 7}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁7张限定特典', Acc = 1, Icon = _EmptyTable},
----------
[9503]={id = 9503, type = 3, text = '已解锁10张限定特典', Condition = {manualunlock = {{0, 10}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁10张限定特典', Acc = 1, Icon = _EmptyTable},
----------
[9504]={id = 9504, type = 3, text = '已解锁20个头饰', Condition = {manualunlock = {{1, 20}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁20个头饰', Acc = 1, Icon = _EmptyTable},
----------
[9505]={id = 9505, type = 3, text = '已解锁30张头饰', Condition = {manualunlock = {{1, 30}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁30张头饰', Acc = 1, Icon = _EmptyTable},
----------
[9506]={id = 9506, type = 3, text = '已解锁40张头饰', Condition = {manualunlock = {{1, 40}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁40张头饰', Acc = 1, Icon = _EmptyTable},
----------
[9507]={id = 9507, type = 3, text = '已解锁50张头饰', Condition = {manualunlock = {{1, 50}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁50张头饰', Acc = 1, Icon = _EmptyTable},
----------
[9508]={id = 9508, type = 3, text = '已解锁60张头饰', Condition = {manualunlock = {{1, 60}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁60张头饰', Acc = 1, Icon = _EmptyTable},
----------
[9509]={id = 9509, type = 3, text = '已解锁80张头饰', Condition = {manualunlock = {{1, 80}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁80张头饰', Acc = 1, Icon = _EmptyTable},
----------
[9510]={id = 9510, type = 3, text = '冒险手册中激活%s/5个头饰', Condition = {manualunlock = {{1, 5}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '宠物打工·微笑小姐开启', Show = 1, Acc = 1, Icon = {uiicon = 'Missroom'}},
----------
[9600]={id = 9600, type = 3, text = '祈祷卡片包购买次数+1', Condition = {achieve = {1203044}}, event = {type = 'add_shop_cnt', param = {1801000, 1}}, sysMsg = _EmptyTable, Tip = '祈祷卡片包购买次数+1', Show = 1, Acc = 1, Icon = {itemicon = 'item_3862'}},
[9601]={id = 9601, Condition = {achieve = {1203045}}},
[9602]={id = 9602, Condition = {achieve = {1203046}}},
[9603]={id = 9603, Condition = {achieve = {1203047}}},
[9604]={id = 9604, Condition = {achieve = {1203048}}},
[9605]={id = 9605, Condition = {achieve = {1203049}}},
[9606]={id = 9606, Condition = {achieve = {1203050}}},
[9607]={id = 9607, Condition = {achieve = {1203051}}},
[9608]={id = 9608, Condition = {achieve = {1203052}}},
[9609]={id = 9609, Condition = {achieve = {1203053}}},
----------
[9610]={id = 9610, type = 3, text = '祈祷卡片包购买次数+2', Condition = {achieve = {1203054}}, event = {type = 'add_shop_cnt', param = {1801000, 2}}, sysMsg = _EmptyTable, Tip = '祈祷卡片包购买次数+2', Show = 1, Acc = 1, Icon = {itemicon = 'item_3862'}},
----------
[9611]={id = 9611, type = 3, text = '祈祷卡片包购买次数+3', Condition = {achieve = {1203055}}, event = {type = 'add_shop_cnt', param = {1801000, 3}}, sysMsg = _EmptyTable, Tip = '祈祷卡片包购买次数+3', Show = 1, Acc = 1, Icon = {itemicon = 'item_3862'}},
----------
[100001]={id = 100001, type = 3, text = '已解锁1张限定特典', Condition = {manualunlock = {{0, 1}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁1张限定特典', Acc = 1, Icon = _EmptyTable},
----------
[100002]={id = 100002, type = 3, text = '已解锁2张限定特典', Condition = {manualunlock = {{0, 2}}}, event = _EmptyTable, sysMsg = _EmptyTable, Tip = '已解锁2张限定特典', Acc = 1, Icon = _EmptyTable},
----------
}
setmetatable(Table_Menu[2001],{__index = Table_Menu[3]})
setmetatable(Table_Menu[2002],{__index = Table_Menu[3]})
setmetatable(Table_Menu[11],{__index = Table_Menu[10]})
setmetatable(Table_Menu[12],{__index = Table_Menu[10]})
setmetatable(Table_Menu[13],{__index = Table_Menu[10]})
setmetatable(Table_Menu[14],{__index = Table_Menu[10]})
setmetatable(Table_Menu[15],{__index = Table_Menu[10]})
setmetatable(Table_Menu[52],{__index = Table_Menu[51]})
setmetatable(Table_Menu[713],{__index = Table_Menu[51]})
setmetatable(Table_Menu[714],{__index = Table_Menu[51]})
setmetatable(Table_Menu[715],{__index = Table_Menu[51]})
setmetatable(Table_Menu[716],{__index = Table_Menu[51]})
setmetatable(Table_Menu[750],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1201],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1402],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1404],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1406],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1407],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1408],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1410],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1411],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1412],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1413],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1414],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1415],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1416],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1417],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1418],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1419],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1420],{__index = Table_Menu[51]})
setmetatable(Table_Menu[1421],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3001],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3002],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3003],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3004],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3005],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3006],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3007],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3008],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3009],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3010],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3011],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3012],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3013],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3014],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3015],{__index = Table_Menu[51]})
setmetatable(Table_Menu[4033],{__index = Table_Menu[51]})
setmetatable(Table_Menu[4034],{__index = Table_Menu[51]})
setmetatable(Table_Menu[4035],{__index = Table_Menu[51]})
setmetatable(Table_Menu[4036],{__index = Table_Menu[51]})
setmetatable(Table_Menu[4037],{__index = Table_Menu[51]})
setmetatable(Table_Menu[4038],{__index = Table_Menu[51]})
setmetatable(Table_Menu[4039],{__index = Table_Menu[51]})
setmetatable(Table_Menu[4040],{__index = Table_Menu[51]})
setmetatable(Table_Menu[100000],{__index = Table_Menu[51]})
setmetatable(Table_Menu[3000000],{__index = Table_Menu[51]})
setmetatable(Table_Menu[88],{__index = Table_Menu[87]})
setmetatable(Table_Menu[89],{__index = Table_Menu[87]})
setmetatable(Table_Menu[90],{__index = Table_Menu[87]})
setmetatable(Table_Menu[91],{__index = Table_Menu[87]})
setmetatable(Table_Menu[92],{__index = Table_Menu[87]})
setmetatable(Table_Menu[93],{__index = Table_Menu[87]})
setmetatable(Table_Menu[94],{__index = Table_Menu[87]})
setmetatable(Table_Menu[180],{__index = Table_Menu[87]})
setmetatable(Table_Menu[527],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1101],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1106],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1112],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1113],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1115],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1116],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1117],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1118],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1119],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1120],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1501],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1503],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1506],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1509],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1513],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1522],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1523],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1524],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1543],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1544],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1554],{__index = Table_Menu[87]})
setmetatable(Table_Menu[1901],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4001],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4002],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4003],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4004],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4005],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4006],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4007],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4008],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4009],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4010],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4011],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4012],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4013],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4014],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4015],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4016],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4017],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4018],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4019],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4020],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4021],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4022],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4023],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4024],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4025],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4026],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4027],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4028],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4029],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4030],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4031],{__index = Table_Menu[87]})
setmetatable(Table_Menu[4032],{__index = Table_Menu[87]})
setmetatable(Table_Menu[96],{__index = Table_Menu[95]})
setmetatable(Table_Menu[97],{__index = Table_Menu[95]})
setmetatable(Table_Menu[98],{__index = Table_Menu[95]})
setmetatable(Table_Menu[99],{__index = Table_Menu[95]})
setmetatable(Table_Menu[100],{__index = Table_Menu[95]})
setmetatable(Table_Menu[105],{__index = Table_Menu[104]})
setmetatable(Table_Menu[106],{__index = Table_Menu[104]})
setmetatable(Table_Menu[108],{__index = Table_Menu[104]})
setmetatable(Table_Menu[109],{__index = Table_Menu[104]})
setmetatable(Table_Menu[110],{__index = Table_Menu[104]})
setmetatable(Table_Menu[114],{__index = Table_Menu[104]})
setmetatable(Table_Menu[115],{__index = Table_Menu[104]})
setmetatable(Table_Menu[117],{__index = Table_Menu[104]})
setmetatable(Table_Menu[119],{__index = Table_Menu[104]})
setmetatable(Table_Menu[120],{__index = Table_Menu[104]})
setmetatable(Table_Menu[123],{__index = Table_Menu[104]})
setmetatable(Table_Menu[124],{__index = Table_Menu[104]})
setmetatable(Table_Menu[125],{__index = Table_Menu[104]})
setmetatable(Table_Menu[126],{__index = Table_Menu[104]})
setmetatable(Table_Menu[127],{__index = Table_Menu[104]})
setmetatable(Table_Menu[128],{__index = Table_Menu[104]})
setmetatable(Table_Menu[129],{__index = Table_Menu[104]})
setmetatable(Table_Menu[130],{__index = Table_Menu[104]})
setmetatable(Table_Menu[131],{__index = Table_Menu[104]})
setmetatable(Table_Menu[132],{__index = Table_Menu[104]})
setmetatable(Table_Menu[134],{__index = Table_Menu[104]})
setmetatable(Table_Menu[135],{__index = Table_Menu[104]})
setmetatable(Table_Menu[137],{__index = Table_Menu[104]})
setmetatable(Table_Menu[138],{__index = Table_Menu[104]})
setmetatable(Table_Menu[139],{__index = Table_Menu[104]})
setmetatable(Table_Menu[140],{__index = Table_Menu[104]})
setmetatable(Table_Menu[141],{__index = Table_Menu[104]})
setmetatable(Table_Menu[142],{__index = Table_Menu[104]})
setmetatable(Table_Menu[143],{__index = Table_Menu[104]})
setmetatable(Table_Menu[144],{__index = Table_Menu[104]})
setmetatable(Table_Menu[145],{__index = Table_Menu[104]})
setmetatable(Table_Menu[111],{__index = Table_Menu[107]})
setmetatable(Table_Menu[112],{__index = Table_Menu[107]})
setmetatable(Table_Menu[113],{__index = Table_Menu[107]})
setmetatable(Table_Menu[116],{__index = Table_Menu[107]})
setmetatable(Table_Menu[118],{__index = Table_Menu[107]})
setmetatable(Table_Menu[121],{__index = Table_Menu[107]})
setmetatable(Table_Menu[122],{__index = Table_Menu[107]})
setmetatable(Table_Menu[146],{__index = Table_Menu[107]})
setmetatable(Table_Menu[203],{__index = Table_Menu[202]})
setmetatable(Table_Menu[204],{__index = Table_Menu[202]})
setmetatable(Table_Menu[205],{__index = Table_Menu[202]})
setmetatable(Table_Menu[206],{__index = Table_Menu[202]})
setmetatable(Table_Menu[207],{__index = Table_Menu[202]})
setmetatable(Table_Menu[208],{__index = Table_Menu[202]})
setmetatable(Table_Menu[209],{__index = Table_Menu[202]})
setmetatable(Table_Menu[210],{__index = Table_Menu[202]})
setmetatable(Table_Menu[214],{__index = Table_Menu[202]})
setmetatable(Table_Menu[216],{__index = Table_Menu[202]})
setmetatable(Table_Menu[217],{__index = Table_Menu[202]})
setmetatable(Table_Menu[218],{__index = Table_Menu[202]})
setmetatable(Table_Menu[219],{__index = Table_Menu[202]})
setmetatable(Table_Menu[220],{__index = Table_Menu[202]})
setmetatable(Table_Menu[221],{__index = Table_Menu[202]})
setmetatable(Table_Menu[222],{__index = Table_Menu[202]})
setmetatable(Table_Menu[225],{__index = Table_Menu[224]})
setmetatable(Table_Menu[226],{__index = Table_Menu[224]})
setmetatable(Table_Menu[227],{__index = Table_Menu[224]})
setmetatable(Table_Menu[302],{__index = Table_Menu[301]})
setmetatable(Table_Menu[303],{__index = Table_Menu[301]})
setmetatable(Table_Menu[304],{__index = Table_Menu[301]})
setmetatable(Table_Menu[305],{__index = Table_Menu[301]})
setmetatable(Table_Menu[306],{__index = Table_Menu[301]})
setmetatable(Table_Menu[307],{__index = Table_Menu[301]})
setmetatable(Table_Menu[308],{__index = Table_Menu[301]})
setmetatable(Table_Menu[309],{__index = Table_Menu[301]})
setmetatable(Table_Menu[310],{__index = Table_Menu[301]})
setmetatable(Table_Menu[313],{__index = Table_Menu[301]})
setmetatable(Table_Menu[314],{__index = Table_Menu[301]})
setmetatable(Table_Menu[315],{__index = Table_Menu[301]})
setmetatable(Table_Menu[316],{__index = Table_Menu[301]})
setmetatable(Table_Menu[317],{__index = Table_Menu[301]})
setmetatable(Table_Menu[318],{__index = Table_Menu[301]})
setmetatable(Table_Menu[319],{__index = Table_Menu[301]})
setmetatable(Table_Menu[320],{__index = Table_Menu[301]})
setmetatable(Table_Menu[321],{__index = Table_Menu[301]})
setmetatable(Table_Menu[322],{__index = Table_Menu[301]})
setmetatable(Table_Menu[324],{__index = Table_Menu[301]})
setmetatable(Table_Menu[325],{__index = Table_Menu[301]})
setmetatable(Table_Menu[326],{__index = Table_Menu[301]})
setmetatable(Table_Menu[327],{__index = Table_Menu[301]})
setmetatable(Table_Menu[329],{__index = Table_Menu[301]})
setmetatable(Table_Menu[331],{__index = Table_Menu[301]})
setmetatable(Table_Menu[332],{__index = Table_Menu[301]})
setmetatable(Table_Menu[335],{__index = Table_Menu[301]})
setmetatable(Table_Menu[336],{__index = Table_Menu[301]})
setmetatable(Table_Menu[337],{__index = Table_Menu[301]})
setmetatable(Table_Menu[338],{__index = Table_Menu[301]})
setmetatable(Table_Menu[339],{__index = Table_Menu[301]})
setmetatable(Table_Menu[340],{__index = Table_Menu[301]})
setmetatable(Table_Menu[342],{__index = Table_Menu[301]})
setmetatable(Table_Menu[343],{__index = Table_Menu[301]})
setmetatable(Table_Menu[347],{__index = Table_Menu[301]})
setmetatable(Table_Menu[348],{__index = Table_Menu[301]})
setmetatable(Table_Menu[350],{__index = Table_Menu[301]})
setmetatable(Table_Menu[351],{__index = Table_Menu[301]})
setmetatable(Table_Menu[352],{__index = Table_Menu[301]})
setmetatable(Table_Menu[353],{__index = Table_Menu[301]})
setmetatable(Table_Menu[354],{__index = Table_Menu[301]})
setmetatable(Table_Menu[356],{__index = Table_Menu[301]})
setmetatable(Table_Menu[358],{__index = Table_Menu[301]})
setmetatable(Table_Menu[359],{__index = Table_Menu[301]})
setmetatable(Table_Menu[362],{__index = Table_Menu[301]})
setmetatable(Table_Menu[363],{__index = Table_Menu[301]})
setmetatable(Table_Menu[364],{__index = Table_Menu[301]})
setmetatable(Table_Menu[365],{__index = Table_Menu[301]})
setmetatable(Table_Menu[366],{__index = Table_Menu[301]})
setmetatable(Table_Menu[368],{__index = Table_Menu[301]})
setmetatable(Table_Menu[369],{__index = Table_Menu[301]})
setmetatable(Table_Menu[371],{__index = Table_Menu[301]})
setmetatable(Table_Menu[372],{__index = Table_Menu[301]})
setmetatable(Table_Menu[374],{__index = Table_Menu[301]})
setmetatable(Table_Menu[379],{__index = Table_Menu[301]})
setmetatable(Table_Menu[382],{__index = Table_Menu[301]})
setmetatable(Table_Menu[389],{__index = Table_Menu[301]})
setmetatable(Table_Menu[391],{__index = Table_Menu[301]})
setmetatable(Table_Menu[392],{__index = Table_Menu[301]})
setmetatable(Table_Menu[393],{__index = Table_Menu[301]})
setmetatable(Table_Menu[397],{__index = Table_Menu[301]})
setmetatable(Table_Menu[398],{__index = Table_Menu[301]})
setmetatable(Table_Menu[399],{__index = Table_Menu[301]})
setmetatable(Table_Menu[312],{__index = Table_Menu[311]})
setmetatable(Table_Menu[323],{__index = Table_Menu[311]})
setmetatable(Table_Menu[328],{__index = Table_Menu[311]})
setmetatable(Table_Menu[330],{__index = Table_Menu[311]})
setmetatable(Table_Menu[333],{__index = Table_Menu[311]})
setmetatable(Table_Menu[334],{__index = Table_Menu[311]})
setmetatable(Table_Menu[341],{__index = Table_Menu[311]})
setmetatable(Table_Menu[344],{__index = Table_Menu[311]})
setmetatable(Table_Menu[345],{__index = Table_Menu[311]})
setmetatable(Table_Menu[346],{__index = Table_Menu[311]})
setmetatable(Table_Menu[349],{__index = Table_Menu[311]})
setmetatable(Table_Menu[355],{__index = Table_Menu[311]})
setmetatable(Table_Menu[357],{__index = Table_Menu[311]})
setmetatable(Table_Menu[360],{__index = Table_Menu[311]})
setmetatable(Table_Menu[361],{__index = Table_Menu[311]})
setmetatable(Table_Menu[367],{__index = Table_Menu[311]})
setmetatable(Table_Menu[370],{__index = Table_Menu[311]})
setmetatable(Table_Menu[373],{__index = Table_Menu[311]})
setmetatable(Table_Menu[375],{__index = Table_Menu[311]})
setmetatable(Table_Menu[376],{__index = Table_Menu[311]})
setmetatable(Table_Menu[377],{__index = Table_Menu[311]})
setmetatable(Table_Menu[378],{__index = Table_Menu[311]})
setmetatable(Table_Menu[380],{__index = Table_Menu[311]})
setmetatable(Table_Menu[381],{__index = Table_Menu[311]})
setmetatable(Table_Menu[383],{__index = Table_Menu[311]})
setmetatable(Table_Menu[384],{__index = Table_Menu[311]})
setmetatable(Table_Menu[385],{__index = Table_Menu[311]})
setmetatable(Table_Menu[386],{__index = Table_Menu[311]})
setmetatable(Table_Menu[387],{__index = Table_Menu[311]})
setmetatable(Table_Menu[388],{__index = Table_Menu[311]})
setmetatable(Table_Menu[390],{__index = Table_Menu[311]})
setmetatable(Table_Menu[394],{__index = Table_Menu[311]})
setmetatable(Table_Menu[395],{__index = Table_Menu[311]})
setmetatable(Table_Menu[396],{__index = Table_Menu[311]})
setmetatable(Table_Menu[400],{__index = Table_Menu[311]})
setmetatable(Table_Menu[709],{__index = Table_Menu[632]})
setmetatable(Table_Menu[710],{__index = Table_Menu[632]})
setmetatable(Table_Menu[711],{__index = Table_Menu[632]})
setmetatable(Table_Menu[712],{__index = Table_Menu[632]})
setmetatable(Table_Menu[641],{__index = Table_Menu[640]})
setmetatable(Table_Menu[702],{__index = Table_Menu[701]})
setmetatable(Table_Menu[703],{__index = Table_Menu[701]})
setmetatable(Table_Menu[704],{__index = Table_Menu[701]})
setmetatable(Table_Menu[705],{__index = Table_Menu[701]})
setmetatable(Table_Menu[706],{__index = Table_Menu[701]})
setmetatable(Table_Menu[720],{__index = Table_Menu[701]})
setmetatable(Table_Menu[721],{__index = Table_Menu[701]})
setmetatable(Table_Menu[722],{__index = Table_Menu[701]})
setmetatable(Table_Menu[723],{__index = Table_Menu[701]})
setmetatable(Table_Menu[724],{__index = Table_Menu[701]})
setmetatable(Table_Menu[725],{__index = Table_Menu[701]})
setmetatable(Table_Menu[708],{__index = Table_Menu[707]})
setmetatable(Table_Menu[719],{__index = Table_Menu[717]})
setmetatable(Table_Menu[903],{__index = Table_Menu[901]})
setmetatable(Table_Menu[904],{__index = Table_Menu[901]})
setmetatable(Table_Menu[905],{__index = Table_Menu[902]})
setmetatable(Table_Menu[906],{__index = Table_Menu[902]})
setmetatable(Table_Menu[911],{__index = Table_Menu[910]})
setmetatable(Table_Menu[912],{__index = Table_Menu[910]})
setmetatable(Table_Menu[913],{__index = Table_Menu[910]})
setmetatable(Table_Menu[914],{__index = Table_Menu[910]})
setmetatable(Table_Menu[915],{__index = Table_Menu[910]})
setmetatable(Table_Menu[917],{__index = Table_Menu[910]})
setmetatable(Table_Menu[918],{__index = Table_Menu[910]})
setmetatable(Table_Menu[919],{__index = Table_Menu[910]})
setmetatable(Table_Menu[920],{__index = Table_Menu[910]})
setmetatable(Table_Menu[921],{__index = Table_Menu[910]})
setmetatable(Table_Menu[922],{__index = Table_Menu[910]})
setmetatable(Table_Menu[923],{__index = Table_Menu[910]})
setmetatable(Table_Menu[924],{__index = Table_Menu[910]})
setmetatable(Table_Menu[925],{__index = Table_Menu[910]})
setmetatable(Table_Menu[926],{__index = Table_Menu[910]})
setmetatable(Table_Menu[927],{__index = Table_Menu[910]})
setmetatable(Table_Menu[928],{__index = Table_Menu[910]})
setmetatable(Table_Menu[1405],{__index = Table_Menu[1403]})
setmetatable(Table_Menu[1409],{__index = Table_Menu[1403]})
setmetatable(Table_Menu[1571],{__index = Table_Menu[1565]})
setmetatable(Table_Menu[9101],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9102],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9103],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9104],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9105],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9106],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9107],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9108],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9109],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9110],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9111],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9112],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9113],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9114],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9115],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9116],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9117],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9118],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9119],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9120],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9121],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9122],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9123],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9124],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9125],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9126],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9127],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9128],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9129],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9130],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9131],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9132],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9133],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9134],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9135],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9136],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9137],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9138],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9139],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9140],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9141],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9142],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9143],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9144],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9145],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9146],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9147],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9148],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9149],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9150],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9151],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9152],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9153],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9154],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9155],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9156],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9157],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9158],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9159],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9160],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9170],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9180],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9190],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9200],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9210],{__index = Table_Menu[9002]})
setmetatable(Table_Menu[9302],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9303],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9304],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9305],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9306],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9307],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9308],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9309],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9310],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[9311],{__index = Table_Menu[9301]})
setmetatable(Table_Menu[100003],{__index = Table_Menu[9500]})
setmetatable(Table_Menu[9601],{__index = Table_Menu[9600]})
setmetatable(Table_Menu[9602],{__index = Table_Menu[9600]})
setmetatable(Table_Menu[9603],{__index = Table_Menu[9600]})
setmetatable(Table_Menu[9604],{__index = Table_Menu[9600]})
setmetatable(Table_Menu[9605],{__index = Table_Menu[9600]})
setmetatable(Table_Menu[9606],{__index = Table_Menu[9600]})
setmetatable(Table_Menu[9607],{__index = Table_Menu[9600]})
setmetatable(Table_Menu[9608],{__index = Table_Menu[9600]})
setmetatable(Table_Menu[9609],{__index = Table_Menu[9600]})
return Table_Menu
