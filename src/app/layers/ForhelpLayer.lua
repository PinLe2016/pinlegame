--
-- Author: peter
-- Date: 2016-12-16 18:01:43
-- Date: 2016-12-16 17:57:38
--
--兑换帮助
local ForhelpLayer = class("ForhelpLayer", function()
            return display.newLayer("ForhelpLayer")
end)

function ForhelpLayer:ctor()

            self:setNodeEventEnabled(true)--layer添加监听

            self:init()
end

function ForhelpLayer:init(  )
       self.forhelp= cc.CSLoader:createNode("ForhelpLayer.csb")
       self:addChild(self.forhelp)

       self.back_bt=self.forhelp:getChildByTag(672)   --  返回
       self.back_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)
       self.panel_bg=self.forhelp:getChildByTag(787)   --  面板
       self.panel_bg:setVisible(false)
       self.callback_bt=self.panel_bg:getChildByTag(788)   --  面板返回
       self.callback_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)

        self._list=self.forhelp:getChildByTag(543)--列表
        self._list:setItemModel(self._list:getItem(0))
        self._list:removeAllItems()
       for i=1,1 do
            self._list:pushBackDefaultItem()
            local  cell = self._list:getItem(i-1)
            cell:setTag(i) 
            cell:addTouchEventListener(function(sender, eventType  )
                                    self:callback(sender, eventType)
            end)
            

       end
end

function ForhelpLayer:callback( sender, eventType )
          local tag=sender:getTag()
          if eventType ~= ccui.TouchEventType.ended then
                 
                 sender:getChildByTag(785):setVisible(true)
                return
          end
          sender:getChildByTag(785):setVisible(false)
          self.panel_bg:setVisible(true)
         
end



function ForhelpLayer:touch_callback(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          if tag==672 then
          	self:removeFromParent()
          elseif tag==788 then
            self.panel_bg:setVisible(false)
          end
end
function ForhelpLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        

                      end)
	
end

function ForhelpLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
     	 
end


return ForhelpLayer
