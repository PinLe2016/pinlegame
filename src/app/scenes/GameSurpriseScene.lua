--  新版惊喜吧 
local GameSurpriseScene = class("GameSurpriseScene", function()
            return display.newScene("GameSurpriseScene")
end)
function GameSurpriseScene:ctor()
      self:fun_constructor()
      self:fun_init()
      self.ser_status=1   -- 1 本期活动  2  往期活动   0  是我的活动
      self.sur_pageno= 1  --  页数
      LocalData:Instance():set_getactivitylist(nil)
      Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
     
end
--  弹窗
function GameSurpriseScene:fun_Popup_window_Twoday( ... )
         --  每天第一次登陆的时候弹出
         local tab=os.date("*t");
         local new_time_two=cc.UserDefault:getInstance():getIntegerForKey("pop_new_time",0)
         if new_time_two==0  or tonumber(tab.day)  ~= tonumber(new_time_two)  then
            self.floating_layer:fun_congratulations("推荐给你最好的朋友,\n一起赢大奖","稍后推荐","前去推荐","推荐",function (sender, eventType)
                                  if eventType==1 then
                                    self:fun_storebrowser("http://sj.qq.com/myapp/detail.htm?apkName=com.pinle.pinlegame")
                                  end
            end)
            cc.UserDefault:getInstance():setIntegerForKey("pop_new_time",tab.day)
            return  true
         end
         return  false    
end
-- 外部链接
function GameSurpriseScene:fun_storebrowser( _url)
      self.Storebrowser = cc.CSLoader:createNode("Storebrowser.csb")
      self:addChild(self.Storebrowser)
      self.Storebrowser:setTag(1314)
      local back=self.Storebrowser:getChildByTag(2122)
      local store_size=self.Storebrowser:getChildByTag(2123)
       back:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                        return
                  end
                  self:removeChildByTag(1314, true)
            end)
              self.share=cc.UM_Share:create()
              self.Storebrowser:addChild(self.share)
              self.share:add_WebView(tostring(_url),cc.size(store_size:getContentSize().width ,store_size:getContentSize().height),
               cc.p(store_size:getPositionX(),store_size:getPositionY()))
end
function GameSurpriseScene:fun_constructor( ... )
      self.floating_layer = require("app.layers.FloatingLayer").new()
      self.floating_layer:addTo(self,100000)
      self:listener_home() --注册安卓返回键
      --  列表发送请求
      self.lv_table_dx={}
      self.lv_table_dx_idx=1
      self.lv_table_dx_idx_tag=0
      self.jac_data_num_tag=0
      self.jac_data_num=0
      self.count_cishu=0
      self.image_table={}  --  存放图片
      self.timetext_table={} --存放时间
      self.time=0
      self.LV_hierarchy_table={"平民","骑士","勋爵","男爵","子爵","伯爵","侯爵","公爵","国王"}
      self.LV_hierarchy_table_LV_IMG={"9","10","11","12","13","17","16","14","15"}
      self.LV_hierarchy_table_LV_IMG_NAME={"28","27","26","25","24","23","22","29","21"}
      self.secondOne = 0
      self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
	      	self:update(dt)
      end)
end

function GameSurpriseScene:fun_init( ... )
	self.GameSurpriseScene = cc.CSLoader:createNode("GameSurpriseScene.csb");
	self:addChild(self.GameSurpriseScene)

      self.GameSurpriseText_1=self.GameSurpriseScene:getChildByName("Text_1")
      self.GameSurpriseImage_49=self.GameSurpriseScene:getChildByName("Image_49")
      self.GameSurpriseText_1:setVisible(false)
      self.GameSurpriseImage_49:setVisible(false)
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
		          self:fun_Rulesofsurprise()
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
function GameSurpriseScene:fun_Rulesofsurprise( ... )
              self.Rulesofsurprise = cc.CSLoader:createNode("Rulesofsurprise.csb")
              self:addChild(self.Rulesofsurprise) 
              self.Rulesofsurprise:setTag(3288)
              local Image_45=self.Rulesofsurprise:getChildByName("Image_45")
              local Image_1=self.Rulesofsurprise:getChildByName("ProjectNode_1"):getChildByName("Image_1")
              Image_1:getChildByName("Image_4"):setVisible(false)
              Image_1:getChildByName("Image_5"):setVisible(false)
              Image_45:addTouchEventListener(function(sender, eventType  )
                   if eventType == 3 then
                      sender:setScale(1)
                      return
                  end
                  if eventType ~= ccui.TouchEventType.ended then
                      sender:setScale(1.2)
                  return
                  end
                  sender:setScale(1)
                  self:removeChildByTag(3288, true)

            end)
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
                         for i=1,6 do
                            self.lvw_Surorise:pushBackDefaultItem()
                            local  cell = self.lvw_Surorise:getItem(i-1)
                        end
               elseif tag=="btn_Past" then
                        Util:all_layer_backMusic()
                        self:fun_touch_com(2)
                        LocalData:Instance():set_getactivitylist(nil)
                        Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
                         for i=1,6 do
                            self.lvw_Surorise:pushBackDefaultItem()
                            local  cell = self.lvw_Surorise:getItem(i-1)
                        end
	   elseif tag=="my_bt" then
                      Util:all_layer_backMusic()
                      self:fun_touch_com(3)
                      LocalData:Instance():set_getactivitylist(nil)
                      Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
                       for i=1,6 do
                            self.lvw_Surorise:pushBackDefaultItem()
                            local  cell = self.lvw_Surorise:getItem(i-1)
                        end
	   end

              self.curr_bright=sender
