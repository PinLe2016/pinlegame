--
-- Author: Your Name
-- Date: 2016-05-05 10:31:25
--
--
-- Author: Your Name
-- Date: 2016-04-19 09:45:07
--

local GameScene = class("GameScene", function()
      return display.newScene("GameScene")
end)


local debrisLayer = require("app.layers.debrisLayer")
local SurpriseOverScene = require("app.scenes.SurpriseOverScene")

function GameScene:ctor(params)
    self.heroid=params.heroid
    self.cycle=params.cycle
    self.floating_layer = FloatingLayerEx.new()

    self.floating_layer:addTo(self,-1)
    self._time=5

    self.type=params.type

    self.image= params.image

    self.adid=params.adid

    self.id=params.id
    if params.img then
      self.img=params.img
    end

     if params.adownerid then
          self.adownerid = params.adownerid
          self.goldspoolcount=params.goldspoolcount
     end


      if self.type=="daojishi" then
         self.countdownLayer = cc.CSLoader:createNode("countdownLayer.csb")
         self:addChild(self.countdownLayer)
      else
         local csb = cc.CSLoader:createNode("XSHGameScene.csb")
      self._csb=csb
      self:addChild(csb)
      end
     
    self:listener_home() --注册安卓返回键
     
end
function GameScene:funinit(  )

       self._kuang=self._csb:getChildByTag(53)
      local back_bt=self._csb:getChildByTag(21)  -- 禁返回
      back_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)
      local music_bt=self._csb:getChildByTag(22) -- 禁音效
      music_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)
      self.restore_bt=self._csb:getChildByTag(23)--查看原图
      self._restore_bt=self.restore_bt
      self.restore_bt:setTouchEnabled(false)
      self.restore_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)
       self.suspended_bt=self._csb:getChildByTag(44)--暂停
       self.suspended_bt:setTouchEnabled(false)
       self.suspended_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)

      self:originalimage(1)  
      local node = cc.CSLoader:createNode("battlestart.csb")
      local action = cc.CSLoader:createTimeline("battlestart.csb")
      action:setTimeSpeed(0.25)
      node:runAction(action)
      action:gotoFrameAndPlay(15,90,false)
      local function stopAction()
                  local kuang=self._csb:getChildByTag(53)
                  local _size=kuang:getContentSize()
                  local point={}
                  point.x=kuang:getPositionX()
                  point.y=kuang:getPositionY()
                   if self.type=="surprise" then
                      local list_table=LocalData:Instance():get_getactivityadlist()["ads"]

                      local deblayer= debrisLayer.new({filename=tostring(Util:sub_str(list_table[1]["imgurl"], "/",":"))
                     ,row=3,col=4,_size=_size,point=point,adid=self.adid,tp=1,type=self.type})
                      self._csb:addChild(deblayer)
                  elseif self.type=="audition" then

                     --  local deblayer= debrisLayer.new({filename=self.image
                     -- ,row=3,col=4,_size=_size,point=point,adid=self.adid,tp=2})
                     --  self._csb:addChild(deblayer)
                        local  list_table=LocalData:Instance():get_getgoldspoollistbale()
                        local  jaclayer_data=list_table["adlist"]

                        -- print("你猜",self.adid)
                      local deblayer= debrisLayer.new({filename=tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":"))
                     ,row=3,col=4,_size=_size,point=point,adid=jaclayer_data[1]["adid"],tp=1,type=self.type,adownerid=self.adownerid,goldspoolcount=self.goldspoolcount})   --self.adid
                      self._csb:addChild(deblayer)

                  end

                  if  node then
                     node:removeFromParent()
                 end
                 if  self._originalimage then
                     self._originalimage:removeFromParent()
                 end
                 self.suspended_bt:setTouchEnabled(true)
                 self.restore_bt:setTouchEnabled(true)
                    
      end
      local callfunc = cc.CallFunc:create(stopAction)
      node:runAction(cc.Sequence:create(cc.DelayTime:create(6),callfunc  ))
      self:addChild(node)

end
function GameScene:csb_btCallback(sender, eventType)
      if eventType ~= ccui.TouchEventType.ended then
                       return
      end
      local tag=sender:getTag()
      if tag== 21 then
              Util:scene_control("SurpriseScene")
      elseif tag== 22 then
            cc.UserDefault:getInstance():setBoolForKey("music",true)
            cc.UserDefault:getInstance():flush()
            print("音乐",cc.UserDefault:getInstance():getBoolForKey("music"))
      elseif tag== 23 then
            self:originalimage(2)
      elseif tag== 44 then
           self:funsuspended()

      end


