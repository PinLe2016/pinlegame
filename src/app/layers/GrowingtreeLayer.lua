--
-- Author: peter
-- Date: 2017-01-16 13:49:38
--  成长树 
local GrowingtreeLayer = class("GrowingtreeLayer", function()
            return display.newScene("GrowingtreeLayer")
end)
function GrowingtreeLayer:ctor()
       self:setNodeEventEnabled(true)--layer添加监听
       self.floating_layer = require("app.layers.FloatingLayer").new()
       self.floating_layer:addTo(self,100000)
       self:setTouchSwallowEnabled(false)
       self:setNodeEventEnabled(true)
       self.zhi_ct=0
       self.get_seatcount=1  --  获取点击果子的信息的坑位
       self.pt_table={}
       self.list_seedstatus={"干旱","正常","成熟","收获","死亡"}  --  记住是从0 开始的
       self.zh_state={"普通种子","中级种子","高级种子","钻石种子","惊喜种子"}
       self.zh_stateimage1={"chengzhangshu-zhongzi-chu-1.png","chengzhangshu-zhongzi-zhong-1.png","chengzhangshu-zhongzi-gao-1.png","chengzhangshu-zhongzi-zuan-1.png","chengzhangshu-zhongzi-xi-1.png"}
       self.zh_stateimage2={"chengzhangshu-zhongzi-chu-2.png","chengzhangshu-zhongzi-zhong-2.png","chengzhangshu-zhongzi-gao-2.png","chengzhangshu-zhongzi-zuanshi.png","chengzhangshu-zhongzi-xi-2.png"}
       self._type=nil
       self.is_friend=false
       self:init()
       Server:Instance():gettreelist()--   成长树初始化接口
       Server:Instance():gettreefriendlist(7,1,1)--   成长树好友初始化接口  每页显示数据  页号  好友类型  Int 1我的好友，2我的员工
        self:function_touchlistener()
end
function GrowingtreeLayer:function_touchlistener( )
	local layer=cc.Layer:create()
	self:addChild(layer,500)
	 local function onTouchEnded(x,y) 
	                  print("坐标",x," ",y)
	                  self:function_touchmove(nil,x,y)
	 end
	    self.Growingtree:setTouchEnabled(true)  
	    self.Growingtree:setTouchSwallowEnabled(true)  
	    self.Growingtree:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)  
	    self.Growingtree:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event) 
	             if event.name == "began" then  
	             	print("坐标")
	               onTouchEnded(event.x,event.y)  
	             end  
	             return true  
	    end)  
end
function GrowingtreeLayer:function_touchmove( obj,x,y)
	
	if obj~=nil then
		if self._type==20 then
			local gettreelist = LocalData:Instance():get_gettreelist()
		 	for i=1,#gettreelist["list"][1]["seedlist"] do
			 	if gettreelist["list"][1]["seedlist"][1]["seedid"] and gettreelist["list"][1]["seedlist"][i]["seatcount"] == self.get_seatcount  then
			 		Server:Instance():promptbox_box_buffer("已种植了")
			 		return
			 	end
			end
			 Server:Instance():setseedplant(self.z_treeid,self.z_gameitemid,self.get_seatcount)  --  种种子
		elseif self._type==21 then  --  浇水
			 x=x+100
			 y=y-50
		elseif self._type==22 then  --  施肥
			print("没化肥")
			Server:Instance():promptbox_box_buffer("没化肥")   --prompt
			 --Server:Instance():setseedmanure(self.z_treeid,self.z_gameitemid)  --  	
		elseif self._type==23 then  --收获
			print("收获")
		end
	end
	self.zt_obj=obj
	self.zt_x=x
	self.zt_y=y
	local _obj=self.Growingtree:getChildByTag(266)
	local  move1=cc.MoveTo:create(0.5, cc.p( x,y ) )
	--目的是等待移动完动画在执行动作动画
	local function stopAction()
		if obj~=nil then  --  主要是判断是否点中果实 
			 if self._type==21 then
		    		_obj:setRotation(45)
		    		self:function_water_act(-20,50)  --  浇水动画
		    	elseif self._type==23 then
		    		self:function_harvest_act(x,y) --  收获动画
		    	end
		end
	           
    	--  加帧     
            end
            local callfunc = cc.CallFunc:create(stopAction)
            local seq=cc.Sequence:create(move1,cc.DelayTime:create(0.5))
    	_obj:runAction(seq)
    	