end
function GameSurpriseScene:fun_touch_com(num )
	self.jac_data_num_tag=0
  self.count_cishu=0
            self.jac_data_num=0
            self.lv_table_dx={}
            self.lv_table_dx_idx=1
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
			--LocalData:Instance():set_getactivitylist(nil)
			Server:Instance():getactivitylist(tostring(self.ser_status),self.sur_pageno)
	                     return
	          end
	end))
	self.lvw_Surorise:setItemModel(self.lvw_Surorise:getItem(0))
	self.lvw_Surorise:removeAllItems()
      self.lvw_Surorise:setInnerContainerSize(self.lvw_Surorise:getContentSize())
      for i=1,6 do
          self.lvw_Surorise:pushBackDefaultItem()
          local  cell = self.lvw_Surorise:getItem(i-1)
      end
end
function GameSurpriseScene:fun_list_data(  )
	local list_table=LocalData:Instance():get_getactivitylist()
	local _gamelist=list_table["game"]
	if not list_table then
		return
	end
	local num=#_gamelist-self.count_cishu
      
	if num == 0  then
		return
	end
      if #_gamelist  == self.count_cishu  then
         return
      else
        self.lvw_Surorise:removeAllItems()
      end
	local jioushu=math.floor(tonumber(num)) % 2  == 1 and 1 or 2   --判段奇数 偶数
	local _jioushu=0
	if jioushu==1 then
		 _jioushu=num /  2-0.5
 	else
 		_jioushu=num /  2
	end
	self.jac_data_num=_jioushu  +  num %  2   +self.jac_data_num_tag
	for i=self.jac_data_num_tag+1,self.jac_data_num do
		self.lvw_Surorise:pushBackDefaultItem()
		local  cell = self.lvw_Surorise:getItem(i-1)
		local  _bg=cell:getChildByName("bg")
		local  time_bg=_bg:getChildByName("time_bg")
		local  _bg_Copy=cell:getChildByName("bg_Copy")
		local  time_bg_Copy=_bg_Copy:getChildByName("time_bg")
		_bg:setTag(2*i-1)
		_bg_Copy:setVisible(false)
		self:fun_surprise_data(_bg,time_bg,i,1)

		if (i-self.jac_data_num_tag)*2-1== num  then
                  self.count_cishu=#_gamelist
                  self.jac_data_num_tag=self.jac_data_num
			return
		end
		_bg_Copy:setTag(2*i)
		_bg_Copy:setVisible(true)
		self:fun_surprise_data(_bg_Copy,time_bg_Copy,i,0)
	end
      if tonumber(self.jac_data_num_tag)~=0 then
             self.lvw_Surorise:jumpToPercentVertical(120)
      else
             self.lvw_Surorise:jumpToPercentVertical(0)
      end

	self.jac_data_num_tag=self.jac_data_num
     self.count_cishu=#_gamelist
