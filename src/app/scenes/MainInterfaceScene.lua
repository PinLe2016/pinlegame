


local MainInterfaceScene = class("MainInterfaceScene", function()
    return display.newScene("MainInterfaceScene")
end)

 function MainInterfaceScene:Popup_window_Twoday( )
             local _table={"距离大奖越来越近,赶快邀请好友给您助力了","您的排名被超越,好友助力"}
              self.floating_layer:fun_NotificationMessage(_table[math.random(1,2)],function (sender, eventType)
                                  if eventType==1 then
                                    print("马上助力")
                                  end
                            end)
end
-- 新  一些弹窗
function MainInterfaceScene:Popup_window( ... )
     local new_time_two=cc.UserDefault:getInstance():getIntegerForKey("new_time_two",0)
     if new_time_two==0 then
       cc.UserDefault:getInstance():setIntegerForKey("new_time_two",os.time())
     end

end
function MainInterfaceScene:ctor()
  -- local date1=os.date("%Y-%m-%d %H:%M:%S")
  --  dump(date1)
  --  tab=os.date("*t");
  --  print(tab.year, tab.month, tab.day, tab.hour, tab.min, tab.sec);
  -- print("蓝色的罚款是",os.time())
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self.count=0
      self.main_leve={0,500,1500,8000,15000,40000,80000,150000,400000,80000,2000000,5000000}
      self.main_leve_name={"平民","骑士","勋爵","男爵","子爵","伯爵","侯爵","公爵","大公","亲王","王储","国王"}
      self:Physics_homeback_ref()
      local userdt = LocalData:Instance():get_userdata()
      LocalData:Instance():set_sign(1)
      local _index=string.match(tostring(Util:sub_str(userdt["imageUrl"], "/",":")),"%d%d")
      if _index==nil then
      _index=string.match(tostring(Util:sub_str(userdt["imageUrl"], "/",":")),"%d")
      end

      --2天不等就弹窗
      self:Popup_window()
      local _KEY=cc.UserDefault:getInstance():getIntegerForKey("new_time_two",0)
      if _KEY~=0 and  tonumber(_KEY) +  172800  <= os.time()  then
          self:Popup_window_Twoday()
          cc.UserDefault:getInstance():setIntegerForKey("new_time_two",os.time())
      end

      Server:Instance():getconfig()  --  获取后台音效
      self:listener_home() --注册安卓返回键
      Server:Instance():gettasklist()   --  初始化任务
      --手机归属请求
      Server:Instance():getusercitybyphone()--手机归属
      self:fun_init()
      Server:Instance():getaffichelist(1,1)  --  邮件公告
      --Server:Instance():getaffichelist(2,2)  --  首页公告  

      Server:Instance():share_title() --分享内容获取

end
function MainInterfaceScene:hammerAction()
    --创建动画序列
     local node = cc.Sprite:create("liu/01.png")  
    local animation = cc.Animation:create()
    local number,name
    for i=1,6 do
      number = i 
      name = "liu/0"..number..".png"
      animation:addSpriteFrameWithFile(name)
    end

    animation:setDelayPerUnit(0.3/3.0)
    animation:setRestoreOriginalFrame(true)

    local animate = cc.Animate:create(animation)
    animation:setRestoreOriginalFrame(true)
   -- local node = self.layerPlay:getChildByTag(self.kTagSprite4)
    -- node:setAnchorPoint(0.75,1.0)
    node:setVisible(true)
    local function logSprRotation(sender)
    node:setVisible(false)
    end
    local action = cc.Sequence:create(animate,animate:reverse())

    node:setPosition(cc.p(display.cx,display.cy))
    self:addChild(node)

    --node:stopAllActions()
    node:runAction(cc.RepeatForever:create(animate))
   
end

--惊喜吧弹球页面home 键退出处理
function MainInterfaceScene:Physics_homeback_ref( )
        local phy_data_string=cc.UserDefault:getInstance():getStringForKey("Physics",nil)
        dump(phy_data_string)
        local phy_data_date=json.decode(phy_data_string)
        
        if not phy_data_date then
          return
        end

        
        dump(phy_data_date)
        Server:Instance():getactivitypoints(phy_data_date.actid,phy_data_date.cycle,phy_data_date.score)
        cc.UserDefault:getInstance():setStringForKey("Physics",nil)


end

