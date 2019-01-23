Table_Dialog_Quest4 = {}
local func_index = function(table, key)
	local data = StrTablesManager.GetData("Table_Dialog_Quest4", key);
	return data
end
local Mt_Table_Dialog_Quest4 = {__index = func_index}
setmetatable(Table_Dialog_Quest4,Mt_Table_Dialog_Quest4)
Table_Dialog_Quest4_s = {
	[83] = "{id = 83, Speaker = 1054, Text = '[c][ffff00][PlayerName][-][/c]，当你升级的时候，会获得一些素质点，用来强化自己的实力。', Emoji = 0}",
	[84] = "{id = 84, Speaker = 1054, Text = '我发现你已经自己加过素质点了，果然和我想的一样，是个聪明的孩子呢~', Option = '谢谢', Emoji = 20}",
	[85] = "{id = 85, Speaker = 1054, Text = '素质点决定了你成长的方向，非常重要哦~我现在教你怎么加点吧。', Option = '好的', Emoji = 0}",
	[86] = "{id = 86, Speaker = 1054, Text = '好了，你已经学会如何成长了，有没有感觉自己变厉害一点点呢^-^', Emoji = 17}",
	[87] = "{id = 87, Speaker = 1054, Text = '初心者，以后每次进阶到高级职业，都会有重新分配点数的机会，职业导师也会给出成长建议，请安心使用点数，让自己变强就好了。', Option = '我知道了', Emoji = 0}",
	[2364] = "{id = 2364, Speaker = 1024, Text = '[c][ffff00]技能[-][/c]是我们最强的力量，要成为优秀的冒险家，不光战斗技巧，还有很多生存技能需要掌握。我先教你几个基本技能吧，等你练熟悉之后，再来找我。', Option = '谢谢'}",
	[2365] = "{id = 2365, Speaker = 1024, Text = '一边冒险，一边在实战中锻炼自己的[c][ffff00]职业技能[-][/c]，就是冒险家的生存方式，也是新人成长最快的途径，请加油吧！', Option = '再见'}",
	[5106] = "{id = 5106, Speaker = 1024, Text = '我将重置你的角色属性，你可以根据你所选择的职业重新分配。'}",
	[5107] = "{id = 5107, Speaker = 1024, Text = '我可是很期待你会成长为一个什么样的冒险者哦~'}",
	[1312550] = "{id = 1312550, Speaker = 1187, Text = '亲爱的冒险者，看懂地图是冒险前必不可少的学问'}",
	[1312551] = "{id = 1312551, Speaker = 1187, Text = '现在就让我们一起看看地图上到底标记了些什么吧'}",
 
}
return Table_Dialog_Quest4
