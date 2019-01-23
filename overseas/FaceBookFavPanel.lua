autoImport("FaceBookGiftCell");

FaceBookFavPanel = class("FaceBookFavPanel",ContainerView)
FaceBookFavPanel.ViewType = UIViewType.PopUpLayer

FaceBookFavPage =
{
    ThumbsUp = 1,
    Share = 2,
    Invite = 3,
};

function FaceBookFavPanel:Init()
    local tagButtonBack = self:FindGO("TagButtonBack")
    self.thumbsUpTagBack = self:FindGO("ThumbsUpTag", tagButtonBack)
    self:AddClickEvent(self.thumbsUpTagBack, function (go)
        self:ChangePage(FaceBookFavPage.ThumbsUp)
    end)
    self.shareTagBack = self:FindGO("ShareTag", tagButtonBack)
    self:AddClickEvent(self.shareTagBack, function (go)
        self:ChangePage(FaceBookFavPage.Share)
    end)
    self.inviteTagBack = self:FindGO("InviteTag", tagButtonBack)
    self:AddClickEvent(self.inviteTagBack, function (go)
        self:ChangePage(FaceBookFavPage.Invite)
    end)

    local tagButtonFront = self:FindGO("TagButtonFront")
    self.thumbsUpTagFront = self:FindGO("ThumbsUpTag", tagButtonFront)
    self.shareTagFront = self:FindGO("ShareTag", tagButtonFront)
    self.inviteTagFront = self:FindGO("InviteTag", tagButtonFront)
    
    self.thumbsUpPage = self:FindGO("ThumbsUpPage")
    self.sharePage = self:FindGO("SharePage")
    self.invitePage = self:FindGO("InvitePage")

    self:InitThumbsUp()
    self:InitShare()

    self.activePage = FaceBookFavPage.ThumbsUp

    self.thumbsUpTagBack:SetActive(false)
    self.thumbsUpTagFront:SetActive(true)

    self.shareTagBack:SetActive(true)
    self.shareTagFront:SetActive(false)

    self.inviteTagBack:SetActive(false)
    self.inviteTagFront:SetActive(false)

    self.thumbsUpPage:SetActive(true)
    self.sharePage:SetActive(false)
    self.invitePage:SetActive(false)

    self.Pages = {}

    self.Pages[FaceBookFavPage.ThumbsUp] = {}
    self.Pages[FaceBookFavPage.ThumbsUp].Page = self.thumbsUpPage
    self.Pages[FaceBookFavPage.ThumbsUp].TagBack = self.thumbsUpTagBack
    self.Pages[FaceBookFavPage.ThumbsUp].TagFront = self.thumbsUpTagFront

    self.Pages[FaceBookFavPage.Share] = {}
    self.Pages[FaceBookFavPage.Share].Page = self.sharePage
    self.Pages[FaceBookFavPage.Share].TagBack = self.shareTagBack
    self.Pages[FaceBookFavPage.Share].TagFront = self.shareTagFront

    self.Pages[FaceBookFavPage.Invite] = {}
    self.Pages[FaceBookFavPage.Invite].Page = self.invitePage
    self.Pages[FaceBookFavPage.Invite].TagBack = self.inviteTagBack
    self.Pages[FaceBookFavPage.Invite].TagFront = self.inviteTagFront
    
    -- close tab change
    tagButtonBack:SetActive(false)
    tagButtonFront:SetActive(false)
end

function FaceBookFavPanel:ChangePage(id)
    Debug.Log("press tag " .. id .. ", org is " .. self.activePage)
    if id == self.activePage then
        return
    end

    self.Pages[self.activePage].Page:SetActive(false)
    self.Pages[self.activePage].TagBack:SetActive(true)
    self.Pages[self.activePage].TagFront:SetActive(false)

    self.Pages[id].Page:SetActive(true)
    self.Pages[id].TagBack:SetActive(false)
    self.Pages[id].TagFront:SetActive(true)

    self.activePage = id
end

