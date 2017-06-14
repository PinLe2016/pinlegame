--  新版惊喜吧 
local PowerHelp = class("PowerHelp", function()
            return display.newScene("PowerHelp")
end)
--测试数据

function PowerHelp:test_date()
	self.rank_data2={
		{"png/httpgame.pinlegame.comheadheadicon_0.jpg","猫猫er","520","四件套"},
		{"png/httpgame.pinlegame.comheadheadicon_1.jpg","人心可畏","500","蓝牙耳机"},
		{"png/httpgame.pinlegame.comheadheadicon_2.jpg","十年温如初","482","遥控电风扇"},
		{"png/httpgame.pinlegame.comheadheadicon_3.jpg","流年灬未亡","470",""},
		{"png/httpgame.pinlegame.comheadheadicon_4.jpg","Dissappear","469",""},
		{"png/httpgame.pinlegame.comheadheadicon_6.jpg","萌爹爹","458",""},
		{"png/httpgame.pinlegame.comheadheadicon_8.jpg","瞎闹腾","452",""},
		{"png/httpgame.pinlegame.comheadheadicon_7.jpg","幸运草","448",""},
		{"png/httpgame.pinlegame.comheadheadicon_9.jpg","阿晶","449",""},
		{"png/httpgame.pinlegame.comheadheadicon_11.jpg","淡雨沫烟","432",""},
		{"png/httpgame.pinlegame.comheadheadicon_10.jpg","夏夜之瞳","430",""},
		{"png/httpgame.pinlegame.comheadheadicon_12.jpg","cherry","427",""},
		{"png/httpgame.pinlegame.comheadheadicon_10.jpg","我是贝麻麻","421",""},
		{"png/httpgame.pinlegame.comheadheadicon_11.jpg","coco","416",""},
		{"png/httpgame.pinlegame.comheadheadicon_13.jpg","小莹","415",""},
		{"png/httpgame.pinlegame.comheadheadicon_0.jpg","宝爸","410",""},
		{"png/httpgame.pinlegame.comheadheadicon_5.jpg","Robin","408",""},
		{"png/httpgame.pinlegame.comheadheadicon_7.jpg","蜗牛哥哥","406",""},
		{"png/httpgame.pinlegame.comheadheadicon_8.jpg","疯狂的兔子","401",""},
		{"png/httpgame.pinlegame.comheadheadicon_4.jpg","萌主﹫","399",""},
	}

	self.rank_data3={
		{"png/httpgame.pinlegame.comheadheadicon_10.jpg","我是贝麻麻","1209","索尼微单相机"},
		{"png/httpgame.pinlegame.comheadheadicon_13.jpg","小莹","1206","家用磨豆机"},
		{"png/httpgame.pinlegame.comheadheadicon_10.jpg","夏夜之瞳","1198","小米充电宝"},
		{"png/httpgame.pinlegame.comheadheadicon_4.jpg","Dissappear","1190",""},
		{"png/httpgame.pinlegame.comheadheadicon_6.jpg","萌爹爹","1174",""},
		{"png/httpgame.pinlegame.comheadheadicon_11.jpg","淡雨沫烟","1165",""},
		{"png/httpgame.pinlegame.comheadheadicon_7.jpg","Robin","1121",""},
		{"png/httpgame.pinlegame.comheadheadicon_11.jpg","猫猫er","1110",""},
		{"png/httpgame.pinlegame.comheadheadicon_5.jpg","疯狂的兔子","1067",""},
		{"png/httpgame.pinlegame.comheadheadicon_0.jpg","萌主﹫","1012",""},
		{"png/httpgame.pinlegame.comheadheadicon_8.jpg","宝爸","985",""},
		{"png/httpgame.pinlegame.comheadheadicon_4.jpg","幸运草","962",""},
		{"png/httpgame.pinlegame.comheadheadicon_0.jpg","蜗牛哥哥","932",""},
		{"png/httpgame.pinlegame.comheadheadicon_7.jpg","cherry","866",""},
		{"png/httpgame.pinlegame.comheadheadicon_1.jpg","人心可畏","832",""},
		{"png/httpgame.pinlegame.comheadheadicon_12.jpg","阿晶","799",""},
		{"png/httpgame.pinlegame.comheadheadicon_9.jpg","流年灬未亡","756",""},
		{"png/httpgame.pinlegame.comheadheadicon_3.jpg","瞎闹腾","748",""},
		{"png/httpgame.pinlegame.comheadheadicon_8.jpg","十年温如初","729",""},
		{"png/httpgame.pinlegame.comheadheadicon_2.jpg","萌主﹫","655",""},
	}


	self.rank_data1={
		{"png/httpgame.pinlegame.comheadheadicon_13.jpg","小莹","101","KTV欢唱券"},
		{"png/httpgame.pinlegame.comheadheadicon_10.jpg","我是贝麻麻","98","20元话费"},
		{"png/httpgame.pinlegame.comheadheadicon_10.jpg","夏夜之瞳","80","10元话费"},
		{"png/httpgame.pinlegame.comheadheadicon_4.jpg","Dissappear","77",""},
		{"png/httpgame.pinlegame.comheadheadicon_1.jpg","人心可畏","76",""},
		{"png/httpgame.pinlegame.comheadheadicon_12.jpg","阿晶","73",""},
		{"png/httpgame.pinlegame.comheadheadicon_9.jpg","流年灬未亡","68",""},
		{"png/httpgame.pinlegame.comheadheadicon_3.jpg","瞎闹腾","66",""},
		{"png/httpgame.pinlegame.comheadheadicon_8.jpg","十年温如初","65",""},
		{"png/httpgame.pinlegame.comheadheadicon_2.jpg","萌主﹫","63",""},
		{"png/httpgame.pinlegame.comheadheadicon_6.jpg","萌爹爹","60",""},
		{"png/httpgame.pinlegame.comheadheadicon_11.jpg","淡雨沫烟","58",""},
		{"png/httpgame.pinlegame.comheadheadicon_7.jpg","Robin","57",""},
		{"png/httpgame.pinlegame.comheadheadicon_11.jpg","猫猫er","56",""},
		{"png/httpgame.pinlegame.comheadheadicon_5.jpg","疯狂的兔子","56",""},
		{"png/httpgame.pinlegame.comheadheadicon_0.jpg","萌主﹫","53",""},
		{"png/httpgame.pinlegame.comheadheadicon_8.jpg","宝爸","50",""},
		{"png/httpgame.pinlegame.comheadheadicon_4.jpg","幸运草","48",""},
		{"png/httpgame.pinlegame.comheadheadicon_0.jpg","蜗牛哥哥","47",""},
		{"png/httpgame.pinlegame.comheadheadicon_7.jpg","cherry","45",""},

	}

	-- for  i = 20, 1, -1 do  
	-- 	local  index =  math.random(1, 20);
	-- 	local  tempNum = self.rank_data1[i];
	-- 	self.rank_data1[i] = self.rank_data1[index];
	-- 	self.rank_data1[index] = tempNum;
	-- end

	-- -- local recv = json.ecode(self.rank_data1)
 --    io.writefile(cc.FileUtils:getInstance():getWritablePath() .."recv.lua", json.encode(self.rank_data1))
	
 	self.all_data={self.rank_data1,self.rank_data2,self.rank_data3}
 	self.data_power=self.rank_data1
