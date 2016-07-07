


local MainInterfaceScene = class("MainInterfaceScene", function()
    return display.newScene("MainInterfaceScene")
end)

local PerInformationLayer = require("app.layers.PerInformationLayer")--惊喜吧  
local FriendrequestLayer = require("app.layers.FriendrequestLayer")  --邀请好友
local InvitefriendsLayer = require("app.layers.InvitefriendsLayer")  --邀请好友排行榜
local activitycodeLayer = require("app.layers.activitycodeLayer")  --活动吗
function MainInterfaceScene:ctor()
	self.floating_layer = FloatingLayerEx.new()
      self.floating_layer:addTo(self,100000)
      self.count=0
       
      self:fun_init()

   
end
function MainInterfaceScene:fun_init( )
      
      self.MainInterfaceScene = cc.CSLoader:createNode("MainInterfaceScene.csb")
      self:addChild(self.MainInterfaceScene)

      self.roleAction = cc.CSLoader:createTimeline("MainInterfaceScene.csb")
      self:runAction(self.roleAction)

      self.checkinlayer = cc.CSLoader:createNode("checkinLayer.csb")
      self:addChild(self.checkinlayer)
      self.checkinlayer:setVisible(false)


         
      local Surprise_bt=self.MainInterfaceScene:getChildByTag(56)
          Surprise_bt:addTouchEventListener(function(sender, eventType  )
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
      local jackpot_bt=self.MainInterfaceScene:getChildByTag(97)
          jackpot_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      local true_bt=self.MainInterfaceScene:getChildByTag(397):getChildByTag(399)
          true_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       local head=self.MainInterfaceScene:getChildByTag(37)
          head:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
      local checkin_bt=self.MainInterfaceScene:getChildByTag(124)
          checkin_bt:addTouchEventListener(function(sender, eventType  )
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
      local setup_bt=self.actbg:getChildByTag(53)  --设置按钮
      setup_bt:addTouchEventListener(function(sender, eventType  )

           self:touch_callback(sender, eventType)
      end)
      local friends_bt=self.actbg:getChildByTag(52)  --邀请好友排行
      friends_bt:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)
      local friend_bt=self.MainInterfaceScene:getChildByTag(288)--邀请好友
      friend_bt:addTouchEventListener(function(sender, eventType  )
           self:touch_callback(sender, eventType)
      end)
       local fenxiang_bt=self.actbg:getChildByTag(54)--测试分享
      fenxiang_bt:addTouchEventListener(function(sender, eventType  )
           print("规则额")
           self:touch_callback(sender, eventType)
      end)
     


      self.barrier_bg=self.MainInterfaceScene:getChildByTag(396)
      self.kuang=self.MainInterfaceScene:getChildByTag(397)

      self.activitycode_text = self.kuang:getChildByTag(58)

      self:userdata()

end
--用户数据
function MainInterfaceScene:userdata(  )
       local userdt = LocalData:Instance():get_userdata()
       dump(userdt)
       local head=self.MainInterfaceScene:getChildByTag(37)-- 头像
       head:loadTexture("cre/"..LocalData:Instance():get_user_head())--(tostring(Util:sub_str(userdt["imageUrl"], "/",":")))
       local name=self.MainInterfaceScene:getChildByTag(38)-- 名字
       name:setString(userdt["nickname"])
       local crown_name=self.MainInterfaceScene:getChildByTag(41)-- 爵位
       crown_name:setString(userdt["rankname"])
       local leve=self.MainInterfaceScene:getChildByTag(39)-- 等级
       leve:setString(userdt["grade"])
       local gold_text=self.MainInterfaceScene:getChildByTag(44)-- 金币
       print("hahhahhahahhahfewahiufhewfh")
       gold_text:setString(userdt["golds"])
       local diamond_text=self.MainInterfaceScene:getChildByTag(45)-- 钻石
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
    self:addChild(activitycodeLayer.new())
		-- self.barrier_bg:setVisible(true)
		-- self.kuang:setVisible(true)
	elseif tag==37 then
		self:addChild(PerInformationLayer.new())
	elseif tag==399 then --弹出确定
		Server:Instance():validateactivitycode(self.activitycode_text:getString())
		self.activitycode_text:setString(" ")
	elseif tag==97 then
		Util:scene_control("GoldprizeScene")
	elseif tag==124 then
	           Server:Instance():getcheckinhistory()  --签到http
      elseif tag==48 then  --设置
            self:funsetup(  )
      elseif tag==91 then  --设置返回
            --self.set_bg:setVisible(false)
            self.set_bg1:setVisible(false)
      elseif tag==288 then  --邀请好友
            self:addChild(FriendrequestLayer.new())
      elseif tag==54 then  --测试分享
            print("规则")
            -- self.Ruledescription = cc.CSLoader:createNode("Ruledescription.csb")
            -- self:addChild(self.Ruledescription)
      elseif tag==626 then  --商城
            device.openURL("http://playios.pinlegame.com/P_default.aspx?")

      elseif tag==49 then  --加
            if self.roleAction:getStartFrame()==0 then
                  self.actbg:setVisible(true)
                  self.roleAction:gotoFrameAndPlay(40,81, false)
            else
                  self.roleAction:gotoFrameAndPlay(0,40, false)
                  self.actbg:setVisible(true)
            end
      elseif tag==53 then  --设置
            self:funsetup(  )
            

      elseif tag==52 then  --邀请好友
            self:addChild(InvitefriendsLayer.new())
      elseif tag==266 then  --注销
            Util:scene_control("LoginScene")
	end
end




function MainInterfaceScene:funsetup(  )
        -- self.set_bg=self.MainInterfaceScene:getChildByTag(88)
        -- self.set_bg:setVisible(true)
        self.set_bg1=self.MainInterfaceScene:getChildByTag(89)
        self.set_bg1:setVisible(true)
        local set_back=self.set_bg1:getChildByTag(91)
        set_back:addTouchEventListener(function(sender, eventType  )
              self:touch_callback(sender, eventType)
        end)
        local cancellation_bt=self.set_bg1:getChildByTag(266)--注销功能
        cancellation_bt:addTouchEventListener(function(sender, eventType  )
            self:touch_callback(sender, eventType)
      end)

        local music_bt=self.set_bg1:getChildByTag(93)  -- 音乐
        music_bt:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开启")
                            LocalData:Instance():set_music(true)
                            --audio.resumeMusic()
                            Util:player_music("ACTIVITY",true )
                            
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                             LocalData:Instance():set_music(false)
                             --audio.pauseMusic()
                             Util:stop_music("ACTIVITY")
                     end
        end)
        local sound_bt=self.set_bg1:getChildByTag(92)  -- 音效
        sound_bt:addEventListener(function(sender, eventType  )
                 if eventType == ccui.CheckBoxEventType.selected then
                        print("开启")
                         LocalData:Instance():set_music(true)
                        audio.resumeAllSounds()--恢复所有音效
                       --Util:player_music("ACTIVITY",true )
                 elseif eventType == ccui.CheckBoxEventType.unselected then
                        LocalData:Instance():set_music(false)
                        audio.pauseAllSounds()  --关闭所有音效
                         --Util:stop_music("ACTIVITY")
                 end
         end)

