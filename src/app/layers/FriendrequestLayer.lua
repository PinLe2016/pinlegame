--
-- Author: peter
-- Date: 2016-06-13 15:55:45
--邀请好友 
local FriendrequestLayer = class("FriendrequestLayer", function()
            return display.newScene("FriendrequestLayer")
end)
function FriendrequestLayer:ctor(params)--params
            self.switch = params.switch
            self.floating_layer = require("app.layers.FloatingLayer").new()
            self.floating_layer:addTo(self,100000)
            self:setNodeEventEnabled(true)--layer添加监听
            self:fun_init()

end
function FriendrequestLayer:fun_init( ... )
            
            local fragment_sprite_bg = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
            self:addChild(fragment_sprite_bg)
            self.Friendrequest = cc.CSLoader:createNode("Friendrequest.csb")
            self:addChild(self.Friendrequest)
            self.Friendrequest:setScale(0.7)
            self.Friendrequest:setAnchorPoint(0.5,0.5)
            self.Friendrequest:setPosition(320, 568)
           Util:layer_action(self.Friendrequest,self,"open") 
            Server:Instance():get_friend_reward_setting_list()  --邀请有礼接口
end
function FriendrequestLayer:init(  )
       local _table=LocalData:Instance():get_gettasklist()
       local tasklist=_table["tasklist"]
       for i=1,#tasklist  do 
             if  tonumber(tasklist[i]["targettype"])   ==  1   then
                  LocalData:Instance():set_tasktable(tasklist[i]["targetid"])
             end   
       end
       self:pop_up()--弹出框
       local back_bt=self.Friendrequest:getChildByTag(3418)  --返回
            back_bt:addTouchEventListener(function(sender, eventType)
              if eventType == 3 then
                       sender:setScale(1)
                       return
              end

            if eventType ~= ccui.TouchEventType.ended then
                       sender:setScale(1.2)
                       return
                  end
            sender:setScale(1)

            if self.share then
                if self.share:getIs_Share()  and  LocalData:Instance():get_tasktable()    then   --  判断分享是否做完任务
                   Server:Instance():settasktarget(LocalData:Instance():get_tasktable())
                    LocalData:Instance():set_tasktable(nil)--制空
                end
            end
            Util:all_layer_backMusic()
            Server:Instance():gettasklist()
            Util:layer_action(self.Friendrequest,self,"close")
            local function stopAction()
                if self.switch==1 then
                    self:removeFromParent()
                else
                --Util:scene_control("MainInterfaceScene")
                    self:removeFromParent()
                end
            end
            local actionTo = cc.ScaleTo:create(0.1, 1.1)
            local actionTo1 = cc.ScaleTo:create(0.3, 1)
            local callfunc = cc.CallFunc:create(stopAction)
            self.Friendrequest:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))

       end)
     
        self.friendlist_num=LocalData:Instance():get_reward_setting_list()  
        local friend_num=self.Friendrequest:getChildByTag(160)  --邀请的人数
        friend_num:setString(tostring(self.friendlist_num["friendcount"]))
        local ldb_Friends=self.Friendrequest:getChildByTag(333)
        ldb_Friends:setPercent(tonumber(self.friendlist_num["friendcount"])/200 *100)
       local friend_bt=self.Friendrequest:getChildByTag(161)  --好友邀请
            friend_bt:addTouchEventListener(function(sender, eventType)
            self:touch_callback(sender, eventType)
       end)
       local feedback_bt=self.Friendrequest:getChildByTag(162)  --回馈邀请人
              feedback_bt:addTouchEventListener(function(sender, eventType)
              self:touch_callback(sender, eventType)
       end)
      self:fun_scrollToPage()
