CookRecipeCell = class("CookRecipeCell", BaseCell)
function CookRecipeCell:Init()
  self:GetGameObjects()
end
function CookRecipeCell:GetGameObjects()
  self.cookInfo_TipLabel = self:FindComponent("TipLabel", UILabel)
  self.foodStars = {}
  self.foodStars[0] = self:FindGO("CookInfo_FoodStars")
  for i = 1, 5 do
    self.foodStars[i] = self:FindComponent("Star" .. i, UISprite, self.foodStars[0])
  end
end
function CookRecipeCell:SetData(data)
  self.data = data
  local recipeData = FoodProxy.Instance:GetRecipeByRecipeId(data.recipeId)
  local rate = 67
  local cookhard = recipeData:GetDiffLevel()
  if CommonFun.calcCookSuccessRate then
    local cookerlv = Game.Myself.data.userdata:Get(UDEnum.COOKER_LV) or 1
    local cookData = Table_CookerLevel[cookerlv]
    local succressraet = cookData and cookData.SuccessRate or 1
    local cooklv = 1
    local cookInfo = FoodProxy.Instance:Get_FoodCookExpInfo(recipeData.staticData.Product)
    if cookInfo then
      cooklv = cookInfo.level
    end
    rate = CommonFun.calcCookSuccessRate(cookerlv, cooklv, cookhard, data.avgMatLevel, succressraet) / 10
  end
  if recipeData and recipeData.unlock then
    self.cookInfo_TipLabel.text = recipeData.staticData.Name .. "\n" .. ZhString.FoodMakeView_SuccessRateTip .. rate .. "%"
  else
    self.cookInfo_TipLabel.text = "???????" .. "\n" .. ZhString.FoodMakeView_SuccessRateTip .. rate .. "%"
  end
  if cookhard and cookhard > 0 then
    self.foodStars[0]:SetActive(true)
    local num = math.floor(cookhard / 2)
    for i = 1, 5 do
      if i <= num then
        self.foodStars[i].gameObject:SetActive(true)
        self.foodStars[i].spriteName = "food_icon_08"
      elseif i == num + 1 and cookhard % 2 == 1 then
        self.foodStars[i].gameObject:SetActive(true)
        self.foodStars[i].spriteName = "food_icon_09"
      else
        self.foodStars[i].gameObject:SetActive(false)
      end
    end
  else
    self.foodStars[0]:SetActive(false)
  end
end
