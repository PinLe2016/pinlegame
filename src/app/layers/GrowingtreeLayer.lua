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
       self.pt_table={}
       self._type=nil
       self.is_friend=false
       Server:Instance():gettreelist()--   成长树初始化接口
       Server:Instance():gettreefriendlist(7,1,1)--   成长树好友初始化接口  每页显示数据  页号  好友类型  Int 1我的好友，2我的员工
       -- 
      
       self:init()
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
			 Server:Instance():setseedplant(self.z_treeid,self.z_gameitemid)  --  种种子
		elseif self._type==21 then  --  浇水
			 Server:Instance():setseedwater(self.z_treeid,self.z_seedid)  --  
		elseif self._type==22 then  --  施肥
			print("没化肥")
			Server:Instance():promptbox_box_buffer("没化肥")   --prompt
			 --Server:Instance():setseedmanure(self.z_treeid,self.z_gameitemid)  --  	
		elseif self._type==23 then  --收获
			 Server:Instance():setseedreward(self.z_treeid,self.z_seedid)  --  
		end
		
	end
	local _obj=self.Growingtree:getChildByTag(266)
	local  move1=cc.MoveTo:create(0.5, cc.p( x,y ) )
    	_obj:runAction(move1)
    	--  加帧
end
function GrowingtreeLayer:init(  )
	self.Growingtree = cc.CSLoader:createNode("Growingtree.csb");
    	self:addChild(self.Growingtree)

	


    	self._pt=cc.p(self.Growingtree:getChildByTag(266):getPositionX(),self.Growingtree:getChildByTag(266):getPositionY())
  
    	for i=1,10 do
    		self.pt_table[i]=self.Growingtree:getChildByTag(103+i)
    		self.Growingtree:getChildByTag(103+i):addTouchEventListener(function(sender, eventType  )
		            if eventType ~= ccui.TouchEventType.ended then
		                return
		            end 
		           self:function_touchmove( sender,sender:getPositionX(),sender:getPositionY())
	  end)
    		
    	end

    	
    	self.GrowingtreeNode = self.Growingtree:getChildByTag(56)  --Node   界面
    	
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
	 dump(gettreelist ["list"][1]["seedlist"])
	 if gettreelist["list"][1]["seedlist"][1]["seedid"] then
	 	self.Growingtree:getChildByTag(104):loadTexture("png/bigwheelzhuanpandi-zi.png")
	 	self.z_seedid=gettreelist["list"][1]["seedlist"][1]["seedid"]

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
                    Panel:setVisible(false)
                    return
            end
            Panel:setVisible(true)
	for i=1,#_list  do
		local  call=Panel:clone() 
		local head_image=call:getChildByTag(50)
		--head_image:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(_list[i]["imageUrl"], "/",":"))))--初始化头像
		head_image:loadTexture("png/" ..  "chengzhangshu-huafei-chuji.png")
		local head_bt=call:getChildByTag(49)  --  头像按钮
		head_bt:getChildByName("Image_44"):setTag(i)
		head_bt:addTouchEventListener(function(sender, eventType  )
		            if eventType ~= ccui.TouchEventType.ended then
		                return
		            end 

		            self.Growingtree:getChildByTag(266):loadTexture("png/dadishu-02-bantou-di-zuoshang.png")
          	  		self.Growingtree:getChildByTag(266):setVisible(true)

		            local _gettreegameitemlist=LocalData:Instance():get_gettreegameitemlist()
		            local gettreelist = LocalData:Instance():get_gettreelist()

		            self.z_gameitemid=_gettreegameitemlist["list"][sender:getChildByName("Image_44"):getTag()]["gameitemid"]
		            self.z_treeid=gettreelist["list"][1]["treeid"]  --  目前一棵树  零时写死
		                print("交罚款绝对是",self.z_gameitemid)


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
          	 Server:Instance():gettreefriendlist(7,1,1)
          	 self.Growingtree:getChildByTag(266):setVisible(false)
          	 self:function_friendIsvisible(true)
          elseif tag==20 then
          	  print("背包")
          	  self._type=20
          	  self:function_friendIsvisible(false)
          	  self.Growingtree:getChildByTag(266):setVisible(false)
          	  Server:Instance():gettreegameitemlist(3 )  --1化肥 2种子 3化肥和种子
          elseif tag==21 then
          	  print("浇水")
          	  self._type=21
          	  dump(self._pt)
          	  self.Growingtree:getChildByTag(266):setPosition(cc.p(self._pt.x,self._pt.y))
          	  self.Growingtree:getChildByTag(266):setVisible(true)
          	  self:function_friendIsvisible(false)
          elseif tag==22 then
          	 print("施肥")
          	 self._type=22
          	 self.Growingtree:getChildByTag(266):loadTexture("png/chengzhangshu-huafei-chuji.png")
          	  self.Growingtree:getChildByTag(266):setPosition(cc.p(self._pt.x,self._pt.y))
          	 self:function_friendIsvisible(false)
          elseif tag==23 then
          	  print("收获")
          	  self._type=23
          	   self.Growingtree:getChildByTag(266):setPosition(cc.p(self._pt.x,self._pt.y))
          	  self.Growingtree:getChildByTag(266):loadTexture("png/dadishu-02-bantou-di-zuoshang.png")
          	  self:function_friendIsvisible(false)
         end
         self.curr_bright=sender
    
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
     	
end


return GrowingtreeLayer