end
function GameScene:funsuspended( )
           local mask_layer=self._csb:getChildByTag(46)  -- 遮罩层
           mask_layer:setVisible(true)
           local panel=self._csb:getChildByTag(47)  -- 面板
           panel:setLocalZOrder(20)
           panel:setVisible(true)
           local back_bt=panel:getChildByTag(49)  -- 返回
           back_bt:addTouchEventListener(function(sender, eventType  )
                      mask_layer:setVisible(false)
                      panel:setVisible(false)
               end)
           local continue_bt=panel:getChildByTag(50)  -- 继续
           continue_bt:addTouchEventListener(function(sender, eventType  )
                      mask_layer:setVisible(false)
                      panel:setVisible(false)
               end)
           local continue_bt=panel:getChildByTag(51)  -- 退出
           continue_bt:addTouchEventListener(function(sender, eventType  )
                      --Util:scene_control("MainInterfaceScene")
                      -- if self.type=="audition" then
                      --     Server:Instance():getgoldspoolbyid(LocalData:Instance():get_user_oid())
                      --    Server:Instance():sceneinformation()
                      -- end
                    
                      -- cc.Director:getInstance():popScene()
                      Util:scene_control("GoldprizeScene")
               end)
           local sound_box=panel:getChildByTag(52)  -- 音效
           sound_box:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开启")
                             audio.resumeMusic()
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                              audio.pauseMusic()
                     end
               end)
           local music_box=panel:getChildByTag(53)  -- 音乐
           music_box:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开启")
                            audio.resumeMusic()
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                             audio.pauseMusic()
                     end
               end)
           local notifications_box=panel:getChildByTag(54)  -- 通知
           notifications_box:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开启")
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
               end)
end
function GameScene:originalimage(dex)
           local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
           self._originalimage = cc.CSLoader:createNode("originalimage.csb")
           self._kuang:setLocalZOrder(200)
           self._kuang:addChild(self._originalimage)
           self.original=self._originalimage:getChildByTag(118)
           self.tishi=self._originalimage:getChildByTag(2044)
           self.continue_bt=self._originalimage:getChildByTag(107)
           self.masklayer=self._originalimage:getChildByTag(1050)
           self.masklayer:setPosition(cc.p(-self._kuang:getPositionX(),-self._kuang:getPositionY()))

           if self.type=="surprise" then
              local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
              self.original:loadTexture(path..tostring(Util:sub_str(list_table[1]["imgurl"], "/",":")))-- 记住更换原图
          elseif self.type=="audition" then

             local  list_table=LocalData:Instance():get_getgoldspoollistbale()
             local  jaclayer_data=list_table["adlist"]
             local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
             print("6666666666555 .",tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":")))
              self.original:loadTexture(path  ..  tostring(Util:sub_str(jaclayer_data[1]["imgurl"], "/",":")))

            -- local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
            --   self.original:loadTexture(path..tostring(self.image))-- 记住更换原图
               
          end
           if dex==2 then
              --self.original:setTouchEnabled(true)
              self.masklayer:setVisible(true)
              self.continue_bt:setVisible(true)
              local actionBy = cc.ScaleBy:create(1, 1.5, 1.5)
              self.continue_bt:runAction(cc.RepeatForever:create(cc.Sequence:create(actionBy, actionBy:reverse())))     


           elseif dex==1 then
              self.original:setTouchEnabled(false)
              self.tishi:setVisible(false)
           end
           if self.original:isTouchEnabled() then
               self._restore_bt:setTouchEnabled(false)
           end

           self.original:addTouchEventListener(function(sender, eventType  )
                    if eventType ~= ccui.TouchEventType.ended then
                              return
                    end
                  self._originalimage:removeFromParent()
                  self._restore_bt:setTouchEnabled(true)
          end)
           self.masklayer:addTouchEventListener(function(sender, eventType  )
                    if eventType ~= ccui.TouchEventType.ended then
                              return
                    end
                  self._originalimage:removeFromParent()
                  self._restore_bt:setTouchEnabled(true)
          end)

        

end
 function GameScene:countdown()
           self._time=self._time-1
           self._dajishi:setString(tostring(self._time))
           if self._time==0 then
              --Util:scene_control("SurpriseOverScene")
              Util:scene_controlid("SurpriseOverScene",{id=self.adid,cycle=self.cycle,heroid=self.heroid})
               -- local scene=SurpriseOverScene.new({})
               -- cc.Director:getInstance():pushScene(scene)

              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scnum)--停止定时器
           end