end
--签到
function MainInterfaceScene:fun_checkin( tm )
	 self.checkinlayer:setVisible(false)
        --签到增加的金币
        if tm==2 then
          local _sig=LocalData:Instance():get_getcheckinhistory()
          local userdt = LocalData:Instance():get_userdata()
          userdt["golds"]=_sig["playerinfo"]["golds"]
          LocalData:Instance():set_userdata(userdt) --  保存数据
        end
        


	local back_bt=self.checkinlayer:getChildByTag(84)  --返回
	back_bt:addTouchEventListener(function(sender, eventType  )
	       if eventType ~= ccui.TouchEventType.ended then
		      return
	       end
             self.checkinlayer:setVisible(false)
	       
	end)
	local check_bt=self.checkinlayer:getChildByTag(87)
      self.check_button=check_bt
	check_bt:addTouchEventListener(function(sender, eventType  )
	       if eventType ~= ccui.TouchEventType.ended then
		return
	       end
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
            	       _bg:setPosition(cc.p(_bg:getPositionX()+_size.width*(j-1),_bg:getPositionY()-_size.height* math.ceil(i-1)))
            	       self.checkinlayer:addChild(_bg)
        		      
        		end
        	end
        	for i=1,totaydays-math.ceil(totaydays/7-1)*7 do
        		 local _bg=day_bg:clone()
        		 local  day_text=_bg:getChildByTag(86)
                   local biaoji=_bg:getChildByTag(484)
                         day_text:setString( math.ceil(totaydays/7-1)*7+i)
                         _table[math.ceil(totaydays/7-1)*7+i]=day_text
                         _biaojitable[math.ceil(totaydays/7-1)*7+i]=biaoji
            	 _bg:setPosition(cc.p(_bg:getPositionX()+_size.width*(i-1),_bg:getPositionY()-_size.height* math.ceil(totaydays/7-1)))
            	 self.checkinlayer:addChild(_bg)
        	end
              _biaojitable[16]:loadTexture("png/Qprize.png")
              _biaojitable[16]:setVisible(true)
              if not days then
                self.checkinlayer:setVisible(true)
                  return
              end
           
            for i=1,totaydays do
                  if #days==0 then
                      break
                  end
            	for j=1,#days do
            		if i==tonumber(os.date("%d",days[j])) then
                              if i==16 then
                                _biaojitable[i]:loadTexture("res/png/Qprizeopen.png")
                              end
            			_table[i]:setColor(cc.c3b(125, 125, 100))
                              _biaojitable[i]:setVisible(true)
            		end
            	end
            end

            self.checkinlayer:setVisible(true)
             if tonumber(days[#days]) ==tonumber(LocalData:Instance():get_isign()) then
                Server:Instance():prompt("今天您已经签到，请改天再签")
                self.check_button:setTouchEnabled(false)
            else
               self.check_button:setTouchEnabled(true)
            end
            LocalData:Instance():set_isign(days[#days])
end
function MainInterfaceScene:onEnter()
  --audio.playMusic(G_SOUND["ACTIVITY"],true)
  Util:player_music("ACTIVITY",true )
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CHECK_POST, self,
                       function()
                       self:fun_checkin(2)--签到后
                      end)
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CHECKINHISTORY_POST, self,
                       function()
                       self:fun_checkin(1)  --签到
                      end)
end

function MainInterfaceScene:onExit()
  --audio.stopMusic(G_SOUND["ACTIVITY"])
  Util:stop_music("ACTIVITY")
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CHECK_POST, self)
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CHECKINHISTORY_POST, self)
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
















return MainInterfaceScene