function FaceBookFavPanel:InitThumbsUp()
    self.favBtn = self:FindGO("FavBg", self.thumbsUpPage)
    self:AddClickEvent(self.favBtn, function (go)
        Application.OpenURL("https://www.facebook.com/PlayRagnarokM/")
    end)


    self.showNoticeBtn = self:FindGO("InfoButton", self.thumbsUpPage)

    local longPress = self.showNoticeBtn:GetComponent(UILongPress)
    if(longPress)then
        longPress.pressEvent = function ( obj,state )
            -- body
            local noticeLabel = self:FindGO("NoticeDes", self.thumbsUpPage):GetComponent(UILabel)
            noticeLabel.text = ZhString.FaceBookShare1
            local NoticeView = self:FindGO("Notice", self.thumbsUpPage)
            if(state)then
                NoticeView:SetActive(true);
            else
                NoticeView:SetActive(false);
            end
        end
    end

    
    self.favCountLabel = self:FindComponent("FavCount",UILabel)

    self.giftsConfig = {}

    for k, v in pairs(Table_FacebookReward) do
        table.insert(self.giftsConfig,{
            id = v.id,
            target = v.like,
            itemId = v.item,
            init = true
        })
    end
    
    -- init list from config todo xde 修改成配置
    table.sort(self.giftsConfig, FaceBookFavPanel.SortConf);

    self:RefreshItems(self.giftsConfig)

    self:TaiwanFbLikeListen()

--    self:inviteFBFriends("title","msg")
end

function FaceBookFavPanel:ShareImage()
    self.sharingImage = false
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance();
    overseasManager:ShareImg(self.shareImage,"","","",function(msg)
        redlog('msg' .. msg)
        if(msg == "1")then
            ServiceOverseasTaiwanCmdProxy.Instance:CallTaiwanFbShareRedeemCmd();
            MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
        else
            MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
        end
    end);
end

function FaceBookFavPanel:ShareImageLoad(asset, path, shareImageName)
    local savePath = PathUtil.GetSavePath(PathConfig.PhotographPath).."/"..shareImageName
    ScreenShot.SaveJPG(asset,savePath,100)
    self.shareImage = savePath..".jpg"
    self:ShareImage()
end

function FaceBookFavPanel:InitShare()
    self.shareImmediatelyBtn = self:FindGO("ShareImmediately", self.sharePage)
    self.shareImmediatelyBtn:SetActive(true)
    self:AddClickEvent(self.shareImmediatelyBtn, function (go)
        if not self.shareInited then
            return;
        end
        if self.sharingImage then
            return;
        end
        self.sharingImage = true
        if self.shareImage == nil then
            local texturePath = "GUI/pic/Overseas/like_bg_02";
            local shareImageName = "FaceBookShare_like_bg_02"
            Game.AssetManager_UI:LoadAsset(
                texturePath,
                Texture2D,
                FaceBookFavPanel.ShareImageLoad,
                self,
                shareImageName
            );
            return
        end
        self:ShareImage()
    end)
    self.sharedBtn = self:FindGO("Shared", self.sharePage)
    self.sharedBtn:SetActive(false)

    self.shareDetailBtn = self:FindGO("Detail", self.sharePage)
    self.shareNoticeLabel = self:FindGO("NoticeDes", self.sharePage):GetComponent(UILabel)
    self.shareNoticeView = self:FindGO("Notice", self.sharePage)
    local longPress = self.shareDetailBtn:GetComponent(UILongPress)
    if(longPress)then
        longPress.pressEvent = function ( obj,state )
            -- body
            self.shareNoticeLabel.text = ZhString.FaceBookShare
            if(state)then
                self.shareNoticeView:SetActive(true);
            else
                self.shareNoticeView:SetActive(false);
            end
        end
    end
    
    self:TaiwanFbShareListen();
    self.canShare = true;
    self.shareInited = false;
end

function FaceBookFavPanel.SortConf(a,b)
    local result = tonumber(a.target) < tonumber(b.target)
    return result
end

function FaceBookFavPanel:OnEnter()
    self.super.OnEnter(self);
    ServiceOverseasTaiwanCmdProxy.Instance:CallTaiwanFbLikeProgressCmd();
    ServiceOverseasTaiwanCmdProxy.Instance:CallTaiwanFbShareProgressCmd();
end

function FaceBookFavPanel:RefreshCount(count)
    local numStr = self:number_format(count)
    self.favCountLabel.text = string.format("%s people like this", numStr)
end