end
function GameScene:fun_countdown( )
      self._scnum=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(  )
                                self:countdown()
              end,1.0, false)
end

function GameScene:tupian(  )
                 local _back=self.countdownLayer:getChildByTag(587)  --返回键
                   _back:setVisible(false)
                   local path=cc.FileUtils:getInstance():getWritablePath()

                     local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
                     local  _image=self.countdownLayer:getChildByTag(590)
                    _image:setVisible(true)
                     local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"..tostring(Util:sub_str(list_table[1]["imgurl"], "/",":"))
                     _image:loadTexture(path)
                    self._dajishi=self.countdownLayer:getChildByTag(589)
                    self._dajishi:setString("5")  --于是乎自己就决定了 
                    self:fun_countdown( )

end
function GameScene:imgurl_download(  )
        if self.type=="audition" then
           local  list_table=LocalData:Instance():get_getgoldspoollistbale()
          local  jaclayer_data=list_table["adlist"]
          for i=1,#jaclayer_data do
              local _table={}
              _table["imgurl"]=jaclayer_data[i]["imgurl"]
                _table["max_pic_idx"]=#jaclayer_data
                _table["curr_pic_idx"]=i
                 Server:Instance():actrequest_pic(jaclayer_data[i]["imgurl"],_table) --下载图片
          end
          return
        end

         local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
         local _table={}
         local imgurl=list_table[1]["imgurl"]
          _table["imgurl"]=list_table[1]["imgurl"]
          Server:Instance():actrequest_pic(imgurl,_table) --下载图片

    


end
function GameScene:onEnter()
     --audio.playMusic(G_SOUND["MENUMUSIC"],true)
     Util:player_music("MENUMUSIC",true )
     if self.type=="surprise" then
        Server:Instance():getactivityadlist(self.adid)--发送请求
    elseif self.type=="audition" then
       --self:funinit()
       Server:Instance():getgoldspooladlist(self.adid)  --记住一会把消息改成上面的   
    elseif self.type=="daojishi" then
      Server:Instance():getactivityadlist(self.adid)--发送请求
     end
    
     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self,
                       function()
                        --display.replaceScene(SurpriseScene:Instance():Surpriseinit())
                      end)
     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.ACTIVITYYADLIST_LAYER_IMAGE, self,
                       function()
                            self:imgurl_download()

                      end)
     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.ACTIVITYYADLISTPIC_LAYER_IMAGE, self,
                       function()
                           if self.type=="surprise"  or  self.type=="audition"   then
                                self:funinit()
                            elseif self.type=="daojishi" then
                                 self:tupian(  )
                           end
                      end)
      NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.PRIZEPOOLDETAILS, self,
                       function()
                        local  _img= LocalData:Instance():get_user_img()
                        local  list_table=LocalData:Instance():get_getgoldspoollistbale()
                        local  jaclayer_data=list_table["adlist"]
                        local  _addetailurl = tostring(1)
                        if jaclayer_data[1]["addetailurl"] then
                           _addetailurl=jaclayer_data[1]["addetailurl"]
                        end
                        -- local  jackpotlayer= 
                        local jackpotlayer= require("app.layers.JackpotLayer").new({id=self.adid,  adownerid=self.adownerid,goldspoolcount= self.goldspoolcount ,image_name=_img,addetailurl=_addetailurl})
                         cc.Director:getInstance():pushScene(jackpotlayer)   --  奖池详情  我们就是硬生生的把一个layer 变成 scene  
                       
                      end)


end

function GameScene:onExit()
           --audio.stopMusic(G_SOUND["MENUMUSIC"])
           Util:stop_music("MENUMUSIC")
           NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self)
           NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.ACTIVITYYADLIST_LAYER_IMAGE, self)
           NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.ACTIVITYYADLISTPIC_LAYER_IMAGE, self)
           NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.PRIZEPOOLDETAILS, self)
end

function GameScene:pushFloating(text)

   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end

end 
function GameScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function GameScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
--android 返回键 响应
function GameScene:listener_home() 
    local  layer=cc.Layer:create()
    self:addChild(layer)
    local function onKeyReleased(keyCode, event)
          if keyCode == cc.KeyCode.KEY_BACK then
              cc.Director:getInstance():popScene()
          end
    end

    local listener = cc.EventListenerKeyboard:create()--
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(listener,layer)

end


return GameScene








