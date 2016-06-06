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

local debrisLayer = require("app.gamecontrol.debrisLayer")


function GameScene:ctor(params)
   self.floating_layer = FloatingLayerEx.new()
   self.floating_layer:addTo(self,-1)

      self.id=params.id

      local csb = cc.CSLoader:createNode("XSHGameScene.csb")
      self._csb=csb
      self:addChild(csb)
      self._kuang=csb:getChildByTag(53)
      local back_bt=csb:getChildByTag(21)  -- 禁返回
      back_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)
      local music_bt=csb:getChildByTag(22) -- 禁音效
      music_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)
      local restore_bt=csb:getChildByTag(23)--查看原图
      restore_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)
       local suspended_bt=csb:getChildByTag(44)--暂停
      suspended_bt:addTouchEventListener(function(sender, eventType  )
                     self:csb_btCallback(sender, eventType)
               end)

      self:originalimage(1)
      local node = cc.CSLoader:createNode("battlestart.csb")
      local action = cc.CSLoader:createTimeline("battlestart.csb")
      action:setTimeSpeed(0.2)
      node:runAction(action)
      action:gotoFrameAndPlay(20,false)
      local function stopAction()
                  local kuang=csb:getChildByTag(53)
                  local _size=kuang:getContentSize()
                  local point={}
                  point.x=kuang:getPositionX()
                  point.y=kuang:getPositionY()
                  local deblayer= debrisLayer.new({filename="httpwww.pinlegame.comGameImageaffbd109-a341-4f1c-8b3f-edb581f01c68.jpg"
                  ,row=4,col=5,_size=_size,point=point,id=self.id})
                  csb:addChild(deblayer,-1)
                  node:removeFromParent()
                 self._originalimage:removeFromParent()
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
           panel:setVisible(true)
           local back_bt=panel:getChildByTag(49)  -- 返回
           back_bt:addTouchEventListener(function(sender, eventType  )
                     mask_layer:removeFromParent()
                     panel:removeFromParent()
               end)
           local continue_bt=panel:getChildByTag(50)  -- 继续
           continue_bt:addTouchEventListener(function(sender, eventType  )
                     mask_layer:removeFromParent()
                     panel:removeFromParent()
               end)
           local continue_bt=panel:getChildByTag(49)  -- 退出
           continue_bt:addTouchEventListener(function(sender, eventType  )
                     Util:scene_control("SurpriseScene")
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
           
           self._originalimage = cc.CSLoader:createNode("originalimage.csb")
           self._kuang:addChild(self._originalimage)
           self.original=self._originalimage:getChildByTag(118)
           --self.original:loadTexture("")-- 记住更换原图
           if dex==2 then
              self.original:setTouchEnabled(true)
           elseif dex==1 then
              self.original:setTouchEnabled(false)
           end
           self.original:addTouchEventListener(function(sender, eventType  )
                    if eventType ~= ccui.TouchEventType.ended then
                              return
                    end
                  self._originalimage:removeFromParent()
          end)

        

end
function GameScene:imgurl_download(  )
         local list_table=LocalData:Instance():get_getactivityadlist()
         local _table={}
         local imgurl="http://www.PinleGame.com/GameImage/affbd109-a341-4f1c-8b3f-edb581f01c68.jpg"--list_table["imgurl"]
          _table["imgurl"]="http://www.PinleGame.com/GameImage/affbd109-a341-4f1c-8b3f-edb581f01c68.jpg"--list_table["imgurl"]
          Server:Instance():actrequest_pic(imgurl,_table) --下载图片
end
function GameScene:onEnter()

     Server:Instance():getactivityadlist(self.id)--发送请求

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