end

function GrowingtreeLayer:init(  )
	self.Growingtree = cc.CSLoader:createNode("Growingtree.csb");
    	self:addChild(self.Growingtree)
    	self._pt=cc.p(self.Growingtree:getChildByTag(266):getPositionX(),self.Growingtree:getChildByTag(266):getPositionY())
  
    	for i=1,8 do
    		self.pt_table[i]=self.Growingtree:getChildByTag(103+i)
    		self.Growingtree:getChildByTag(103+i):addTouchEventListener(function(sender, eventType  )
		            if eventType ~= ccui.TouchEventType.ended then
		                return
		            end 
		            self.get_seatcount=sender:getTag()-103  --  点击的是哪个坑位的果实信息
		           self:function_touchmove( sender,sender:getPositionX(),sender:getPositionY())
		           self:fun_FruitinformationNode(sender:getPositionX(),sender:getPositionY()) -- 果实信息	          
	  	
	  		if self._type==21 then  --  浇水
				local gettreelist = LocalData:Instance():get_gettreelist()
			 	for i=1,#gettreelist["list"][1]["seedlist"] do
				 	if gettreelist["list"][1]["seedlist"][1]["seedid"] and gettreelist["list"][1]["seedlist"][i]["seatcount"] == self.get_seatcount  then
				 		self.z_seedid=gettreelist["list"][1]["seedlist"][i]["seedid"]
				 		Server:Instance():setseedwater(self.z_treeid,self.z_seedid)  --  
				 		
				 	end
				end
			elseif self._type==23 then  --收获
				local gettreelist = LocalData:Instance():get_gettreelist()
			 	for i=1,#gettreelist["list"][1]["seedlist"] do
				 	if gettreelist["list"][1]["seedlist"][1]["seedid"] and gettreelist["list"][1]["seedlist"][i]["seatcount"] == self.get_seatcount  then
				 		self.z_seedid=gettreelist["list"][1]["seedlist"][i]["seedid"]
				 		Server:Instance():setseedreward(self.z_treeid,self.z_seedid)  --  
				 		
				 	end
				end
			end
			 

	  	end)	
    	end
    	self.GrowingtreeNode = self.Growingtree:getChildByTag(56)  --Node   界面
    	self.FruitinformationNode = self.Growingtree:getChildByTag(2489)  --Node  种子信息   界面
    	 local back_bt=self.Growingtree:getChildByTag(84)  --返回
	 back_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	                return
	            end 
	            if self.is_friend  then
	            	self.is_friend=false
	            	Server:Instance():gettreelist()
	            	return
	            end
	           
		Util:scene_control("MainInterfaceScene")
	  end)

	 local friend_bt=self.Growingtree:getChildByTag(19)  --好友按钮
	 friend_bt:getChildByTag(24):setBright(false)
	 friend_bt:setBright(false)
             self.curr_bright=friend_bt--记录当前高亮
	 friend_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_callback(sender, eventType)
	  end)

	 local backpack_bt=self.Growingtree:getChildByTag(20)  --背包按钮
	 backpack_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_callback(sender, eventType)
	  end)

	 local water_bt=self.Growingtree:getChildByTag(21)  --浇水按钮
	 water_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_callback(sender, eventType)
	  end)

	 local fertilization_bt=self.Growingtree:getChildByTag(22)  --施肥按钮
	 fertilization_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_callback(sender, eventType)
	  end)

	  local harvest_bt=self.Growingtree:getChildByTag(23)  --收获按钮
	 harvest_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_callback(sender, eventType)
	  end)

	  local refresh_bt=self.GrowingtreeNode:getChildByTag(45)  --刷新好友按钮
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self.GrowingtreeNode:getChildByTag(41)  --左移一格
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self.GrowingtreeNode:getChildByTag(42)  --右移一格
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self.GrowingtreeNode:getChildByTag(43)  --左移一列
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self.GrowingtreeNode:getChildByTag(44)  --右移一列
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	            self:touch_Nodecallback(sender, eventType)
	  end)

	  local refresh_bt=self.GrowingtreeNode:getChildByTag(46)  --邀请好友按钮
	 refresh_bt:addTouchEventListener(function(sender, eventType  )
	           self:touch_Nodecallback(sender, eventType)
	  end)

	  local Myfriend_bt=self.GrowingtreeNode:getChildByTag(52)  --我的好友按钮
	 Myfriend_bt:getChildByTag(54):setBright(false)
	 Myfriend_bt:setBright(false)
             self.curr_brightnode=Myfriend_bt--记录当前高亮

	 Myfriend_bt:addTouchEventListener(function(sender, eventType  )
	           self:fun_callback(sender, eventType)
	  end)

	  local Myemployees_bt=self.GrowingtreeNode:getChildByTag(53)  --我的员工按钮
	 Myemployees_bt:addTouchEventListener(function(sender, eventType  )
	           self:fun_callback(sender, eventType)
	  end)
    
