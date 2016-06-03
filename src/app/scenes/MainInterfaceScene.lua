


local MainInterfaceScene = class("MainInterfaceScene", function()
    return display.newScene("MainInterfaceScene")
end)

local PerInformationLayer = require("app.layers.PerInformationLayer")--惊喜吧
-- local GoldprizeScene = require("app.scenes.GoldprizeScene")

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
	elseif tag==72 then --活动码
		self.barrier_bg:setVisible(true)
		self.kuang:setVisible(true)
	elseif tag==37 then
		self:addChild(PerInformationLayer.new())
	elseif tag==399 then --弹出确定
		Server:Instance():validateactivitycode(self.activitycode_text:getString())
		self.activitycode_text:setString(" ")
	elseif tag==97 then
		Util:scene_control("GoldprizeScene")
	elseif tag==124 then
		self:fun_checkin()
	


	end
end
--签到
function MainInterfaceScene:fun_checkin(  )
	self.checkinlayer = cc.CSLoader:createNode("checkinLayer.csb")
      	self:addChild(self.checkinlayer)

	local back_bt=self.checkinlayer:getChildByTag(84)
	back_bt:addTouchEventListener(function(sender, eventType  )
	       if eventType ~= ccui.TouchEventType.ended then
		return
	       end

	       self.checkinlayer:removeFromParent()
	end)
	local check_bt=self.checkinlayer:getChildByTag(87)
	check_bt:addTouchEventListener(function(sender, eventType  )
	       if eventType ~= ccui.TouchEventType.ended then
		return
	       end
	       Server:Instance():checkin()  --发送消息
	end)

end
--签到 初始化
function MainInterfaceScene:init_checkin(  )
	-- body
end
function MainInterfaceScene:onEnter()

  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CHECK_POST, self,
                       function()
                       print("真的吗  签到 ")
                      end)
end

function MainInterfaceScene:onExit()
  NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.CHECK_POST, self)
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