function MainInterfaceScene:fun_init( )
      self.MainInterfaceScene = cc.CSLoader:createNode("MainInterfaceScene.csb")
      self:addChild(self.MainInterfaceScene)
      self:fun_radio()
      self.signanimations = cc.CSLoader:createNode("signanimations.csb")
      self.signanimations:setVisible(false)
      self:addChild(self.signanimations)
      self.signanimationact = cc.CSLoader:createTimeline("signanimations.csb")
      self.signanimations:runAction(self.signanimationact)
      local flashing=self.signanimations:getChildByTag(286)
      flashing:runAction( cc.Sequence:create(cc.Blink:create(3,100)))
      self.signanimationact:gotoFrameAndPlay(0,65, true)
         
       self.gamecenter_text=self.MainInterfaceScene:getChildByTag(122)   --游戏中心


      local Surprise_bt=self.MainInterfaceScene:getChildByTag(56)  --惊喜吧
      Surprise_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      local Rotary_bt=self.MainInterfaceScene:getChildByTag(444)  --转盘
      Rotary_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      local win_bt=self.MainInterfaceScene:getChildByTag(97)  --中奖
      win_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      local help_bt=self.MainInterfaceScene:getChildByTag(125)  --助力榜
      help_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

  
     
       local head=self.MainInterfaceScene:getChildByTag(37)
       local per=self.MainInterfaceScene:getChildByTag(28):getChildByTag(29)  --新的需求
          head:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      local checkin_bt= self.MainInterfaceScene:getChildByTag(6222):getChildByTag(124)  --self.signanimations:getChildByTag(290)  签到按钮
          checkin_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      
      
      self.biao_ji=self.MainInterfaceScene:getChildByTag(6222):getChildByTag(1164)--
       self.biao_ji:setVisible(false) 

       local mail_bt= self.MainInterfaceScene:getChildByTag(6222):getChildByTag(88)  --
         local mail_bt1= self.MainInterfaceScene:getChildByTag(6222):getChildByTag(580)  --邮件按钮
       mail_bt1:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

       local task_bt= self.MainInterfaceScene:getChildByTag(6222):getChildByTag(581)  --任务按钮
        local task_bt1= self.MainInterfaceScene:getChildByTag(6222):getChildByTag(92)  --任务按钮
       task_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

      local friends_bt= self.MainInterfaceScene:getChildByTag(6222):getChildByTag(89)  --
      local friends_bt1=self.MainInterfaceScene:getChildByTag(6222):getChildByTag(52)  --邀请好友排行
      friends_bt1:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)
      local friend_bt=self.MainInterfaceScene:getChildByTag(6222):getChildByTag(288)--self.signanimations:getChildByTag(291)--  邀请好友
      local friend_bt1=self.MainInterfaceScene:getChildByTag(6222):getChildByTag(90)
      friend_bt:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)
     
      self.sliding_bg=self.MainInterfaceScene:getChildByTag(6222)
      self.sliding_bg:setScale(0)
      -- local kefu_bt=self.sliding_bg:getChildByTag(6223)--客服
      -- kefu_bt:addTouchEventListener(function(sender, eventType  )
      --      self:fun_backbt(sender, eventType)
      -- end)
     
      -- local women_bt=self.sliding_bg:getChildByTag(6224)--我们
      -- women_bt:addTouchEventListener(function(sender, eventType  )
      --      self:fun_backbt(sender, eventType)
      -- end)
      local newshezhi_bt=self.sliding_bg:getChildByTag(6225)--新的设置声音
      local newshezhi_bt1=self.sliding_bg:getChildByTag(91)--新的设置声音
      newshezhi_bt:addTouchEventListener(function(sender, eventType  )
           self:fun_backbt(sender, eventType)
      end)
      checkin_bt:setScale(0)
       task_bt:setScale(0)
       friend_bt:setScale(0)
       newshezhi_bt:setScale(0)
        -- checkin_bt1:setScale(0)
       task_bt1:setScale(0)
        friend_bt1:setScale(0)
        newshezhi_bt1:setScale(0)

      self.setup_box=self.MainInterfaceScene:getChildByTag(6227)  --新的设置按钮
       self.setup_box1=self.MainInterfaceScene:getChildByTag(87)  --新的设置按钮动画显示
      --  按钮列表动画
      self.setup_box:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            sender:setTouchEnabled(false)
                            local function stopAction()
                                  sender:setTouchEnabled(true)
                                  
                            end
                            local actionTo =  cc.EaseBackOut:create(cc.RotateBy:create(0.5, 120))  
                            local actionTo2 = cc.RotateTo:create(0.2, 60)
                            local callfunc = cc.CallFunc:create(stopAction)
                            self.setup_box:runAction(cc.Sequence:create(actionTo,callfunc  ))
                            self.setup_box1:runAction(cc.Sequence:create(actionTo,callfunc  ))
                             local actionTo1 = cc.ScaleTo:create(0.2, 1,1)
                                  self.sliding_bg:runAction(actionTo1)
                           checkin_bt:setScale(0)
                          
                           checkin_bt:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                            task_bt:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                            task_bt1:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                           friend_bt:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                           newshezhi_bt:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                           friend_bt1:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                           newshezhi_bt1:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                           friends_bt:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                            friends_bt1:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                            mail_bt:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))
                            mail_bt1:runAction(cc.EaseBounceOut:create(cc.ScaleTo:create(0.5, 1)))

                     elseif eventType == ccui.CheckBoxEventType.unselected then
                              sender:setTouchEnabled(false)
                             local function stopAction()
                                  sender:setTouchEnabled(true)
                                  
                            end
                            local actionTo =cc.EaseBackOut:create(cc.RotateBy:create(0.5, -120))  
                            local actionTo2 = cc.RotateTo:create(0.2, -60)
                            local callfunc = cc.CallFunc:create(stopAction)
                            self.setup_box:runAction(cc.Sequence:create(actionTo,callfunc  ))
                            self.setup_box1:runAction(cc.Sequence:create(actionTo,callfunc  ))
                            local function stopAction1()
                                   local actionTo1 = cc.ScaleTo:create(0.2, 1,0)
                                   self.sliding_bg:runAction(actionTo1) 
                            end
                            local callfunc1 = cc.CallFunc:create(stopAction1)
                            newshezhi_bt:runAction(cc.Sequence:create(cc.EaseBounceIn:create(cc.ScaleTo:create(0.3, 0)),callfunc1))
                            task_bt:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            task_bt1:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            friend_bt:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            checkin_bt:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            friend_bt1:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            newshezhi_bt1:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            friends_bt:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            friends_bt1:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            mail_bt:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))
                            mail_bt1:runAction(cc.EaseBounceIn:create(cc.ScaleTo:create(0.4, 0)))

                     end
      end)
      self.barrier_bg=self.MainInterfaceScene:getChildByTag(396)
     