end
function FriendrequestLayer:fun_scrollToPage(  )
        local pvw_Friends=self.Friendrequest:getChildByTag(346)
        self.pnl_First=pvw_Friends:getChildByTag(347)
        
      --    --  左键
      -- local YQHY_D_Z=self.Friendrequest:getChildByTag(335)
      -- YQHY_D_Z:addTouchEventListener(function(sender, eventType  )
      --       if eventType ~= ccui.TouchEventType.ended then
      --        return
      --       end
      --       pvw_Friends:scrollToPage(pvw_Friends:getCurPageIndex()-1)
      -- end)
      -- --右键
      -- local YQHY_D_Y=self.Friendrequest:getChildByTag(336)
      -- YQHY_D_Y:addTouchEventListener(function(sender, eventType  )
      --       if eventType ~= ccui.TouchEventType.ended then
      --        return
      --       end
      --       pvw_Friends:scrollToPage(pvw_Friends:getCurPageIndex()+1)
      -- end)  

     local _reward_setting_list=LocalData:Instance():get_reward_setting_list()
      local managerlist=_reward_setting_list["managerlist"]
      local tmp = 0  
  
    for i=1,#managerlist-1 do  
        for j=1,#managerlist-i do  
            if managerlist[j]["friendscount"] > managerlist[j+1]["friendscount"] then  
                tmp = managerlist[j]  
                managerlist[j] = managerlist[j+1]  
                managerlist[j+1] = tmp  
            end  
        end  
    end  
      self:fun_pnl_First(self.pnl_First,348,20,"","金币 100","",false,true,true,10,managerlist[1]["friendscount"])
      self:fun_pnl_First(self.pnl_First,356,20,"","金币 200","",false,true,true,10,managerlist[2]["friendscount"])
      self:fun_pnl_First(self.pnl_First,364,20,"","金币 500","",false,true,true,10,managerlist[3]["friendscount"])
      self:fun_pnl_First(self.pnl_First,372,20,"","金币 1000","经验 1000",false,true,true,0,managerlist[4]["friendscount"])
      self:fun_pnl_First(self.pnl_First,380,20,"","金币 2000","经验 2000",false,true,true,0,managerlist[5]["friendscount"])
      self:fun_pnl_First(self.pnl_First,388,20,"","金币 4000","经验 4000",false,true,true,0,managerlist[6]["friendscount"])
      self:fun_pnl_First(self.pnl_First,396,20,"","金币 8000","经验 8000",false,true,true,0,managerlist[7]["friendscount"])
      self:fun_pnl_First(self.pnl_First,404,20,"","金币 20000","经验 10000",false,true,true,0,managerlist[8]["friendscount"])

    
end
function FriendrequestLayer:fun_pnl_First( pnl,_tag,number,reward1,reward2,reward3,isb1,isb2,isb3 ,_y,_num)
        local ProjectNode_2=pnl:getChildByTag(_tag):getChildByTag(340)
        local Text_1=ProjectNode_2:getChildByTag(342)
        Text_1:setString(tostring(number))
        local Text_2=ProjectNode_2:getChildByTag(343)
        Text_2:setString(tostring(reward1))
        Text_2:setVisible(isb1)
        local Text_3=ProjectNode_2:getChildByTag(345)
        Text_3:setString(tostring(reward2))
        Text_3:setVisible(isb2)
        Text_3:setPositionY(Text_3:getPositionY()-_y)
        local Text_4=ProjectNode_2:getChildByTag(344)
        Text_4:setString(tostring(reward3))
        Text_4:setVisible(isb3)
        local Text_1=ProjectNode_2:getChildByTag(342)
        Text_1:setString(tostring(_num))
end

