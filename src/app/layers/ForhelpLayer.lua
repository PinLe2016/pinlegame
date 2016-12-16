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


end


function ForhelpLayer:touch_callback(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          if tag==672 then
          	self:removeFromParent()
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
