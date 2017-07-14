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
	--头像 昵称 次数  奖品名称   是否上榜
	self.w_my_head=self.PowerHelp_time_bg:getChildByName("my_head")
	self.w_my_head:loadTexture(LocalData:Instance():get_user_head())
	self.w_my_nickname=self.PowerHelp_time_bg:getChildByName("my_nickname")
	local  userdata=LocalData:Instance():get_user_data()
	local userdt = LocalData:Instance():get_userdata()
	local nickname=userdata["loginname"]
        	local nick_sub=string.sub(nickname,1,3)
        	nick_sub=nick_sub.."****"..string.sub(nickname,8,11)
       	 if userdt["nickname"]~="" then
            	nick_sub=userdt["nickname"]
       	 end
        	self.w_my_nickname:setString(nick_sub)
	self.w_my_number=self.PowerHelp_time_bg:getChildByName("my_number")
	self.w_my_winname=self.PowerHelp_time_bg:getChildByName("my_winname")
	self.w_my_no_win=self.PowerHelp_time_bg:getChildByName("my_no_win")
	self.w_my_no_win:setVisible(true)
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
	                Util:all_layer_backMusic()
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
               	Util:all_layer_backMusic()
		 LocalData:Instance():set_getfriendhelplist(nil)
		 Server:Instance():getfriendhelplist(0)
               elseif tag=="weeks_bt" then
               	Util:all_layer_backMusic()
		LocalData:Instance():set_getfriendhelplist(nil)
		 Server:Instance():getfriendhelplist(1)
	   elseif tag=="month_bt" then
	   	Util:all_layer_backMusic()
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
	--self.PowerHelp_list:setInnerContainerSize(self.PowerHelp_list:getContentSize())
end
function PowerHelp:fun_list_data(  )
	self.PowerHelp_list:removeAllItems()
	local friendhelp=LocalData:Instance():get_getfriendhelplist()
	local friendhelplist=friendhelp["friendhelplist"]
	if #friendhelplist == 0  then
		return
	end
	   local tmp = 0  
	    for i=1,#friendhelplist-1 do  
	        for j=1,#friendhelplist-i do  
	            if friendhelplist[j]["amount"] < friendhelplist[j+1]["amount"] then  
	                tmp = friendhelplist[j]  
	                friendhelplist[j] = friendhelplist[j+1]  
	                friendhelplist[j+1] = tmp  
	            end  
	        end  
	    end  

	 for i=1,#friendhelplist do
	          self.PowerHelp_list:pushBackDefaultItem()
	          local  cell = self.PowerHelp_list:getItem(i-1)
	          cell:getChildByName("rank_bg"):getChildByName("rank_number"):setString(string.format("%d",i))
	          local _index=string.match(tostring(Util:sub_str(friendhelplist[i]["headimageurl"], "/",":")),"%d")
	          if not _index then
	            cell:getChildByName("head"):loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(math.random(1,18))))
	          else
	            cell:getChildByName("head"):loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))
	          end
   	          --cell:getChildByName("head"):loadTexture( string.format("png/httpgame.pinlegame.comheadheadicon_%d.jpg",tonumber(_index)))
	          cell:getChildByName("nickname"):setString(friendhelplist[i]["nickname"])
	          cell:getChildByName("number"):setString(friendhelplist[i]["amount"])
	          if friendhelplist[i]["goodsname"] then
	          	cell:getChildByName("winname"):setString(friendhelplist[i]["goodsname"])
	          end
	          if self.w_my_nickname:getString()  == friendhelplist[i]["nickname"]  then
	          	 self.w_my_number:setString(friendhelplist[i]["amount"])
	          	 self.w_my_no_win:setVisible(false)
	          	 cell:getChildByName("head"):loadTexture(LocalData:Instance():get_user_head())
	          	 if friendhelplist[i]["goodsname"] then
	          	 	self.w_my_winname:setString(friendhelplist[i]["goodsname"])
	          	 end
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