end
function MainInterfaceScene:fun_backbt( sender, eventType )
  if eventType ~= ccui.TouchEventType.ended then

     -- sender:setScale(0.8)
    return
  end
  -- sender:setScale(1)
  local tag=sender:getTag()
  if tag==6223 then
      local CustomerLayer = require("app.layers.CustomerLayer")  --关于拼乐界面  
      self:addChild(CustomerLayer.new(),1,12)
  elseif tag==6224 then
     print("我们")
     local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面  
      self:addChild(aboutdetailsLayer.new(),1,12)
  elseif tag==6225 then
    local SetLayer = require("app.layers.SetLayer")  --邀请好友
    self:addChild(SetLayer.new(),1,11)
    self.sliding_bg:setScale(0)
    self.setup_box:setSelected(false)
    elseif tag==1201 then
     print("成长树")
     --display.replaceScene(require("app.scenes.GrowingtreeScene"):new())
     Util:scene_control("GrowingtreeScene")
  end
  self.sliding_bg:setScale(0)
  self.setup_box:setSelected(false)
end
--用户数据
function MainInterfaceScene:userdata(  )
        local userdt = LocalData:Instance():get_userdata()
        local _getuserinfo=LocalData:Instance():get_getuserinfo()
       userdt["grade"]=_getuserinfo["grade"]
       userdt["diamondnum"]=_getuserinfo["diamondnum"]
       userdt["rankname"]  =  self.main_leve_name[tonumber(userdt["grade"])]
       LocalData:Instance():set_userdata(userdt)
       local head=self.MainInterfaceScene:getChildByTag(37)-- 头像
       if LocalData:Instance():get_user_head() then
            head:loadTexture(LocalData:Instance():get_user_head())   --(tostring(Util:sub_str(userdt["imageUrl"], "/",":")))   ---
       end
      
       local name=self.MainInterfaceScene:getChildByTag(38)-- 名字
       local  userdata=LocalData:Instance():get_user_data()

        local nickname=userdata["loginname"]
        local nick_sub=string.sub(nickname,1,3)
        nick_sub=nick_sub.."****"..string.sub(nickname,8,11)
        if userdt["nickname"]~="" then
            nick_sub=userdt["nickname"]
        end
        name:setString(nick_sub)
        --name:setString(userdt["nickname"])
       local crown_name=self.MainInterfaceScene:getChildByTag(41)-- 爵位
       crown_name:setString(userdt["rankname"])
       local leve=self.MainInterfaceScene:getChildByTag(39)-- 等级
       leve:setString("LV."  ..   userdt["grade"])
        local diamond=self.MainInterfaceScene:getChildByTag(6179)-- 钻石
        if userdt["diamondnum"] then
             diamond:setString(tonumber(userdt["diamondnum"]))
        end
      
       local _gd= LocalData:Instance():get_getcheckinhistory()

       if tonumber(_gd["rewardgolds"])   and   userdt["golds"]  < tonumber(_gd["rewardgolds"])    then
          userdt["golds"] =  tonumber(_gd["rewardgolds"])
       end
       LocalData:Instance():set_user_data(userdt)
       local gold_text=self.MainInterfaceScene:getChildByTag(44)-- 金币
       gold_text:setString(userdt["golds"])
      
       local loadingbar=self.MainInterfaceScene:getChildByTag(55)-- 进度条
       local jindu=tonumber(userdt["points"]) /  self.main_leve[tonumber(userdt["grade"])+1]  *  100 --self.main_leve[+1]/5000000 *100
       loadingbar:setPercent(jindu)--self.main_leve