end
--  种子信息界面数据
function GrowingtreeLayer:fun_FruitinformationNode( _x , _y)
	local gettreelist = LocalData:Instance():get_gettreelist()
 	for i=1,#gettreelist["list"][1]["seedlist"] do
	 	if gettreelist["list"][1]["seedlist"][1]["seedid"]  and  gettreelist["list"][1]["seedlist"][i]["seatcount"] ==  self.get_seatcount  then
		 	local fruitinformation_bg=self.FruitinformationNode:getChildByTag(2424)
		 	self._fruitinformation_bg=fruitinformation_bg
		 	self._fruitinformation_bg:setPosition(cc.p(_x+100,_y))
			local seed=fruitinformation_bg:getChildByTag(2425)
			for j=1,5 do
				if tostring(gettreelist["list"][1]["seedlist"][i]["seedname"]) == self.zh_state[j] then
					seed:loadTexture("png/" .. self.zh_stateimage1[j])
				end
			end
			local seedstatus_3=fruitinformation_bg:getChildByTag(2428) -- 种子状态水滴1
			local seedstatus_2=fruitinformation_bg:getChildByTag(2427) -- 种子状态水滴2
			
			local seedname=fruitinformation_bg:getChildByTag(2431) -- 种子名称
			seedname:setString(gettreelist["list"][1]["seedlist"][i]["seedname"])
			local seedstatus=fruitinformation_bg:getChildByTag(2432) -- 种子状态
			for j=1,5 do
				if tostring(gettreelist["list"][1]["seedlist"][i]["seedstatus"]) == tostring(j-1) then
					seedstatus:setString(self.list_seedstatus[j])
					if j==1 then  --  干旱时候出现缺水状态
						seedstatus_3:loadTexture("png/chengzhangshu-shuidi-xiao-1.png")
						seedstatus_2:loadTexture("png/chengzhangshu-shuidi-xiao-1.png")
					end
				end
			end
			local gaintime=fruitinformation_bg:getChildByTag(2434)  --  结果时间
			print("·ddd··",gettreelist["list"][1]["seedlist"][i]["drytime"])
			local str_time=Util:FormatTime_colon(gettreelist["list"][1]["seedlist"][i]["drytime"])
			gaintime:setString(tostring(str_time[1]))
			local gaintime_loadingBar=fruitinformation_bg:getChildByTag(2429)  --   结果时间进度条
			gaintime_loadingBar:setPercent(10)
	 	end
	 end

	