function FriendrequestLayer:pop_up(  )

      if self.fragment_sprite_bg then
         self.fragment_sprite_bg:removeFromParent()
         self.fragment_sprite_bg=nil
      end
      self.fragment_sprite_bg = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
      self:addChild(self.fragment_sprite_bg)
       self.Friendsstep = cc.CSLoader:createNode("Friendsstep.csb")  --谈出框
       self.fragment_sprite_bg:addChild(self.Friendsstep)
       self.Friendsstep:setScale(0.7)
      self.Friendsstep:setAnchorPoint(0.5,0.5)
      self.Friendsstep:setPosition(320, 568)
      Util:layer_action(self.Friendsstep,self,"open") 

       self.fragment_sprite_bg:setVisible(false)
       self.m_feedback=self.Friendsstep:getChildByTag(226)  --回馈邀请人界面
       self.m_feedback:setVisible(false)
       self.m_friend=self.Friendsstep:getChildByTag(238)  --邀请好友界面
       self.m_friend:setVisible(false)
       
       self.invitecode_num=self.m_feedback:getChildByTag(236) -- 输入邀请码
       self.invitecode_num:setVisible(true)
      
       --_invitecodeNum:setTouchEnabled(false)
      --  local res = " "
      --  local width = 340
      --  local height = 40
      
       local friendlist_code =LocalData:Instance():get_reward_setting_list() 
      -- if tostring(friendlist_code["invitecode"])~="0" then

      --          self.invitecode_num = cc.ui.UILabel.new({text = tostring(friendlist_code["invitecode"]),
      --                   size = 25,
      --                   --align = TEXT_ALIGN_CENTER,
      --                   font = "Arial",
      --                   color = cc.c4b(255,241,203),
      --                   })
      --     self.invitecode_num:setAnchorPoint(1,0.5)

      --    self.invitecode_num:setPosition(cc.p(_invitecodeNum:getPositionX(),_invitecodeNum:getPositionY()))
      --    self.invitecode_num:addTo(self.m_feedback,100)
      
      --     -- self.invitecode_num:setPlaceHolder()
      --     -- self.m_feedback:setTouchEnabled(false)
      --   else
      --           self.invitecode_num = ccui.EditBox:create(cc.size(width,height),res)
      --           self.invitecode_num:setVisible(false)
      --           self.m_feedback:addChild(self.invitecode_num)
      --           self.invitecode_num:setPosition(cc.p(_invitecodeNum:getPositionX(),_invitecodeNum:getPositionY()))--( cc.p(107,77 ))  
      --           self.invitecode_num:setPlaceHolder("请输入邀请码")
        
      --           --self.invitecode_num:setMaxLength(11)
      -- end


       local friend_back=self.m_friend:getChildByTag(242)  --好友返回
  friend_back:addTouchEventListener(function(sender, eventType)
  self:touch_callback(sender, eventType)
       end)

       local share_bt=self.m_friend:getChildByTag(243)  --前往邀请  分享
  share_bt:addTouchEventListener(function(sender, eventType)
  -- self:touch_callback(sender, eventType)
       end)

      local feedback_back=self.m_feedback:getChildByTag(1844) --回馈返回
  feedback_back:addTouchEventListener(function(sender, eventType)
                    if eventType == 3 then
                       sender:setScale(1)
                       return
                    end

                    if eventType ~= ccui.TouchEventType.ended then
                       sender:setScale(1.2)
                       return
                    end
                    
                      local function stopAction()
                              sender:setScale(1)
                            self.fragment_sprite_bg:setVisible(false)
                            self.m_feedback:setVisible(false)
                            -- self.invitecode_num:setVisible(false)
                      end
                      local actionTo = cc.ScaleTo:create(0.1, 1.1)
                      local actionTo1 = cc.ScaleTo:create(0.1, 0.7)
                      local callfunc = cc.CallFunc:create(stopAction)
                      self.Friendsstep:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))


       end)

       local _backbt=self.m_feedback:getChildByTag(230)  --下次再说
  _backbt:addTouchEventListener(function(sender, eventType)
  self:touch_callback(sender, eventType)
       end)

       local obtain_bt=self.m_feedback:getChildByTag(231)  --输入获取
  obtain_bt:addTouchEventListener(function(sender, eventType)
  self:touch_callback(sender, eventType)
       end)

   if tostring(friendlist_code["invitecode"])~="0" then
      _backbt:setVisible(false)
      obtain_bt:setVisible(false)
      self.invitecode_num:setVisible(false)
      self.invitecode_num:setString(tostring(friendlist_code["invitecode"]))
    else
       Util:function_keyboard(self.m_feedback,self.invitecode_num,25) 
   end
