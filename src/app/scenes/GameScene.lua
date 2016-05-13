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
   -- self.floating_layer = FloatingLayerEx.new()
   -- self.floating_layer:addTo(self,100000)

  local  function csb_btCallback(sender, eventType)
          if eventType == ccui.TouchEventType.ended then
             --self:addChild(DetailsLayer:new({id=SurpriseScene.act_id,image=SurpriseScene. act_image}))
             Util:scene_control("SurpriseScene")
          end
    end

    local  function music_btCallback(sender, eventType)
          cc.UserDefault:getInstance():setBoolForKey("music",true)
          cc.UserDefault:getInstance():flush()
          if eventType == ccui.TouchEventType.ended then
            print("音乐",cc.UserDefault:getInstance():getBoolForKey("music"))
          end
    end

      local csb = cc.CSLoader:createNode("XSHGameScene.csb")
      self._csb=csb
      self:addChild(csb)
      local back_bt=csb:getChildByTag(21)
      back_bt:addTouchEventListener(csb_btCallback)
      local music_bt=csb:getChildByTag(22)
      music_bt:addTouchEventListener(music_btCallback)

      self:originalimage()
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
                  local deblayer= debrisLayer.new({filename="httpwww.PinleGame.comGameImage856b7718-d0d9-41d7-86d8-11394180d357.jpg"
                  ,row=4,col=5,_size=_size,point=point,id=self.id})
                  csb:addChild(deblayer,3)
                  node:removeFromParent()
                  self.fragment_sprite_bg:removeFromParent()
      end
      local callfunc = cc.CallFunc:create(stopAction)
      node:runAction(cc.Sequence:create(cc.DelayTime:create(10),callfunc  ))
      self:addChild(node)


end
function GameScene:originalimage(  )
          local kuang=self._csb:getChildByTag(53)
          local _size=kuang:getContentSize()
          local point={}
          point.x=kuang:getPositionX()
          point.y=kuang:getPositionY()
          self.fragment_sprite_bg = display.newScale9Sprite("httpwww.PinleGame.comGameImage856b7718-d0d9-41d7-86d8-11394180d357.jpg", point.x,point.y, cc.size(_size.width,_size.height))
          self.fragment_sprite_bg:setAnchorPoint(0.0, 0.0)
          self._csb:addChild(self.fragment_sprite_bg)

end
function GameScene:onEnter()
     NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self,
                       function()
                        display.replaceScene(SurpriseScene:Instance():Surpriseinit())
                      end)

end

function GameScene:onExit()
           NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_SCENE, self)
end

function GameScene:pushFloating(text)

   -- if is_resource then
   --     self.floating_layer:showFloat(text)  
   -- else
   --     self.floating_layer:showFloat(text) 
   -- end

end 

return GameScene