end
function GrowingtreeLayer:fun_data()
	if self.is_friend  then
	        	self.GrowingtreeNode:setVisible(false)
	        	self.Growingtree:getChildByTag(19):setVisible(false)
      		self.Growingtree:getChildByTag(20):setVisible(false)
	else
		self.GrowingtreeNode:setVisible(true)
		self.Growingtree:getChildByTag(19):setVisible(true)
      		self.Growingtree:getChildByTag(20):setVisible(true)
	end
	 local gettreelist = LocalData:Instance():get_gettreelist()
	  self.z_treeid=gettreelist["list"][1]["treeid"]
	 local experience_text=self.Growingtree:getChildByTag(87)  --经验值
	 experience_text:setString(gettreelist["treeExp"])
	 dump(gettreelist["list"][1]["seedlist"])
	 if #gettreelist["list"][1]["seedlist"] ~=  0 then
	 	for i=1,#gettreelist["list"][1]["seedlist"] do
		 	if gettreelist["list"][1]["seedlist"][1]["seedid"]  then
				 for j=1,5 do
				 	if gettreelist["list"][1]["seedlist"][i]["seedname"] ==  self.zh_state[j] then
				 		if gettreelist["list"][1]["seedlist"][i]["seedstatus"] ~=  3  then
					 		self.pt_table[gettreelist["list"][1]["seedlist"][i]["seatcount"]]:loadTexture("png/" ..  self.zh_stateimage1[j])  
					 	else
					 		self.pt_table[gettreelist["list"][1]["seedlist"][i]["seatcount"]]:loadTexture("png/" ..  self.zh_stateimage2[j])  --成熟状态图片
					 	end
				 	end
				 	self.z_seedid=gettreelist["list"][1]["seedlist"][1]["seedid"]
				 end
		 	end
		 end
	 end
	 
	 if #gettreelist["list"][1]["seedlist"] ~=  0  then
	 	local zt = self.pt_table[gettreelist["list"][1]["seedlist"][1]["seatcount"]]
	 	self:fun_FruitinformationNode(zt:getPositionX(),zt:getPositionY()) --  果实状态信息界面
	 end
	 
	 local gold_text=self.Growingtree:getChildByTag(88)  --金币值
	 gold_text:setString(gettreelist["golds"])

	 local diamond_text=self.Growingtree:getChildByTag(89)  --钻石值
	 diamond_text:setString(gettreelist["diamondnum"])

	 local head_bt=self.Growingtree:getChildByTag(85)  --自己头像框按钮
	 head_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	                return
	            end 
	           print("自己头像框按钮")
	  end)

	 local head_image=self.Growingtree:getChildByTag(86)  --自己头像
	 print("头像  ",tostring(Util:sub_str(gettreelist["imageUrl"], "/",":")))
	 head_image:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(gettreelist["imageUrl"], "/",":"))))

	 local name_text=self.Growingtree:getChildByTag(90)  --自己名字
	 name_text:setString(gettreelist["nickname"])
end
--  我的员工是否显示
function GrowingtreeLayer:function_friendIsvisible(Isvisible)
	local bg=self.GrowingtreeNode:getChildByTag(32):getChildByTag(37)
	bg:setVisible(Isvisible)
	local friend_bg=self.GrowingtreeNode:getChildByTag(52)
	friend_bg:setVisible(Isvisible)
	local employees_bg=self.GrowingtreeNode:getChildByTag(53)
	employees_bg:setVisible(Isvisible)

