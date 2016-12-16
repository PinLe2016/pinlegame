--
-- Author: peter
-- Date: 2016-12-16 17:57:38
--
--修改密码
local ChangepasswordLayer = class("ChangepasswordLayer", function()
            return display.newLayer("ChangepasswordLayer")
end)

function ChangepasswordLayer:ctor()

            self:setNodeEventEnabled(true)--layer添加监听

            self:init()
end

function ChangepasswordLayer:init(  )
       self.changepassword= cc.CSLoader:createNode("ChangepasswordLayer.csb")
       self:addChild(self.changepassword)

       self.back_bt=self.changepassword:getChildByTag(208)   --  返回
       self.back_bt:addTouchEventListener(function(sender, eventType  )
          self:touch_callback(sender, eventType)
      end)


end


function ChangepasswordLayer:touch_callback(sender, eventType)
             if eventType ~= ccui.TouchEventType.ended then
                return
             end
          local tag=sender:getTag()
          if tag==208 then
          	self:removeFromParent()
          end
         
          

end
function ChangepasswordLayer:onEnter()
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self,
                       function()
                        

                      end)
	
end

function ChangepasswordLayer:onExit()
     	 NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.AFFICHLIST, self)
     	 
end


return ChangepasswordLayer
