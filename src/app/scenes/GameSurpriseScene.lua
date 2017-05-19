--  新版惊喜吧 
local GameSurpriseScene = class("GameSurpriseScene", function()
            return display.newScene("GameSurpriseScene")
end)
function GameSurpriseScene:ctor()
      self:fun_init()
      self:fun_constructor()

end
function GameSurpriseScene:fun_constructor( ... )
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键
      --  列表发送请求
      self.ser_status=1  	-- 1 本期活动  2  往期活动
      self.sur_pageno= 1  --  页数
      LocalData:Instance():set_getactivitylist(nil)
      Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
      self.image_table={}  --  存放图片
      self.timetext_table={} --存放时间
      self.time=0
      self.secondOne = 0
      self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
	      	self:update(dt)
      end)
end
function GameSurpriseScene:fun_init( ... )
	self.GameSurpriseScene = cc.CSLoader:createNode("GameSurpriseScene.csb");
	self:addChild(self.GameSurpriseScene)

	--  事件初始化
	--  返回
	local btn_Back=self.GameSurpriseScene:getChildByName("btn_Back")
          	btn_Back:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              Util:scene_control("MainInterfaceScene")
            end)
            -- 规则
            local btn_Guide=self.GameSurpriseScene:getChildByName("btn_Guide")
          	btn_Guide:addTouchEventListener(function(sender, eventType  )
	                if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("规则")
            end)
            --  本期活动
            local btn_Current=self.GameSurpriseScene:getChildByName("btn_Current")
            btn_Current:setBright(false)
     	self.curr_bright=btn_Current
          	btn_Current:addTouchEventListener(function(sender, eventType  )
	               self:list_btCallback(sender, eventType)
            end)
            --  往期活动
            local btn_Past=self.GameSurpriseScene:getChildByName("btn_Past")
          	btn_Past:addTouchEventListener(function(sender, eventType  )
	              self:list_btCallback(sender, eventType)     
            end)

          	self:fun_Surorise()
end

  function GameSurpriseScene:list_btCallback( sender, eventType )
              if eventType ~= ccui.TouchEventType.ended then
                       return
              end
              local tag=sender:getName()
              if self.curr_bright:getName()==tag then
                  return
              end
              self.curr_bright:setBright(true)
              sender:setBright(false)
               if tag=="btn_Current" then  
		print("本期活动")
		self:fun_touch_com()
		self.ser_status=1
		Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
               elseif tag=="btn_Past" then
		self:fun_touch_com()
		self.ser_status=2
		Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
		print("往期活动")
	   end

              self.curr_bright=sender
end
function GameSurpriseScene:fun_touch_com( ... )
	LocalData:Instance():set_getactivitylist(nil)
	self:scheduleUpdate()
	self.lvw_Surorise:removeAllItems()
	self.image_table={}  --  存放图片
	self.timetext_table={} --存放时间
	self.sur_pageno=1
end
--初始化列表
function GameSurpriseScene:fun_Surorise( )
	self.lvw_Surorise=self.GameSurpriseScene:getChildByName("ProjectNode_3"):getChildByName("lvw_Surorise")--惊喜吧列表
	self.lvw_Surorise:addScrollViewEventListener((function(sender, eventType  )
	          if eventType  ==6 then
			self.sur_pageno=self.sur_pageno+1
			LocalData:Instance():set_getactivitylist(nil)
			Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
	                     return
	          end

	end))
	self.lvw_Surorise:setItemModel(self.lvw_Surorise:getItem(0))
	self.lvw_Surorise:removeAllItems()

	
end
function GameSurpriseScene:fun_list_data(  )
	local list_table=LocalData:Instance():get_getactivitylist()
	local _gamelist=list_table["game"]
	local num=#_gamelist
	if num == 0 then
		return
	end
	local jioushu=math.floor(tonumber(num)) % 2  == 1 and 1 or 2   --判段奇数 偶数
	local _jioushu=0
	if jioushu==1 then
		 _jioushu=num /  2-0.5
 	else
 		_jioushu=num /  2
	end
	self.jac_data_num=_jioushu  +  num %  2
	for i=1,self.jac_data_num do
		self.lvw_Surorise:pushBackDefaultItem()
		local  cell = self.lvw_Surorise:getItem(i-1)
		local  _bg=cell:getChildByName("bg")
		local  _bg_Copy=cell:getChildByName("bg_Copy")
		_bg_Copy:setVisible(false)
		self:fun_surprise_data(_bg,i,1)
		if i*2-1== num  then
			return
		end
		_bg_Copy:setVisible(true)
		self:fun_surprise_data(_bg_Copy,i,0)
	end