end
function MainInterfaceScene:touch_callback( sender, eventType )
  if eventType ~= ccui.TouchEventType.ended then
    return
  end
  local tag=sender:getTag()
  if tag==56 then --惊喜吧
     Util:scene_control("GameSurpriseScene")
  elseif tag==37 then  --37
    local PerInformationLayer = require("app.layers.PerInformationLayer")--惊喜吧 
    self:addChild(PerInformationLayer.new(),1,14)
  elseif tag==124 then   --  290
      -- self.checkinlayer = cc.CSLoader:createNode("checkinLayer.csb")
      -- self:addChild(self.checkinlayer)
      -- self.checkinlayer:setVisible(true)
      --任务记录
       local _table=LocalData:Instance():get_gettasklist()
       local tasklist=_table["tasklist"]
       for i=1,#tasklist  do 
             if  tonumber(tasklist[i]["targettype"])   ==  0   then
                  LocalData:Instance():set_tasktable(tasklist[i]["targetid"])
             end
             
       end

             Server:Instance():getcheckinhistory()  --签到http
      elseif tag==444 then  --转盘
        Util:scene_control("LuckyDraw")
      elseif tag==97 then  --中奖
        Util:scene_control("TicketCenter")
      elseif tag==125 then  --助力榜
        Util:scene_control("PowerHelp")
      elseif tag==580 then  --邮箱
            print("邮箱")
            self.sliding_bg:setScale(0)
            self.setup_box:setSelected(false)
            local mailLayer = require("app.layers.mailLayer")  --关于邮箱界面
            self:addChild(mailLayer.new(),1,15)
      elseif tag==581 then  --任务
            self.sliding_bg:setScale(0)
            self.setup_box:setSelected(false)
            local taskLayer = require("app.layers.taskLayer")  --关于任务界面
            self:addChild(taskLayer.new(),1,16)
      elseif tag==91 then  --设置返回
            --self.set_bg:setVisible(false)
              Util:all_layer_backMusic()
              self.set_Xbg:setVisible(false)
          
            self.set_bg1:setVisible(false)
      elseif tag==288 then  --邀请好友  291
        local FriendrequestLayer = require("app.layers.FriendrequestLayer")  --邀请好友
            self:addChild(FriendrequestLayer.new({switch=2}),1,11)
