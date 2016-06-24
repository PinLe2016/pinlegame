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


function GameScene:ctor(params)
    self.floating_layer = FloatingLayerEx.new()

    self.floating_layer:addTo(self,-1)
    self._time=10

    self.type=params.type

    self.image= params.image

    self.adid=params.adid

    self.id=params.id

      if self.type=="daojishi" then
         self.countdownLayer = cc.CSLoader:createNode("countdownLayer.csb")
         self:addChild(self.countdownLayer)
      else
         local csb = cc.CSLoader:createNode("XSHGameScene.csb")
      self._csb=csb
      self:addChild(csb)
      end
     
      
     
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
      self.restore_bt:setPositionY(self.restore_bt:getPositionY())
      self._restore_bt=self.restore_bt
      self.restore_bt:setTouchEnabled(false)
      self.restore_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)
       self.suspended_bt=self._csb:getChildByTag(44)--暂停
       self.suspended_bt:setPositionY(self.suspended_bt:getPositionY())
       self.suspended_bt:setTouchEnabled(false)
       self.suspended_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)

      self:originalimage(1)  
      local node = cc.CSLoader:createNode("battlestart.csb")
      local action = cc.CSLoader:createTimeline("battlestart.csb")
      action:setTimeSpeed(0.2)
      node:runAction(action)
      action:gotoFrameAndPlay(20,false)
      local function stopAction()
                  local kuang=self._csb:getChildByTag(53)
                  local _size=kuang:getContentSize()
                  local point={}
                  point.x=kuang:getPositionX()
                  point.y=kuang:getPositionY()
                   if self.type=="surprise" then
                      local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
                      local deblayer= debrisLayer.new({filename=tostring(Util:sub_str(list_table[1]["imgurl"], "/",":"))
                     ,row=4,col=5,_size=_size,point=point,adid=self.adid,tp=1})
                      self._csb:addChild(deblayer)
                  elseif self.type=="audition" then
                      local deblayer= debrisLayer.new({filename=self.image
                     ,row=4,col=5,_size=_size,point=point,adid=self.adid,tp=2})
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
      node:runAction(cc.Sequence:create(cc.DelayTime:create(10),callfunc  ))
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
                      Util:scene_control("MainInterfaceScene")
               end)
           local sound_box=panel:getChildByTag(52)  -- 音效
           sound_box:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开启")
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
               end)
           local music_box=panel:getChildByTag(53)  -- 音乐
           music_box:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开启")
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
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

           if self.type=="surprise" then
              self.original:loadTexture(tostring(Util:sub_str(list_table[1]["imgurl"], "/",":")))-- 记住更换原图
          elseif self.type=="audition" then
            local path=cc.FileUtils:getInstance():getWritablePath()
              self.original:loadTexture(path..tostring(self.image))-- 记住更换原图
          end
           if dex==2 then
              self.original:setTouchEnabled(true)
           elseif dex==1 then
              self.original:setTouchEnabled(false)
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

        

end
 function GameScene:countdown()
           self._time=self._time-1
           self._dajishi:setString(tostring(self._time))
           if self._time==0 then
              Util:scene_control("SurpriseOverScene")
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

                     local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
                     local  _image=self.countdownLayer:getChildByTag(590)
                     _image:loadTexture(tostring(Util:sub_str(list_table[1]["imgurl"], "/",":")))
                    self._dajishi=self.countdownLayer:getChildByTag(589)
                    self._dajishi:setString("10")
                    self:fun_countdown( )

end
function GameScene:imgurl_download(  )
         local list_table=LocalData:Instance():get_getactivityadlist()["ads"]
         local _table={}
         local imgurl=list_table[1]["imgurl"]
          _table["imgurl"]=list_table[1]["imgurl"]
          Server:Instance():actrequest_pic(imgurl,_table) --下载图片
end
function GameScene:onEnter()
     if self.type=="surprise" then
       print("1111111111")
        Server:Instance():getactivityadlist(self.adid)--发送请求
    elseif self.type=="audition" then
       self:funinit()
       print("2222222")
    elseif self.type=="daojishi" then
      Server:Instance():getactivityadlist(self.adid)--发送请求
     end
    

     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self,
                       function()
                        display.replaceScene(SurpriseScene:Instance():Surpriseinit())
                      end)
     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.ACTIVITYYADLIST_LAYER_IMAGE, self,
                       function()
                           print("下载图片")
                            self:imgurl_download()

                      end)
     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.ACTIVITYYADLISTPIC_LAYER_IMAGE, self,
                       function()
                           print("完成下载图片")
                           if self.type=="surprise" then
                                --self:funinit()
                            elseif self.type=="daojishi" then
                                 self:tupian(  )
                           end
                           
                           
                      end)

end

function GameScene:onExit()
           NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self)
           NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.ACTIVITYYADLIST_LAYER_IMAGE, self)
           NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.ACTIVITYYADLISTPIC_LAYER_IMAGE, self)
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
return GameScene








