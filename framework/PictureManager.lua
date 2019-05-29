autoImport("AssetManager")
PictureManager = class("PictureManager")
PictureManager.Config = {
  Pic = {
    Card = "GUI/pic/Card/",
    Illustration = "GUI/pic/Illustration/",
    Loading = "GUI/pic/Loading/",
    UI = "GUI/pic/UI/",
    Map = "GUI/pic/Map/",
    MonthCard = "GUI/pic/MonthCard/",
    ZenyShopNPC = "GUI/pic/ZenyShopNPC/",
    Star = "GUI/pic/Star/",
    PetRenderTexture = "GUI/pic/Model/",
    Auction = "GUI/pic/Auction/",
    Quota = "GUI/pic/Quota/",
    GuildBuilding = "GUI/pic/GuildBuilding/",
    Recall = "GUI/pic/Recall/",
    EPCard = "GUI/pic/EPCard/",
    Wedding = "GUI/pic/Wedding/",
    PetWorkSpace = "GUI/pic/PetWorkSpace/",
    Stage = "GUI/pic/Stage/",
    PVP = "GUI/pic/PVP/",
    ExchangeShop = "GUI/pic/ExchangeShop/",
    MiniMap = "GUI/pic/miniMap/",
    TransmitterScene = "GUI/pic/TransmitterScene/",
    ExpRaid = "GUI/pic/ExpRaid/",
    SignIn = "GUI/pic/SignIn/",
    Puzzle = "GUI/pic/Puzzle/",
    Servant = "GUI/pic/Servant/",
    Camera = "GUI/pic/Camera/",
    NPCLiHui = "GUI/pic/npclihui/",
    BattleManualPanel = "GUI/pic/BattleManualPanel/"
  }
}
PictureManager.Instance = nil
function PictureManager:ctor()
  self.npclihuiCache = {}
  self.cardCatch = {}
  self.illustrationCache = {}
  self.loadingCache = {}
  self.uiCache = {}
  self.mapCache = {}
  self.monthCardCache = {}
  self.zenyShopNPCCache = {}
  self.starCache = {}
  self.PetRenderTextureCache = {}
  self.auctionCache = {}
  self.quotaCache = {}
  self.GuildBuildindCache = {}
  self.recallCache = {}
  self.epCardCache = {}
  self.weddingCache = {}
  self.petWorkSpaceCache = {}
  self.stageCache = {}
  self.pvpCache = {}
  self.exchangeShopCache = {}
  self.miniMapCache = {}
  self.transmitterSceneCache = {}
  self.expRaidCache = {}
  self.signInCache = {}
  self.puzzleBGCache = {}
  self.servantCache = {}
  self.cameraCache = {}
  self.BattleManualPanelCache = {}
  PictureManager.Instance = self
