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
      self.win_type=0
      Server:Instance():getconsignee()
      --  请求自己中奖信息
      self.tck_data_num_tag=0
      self.tck_data_num=1
      self.TicketCenter_pageno=1
      Server:Instance():getmyrewardlist(self.TicketCenter_pageno)
      --  定时器
      self.image_table={}  --  存放奖品图片
      self.time=0
      self.secondOne = 0
      self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
	      	self:update(dt)
      end)
    
end
function TicketCenter:fun_init( ... )
	self.TicketCenter = cc.CSLoader:createNode("TicketCenter.csb");
	self:addChild(self.TicketCenter)
	-- self.TicketCenter:setScale(0.7)
 --            self.TicketCenter:setAnchorPoint(0.5,0.5)
 --            self.TicketCenter:setPosition(320, 568)
	-- Util:layer_action(self.TicketCenter,self,"open") 

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
	              Util:all_layer_backMusic()
	              --Util:layer_action(self.TicketCenter,self,"close") 
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
	                Util:all_layer_backMusic()
	                self.win_type=1
	                self.PerfectInformation = cc.CSLoader:createNode("PerfectInformation.csb");
		    self:addChild(self.PerfectInformation)
		    self.PerfectInformation:setTag(213)
	                Server:Instance():getconsignee()
            end)
            
          	 self:fun_Surorise()
end


--初始化列表
function TicketCenter:fun_Surorise( )

	self.TicketCenterlist=self.TicketCenter:getChildByName("TicketCenter_NODE"):getChildByName("TicketCenterlist")--惊喜吧列表
	self.TicketCenterlist:addScrollViewEventListener((function(sender, eventType  )
	          if eventType  ==6 then
			 self.TicketCenter_pageno=self.TicketCenter_pageno+1
			 --LocalData:Instance():set_getmyrewardlist(nil)
			Server:Instance():getmyrewardlist(self.TicketCenter_pageno)
	                     return
	          end
	end))
	self.TicketCenterlist:setItemModel(self.TicketCenterlist:getItem(0))
	self.TicketCenterlist:removeAllItems()
	self.TicketCenterlist:setInnerContainerSize(self.TicketCenterlist:getContentSize())
end
function TicketCenter:fun_list_data(  )
	local myrewardlist=LocalData:Instance():get_getmyrewardlist()
            local  rewardlist=myrewardlist["rewardlist"]
            local win_consignee=LocalData:Instance():get_getconsignee()

            if #rewardlist ==  0 then
            	return
            end
            self.tck_data_num=#rewardlist
            if self.tck_data_num_tag  == self.tck_data_num  then
            	return
            end
            dump(self.tck_data_num_tag)
            dump(self.tck_data_num)
            print("开始")
            local path=cc.FileUtils:getInstance():getWritablePath().."down_pic/"
	 for i=self.tck_data_num_tag+1,self.tck_data_num do
	          self.TicketCenterlist:pushBackDefaultItem()
	          local  cell = self.TicketCenterlist:getItem(i-1)
	          --  名称
	          local TicketCenter_NAME=cell:getChildByName("TicketCenter_NAME")
	          TicketCenter_NAME:setString(rewardlist[i]["goodsname"])
	          -- 日期""
	          local TicketCenter_TIME=cell:getChildByName("TicketCenter_TIME")
	          TicketCenter_TIME:setString(rewardlist[i]["rewardtime"])
	          --来源
	          local TicketCenter_source=cell:getChildByName("TicketCenter_source")
	          TicketCenter_source:setString(rewardlist[i]["activityname"]  )
	          if rewardlist[i]["activityname"]  ~=  "大转盘" then
	          	TicketCenter_source:setString("拼乐吧" )
	          end
	          --  图片
	          local TicketCenter_image=cell:getChildByName("TicketCenter_image")

	          local file=cc.FileUtils:getInstance():isFileExist(path..tostring(Util:sub_str(rewardlist[i]["activityname"], "/",":")))
	          if not  file then
	              table.insert(self.image_table,{_obj = TicketCenter_image ,name=path..tostring(Util:sub_str(rewardlist[i]["activityname"], "/",":"))})
	           else
	               TicketCenter_image:loadTexture(path..tostring(Util:sub_str(rewardlist[i]["goodsimageurl"], "/",":")))
	          end
	          --  信息确认
	          local TicketCenter_bt=cell:getChildByName("TicketCenter_bt")
	          local Image_6=TicketCenter_bt:getChildByName("Image_6"):getChildByName("Text_8")
	          TicketCenter_bt:setTag(i)
	           if win_consignee["address"] then
	           	TicketCenter_bt:setTouchEnabled(false)
	           	Image_6:setColor(cc.c3b(158, 178, 144))
	           	Image_6:setString("已确认")
	           else
	           	Image_6:setColor(cc.c3b(255, 255, 255))
	           	Image_6:setString("信息确认")
	           	TicketCenter_bt:setTouchEnabled(true)
	           end
	          TicketCenter_bt:addTouchEventListener(function(sender, eventType  )
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
		                self.win_type=2
		                self._win_img=path..tostring(Util:sub_str(rewardlist[sender:getTag()]["goodsimageurl"], "/",":"))
		                self.Theirwin = cc.CSLoader:createNode("Theirwin.csb");
			    self:addChild(self.Theirwin)
			    self.Theirwin:setTag(123)
		                Server:Instance():getconsignee()
	            end)
	           if tonumber(self.tck_data_num_tag)~=0 then
		             self.TicketCenterlist:jumpToPercentVertical(120)
	 	else
		             self.TicketCenterlist:jumpToPercentVertical(0)
		end
	           self.tck_data_num_tag=self.tck_data_num
	          self:scheduleUpdate()
	end
