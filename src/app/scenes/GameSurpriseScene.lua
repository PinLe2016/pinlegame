--  新版惊喜吧 
local GameSurpriseScene = class("GameSurpriseScene", function()
            return display.newScene("GameSurpriseScene")
end)
function GameSurpriseScene:ctor()
      self:fun_init()
      self.ser_status=1   -- 1 本期活动  2  往期活动   0  是我的活动
      self.sur_pageno= 1  --  页数
      LocalData:Instance():set_getactivitylist(nil)
      Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
      self:fun_constructor()
     
end
function GameSurpriseScene:fun_constructor( ... )
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键
      --  列表发送请求
      self.jac_data_num_tag=0
      self.jac_data_num=0
      
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
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
                  Util:all_layer_backMusic()
	              Util:scene_control("MainInterfaceScene")
            end)
            -- 规则
            local btn_Guide=self.GameSurpriseScene:getChildByName("btn_Guide")
          	btn_Guide:addTouchEventListener(function(sender, eventType  )
	                 if eventType == 3 then
	                    sender:setScale(1)
	                    return
	                end
	                if eventType ~= ccui.TouchEventType.ended then
	                    sender:setScale(1.2)
	                return
	                end
	                sender:setScale(1)
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
            --  我的活动
            local my_bt=self.GameSurpriseScene:getChildByName("my_bt")
          	my_bt:addTouchEventListener(function(sender, eventType  )
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
                        Util:all_layer_backMusic()
            		self:fun_touch_com(1)
            		LocalData:Instance():set_getactivitylist(nil)
            		Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
               elseif tag=="btn_Past" then
                        Util:all_layer_backMusic()
                        self:fun_touch_com(2)
                        LocalData:Instance():set_getactivitylist(nil)
                        Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
                        print("往期活动")
	   elseif tag=="my_bt" then
                      Util:all_layer_backMusic()
                      self:fun_touch_com(3)
                      LocalData:Instance():set_getactivitylist(nil)
                      Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
                      print("我的活动")
	   end

              self.curr_bright=sender
end
function GameSurpriseScene:fun_touch_com(num )
	self.jac_data_num_tag=0
            self.jac_data_num=0
	LocalData:Instance():set_getactivitylist(nil)
	self:scheduleUpdate()
	self.lvw_Surorise:removeAllItems()
	self.image_table={}  --  存放图片
	self.timetext_table={} --存放时间
	self.sur_pageno=1
	self.ser_status=num
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
	if not list_table then
		return
	end
	local num=#_gamelist
	if num == 0  then
		return
	end
	local jioushu=math.floor(tonumber(num)) % 2  == 1 and 1 or 2   --判段奇数 偶数
	local _jioushu=0
	if jioushu==1 then
		 _jioushu=num /  2-0.5
 	else
 		_jioushu=num /  2
	end
	self.jac_data_num=_jioushu  +  num %  2  +self.jac_data_num_tag
	for i=self.jac_data_num_tag+1,self.jac_data_num do
		self.lvw_Surorise:pushBackDefaultItem()
		local  cell = self.lvw_Surorise:getItem(i-1)
		local  _bg=cell:getChildByName("bg")
		local  time_bg=_bg:getChildByName("time_bg")
		local  _bg_Copy=cell:getChildByName("bg_Copy")
		local  time_bg_Copy=_bg_Copy:getChildByName("time_bg")
		_bg:setTag(2*i-1)
		_bg_Copy:setVisible(false)
		self:fun_surprise_data(_bg,time_bg,i-self.jac_data_num_tag,1)
		if (i-self.jac_data_num_tag)*2-1== num  then
			return
		end
		_bg_Copy:setTag(2*i)
		_bg_Copy:setVisible(true)
		self:fun_surprise_data(_bg_Copy,time_bg_Copy,i-self.jac_data_num_tag,0)
	end
	self.jac_data_num_tag=self.jac_data_num
end
--实现数据更新
function GameSurpriseScene:fun_surprise_data(_obj,time_obj,_num,istwo)
	local obj=_obj
	local list_table=LocalData:Instance():get_getactivitylist()
	local _gamelist=list_table["game"]
	local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
	

            local file=cc.FileUtils:getInstance():isFileExist(path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":")))
            if not  file then
              table.insert(self.image_table,{_obj = obj ,name=path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":"))})
             else
                _obj:getChildByName("ig_GiftPhoto"):loadTexture(path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":")))
            end
            local _time=(_gamelist[2*_num-istwo]["finishtime"]-_gamelist[2*_num-istwo]["nowtime"] )--_gamelist[2*_num-istwo]["begintime"])-(_gamelist[2*_num-istwo]["nowtime"]-_gamelist[2*_num-istwo]["begintime"])
	local _str1="剩余时间"
	if _time <0  then
		_str1="结束时间: "
	else
		_str1="剩余时间: "
	end
            local time_bj=_time
            if time_bj<=0 then
              time_bj=time_bj+604800  --  目的是 7天后删除 
            end
            local _tabletime=(time_bj)
            local  _tabletime_data=Util:FormatTime_colon(_tabletime)
            local txt_Pastdate=time_obj:getChildByName("txt_Pastdate")
            table.insert(self.timetext_table,{timetext=txt_Pastdate,time_count=time_bj,_str2=_str1})
            txt_Pastdate:setString(_str1  .. _tabletime_data[1]  .. _tabletime_data[2]  .._tabletime_data[3]  .._tabletime_data[4]  )
            
            local ig_GiftPhoto=_obj:getChildByName("ig_GiftPhoto")
            local kuang=_obj:getChildByName("kuang")
            kuang:setVisible(false)
          	ig_GiftPhoto:addTouchEventListener(function(sender, eventType  )
	               if eventType == 3 then
                         -- sender:setScale(1)
                          kuang:setVisible(false)
                          return
                      end
                      if eventType ~= ccui.TouchEventType.ended then
                         -- sender:setScale(0.8)
                          kuang:setVisible(true)
                      return
                      end
                     -- sender:setScale(1)
                      kuang:setVisible(false)
	               local userinfo=LocalData:Instance():get_getuserinfo()
	               if  userinfo["birthday"] and  userinfo["cityname"] and  userinfo["gender"]   then           
	               else
	                       self.floating_layer:prompt_box("完善信息才能参加惊喜吧哦！",function (sender, eventType)      
	                                                                if eventType==1    then
	                                                                    local PerInformationLayer = require("app.layers.PerInformationLayer")--惊喜吧 
	             				                                self:addChild(PerInformationLayer.new())
	                                                                end                
	                           end) 
		               		return
	                end

	              if _time >=0 then
	              	 local SurpriseNode_Detail = require("app.layers.SurpriseNode_Detail")  --关于拼乐界面  
	              	local _parm=_gamelist[sender:getParent():getTag()]
		 	self:addChild(SurpriseNode_Detail.new({id=_parm["id"]}),1,1)
		 else
		 	local SurpriseNode_Detail = require("app.layers.DetailsSurpreissue")  --关于拼乐界面  
	              	local _parm=_gamelist[sender:getParent():getTag()]
		 	self:addChild(SurpriseNode_Detail.new({id=_parm["id"],mylevel=_parm["mylevel"]}),1,1)
	              end
	             
            end)


            --开启定时器
            --  活动类型  全国  和  地方
            local _time_Anegativenumber=tonumber(_time)
            local sp_ActivityType=_obj:getChildByName("sp_ActivityType")
            local sp_ActivityType_TEXT=sp_ActivityType:getChildByName("sp_ActivityType_TEXT")
            sp_ActivityType_TEXT:setString(_gamelist[2*_num-istwo]["area"])

            local part=_obj:getChildByName("part")
            if tonumber(_gamelist[2*_num-istwo]["isnew"])  == 1 then  --  新  0  是 老 
            	part:setVisible(true)
            else
            	part:setVisible(false)
            end
            --  我的爵位
            local time_lv=time_obj:getChildByName("time_lv")
            time_lv:setString("我的爵位     "  ..  _gamelist[2*_num-istwo]["mylevel"])
            --  是否参与
            local YICY=_obj:getChildByName("YICY")
            local NOCY=_obj:getChildByName("NOCY")
            if tonumber(_gamelist[2*_num-istwo]["myrecord"])==0 then   --  0未参与 1参与
            	NOCY:setVisible(true)
            	YICY:setVisible(false)
            	
          else
          	       NOCY:setVisible(false)
            	 YICY:setVisible(true)
            	
            end
            --  是否中奖
            local Notwinimage=_obj:getChildByName("Notwinimage")
            local winimage=_obj:getChildByName("winimage")
            if _time_Anegativenumber<0  and  not tonumber(_gamelist[2*_num-istwo]["prizewinning"]) then
            	Notwinimage:setVisible(true)
            	winimage:setVisible(false)
            elseif _time_Anegativenumber<0  and   tonumber(_gamelist[2*_num-istwo]["prizewinning"]) then
            	winimage:setVisible(true)
            	Notwinimage:setVisible(false)
            end
            --  我的活动参加个数
            local Text_1=self.GameSurpriseScene:getChildByName("Text_1")
            local Image_49=self.GameSurpriseScene:getChildByName("Image_49")
            if tonumber(self.ser_status) == 3 then
            	Text_1:setVisible(true)
            	Image_49:setVisible(true)
            	Text_1:setString(tostring(#_gamelist))
            else
            	Text_1:setVisible(false)
            	Image_49:setVisible(false)
            end
            
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
         		self.timetext_table[i].timetext:setString(self.timetext_table[i]._str2 ..  self.countdown_time[1]  .. self.countdown_time[2]  ..self.countdown_time[3]  ..self.countdown_time[4])
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
         	com_["TAG"]="getactivitylist"
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
	Util:player_music_hit("ACTIVITY",true )
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self,
                       function()
			self.list_table=LocalData:Instance():get_getactivitylist()
			          self:fun_list_data()
			          self:Surpriseimages_list()
                      end)--
	NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self,
                       function()
			--self:fun_list_data()  --  关闭目的是刷新快
			          
                      end)--
end

function GameSurpriseScene:onExit()
  Util:player_music_hit("GAMEBG",true )
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