self.sliding_bg:setScale(0)
self.setup_box:setSelected(false)
            --  local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面  
            -- self:addChild(aboutdetailsLayer.new(),1,12)


      elseif tag==54 then  --测试分享
          local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面
            self:addChild(aboutdetailsLayer.new(),1,12)
            -- self.Ruledescription = cc.CSLoader:createNode("Ruledescription.csb")
            -- self:addChild(self.Ruledescription)
      elseif tag==626 then  --商城

            -- local _table=LocalData:Instance():get_version_date()--游戏中心和 商城开关
            -- if _table and tonumber(_table["shopIsused"])==0 then
            --       local login_info=LocalData:Instance():get_user_data()
            --       local _key=login_info["loginname"]
            --       local _loginkey=login_info["loginkey"]
            --       url=Server:Instance():mall(tostring(_key),tostring(_loginkey))
            --       device.openURL(url)
            --       return
            -- end

            --  Util:scene_controlid("MallScene",{type="emil"})

      elseif tag==49 then  --加
          
      elseif tag==53 then  --设置


      elseif tag==52 then  --邀请好友
        self.sliding_bg:setScale(0)
        self.setup_box:setSelected(false)
        local InvitefriendsLayer = require("app.layers.InvitefriendsLayer")  --邀请好友排行榜
            self:addChild(InvitefriendsLayer.new(),1,13)
      elseif tag==2122 then  --商城返回
              print("返回")
              if  self.Storebrowser then
                 self.Storebrowser:removeFromParent()
                 Util:all_layer_backMusic()
              end
      elseif tag==266 then  --注销

        self.floating_layer:showFloat("您确定要退出登录？",function (sender, eventType)
                                  if eventType==1 then
                                    LocalData:Instance():set_user_data(nil)
                                    Util:deleWeixinLoginDate()
                                    Util:scene_control("LoginScene")
                                  end
                            end)
           
  end
end

function MainInterfaceScene:fun_gamecenter(  )
        local gamecenter = cc.CSLoader:createNode("gamecenter.csb")
        self:addChild(gamecenter)
        local back_bt=gamecenter:getChildByTag(326)
        back_bt:addTouchEventListener(function(sender, eventType  )
              if eventType ~= ccui.TouchEventType.ended then
                     return
              end
              gamecenter:removeFromParent()
        end)

end


function MainInterfaceScene:fun_storebrowser(  )
      self.Storebrowser = cc.CSLoader:createNode("Storebrowser.csb")
      self:addChild(self.Storebrowser)
      local back=self.Storebrowser:getChildByTag(2122)
      local store_size=self.Storebrowser:getChildByTag(2123)
      back:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)


        local login_info=LocalData:Instance():get_user_data()
              local _key=login_info["loginname"]
              local _loginkey=login_info["loginkey"]

              local webview = cc.WebView:create()
              self.Storebrowser:addChild(webview)
              webview:setVisible(true)
              webview:setScalesPageToFit(true)
              webview:loadURL(Server:Instance():mall(tostring(_key),tostring(_loginkey)))
              webview:setContentSize(cc.size(store_size:getContentSize().width   ,store_size:getContentSize().height  )) -- 一定要设置大小才能显示
              webview:reload()
              webview:setPosition(cc.p(store_size:getPositionX(),store_size:getPositionY()))

end

function MainInterfaceScene:move_layer(_layer)
      local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(0.3,cc.p(_layer:getPositionX(),curr_y))  
     local sque=transition.sequence({cc.EaseBackOut:create(move)})
      _layer:runAction(sque)
end

function MainInterfaceScene:onEnter()

  --Util:player_music_hit("GAMEBG",true )
  Server:Instance():getuserinfo()
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CHECK_POST, self,
                       function()
                        Server:Instance():getuserinfo() -- 初始化数据
                        self:fun_checkin(2)--签到后
                       self.check_button:setVisible(false)

                       self.check_biaoji:setVisible(true)

                        self:userdata()

                       

                      end)
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self,
                       function()
                        local getuserinfo=LocalData:Instance():get_getuserinfo()--保存数据
                         local gold_text=self.MainInterfaceScene:getChildByTag(44)-- 金币
                        gold_text:setString(getuserinfo["golds"])
                         local userdt = LocalData:Instance():get_userdata()
                         userdt["golds"]=getuserinfo["golds"]
                         LocalData:Instance():set_userdata(userdt)
                         self:userdata()  --  等级刷新


                       

                        
                      end)

   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CHECKINHISTORY_POST, self,
                       function()
                       self:fun_checkin(1)  --签到
                      end)

   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()                  
                               --self.biao_ji:setVisible(false) 
                               local affiche=LocalData:Instance():get_getaffiche()
                                local affichelist=affiche["affichelist"]
                                --dump(affiche)
                                if #affichelist==0 then
                                   return
                                end
                                for i=1,#affichelist do      
                                   if tonumber(affichelist[i]["isread"]) == 0   then  --1已读  0未读 
                                                 self.biao_ji:setVisible(true)
                                                return
                                     end
                              end
                      end)
