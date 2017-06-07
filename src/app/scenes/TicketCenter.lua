--  兑奖中心
local TicketCenter = class("TicketCenter", function()
            return display.newScene("TicketCenter")
end)
function TicketCenter:ctor()
      self:fun_init()
      self:fun_constructor()
end
function TicketCenter:fun_constructor( ... )
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键
    
end
function TicketCenter:fun_init( ... )
	self.TicketCenter = cc.CSLoader:createNode("TicketCenter.csb");
	self:addChild(self.TicketCenter)
	--  事件初始化
	--  返回
	local TicketCenter_BACK=self.TicketCenter:getChildByName("TicketCenter_BACK")
          	TicketCenter_BACK:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	              Util:scene_control("MainInterfaceScene")
            end)
            local TicketCenter_informationBT=self.TicketCenter:getChildByName("TicketCenter_informationBT")
          	TicketCenter_informationBT:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	              self:fun_Theirwin()
            end)

          	 self:fun_Surorise()
end

  function TicketCenter:list_btCallback( sender, eventType )
              if eventType ~= ccui.TouchEventType.ended then
                       return
              end
              local tag=sender:getName()
              if self.curr_bright:getName()==tag then
                  return
              end
              self.curr_bright:setBright(true)
              sender:setBright(false)
               if tag=="day_bt" then  
		print("日")
		-- self:fun_touch_com(1)
		-- LocalData:Instance():set_getactivitylist(nil)
		-- Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
               elseif tag=="weeks_bt" then
		
		print("周")
	   elseif tag=="month_bt" then
		
		print("月")
	   end

              self.curr_bright=sender
end

--初始化列表
function TicketCenter:fun_Surorise( )

	self.TicketCenterlist=self.TicketCenter:getChildByName("TicketCenter_NODE"):getChildByName("TicketCenterlist")--惊喜吧列表
	self.TicketCenterlist:addScrollViewEventListener((function(sender, eventType  )
	          if eventType  ==6 then
	          		print("刷新")
			-- self.sur_pageno=self.sur_pageno+1
			-- LocalData:Instance():set_getactivitylist(nil)
			-- Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
	                     return
	          end
	end))
	self.TicketCenterlist:setItemModel(self.TicketCenterlist:getItem(0))
	self.TicketCenterlist:removeAllItems()
	self:fun_list_data()
end
function TicketCenter:fun_list_data(  )
	 for i=1,20 do
	          self.TicketCenterlist:pushBackDefaultItem()
	          local  cell = self.TicketCenterlist:getItem(i-1)
	          local cell=cell:getChildByName("TicketCenter_bt")
	          	cell:addTouchEventListener(function(sender, eventType  )
		                 if eventType == 3 then
		                    sender:setScale(1)
		                    return
		                end
		                if eventType ~= ccui.TouchEventType.ended then
		                    sender:setScale(1.2)
		                return
		                end
		                sender:setScale(1)
		              self:fun_Theirwin()
	            end)
	end
end
--信件确认
function TicketCenter:fun_Theirwin(  )
	self.Theirwin = cc.CSLoader:createNode("Theirwin.csb");
	self:addChild(self.Theirwin)
	self.Theirwin:setTag(123)
	local Theirwin_back=self.Theirwin:getChildByName("Theirwin_back")
          	Theirwin_back:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	              self:removeChildByTag(123, true)
            end)
            local Theirwin_name=self.Theirwin:getChildByName("Theirwin_name")
            local Theirwin_phone=self.Theirwin:getChildByName("Theirwin_phone")
            local Theirwin_address=self.Theirwin:getChildByName("Theirwin_address")
            local Theirwin_submit=self.Theirwin:getChildByName("Theirwin_submit")
            Util:function_advice_keyboard(self.Theirwin,Theirwin_name,25)
            Util:function_advice_keyboard(self.Theirwin,Theirwin_phone,25)
            Util:function_advice_keyboard(self.Theirwin,Theirwin_address,25)
          	Theirwin_submit:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	                -- if self.theirwin then

                 --  if name:getString() == "" then
                 --  Server:Instance():promptbox_box_buffer("姓名不能为空哦")   --prompt
                 --  return
                 --  end
                 --   if phone:getString() == "" then
                 --  Server:Instance():promptbox_box_buffer("填写的手机号不能为空哦！")   --prompt
                 --  return
                 --  end
                 --  if tostring(Util:judgeIsAllNumber(tostring(phone:getString())))  ==  "false"  then
                 --  Server:Instance():promptbox_box_buffer("手机号填写错误") 
                 --  return
                 --  end

                 --  if  string.len(phone:getString()) < 11 then
                 --  Server:Instance():promptbox_box_buffer("手机号填写错误")   --prompt
                 --  return
                 --  end
                  
                 --  if address:getString() == "" then
                 --  Server:Instance():promptbox_box_buffer("地址不能为空哦！")   --prompt
                 --  return
                 --  end
	             print("提交")
            end)
end

--完善信息
function TicketCenter:fun_Theirwin(  )
	self.PerfectInformation = cc.CSLoader:createNode("PerfectInformation.csb");
	self:addChild(self.PerfectInformation)
	self.PerfectInformation:setTag(213)
	local PerfectInformation_BG=self.PerfectInformation:getChildByName("PerfectInformation_BG")
	local PerfectInformation_BACK=PerfectInformation_BG:getChildByName("PerfectInformation_BACK")
          	PerfectInformation_BACK:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	              self:removeChildByTag(213, true)
            end)
            local PerfectInformation_phone=PerfectInformation_BG:getChildByName("PerfectInformation_phone")
            local PerfectInformation_name=PerfectInformation_BG:getChildByName("PerfectInformation_name")
            local PerfectInformation_city=PerfectInformation_BG:getChildByName("PerfectInformation_city")
            local PerfectInformation_address=PerfectInformation_BG:getChildByName("PerfectInformation_address")
            Util:function_advice_keyboard(PerfectInformation_BG,PerfectInformation_phone,25)
            Util:function_advice_keyboard(PerfectInformation_BG,PerfectInformation_name,25)
            Util:function_advice_keyboard(PerfectInformation_BG,PerfectInformation_city,25)
            Util:function_advice_keyboard(PerfectInformation_BG,PerfectInformation_address,25)
            local PerfectInformation_submit=PerfectInformation_BG:getChildByName("PerfectInformation_submit")
          	PerfectInformation_submit:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
	
	             print("提交")
            end)
end
function TicketCenter:pushFloating(text)
       self.floating_layer:showFloat(text)  
end 

function TicketCenter:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function TicketCenter:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
function TicketCenter:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end
function TicketCenter:onEnter()

	-- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
 --                       function()
	-- 		self:fun_list_data()
			          
 --                      end)--
end

function TicketCenter:onExit()
      -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
      cc.Director:getInstance():getTextureCache():removeAllTextures() 

end
--android 返回键 响应
function TicketCenter:listener_home() 
    local  layer=cc.Layer:create()
    self:addChild(layer)
    local function onKeyReleased(keyCode, event)
          if keyCode == cc.KeyCode.KEY_BACK then
              self:unscheduleUpdate()
              Util:scene_control("MainInterfaceScene")
          end
    end

    local listener = cc.EventListenerKeyboard:create()--
    listener:registerScriptHandler(onKeyReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(listener,layer)

end

return TicketCenter