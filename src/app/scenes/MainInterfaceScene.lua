


local MainInterfaceScene = class("MainInterfaceScene", function()
    return display.newScene("MainInterfaceScene")
end)

function MainInterfaceScene:extend12()
       -- self.Laohuji = cc.CSLoader:createNode("HitVolesLayer.csb")
       -- self:addChild(self.Laohuji)
       -- local spr=display.newSprite("png/dadishu.png")
       -- spr:setAnchorPoint(cc.p(0,0.0))
       --   self:addChild(spr)

       --    local HitVolesLayer = require("app.layers.HitVolesLayer")--惊喜吧 
       --   self:addChild(HitVolesLayer.new())


          local bigwheelLayer = require("app.layers.bigwheelLayer")--惊喜吧 
         --self:addChild(bigwheelLayer.new())
         display.replaceScene(bigwheelLayer:new())
          -- cc.Director:getInstance():pushScene(bigwheelLayer.new({})) 
end
 
function MainInterfaceScene:ctor()

	    self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self.count=0

      self:Physics_homeback_ref()

       local userdt = LocalData:Instance():get_userdata()
      -- local  LocalData:Instance():set_getuserinfo(self.data)
      LocalData:Instance():set_sign(1)
        local _index=string.match(tostring(Util:sub_str(userdt["imageUrl"], "/",":")),"%d%d")
        if _index==nil then
          _index=string.match(tostring(Util:sub_str(userdt["imageUrl"], "/",":")),"%d")
        end
        LocalData:Instance():set_user_head( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))
       Server:Instance():getconfig()  --  获取后台音效

      self:listener_home() --注册安卓返回键
      Server:Instance():gettasklist()   --  初始化任务
      --手机归属请求
      Server:Instance():getusercitybyphone()--手机归属
      self:fun_init()
      Server:Instance():getaffichelist(1)
       --self:hammerAction()
        -- local spr=display.newSprite("dadishu-wanfajieshao-xinxin.png")
        -- spr:setPosition(cc.p(display.cx,display.cy))
        -- self:addChild(spr)
         -- local particle2 = cc.ParticleSystemQuad:create("zhuanpan_huang.plist")
         -- particle2:setPosition(cc.p(display.cx,display.cy))
         -- particle2:setScale(0.5)
         -- self:addChild(particle2)

     
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


       self.biao_ji=self.MainInterfaceScene:getChildByTag(1164)--
       self.biao_ji:setVisible(false) 

      self.roleAction = cc.CSLoader:createTimeline("MainInterfaceScene.csb")
      self:runAction(self.roleAction)
      self.roleAction:setTimeSpeed(0.3)

      self.signanimations = cc.CSLoader:createNode("signanimations.csb")
      self.signanimations:setVisible(false)
      self:addChild(self.signanimations)
      self.signanimationact = cc.CSLoader:createTimeline("signanimations.csb")
      self.signanimations:runAction(self.signanimationact)
      local flashing=self.signanimations:getChildByTag(286)
      flashing:runAction( cc.Sequence:create(cc.Blink:create(3,100)))
      self.signanimationact:gotoFrameAndPlay(0,65, true)
         
      local Surprise_bt=self.MainInterfaceScene:getChildByTag(56)
          Surprise_bt:addTouchEventListener(function(sender, eventType  )
         self:touch_callback(sender, eventType)
      end)
       self.gamecenter_text=self.MainInterfaceScene:getChildByTag(122)   --游戏中心
      self.gamecenter_bt=self.MainInterfaceScene:getChildByTag(444)   --游戏中心
          self.gamecenter_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       local _table=LocalData:Instance():get_version_date()--游戏中心和 商城开关
        if _table and tonumber(_table["gameIsused"])==0 then  --  0 苹果测试  1  正式
          self.gamecenter_bt:setTouchEnabled(false)
           self.gamecenter_text:setVisible(false)
        else
           self.gamecenter_bt:setTouchEnabled(true)
          self.gamecenter_text:setVisible(false)
        end

      self.list_bt=self.MainInterfaceScene:getChildByTag(125)   --  排行榜
          self.list_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

      local activitycode_bt=self.MainInterfaceScene:getChildByTag(72)
          activitycode_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

      local mall_bt=self.MainInterfaceScene:getChildByTag(626)  --商城
      mall_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

     
      -- if _table and tonumber(_table["shopIsused"])==0 then
      --   mall_bt:setTouchEnabled(false)
      -- end


      local jackpot_bt=self.MainInterfaceScene:getChildByTag(97)
          jackpot_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      local true_bt=self.MainInterfaceScene:getChildByTag(397):getChildByTag(399)
          true_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       local head=self.MainInterfaceScene:getChildByTag(37)
       local per=self.MainInterfaceScene:getChildByTag(28):getChildByTag(29)  --新的需求
          head:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      local checkin_bt= self.MainInterfaceScene:getChildByTag(124)  --self.signanimations:getChildByTag(290)  签到按钮
          checkin_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       local mail_bt= self.MainInterfaceScene:getChildByTag(580)  --邮件按钮
       mail_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

       local task_bt= self.MainInterfaceScene:getChildByTag(581)  --任务按钮
       task_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

      local setup_bt=self.MainInterfaceScene:getChildByTag(48)  --设置
      setup_bt:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)
      local jia_bt=self.MainInterfaceScene:getChildByTag(49)
      jia_bt:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)
      self.actbg=self.MainInterfaceScene:getChildByTag(51)--加动画
      self.actbg:setVisible(false)
      local setup_bt=self.MainInterfaceScene:getChildByTag(53)  --设置按钮
      setup_bt:addTouchEventListener(function(sender, eventType  )

           self:touch_callback(sender, eventType)
      end)
      local friends_bt=self.MainInterfaceScene:getChildByTag(52)  --邀请好友排行
      friends_bt:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)
      local friend_bt=self.MainInterfaceScene:getChildByTag(288)--self.signanimations:getChildByTag(291)--  邀请好友
      friend_bt:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)
       local fenxiang_bt=self.actbg:getChildByTag(54)--测试分享
      fenxiang_bt:addTouchEventListener(function(sender, eventType  )
           print("规则额")
           self:touch_callback(sender, eventType)
      end)
      self.sliding_bg=self.MainInterfaceScene:getChildByTag(6222)
      self.sliding_bg:setScale(0)
      local kefu_bt=self.sliding_bg:getChildByTag(6223)--客服
      kefu_bt:addTouchEventListener(function(sender, eventType  )
           self:fun_backbt(sender, eventType)
      end)
      local women_bt=self.sliding_bg:getChildByTag(6224)--我们
      women_bt:addTouchEventListener(function(sender, eventType  )
           self:fun_backbt(sender, eventType)
      end)
      local newshezhi_bt=self.sliding_bg:getChildByTag(6225)--新的设置声音
      newshezhi_bt:addTouchEventListener(function(sender, eventType  )
           self:fun_backbt(sender, eventType)
      end)
      self.setup_box=self.MainInterfaceScene:getChildByTag(6227)  --新的设置按钮
      self.setup_box:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            --self.sliding_bg:setScale(1)
                            local actionTo = cc.ScaleTo:create(0.2, 1)
                           self.sliding_bg:runAction(actionTo)

                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             --self.sliding_bg:setScale(0)
                             local actionTo = cc.ScaleTo:create(0.2, 0)
                             self.sliding_bg:runAction(actionTo)
                     end
      end)
     


      self.barrier_bg=self.MainInterfaceScene:getChildByTag(396)
      self.kuang=self.MainInterfaceScene:getChildByTag(397)

      self.activitycode_text = self.kuang:getChildByTag(58)


