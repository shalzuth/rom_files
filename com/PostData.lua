PostData = class("PostData")

function PostData:ctor(mailData)
	self:SetData(mailData);
end

function PostData:SetData(mailData)
	if(mailData)then
		self.id = mailData.id;
		self.sysid = mailData.sysid;

		self.mailid = mailData.mailid;
		self.senderid = mailData.senderid;
		self.receiveid = mailData.receiveid;
		self.emailtype = mailData.type;

		self.status = mailData.status;
		self.title = mailData.title;
		self.sendername = mailData.sender;
		self.msg = mailData.msg;

		self.time = mailData.time

		self:SetPosts(mailData.attach);
	end
end

function PostData:SetPosts(blobAttach)
	self.postItems = {};
	if(blobAttach)then
		for i=1,#blobAttach.attachs do
			local mailattach = blobAttach.attachs[i];
			if(mailattach.type == SessionMail_pb.EMAILATTACHTYPE_REWARD)then
				if(mailattach.id)then
					local postTeamids = ItemUtil.GetRewardItemIdsByTeamId(mailattach.id)
					if(postTeamids)then
						for tk,tv in pairs(postTeamids)do
							local tempItem = ItemData.new("Post", tv.id);
							tempItem.num = tv.num;
							table.insert(self.postItems, tempItem);
						end
					end
				end
			elseif(mailattach.type == SessionMail_pb.EMAILATTACHTYPE_ITEM)then
				for i=1,#mailattach.items do
					local itemInfo = mailattach.items[i];
					local tempItem = ItemData.new("Post", itemInfo.id);
					tempItem.num = itemInfo.count;
					table.insert(self.postItems, tempItem);
				end
				for i=1,#mailattach.itemdatas do
					local tempItem = ItemData.new()
					tempItem:ParseFromServerData(mailattach.itemdatas[i])
					table.insert(self.postItems, tempItem);
				end
			end
		end
	end
end