end
--实现数据更新
function GameSurpriseScene:fun_surprise_data(_obj,time_obj,_num,istwo)
	local obj=_obj
	local list_table=LocalData:Instance():get_getactivitylist()
	local _gamelist=list_table["game"]
	local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
	

            -- local file=cc.FileUtils:getInstance():isFileExist(path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":")))
            -- if not  file then
            --   table.insert(self.image_table,{_obj = obj ,name=path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":"))})
            --  else
            --     _obj:getChildByName("ig_GiftPhoto"):loadTexture(path..tostring(Util:sub_str(_gamelist[2*_num-istwo]["ownerurl"], "/",":")))
            -- end
             _obj:getChildByName("ig_GiftPhoto"):loadTexture("res/SurpriseImage/"  ..    math.random(1,3)  ..   ".jpg")
            local _time=(_gamelist[2*_num-istwo]["finishtime"]-_gamelist[2*_num-istwo]["nowtime"] )--_gamelist[2*_num-istwo]["begintime"])-(_gamelist[2*_num-istwo]["nowtime"]-_gamelist[2*_num-istwo]["begintime"])
      	local time_bj=_time
            local gs_time=0
            local _str1="剩余时间"
      	if _time <0  then
      		_str1="结束时间: "
                  time_bj=_gamelist[2*_num-istwo]["finishtime"]
                  gs_time=1
      	else
      		_str1="剩余时间: "
                  time_bj=_time
                  gs_time=0
      	end

            
            local _tabletime=(time_bj)
            local  _tabletime_data=Util:FormatTime_colon(_tabletime)
            local txt_Pastdate=time_obj:getChildByName("txt_Pastdate")
            table.insert(self.timetext_table,{timetext=txt_Pastdate,time_count=time_bj,_str2=_str1,_gs_time=gs_time})
            txt_Pastdate:setString(_str1  .. _tabletime_data[1]  .. _tabletime_data[2]  .._tabletime_data[3]  .._tabletime_data[4]  )
            
            local ig_GiftPhoto=_obj:getChildByName("ig_GiftPhoto")
            --  是否新活动
            local part=ig_GiftPhoto:getChildByName("part")
            if tonumber(_gamelist[2*_num-istwo]["isnew"])  == 1 then  --  新  0  是 老 
              part:setVisible(true)
            else
              part:setVisible(false)
            end

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
                      --  每天第一次进入本期活动登陆弹窗
                      
                      local  tt_tag=sender:getParent():getTag()
                      local _s_sender=sender
                      if self.ser_status==1 then
                        -- if self:fun_Popup_window_Twoday()  then
                        --   return
                        -- end
                               local tab=os.date("*t");
                               local new_time_two=cc.UserDefault:getInstance():getIntegerForKey("pop_new_time",0)
                               if new_time_two==0  or tonumber(tab.day)  ~= tonumber(new_time_two)  then
                                  self.floating_layer:fun_congratulations("推荐给你最好的朋友,\n一起赢大奖","稍后推荐","前去推荐","推荐",function (sender, eventType)
                                                        if eventType==1 then
                                                          self:fun_storebrowser("http://sj.qq.com/myapp/detail.htm?apkName=com.pinle.pinlegame")
                                                        else
                                                                   local _pop_new_count_two=cc.UserDefault:getInstance():getIntegerForKey("pop_new_count_two",0)
                                                                   if _pop_new_count_two~=0 and _pop_new_count_two~=2 then
                                                                         cc.UserDefault:getInstance():setIntegerForKey("pop_new_count_two",2)
                                                                    elseif _pop_new_count_two==2 then
                                                                       cc.UserDefault:getInstance():setIntegerForKey("pop_new_count_two",3)
                                                                   end
                                                                    local userinfo=LocalData:Instance():get_getuserinfo()
                                                                    _s_sender:getChildByName("part"):setVisible(false)
                                                                   if _time >=0 then
                                                                         local SurpriseNode_Detail = require("app.layers.SurpriseNode_Detail")  --关于拼乐界面  
                                                                        local _parm=_gamelist[tt_tag]
                                                                        self.lv_table_dx_idx_tag=tt_tag
                                                                        self:addChild(SurpriseNode_Detail.new({id=_parm["id"],ownerurl=_parm["ownerurl"]  }),1,1)
                                                                   else
                                                                          local SurpriseNode_Detail = require("app.layers.DetailsSurpreissue")  --关于拼乐界面  
                                                                                      local _parm=_gamelist[tt_tag]
                                                                          self:addChild(SurpriseNode_Detail.new({id=_parm["id"],ownerurl=_parm["ownerurl"],mylevel=_parm["mylevel"]}),1,1)
                                                                  end
                                                        end
                                  end)
                                  cc.UserDefault:getInstance():setIntegerForKey("pop_new_time",tab.day)
                                  return  
                               end
                      end
                      local _pop_new_count_two=cc.UserDefault:getInstance():getIntegerForKey("pop_new_count_two",0)
	               if _pop_new_count_two~=0 and _pop_new_count_two~=2 then
                       cc.UserDefault:getInstance():setIntegerForKey("pop_new_count_two",2)
                      elseif _pop_new_count_two==2 then
                         cc.UserDefault:getInstance():setIntegerForKey("pop_new_count_two",3)
                     end
                     local userinfo=LocalData:Instance():get_getuserinfo()
                  sender:getChildByName("part"):setVisible(false)
	              if _time >=0 then
	              	 local SurpriseNode_Detail = require("app.layers.SurpriseNode_Detail")  --关于拼乐界面  
	              	local _parm=_gamelist[tt_tag]
                  self.lv_table_dx_idx_tag=tt_tag
		 	self:addChild(SurpriseNode_Detail.new({id=_parm["id"],ownerurl=_parm["ownerurl"]  }),1,1)
		 else
		 	local SurpriseNode_Detail = require("app.layers.DetailsSurpreissue")  --关于拼乐界面  
	              	local _parm=_gamelist[tt_tag]
		 	self:addChild(SurpriseNode_Detail.new({id=_parm["id"],ownerurl=_parm["ownerurl"],mylevel=_parm["mylevel"]}),1,1)
	              end
	             
            end)


            --开启定时器
            --  活动类型  全国  和  地方
            local _time_Anegativenumber=tonumber(_time)
            local sp_ActivityType=_obj:getChildByName("sp_ActivityType")
            local sp_ActivityType_TEXT=sp_ActivityType:getChildByName("sp_ActivityType_TEXT")
            sp_ActivityType_TEXT:setString(_gamelist[2*_num-istwo]["area"])

            
            --  我的爵位
            local time_lv=time_obj:getChildByName("time_lv")
            local s_lv_sp=time_obj:getChildByName("s_lv_sp")
            local s_lv_img=time_obj:getChildByName("s_lv_img")
            time_lv:setVisible(true)
            s_lv_sp:setVisible(true)
            s_lv_img:setVisible(true)
            self.lv_table_dx[self.lv_table_dx_idx]=s_lv_img
            self.lv_table_dx_idx=self.lv_table_dx_idx+1
            local lv_obj=1
            for j=1,9 do
                if _gamelist[2*_num-istwo]["mylevel"]  ==  self.LV_hierarchy_table[j] then
                  lv_obj=j
                end
            end
          s_lv_sp:loadTexture("DetailsiOfSurprise/JXB_BQHD_CUXQ_"  .. self.LV_hierarchy_table_LV_IMG[lv_obj]  ..   ".png")
          s_lv_img:loadTexture("DetailsiOfSurprise/JXB_BQHD_CUXQ_"  .. self.LV_hierarchy_table_LV_IMG_NAME[lv_obj]  ..   ".png")
          


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
            local Text_1=self.GameSurpriseText_1
            local Image_49=self.GameSurpriseImage_49
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
         		if self.timetext_table[i]._gs_time == 0 then
                       self.countdown_time=Util:FormatTime_colon(self.timetext_table[i].time_count-self.time)
                       self.timetext_table[i].timetext:setString(self.timetext_table[i]._str2 ..  self.countdown_time[1]  .. self.countdown_time[2]  ..self.countdown_time[3]  ..self.countdown_time[4])
                  else
                     local _year=os.date("%Y",(self.timetext_table[i].time_count))
                     local _month=os.date("%m",(self.timetext_table[i].time_count))
                     local _date=os.date("%d",(self.timetext_table[i].time_count))
                     local p_time=os.date("%H",(self.timetext_table[i].time_count))
                    self.timetext_table[i].timetext:setString(self.timetext_table[i]._str2  ..  _year  ..   "年"  ..  _month  ..   "月"  ..  _date  ..   "日"  ..  p_time  ..   "时"    )
                  end
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
      --  参与惊喜吧任意活动两次
      cc.UserDefault:getInstance():setIntegerForKey("pop_new_count_two",0)
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
      NotificationCenter:Instance():AddObserver("lv_table_dx_idx_tag", self,
                       function()
                              local new_time_two=cc.UserDefault:getInstance():getIntegerForKey("lv_table_dx_idx_tag",1)
                              self.lv_table_dx[self.lv_table_dx_idx_tag]:loadTexture("DetailsiOfSurprise/JXB_BQHD_CUXQ_"  .. self.LV_hierarchy_table_LV_IMG_NAME[new_time_two]  ..   ".png")
                      end)--
end

function GameSurpriseScene:onExit()
     --  参与惊喜吧任意活动两次
     cc.UserDefault:getInstance():setIntegerForKey("pop_new_count_two",0)
      Util:player_music_hit("GAMEBG",true )
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST_IMAGE, self)
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.SURPRIS_LIST, self)
      NotificationCenter:Instance():RemoveObserver("lv_table_dx_idx_tag", self)
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