end
function MainInterfaceScene:fun_backbt( sender, eventType )
  if eventType ~= ccui.TouchEventType.ended then
     sender:setScale(0.8)
    return
  end
  sender:setScale(1)
  local tag=sender:getTag()
  if tag==6223 then
      local CustomerLayer = require("app.layers.CustomerLayer")  --关于拼乐界面  
      self:addChild(CustomerLayer.new(),1,12)
  elseif tag==6224 then
     print("我们")
     local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面  
      self:addChild(aboutdetailsLayer.new(),1,12)
  elseif tag==6225 then
     print("声音")
     self:funsetup( true )
     
     
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
       LocalData:Instance():set_userdata(userdt)
       local head=self.MainInterfaceScene:getChildByTag(37)-- 头像
       head:loadTexture(LocalData:Instance():get_user_head())   --(tostring(Util:sub_str(userdt["imageUrl"], "/",":")))   ---
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
       local diamond_text=self.MainInterfaceScene:getChildByTag(45)-- 
       diamond_text:setString("0")--loadingBar:setPercent(0)
       local loadingbar=self.MainInterfaceScene:getChildByTag(55)-- 进度条
       local jindu=userdt["grade"]/8 *100
       loadingbar:setPercent(jindu)
end
function MainInterfaceScene:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
	if tag==56 then --惊喜吧
		 Util:scene_control("SurpriseScene")
	elseif tag==72 then --活动码
    local activitycodeLayer = require("app.layers.activitycodeLayer")  --活动吗
    self:addChild(activitycodeLayer.new(),1,255)
		-- self.barrier_bg:setVisible(true)
		-- self.kuang:setVisible(true)
	elseif tag==37 then  --37
    local PerInformationLayer = require("app.layers.PerInformationLayer")--惊喜吧 
		self:addChild(PerInformationLayer.new(),1,14)
	elseif tag==399 then --弹出确定
		Server:Instance():validateactivitycode(self.activitycode_text:getString())
		self.activitycode_text:setString(" ")
	elseif tag==97 then
		Util:scene_control("GoldprizeScene")
     --Util:scene_control("PhysicsScene")
      elseif tag==444 then  --游戏中心

            local _table=LocalData:Instance():get_version_date()--游戏中心和 商城开关
            if _table and tonumber(_table["gameIsused"])==0 then  --  0 苹果测试  1  正式
                    self:fun_gamecenter()
                    return
            end
            Util:scene_controlid("MallScene",{type="play_mode"})
      elseif tag==125 then 
              --self:fun_showtip( self.list_bt,sender:getPositionX(),sender:getPositionY())
              --self.list_bt:setTouchEnabled(false)
               local RichlistLayer = require("app.layers.RichlistLayer")--排行榜 
         self:addChild(RichlistLayer.new(),1,17)


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
      elseif tag==48 then  --设置
            self:funsetup( true )
      elseif tag==580 then  --邮箱
            print("邮箱")
            local mailLayer = require("app.layers.mailLayer")  --关于邮箱界面
            self:addChild(mailLayer.new(),1,15)
      elseif tag==581 then  --任务
            print("任务")
            local taskLayer = require("app.layers.taskLayer")  --关于任务界面
            self:addChild(taskLayer.new(),1,16)
      elseif tag==91 then  --设置返回
            --self.set_bg:setVisible(false)
              Util:all_layer_backMusic()
              self.set_Xbg:setVisible(false)
          
            self.set_bg1:setVisible(false)
      elseif tag==288 then  --邀请好友  291
        local FriendrequestLayer = require("app.layers.FriendrequestLayer")  --邀请好友
            self:addChild(FriendrequestLayer.new(),1,11)

            --  local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面  
            -- self:addChild(aboutdetailsLayer.new(),1,12)


      elseif tag==54 then  --测试分享
          local aboutdetailsLayer = require("app.layers.aboutdetailsLayer")  --关于拼乐界面
            self:addChild(aboutdetailsLayer.new(),1,12)
            -- self.Ruledescription = cc.CSLoader:createNode("Ruledescription.csb")
            -- self:addChild(self.Ruledescription)
      elseif tag==626 then  --商城

            local _table=LocalData:Instance():get_version_date()--游戏中心和 商城开关
            if _table and tonumber(_table["shopIsused"])==0 then
                  local login_info=LocalData:Instance():get_user_data()
                  local _key=login_info["loginname"]
                  local _loginkey=login_info["loginkey"]
                  url=Server:Instance():mall(tostring(_key),tostring(_loginkey))
                  device.openURL(url)
                  return
            end

             Util:scene_controlid("MallScene",{type="emil"})
             


      elseif tag==49 then  --加
            if self.roleAction:getStartFrame()==0 then
                  print("0000000")
                  self.actbg:setVisible(true)
                  self.roleAction:gotoFrameAndPlay(45,0, false)
            else
              print("111111")
                  self.roleAction:gotoFrameAndPlay(0,45, false)
                  self.actbg:setVisible(false)
            end
      elseif tag==53 then  --设置
            self:funsetup( true )

      elseif tag==52 then  --邀请好友
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