end
function PictureManager:SetBattleManualPanel(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.BattleManualPanel, self.BattleManualPanelCache)
end
function PictureManager:SetNPCLiHui(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.NPCLiHui, self.npclihuiCache)
end
function PictureManager:SetCard(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Card, self.cardCatch)
end
function PictureManager:SetIllustration(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Illustration, self.illustrationCache)
end
function PictureManager:SetLoading(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Loading, self.loadingCache, true)
end
function PictureManager:SetUI(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.UI, self.uiCache)
end
function PictureManager:SetMonthCardUI(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MonthCard, self.monthCardCache)
end
function PictureManager:SetMap(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Map, self.mapCache)
end
function PictureManager:SetZenyShopNPC(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ZenyShopNPC, self.zenyShopNPCCache)
end
function PictureManager:SetQuota(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Quota, self.quotaCache)
end
function PictureManager:SetGuildBuilding(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.GuildBuilding, self.GuildBuildindCache)
end
function PictureManager:SetStar(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Star, self.starCache)
end
function PictureManager:SetPetRenderTexture(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PetRenderTexture, self.PetRenderTextureCache)
end
function PictureManager:SetAuction(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Auction, self.auctionCache)
end
function PictureManager:SetRecall(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Recall, self.recallCache)
end
function PictureManager:SetEPCardUI(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.EPCard, self.epCardCache)
end
function PictureManager:SetWedding(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Wedding, self.weddingCache)
end
function PictureManager:SetPetWorkSpace(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PetWorkSpace, self.petWorkSpaceCache)
end
function PictureManager:SetExchangeShop(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ExchangeShop, self.exchangeShopCache)
end
function PictureManager:SetStagePart(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Stage, self.stageCache)
end
function PictureManager:SetPVP(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.PVP, self.pvpCache)
end
function PictureManager:SetMiniMap(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.MiniMap, self.miniMapCache)
end
function PictureManager:SetTransmitterScene(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.TransmitterScene, self.transmitterSceneCache)
end
function PictureManager:SetExpRaid(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.ExpRaid, self.expRaidCache)
end
function PictureManager:SetSignIn(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.SignIn, self.signInCache)
end
function PictureManager:SetPuzzleBG(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Puzzle, self.puzzleBGCache)
end
function PictureManager:SetServantBG(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Servant, self.servantCache)
end
function PictureManager:SetCameraBG(sName, uiTexture)
  return self:SetTexture(sName, uiTexture, PictureManager.Config.Pic.Camera, self.cameraCache)
end
function PictureManager:SetTexture(sName, uiTexture, path, cache, reFitScreenHeight)
  local rID = path .. sName
  local cacheInfo = cache[sName]
  if cacheInfo == nil then
    cacheInfo = {}
    cache[sName] = cacheInfo
  end
  cacheInfo[1] = rID
  if cacheInfo[2] then
    cacheInfo[2] = cacheInfo[2] + 1
  else
    cacheInfo[2] = 1
  end
  Game.AssetManager_UI:LoadAsset(rID, Texture, PictureManager._LoadTexture, uiTexture, reFitScreenHeight)
  return true
end
function PictureManager._LoadTexture(uiTexture, asset, path, reFitScreenHeight)
  uiTexture.mainTexture = asset
  if reFitScreenHeight then
    PictureManager.ReFitMobileScreenHeight(uiTexture)
  end
end
function PictureManager.ReFitMobileScreenHeight(uiTexture)
  if uiTexture then
    local height = UIManagerProxy.Instance:GetMyMobileScreenAdaptionManualHeight()
    if not height then
      return
    end
    local scale = height / uiTexture.mainTexture.height
    uiTexture.height = height
    uiTexture.width = uiTexture.mainTexture.width * scale
  end
end
function PictureManager.ReFitFullScreen(uiTexture, exVal)
  exVal = exVal or 0
  local screen = NGUITools.screenSize
  local aspect = screen.x / screen.y
  local manualHeight = UIManagerProxy.Instance:GetMyMobileScreenAdaptionManualHeight()
  helplog("PictureManager.ReFitFullScreen")
  helplog(manualHeight, screen.x, screen.y)
  if manualHeight == nil then
    manualHeight = 720
  end
  if manualHeight then
    uiTexture.height = manualHeight + exVal
    uiTexture.width = aspect * manualHeight + exVal
  else
    uiTexture.width = 1280 + exVal
    uiTexture.height = 1280 / aspect + exVal
  end
end
function PictureManager:UnLoadBattleManualPanel(sName, uiTexture)
  self:UnLoadTexture(self.BattleManualPanelCache, sName, uiTexture)
end
function PictureManager:UnLoadNPCLiHui(sName, uiTexture)
  self:UnLoadTexture(self.npclihuiCache, sName, uiTexture)
end
function PictureManager:UnLoadCard(sName, uiTexture)
  self:UnLoadTexture(self.cardCatch, sName, uiTexture)
end
function PictureManager:UnLoadIllustration(sName, uiTexture)
  self:UnLoadTexture(self.illustrationCache, sName, uiTexture)
end
function PictureManager:UnLoadLoading(sName, uiTexture)
  self:UnLoadTexture(self.loadingCache, sName, uiTexture)