NotificationCenter:Instance():AddObserver("XINYUE", self,
                       function()
                       

                       
                      end)

end

function MainInterfaceScene:onExit()
  --audio.stopMusic(G_SOUND["ACTIVITY"])
  -- Util:stop_music("ACTIVITY")
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CHECK_POST, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CHECKINHISTORY_POST, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
  NotificationCenter:Instance():RemoveObserver("XINYUE", self)
  
  cc.Director:getInstance():getTextureCache():removeAllTextures() 
end  

--android 返回键 响应
function MainInterfaceScene:listener_home() 
    local  layer=cc.Layer:create()
    self:addChild(layer)
    local function onKeyReleased(keyCode, event)
          if keyCode == cc.KeyCode.KEY_BACK then
            if self:getChildByTag(255) then
              self:removeChildByTag(255)
              return
            end
            for i=11,17 do
              if self:getChildByTag(i) then
                self:removeChildByTag(i)
                return
              end
            end
            if self.checkinlayer then
                self.fragment_sprite:setVisible(false)
                self.checkinlayer:removeFromParent()
                self.checkinlayer=nil
              return
            end
            if self.set_Xbg and self.set_Xbg:isVisible() then
              self.set_Xbg:setVisible(false) 
              self.set_bg1:setVisible(false) 
              return
            end

            if not self.floating_layer.dialog then
              self.floating_layer:showFloat("您确定要退出游戏？",function (sender, eventType)
                  if eventType==1 then
                        cc.Director:getInstance():endToLua()
                  end
              end)  
            end


          end
    end

    local listener = cc.EventListenerKeyboard:create()--
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(listener,layer)
end
--  零时加的  
function MainInterfaceScene:fun_showtip(bt_obj,_x,_y )
          if self.showtip_image~=nil then
            return
          end
          self.showtip_image= display.newSprite("png/jingqingqidai-zi.png")
          self.showtip_image:setScale(0)
          self.showtip_image:setAnchorPoint(0, 0)
          self:addChild(self.showtip_image)
          self.showtip_image:setPosition(_x, _y)

          local function removeThis()
                if self.showtip_image then
                   self.showtip_image:removeFromParent()
                   self.showtip_image=nil
                end
          end
          local actionTo = cc.ScaleTo:create(0.5, 1)
          self.showtip_image:runAction( cc.Sequence:create(actionTo,cc.DelayTime:create(0.3 ),cc.CallFunc:create(removeThis)))
end
--  广播 跑马灯
function MainInterfaceScene:fun_radio( ... )
          local LuckyDraw_text =self.MainInterfaceScene:getChildByTag(268)
          local crn=cc.ClippingRectangleNode:create(cc.rect(0,0,450,41))
          crn:setAnchorPoint(0)
          crn:setPosition(cc.p(LuckyDraw_text:getPositionX()-LuckyDraw_text:getContentSize().width/2+6,LuckyDraw_text:getPositionY()-LuckyDraw_text:getContentSize().height/2))
          self.MainInterfaceScene:addChild(crn)

          local title = ccui.Text:create("恭喜拼乐融资成功", "resources/com/huakangfangyuan.ttf", 27)
          title:setPosition(cc.p(-450,8))
          title:setAnchorPoint(cc.p(0,0))
          crn:addChild(title)
          title:setColor(cc.c3b(255, 255, 255))

                --描述动画
            local move = cc.MoveTo:create((title:getContentSize().width)/50, cc.p(-450,8))
             local callfunc = cc.CallFunc:create(function(node, value)
                    title:setPosition(cc.p(450+title:getContentSize().width,8))
                  end, {tag=0})
             local seq = cc.Sequence:create(move,cc.DelayTime:create(1),callfunc  ) 
            local rep = cc.RepeatForever:create(seq)
            title:runAction(rep)
end
function MainInterfaceScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 

function MainInterfaceScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
end 
function MainInterfaceScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end 
function MainInterfaceScene:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end


return MainInterfaceScene