function MainInterfaceScene:funsetup( Isture )
        -- self.set_bg=self.MainInterfaceScene:getChildByTag(88)
        -- self.set_bg:setVisible(true)
        
        self.set_bg1=self.MainInterfaceScene:getChildByTag(89)
        self.set_Xbg=self.MainInterfaceScene:getChildByTag(563)
        self.set_Xbg:setVisible(Isture)
        self.set_bg1:setVisible(Isture)
        -- self.fragment_sprite1 = cc.CSLoader:createNode("masklayer.csb")  --邀请好友排行榜
        -- self:addChild(self.fragment_sprite1)
        -- self.fragment_sprite1:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png")
        --  self.fragment_sprite1:getChildByTag(135):setTouchEnabled(false) 



          self:move_layer(self.set_bg1)
        self.set_bg1:setVisible(Isture)
        local set_back=self.set_bg1:getChildByTag(91)
        set_back:addTouchEventListener(function(sender, eventType  )
              self:touch_callback(sender, eventType)
        end)
        local cancellation_bt=self.set_bg1:getChildByTag(266)--注销功能
        cancellation_bt:addTouchEventListener(function(sender, eventType  )
            self:touch_callback(sender, eventType)
      end)

        local music_bt=self.set_bg1:getChildByTag(93)  -- 音乐
        local sound_bt=self.set_bg1:getChildByTag(92)  -- 音效

        local getconfig=LocalData:Instance():get_getconfig()
        local _list = getconfig["list"]
        local _list1=_list[1]["sataus"]
        local _list2=_list[2]["sataus"]
        if tonumber(_list1) == 0 then  --o 开  1  关闭
           music_bt:setSelected(true)
           audio.resumeMusic()
        else
           music_bt:setSelected(false)
           audio.pauseMusic()
        end
         if tonumber(_list2) == 0 then  --o 开  1  关闭
           sound_bt:setSelected(true)
           audio.resumeAllSounds()
        else
           sound_bt:setSelected(false)
           audio.pauseAllSounds()
        end
       


        music_bt:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开启")
                            LocalData:Instance():set_music_hit(true)
                            audio.resumeMusic()
                            Util:player_music_hit("ACTIVITY",true )
                             Server:Instance():setconfig(_list[1]["itemsId"],0)  --  获取后台音效
                            
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                             LocalData:Instance():set_music_hit(false)
                             audio.pauseMusic()
                             Util:stop_music("ACTIVITY")
                             Server:Instance():setconfig(_list[1]["itemsId"],1)  --  获取后台音效
                     end
        end)
       
        sound_bt:addEventListener(function(sender, eventType  )
                 if eventType == ccui.CheckBoxEventType.selected then
                        print("开启")
                         LocalData:Instance():set_music(true)
                        --audio.resumeAllSounds()--恢复所有音效
                        Server:Instance():setconfig(_list[2]["itemsId"],0)  --  获取后台音效
                       -- Util:player_music_hit("ACTIVITY",true )
                 elseif eventType == ccui.CheckBoxEventType.unselected then
                        LocalData:Instance():set_music(false)
                        --audio.pauseAllSounds()  --关闭所有音效
                        Server:Instance():setconfig(_list[2]["itemsId"],1)  --  获取后台音效
                         -- Util:stop_music("ACTIVITY")
                 end
         end)

