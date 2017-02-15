--
-- Author: peter
-- Date: 2017-01-16 13:49:38
--  成长树 
local GrowingtreeLayer = class("GrowingtreeLayer", function()
            return display.newLayer("GrowingtreeLayer")
end)
function GrowingtreeLayer:ctor()
       self:setNodeEventEnabled(true)--layer添加监听
       Server:Instance():gettreelist()--   成长树初始化接口
       Server:Instance():gettreefriendlist(7,1,1)--   成长树好友初始化接口  每页显示数据  页号  好友类型  Int 1我的好友，2我的员工
       self:init()
end
function GrowingtreeLayer:init(  )
	self.Growingtree = cc.CSLoader:createNode("Growingtree.csb");
    	self:addChild(self.Growingtree)
    	self.GrowingtreeNode = self.Growingtree:getChildByTag(56)  --Node   界面
    	
    	 local back_bt=self.Growingtree:getChildByTag(84)  --返回
	 back_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	                return
	            end 
	           self:removeFromParent()
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
	 local gettreelist = LocalData:Instance():get_gettreelist()
	 local experience_text=self.Growingtree:getChildByTag(87)  --经验值
	 experience_text:setString(gettreelist["treeExp"])

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
	 if #_list   ==  0  then
	 	print("好友个数",#_list)
                    Panel:setVisible(false)
                    return
            end
            Panel:setVisible(true)
	for i=1,#_list  do
		local  call=Panel:clone() 
		local head_image=call:getChildByTag(50)
		head_image:loadTexture("png/" ..  string.lower(tostring(Util:sub_str(_list[i]["imageUrl"], "/",":"))))--初始化头像
		local head_bt=call:getChildByTag(49)  --  头像按钮
		head_bt:addTouchEventListener(function(sender, eventType  )
		            if eventType ~= ccui.TouchEventType.ended then
		                return
		            end 
		  end)
		local head_text=call:getChildByTag(51)  --  头像按钮
		head_text:setString(_list[i]["nickname"])
		self.PageView_head:addPage(call)   --添加头像框
		if tonumber(_list[i]["flag"])  ==  0  then   -- 0好友  1自己
			print("好友")
		else
			print("自己")		
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
          	 self:function_friendIsvisible(true)
          elseif tag==20 then
          	  print("背包")
          	  self:function_friendIsvisible(false)
          	  Server:Instance():gettreegameitemlist(1)  --1化肥 2种子 3化肥和种子
          elseif tag==21 then
          	  print("浇水")
          	  self:function_friendIsvisible(false)
          elseif tag==22 then
          	 print("施肥")
          	 self:function_friendIsvisible(false)
          elseif tag==23 then
          	  print("收获")
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


end

function GrowingtreeLayer:onExit()
      NotificationCenter:Instance():RemoveObserver("MESSAGE_GETTREELIST", self)
      NotificationCenter:Instance():RemoveObserver("MESSAGE_GETTREEFRIENDLIST", self)
     	
end


return GrowingtreeLayer



