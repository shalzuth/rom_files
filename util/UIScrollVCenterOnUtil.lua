UIScrollVCenterOnUtil = class("UIScrollVCenterOnUtil");

function UIScrollVCenterOnUtil:ctor(mScrollView)
	if(mScrollView)then
		self.mScrollView = mScrollView;
		self.mTrans = mScrollView.transform;
		self:Init();
	end
end

function UIScrollVCenterOnUtil:Init()
end

function UIScrollVCenterOnUtil:Center(target)
	if(self:ObjIsNil(target) or self:ObjIsNil(self.mScrollView))then
		return;
	end
	if(not self.mPanel)then
		self.mPanel = self.mScrollView.panel;
	end
	if(self.mPanel)then
		if(self.mBound~=self.mScrollView.bounds)then
			self.mBound = self.mScrollView.bounds;
			local boundSize = self.mBound.size;
			local ps = self.mPanel:GetViewSize ();
			if(boundSize.x>ps.x)then
				self.checkBound = Bounds(self.mBound.center, Vector3 (boundSize.x - ps.x, boundSize.y - ps.y));
			else
				self.checkBound = Bounds(self.mBound.center, Vector3.zero);
			end
		end
		if(self.checkBound)then
			local cp = self.mTrans:InverseTransformPoint (target.position);
			if(not self.checkBound:Contains(cp))then
				cp = self.checkBound:ClosestPoint (cp);
			end 
			local corners = self.mPanel.worldCorners;
			local panelCenter = (corners[3] + corners[1]) * 0.5;
			local cc = self.mTrans:InverseTransformPoint (panelCenter);
			local localOffset = cp - cc;

			self.mTrans.localPosition = self.mTrans.localPosition - localOffset;
			local co = self.mPanel.clipOffset;
			self.mScrollView.panel.clipOffset = Vector2(co.x+localOffset.x, co.y+localOffset.y);
			-- SpringPanel.Begin (self.mScrollView.panel.cachedGameObject, self.mTrans.localPosition - localOffset, 8).strength = 13;
			return true;
		end
	end
	return false;
end

function UIScrollVCenterOnUtil:ObjIsNil(obj)
	return GameObjectUtil.Instance:ObjectIsNULL(obj);
end