end
--实现数据更新
function GameSurpriseScene:fun_surprise_data(_obj,_num,istwo)
	local obj=_obj
	local list_table=LocalData:Instance():get_getactivitylist()
	local _gamelist=list_table["game"]
	local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
	local ig_GiftPhoto=_obj:getChildByName("ig_GiftPhoto")
          	ig_GiftPhoto:addTouchEventListener(function(sender, eventType  )
	               if eventType ~= ccui.TouchEventType.ended then
	                   return
	              end
	              print("活动编号"  ..  2*_num-1)
	              local SurpriseNode_Detail = require("app.layers.SurpriseNode_Detail")  --关于拼乐界面  
		  self:addChild(SurpriseNode_Detail.new(),1,12)
            end)

            local file=cc.FileUtils:getInstance():isFileExist(path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":")))
            if not  file then
              table.insert(self.image_table,{_obj = obj ,name=path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":"))})
             else
                _obj:getChildByName("ig_GiftPhoto"):loadTexture(path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":")))
            end
            local _time=(_gamelist[2*_num-istwo]["finishtime"]-_gamelist[2*_num-istwo]["begintime"])-(_gamelist[2*_num-istwo]["nowtime"]-_gamelist[2*_num-istwo]["begintime"])
            local _tabletime=(_time)
            local  _tabletime_data=Util:FormatTime_colon(_tabletime)
            local txt_Pastdate=_obj:getChildByName("txt_Pastdate")
            table.insert(self.timetext_table,{timetext=txt_Pastdate,time_count=_time})
            txt_Pastdate:setString(_tabletime_data[1]  .. _tabletime_data[2]  .._tabletime_data[3]  .._tabletime_data[4]  )
            --开启定时器
            self:scheduleUpdate()	
end
--刷新时间的定时器
function GameSurpriseScene:update(dt)
	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	self.secondOne=0
            self.time=1+self.time
         	for i=1,#self.timetext_table do
         		
         		self.countdown_time=Util:FormatTime_colon(self.timetext_table[i].time_count-self.time)
         		self.timetext_table[i].timetext:setString(self.countdown_time[1]  .. self.countdown_time[2]  ..self.countdown_time[3]  ..self.countdown_time[4])
         	end
           --  刷新下载的图片
	if #self.image_table~=0 then
	   local next_num=0
	  for i=1,#self.image_table do
	      local file=cc.FileUtils:getInstance():isFileExist(self.image_table[i].name)
	      if file and self.image_table[i]._obj then
	          local activity_Panel=self.image_table[i]._obj:getChildByName("ig_GiftPhoto")
	          activity_Panel:loadTexture(self.image_table[i].name)
	          self.image_table[i]._obj=nil
	          next_num=next_num+1
	      end
	  end
	  if next_num == #self.image_table then
	     self.image_table={}
	  end
	end
end
--下载图片
function GameSurpriseScene:Surpriseimages_list(  )
         local list_table=LocalData:Instance():get_getactivitylist()
         local  sup_data=list_table["game"]
         for i=1,#sup_data do
         	local com_={}
         	com_["command"]=sup_data[i]["ownerurl"]
         	com_["max_pic_idx"]=#sup_data
         	com_["curr_pic_idx"]=i
         	Server:Instance():request_pic(sup_data[i]["ownerurl"],com_) 
         end
end
function GameSurpriseScene:pushFloating(text)
       self.floating_layer:showFloat(text)  
end 

function GameSurpriseScene:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
       
end 
function GameSurpriseScene:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end
function GameSurpriseScene:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end
function GameSurpriseScene:onEnter()


	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
                       function()
			self.list_table=LocalData:Instance():get_getactivitylist()
			          dump(self.list_table)
			          self:Surpriseimages_list()
                      end)--
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
                       function()
			self:fun_list_data()
			          
                      end)--
end

function GameSurpriseScene:onExit()
     
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
      cc.Director:getInstance():getTextureCache():removeAllTextures() 

end
--android 返回键 响应
function GameSurpriseScene:listener_home() 
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

return GameSurpriseScene