end

function PowerHelp:ctor()
	  self:test_date()
      self:fun_init()
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
		print("日")
		self:fun_touch_com(1)
		-- LocalData:Instance():set_getactivitylist(nil)
		-- Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
               elseif tag=="weeks_bt" then
				self:fun_touch_com(2)
		print("周")
	   elseif tag=="month_bt" then
		self:fun_touch_com(3)
		print("月")
	   end

              self.curr_bright=sender
end
function PowerHelp:fun_touch_com(num )
	LocalData:Instance():set_getactivitylist(nil)
	self.PowerHelp_list:removeAllItems()
	self.sur_pageno=1
	self.ser_status=num
	self.data_power=self.all_data[num]
	self:fun_list_data(  )
end
--初始化列表
function PowerHelp:fun_Surorise( )
	--  头像
	 -- local my_head=self.PowerHelp_time_bg:getChildByName("my_head")
	 -- my_head:loadTexture("json")
	--  昵称
	-- local my_nickname=self.PowerHelp_time_bg:getChildByName("my_nickname")
	-- my_nickname:setString("text")
	-- --  助力人数
	-- local my_number=self.PowerHelp_time_bg:getChildByName("my_number")
	-- my_number:setString("text")
	-- --  获得奖品
	-- local my_winname=self.PowerHelp_time_bg:getChildByName("my_winname")
	-- my_winname:setString("text")
	-- --未获得奖品
	-- local my_no_win=self.PowerHelp_time_bg:getChildByName("my_no_win")
	-- --排名第一
	-- local myrank_one=self.PowerHelp_time_bg:getChildByName("myrank_one")
	-- --  排名非第一
	-- local myrank_bg=self.PowerHelp_time_bg:getChildByName("myrank_bg")
	-- local myrank=myrank_bg:getChildByName("myrank")
	-- myrank:setString("text")

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
	self:fun_list_data()
end
function PowerHelp:fun_list_data(  )
	 for i=1,20 do
	          self.PowerHelp_list:pushBackDefaultItem()
	          local  cell = self.PowerHelp_list:getItem(i-1)
	          cell:getChildByName("rank_bg"):getChildByName("rank_number"):setString(string.format("%d",i))
	          cell:getChildByName("head"):loadTexture(self.data_power[i][1])
	          -- print("···",self.data_power[i][2])
	          cell:getChildByName("nickname"):setString(tostring(self.data_power[i][2]))
	          cell:getChildByName("number"):setString(self.data_power[i][3])
	          cell:getChildByName("winname"):setString(self.data_power[i][4])
	          
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

	-- NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
 --                       function()
	-- 		self:fun_list_data()
			          
 --                      end)--
end

function PowerHelp:onExit()
      -- NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
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