end
--  好友列表
function GrowingtreeLayer:function_friend( )
            local gettreefriendlist=LocalData:Instance():get_gettreefriendlist()
            local _list=gettreefriendlist["list"]
	self.PageView_head=self.GrowingtreeNode:getChildByTag(566):getChildByTag(47)
	local Panel=self.PageView_head:getChildByTag(48)

	local head_image=Panel:getChildByTag(50)
	head_image:loadTexture("png/" ..  "chengzhangshu-di-1-haoyou-1.png")--初始化头像
	local head_bt=Panel:getChildByTag(49)  --  头像按钮
	head_image:setScale(0.53)
	head_bt:addTouchEventListener(function(sender, eventType  )
		
	            if eventType ~= ccui.TouchEventType.ended then
	                return
	            end 
	           
	          
	  end)
	local head_text=Panel:getChildByTag(51)  --  头像按钮
	head_text:setString("拼乐")
	self.PageView_head:addPage(Panel)   --添加头像框
	
	local friend_lv=Panel:getChildByTag(77)  --  等级
	friend_lv:setString("LV " .. tostring(0) )


	 for i=2,#self.PageView_head:getPages() do 
		self.PageView_head:removePageAtIndex(1)   --  删除view  里面的样图
	end
	 if #_list   ==  0  then
	 	print("好友个数",#_list)
                    --Panel:setVisible(false)
                       for i=1,7 do
			local  call=Panel:clone() 
			self.PageView_head:addPage(call)
		end

                    return
            end
           
	for i=1,#_list  do
		local  call=Panel:clone() 
		local head_image=call:getChildByTag(50)
		head_image:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(_list[i]["imageUrl"], "/",":"))))--初始化头像
		local head_bt=call:getChildByTag(49)  --  头像按钮
		head_image:setScale(0.53)
		head_bt:getChildByName("Image_34"):setTag(i)
		head_bt:addTouchEventListener(function(sender, eventType  )
		            if eventType ~= ccui.TouchEventType.ended then
		                return
		            end 
		           self.is_friend=true
		           Server:Instance():gettreelist(_list[sender:getChildByName("Image_34"):getTag()]["playerid"])
		            -- if eventType == ccui.TouchEventType.began then
		            -- 	print("开始")
		            -- 	sender:setTouchEnabled(true)
		            -- elseif eventType == ccui.TouchEventType.moved then
		            --   	print("移动")
		            --   	-- eventType=cui.TouchEventType.ended
		            --   	-- --sender:setTouchEnabled(false)
		            -- elseif eventType == ccui.TouchEventType.ended then
		            -- 	print("结束")
		            -- 	sender:setTouchEnabled(true)
		            -- end 
		  end)
		local head_text=call:getChildByTag(51)  --  头像按钮
		head_text:setString(_list[i]["nickname"])
		self.PageView_head:addPage(call)   --添加头像框
		if tonumber(_list[i]["flag"])  ==  0  then   -- 0好友  1自己
			print("好友YES")
		else
			print("自己")		
		end
		local friend_lv=call:getChildByTag(77)  --  等级
		friend_lv:setString("LV " .. tostring(_list[i]["playergrade"]) )

            end
            --  默认机器好友
            if #_list < 7  then
	            for i=1,7- #_list do
			local  call=Panel:clone() 
			self.PageView_head:addPage(call)
		end
            end
            self.PageView_head:removePage(Panel)  --删除样图
