--
-- Author: peter
-- Date: 2017-01-16 13:49:38
--  成长树 
local GrowingtreeLayer = class("GrowingtreeLayer", function()
            return display.newLayer("GrowingtreeLayer")
end)
function GrowingtreeLayer:ctor()
       self:setNodeEventEnabled(true)--layer添加监听
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

    	self:fun_data()


    
end

function GrowingtreeLayer:fun_data()
	 local experience_text=self.Growingtree:getChildByTag(87)  --经验值
	 experience_text:setString("经验值")

	 local gold_text=self.Growingtree:getChildByTag(88)  --金币值
	 gold_text:setString("金币值")

	 local diamond_text=self.Growingtree:getChildByTag(89)  --钻石值
	 diamond_text:setString("钻石值")

	 local head_bt=self.Growingtree:getChildByTag(85)  --自己头像框按钮
	 head_bt:addTouchEventListener(function(sender, eventType  )
	            if eventType ~= ccui.TouchEventType.ended then
	                return
	            end 
	           print("自己头像框按钮")
	  end)

	 local head_image=self.Growingtree:getChildByTag(86)  --自己头像
	 --head_image:loadTexture("")

	 local name_text=self.Growingtree:getChildByTag(90)  --自己名字
	 name_text:setString("拼乐")

	self.PageView_head=self.GrowingtreeNode:getChildByTag(566):getChildByTag(47)
	local Panel=self.PageView_head:getChildByTag(48)
	for i=1,10 do
		local  call=Panel:clone() 
		local head_image=call:getChildByTag(50)
		head_image:loadTexture( "png/httpgame.pinlegame.comheadheadicon_" .. tostring(i) .. ".jpg")--初始化头像
		local head_bt=call:getChildByTag(49)  --  头像按钮
		head_bt:addTouchEventListener(function(sender, eventType  )
		            if eventType ~= ccui.TouchEventType.ended then
		                return
		            end 
		  end)
		local head_text=call:getChildByTag(51)  --  头像按钮
		head_text:setString("水哥")
		self.PageView_head:addPage(call)   --添加头像框

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
          elseif tag==53 then
          	  print("我的员工按钮")
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
          elseif tag==20 then
          	  print("背包")
          elseif tag==21 then
          	  print("浇水")
          elseif tag==22 then
          	 print("施肥")
          elseif tag==23 then
          	  print("收获")
         end
         self.curr_bright=sender
    
end


function GrowingtreeLayer:onEnter()
  NotificationCenter:Instance():AddObserver(G_NOTIFICATION_EVENT.FEEDBACK, self,
                       function()

                      end)


end

function GrowingtreeLayer:onExit()
      NotificationCenter:Instance():RemoveObserver(G_NOTIFICATION_EVENT.FEEDBACK, self)
     	
end


return GrowingtreeLayer



