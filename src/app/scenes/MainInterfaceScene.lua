


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
      local setup_bt=self.MainInterfaceScene:getChildByTag(48)
      setup_bt:addTouchEventListener(function(sender, eventType  )
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
	           Server:Instance():getcheckinhistory()  --签到http
      elseif tag==48 then  --设置
            self:funsetup(  )
      elseif tag==91 then  --设置返回
            self.set_bg:setVisible(false)
            self.set_bg1:setVisible(false)
           


	end
end
function MainInterfaceScene:funsetup(  )
        self.set_bg=self.MainInterfaceScene:getChildByTag(88)
        self.set_bg:setVisible(true)
        self.set_bg1=self.MainInterfaceScene:getChildByTag(89)
        self.set_bg1:setVisible(true)
        local set_back=self.set_bg1:getChildByTag(91)
        set_back:addTouchEventListener(function(sender, eventType  )
              self:touch_callback(sender, eventType)
        end)
        local music_bt=self.set_bg1:getChildByTag(93)  -- 音乐
        music_bt:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            print("开启")
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             print("关闭")
                     end
        end)
        local sound_bt=self.set_bg1:getChildByTag(92)  -- 音效
        sound_bt:addEventListener(function(sender, eventType  )
                 if eventType == ccui.CheckBoxEventType.selected then
                        print("开启")
                 elseif eventType == ccui.CheckBoxEventType.unselected then
                         print("关闭")
                 end
         end)

end
--签到
function MainInterfaceScene:fun_checkin(  )
	 self.checkinlayer:setVisible(true)

	local back_bt=self.checkinlayer:getChildByTag(84)  --返回
	back_bt:addTouchEventListener(function(sender, eventType  )
	       if eventType ~= ccui.TouchEventType.ended then
		      return
	       end
             self.checkinlayer:setVisible(false)
	       
	end)
	local check_bt=self.checkinlayer:getChildByTag(87)
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
            for i=1, math.ceil(totaydays/7-1) do
            	for j=1,7 do
            	       local _bg=day_bg:clone()
            	       local  day_text=_bg:getChildByTag(86)
                               day_text:setString((i-1)*7+j)
                               _table[(i-1)*7+j]=day_text
            	       _bg:setPosition(cc.p(_bg:getPositionX()+_size.width*(j-1),_bg:getPositionY()-_size.height* math.ceil(i-1)))
            	       self.checkinlayer:addChild(_bg)
        		      
        		end
        	end
        	for i=1,totaydays-math.ceil(totaydays/7-1)*7 do
        		 local _bg=day_bg:clone()
        		 local  day_text=_bg:getChildByTag(86)
                         day_text:setString( math.ceil(totaydays/7-1)*7+i)
                         _table[math.ceil(totaydays/7-1)*7+i]=day_text
            	 _bg:setPosition(cc.p(_bg:getPositionX()+_size.width*(i-1),_bg:getPositionY()-_size.height* math.ceil(totaydays/7-1)))
            	 self.checkinlayer:addChild(_bg)
        	end
            for i=1,totaydays do
            	for j=1,#days do
            		if i==tonumber(os.date("%d",days[j])) then
            			_table[i]:setColor(cc.c3b(255, 255, 100))
            		end
            	end
            end

end
function MainInterfaceScene:onEnter()

  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CHECK_POST, self,
                       function()
                       self:fun_checkin()--签到后
                      end)
   NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.CHECKINHISTORY_POST, self,
                       function()
                       self:fun_checkin()  --签到
                      end)
end

function MainInterfaceScene:onExit()
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