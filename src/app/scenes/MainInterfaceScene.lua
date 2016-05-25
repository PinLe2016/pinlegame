


local MainInterfaceScene = class("MainInterfaceScene", function()
    return display.newScene("MainInterfaceScene")
end)
local PerInformationLayer = require("app.layers.PerInformationLayer")--惊喜吧



function MainInterfaceScene:ctor()
	   self.floating_layer = FloatingLayerEx.new()
               self.floating_layer:addTo(self,100000)

	 self.MainInterfaceScene = cc.CSLoader:createNode("MainInterfaceScene.csb")
      	 self:addChild(self.MainInterfaceScene)
      	 
      	 local Surprise_bt=self.MainInterfaceScene:getChildByTag(56)
    	Surprise_bt:addTouchEventListener(function(sender, eventType  )
		self:touch_callback(sender, eventType)
	end)
    	local activitycode_bt=self.MainInterfaceScene:getChildByTag(72)
    	activitycode_bt:addTouchEventListener(function(sender, eventType  )
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

    	self.barrier_bg=self.MainInterfaceScene:getChildByTag(396)
    	self.kuang=self.MainInterfaceScene:getChildByTag(397)

    	self.activitycode_text = self.kuang:getChildByTag(58)
end

function MainInterfaceScene:touch_callback( sender, eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local tag=sender:getTag()
	if tag==56 then --惊喜吧
		 Util:scene_control("SurpriseScene")
		 Server:Instance():getactivitylist(1)
	elseif tag==72 then --活动码
		self.barrier_bg:setVisible(true)
		self.kuang:setVisible(true)
	elseif tag==37 then
		self:addChild(PerInformationLayer.new())
	elseif tag==399 then --弹出确定
		Server:Instance():validateactivitycode(self.activitycode_text:getString())
		self.activitycode_text:setString(" ")
	end
end

function MainInterfaceScene:onEnter()

--   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.LOGIN_POST, self,
--                        function()
                       
--                       end)
end

function MainInterfaceScene:onExit()
  --NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.LOGIN_POST, self)
end


function MainInterfaceScene:pushFloating(text,is_resource,r_type)
   if is_resource then
       self.floating_layer:showFloat(text,is_resource,r_type)  
       self.barrier_bg:setVisible(false)
       self.kuang:setVisible(false)
   else
   	self.barrier_bg:setVisible(false)
	self.kuang:setVisible(false)
       self.floating_layer:showFloat(text,is_resource) 
   end
end 

return MainInterfaceScene