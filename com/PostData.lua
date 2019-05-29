PostData = class("PostData")
function PostData:ctor(mailData)
  self:SetData(mailData)
end
function PostData:SetData(mailData)
  if mailData then
    self.id = mailData.id
    self.sysid = mailData.sysid
    self.mailid = mailData.mailid
    self.senderid = mailData.senderid
    self.receiveid = mailData.receiveid
    self.emailtype = mailData.type
    self.status = mailData.status
    self.title = mailData.title
    self.sendername = mailData.sender
    self.msg = mailData.msg
    self.time = mailData.time
    self.sendtime = mailData.sendtime
    self.expiretime = mailData.expiretime
    self:SetPosts(mailData.attach)
    self.unread = mailData.status == PostProxy.STATUS.NEW
    self.attachtime = mailData.attachtime
    self:SetFilterData()
    self:SetSortID()
  end
end
function PostData:SetFilterData()
  if self:IsRealAttach() then
    self.FilterIndex = SessionMail_pb.EMAILSTATUS_ATTACH
  elseif not self.unread then
    self.FilterIndex = SessionMail_pb.EMAILSTATUS_READ
  end
end
function PostData:IsMultiChoosenPost()
  local posts = PostProxy.Instance:GetMultiChoosePost()
  return TableUtility.ArrayFindIndex(posts, self.id) ~= 0
end
function PostData:HasPostItems()
  return #self.postItems > 0
end
function PostData:CheckAttachValid()
  return self:HasPostItems() and not self:IsAttachStatus()
end
function PostData:CheckNoPostAttachValid()
  return not self:HasPostItems() and not self:IsAttachStatus()
end
function PostData:IsAttachStatus()
  return SessionMail_pb.EMAILSTATUS_ATTACH == self.status
end
function PostData:IsRealAttach()
  return self:IsAttachStatus() and self:HasPostItems()
end
function PostData:IsVirtualAttach()
  return self:IsAttachStatus() and not self:HasPostItems()
end
function PostData:SetSortID()
  if self.unread and self:HasPostItems() then
    self.sortID = 1
  elseif self.unread and not self:HasPostItems() then
    self.sortID = 2
  elseif self:CheckAttachValid() then
    self.sortID = 3
  elseif self:CheckNoPostAttachValid() then
    self.sortID = 4
  elseif self:IsRealAttach() then
    self.sortID = 5
  elseif self:IsVirtualAttach() then
    self.sortID = 6
  else
    self.sortID = 7
  end
end
function PostData:SetPosts(blobAttach)
  self.postItems = {}
  if blobAttach then
    for i = 1, #blobAttach.attachs do
      local mailattach = blobAttach.attachs[i]
      if mailattach.type == SessionMail_pb.EMAILATTACHTYPE_REWARD then
        if mailattach.id then
          local postTeamids = ItemUtil.GetRewardItemIdsByTeamId(mailattach.id)
          if postTeamids then
            for tk, tv in pairs(postTeamids) do
              local tempItem = ItemData.new("Post", tv.id)
              tempItem.num = tv.num
              tempItem.attach = self:IsAttachStatus()
              table.insert(self.postItems, tempItem)
            end
          end
        end
      elseif mailattach.type == SessionMail_pb.EMAILATTACHTYPE_ITEM then
        for i = 1, #mailattach.items do
          local itemInfo = mailattach.items[i]
          local tempItem = ItemData.new("Post", itemInfo.id)
          tempItem.num = itemInfo.count
          tempItem.attach = self:IsAttachStatus()
          table.insert(self.postItems, tempItem)
        end
        for i = 1, #mailattach.itemdatas do
          local tempItem = ItemData.new()
          tempItem:ParseFromServerData(mailattach.itemdatas[i])
          tempItem.attach = self:IsAttachStatus()
          table.insert(self.postItems, tempItem)
        end
      end
    end
  end
end