end


function FriendrequestLayer:pushFloating(text)
    if is_resource then
        self.floating_layer:showFloat(text)  
        
    else
        if self.barrier_bg then 
            self.barrier_bg:setVisible(false)
        end
        self.floating_layer:showFloat(text)
    end
end 

function FriendrequestLayer:push_buffer(is_buffer)

       self.floating_layer:show_http(is_buffer) 
       
end 
function FriendrequestLayer:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end


function FriendrequestLayer:touch_callback( sender, eventType )
  if eventType ~= ccui.TouchEventType.ended then
    return
  end
  local tag=sender:getTag()



  if tag==123 then --返回
      -- local function stopAction()
      --      if self.switch==1 then
      --          self:removeFromParent()
      --     else
      --         --Util:scene_control("MainInterfaceScene")
      --         self:removeFromParent()
      --     end
      -- end
      -- local actionTo = cc.ScaleTo:create(0.1, 1.1)
      -- local actionTo1 = cc.ScaleTo:create(0.3, 1)
      -- local callfunc = cc.CallFunc:create(stopAction)
      -- self.Friendrequest:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))
      Util:layer_action(self.Friendrequest,self,"close")

  elseif tag==161 then  --好友邀请
    self.share=Util:share()
  elseif tag==162 then  --回馈邀请人
    self.fragment_sprite_bg:setVisible(true)
    Util:layer_action(self.Friendsstep,self,"open")
    self.m_feedback:setVisible(true)
    self.invitecode_num:setVisible(true)
  elseif tag==1844 then  --回馈返回
    
  elseif tag==242 then  --好友返回
    self.fragment_sprite_bg:setVisible(false)
    self.m_friend:setVisible(false)
  elseif tag==243 then  --分享
    
  elseif tag==230 then  --下次再说
    self.fragment_sprite_bg:setVisible(false)
    self.m_friend:setVisible(false)
  elseif tag==231 then  --获取输入码

    if tostring(Util:judgeIsAllNumber(tostring(self.invitecode_num:getString())))  ==  "false"    then
      Server:Instance():promptbox_box_buffer("手机号码格式错误")
      return
    end
    if string.len(self.invitecode_num:getString()) < 11 then
      Server:Instance():promptbox_box_buffer("手机号填写错误")
      return
    end


    local _num=self.invitecode_num:getString()
    Server:Instance():setinvitecode(tostring(_num))  --测试（与策划不符）
    print("获取输入码",_num)
  
  
  end
end
function FriendrequestLayer:onEnter()
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.INVITATION_POLITE, self,
                       function()
                         --  
                          local function stopAction()
                                 self:init()

                              end
                        
                              local callfunc = cc.CallFunc:create(stopAction)
                              self.Friendrequest:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),callfunc  ))
                          
                      end)
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.STECODE, self,
                       function()
                         self.floating_layer:showFloat("填写成功，奖励即将发送至您的好友。",function (sender, eventType)        
                                                                if eventType==1    then
                                                                          self:pop_up()--弹出框
                                                                          local userdt = LocalData:Instance():get_userdata()
                                                                          userdt["golds"]=userdt["golds"]  +  200
                                                                          LocalData:Instance():set_userdata(userdt)
                                                                    end
                                                end)   
                      end)
end

function FriendrequestLayer:onExit()
        NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.INVITATION_POLITE, self)
       NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.STECODE, self)
       cc.Director:getInstance():getTextureCache():removeAllTextures() 
end

return FriendrequestLayer

