end
--  背包列表
function GrowingtreeLayer:function_backpack( )
            local gettreegameitemlist=LocalData:Instance():get_gettreegameitemlist()
            local _list=gettreegameitemlist["list"]
	self.PageView_head=self.GrowingtreeNode:getChildByTag(566):getChildByTag(47)
	local Panel=self.PageView_head:getChildByTag(48)
	for i=2,#self.PageView_head:getPages() do 
		self.PageView_head:removePageAtIndex(1)   --  删除view  里面的样图
	end

	local head_image=Panel:getChildByTag(50)
	head_image:loadTexture("png/" ..  "chengzhangshu-di-1-haoyou-1.png")--初始化头像
	local head_bt=Panel:getChildByTag(49)  --  头像按钮
	head_image:setScale(0.53)
	

	head_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	                return
	            end 
	            
	  end)
	local head_text=Panel:getChildByTag(51)  --  头像按钮
	head_text:setString("拼乐")
	self.PageView_head:addPage(Panel)   --添加头像框
	
	local friend_lv=Panel:getChildByTag(77)  --  等级
	friend_lv:setString("LV " .. tostring(0) )

	 if #_list   ==  0  then
	 	print("背包个数",#_list)
                    --Panel:setVisible(false)
                       for i=1,7 do
			local  call=Panel:clone() 
			self.PageView_head:addPage(call)
		end

                    return
            end
            Panel:setVisible(true)
	for i=1,#_list  do
		local  call=Panel:clone() 
		local head_image=call:getChildByTag(50)
		--head_image:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(_list[i]["imageUrl"], "/",":"))))--初始化头像

		for j=1,5 do
			if tostring(_list[i]["name"]) == self.zh_state[j] then
				head_image:loadTexture("png/" .. self.zh_stateimage1[j])
			end
		end
		
		local head_bt=call:getChildByTag(49)  --  头像按钮
		head_bt:getChildByName("Image_44"):setTag(i)
		head_bt:addTouchEventListener(function(sender, eventType  )
		            if eventType ~= ccui.TouchEventType.ended then
		                return
		            end 
          	  		self.Growingtree:getChildByTag(266):setVisible(true)
			for j=1,5 do
				if tostring(_list[sender:getChildByName("Image_44"):getTag()]["name"])  == self.zh_state[j] then
					self.Growingtree:getChildByTag(266):loadTexture("png/" .. self.zh_stateimage1[j])
					self.zhi_ct=j
				end
			end
		            local _gettreegameitemlist=LocalData:Instance():get_gettreegameitemlist()
		            local gettreelist = LocalData:Instance():get_gettreelist()

		            self.z_gameitemid=_gettreegameitemlist["list"][sender:getChildByName("Image_44"):getTag()]["gameitemid"]
		            self.z_treeid=gettreelist["list"][1]["treeid"]  --  目前一棵树  零时写死
		            self.Growingtree:getChildByTag(266):setPosition(cc.p(self._pt.x,self._pt.y))


		  end)
		local head_text=call:getChildByTag(51)  --  头像按钮
		head_text:setString(_list[i]["name"])
		self.PageView_head:addPage(call)   --添加头像框
		local friend_lv=call:getChildByTag(77)  --  等级
		friend_lv:setString(tostring(_list[i]["count"]) )

            end
            --  默认机器好友
            if #_list < 7  then
	            for i=1,7- #_list do
			local  call=Panel:clone() 
			self.PageView_head:addPage(call)
		end
            end
            self.PageView_head:removePage(Panel)  --删除样图
