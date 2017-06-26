--  新版惊喜吧 
local PowerHelp = class("PowerHelp", function()
            return display.newScene("PowerHelp")
end)

function PowerHelp:ctor()
	 
      self:fun_init()
      Server:Instance():getfriendhelplist(0)
      self:fun_constructor()
end
function PowerHelp:fun_constructor( ... )
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键
    
end


function PowerHelp:fun_init( ... )
	self.PowerHelp = cc.CSLoader:createNode("PowerHelp.csb");
	self:addChild(self.PowerHelp)
	self.PowerHelp_time_bg=self.PowerHelp:getChildByName("PowerHelp_time_bg")

	--  事件初始化
	--  返回
	local btn_Back=self.PowerHelp:getChildByName("PowerHelp_back")
          	btn_Back:addTouchEventListener(function(sender, eventType  )
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
            --  日
            local btn_Current=self.PowerHelp_time_bg:getChildByName("day_bt")
            btn_Current:setBright(false)
     	self.curr_bright=btn_Current
          	btn_Current:addTouchEventListener(function(sender, eventType  )
	               self:list_btCallback(sender, eventType)

            end)
            --  周
            local btn_Past=self.PowerHelp_time_bg:getChildByName("weeks_bt")
          	btn_Past:addTouchEventListener(function(sender, eventType  )
	              self:list_btCallback(sender, eventType)     
            end)
            --  月
            local my_bt=self.PowerHelp_time_bg:getChildByName("month_bt")
          	my_bt:addTouchEventListener(function(sender, eventType  )
	              self:list_btCallback(sender, eventType)     
            end)

          	 self:fun_Surorise()
          	 
end

  function PowerHelp:list_btCallback( sender, eventType )
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
		 LocalData:Instance():set_getfriendhelplist(nil)
		 Server:Instance():getfriendhelplist(0)
               elseif tag=="weeks_bt" then
		LocalData:Instance():set_getfriendhelplist(nil)
		 Server:Instance():getfriendhelplist(1)
	   elseif tag=="month_bt" then
		LocalData:Instance():set_getfriendhelplist(nil)
		 Server:Instance():getfriendhelplist(2)
	   end

              self.curr_bright=sender
end
--初始化列表
function PowerHelp:fun_Surorise( )
	self.PowerHelp_list=self.PowerHelp:getChildByName("PowerHelpNode"):getChildByName("PowerHelp_list")--惊喜吧列表
	self.PowerHelp_list:addScrollViewEventListener((function(sender, eventType  )
	          if eventType  ==6 then
	          		print("刷新")
			-- self.sur_pageno=self.sur_pageno+1
			-- LocalData:Instance():set_getactivitylist(nil)
			-- Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
	                     return
	          end
	end))
	self.PowerHelp_list:setItemModel(self.PowerHelp_list:getItem(0))
	self.PowerHelp_list:removeAllItems()
end
function PowerHelp:fun_list_data(  )
	self.PowerHelp_list:removeAllItems()
	local friendhelp=LocalData:Instance():get_getfriendhelplist()
	local friendhelplist=friendhelp["friendhelplist"]
	if #friendhelplist == 0  then
		return
	end
	 for i=1,#friendhelplist do
	          self.PowerHelp_list:pushBackDefaultItem()
	          local  cell = self.PowerHelp_list:getItem(i-1)
	          cell:getChildByName("rank_bg"):getChildByName("rank_number"):setString(string.format("%d",i))
	          local _index=string.match(tostring(Util:sub_str(friendhelplist[i]["headimageurl"], "/",":")),"%d")
   	          cell:getChildByName("head"):loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))
	          cell:getChildByName("nickname"):setString(friendhelplist[i]["nickname"])
	          cell:getChildByName("number"):setString(friendhelplist[i]["amount"])
	          if friendhelplist[i]["goodsname"] then
	          	cell:getChildByName("winname"):setString(friendhelplist[i]["goodsname"])
	          end
	         
	end
end
function PowerHelp:pushFloating(text)
       self.floating_layer:showFloat(text)  
end 

function PowerHelp:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function PowerHelp:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
function PowerHelp:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end
function PowerHelp:onEnter()

	NotificationCenter:Instance():AddObserver("getfriendhelplist", self,
                       function()
			self:fun_list_data()
			          
                      end)--
end

function PowerHelp:onExit()
       NotificationCenter:Instance():RemoveObserver("getfriendhelplist", self)
      cc.Director:getInstance():getTextureCache():removeAllTextures() 

end
--android 返回键 响应
function PowerHelp:listener_home() 
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

return PowerHelp