end

--下载图片
function TicketCenter:Theirwin_download_list(  )
         local myrewardlist=LocalData:Instance():get_getmyrewardlist()
         local  rewardlist=myrewardlist["rewardlist"]
         if #rewardlist  ==0  then
         	return
         end
         for i=1,#rewardlist do
         	local com_={}
         	com_["command"]=rewardlist[i]["goodsimageurl"]
         	com_["max_pic_idx"]=#rewardlist
         	com_["curr_pic_idx"]=i
         	com_["TAG"]="getmyrewardlist"
         	Server:Instance():request_pic(rewardlist[i]["goodsimageurl"],com_) 
         end
end
--刷新时间的定时器
function TicketCenter:update(dt)
	self.secondOne = self.secondOne+dt
	if self.secondOne <1 then return end
	self.secondOne=0
           
           --  刷新下载的图片
	if #self.image_table~=0 then
	   local next_num=0
	  for i=1,#self.image_table do
	      local file=cc.FileUtils:getInstance():isFileExist(self.image_table[i].name)
	      if file and self.image_table[i]._obj then
	          local activity_Panel=self.image_table[i]._obj
	          activity_Panel:loadTexture(self.image_table[i].name)
	          self.image_table[i]._obj=nil
	          next_num=next_num+1
	      end
	  end
	  if next_num == #self.image_table then
	     self.image_table={}
	     self:unscheduleUpdate()
	  end
	end
end
--信件确认
function TicketCenter:fun_Theirwin( _img)
	local win_consignee=LocalData:Instance():get_getconsignee()
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
	                Util:all_layer_backMusic()
	              self:removeChildByTag(123, true)
            end)
            local Theirwin_name=self.Theirwin:getChildByName("Theirwin_name")
            local Theirwin_phone=self.Theirwin:getChildByName("Theirwin_phone")
            local Theirwin_address=self.Theirwin:getChildByName("Theirwin_address")
            local Theirwin_submit=self.Theirwin:getChildByName("Theirwin_submit")
            local Theirwin_win_image=self.Theirwin:getChildByName("Theirwin_win_image")
            Theirwin_win_image:loadTexture(_img)
            Util:function_advice_keyboard(self.Theirwin,Theirwin_name,25)
            Util:function_advice_keyboard(self.Theirwin,Theirwin_phone,25)
            Util:function_advice_keyboard(self.Theirwin,Theirwin_address,25)
            if win_consignee["address"] then
            	Theirwin_address:setString(win_consignee["address"])
            end
            if win_consignee["name"] then
            	Theirwin_name:setString(win_consignee["name"])
            end
            if win_consignee["phone"] then
            	Theirwin_phone:setString(win_consignee["phone"])
            end
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
	                Util:all_layer_backMusic()
	                  if Theirwin_name:getString() == "" then
	                  Server:Instance():promptbox_box_buffer("姓名不能为空哦")   --prompt
	                  return
	                  end
	                   if Theirwin_phone:getString() == "" then
	                  Server:Instance():promptbox_box_buffer("填写的手机号不能为空哦！")   --prompt
	                  return
	                  end
	                  if tostring(Util:judgeIsAllNumber(tostring(Theirwin_phone:getString())))  ==  "false"  then
	                  Server:Instance():promptbox_box_buffer("手机号填写错误") 
	                  return
	                  end

	                  if  string.len(Theirwin_phone:getString()) < 11 then
	                  Server:Instance():promptbox_box_buffer("手机号填写错误")   --prompt
	                  return
	                  end
	                  
	                  if Theirwin_address:getString() == "" then
	                  Server:Instance():promptbox_box_buffer("地址不能为空哦！")   --prompt
	                  return
	                  end
		 
	             Server:Instance():setconsignee(Theirwin_name:getString(),Theirwin_phone:getString(),Theirwin_address:getString())
            end)
