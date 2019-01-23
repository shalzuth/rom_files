NoticeMsgView = class("NoticeMsgView",ContainerView)

NoticeMsgView.ViewType = UIViewType.BoardLayer

function NoticeMsgView:Init()
	self:FindObjs()
	self:AddEvts()

	self.noticeMsgList = {}
end

function NoticeMsgView:FindObjs()
	self.noticeMsg = self:FindGO("NoticeMsg"):GetComponent(TweenPosition)
	self.noticeMsgLabel = self:FindGO("NoticeMsgLabel"):GetComponent(UILabel)
	self.noticeMsgLabelTween = self.noticeMsgLabel.gameObject:GetComponent(TweenPosition)
end

function NoticeMsgView:AddEvts()
	self:AddListenEvt(SystemMsgEvent.NoticeMsg,self.HandleNoticeMsg)
end

function NoticeMsgView:HandleNoticeMsg(note)
	local data = note.body

	table.insert(self.noticeMsgList , data)
	-- LogUtility.InfoFormat("AddNoticeMsg : {0}",data.text)
	if #self.noticeMsgList == 1 then
		self:PlayNoticeMsg()
	end
end

function NoticeMsgView:PlayNoticeMsg()
	if #self.noticeMsgList > 0 then
		local msg = self.noticeMsgList[1]
		local text = msg.param and MsgParserProxy.Instance:TryParse(msg.text,unpack(msg.param)) or msg.text
		self:PlayForwardNoticeMsg(text)
	end
end

function NoticeMsgView:PlayForwardNoticeMsg(text)
	self.noticeMsgLabel.text = text

	self.noticeMsg:PlayForward()

	self.noticeMsg:SetOnFinished(function ()
		local perHeight = self.noticeMsgLabel.fontSize + self.noticeMsgLabel.spacingY
		local line = self.noticeMsgLabel.printedSize.y / perHeight

		if line > 1 then			
			LeanTween.delayedCall (self.gameObject, GameConfig.ShowNotice.duration , function ()
				self.noticeMsgLabelTween:PlayForward()
				self.noticeMsgLabelTween:SetOnFinished(function ()
					self:PlayReverseNoticeMsg()
				end)
			end)
		else
			self:PlayReverseNoticeMsg()
		end
	end)
end

function NoticeMsgView:PlayReverseNoticeMsg()
	LeanTween.delayedCall (self.gameObject, GameConfig.ShowNotice.duration , function ()
		self.noticeMsg:PlayReverse()
		self.noticeMsg:SetOnFinished(function ()
			if self.noticeMsg.value == self.noticeMsg.from then
				self.noticeMsgLabelTween:ResetToBeginning()

				table.remove(self.noticeMsgList , 1)
				self:PlayNoticeMsg()
			end
		end)
	end)
end