end
-- function function_name( ... )

--       local function CallFucnCallback3(sender)
--                      local check_bt=self.checkinlayer:getChildByTag(81) 
--                      check_bt:setVisible(true)                                     
--       end
--      local move = cc.MoveTo:create(0.5, cc.p(0,0))
--      local move1 = cc.MoveTo:create(0.2, cc.p(0,10))
--      local move2 = cc.MoveTo:create(0.2, cc.p(0,0))
--      local move3 = cc.MoveTo:create(0.1, cc.p(0,8))
--      local move4 = cc.MoveTo:create(0.1, cc.p(0,0))
--      self.checkinlayer:runAction(cc.Sequence:create(move,move1,move2,move3,move4,cc.CallFunc:create(CallFucnCallback3)))
-- end

function MainInterfaceScene:move_layer(_layer)
      local curr_y=_layer:getPositionY()
    _layer:setPositionY(curr_y+_layer:getContentSize().height)
    local move =cc.MoveTo:create(0.3,cc.p(_layer:getPositionX(),curr_y))  
     local sque=transition.sequence({cc.EaseBackOut:create(move)})
      _layer:runAction(sque)
end

--签到
function MainInterfaceScene:fun_checkin( tm )

      if not self.checkinlayer then   --GRzhezhaoceng
         self.fragment_sprite = cc.CSLoader:createNode("masklayer.csb")  --背景层
        self:addChild(self.fragment_sprite)
        self.fragment_sprite:getChildByTag(135):loadTexture("png/GRzhezhaoceng.png") 
         self.checkinlayer = cc.CSLoader:createNode("checkinLayer.csb")
         self:addChild(self.checkinlayer,1,17)
         self.checkinlayer:setVisible(true)
         self:move_layer(self.checkinlayer)
      end

      if not self.checkinlayer then
        return
      end
      
      if tm==2 then
            local _sig=LocalData:Instance():get_getcheckinhistory()
            local userdt = LocalData:Instance():get_userdata()
            userdt["golds"]=_sig["playerinfo"]["golds"]
            LocalData:Instance():set_userdata(userdt) --  保存数据

          --       签到增加的金币
            -- self.Signinact = cc.CSLoader:createNode("Signinact.csb")
            -- self.checkinlayer:addChild(self.Signinact)
            -- self.Signin_act = cc.CSLoader:createTimeline("Signinact.csb")
            -- self.Signinact:runAction(self.Signin_act)
            -- self.Signin_act:gotoFrameAndPlay(0,80, false)
             if LocalData:Instance():get_music() then
                audio.playSound("sound/effect/jinbidiaoluo.mp3",false)
             end
            


        local particle = cc.ParticleSystemQuad:create("goldCoin(3).plist")
        particle:setPosition(display.cx,display.cy*4/5)
        particle:setDuration(1)
        self:addChild(particle,300)


          -- Util:scene_control("MainInterfaceScene")  --禁止
        end
        
	local back_bt=self.checkinlayer:getChildByTag(84)  --返回
	back_bt:addTouchEventListener(function(sender, eventType  )
	       if eventType ~= ccui.TouchEventType.ended then
		      return
	       end
         self.fragment_sprite:setVisible(false)
         self.checkinlayer:removeFromParent()
             self.checkinlayer=nil
             Server:Instance():gettasklist()   --目的是刷新任务数据
             Util:all_layer_backMusic()
	       
	end)
	local check_bt=self.checkinlayer:getChildByTag(87)
      self.check_button=check_bt
	check_bt:addTouchEventListener(function(sender, eventType  )
	       if eventType ~= ccui.TouchEventType.ended then
		     return
	       end
             if LocalData:Instance():get_tasktable() then
               Server:Instance():settasktarget(LocalData:Instance():get_tasktable())
             end
             LocalData:Instance():set_tasktable(nil)--制空
	       Server:Instance():checkin()  --发送消息
	end)

	self:init_checkin()-- 初始化签到数据