function FaceBookFavPanel:RefreshItems(giftDatas)
    if(self.gifts == nil)then
        local scrollViewObj = self:FindGO("ScrollView", self.thumbsUpPage);
        self.scrollView = scrollViewObj:GetComponent(UIScrollView);
        local giftsGrid = self:FindGO("Grid", scrollViewObj):GetComponent(UIGrid);
        self.gifts = UIGridListCtrl.new(giftsGrid, FaceBookGiftCell, "FaceBookGiftCell");
    end


    self.gifts:ResetDatas(giftDatas);
    self.scrollView:ResetPosition();
end

function FaceBookFavPanel:SetShare(canShare)
    self.canShare = canShare
    self.shareImmediatelyBtn:SetActive(self.canShare)
    self.sharedBtn:SetActive(not self.canShare)
end

function FaceBookFavPanel:OnExit()
    self.super.OnExit(self);
end

function FaceBookFavPanel:findConfig(id)
    local conf ={}
    for i=1,#self.giftsConfig do
        local item = self.giftsConfig[i];
        if(item.id == id)then
            conf = item break
        end
    end
    return conf
end

-- net
function FaceBookFavPanel:TaiwanFbLikeListen()
    self:AddListenEvt(ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeProgressCmd, self.HandleFbProgressUpdate);
    self:AddListenEvt(ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeUserRedeemCmd, self.HandleFbTaiwanFbLikeUserRedeem);
end

function FaceBookFavPanel:TaiwanFbShareListen()
    self:AddListenEvt(ServiceEvent.OverseasTaiwanCmdTaiwanFbShareProgressCmd, self.HandleFbTaiwanFbShareProgress);
    self:AddListenEvt(ServiceEvent.OverseasTaiwanCmdTaiwanFbShareRedeemCmd, self.HandleFbTaiwanFbShareRedeem);
end

function FaceBookFavPanel:HandleFbTaiwanFbShareRedeem(data)
    local err = data.body.err
    if err == 0 then -- success
        self:SetShare(false)
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookGiftGetSuccess)
    elseif err == 1 then -- shared
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookRewardHasRedeemed)
    end
end

function FaceBookFavPanel:HandleFbTaiwanFbShareProgress(data)
    self:SetShare(data.body.canShare)
    self.shareInited = true
end

function FaceBookFavPanel:HandleFbTaiwanFbLikeUserRedeem(data)
    local err = data.body.err
--    helplog(err)
    if(err == 0)then
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookGiftGetSuccess) --todo xde
        ServiceOverseasTaiwanCmdProxy.Instance:CallTaiwanFbLikeProgressCmd();    
    elseif(err == 1)then
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookRewardHasNotUnlocked)
    elseif(err == 2)then
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookRewardHasRedeemed)
    end
    
end

function FaceBookFavPanel:HandleFbProgressUpdate(data)
    local totalLikes = data.body.totalLikes;
   
    self:RefreshCount(totalLikes)

    local prizeList = data.body.prizeList;
    local gifts = {}
    for i=1,#prizeList do
        local item = prizeList[i];
        local config = self:findConfig(item.id)
        table.insert(gifts, {
            id = item.id,
            target = config.target,
            itemId = config.itemId,
            init = false,
            isUnlocked = item.isUnlocked,
            userRedeemed= item.userRedeemed
        })
    end

    table.sort(gifts, FaceBookFavPanel.SortConf);
    self:RefreshItems(gifts)
end

function FaceBookFavPanel:number_format(num,deperator)
    local str1 =""
    local str = tostring(num)
    local strLen = string.len(str)

    if deperator == nil then
        deperator = ","
    end
    deperator = tostring(deperator)

    for i=1,strLen do
        str1 = string.char(string.byte(str,strLen+1 - i)) .. str1
        if math.fmod(i,3) == 0 then
            if strLen - i ~= 0 then
                str1 = ","..str1
            end
        end
    end
    return str1
end  

function FaceBookFavPanel:inviteFBFriends(title,msg)
    OverSeas_TW.OverSeasManager.GetInstance():FBInvite(title,msg)
end


function FaceBookFavPanel:shareFBMsg()
    OverSeas_TW.OverSeasManager.GetInstance():ShareMsg("","")
end