end
function PictureManager:UnLoadUI(sName, uiTexture)
  self:UnLoadTexture(self.uiCache, sName, uiTexture)
end
function PictureManager:UnLoadMap(sName, uiTexture)
  self:UnLoadTexture(self.mapCache, sName, uiTexture)
end
function PictureManager:UnLoadMonthCard(sName, uiTexture)
  self:UnLoadTexture(self.monthCardCache, sName, uiTexture)
end
function PictureManager:UnLoadZenyShopNPC(sName, uiTexture)
  self:UnLoadTexture(self.zenyShopNPCCache, sName, uiTexture)
end
function PictureManager:UnLoadStar(sName, uiTexture)
  self:UnLoadTexture(self.starCache, sName, uiTexture)
end
function PictureManager:UnloadPetTexture(sName, uiTexture)
  self:UnLoadTexture(self.PetRenderTextureCache, sName, uiTexture)
end
function PictureManager:UnLoadAuction(sName, uiTexture)
  self:UnLoadTexture(self.auctionCache, sName, uiTexture)
end
function PictureManager:UnLoadQuota(sName, uiTexture)
  self:UnLoadTexture(self.quotaCache, sName, uiTexture)
end
function PictureManager:UnloadGuildBuilding(sName, uiTexture)
  self:UnLoadTexture(self.GuildBuildindCache, sName, uiTexture)
end
function PictureManager:UnLoadRecall(sName, uiTexture)
  self:UnLoadTexture(self.recallCache, sName, uiTexture)
end
function PictureManager:UnLoadWedding(sName, uiTexture)
  self:UnLoadTexture(self.weddingCache, sName, uiTexture)
end
function PictureManager:UnloadPetWorkSpace(sName, uiTexture)
  self:UnLoadTexture(self.petWorkSpaceCache, sName, uiTexture)
end
function PictureManager:UnloadExchangeShop(sName, uiTexture)
  self:UnLoadTexture(self.exchangeShopCache, sName, uiTexture)
end
function PictureManager:UnLoadStagePart(sName, uiTexture)
  self:UnLoadTexture(self.stageCache, sName, uiTexture)
end
function PictureManager:UnLoadPVP(sName, uiTexture)
  self:UnLoadTexture(self.pvpCache, sName, uiTexture)
end
function PictureManager:UnLoadMiniMap(sName, uiTexture)
  self:UnLoadTexture(self.miniMapCache, sName, uiTexture)
end
function PictureManager:UnLoadTransmitterScene(sName, uiTexture)
  self:UnLoadTexture(self.transmitterSceneCache, sName, uiTexture)
end
function PictureManager:UnLoadExpRaid(sName, uiTexture)
  self:UnLoadTexture(self.expRaidCache, sName, uiTexture)
end
function PictureManager:UnLoadSignIn(sName, uiTexture)
  self:UnLoadTexture(self.signInCache, sName, uiTexture)
end
function PictureManager:UnLoadPuzzleBG(sName, uiTexture)
  self:UnLoadTexture(self.puzzleBGCache, sName, uiTexture)
end
function PictureManager:UnLoadServantBG(sName, uiTexture)
  self:UnLoadTexture(self.servantCache, sName, uiTexture)
end
function PictureManager:UnLoadCameraBG(sName, uiTexture)
  self:UnLoadTexture(self.cameraCache, sName, uiTexture)
end
function PictureManager:UnLoadTexture(cache, sName, uiTexture)
  if cache then
    if sName == nil then
      for sName, resInfo in pairs(cache) do
        resInfo[2] = resInfo[2] - 1
        if resInfo[2] <= 0 then
          Game.AssetManager_UI:UnLoadAsset(resInfo[1])
          cache[sName] = nil
        end
      end
    else
      local resInfo = cache[sName]
      if resInfo then
        resInfo[2] = resInfo[2] - 1
        if resInfo[2] <= 0 then
          Game.AssetManager_UI:UnLoadAsset(resInfo[1])
          cache[sName] = nil
        end
      end
    end
  end
end