end
--签到 初始化
function MainInterfaceScene:init_checkin(  )
     


	local  day_bg=self.checkinlayer:getChildByTag(85)
	local  day_text=day_bg:getChildByTag(86)
	local   _size=day_bg:getContentSize()

	local  checkindata=LocalData:Instance():get_getcheckinhistory() --用户数据
	local  days=checkindata["days"]

            local  totaydays=checkindata["totaldays"]
            local check_data=self.checkinlayer:getChildByTag(40)
            self.check_biaoji=self.checkinlayer:getChildByTag(39)

             --check_data:loadTexture(string.format("png/qiandao_%d.png", totaydays))
            local  _table={}
            local  _biaojitable={}
            for i=1, math.ceil(totaydays/7-1) do
            	for j=1,7 do
            	       local _bg=day_bg:clone()
            	       local  day_text=_bg:getChildByTag(86)
                         local biaoji=_bg:getChildByTag(484)
                         biaoji:setVisible(false)
                               day_text:setString((i-1)*7+j)
                               _table[(i-1)*7+j]=day_text
                               _biaojitable[(i-1)*7+j]=biaoji
            	       _bg:setPosition(cc.p(_bg:getPositionX()+(_size.width+8)*(j-1),_bg:getPositionY()-_size.height* math.ceil(i-1)))
            	       self.checkinlayer:addChild(_bg)
        		      
        		end
        	end
        	for i=1,totaydays-math.ceil(totaydays/7-1)*7 do
        		 local _bg=day_bg:clone()
        		 local  day_text=_bg:getChildByTag(86)
                   local biaoji=_bg:getChildByTag(484)
                   biaoji:setVisible(false)
                         day_text:setString( math.ceil(totaydays/7-1)*7+i)
                         _table[math.ceil(totaydays/7-1)*7+i]=day_text
                         _biaojitable[math.ceil(totaydays/7-1)*7+i]=biaoji
            	 _bg:setPosition(cc.p(_bg:getPositionX()+(_size.width+8)*(i-1),_bg:getPositionY()-_size.height* math.ceil(totaydays/7-1)))
            	 self.checkinlayer:addChild(_bg)
        	end
              _biaojitable[16]:loadTexture("png/Qprize.png")
              --_biaojitable[16]:setVisible(true)
              if not days then
                --self.checkinlayer:setVisible(true)
                  return
              end
           
            for i=1,totaydays do
                  if #days==0 then
                      break
                  end
            	for j=1,#days do
            		if i==tonumber(os.date("%d",days[j])) then
                              if i==16 then
                                _biaojitable[i]:loadTexture("res/png/Qprize.png")
                              end
            			_table[i]:setColor(cc.c3b(62, 165, 216))
                              _biaojitable[i]:setVisible(true)
            		end
            	end
            end

            local tm = os.date("*t")
            if tm.day ==tonumber(os.date("%d",days[1])) then   --  获取系统时间
                self.check_button:setVisible(false)

                self.check_biaoji:setVisible(true)

                return
            else
               self.check_button:setVisible(true)
            end