end

--完善信息
function TicketCenter:fun_PerfectInformation(  )
	local win_consignee=LocalData:Instance():get_getconsignee()
	dump(win_consignee)
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
	                Util:all_layer_backMusic()
	              self:removeChildByTag(213, true)
            end)
            local PerfectInformation_phone=PerfectInformation_BG:getChildByName("PerfectInformation_phone")
            local PerfectInformation_name=PerfectInformation_BG:getChildByName("PerfectInformation_name")
            --local PerfectInformation_city=PerfectInformation_BG:getChildByName("PerfectInformation_city")
            local PerfectInformation_address=PerfectInformation_BG:getChildByName("PerfectInformation_address")
            Util:function_advice_keyboard(PerfectInformation_BG,PerfectInformation_phone,25)
            Util:function_advice_keyboard(PerfectInformation_BG,PerfectInformation_name,25)
            --Util:function_advice_keyboard(PerfectInformation_BG,PerfectInformation_city,25)
            Util:function_advice_keyboard(PerfectInformation_BG,PerfectInformation_address,25)
            local PerfectInformation_submit=PerfectInformation_BG:getChildByName("PerfectInformation_submit")
          	if win_consignee["address"] then
            	PerfectInformation_address:setString(win_consignee["address"])
            end
            if win_consignee["name"] then
            	PerfectInformation_name:setString(win_consignee["name"])
            end
            if win_consignee["phone"] then
            	PerfectInformation_phone:setString(win_consignee["phone"])
            end
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
	                Util:all_layer_backMusic()
	                if PerfectInformation_name:getString() == "" then
	                  Server:Instance():promptbox_box_buffer("姓名不能为空哦")   --prompt
	                  return
	                  end
	                   if PerfectInformation_phone:getString() == "" then
	                  Server:Instance():promptbox_box_buffer("填写的手机号不能为空哦！")   --prompt
	                  return
	                  end
	                  if tostring(Util:judgeIsAllNumber(tostring(PerfectInformation_phone:getString())))  ==  "false"  then
	                  Server:Instance():promptbox_box_buffer("手机号填写错误") 
	                  return
	                  end

	                  if  string.len(PerfectInformation_phone:getString()) < 11 then
	                  Server:Instance():promptbox_box_buffer("手机号填写错误")   --prompt
	                  return
	                  end
	                  
	                  if PerfectInformation_address:getString() == "" then
	                  Server:Instance():promptbox_box_buffer("地址不能为空哦！")   --prompt
	                  return
	                  end
	                  Server:Instance():setconsignee(PerfectInformation_name:getString(),PerfectInformation_phone:getString(),PerfectInformation_address:getString())
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
 	
	NotificationCenter:Instance():AddObserver("getconsignee", self,
                       function()
                       	if self.win_type==1 then
                       		self:fun_PerfectInformation() 
                       	elseif self.win_type==2 then
                       		self:fun_Theirwin(self._win_img) 
                       	end
			
			         
                      end)
	   NotificationCenter:Instance():AddObserver("setconsignee_call", self,
                       function()

                         self.floating_layer:prompt_box("填写成功哦！",function (sender, eventType)      
                                                                if eventType==1    then
                                                                	if self.win_type==1 then
                                                                		self:removeChildByTag(213, true)
                                                                	elseif self.win_type==2 then
                                                                		self:removeChildByTag(123, true)
                                                                	end
                                                                end                
                                                end)    --  然并卵的提示语
                      end)
	    --  下载图片
	   NotificationCenter:Instance():AddObserver("GAME_GETMYREWARDLIST", self,
                       function()
                       			self:fun_list_data()	         
                      end)
	   --  中奖列表
	   NotificationCenter:Instance():AddObserver("getmyrewardlist", self,
                       function()
                       
			         self:Theirwin_download_list()
			         self:fun_list_data()	
                      end)

end

function TicketCenter:onExit()
      NotificationCenter:Instance():RemoveObserver("getconsignee", self)
      NotificationCenter:Instance():RemoveObserver("setconsignee_call", self)
      NotificationCenter:Instance():RemoveObserver("getmyrewardlist", self)
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