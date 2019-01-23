SetViewSwitchRolePage = class("SetViewSwitchRolePage",SubView)

autoImport("SetViewHeadCell")
autoImport("SwitchRolePanel")

function SetViewSwitchRolePage:Init ()
     self:initView()
     -- todo xde 屏蔽切换角色按钮
     self:AddViewEvents()
     self:initData()
end

function SetViewSwitchRolePage:initView ()
    self.grid = self:FindComponent("roleGrid",UIGrid)
    self.roleGrid = UIGridListCtrl.new(self.grid,SetViewHeadCell,"SetViewHeadCell")
    self.roleGrid:AddEventListener(MouseEvent.MouseClick,self.cellClick,self)
    self.content = self:FindGO("content")
    self.contentGrid = self:FindGO("contentGrid")
    self.contentBg = self:FindComponent("contentBg",UISprite)
    local switchRoleBtn = self:FindComponent("switchRoleLabel",UILabel)
    switchRoleBtn.text = ZhString.SetViewSecurityPage_SwitchRoleLabel
        -- todo xde 屏蔽切换角色按钮
    -- switchRoleBtn.gameObject.transform.parent.gameObject:SetActive(false)
end

function SetViewSwitchRolePage:initData ()   
    local allRoles = ServiceUserProxy.Instance:GetAllRoleInfos()
    local arrays = {}
    if allRoles and #allRoles >1 then
        for i=1,#allRoles do
            local single = allRoles[i]
            local deletetime = single.deletetime
            local leftTime = deletetime ~= 0 and ServerTime.ServerDeltaSecondTime(deletetime * 1000) or 1
            if(single.id ~=0 and single.id ~= Game.Myself.data.id and leftTime > 0)then
                arrays[#arrays+1] = single
            end
        end
    end
    if(#arrays == 0)then
        self.roleGrid:SetEmptyDatas(1)
    else
        self.roleGrid:ResetDatas(arrays)
    end
end

function SetViewSwitchRolePage:AddViewEvents()
    self:AddButtonEvent("switchRoleBtn",function ( )
       self:Show(self.content)
       self.roleGrid:Layout()
       self:resizeContentBg()
    end)
end

function SetViewSwitchRolePage:resizeContentBg()
    local size = #self.roleGrid:GetCells()
    self.contentBg.width = size*126
    -- local bd = NGUIMath.CalculateRelativeWidgetBounds(self.contentGrid.transform)
    -- local width = bd.size.x
    -- self.contentBg.width = width
end

function SetViewSwitchRolePage:cellClick(cellCtr)
    if(cellCtr.data == nil)then
        MsgManager.ShowMsgByID(13012)
    elseif(cellCtr.data.deletetime ~= 0)then
        MsgManager.ShowMsgByID(13011)
    else
        MsgManager.ConfirmMsgByID(13010, function ()
           PlayerPrefs.SetString(ServiceLoginUserCmdProxy.toswitchroleid,tostring(cellCtr.data.id))
           PlayerPrefs.Save()
           Game.Me():BackToSwitchRole()
        end)
    end
end

function SetViewSwitchRolePage:Exit () 
end

function SetViewSwitchRolePage:Save () 

end

function SetViewSwitchRolePage:OnExit ()    
    TimeTickManager.Me():ClearTick(self)
end

function SetViewSwitchRolePage:SwitchOn ()
end

function SetViewSwitchRolePage:SwitchOff ()
    
end