end
function MainInterfaceScene:onEnter()
  Util:player_music_hit("ACTIVITY",true )
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
                                print("邮件按钮")                   
                               --self.biao_ji:setVisible(false) 
                               local affiche=LocalData:Instance():get_getaffiche()
                                local affichelist=affiche["affichelist"]
                                dump(affiche)
                                if #affichelist==0 then
                                   return
                                end
                                print("邮件按钮111") 
                                for i=1,#affichelist do   
                                print("邮件按钮22222")      
                                   if tonumber(affichelist[i]["isread"]) == 0   then  --1已读  0未读 
                                    print("邮件按钮3333") 
                                                 self.biao_ji:setVisible(true)
                                                return
                                     end
                              end
                      end)
NotificationCenter:Instance():AddObserver("XINYUE", self,
                       function()
                       self:funsetup(false)  
                      end)

end

function MainInterfaceScene:onExit()
  --audio.stopMusic(G_SOUND["ACTIVITY"])
  Util:stop_music("ACTIVITY")
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CHECK_POST, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CHECKINHISTORY_POST, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.USERINFOINIT_LAYER_IMAGE, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
  NotificationCenter:Instance():RemoveObserver("XINYUE", self)
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

            self.floating_layer:showFloat("您确定要退出游戏？",function (sender, eventType)
                if eventType==1 then
                      cc.Director:getInstance():endToLua()
                end
            end)  


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
function MainInterfaceScene:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
       self.barrier_bg:setVisible(false)
       self.kuang:setVisible(false)
   else
   	self.barrier_bg:setVisible(false)
	self.kuang:setVisible(false)
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