end
function GrowingtreeLayer:touch_Nodecallback( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
           end 
          local tag=sender:getTag() 
       
          if tag==41 then   
          	 print("左移一格")
          	 self.PageView_head:scrollToPage(self.PageView_head:getCurPageIndex()+1)
          elseif tag==42 then
          	  print("右移一格")
          	  self.PageView_head:scrollToPage(self.PageView_head:getCurPageIndex()-1)
          elseif tag==43 then
          	  print("左移一列")
          	  self.PageView_head:scrollToPage(self.PageView_head:getCurPageIndex()+7)
          elseif tag==44 then
          	  print("右移一列")
          	  self.PageView_head:scrollToPage(self.PageView_head:getCurPageIndex()-7)
          elseif tag==45 then
          	  print("刷新好友按钮")
          elseif tag==46 then
          	  print("邀请好友按钮")
          end
 end 
 function GrowingtreeLayer:fun_callback( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
           end 
          local tag=sender:getTag() 
          if self.curr_brightnode:getTag()==tag then
              return
          end
          self.curr_brightnode:setBright(true)
          self.curr_brightnode:getChildByTag(self.curr_brightnode:getTag()+2):setBright(true)
          sender:setBright(false)
          sender:getChildByTag(sender:getTag()+2):setBright(false)
          if tag==52 then   
          	 print("我的好友按钮")
          	 Server:Instance():gettreefriendlist(7,1,1)--   成长树好友初始化接口  每页显示数据  页号  好友类型  Int 1我的好友，2我的员工
          elseif tag==53 then
          	  print("我的员工按钮")
          	  Server:Instance():gettreefriendlist(7,1,2)--   成长树好友初始化接口  每页显示数据  页号  好友类型  Int 1我的好友，2我的员工
         end
         self.curr_brightnode=sender
    
end
function GrowingtreeLayer:touch_callback( sender, eventType )
          if eventType ~= ccui.TouchEventType.ended then
                return
           end 
          local tag=sender:getTag() 
          if self.curr_bright:getTag()==tag then
              return
          end
          self.curr_bright:setBright(true)
          self.curr_bright:getChildByTag(self.curr_bright:getTag()+5):setBright(true)
          sender:setBright(false)
          sender:getChildByTag(sender:getTag()+5):setBright(false)
          if tag==19 then   
          	 print("好友")
          	 self._type=19
          	 Server:Instance():gettreefriendlist(7,1,1)
          	 self.Growingtree:getChildByTag(266):setVisible(false)
          	 self:function_friendIsvisible(true)
          elseif tag==20 then
          	  print("背包")
          	  self._type=20
          	  self:function_friendIsvisible(false)
          	  self.Growingtree:getChildByTag(266):setVisible(false)
          	  Server:Instance():gettreegameitemlist(3 )  --1化肥 2种子 3化肥和种子
          	  self.Growingtree:getChildByTag(266):setPosition(cc.p(self._pt.x,self._pt.y))
          elseif tag==21 then
          	  print("浇水")
          	  self._type=21
          	  self.Growingtree:getChildByTag(266):loadTexture("png/chengzhangshu-shuihu.png")
          	  self.Growingtree:getChildByTag(266):setPosition(cc.p(self._pt.x,self._pt.y))
          	  self.Growingtree:getChildByTag(266):setVisible(true)
          	  self:function_friendIsvisible(false)
          	  self.Growingtree:getChildByTag(266):setRotation(90)
          elseif tag==22 then
          	 print("施肥")
          	 self._type=22
          	 --self.Growingtree:getChildByTag(266):loadTexture("png/chengzhangshu-huafei-chuji.png")
          	  self.Growingtree:getChildByTag(266):setPosition(cc.p(self._pt.x,self._pt.y))
          	  --self.Growingtree:getChildByTag(266):setVisible(true)
          	 self:function_friendIsvisible(false)
          	 self.Growingtree:getChildByTag(266):setRotation(90)
          	 Server:Instance():gettreegameitemlist(1)   --  1 是化肥 2   是种子  3  是化肥和种子
          elseif tag==23 then
          	  print("收获")
          	  self._type=23
          	   self.Growingtree:getChildByTag(266):setPosition(cc.p(self._pt.x,self._pt.y))
          	  self.Growingtree:getChildByTag(266):loadTexture("png/chengzhangshu-shou-1.png")
          	  self.Growingtree:getChildByTag(266):setVisible(true)
          	  self.Growingtree:getChildByTag(266):setRotation(0)
          	  self:function_friendIsvisible(false)
         end
         self.curr_bright=sender
    
end
--浇水动画 
function GrowingtreeLayer:function_water_act( x,y )
	local animation = cc.Animation:create()
	local name
	for i=1,5 do
		name = "png/chengzhangshu-shuihu-shuidi-"..i..".png"
		animation:addSpriteFrameWithFile(name)
	end
	animation:setDelayPerUnit(0.2)
	animation:setRestoreOriginalFrame(true)
	--创建动作
	local animate = cc.Animate:create(animation)
	local spr=display.newSprite()
	spr:setPosition(cc.p(x,y))
	self.Growingtree:getChildByTag(266):addChild(spr)  --  直接在水壶上上面
	
	 local function stopAction()
	                  self.Growingtree:getChildByTag(266):setRotation(90)   
               end
              local callfunc = cc.CallFunc:create(stopAction)
              local seq=cc.Sequence:create(cc.Repeat:create(animate,3),cc.DelayTime:create(0.8),callfunc)
	spr:stopAllActions()
	spr:runAction(seq)--(animate)

end
--  收获手指动画
function GrowingtreeLayer:function_harvest_act( x,y )
	local animation = cc.Animation:create()
	local name
	for i=1,2 do
		name = "png/chengzhangshu-shou-"..i..".png"
		animation:addSpriteFrameWithFile(name)
	end
	animation:setDelayPerUnit(0.5)
	animation:setRestoreOriginalFrame(true)
	--创建动作
	local animate = cc.Animate:create(animation)
	self.spr=display.newSprite()
	self.spr:setPosition(cc.p(x,y))
	self.Growingtree:getChildByTag(266):setVisible(false)  -- 开始影藏原图
	--self.Growingtree:getChildByTag(266):addChild(self.spr)  --  直接在手指上上面
	self.Growingtree:addChild(self.spr)  --  直接在手指上上面
	   local function stopAction()
	                  self.Growingtree:getChildByTag(266):setVisible(true)     
               end
              local callfunc = cc.CallFunc:create(stopAction)
              local seq=cc.Sequence:create(cc.Repeat:create(animate,3),cc.DelayTime:create(1.5),callfunc)
	self.spr:stopAllActions()
	self.spr:runAction(seq)--(animate)

end
function GrowingtreeLayer:onEnter()
 --  成长树消息
  NotificationCenter:Instance():AddObserver("MESSAGE_GETTREELIST", self,
                       function()
                       	self:fun_data()  --  自己数据

                      end)
  --  成长树好友消息
  NotificationCenter:Instance():AddObserver("MESSAGE_GETTREEFRIENDLIST", self,
                       function()
                       	self:function_friend()  --  好友数据

                      end)
    --  成长树背包消息
  NotificationCenter:Instance():AddObserver("MESSAGE_GSTTREEGAMEITEMLIST", self,
                       function()
                       	self:function_backpack()  --  背包数据

                      end)
  --  种种子消息
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDPLANT", self,
                       function()
                       	
		self.pt_table[self.get_seatcount]:loadTexture("png/" ..  self.zh_stateimage1[self.zhi_ct])  --  坑位变种子
		self.Growingtree:getChildByTag(266):setVisible(false)  --  样图种子消失 
                      end)
  --  浇水消息
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDWATER", self,
                       function()
                       	print("浇水返回的消息")
			if self.zt_obj~=nil then  --  主要是判断是否点中果实 
					_obj:setRotation(45)
					self:function_water_act(-20,50)  --  浇水动画
			end
                      end)
  --  收获消息
  NotificationCenter:Instance():AddObserver("MESSAGE_SETSEEDREWARD", self,
                       function()
                       	print("收获返回的消息")
			if self.zt_obj~=nil then  --  主要是判断是否点中果实 
				
				self:function_harvest_act(self.zt_x,self.zt_y) --  收获动画
				
			end
                      end)


end
function GrowingtreeLayer:pushFloating(text)
   if is_resource then
       self.floating_layer:showFloat(text)  
   else
       self.floating_layer:showFloat(text) 
   end
end 

function GrowingtreeLayer:push_buffer(is_buffer)
       self.floating_layer:show_http(is_buffer) 
end 
function GrowingtreeLayer:networkbox_buffer(prompt_text)
       self.floating_layer:network_box(prompt_text) 
end 
function GrowingtreeLayer:promptbox_buffer(prompt_text)
       self.floating_layer:prompt_box(prompt_text) 
end

function GrowingtreeLayer:onExit()
      NotificationCenter:Instance():RemoveObserver("MESSAGE_GETTREELIST", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_GETTREEFRIENDLIST", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_GSTTREEGAMEITEMLIST", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDPLANT", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDWATER", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_SETSEEDREWARD", self)
     	
end


return GrowingtreeLayer



